import Foundation
import Erebine

@main struct ManagementSmoke {
    static func resolve(_ value: JSONValue, _ vars: [String: JSONValue]) throws -> JSONValue {
        switch value {
        case .string(let s):
            if s.hasPrefix("${"),s.hasSuffix("}"),s.components(separatedBy:"${").count==2 {
                let name=String(s.dropFirst(2).dropLast());guard let value=vars[name] else {throw ErebineError.invalid("Missing scenario variable")};return value
            }
            var result=s
            for (name,value) in vars {if let text=value.string {result=result.replacingOccurrences(of:"${"+name+"}",with:text)}}
            guard !result.contains("${") else {throw ErebineError.invalid("Missing interpolated variable")};return .string(result)
        case .array(let a):return .array(try a.map{try resolve($0,vars)})
        case .object(let o):return .object(try o.mapValues{try resolve($0,vars)})
        default:return value
        }
    }
    static func pointer(_ body: JSONValue, _ pointer: String) -> JSONValue? {
        var current=body
        for part in pointer.split(separator:"/") {
            let name=String(part).replacingOccurrences(of:"~1",with:"/").replacingOccurrences(of:"~0",with:"~")
            switch current {
            case .object(let o):guard let value=o[name] else {return nil};current=value
            case .array(let a):guard let i=Int(name),a.indices.contains(i) else {return nil};current=a[i]
            default:return nil
            }
        }
        return current
    }
    static func pollReady(_ body: JSONValue?, _ step: JSONValue, _ poll: JSONValue) -> Bool {
        if let path=poll["pointer"]?.string,case .array(let values)=poll["values"],let body,let value=pointer(body,path) {return values.contains(value)}
        if let spec=step["save_match"],let body,case .array(let items)=pointer(body,spec["pointer"]!.string!) {
            return items.contains { item in
                let a=item[spec["field"]!.string!];let b=spec["equals"]
                return a == b || (spec["uuid_compare"] == true && a?.string.flatMap(UUID.init(uuidString:)) == b?.string.flatMap(UUID.init(uuidString:)) && b?.string.flatMap(UUID.init(uuidString:)) != nil)
            }
        }
        return false
    }
    static func run() async throws {
        guard let origin=ProcessInfo.processInfo.environment["EREBINE_MANAGEMENT_PROXY"],origin.hasPrefix("http://127.0.0.1:"),let url=URL(string:origin) else {throw ErebineError.invalid("Management validation requires a loopback proxy")}
        let bootstrap=try Client(origin:url)
        let configResponse=try await bootstrap.send(method:"GET",path:"/__management/config",options:.init(query:[URLQueryItem(name:"client",value:"swift")]))
        guard case .object(var vars)=try configResponse.json(),let project=vars["project_id"]?.string else {throw ErebineError.invalid("Proxy configuration missing")}
        let client=try Client(origin:url,projectID:project)
        let source=URL(fileURLWithPath:#filePath).deletingLastPathComponent().deletingLastPathComponent().deletingLastPathComponent().appendingPathComponent("api/management-scenarios.json")
        let selected = ProcessInfo.processInfo.environment["EREBINE_MANAGEMENT_SCENARIOS"].map { URL(fileURLWithPath: $0) } ?? source
        let scenarios=try JSONDecoder().decode(JSONValue.self,from:Data(contentsOf:selected))
        guard case .array(let steps)=scenarios["steps"] else {throw ErebineError.invalid("Scenarios missing")}
        var results:[JSONValue]=[];var cleanup:[JSONValue]=[];var cleanedPaths=Set<String>()
        for original in steps {
            let name=original["name"]!.string!
            let step:JSONValue
            var requestSpec=original
            if case .object(var object)=requestSpec {object.removeValue(forKey:"cleanup");requestSpec = .object(object)}
            do {step=try resolve(requestSpec,vars)} catch {results.append(["name":.string(name),"result":"skipped_dependency"]);continue}
            guard let operation=Operations.all.first(where:{$0.name==step["operation"]?.string}),case .object(let params)=step["parameters"] else {throw ErebineError.invalid("Scenario operation missing")}
            var options=RequestOptions(parameters:params.mapValues{$0.string!})
            if case .object(let h)=step["headers"] {options.headers=h.mapValues{$0.string!}}
            if case .array(let pairs) = step["query"] {
                options.query = pairs.map { pair in guard case .array(let p) = pair else { preconditionFailure("Invalid query pair") }; return URLQueryItem(name: p[0].string!, value: p[1].string!) }
            }
            if let encoded=step["body_base64"]?.string {
                guard let data=Data(base64Encoded:encoded) else { throw ErebineError.invalid("Invalid base64 fixture") }
                options.body=data; options.contentType=step["content_type"]?.string ?? "application/octet-stream"
            }
            if let body=step["body"] {options.body=try JSONEncoder().encode(body);options.contentType="application/json"}
            if let form=step["multipart"] {
                var multipart=Multipart()
                if case .array(let fields)=form["fields"] {for item in fields {guard case .array(let pair)=item else {continue};try multipart.field(pair[0].string!,value:pair[1].string!)}}
                let file=form["file"]!;try multipart.file(file["field"]!.string!,filename:file["filename"]!.string!,contentType:file["content_type"]!.string!,bytes:Data(file["text"]!.string!.utf8))
                options=multipart.options(parameters:options.parameters,headers:options.headers)
            }
            if case .integer(let ms)=step["delay_ms"], ms>0 { try await Task.sleep(nanoseconds:UInt64(min(ms,5000))*1_000_000) }
            do {
                var response=try await client.send(operation,options:options)
                var pollFailed=false
                if let poll=step["poll"] {
                    guard operation.method=="GET" else {throw ErebineError.invalid("Polling is limited to GET requests")}
                    let attempts:Int;if case .integer(let n)=poll["attempts"] {attempts=Int(max(1,min(n,300)))}else{attempts=20}
                    let ms:Int64;if case .integer(let n)=poll["delay_ms"] {ms=max(100,min(n,2000))}else{ms=1000}
                    for _ in 1..<attempts {
                        if pollReady(try? response.json(),step,poll){break}
                        try await Task.sleep(nanoseconds:UInt64(ms)*1_000_000)
                        do {response=try await client.send(operation,options:options)}catch{pollFailed=true;break}
                    }
                }
                if let poll=step["poll"] {pollFailed = pollFailed || !pollReady(try? response.json(),step,poll)}
                let body=try? response.json();var passed=step["expected_error"] == nil && !pollFailed
                if operation.method == "DELETE",let path=try client.prepare(operation,options:options).url?.path {cleanedPaths.insert(path)}
                if case .array(let statuses)=step["expected_status"] { passed=passed && statuses.contains(.integer(Int64(response.status))) }
                if let spec=step["save_match"] {
                    var selected:JSONValue?
                    if let body, case .array(let items)=pointer(body,spec["pointer"]!.string!) {
                        selected=items.first(where: { $0[spec["field"]!.string!] == spec["equals"] || (spec["uuid_compare"] == true && $0[spec["field"]!.string!]?.string.flatMap(UUID.init(uuidString:)) == spec["equals"]?.string.flatMap(UUID.init(uuidString:)) && spec["equals"]?.string.flatMap(UUID.init(uuidString:)) != nil) }).flatMap { pointer($0,spec["value_pointer"]!.string!) }
                    }
                    if let selected, selected.string != nil { vars[spec["variable"]!.string!] = selected } else { passed=false }
                }
                if case .object(let save)=original["save"] {
                    for (key,paths) in save {
                        guard case .array(let pointers)=paths else {passed=false;continue}
                        let found=pointers.compactMap{p in body.flatMap{pointer($0,p.string!)}}.first(where:{$0.string != nil})
                        if let found {vars[key]=found} else {passed=false}
                    }
                    if let spec=original["cleanup"] {if let spec=try? resolve(spec,vars){cleanup.append(spec)}else{passed=false}}
                }
                if let spec=step["cleanup_matching"] {
                    if let body, case .array(let items)=pointer(body,spec["pointer"]!.string!) {
                        for item in items where item[spec["field"]!.string!]?.string?.hasPrefix(spec["prefix"]!.string!) == true {
                            if let id=item["id"]?.string { cleanup.append(["method":"DELETE","path":.string(spec["path"]!.string!.replacingOccurrences(of:"{id}",with:id))]) }
                        }
                    } else { passed=false }
                }
                if case .object(let assertions)=step["assertions"] {for (p,expected) in assertions {passed = passed && body.flatMap{pointer($0,p)}==expected}}
                if case .object(let assertions)=step["contains"] {for (p,expected) in assertions {passed = passed && body.flatMap {pointer($0,p)}?.string?.contains(expected.string!) == true}}
                if let text=step["expected_text"]?.string {passed = passed && String(data:response.body,encoding:.utf8)==text}
                if case .object(let lengths)=step["min_array_lengths"] {for (p,min) in lengths {guard case .integer(let count)=min,case .array(let values)=body.flatMap({pointer($0,p)}) else {passed=false;continue};passed = passed && values.count>=count}}
                var record:[String:JSONValue]=["name":.string(name),"status":.integer(Int64(response.status)),"result":.string(passed ? "passed":"response_contract_failed")]
                if case .object(let fields)=body {record["json_fields"] = .array(fields.keys.sorted().map(JSONValue.string))}
                results.append(.object(record))
            } catch ErebineError.api(let status,_,let data) {
                let body=try? JSONDecoder().decode(JSONValue.self,from:data)
                let code=body?["error"]?["code"]?.string
                var expected=false
                if step["expected_error"]?["status"] == .integer(Int64(status)) { if case .array(let codes)=step["expected_error"]?["codes"], let code { expected=codes.contains(.string(code)) } else {expected=true} }
                var record:[String:JSONValue]=["name":.string(name),"status":.integer(Int64(status)),"result":.string(expected ? "expected_rejection" : code == "no_active_endpoint" ? "environment_unavailable":"http_failed")]
                if let code=body?["error"]?["code"]?.string {record["code"] = .string(code)}
                results.append(.object(record))
            } catch {results.append(["name":.string(name),"result":"transport_failed"])}
        }
        var cleanupResults:[JSONValue]=[]
        for spec in cleanup.reversed() {
            var path=spec["path"]!.string!
            for (name,value) in vars {if let text=value.string {path=path.replacingOccurrences(of:"{"+name+"}",with:text)}}
            guard cleanedPaths.insert(path).inserted else {continue}
            var options=RequestOptions()
            if case .object(let h)=spec["headers"] {options.headers=h.mapValues{$0.string!}}
            do {let response=try await client.send(method:spec["method"]!.string!,path:path,options:options);cleanupResults.append(["status":.integer(Int64(response.status)),"result":"passed"])}
            catch ErebineError.api(let status,_,_) {cleanupResults.append(["status":.integer(Int64(status)),"result":.string(status==404 ? "already_absent":"failed")])}
            catch {cleanupResults.append(["result":"transport_failed"])}
        }
        let result:JSONValue=["sdk":"swift","steps":.array(results),"cleanup":.array(cleanupResults)]
        print(String(data:try JSONEncoder().encode(result),encoding:.utf8)!)
        let failed=results.contains { ["http_failed","transport_failed","response_contract_failed"].contains($0["result"]?.string ?? "") } || cleanupResults.contains { ["failed","transport_failed"].contains($0["result"]?.string ?? "") }
        if failed { throw ErebineError.invalid("Live validation has failed checks or cleanup") }
    }
    static func main() async {do {try await run()}catch {FileHandle.standardError.write(Data("Management validation could not complete; no credential values logged.\n".utf8)); exit(1)}}
}
