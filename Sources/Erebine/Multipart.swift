import Foundation
/// In-memory multipart body suitable for files/audio. Large chunked uploads can use
/// RequestOptions.body directly with application/octet-stream and checksum headers.
public struct Multipart: Sendable {
    public let boundary: String
    private var data = Data()
    public init() { boundary = "erebine-" + UUID().uuidString }
    public mutating func field(_ name: String, value: String) throws {
        try part(name, filename: nil, contentType: nil, bytes: Data(value.utf8))
    }
    public mutating func file(_ name: String, filename: String, contentType: String, bytes: Data) throws {
        try part(name, filename: filename, contentType: contentType, bytes: bytes)
    }
    private mutating func part(_ name: String, filename: String?, contentType: String?, bytes: Data) throws {
        for value in [name, filename, contentType].compactMap({$0}) {
            guard !value.unicodeScalars.contains(where: CharacterSet.controlCharacters.contains), !value.contains("\""), !value.contains("\\") else { throw ErebineError.invalid("Invalid multipart metadata") }
        }
        data.append(Data("--\(boundary)\r\nContent-Disposition: form-data; name=\"\(name)\"".utf8))
        if let filename { data.append(Data("; filename=\"\(filename)\"".utf8)) }
        if let contentType { data.append(Data("\r\nContent-Type: \(contentType)".utf8)) }
        data.append(Data("\r\n\r\n".utf8)); data.append(bytes); data.append(Data("\r\n".utf8))
    }
    public func options(parameters: [String: String] = [:], query: [URLQueryItem] = [], headers: [String: String] = [:]) -> RequestOptions {
        var final = data; final.append(Data("--\(boundary)--\r\n".utf8))
        return RequestOptions(parameters: parameters, query: query, headers: headers, body: final, contentType: "multipart/form-data; boundary=\(boundary)")
    }
}
