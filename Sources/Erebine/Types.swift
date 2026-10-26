import Foundation
/// Optional convenience helpers. Use JSONValue to construct any documented body
/// without waiting for a typed helper to gain a new vendor field.
public struct ChatMessage: Sendable, Codable {
    public var role: String
    public var content: JSONValue
    public var extra: [String: JSONValue]
    public init(role: String, content: JSONValue, extra: [String: JSONValue] = [:]) { self.role = role; self.content = content; self.extra = extra }
    public static func user(_ text: String) -> Self { .init(role: "user", content: .string(text)) }
    public static func system(_ text: String) -> Self { .init(role: "system", content: .string(text)) }
    public init(from decoder: any Decoder) throws {
        guard case .object(var object) = try JSONValue(from: decoder), let role = object.removeValue(forKey: "role")?.string, let content = object.removeValue(forKey: "content") else { throw ErebineError.invalid("Expected message role and content") }
        self.role = role; self.content = content; self.extra = object
    }
    public func encode(to encoder: any Encoder) throws {
        var object = extra; object["role"] = .string(role); object["content"] = content
        try JSONValue.object(object).encode(to: encoder)
    }
}
public struct ChatCompletionRequest: Sendable, Encodable {
    public var model: String
    public var messages: [ChatMessage]
    public var extra: [String: JSONValue]
    public init(model: String, messages: [ChatMessage], extra: [String: JSONValue] = [:]) { self.model = model; self.messages = messages; self.extra = extra }
    public func encode(to encoder: any Encoder) throws {
        var object = extra
        object["model"] = .string(model)
        object["messages"] = try JSONDecoder().decode(JSONValue.self, from: JSONEncoder().encode(messages))
        try JSONValue.object(object).encode(to: encoder)
    }
}
