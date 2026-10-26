import XCTest
@testable import Erebine
import Foundation

final class InferenceTests: XCTestCase {
    func testTypedInferenceRequestsAndAudioWireFormats() async throws {
        let f = try Fixture()
        let client = try Client(origin:f.origin, apiKey:"fake-fixture-key", projectID:"proj_test", routing:.endpoint("test"), headers:["X-Fixture-Echo":"1"])
        let format: JSONValue = ["type":"json_schema", "json_schema":["name":"answer", "strict":true, "schema":["type":"object"]]]
        let tools: JSONValue = [["type":"function", "function":["name":"echo", "parameters":["type":"object"]]]]
        let chat = ChatCompletionRequest(model:"fixture-model", messages:[.user("hi")], extra:["model":"bad", "x_future":["on":true], "response_format":format, "tools":tools])
        var responses: [(APIResponse, String)] = []
        responses.append((try await client.inference.chat(chat), "/v1/chat/completions"))
        responses.append((try await client.inference.responses(ResponsesRequest(model:"fixture-model", input:[["type":"function_call_output", "call_id":"call_test", "output":"ok"]])), "/v1/responses"))
        responses.append((try await client.inference.embeddings(EmbeddingRequest(model:"fixture-model", input:[[1,2],[3,4]])), "/v1/embeddings"))
        responses.append((try await client.inference.rerank(RerankRequest(model:"fixture-model", query:"question", documents:["doc", ["text":"other"]])), "/v1/rerank"))
        responses.append((try await client.inference.score(ScoreRequest(model:"fixture-model", text1:"question", text2:["doc"])), "/v1/score"))
        responses.append((try await client.inference.speech(SpeechRequest(model:"fixture-model", input:"hello", voice:"alloy")), "/v1/audio/speech"))
        responses.append((try await client.inference.systemOne(SystemOneRequest(model:"fixture-model", state:["state":"test"], questions:[:])), "/v1/systemone"))
        for (response, suffix) in responses {
            let value = try response.json(); XCTAssertTrue(value["path"]!.string!.hasSuffix(suffix))
            let body = try JSONDecoder().decode(JSONValue.self, from:Data(value["body"]!.string!.utf8))
            XCTAssertEqual(body["model"]?.string, "fixture-model")
            if suffix == "/v1/chat/completions" { XCTAssertEqual(body["response_format"], format); XCTAssertEqual(body["tools"], tools); XCTAssertEqual(body["x_future"]?["on"], true) }
        }
        var audio = AudioTranscriptionRequest(model:"fixture-model", file:AudioFile(filename:"clip.wav", contentType:"audio/wav", data:Data("RIFFfixture".utf8)), fields:[("response_format","text"),("timestamp_granularities[]","word"),("timestamp_granularities[]","segment")])
        let transcribed = try await client.inference.transcribe(audio); let translated = try await client.inference.translate(audio)
        for response in [transcribed, translated] { let wire = try response.json()["body"]!.string!; XCTAssertTrue(wire.contains("filename=\"clip.wav\"")); XCTAssertTrue(wire.contains("RIFFfixture")); XCTAssertTrue(wire.contains("timestamp_granularities[]")) }
        audio.fields.append(("model","bad"))
        do { _ = try await client.inference.transcribe(audio); XCTFail("Duplicate model accepted") } catch ErebineError.invalid { }
        let model = try await client.inference.model("org/model"); XCTAssertTrue(try model.json()["path"]!.string!.hasSuffix("/v1/models/org%2Fmodel"))
        let raw = try await f.client().inference.speech(SpeechRequest(model:"fixture-model", input:"hello", voice:"alloy"))
        XCTAssertEqual(raw.body,Data("RIFFfixtureWAVE".utf8)); XCTAssertEqual(raw.headers["content-type"],"audio/wav")
    }
    func testStreamingToolsReasoningAndUsage() async throws {
        let f = try Fixture(); let client = try f.client()
        let request: JSONValue = ["model":"fixture", "messages":[], "stream":false, "x_future":1, "stream_options":["include_usage":true]]
        let stream = try await client.inference.streamChat(request); var accumulator = ChatAccumulator()
        for try await event in stream { try accumulator.push(event) }
        XCTAssertEqual(accumulator.raw[0]["fixture_request"]?["stream"],true); XCTAssertEqual(accumulator.raw[0]["fixture_request"]?["x_future"],1)
        XCTAssertEqual(accumulator.choices[0]?.reasoning,"thinking"); XCTAssertEqual(accumulator.choices[0]?.content,"")
        XCTAssertEqual(accumulator.choices[0]?.toolCalls[0]?.arguments,"{\"a\":1}"); XCTAssertEqual(accumulator.choices[0]?.finishReason,"tool_calls"); XCTAssertEqual(accumulator.usage?["total_tokens"],5)
        let responseStream = try await client.inference.streamResponses(JSONValue.object(["model":"fixture","input":"hi"]))
        var ri = responseStream.makeAsyncIterator(); let firstResponse = try await ri.next()!
        XCTAssertEqual(try firstResponse.json()["fixture_request"]?["stream"],true)
        let speechStream = try await client.inference.streamSpeech(SpeechRequest(model:"fixture",input:"hi",voice:"alloy"))
        var si = speechStream.makeAsyncIterator(); let firstSpeech = try await si.next()!
        XCTAssertEqual(try firstSpeech.json()["fixture_request"]?["stream_format"],"sse")
    }
    func testStreamInterleavingAndToolResults() throws {
        let data = Data(#"[{"choices":[{"index":1,"delta":{"content":"B","refusal":"refused","reasoning_content":null,"reasoning":"R"}},{"index":0,"delta":{"tool_calls":[{"index":1,"id":"b","function":{"name":"sum","arguments":"{\"b\":"}},{"index":0,"id":"a","function":{"name":"echo","arguments":"{\"a\":"}}]}}]},{"choices":[{"index":0,"delta":{"tool_calls":[{"index":0,"function":{"arguments":"1}"}},{"index":1,"function":{"arguments":"2}"}}]}},{"index":1,"delta":{"content":"2"},"finish_reason":"future_reason"}]},{"type":"x_future","vendor":{"kept":true},"error":null}]"#.utf8)
        let events = try JSONDecoder().decode([JSONValue].self,from:data); var a = ChatAccumulator()
        for event in events { try a.pushJSON(event) }
        XCTAssertEqual(a.choices[1]?.content,"B2"); XCTAssertEqual(a.choices[1]?.refusal,"refused"); XCTAssertEqual(a.choices[1]?.reasoning,"R"); XCTAssertEqual(a.choices[0]?.toolCalls[1]?.arguments,"{\"b\":2}"); XCTAssertEqual(a.raw.count,3)
        XCTAssertThrowsError(try a.pushJSON(["error":["code":"future_error"]])); XCTAssertEqual(a.raw.count,4)
        let tool = try JSONDecoder().decode(JSONValue.self,from:JSONEncoder().encode(ChatMessage.tool(callID:"call_test",output:"ok")))
        XCTAssertEqual(tool["tool_call_id"],"call_test")
        let result: JSONValue = ["output":[["type":"reasoning","text":"hidden"],["type":"message","content":[["type":"output_text","text":"hi"]]]]]
        XCTAssertEqual(result.outputText,"hi")
    }
    func testNativeRealtimeWebSocket() async throws {
        let f = try Fixture(); let client = try f.client(); let session = try await client.realtime()
        XCTAssertEqual(session.response?.value(forHTTPHeaderField:"X-Fixture-Authorization"),"Bearer fake-fixture-key")
        try await session.configureTranscription(model:"fixture-model")
        let configured = try await session.receiveJSON(); XCTAssertEqual(configured["type"],"session.updated")
        try await session.appendAudio(Data([0,255,128,1]))
        let appended = try await session.receiveJSON(); XCTAssertEqual(appended["bytes"],4)
        try await session.commitAudio()
        let delta = try await session.receiveJSON(); let completed = try await session.receiveJSON()
        XCTAssertEqual(delta["delta"],"héllo "); XCTAssertEqual(completed["transcript"],"héllo 🌎")
        try await session.sendJSON(JSONValue.object(["type":"x_future","vendor":true]))
        let echoed = try await session.receiveJSON(); XCTAssertEqual(echoed["payload"]?["vendor"],true); session.close()
    }
}

extension InferenceTests {
    func testRealtimeReadCancellationClosesSocket() async throws {
        let f = try Fixture(); let client = try f.client(); let session = try await client.realtime()
        let read = Task { try await session.receiveJSON() }
        read.cancel()
        switch await read.result {
        case .failure: break
        case .success: XCTFail("Cancelled read returned a result")
        }
    }
}
