import Foundation
public struct ServerEvent: Sendable, Equatable {
    public let event: String?
    public let data: String
    public let id: String?
    public let retry: UInt64?
    public func json() throws -> JSONValue { try JSONDecoder().decode(JSONValue.self, from: Data(data.utf8)) }
}
/// Incremental decoder; 8 MiB per event. Unknown event names are preserved.
public struct SSEDecoder: Sendable {
    private var line: [UInt8] = []
    private var data = ""
    private var event: String?
    private var id: String?
    private var retry: UInt64?
    private var skipLF = false
    private var started = false
    private var size = 0
    public init() {}
    public mutating func push(_ bytes: some Sequence<UInt8>) throws -> [ServerEvent] {
        var events: [ServerEvent] = []
        for byte in bytes {
            if skipLF { skipLF = false; if byte == 10 { continue } }
            if byte == 13 || byte == 10 {
                try processLine(&events); skipLF = byte == 13
            } else {
                line.append(byte)
                guard line.count + size <= 8 * 1024 * 1024 else { throw ErebineError.stream("SSE event exceeds 8 MiB") }
            }
        }
        return events
    }
    private mutating func processLine(_ events: inout [ServerEvent]) throws {
        guard var text = String(bytes: line, encoding: .utf8) else { throw ErebineError.stream("Invalid UTF-8") }
        line.removeAll(keepingCapacity: true)
        if !started { if text.hasPrefix("\u{feff}") { text.removeFirst() }; started = true }
        if text.isEmpty {
            if !data.isEmpty {
                data.removeLast()
                events.append(ServerEvent(event: event, data: data, id: id, retry: retry)); data = ""
            }
            event = nil; retry = nil; size = 0; return
        }
        if text.hasPrefix(":") { return }
        size += text.utf8.count
        guard size <= 8 * 1024 * 1024 else { throw ErebineError.stream("SSE event exceeds 8 MiB") }
        let parts = text.split(separator: ":", maxSplits: 1, omittingEmptySubsequences: false)
        let field = String(parts[0]); var value = parts.count == 2 ? String(parts[1]) : ""
        if value.hasPrefix(" ") { value.removeFirst() }
        switch field {
        case "data": data += value + "\n"
        case "event": event = value
        case "id" where !value.contains("\0"): id = value
        case "retry" where !value.isEmpty && value.utf8.allSatisfy({ (48...57).contains($0) }): retry = UInt64(value)
        default: break
        }
    }
    /// SSE EOF discards an event lacking a blank-line terminator.
    public mutating func finish() { line.removeAll(); data = "" }
}
public struct EventStream: AsyncSequence {
    public typealias Element = ServerEvent
    public let status: Int
    public let headers: [String: String]
    private let bytes: URLSession.AsyncBytes
    init(status: Int, headers: [String: String], bytes: URLSession.AsyncBytes) { self.status = status; self.headers = headers; self.bytes = bytes }
    public struct AsyncIterator: AsyncIteratorProtocol {
        private var bytes: URLSession.AsyncBytes.AsyncIterator
        private var decoder = SSEDecoder()
        private var done = false
        init(_ bytes: URLSession.AsyncBytes.AsyncIterator) { self.bytes = bytes }
        public mutating func next() async throws -> ServerEvent? {
            if done { return nil }
            do {
                while let byte = try await bytes.next() {
                    try Task.checkCancellation()
                    if let event = try decoder.push([byte]).first {
                        if event.data == "[DONE]" { done = true; return nil }
                        return event
                    }
                }
                done = true; decoder.finish(); return nil
            } catch { done = true; throw error }
        }
    }
    public func makeAsyncIterator() -> AsyncIterator { AsyncIterator(bytes.makeAsyncIterator()) }
}
