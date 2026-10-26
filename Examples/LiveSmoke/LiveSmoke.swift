import Erebine
import Foundation

// Opt-in live validation through a loopback SSH proxy that injects remote auth.
// This executable never receives or stores the real account key.
@main struct LiveSmoke {
    static func main() async throws {
        guard let origin = ProcessInfo.processInfo.environment["EREBINE_VALIDATION_ORIGIN"], origin.hasPrefix("http://127.0.0.1:"), let url = URL(string: origin) else { throw ErebineError.invalid("Set a loopback EREBINE_VALIDATION_ORIGIN") }
        let bootstrap = try Client(origin: url)
        let configResponse = try await bootstrap.send(method: "GET", path: "/__validation/config")
        let config = try configResponse.json()
        guard let project = config["project"]?.string, let workspace = config["workspace"]?.string, let model = config["model"]?.string else { throw ErebineError.invalid("Missing proxy configuration") }
        let client = try Client(origin: url, projectID: project, routing: .direct(workspace: workspace))
        let mcp = try await MCPSession.connect(client)
        let tools = try await mcp.listTools()
        guard case .array(let available) = tools["tools"], !available.isEmpty else { throw ErebineError.invalid("No MCP tools") }
        try await mcp.close()
        print("MCP: session initialized, \(available.count) tools discovered, session closed")
        if ProcessInfo.processInfo.environment["EREBINE_VALIDATION_MCP_ONLY"] != nil { return }
        let models = try await client.inference.models()
        guard case .array(let list) = try models.json()["data"], list.contains(where: {$0["id"]?.string == model}) else { throw ErebineError.invalid("Configured model missing") }
        print("models: HTTP \(models.status), configured model discovered")
        let request: JSONValue = ["model": .string(model), "messages": [["role":"user", "content":"Reply only with SDK_OK."]], "max_tokens":64, "store":false]
        let chat = try await client.inference.chat(request)
        guard case .array = try chat.json()["choices"] else { throw ErebineError.invalid("No choices") }
        print("chat: HTTP \(chat.status), choices decoded, request_id=\(chat.requestID != nil)")
        let response = try await client.inference.responses(ResponsesRequest(model:model, input:"Reply only with SDK_OK.", extra:["max_output_tokens":64,"store":false]))
        guard case .array = try response.json()["output"] else { throw ErebineError.invalid("No response output") }
        print("responses: HTTP \(response.status), output decoded")
        let streamBody: JSONValue = ["model": .string(model), "messages": [["role":"user", "content":"Reply only with SDK_OK."]], "max_tokens":64, "store":false, "stream":true, "stream_options":["include_usage":true]]
        let events = try await client.inference.streamChat(streamBody, options:.init(headers:["X-Erebine-Vendor-Events":"on"]))
        var count = 0; var usage = false
        for try await event in events {
            let value = try event.json()
            guard value["error"] == nil else { throw ErebineError.stream("Server streaming error") }
            if let u = value["usage"], u != .null { usage = true }; count += 1
        }
        guard count > 0 else { throw ErebineError.stream("No events") }
        print("stream: \(count) JSON events decoded, usage=\(usage)")
        try await InferenceChecks.run(client, config, model)
    }
}
