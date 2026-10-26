import XCTest
@testable import Erebine
import Foundation

final class CLIContractTests: XCTestCase {
    func testOfficialCLIContractsReplayThroughNativeTransport() async throws {
        let root=URL(fileURLWithPath:#filePath).deletingLastPathComponent().deletingLastPathComponent().deletingLastPathComponent()
        let evidence=try JSONDecoder().decode(JSONValue.self,from:Data(contentsOf:root.appendingPathComponent("api/cli-contracts.json")))
        guard case .array(let fixtures)=evidence["requests"] else {return XCTFail("Missing CLI fixtures")}
        XCTAssertEqual(fixtures.count,283)
        let f=try Fixture();let client=try Client(origin:f.origin,apiKey:"fake-fixture-key",projectID:"proj_fixture",routing:.endpoint("test"),headers:["X-Fixture-Echo":"1"])
        for fixture in fixtures {
            guard let operation=Operations.all.first(where:{$0.name==fixture["operation"]?.string}),case .object(let params)=fixture["parameters"],case .array(let pairs)=fixture["query"] else {return XCTFail("Invalid fixture binding")}
            let parameters=params.mapValues{$0.string!}
            let query=pairs.map{pair -> URLQueryItem in guard case .array(let p)=pair else {fatalError("Invalid query fixture")};return URLQueryItem(name:p[0].string!,value:p[1].string!)}
            var options=RequestOptions(parameters:parameters,query:query)
            let expectedBody=Data(base64Encoded:fixture["body_base64"]!.string!)!
            if let ct=fixture["content_type"]?.string {
                if !expectedBody.isEmpty && ct.contains("application/json") {options=try .json(fixture["body_json"]!,parameters:parameters,query:query)}
                else {options.body=expectedBody;options.contentType=ct}
            }
            if case .object(let headers) = fixture["headers"] { options.headers = headers.mapValues { $0.string! } }
            let prepared=try client.prepare(operation,options:options)
            let expected=URLComponents(url:prepared.url!,resolvingAgainstBaseURL:false)!
            XCTAssertEqual(expected.percentEncodedPath,fixture["expected_path"]?.string,fixture["command"]!.string!)
            let response=try await client.send(operation,options:options);let echo=try response.json()
            XCTAssertEqual(echo["method"]?.string,operation.method)
            if case .object(let headers) = fixture["headers"], case .object(let echoedHeaders) = echo["headers"] {
                for (name,value) in headers { XCTAssertEqual(echoedHeaders.first(where: { $0.key.lowercased() == name.lowercased() })?.value, value) }
            }
            if expectedBody.isEmpty { XCTAssertEqual(echo["body"]?.string, "") }

            XCTAssertEqual(echo["path"]?.string,expected.percentEncodedPath+(expected.percentEncodedQuery.map{"?"+$0} ?? ""))
            if fixture["body_json"] != .null {
                let body=try JSONDecoder().decode(JSONValue.self,from:Data(echo["body"]!.string!.utf8))
                XCTAssertEqual(body,fixture["body_json"])
            } else if !expectedBody.isEmpty {XCTAssertEqual(Data(echo["body"]!.string!.utf8),expectedBody)}
        }
    }
}
