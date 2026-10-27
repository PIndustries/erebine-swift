import Foundation
import Erebine
@main struct WorkerInferenceSmoke {
    static func validateResponse(_ value: JSONValue) throws {
        guard let status=value["status"]?.string,["completed","incomplete"].contains(status),
              case .array(let output)=value["output"],!output.isEmpty,
              case .integer(let tokens)=value["usage"]?["output_tokens"],tokens>0,
              value["error"] == nil || value["error"] == .null else {throw ErebineError.invalid("Responses generation contract")}
    }
    static func check(_ name:String,_ checks:inout [JSONValue],_ operation:() async throws -> [String:JSONValue]) async {
        do {var fields=try await operation();fields["name"] = .string(name);fields["result"] = "passed";checks.append(.object(fields))}
        catch ErebineError.api(let status,_,_) {checks.append(["name":.string(name),"result":"http_failed","status":.integer(Int64(status))])}
        catch {checks.append(["name":.string(name),"result":"response_contract_failed"])}
    }
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
        if ProcessInfo.processInfo.environment["EREBINE_WORKER_INFERENCE_MODE"] != "responses" {
        let body:JSONValue=["model":cfg["model_id"]!,"messages":[["role":"user","content":"Synthetic native SDK live test."]],"max_tokens":8,"temperature":0,"store":true,"metadata":["sdk_validation":"true","chat_id":.string(chatID)]]
        let generated=try await client.inference.chat(body);let completed=try generated.json()
        var hasGeneratedText=false
        if case .array(let choices)=completed["choices"],let content=choices.first?["message"]?["content"]?.string,case .integer(let tokens)=completed["usage"]?["completion_tokens"] {hasGeneratedText = !content.isEmpty && tokens>0}
        checks.append(["name":"real CPU chat completion","result":.string(hasGeneratedText ? "passed":"response_contract_failed"),"output_tokens":completed["usage"]?["completion_tokens"] ?? .null])
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
        var streamed=false
        if case .integer(let tokens)=accumulator.usage?["completion_tokens"] {streamed = events>0 && accumulator.choices.values.contains{!$0.content.isEmpty} && tokens>0}
        checks.append(["name":"real CPU chat SSE and native assembly","result":.string(streamed ? "passed":"response_contract_failed"),"events":.integer(Int64(events)),"usage_received":.bool(accumulator.usage != nil),"output_tokens":accumulator.usage?["completion_tokens"] ?? .null])
        }
        let request:JSONValue=["model":cfg["model_id"]!,"input":[["role":"user","content":[["type":"input_text","text":"Synthetic response fixture."]]]],"max_output_tokens":32,"store":true]
        let r=try await client.inference.responses(request);let response=try r.json()
        try validateResponse(response)
        checks.append(["name":"real CPU Responses generation","result":"passed","terminal_status":response["status"]!,"output_tokens":response["usage"]!["output_tokens"]!])
        guard let id=response["id"]?.string else {throw ErebineError.invalid("Missing Responses ID")}
        await check("stored Responses content retrieval",&checks){
            let retrieved=try await client.api.getProjectIdEndpointSlugV1ResponsesId(id:id).json()
            try validateResponse(retrieved)
            guard retrieved["id"] == response["id"],case .array(let saved)=retrieved["output"],case .array(let created)=response["output"],saved.first?["content"] == created.first?["content"] else {throw ErebineError.invalid("Stored Responses round trip")}
            return ["output_item_id_stable":.bool(saved.first?["id"] == created.first?["id"])]
        }
        await check("stored Responses input-item persistence",&checks){
            let items=try await client.api.getProjectIdEndpointSlugV1ResponsesIdInputItems(id:id).json()
            guard case .array(let inputItems)=items["data"],!inputItems.isEmpty else {throw ErebineError.invalid("Responses input items missing")}
            return ["input_items":.integer(Int64(inputItems.count))]
        }
        await check("stored Responses listing",&checks){
            let listing=try await client.api.getProjectIdEndpointSlugV1Responses(options:.init(query:[.init(name:"limit",value:"100")])).json()
            guard case .array(let listed)=listing["data"],listed.contains(where:{$0["id"]==response["id"]}) else {throw ErebineError.invalid("Responses missing from listing")}
            return [:]
        }
        await check("Responses conversation chaining and child deletion",&checks){
            let chained=try await client.inference.responses(["model":cfg["model_id"]!,"input":"Continue the synthetic fixture.","previous_response_id":.string(id),"max_output_tokens":16,"store":true] as JSONValue).json()
            try validateResponse(chained)
            guard chained["previous_response_id"]==response["id"],let chainedID=chained["id"]?.string else {throw ErebineError.invalid("Responses chaining contract")}
            _ = try await client.api.deleteProjectIdEndpointSlugV1ResponsesId(id:chainedID)
            return [:]
        }
        await check("real CPU Responses SSE terminal snapshot and usage",&checks){
            let streamBody:JSONValue=["model":cfg["model_id"]!,"input":"Synthetic streamed response fixture.","max_output_tokens":32,"store":false]
            var count=0;var terminal:JSONValue?
            for try await event in try await client.inference.streamResponses(streamBody){
                let value=try event.json();let kind=value["type"]?.string ?? event.event ?? ""
                guard (value["error"] == nil || value["error"] == .null),!["response.failed","response.cancelled","error"].contains(kind) else {throw ErebineError.stream("Response stream error")}
                if ["response.completed","response.incomplete"].contains(kind) {guard let response=value["response"] else {throw ErebineError.stream("Missing terminal response")};try validateResponse(response);terminal=response["status"]}
                count+=1
            }
            guard count>0,let terminal else {throw ErebineError.invalid("Responses stream missing successful terminal snapshot")}
            return ["events":.integer(Int64(count)),"terminal_status":terminal,"usage_verified":true]
        }
        await check("background Responses queue cancel retrieve and delete",&checks){
            let background=try await client.inference.responses(["model":cfg["model_id"]!,"input":"Synthetic cancellable background fixture.","max_output_tokens":64,"store":true,"background":true] as JSONValue).json()
            guard let backgroundID=background["id"]?.string,let state=background["status"]?.string,["queued","in_progress"].contains(state) else {throw ErebineError.invalid("Background Responses not asynchronous")}
            let cancelled=try await client.api.postProjectIdEndpointSlugV1ResponsesIdCancel(id:backgroundID).json()
            guard cancelled["status"]=="cancelled" else {throw ErebineError.invalid("Background cancellation contract")}
            let cancelledGet=try await client.api.getProjectIdEndpointSlugV1ResponsesId(id:backgroundID).json()
            guard cancelledGet["status"]=="cancelled" else {throw ErebineError.invalid("Background cancellation persistence")}
            let cleanupStatus:Int
            do {cleanupStatus=try await client.api.deleteProjectIdEndpointSlugV1ResponsesId(id:backgroundID).status}
            catch ErebineError.api(let status,_,_) where status==404 {cleanupStatus=404}
            return ["cleanup_status":.integer(Int64(cleanupStatus))]
        }
        await check("delete stored Responses and verify absence",&checks){
            let deleted=try await client.api.deleteProjectIdEndpointSlugV1ResponsesId(id:id).json()
            guard deleted["deleted"]==true else {throw ErebineError.invalid("Responses deletion contract")}
            do {_ = try await client.api.getProjectIdEndpointSlugV1ResponsesId(id:id);throw ErebineError.invalid("Deleted Responses remains accessible")}
            catch ErebineError.api(let status,_,_) where status==404 {}
            return [:]
        }

    }
    static func main() async {var checks:[JSONValue]=[];var ok=true;do{try await run(&checks)}catch ErebineError.api(let status,_,_){ok=false;checks.append(["name":"worker setup or generation","result":"http_failed","status":.integer(Int64(status))])}catch{ok=false;checks.append(["name":"worker setup or generation","result":"response_contract_failed"])};ok = ok && checks.allSatisfy{$0["result"] == "passed"};let report:JSONValue=["sdk":"swift","checks":.array(checks),"completed":.bool(ok),"responses_only":.bool(ProcessInfo.processInfo.environment["EREBINE_WORKER_INFERENCE_MODE"] == "responses")];print(String(data:try! JSONEncoder().encode(report),encoding:.utf8)!);if !ok{FileHandle.standardError.write(Data("Worker inference validation did not complete; credentials, identifiers and response bodies were not logged.\n".utf8));exit(1)}}
}
