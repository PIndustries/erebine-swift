# Native MCP sessions

Both SDKs speak MCP Streamable HTTP (2025-06-18) at the project MCP route.
Initialization, protocol/session headers, JSON/finite-SSE POST responses,
initialized notification, tool discovery/calls, prompts, resources, resource
templates, ping, subscriptions, GET events, and explicit session termination are
implemented. JSON results retain vendor fields. Cursor pagination is explicit.

## Rust

```rust
let mut session = erebine::mcp::McpSession::connect(client).await?;
let prompts = session.list_prompts(None).await?;
let resources = session.list_resources(None).await?;
let templates = session.list_resource_templates(None).await?;
let result = session.read_resource(resource_uri).await?;
let prompt = session.get_prompt("prompt_name", Default::default()).await?;
// Only when the server advertises subscription support:
session.subscribe_resource(resource_uri).await?;
let mut events = session.events(None).await?;
// Consume with futures_util::StreamExt; each event retains id/event/data/retry.
// After a disconnect, open events(Some(last_event_id)) to request resume.
session.unsubscribe_resource(resource_uri).await?;
session.close().await?;
```

## Swift

```swift
let session = try await MCPSession.connect(client)
let prompts = try await session.listPrompts()
let resources = try await session.listResources()
let templates = try await session.listResourceTemplates()
let result = try await session.readResource(resourceURI)
let prompt = try await session.getPrompt("prompt_name", arguments: [:])
// Only when the server advertises subscription support:
_ = try await session.subscribeResource(resourceURI)
let events = try await session.events(lastEventID: nil)
for try await event in events {
    let message = try event.json()
    // Dispatch a notification in your application; retain event.id for resume.
}
_ = try await session.unsubscribeResource(resourceURI)
try await session.close()
```

Pass `nextCursor` from a listing response into that method's `cursor` argument.
`call` remains available for arbitrary JSON-RPC methods and `notify` for client
notifications. Read `initialization` for server capabilities. A server may return
405 for GET or DELETE; the structured HTTP error is preserved. Resume requests
send `Last-Event-ID` together with the negotiated session/protocol headers.

The application owns reconnection, backoff, notification dispatch, and eventual
session cleanup. The SDK never reruns a tool/RPC, executes a received request, or
advertises client sampling/roots/elicitation capabilities. POST SSE response
handling expects a finite response stream. Resource subscriptions and GET/resume
are locally protocol-tested; successful behavior on a particular deployment
requires that server to advertise and implement the capability.

Protocol references: [Streamable HTTP](https://modelcontextprotocol.io/specification/2025-06-18/basic/transports),
[resources](https://modelcontextprotocol.io/specification/2025-06-18/server/resources),
[prompts](https://modelcontextprotocol.io/specification/2025-06-18/server/prompts).

Opt-in native read-only live drivers are `examples/mcp_live_smoke.rs` and
`Examples/MCPLiveSmoke/MCPLiveSmoke.swift` (`ErebineMCPLiveSmoke`). They use the
same credential-injecting loopback boundary as the management driver, create an
isolated workspace, report only check outcomes, and remove the workspace.
