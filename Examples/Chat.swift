import Foundation
import Erebine

// Call from your application's async task. Values come from your app's configuration.
func chat(apiKey: String, projectID: String, workspaceID: String, model: String) async throws -> JSONValue {
    let client = try Client(apiKey: apiKey, projectID: projectID, routing: .direct(workspace: workspaceID))
    let request = ChatCompletionRequest(model: model, messages: [.user("Say hello in one sentence.")])
    let response = try await client.send(Operations.chatCompletionsCreate, options: .json(request))
    return try response.json()
}
func stream(apiKey: String, projectID: String, endpoint: String, model: String) async throws {
    let client = try Client(apiKey: apiKey, projectID: projectID, routing: .endpoint(endpoint))
    let body: JSONValue = ["model": .string(model), "messages": [["role": "user", "content": "Hello"]], "stream": true, "stream_options": ["include_usage": true]]
    let events = try await client.stream(Operations.chatCompletionsCreate, options: .json(body, headers: ["X-Erebine-Vendor-Events": "on"]))
    for try await event in events { print(event.event ?? "message", event.data) }
}
