import Foundation

public enum Surface: String, Sendable, Codable { case router, dashboard }
public struct Operation: Sendable {
    public let name: String
    public let method: String
    public let path: String
    public let surface: Surface
    public let sources: [String]
    public init(name: String, method: String, path: String, surface: Surface, sources: [String] = []) {
        self.name = name; self.method = method; self.path = path; self.surface = surface; self.sources = sources
    }
}
public enum Routing: Sendable {
    case endpoint(String)
    case direct(workspace: String? = nil)
    case semantic(workspace: String)
    var segments: [String] {
        switch self {
        case .endpoint(let slug): return [slug]
        case .direct(let workspace): return workspace.map { [$0, "_direct"] } ?? ["_direct"]
        case .semantic(let workspace): return [workspace, "_semantic", "router"]
        }
    }
}
public enum ErebineError: Error, Sendable {
    case invalid(String)
    case api(status: Int, headers: [String: String], body: Data)
    case stream(String)
    case rpc(JSONValue)
    public var requestID: String? { if case .api(_, let headers, _) = self { return headers["x-request-id"] }; return nil }
    public var retryAfter: String? { if case .api(_, let headers, _) = self { return headers["retry-after"] }; return nil }
    public var apiBody: JSONValue? { if case .api(_, _, let body) = self { return try? JSONDecoder().decode(JSONValue.self, from: body) }; return nil }
}
public struct APIResponse: Sendable {
    public let status: Int
    /// Header keys are lowercased.
    public let headers: [String: String]
    public let body: Data
    public var requestID: String? { headers["x-request-id"] }
    public func decode<T: Decodable>(_ type: T.Type = T.self, decoder: JSONDecoder = JSONDecoder()) throws -> T { try decoder.decode(type, from: body) }
    public func json() throws -> JSONValue { try decode(JSONValue.self) }
}
public struct RequestOptions: Sendable {
    public var parameters: [String: String]
    /// Use URLQueryItem to retain repeated names, ordering, and empty values.
    public var query: [URLQueryItem]
    public var headers: [String: String]
    public var body: Data?
    public var contentType: String?
    public init(parameters: [String: String] = [:], query: [URLQueryItem] = [], headers: [String: String] = [:], body: Data? = nil, contentType: String? = nil) {
        self.parameters = parameters; self.query = query; self.headers = headers; self.body = body; self.contentType = contentType
    }
    public static func json<T: Encodable>(_ value: T, parameters: [String: String] = [:], query: [URLQueryItem] = [], headers: [String: String] = [:]) throws -> Self {
        Self(parameters: parameters, query: query, headers: headers, body: try JSONEncoder().encode(value), contentType: "application/json")
    }
}
// Redirects remain visible to the caller. URLSession must never forward credentials
// automatically, including session cookies or project keys on dashboard surfaces.
private final class NoRedirect: NSObject, URLSessionTaskDelegate, Sendable {
    func urlSession(_ session: URLSession, task: URLSessionTask, willPerformHTTPRedirection response: HTTPURLResponse, newRequest request: URLRequest, completionHandler: @escaping @Sendable (URLRequest?) -> Void) { completionHandler(nil) }
}
public struct Client: Sendable {
    private let origin: URL
    public let surface: Surface
    private let projectID: String?
    private let routing: Routing?
    private let omitProject: Bool
    private let headers: [String: String]
    private let session: URLSession
    public init(origin: URL = URL(string: "https://api.erebine.ai")!, surface: Surface = .router, apiKey: String? = nil, projectID: String? = nil, routing: Routing? = nil, customDomain: Bool = false, headers: [String: String] = [:], timeout: TimeInterval = 300) throws {
        guard let parts = URLComponents(url: origin, resolvingAgainstBaseURL: false), ["http", "https"].contains(parts.scheme ?? ""), parts.host != nil,
              (parts.path.isEmpty || parts.path == "/"), parts.user == nil, parts.password == nil, parts.query == nil, parts.fragment == nil else {
            throw ErebineError.invalid("Expected an HTTP(S) origin without path, credentials, query, or fragment")
        }
        self.origin = origin; self.surface = surface; self.projectID = projectID; self.routing = routing; self.omitProject = customDomain
        var h = headers
        if let apiKey { h["Authorization"] = "Bearer \(apiKey)" }
        for (name, value) in h { try Self.validateHeader(name, value) }
        self.headers = h
        let config = URLSessionConfiguration.ephemeral
        config.httpShouldSetCookies = false
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        config.timeoutIntervalForRequest = timeout
        config.timeoutIntervalForResource = timeout
        self.session = URLSession(configuration: config, delegate: NoRedirect(), delegateQueue: nil)
    }
    public func prepare(_ operation: Operation, options: RequestOptions = .init()) throws -> URLRequest {
        guard operation.surface == surface else { throw ErebineError.invalid("Operation and client authentication surfaces differ") }
        return try prepare(method: operation.method, path: operation.path, options: options)
    }
    /// Origin-relative escape hatch for operations not yet in the reviewed catalog.
    public func prepare(method: String, path: String, options: RequestOptions = .init()) throws -> URLRequest {
        guard !method.isEmpty, method.utf8.allSatisfy({ (65...90).contains($0) || (97...122).contains($0) }), path.hasPrefix("/"), !path.hasPrefix("//"), !path.contains("?"), !path.contains("#"), !path.contains("\\") else { throw ErebineError.invalid("Invalid method or path template") }
        var encoded: [String] = []
        for part in path.dropFirst().split(separator: "/", omittingEmptySubsequences: false).map(String.init) {
            if part.hasPrefix("{"), part.hasSuffix("}") {
                let name = String(part.dropFirst().dropLast())
                if name == "project_id", omitProject { continue }
                if name == "endpoint_slug", options.parameters[name] == nil, let routing {
                    encoded += try routing.segments.map(Self.escape); continue
                }
                guard let value = options.parameters[name] ?? (name == "project_id" ? projectID : nil) else { throw ErebineError.invalid("Missing path parameter \(name)") }
                if name == "relative_path" || name == "path" {
                    encoded += try value.split(separator: "/", omittingEmptySubsequences: false).map { try Self.escape(String($0)) }
                } else { encoded.append(try Self.escape(value)) }
            } else {
                guard !part.contains("{"), !part.contains("}") else { throw ErebineError.invalid("Malformed path template") }
                encoded.append(try Self.escape(part))
            }
        }
        var parts = URLComponents(url: origin, resolvingAgainstBaseURL: false)!
        parts.percentEncodedPath = "/" + encoded.joined(separator: "/")
        if !options.query.isEmpty {
            parts.queryItems = options.query
            parts.percentEncodedQuery = parts.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        }
        guard let url = parts.url else { throw ErebineError.invalid("Invalid URL") }
        var request = URLRequest(url: url); request.httpMethod = method
        for (name, value) in headers { request.setValue(value, forHTTPHeaderField: name) }
        for (name, value) in options.headers { try Self.validateHeader(name, value); request.setValue(value, forHTTPHeaderField: name) }
        if let contentType = options.contentType { try Self.validateHeader("Content-Type", contentType); request.setValue(contentType, forHTTPHeaderField: "Content-Type") }
        request.httpBody = options.body
        return request
    }
    public func send(_ operation: Operation, options: RequestOptions = .init()) async throws -> APIResponse {
        try await execute(prepare(operation, options: options))
    }
    public func send(method: String, path: String, options: RequestOptions = .init()) async throws -> APIResponse {
        try await execute(prepare(method: method, path: path, options: options))
    }
    private func execute(_ request: URLRequest) async throws -> APIResponse {
        let (body, response) = try await session.data(for: request)
        let (status, headers) = try Self.metadata(response)
        guard (200..<300).contains(status) else { throw ErebineError.api(status: status, headers: headers, body: body) }
        return APIResponse(status: status, headers: headers, body: body)
    }
    /// Demand-driven AsyncSequence: reads events as the consumer asks for them.
    /// Cancelling the consuming Task cancels URLSession reads. Use the server's
    /// cancellation operation to stop generation, not just its network stream.
    public func stream(_ operation: Operation, options: RequestOptions = .init()) async throws -> EventStream {
        var request = try prepare(operation, options: options)
        request.setValue("text/event-stream", forHTTPHeaderField: "Accept")
        let (bytes, response) = try await session.bytes(for: request)
        let (status, headers) = try Self.metadata(response)
        guard (200..<300).contains(status) else {
            var body = Data(); for try await byte in bytes { body.append(byte) }
            throw ErebineError.api(status: status, headers: headers, body: body)
        }
        guard headers["content-type"]?.split(separator: ";").first?.trimmingCharacters(in: .whitespaces).lowercased() == "text/event-stream" else { throw ErebineError.stream("Expected text/event-stream") }
        return EventStream(status: status, headers: headers, bytes: bytes)
    }
    private static func metadata(_ response: URLResponse) throws -> (Int, [String: String]) {
        guard let response = response as? HTTPURLResponse else { throw ErebineError.invalid("Expected HTTP response") }
        var headers: [String: String] = [:]
        for (key, value) in response.allHeaderFields { headers[String(describing: key).lowercased()] = String(describing: value) }
        return (response.statusCode, headers)
    }
    private static func escape(_ value: String) throws -> String {
        guard !value.isEmpty, value != ".", value != "..", !value.unicodeScalars.contains(where: CharacterSet.controlCharacters.contains) else { throw ErebineError.invalid("Empty, dot, or control-character path segment") }
        let allowed = CharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~")
        guard let escaped = value.addingPercentEncoding(withAllowedCharacters: allowed) else { throw ErebineError.invalid("Unencodable path parameter") }
        return escaped
    }
    private static func validateHeader(_ name: String, _ value: String) throws {
        let token = CharacterSet(charactersIn: "!#$%&'*+-.^_`|~0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz")
        guard !name.isEmpty, name.unicodeScalars.allSatisfy(token.contains), !value.unicodeScalars.contains(where: { $0.value < 32 && $0.value != 9 || $0.value == 127 }) else { throw ErebineError.invalid("Invalid header") }
    }
}

extension Client: CustomStringConvertible, CustomDebugStringConvertible {
    public var description: String { "Erebine.Client(origin: \(origin), surface: \(surface.rawValue))" }
    public var debugDescription: String { description }
}
