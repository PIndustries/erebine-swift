# erebine-swift

Native Swift SDK for Erebine, maintained by P.Industries. Uses Foundation,
URLSession, async/await, and AsyncSequence. No Rust FFI or third-party runtime.
Community project; not an official Erebine SDK. MIT licensed.

**Experimental 0.1:** 268 documented HTTP operation bindings, sharing the same
catalog as [erebine-rs](https://github.com/PIndustries/erebine-rs). Full API/schema
parity is the target; documentation gaps and live verification remain. See
[COVERAGE.md](COVERAGE.md).

## Swift Package Manager

Add `https://github.com/PIndustries/erebine-swift` in Xcode, selecting the `main`
branch until a release is tagged, and link the `Erebine` product. Or add:

```swift
.package(url: "https://github.com/PIndustries/erebine-swift", branch: "main")
```

Swift 6; minimum deployment targets: macOS 12, iOS 15, tvOS 15, watchOS 8, visionOS 1.
The SDK has no package dependencies. Python 3 is used only for local HTTP tests.

## Chat

```swift
import Erebine

let client = try Client(
    apiKey: apiKey,
    projectID: projectID,
    routing: .direct(workspace: workspaceID)
)
let request = ChatCompletionRequest(model: model, messages: [.user("Hello")])
let response = try await client.send(
    Operations.chatCompletionsCreate,
    options: .json(request)
)
let result = try response.json()
```

Discover model IDs using `Operations.modelsList` on this same base. Use
`.endpoint(slug)` for an endpoint or `.semantic(workspace: id)` for the semantic
router. Pass X-Conversation-Id for multi-turn affinity. For custom API domains,
set `origin` and `customDomain: true` so the hostname supplies the project.

## Full wire access

Every catalog entry has a named `Operations` definition. See the method/path
index in [api/README.md](api/README.md); names convert snake_case to camelCase.
`JSONValue` retains unknown fields and 64-bit integers. You can also encode your
own Codable types or supply exact Data bytes. Responses keep their original body.

```swift
let body: JSONValue = ["model": .string(model), "input": "Hello", "store": true]
let response = try await client.send(Operations.responsesCreate, options: .json(body))

var multipart = Multipart()
try multipart.field("purpose", value: "batch")
try multipart.file("file", filename: "input.jsonl",
                   contentType: "application/jsonl", bytes: fileData)
let file = try await client.send(Operations.filesCreate, options: multipart.options())
```

`RequestOptions` supports path parameters, ordered/repeated `URLQueryItem`s,
headers, Data bodies, and content types. Multipart is in-memory; upload large
files as the documented resumable octet-stream chunks with checksum headers.
`Client.prepare` lets you inspect a request without submitting it. The raw
`send(method:path:options:)` escape hatch accepts origin-relative path templates.

`APIResponse` retains status, lowercased headers, and bytes. Empty 204 and binary
responses do not require JSON decoding. `ErebineError.api` retains unknown server
error envelopes, request IDs, and Retry-After. Automatic retries are disabled;
callers decide whether a request can safely be repeated. The default timeout is
300 seconds; set `timeout` when creating the client to change it.

## Streaming

```swift
let body: JSONValue = [
    "model": .string(model),
    "messages": [["role": "user", "content": "Hello"]],
    "stream": true,
    "stream_options": ["include_usage": true]
]
let stream = try await client.stream(
    Operations.chatCompletionsCreate,
    options: .json(body, headers: ["X-Erebine-Vendor-Events": "on"])
)
for try await event in stream {
    print(event.event ?? "message", event.data)
}
```

The demand-driven sequence preserves vendor event names, multiline data, IDs,
and retry fields. It terminates at `[DONE]`. Cancelling the consuming Task
cancels URLSession reads; server generation should also be stopped with its
explicit cancellation API. See [Examples/Chat.swift](Examples/Chat.swift).

## Dashboard routes

Use a separate `Client(origin: URL(string: "https://erebine.ai")!, surface:
.dashboard, headers: ...)` with caller-supplied Cookie and X-CSRF-Token as required.
Some dashboard routes use bearer authentication instead; consult their source
links. No implicit shared browser session or cookie storage is used. The SDK
rejects cross-surface operation/client pairs and returns redirects to the caller.

## Development

```sh
python3 scripts/generate.py
swift test
xcodebuild -scheme Erebine -destination 'generic/platform=iOS Simulator' CODE_SIGNING_ALLOWED=NO build
```

Local tests contact only loopback HTTP fixtures. See [coverage](COVERAGE.md),
[contributing](CONTRIBUTING.md), [security](SECURITY.md), and [NOTICE](NOTICE).
