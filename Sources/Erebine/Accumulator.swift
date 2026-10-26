import Foundation
/// Caller-owned stream assembly. No tools execute automatically. Raw event bodies
/// remain available; memory grows with the stream while this helper is in use.
public struct StreamToolCall: Sendable {
    public var id: String?
    public var kind: String?
    public var name = ""
    public var arguments = ""
}
public struct StreamChoice: Sendable {
    public var role: String?
    public var content = ""
    public var reasoning = ""
    public var refusal = ""
    public var toolCalls: [Int64: StreamToolCall] = [:]
    public var finishReason: String?
}
public struct ChatAccumulator: Sendable {
    public private(set) var id: String?
    public private(set) var model: String?
    public private(set) var choices: [Int64: StreamChoice] = [:]
    public private(set) var usage: JSONValue?
    public private(set) var raw: [JSONValue] = []
    public init() {}
    public mutating func push(_ event: ServerEvent) throws { try pushJSON(event.json()) }
    public mutating func pushJSON(_ value: JSONValue) throws {
        raw.append(value)
        guard value["error"] == nil || value["error"] == .null else { throw ErebineError.stream("Server inference error event; inspect the raw event") }
        if case .array = value["choices"] {
        if let id = value["id"]?.string { self.id = id }
        if let model = value["model"]?.string { self.model = model }
        if let usage = value["usage"], usage != .null { self.usage = usage }
        }
        if case .array(let items) = value["choices"] {
            for item in items {
                guard case .integer(let index) = item["index"], index >= 0 else { throw ErebineError.invalid("Stream choice requires an unsigned index") }
                var choice = choices[index] ?? StreamChoice(); let delta = item["delta"]
                if let role = delta?["role"]?.string { choice.role = role }
                choice.content += delta?["content"]?.string ?? ""
                choice.reasoning += (delta?["reasoning_content"]?.string ?? delta?["reasoning"]?.string) ?? ""
                choice.refusal += delta?["refusal"]?.string ?? ""
                if let reason = item["finish_reason"]?.string { choice.finishReason = reason }
                if case .array(let calls) = delta?["tool_calls"] {
                    for call in calls {
                        guard case .integer(let ti) = call["index"], ti >= 0 else { throw ErebineError.invalid("Stream tool call requires an unsigned index") }
                        var tool = choice.toolCalls[ti] ?? StreamToolCall()
                        if let id = call["id"]?.string { tool.id = id }
                        if let kind = call["type"]?.string { tool.kind = kind }
                        tool.name += call["function"]?["name"]?.string ?? ""
                        tool.arguments += call["function"]?["arguments"]?.string ?? ""
                        choice.toolCalls[ti] = tool
                    }
                }
                choices[index] = choice
            }
        }
    }
}
