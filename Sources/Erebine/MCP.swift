import Foundation

/// Request/response MCP sessions over Streamable HTTP (2025-06-18).
/// Supports JSON and finite SSE POST responses. Does not advertise sampling,
/// elicitation, roots, subscription listeners, or resumable reconnection.
public actor MCPSession {
    private let client: Client
    private var sessionID: String?
    private var nextID: Int64 = 2
    private var closed = false
    public let initialization: JSONValue
    private init(client: Client, sessionID: String?, initialization: JSONValue) {
        self.client = client; self.sessionID = sessionID; self.initialization = initialization
    }
    public static func connect(_ client: Client) async throws -> MCPSession {
        let body: JSONValue = ["jsonrpc":"2.0", "id":1, "method":"initialize", "params":["protocolVersion":"2025-06-18", "capabilities":[:], "clientInfo":["name":"erebine-swift", "version":"0.1.0"]]]
        let response = try await client.send(Operations.mcpPost, options: .json(body, headers:["Accept":"application/json, text/event-stream"]))
        let result = try decode(response, id: 1)
        guard result["protocolVersion"]?.string == "2025-06-18" else { throw ErebineError.invalid("Unsupported negotiated MCP protocol version") }
        let session = MCPSession(client: client, sessionID: response.headers["mcp-session-id"], initialization: result)
        try await session.notify("notifications/initialized")
        return session
    }
    private func headers() throws -> [String: String] {
        guard !closed else { throw ErebineError.invalid("MCP session is closed") }
        var headers = ["Accept":"application/json, text/event-stream", "MCP-Protocol-Version":"2025-06-18"]
        if let sessionID { headers["Mcp-Session-Id"] = sessionID }
        return headers
    }
    /// Return the JSON-RPC result; tool schemas and unknown fields are preserved.
    public func call(_ method: String, params: JSONValue = [:]) async throws -> JSONValue {
        let id = nextID
        guard nextID < Int64.max else { throw ErebineError.invalid("MCP request ID exhausted") }
        nextID += 1
        let request: JSONValue = ["jsonrpc":"2.0", "id":.integer(id), "method":.string(method), "params":params]
        let response = try await client.send(Operations.mcpPost, options: .json(request, headers: headers()))
        return try Self.decode(response, id: id)
    }
    public func notify(_ method: String, params: JSONValue? = nil) async throws {
        var body: [String: JSONValue] = ["jsonrpc":"2.0", "method":.string(method)]
        if let params { body["params"] = params }
        let response = try await client.send(Operations.mcpPost, options: .json(JSONValue.object(body), headers: headers()))
        guard response.status == 202, response.body.isEmpty else { throw ErebineError.invalid("MCP notification expected empty HTTP 202") }
    }
    /// Pagination is explicit: pass nextCursor on the next call.
    public func listTools(cursor: String? = nil) async throws -> JSONValue {
        try await call("tools/list", params: cursor.map { ["cursor":.string($0)] } ?? [:])
    }
    public func callTool(_ name: String, arguments: JSONValue = [:]) async throws -> JSONValue {
        try await call("tools/call", params:["name":.string(name), "arguments":arguments])
    }
    /// Explicit session termination. A server may refuse DELETE with HTTP 405.
    public func close() async throws {
        if closed { return }
        if sessionID != nil { _ = try await client.send(Operations.mcpDelete, options: .init(headers: headers())) }
        closed = true
    }
    private static func decode(_ response: APIResponse, id: Int64) throws -> JSONValue {
        let kind = response.headers["content-type"]?.split(separator:";").first?.trimmingCharacters(in:.whitespaces)
        let messages: [JSONValue]
        switch kind {
        case "application/json": messages = [try response.json()]
        case "text/event-stream":
            var decoder = SSEDecoder(); messages = try decoder.push(response.body).map { try $0.json() }
        default: throw ErebineError.invalid("MCP expected JSON or SSE response")
        }
        guard let message = messages.first(where: { $0["id"] == .integer(id) && ($0["result"] != nil || $0["error"] != nil) }), message["jsonrpc"]?.string == "2.0" else { throw ErebineError.invalid("MCP response ID missing, mismatched, or invalid") }
        if let error = message["error"] { throw ErebineError.rpc(error) }
        return message["result"]!
    }
}
