import XCTest
@testable import Erebine
import Foundation

final class Fixture {
    let process = Process()
    let file = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString + ".port")
    let origin: URL
    init() throws {
        process.executableURL = URL(fileURLWithPath: "/usr/bin/env")
        process.arguments = ["python3", Bundle.module.url(forResource: "http_fixture", withExtension: "py")!.path, "--port-file", file.path]
        try process.run()
        var port: Int?
        for _ in 0..<1000 {
            if let text = try? String(contentsOf: file, encoding: .utf8), let p = Int(text) { port = p; break }
            Thread.sleep(forTimeInterval: 0.01)
        }
        guard let port else { process.terminate(); throw ErebineError.invalid("Fixture failed to start") }
        origin = URL(string: "http://127.0.0.1:\(port)")!
    }
    deinit { process.terminate(); try? FileManager.default.removeItem(at: file) }
    func client() throws -> Client { try Client(origin: origin, apiKey: "fake-fixture-key", projectID: "proj_test", routing: .endpoint("test")) }
}
final class TransportTests: XCTestCase {
    func testJSONQueryAndMetadata() async throws {
        let f = try Fixture(); let c = try f.client()
        let payload: JSONValue = ["model": "test", "x_vendor": ["enabled": true]]
        let options = try RequestOptions.json(payload, parameters: ["id": "a/b?#% 🌎"], query: [.init(name: "tag", value: "a+b"), .init(name: "tag", value: "two")], headers: ["X-Conversation-Id": "stable"])
        let r = try await c.send(method: "POST", path: "/echo/{id}", options: options)
        XCTAssertEqual(r.requestID, "fixture-request")
        let v = try r.json(); XCTAssertEqual(v["method"]?.string, "POST")
        XCTAssertTrue(v["path"]!.string!.hasPrefix("/echo/a%2Fb%3F%23%25%20%F0%9F%8C%8E?tag=a%2Bb&tag=two"))
        let body = try JSONDecoder().decode(JSONValue.self, from: Data(v["body"]!.string!.utf8))
        XCTAssertEqual(body["x_vendor"]?["enabled"], .bool(true))
    }
    func testErrorsEmptyBinaryAndRedirects() async throws {
        let f = try Fixture(); let c = try f.client()
        do { _ = try await c.send(method: "GET", path: "/error"); XCTFail("expected error") }
        catch let e as ErebineError {
            XCTAssertEqual(e.requestID, "fixture-request"); XCTAssertEqual(e.retryAfter, "3")
            XCTAssertEqual(e.apiBody?["error"]?["type"]?.string, "future_vendor_error")
        }
        let empty = try await c.send(method: "DELETE", path: "/empty"); XCTAssertEqual(empty.status, 204); XCTAssertTrue(empty.body.isEmpty)
        let binary = try await c.send(method: "GET", path: "/binary"); XCTAssertEqual(binary.body, Data([0,255,10,128]))
        do { _ = try await c.send(method: "GET", path: "/redirect"); XCTFail("redirect followed") }
        catch ErebineError.api(let status, _, _) { XCTAssertEqual(status, 302) }
    }
    func testMultipartAndBinaryUpload() async throws {
        let f = try Fixture(); let c = try f.client(); var form = Multipart()
        try form.field("purpose", value: "batch")
        try form.file("file", filename: "batch.jsonl", contentType: "application/jsonl", bytes: Data("abc\n".utf8))
        let r = try await c.send(method: "POST", path: "/echo", options: form.options())
        XCTAssertTrue(try r.json()["body"]!.string!.contains("filename=\"batch.jsonl\""))
        XCTAssertThrowsError(try form.field("bad\r\nHeader", value: "x"))
        let raw = try await c.send(method: "POST", path: "/echo", options: .init(headers: ["X-Chunk-Checksum":"fake-sha256"], body: Data("raw".utf8), contentType: "application/octet-stream"))
        XCTAssertEqual(try raw.json()["body"]?.string, "raw")
    }
    func testStreaming() async throws {
        let f = try Fixture(); let c = try f.client()
        let op = Operation(name: "fixture", method: "GET", path: "/stream", surface: .router)
        let stream = try await c.stream(op); XCTAssertEqual(stream.headers["x-request-id"], "fixture-stream")
        var events: [ServerEvent] = []
        for try await event in stream { events.append(event) }
        XCTAssertEqual(events.count, 2); XCTAssertEqual(events[0].event, "x_reasoning")
        XCTAssertEqual(try events[0].json()["text"]?.string, "héllo 🌎")
        XCTAssertEqual(events[1].event, "response.completed")
    }
    func testAllOperationsAndSafeURLs() throws {
        let router = try Client(); let dashboard = try Client(origin: URL(string: "https://erebine.ai")!, surface: .dashboard)
        for op in Operations.all {
            var params: [String: String] = [:]
            for p in op.path.split(separator: "/") where p.hasPrefix("{") { params[String(p.dropFirst().dropLast())] = "test" }
            XCTAssertNoThrow(try (op.surface == .router ? router : dashboard).prepare(op, options: .init(parameters: params)), op.name)
        }
        XCTAssertThrowsError(try router.prepare(method: "GET", path: "//evil.example/path"))
        XCTAssertThrowsError(try router.prepare(method: "GET", path: "/a/{id}", options: .init(parameters: ["id":".."])))
        XCTAssertThrowsError(try router.prepare(method: "GET", path: "/a/{relative_path}", options: .init(parameters: ["relative_path":"../secret"])))
        XCTAssertThrowsError(try router.prepare(Operations.chatCompletionsCreate))
        XCTAssertThrowsError(try router.prepare(Operations.all.first(where: {$0.surface == .dashboard})!))
        XCTAssertThrowsError(try Client(headers: ["Bad Header":"value"]))
    }
    func testRoutingAndCustomDomain() throws {
        let direct = try Client(projectID: "proj", routing: .direct(workspace: "ws"))
        XCTAssertEqual(try direct.prepare(Operations.chatCompletionsCreate).url?.path, "/proj/ws/_direct/v1/chat/completions")
        let semantic = try Client(projectID: "proj", routing: .semantic(workspace: "ws"), customDomain: true)
        XCTAssertEqual(try semantic.prepare(Operations.responsesCreate).url?.path, "/ws/_semantic/router/v1/responses")
    }
    func testSSEEveryByteBoundary() throws {
        var d = SSEDecoder(); var events: [ServerEvent] = []
        let input = "\u{feff}: heartbeat\r\nid: 7\r\nevent: x_reasoning\r\nretry: 123\r\ndata: héllo\r\ndata: 🌎\r\n\r\ndata: next\n\n"
        for b in input.utf8 { events += try d.push([b]) }
        XCTAssertEqual(events.count, 2); XCTAssertEqual(events[0].data, "héllo\n🌎"); XCTAssertEqual(events[0].retry, 123); XCTAssertEqual(events[1].id, "7")
        XCTAssertThrowsError(try d.push([255,10]))
        var incomplete = SSEDecoder(); XCTAssertTrue(try incomplete.push(Array("data: unfinished".utf8)).isEmpty); incomplete.finish()
    }
    func testJSONPreservesLargeIntegersAndUnknownFields() throws {
        let input = Data("{\"id\":18446744073709551615,\"x_vendor\":{\"future\":true}}".utf8)
        let value = try JSONDecoder().decode(JSONValue.self, from: input)
        XCTAssertEqual(value["id"], .unsignedInteger(UInt64.max))
        XCTAssertEqual(try JSONDecoder().decode(JSONValue.self, from: JSONEncoder().encode(value)), value)
    }
}
