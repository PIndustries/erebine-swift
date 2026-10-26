import Foundation
/// Native WebSocket transcription. Use an endpoint with task_mode=realtime.
/// Session errors remain JSON events; the caller decides whether to continue.
public final class RealtimeSession: Sendable {
    private let client: Client
    private let task: URLSessionWebSocketTask
    init(client: Client, task: URLSessionWebSocketTask) { self.client = client; self.task = task }
    public var response: HTTPURLResponse? { task.response as? HTTPURLResponse }
    public func send(_ message: URLSessionWebSocketTask.Message) async throws {
        try await withTaskCancellationHandler { try await task.send(message) } onCancel: { task.cancel(with:.goingAway, reason:nil) }
    }
    public func sendJSON<T: Encodable>(_ body: T) async throws {
        let data = try JSONEncoder().encode(body)
        guard let text = String(data: data, encoding: .utf8) else { throw ErebineError.invalid("WebSocket JSON is not UTF-8") }
        try await send(.string(text))
    }
    public func configureTranscription(model: String, inputAudioFormat: String = "pcm16") async throws {
        let body: JSONValue = ["type":"session.update", "session":["type":"transcription", "input_audio_format":.string(inputAudioFormat), "input_audio_transcription":["model":.string(model)]]]
        try await sendJSON(body)
    }
    public func appendAudio(_ data: Data) async throws { try await sendJSON(JSONValue.object(["type":"input_audio_buffer.append", "audio":.string(data.base64EncodedString())])) }
    public func commitAudio() async throws { try await sendJSON(JSONValue.object(["type":"input_audio_buffer.commit"])) }
    public func receive() async throws -> URLSessionWebSocketTask.Message {
        try await withTaskCancellationHandler { try await task.receive() } onCancel: { task.cancel(with:.goingAway, reason:nil) }
    }
    public func receiveJSON() async throws -> JSONValue {
        let data: Data
        switch try await receive() {
        case .string(let text): data = Data(text.utf8)
        case .data(let bytes): data = bytes
        @unknown default: throw ErebineError.stream("Unknown WebSocket message type")
        }
        return try JSONDecoder().decode(JSONValue.self, from: data)
    }
    public func close(code: URLSessionWebSocketTask.CloseCode = .normalClosure, reason: Data? = nil) { task.cancel(with: code, reason: reason) }
}
extension Client {
    /// Awaits a protocol ping/pong so handshake failures surface at connection time.
    public func realtime(options: RequestOptions = .init()) async throws -> RealtimeSession {
        guard surface == .router else { throw ErebineError.invalid("Realtime requires a router client") }
        guard options.body == nil else { throw ErebineError.invalid("Realtime handshake cannot contain a body") }
        var request = try prepare(method:"GET", path:"/{project_id}/{endpoint_slug}/v1/realtime", options: options)
        var components = URLComponents(url: request.url!, resolvingAgainstBaseURL:false)!
        components.scheme = components.scheme == "https" ? "wss" : "ws"; request.url = components.url
        let task = makeWebSocketTask(request); task.maximumMessageSize = 8 * 1024 * 1024; task.resume()
        do {
            try await withTaskCancellationHandler {
                try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, any Error>) in
                    task.sendPing { error in
                        if let error { continuation.resume(throwing: error) } else { continuation.resume() }
                    }
                }
                try Task.checkCancellation()
            } onCancel: { task.cancel(with:.goingAway, reason:nil) }
        } catch { task.cancel(with:.goingAway, reason:nil); throw error }
        return RealtimeSession(client:self, task:task)
    }
}
