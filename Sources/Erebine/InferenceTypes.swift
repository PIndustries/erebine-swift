import Foundation

/// Required typed fields take precedence over extra vendor fields.
public protocol InferenceRequest: Encodable, Sendable {
    var extra: [String: JSONValue] { get }
    var fields: [String: JSONValue] { get }
}
extension InferenceRequest {
    public func encode(to encoder: any Encoder) throws {
        try JSONValue.object(extra.merging(fields, uniquingKeysWith: { _, required in required })).encode(to: encoder)
    }
}
public struct ResponsesRequest: InferenceRequest {
    public var model: String
    public var input: JSONValue
    public var extra: [String: JSONValue]
    public init(model: String, input: JSONValue, extra: [String: JSONValue] = [:]) {
        self.model = model; self.input = input; self.extra = extra
    }
    public var fields: [String: JSONValue] { ["model": .string(model), "input": input] }
}
public struct EmbeddingRequest: InferenceRequest {
    public var model: String
    public var input: JSONValue
    public var extra: [String: JSONValue]
    public init(model: String, input: JSONValue, extra: [String: JSONValue] = [:]) {
        self.model = model; self.input = input; self.extra = extra
    }
    public var fields: [String: JSONValue] { ["model": .string(model), "input": input] }
}
public struct RerankRequest: InferenceRequest {
    public var model: String
    public var query: String
    public var documents: [JSONValue]
    public var extra: [String: JSONValue]
    public init(model: String, query: String, documents: [JSONValue], extra: [String: JSONValue] = [:]) {
        self.model = model; self.query = query; self.documents = documents; self.extra = extra
    }
    public var fields: [String: JSONValue] { ["model": .string(model), "query": .string(query), "documents": .array(documents)] }
}
public struct ScoreRequest: InferenceRequest {
    public var model: String
    public var text1: String
    public var text2: [String]
    public var extra: [String: JSONValue]
    public init(model: String, text1: String, text2: [String], extra: [String: JSONValue] = [:]) {
        self.model = model; self.text1 = text1; self.text2 = text2; self.extra = extra
    }
    public var fields: [String: JSONValue] { ["model": .string(model), "text_1": .string(text1), "text_2": .array(text2.map(JSONValue.string))] }
}
public struct SpeechRequest: InferenceRequest {
    public var model: String
    public var input: String
    public var voice: String
    public var extra: [String: JSONValue]
    public init(model: String, input: String, voice: String, extra: [String: JSONValue] = [:]) {
        self.model = model; self.input = input; self.voice = voice; self.extra = extra
    }
    public var fields: [String: JSONValue] { ["model": .string(model), "input": .string(input), "voice": .string(voice)] }
}
public struct SystemOneRequest: InferenceRequest {
    public var model: String
    public var state: JSONValue
    public var questions: [String: JSONValue]
    public var extra: [String: JSONValue]
    public init(model: String, state: JSONValue, questions: [String: JSONValue], extra: [String: JSONValue] = [:]) {
        self.model = model; self.state = state; self.questions = questions; self.extra = extra
    }
    public var fields: [String: JSONValue] { ["model": .string(model), "state": state, "questions": .object(questions)] }
}

public struct AudioFile: Sendable {
    public var filename: String
    public var contentType: String
    public var data: Data
    public init(filename: String, contentType: String, data: Data) { self.filename = filename; self.contentType = contentType; self.data = data }
}
public struct AudioTranscriptionRequest: Sendable {
    public var model: String
    public var file: AudioFile
    /// Repeated form field names are retained, including timestamp granularities.
    public var fields: [(String, String)]
    public init(model: String, file: AudioFile, fields: [(String, String)] = []) { self.model = model; self.file = file; self.fields = fields }
}
extension ChatMessage {
    public static func tool(callID: String, output: String) -> Self { .init(role: "tool", content: .string(output), extra: ["tool_call_id":.string(callID)]) }
    public static func assistantToolCalls(_ calls: [JSONValue]) -> Self { .init(role: "assistant", content: .null, extra: ["tool_calls":.array(calls)]) }
}
extension JSONValue {
    /// Visible text only; reasoning and tool arguments remain separate fields.
    public var outputText: String {
        if case .array(let choices) = self["choices"], let first = choices.first, let text = first["message"]?["content"]?.string { return text }
        guard case .array(let output) = self["output"] else { return "" }
        return output.filter { $0["type"]?.string == "message" }.flatMap { item -> [JSONValue] in
            if case .array(let content) = item["content"] { return content }; return []
        }.filter { $0["type"]?.string == "output_text" }.compactMap { $0["text"]?.string }.joined()
    }
}

