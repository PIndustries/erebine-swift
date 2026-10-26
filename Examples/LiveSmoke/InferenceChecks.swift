import Erebine
import Foundation

enum InferenceChecks {
    static func require(_ condition: Bool, _ message: String) throws { if !condition { throw ErebineError.invalid(message) } }
    static func run(_ client: Client, _ config: JSONValue, _ model: String) async throws {
        let responseEvents = try await client.inference.streamResponses(ResponsesRequest(model:model, input:"Reply only with SDK_OK.", extra:["max_output_tokens":64,"store":false]))
        var responseCount = 0; var terminal = false
        for try await event in responseEvents {
            let value = try event.json()
            try require(value["type"] != "response.failed" && value["type"] != "error", "Responses streaming error")
            terminal = terminal || value["type"] == "response.completed" || value["type"] == "response.incomplete"; responseCount += 1
        }
        try require(terminal && responseCount > 0, "Responses terminal event missing")
        print("responses SSE: \(responseCount) JSON events and terminal response decoded")
        let metadata = try await client.inference.model(model)
        try require(try metadata.json()["id"]?.string == model, "Retrieved model ID differs")
        print("model retrieval: HTTP \(metadata.status)")
        let schema: JSONValue = ["type":"json_schema", "json_schema":["name":"sdk_answer", "strict":true, "schema":["type":"object", "properties":["ok":["type":"boolean"]], "required":["ok"], "additionalProperties":false]]]
        let body = ChatCompletionRequest(model:model, messages:[.user("Return an object with ok set to true.")], extra:["max_tokens":128, "reasoning_effort":"minimal", "response_format":schema, "store":false])
        let structuredResponse = try await client.inference.chat(body)
        let structuredText = try structuredResponse.json().outputText
        let structured = try JSONDecoder().decode(JSONValue.self, from:Data(structuredText.utf8))
        try require(structured["ok"] == true, "Structured JSON schema result missing")
        print("structured output: JSON schema result decoded")
        let tool: JSONValue = ["type":"function", "function":["name":"sdk_echo", "description":"Echo the provided synthetic text locally.", "parameters":["type":"object", "properties":["text":["type":"string"]], "required":["text"], "additionalProperties":false], "strict":true]]
        let user: JSONValue = ["role":"user", "content":"Call sdk_echo with the text sdk-fixture."]
        let request: JSONValue = ["model":.string(model), "messages":[user], "tools":[tool], "tool_choice":["type":"function", "function":["name":"sdk_echo"]], "max_tokens":128, "reasoning_effort":"minimal", "store":false]
        let toolResponse = try await client.inference.chat(request)
        guard case .array(let choices) = try toolResponse.json()["choices"], let assistant = choices.first?["message"], case .array(let calls) = assistant["tool_calls"], !calls.isEmpty else { throw ErebineError.invalid("Tool calls missing") }
        var messages = [user, assistant]
        for call in calls {
            try require(call["function"]?["name"]?.string == "sdk_echo", "Unexpected tool")
            guard let arguments = call["function"]?["arguments"]?.string, let id = call["id"]?.string else { throw ErebineError.invalid("Tool arguments or ID missing") }
            let args = try JSONDecoder().decode(JSONValue.self, from:Data(arguments.utf8))
            guard let output = args["text"]?.string else { throw ErebineError.invalid("Tool text missing") }
            let message = try JSONDecoder().decode(JSONValue.self, from:JSONEncoder().encode(ChatMessage.tool(callID:id, output:output)))
            messages.append(message)
        }
        let follow: JSONValue = ["model":.string(model), "messages":.array(messages), "max_tokens":128, "reasoning_effort":"minimal", "store":false]
        let followResponse = try await client.inference.chat(follow)
        try require(!followResponse.json().outputText.isEmpty, "Tool result answer missing")
        print("tool calling: function arguments decoded and local result round-tripped")
        if let embedding = config["embedding_model"]?.string {
            for format in ["float","base64"] {
                let request = EmbeddingRequest(model:embedding, input:["SDK fixture one","SDK fixture two"], extra:["encoding_format":.string(format)])
                let response = try await client.inference.embeddings(request)
                guard case .array(let data) = try response.json()["data"], data.count == 2 else { throw ErebineError.invalid("Embedding batch missing") }
                if format == "float" { guard case .array = data[0]["embedding"] else { throw ErebineError.invalid("Float embedding missing") } }
                else { try require(data[0]["embedding"]?.string != nil, "Base64 embedding missing") }
            }
            print("embeddings: batched float and base64 responses decoded")
        }
        if let ranker = config["rerank_model"]?.string {
            let response = try await client.inference.rerank(RerankRequest(model:ranker, query:"Rust SDK", documents:["A Rust client library","A cooking recipe"]))
            guard case .array(let results) = try response.json()["results"], results.count == 2 else { throw ErebineError.invalid("Rerank results missing") }
            let scores = try await client.inference.score(ScoreRequest(model:ranker, text1:"Rust SDK", text2:["A Rust client library","A cooking recipe"]))
            guard case .array(let data) = try scores.json()["data"], data.count == 2 else { throw ErebineError.invalid("Score data missing") }
            print("rerank and score: both result formats decoded")
        }
        if let model = config["transcription_model"]?.string {
            func le(_ value: UInt32, _ bytes: Int) -> Data { Data((0..<bytes).map { UInt8(truncatingIfNeeded:value >> (8 * $0)) }) }
            let size: UInt32 = 8000
            var wav = Data("RIFF".utf8); wav.append(le(36+size,4)); wav.append(Data("WAVEfmt ".utf8)); wav.append(le(16,4)); wav.append(le(1,2)); wav.append(le(1,2)); wav.append(le(16000,4)); wav.append(le(32000,4)); wav.append(le(2,2)); wav.append(le(16,2)); wav.append(Data("data".utf8)); wav.append(le(size,4)); wav.append(Data(repeating:0,count:Int(size)))
            let response = try await client.inference.transcribe(AudioTranscriptionRequest(model:model, file:AudioFile(filename:"sdk-silence.wav", contentType:"audio/wav", data:wav)))
            try require(response.json()["text"]?.string != nil, "Transcript shape missing")
            print("transcription: multipart audio accepted, transcript shape decoded")
        }
    }
}
