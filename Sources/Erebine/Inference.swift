import Foundation

/// Named native inference APIs accepting typed requests, JSONValue, or your own
/// Encodable types. Status, headers, original bytes, and vendor fields survive.
public struct Inference: Sendable {
    private let client: Client
    init(client: Client) { self.client = client }
    private func options<T: Encodable>(_ body: T, _ options: RequestOptions) throws -> RequestOptions {
        guard options.body == nil else { throw ErebineError.invalid("Inference body must be supplied as the request argument") }
        var result = options; result.body = try JSONEncoder().encode(body); result.contentType = "application/json"; return result
    }
    private func streaming<T: Encodable>(_ body: T, key: String, value: JSONValue) throws -> JSONValue {
        guard case .object(var fields) = try JSONDecoder().decode(JSONValue.self, from: JSONEncoder().encode(body)) else { throw ErebineError.invalid("Inference body must be a JSON object") }
        fields[key] = value; return .object(fields)
    }
    public func models(options: RequestOptions = .init()) async throws -> APIResponse { try await client.send(Operations.modelsList, options: options) }
    public func model(_ id: String, options: RequestOptions = .init()) async throws -> APIResponse {
        var options = options; options.parameters["id"] = id
        return try await client.send(Operations.getProjectIdEndpointSlugV1ModelsId, options: options)
    }
    public func chat<T: Encodable>(_ body: T, options: RequestOptions = .init()) async throws -> APIResponse { try await client.send(Operations.chatCompletionsCreate, options: self.options(body, options)) }
    public func responses<T: Encodable>(_ body: T, options: RequestOptions = .init()) async throws -> APIResponse { try await client.send(Operations.responsesCreate, options: self.options(body, options)) }
    public func embeddings<T: Encodable>(_ body: T, options: RequestOptions = .init()) async throws -> APIResponse { try await client.send(Operations.embeddingsCreate, options: self.options(body, options)) }
    public func rerank<T: Encodable>(_ body: T, options: RequestOptions = .init()) async throws -> APIResponse { try await client.send(Operations.postProjectIdEndpointSlugV1Rerank, options: self.options(body, options)) }
    public func score<T: Encodable>(_ body: T, options: RequestOptions = .init()) async throws -> APIResponse { try await client.send(Operations.postProjectIdEndpointSlugV1Score, options: self.options(body, options)) }
    public func systemOne<T: Encodable>(_ body: T, options: RequestOptions = .init()) async throws -> APIResponse { try await client.send(Operations.postProjectIdEndpointSlugV1Systemone, options: self.options(body, options)) }
    public func speech<T: Encodable>(_ body: T, options: RequestOptions = .init()) async throws -> APIResponse { try await client.send(Operations.postProjectIdEndpointSlugV1AudioSpeech, options: self.options(body, options)) }
    public func streamChat<T: Encodable>(_ body: T, options: RequestOptions = .init()) async throws -> EventStream { try await client.stream(Operations.chatCompletionsCreate, options: self.options(streaming(body, key:"stream", value:true), options)) }
    public func streamResponses<T: Encodable>(_ body: T, options: RequestOptions = .init()) async throws -> EventStream { try await client.stream(Operations.responsesCreate, options: self.options(streaming(body, key:"stream", value:true), options)) }
    public func streamSpeech<T: Encodable>(_ body: T, options: RequestOptions = .init()) async throws -> EventStream { try await client.stream(Operations.postProjectIdEndpointSlugV1AudioSpeech, options: self.options(streaming(body, key:"stream_format", value:"sse"), options)) }
    private func audio(_ operation: Operation, _ body: AudioTranscriptionRequest, options: RequestOptions) async throws -> APIResponse {
        guard options.body == nil, options.contentType == nil else { throw ErebineError.invalid("Audio helper builds its multipart body and content type") }
        guard !body.fields.contains(where: { $0.0 == "model" || $0.0 == "file" }) else { throw ErebineError.invalid("Additional audio fields cannot replace model or file") }
        var form = Multipart(); try form.field("model", value: body.model)
        try form.file("file", filename: body.file.filename, contentType: body.file.contentType, bytes: body.file.data)
        for (name, value) in body.fields { try form.field(name, value: value) }
        return try await client.send(operation, options: form.options(parameters: options.parameters, query: options.query, headers: options.headers))
    }
    public func transcribe(_ body: AudioTranscriptionRequest, options: RequestOptions = .init()) async throws -> APIResponse { try await audio(Operations.postProjectIdEndpointSlugV1AudioTranscriptions, body, options: options) }
    public func translate(_ body: AudioTranscriptionRequest, options: RequestOptions = .init()) async throws -> APIResponse { try await audio(Operations.postProjectIdEndpointSlugV1AudioTranslations, body, options: options) }
    public func cancelChat(_ id: String, options: RequestOptions = .init()) async throws -> APIResponse {
        var options = options; options.parameters["id"] = id
        return try await client.send(Operations.postProjectIdEndpointSlugV1ChatCompletionsId, options: options)
    }
    public func cancelResponse(_ id: String, options: RequestOptions = .init()) async throws -> APIResponse {
        var options = options; options.parameters["id"] = id
        return try await client.send(Operations.postProjectIdEndpointSlugV1ResponsesIdCancel, options: options)
    }
}
extension Client { public var inference: Inference { Inference(client: self) } }
