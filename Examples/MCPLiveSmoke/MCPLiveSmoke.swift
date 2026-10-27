import Foundation
import Erebine

@main struct MCPLiveSmoke {
    static func run() async throws {
        guard let origin=ProcessInfo.processInfo.environment["EREBINE_MANAGEMENT_PROXY"], origin.hasPrefix("http://127.0.0.1:"),let url=URL(string:origin) else {throw ErebineError.invalid("Loopback proxy required")}
        let bootstrap=try Client(origin:url)
        let config=try await bootstrap.send(method:"GET",path:"/__management/config",options:.init(query:[.init(name:"client",value:"swift")]))
        let cfg=try config.json()
        let client=try Client(origin:url,projectID:cfg["project_id"]!.string!)
        let created=try await client.api.postProjectIdV1Workspaces(options:.json(["name":cfg["prefix"]!,"description":"Disposable MCP protocol validation"] as JSONValue))
        let workspace=try created.json();guard let id=workspace["id"]?.string else {throw ErebineError.invalid("Workspace missing")}
        let mcpClient=try Client(origin:url,projectID:cfg["project_id"]!.string!,headers:["X-Erebine-Workspace":id],timeout:8)
        var results:[JSONValue]=[]
        func record(_ name:String,_ operation:() async throws -> JSONValue) async -> JSONValue? {
            do {let value=try await operation();results.append(["name":.string(name),"result":"passed"]);return value}
            catch ErebineError.api(let status,_,_) {results.append(["name":.string(name),"result":"http_rejected","status":.integer(Int64(status))])}
            catch ErebineError.rpc(let body) {results.append(["name":.string(name),"result":"rpc_rejected","code":body["code"] ?? .null])}
            catch {results.append(["name":.string(name),"result":"protocol_or_transport_failed"])}
            return nil
        }
        do {
            let session=try await MCPSession.connect(mcpClient)
            results.append(["name":"initialize and initialized notification","result":"passed"])
            _ = await record("ping") {try await session.ping()}
            _ = await record("tools list") {try await session.listTools()}
            let prompts=await record("prompts list") {try await session.listPrompts()}
            let resources=await record("resources list") {try await session.listResources()}
            _ = await record("resource templates") {try await session.listResourceTemplates()}
            if case .array(let list)=prompts?["prompts"],let prompt=list.first,let name=prompt["name"]?.string {
                var args:[String:String]=[:]
                if case .array(let arguments)=prompt["arguments"] {for arg in arguments {if let name=arg["name"]?.string {args[name]=name.contains("workspace") ? id : "Synthetic SDK validation"}}}
                _ = await record("prompt retrieval") {try await session.getPrompt(name,arguments:args)}
            }
            if case .array(let list)=resources?["resources"],let uri=list.first?["uri"]?.string {
                _ = await record("resource read") {try await session.readResource(uri)}
                let initialization=await session.initialization
                if initialization["capabilities"]?["resources"]?["subscribe"] == true {
                    _ = await record("resource subscribe") {try await session.subscribeResource(uri)}
                    _ = await record("resource unsubscribe") {try await session.unsubscribeResource(uri)}
                } else {results.append(["name":"resource subscriptions","result":"capability_not_advertised"])}
            }
            do {
                _ = try await session.events()
                results.append(["name":"GET event stream","result":"opened"])
            } catch ErebineError.api(let status,_,_) {results.append(["name":"GET event stream","result":"http_rejected","status":.integer(Int64(status))])}
            catch {results.append(["name":"GET event stream","result":"not_established"])}
            do {try await session.close();results.append(["name":"session close","result":"passed"])}
            catch {results.append(["name":"session close","result":"failed"])}
        } catch {results.append(["name":"initialize","result":"protocol_or_transport_failed"])}
        var cleanup=false
        do {_ = try await client.api.deleteProjectIdV1WorkspacesId(id:id);cleanup=true}catch {}
        let report:JSONValue=["sdk":"swift","checks":.array(results),"workspace_cleanup":.bool(cleanup)]
        print(String(data:try JSONEncoder().encode(report),encoding:.utf8)!)
        let failed=results.contains { r in ["failed","rpc_rejected","protocol_or_transport_failed"].contains(r["result"]?.string ?? "") || (r["result"]?.string == "http_rejected" && !(r["name"]?.string == "GET event stream" && r["status"] == 405)) }
        if failed {throw ErebineError.invalid("MCP checks failed")}
        if !cleanup {throw ErebineError.invalid("Workspace cleanup failed")}
    }
    static func main() async {do {try await run()}catch {FileHandle.standardError.write(Data("MCP validation did not complete; credentials and response bodies were not logged.\n".utf8));exit(1)}}
}
