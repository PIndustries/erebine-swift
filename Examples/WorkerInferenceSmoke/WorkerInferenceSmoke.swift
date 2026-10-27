import Foundation
import Erebine
@main struct WorkerInferenceSmoke {
    static func run(_ checks: inout [JSONValue]) async throws {
        guard let origin=ProcessInfo.processInfo.environment["EREBINE_MANAGEMENT_PROXY"],origin.hasPrefix("http://127.0.0.1:"),let url=URL(string:origin) else {throw ErebineError.invalid("Loopback proxy required")}
        let bootstrap=try Client(origin:url)
        let config=try await bootstrap.send(method:"GET",path:"/__management/config",options:.init(query:[.init(name:"client",value:"swift")]))
        let cfg=try config.json();let management=try Client(origin:url,projectID:cfg["project_id"]!.string!)
        let ws=try await management.api.postProjectIdV1Workspaces(options:.json(["name":.string(cfg["prefix"]!.string!+"-chat"),"description":"Isolated native SDK inference fixture"] as JSONValue))
        let workspace=try ws.json();let workspaceID=workspace["id"]!.string!
        let c=try await management.api.postProjectIdV1Chats(options:.json(["title":cfg["prefix"]!,"workspace_id":.string(workspaceID),"model_id":cfg["model_id"]!] as JSONValue))
        let chat=try c.json();let chatID=chat["id"]!.string!
        checks.append(["name":"create isolated chat workspace and chat","result":"passed"])
        let client=try Client(origin:url,projectID:cfg["project_id"]!.string!,routing:.endpoint(cfg["endpoint_slug"]!.string!),headers:["X-Workspace-Id":workspaceID,"X-Chat-Id":chatID])
        let models=try await client.inference.models();guard case .array = try models.json()["data"] else {throw ErebineError.invalid("Model discovery contract")}
        checks.append(["name":"discover served model","result":"passed"])
        let body:JSONValue=["model":cfg["model_id"]!,"messages":[["role":"user","content":"Synthetic native SDK live test."]],"max_tokens":8,"temperature":0,"store":true,"metadata":["sdk_validation":"true","chat_id":.string(chatID)]]
        let generated=try await client.inference.chat(body);let completed=try generated.json()
        guard case .array(let choices)=completed["choices"],!choices.isEmpty else {throw ErebineError.invalid("Chat completion contract")}
        checks.append(["name":"real CPU chat completion","result":"passed"])
        if let id=completed["id"]?.string {
            _ = try await client.api.getProjectIdEndpointSlugV1ChatCompletionsId(id:id)
            _ = try await client.api.getProjectIdEndpointSlugV1ChatCompletionsIdMessages(id:id)
            _ = try await client.api.postProjectIdEndpointSlugV1ChatCompletionsId(id:id,options:.json(["metadata":["sdk_validation":"updated"]]))
            _ = try await client.api.deleteProjectIdEndpointSlugV1ChatCompletionsId(id:id)
            checks.append(["name":"stored completion retrieve messages update delete","result":"passed"])
        }
        let streaming:JSONValue=["model":cfg["model_id"]!,"messages":[["role":"user","content":"Synthetic stream fixture."]],"max_tokens":8,"store":false,"stream_options":["include_usage":true]]
        var accumulator=ChatAccumulator();var events=0
        for try await event in try await client.inference.streamChat(streaming){try accumulator.push(event);events+=1}
        guard events>0,!accumulator.choices.isEmpty else {throw ErebineError.invalid("SSE completion contract")}
        checks.append(["name":"real CPU chat SSE and native assembly","result":"passed","events":.integer(Int64(events)),"usage_received":.bool(accumulator.usage != nil)])
        let request:JSONValue=["model":cfg["model_id"]!,"input":"Synthetic response fixture.","max_output_tokens":32,"store":true]
        let r=try await client.inference.responses(request);let response=try r.json()
        guard case .array = response["output"] else {throw ErebineError.invalid("Responses contract")}
        checks.append(["name":"real CPU Responses generation","result":"passed"])
        if let id=response["id"]?.string {
            _ = try await client.api.getProjectIdEndpointSlugV1ResponsesId(id:id)
            _ = try await client.api.getProjectIdEndpointSlugV1ResponsesIdInputItems(id:id)
            _ = try await client.api.deleteProjectIdEndpointSlugV1ResponsesId(id:id)
            checks.append(["name":"stored Responses retrieve input items delete","result":"passed"])
        }
        let streamBody:JSONValue=["model":cfg["model_id"]!,"input":"Synthetic streamed response fixture.","max_output_tokens":32,"store":false]
        var count=0
        for try await event in try await client.inference.streamResponses(streamBody){let value=try event.json();guard value["error"] == nil else {throw ErebineError.stream("Response stream error")};count+=1}
        guard count>0 else {throw ErebineError.invalid("Empty Responses stream")}
        checks.append(["name":"real CPU Responses SSE","result":"passed","events":.integer(Int64(count))])
    }
    static func main() async {var checks:[JSONValue]=[];var ok=true;do{try await run(&checks)}catch{ok=false};let report:JSONValue=["sdk":"swift","checks":.array(checks),"completed":.bool(ok)];print(String(data:try! JSONEncoder().encode(report),encoding:.utf8)!);if !ok{FileHandle.standardError.write(Data("Worker inference validation did not complete; credentials, identifiers and response bodies were not logged.\n".utf8));exit(1)}}
}
