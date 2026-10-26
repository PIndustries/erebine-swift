import XCTest
@testable import Erebine
import Foundation

final class SurfaceTests: XCTestCase {
    func testEveryCatalogBindingCrossesNativeTransport() async throws {
        let f = try Fixture()
        for operation in Operations.all {
            let client = try Client(origin: f.origin, surface: operation.surface, projectID: "proj_fixture", routing: .endpoint("endpoint_fixture"), headers: ["X-Fixture-Echo":"1"])
            var params: [String:String] = [:]
            for part in operation.path.split(separator: "{").dropFirst() {
                let name = String(part.split(separator: "}")[0]); params[name] = "fixture_" + name
            }
            let options = RequestOptions(parameters: params, query: [.init(name:"tag",value:"first + value"),.init(name:"tag",value:"second")])
            let prepared = try client.prepare(operation, options: options)
            let expected = URLComponents(url: prepared.url!, resolvingAgainstBaseURL: false)!
            let response = try await client.send(operation, options: options)
            let echo = try response.json()
            XCTAssertEqual(echo["method"]?.string, operation.method, operation.name)
            XCTAssertEqual(echo["path"]?.string, expected.percentEncodedPath + "?" + expected.percentEncodedQuery!, operation.name)
        }
    }
    func testNativeAPIMethodsAndWorkspaceEndpointRouting() async throws {
        let f = try Fixture()
        let client = try Client(origin: f.origin, projectID:"proj_test", routing: .workspaceEndpoint(workspace:"ws fixture", endpoint:"endpoint/fixture"), headers:["X-Fixture-Echo":"1"])
        let payload: JSONValue = ["model":"fixture","messages":[],"x_future":true]
        let response = try await client.api.postProjectIdEndpointSlugV1ChatCompletions(options: .json(payload))
        XCTAssertEqual(try response.json()["path"]?.string,"/proj_test/ws%20fixture/endpoint%2Ffixture/v1/chat/completions")
        let update = try await client.api.patchProjectIdV1ManagementEndpointsId(id:"endpoint fixture", options: .json(["name":"fixture"], parameters:["id":"must-not-override"]))
        let echo = try update.json()
        XCTAssertEqual(echo["path"]?.string,"/proj_test/v1/management/endpoints/endpoint%20fixture")
        XCTAssertEqual(echo["method"]?.string,"PATCH")
        let preflight = try await client.api.optionsProjectIdEndpointSlugV1ChatCompletions(options: .init(headers:["Origin":"https://example.invalid", "Access-Control-Request-Method":"POST"]))
        XCTAssertEqual(try preflight.json()["method"]?.string,"OPTIONS")
        let dashboard = try Client(origin:f.origin, surface:.dashboard)
        do { _ = try await dashboard.api.getProjectIdV1Models(); XCTFail("surface mismatch accepted") }
        catch ErebineError.invalid { }
    }
    func testMCPPromptsResourcesPaginationNotificationsAndResume() async throws {
        let f = try Fixture(); let session = try await MCPSession.connect(f.client())
        let pong = try await session.ping(); XCTAssertEqual(pong, [:])
        let first = try await session.listPrompts(); XCTAssertEqual(first["nextCursor"]?.string,"fixture-next")
        let next = try await session.listPrompts(cursor:first["nextCursor"]?.string)
        XCTAssertNil(next["nextCursor"]); XCTAssertEqual(next["fixture_params"]?["cursor"]?.string,"fixture-next")
        let prompt = try await session.getPrompt("fixture", arguments:["topic":"unicode 🌎"])
        XCTAssertEqual(prompt["fixture_params"], ["name":"fixture", "arguments":["topic":"unicode 🌎"]])
        let resources = try await session.listResources(cursor:"page2")
        XCTAssertEqual(resources["fixture_params"]?["cursor"]?.string,"page2")
        let templates = try await session.listResourceTemplates()
        guard case .array(let list) = templates["resourceTemplates"] else {return XCTFail("missing templates")}
        XCTAssertEqual(list[0]["x_vendor"],true)
        let uri = "erebine://fixture/resource"
        let resource = try await session.readResource(uri)
        guard case .array(let contents) = resource["contents"] else {return XCTFail("missing contents")}
        XCTAssertEqual(contents[0]["text"]?.string,"héllo 🌎")
        let subscribed = try await session.subscribeResource(uri)
        XCTAssertEqual(subscribed["fixture_params"]?["uri"]?.string,uri)
        let events = try await session.events(lastEventID:"fixture-event-1")
        var received:[ServerEvent] = []
        for try await event in events { received.append(event) }
        XCTAssertEqual(received.count,1);XCTAssertEqual(received[0].id,"fixture-event-2")
        let message = try received[0].json()
        XCTAssertEqual(message["method"]?.string,"notifications/resources/updated")
        XCTAssertEqual(message["x_last_event_id"]?.string,"fixture-event-1")
        _ = try await session.unsubscribeResource(uri); try await session.close()
        do { _ = try await session.events(); XCTFail("closed session accepted") } catch ErebineError.invalid { }
        let refusedClient = try Client(origin:f.origin,projectID:"proj_test",headers:["X-Fixture-MCP-Refuse-GET":"1"])
        let refused = try await MCPSession.connect(refusedClient)
        do { _ = try await refused.events();XCTFail("expected refusal") }
        catch ErebineError.api(let status,_,_) {XCTAssertEqual(status,405)}
    }
}
