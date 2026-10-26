# Native API methods

Every catalog operation has a native method under `client.api()` in Rust and
`client.api` in Swift. Rust methods use the operation's snake_case name; Swift
uses camelCase. See `api/README.md` for the complete operation index.

Methods inherit the client's project and routing configuration. Required resource
IDs are explicit string arguments. Requests preserve unknown fields rather than
filtering them through incomplete schemas. Existing operation constants remain
available, and named inference helpers continue to provide typed requests.

## Rust

```rust
use erebine::{Client, Surface, json};
let key = std::env::var("EREBINE_API_KEY")?;
let project = std::env::var("EREBINE_PROJECT_ID")?;
let client = Client::new("https://api.erebine.ai", Surface::Router)?
    .bearer(&key)?.project(&project);
let response = client.api().get_project_id_v1_management_endpoints()
    .query("limit", 20).send().await?;
let endpoints: erebine::Value = response.json()?;
// Update an endpoint ID supplied by your application:
let request = client.api().patch_project_id_v1_management_endpoints_id(endpoint_id)
    .json(&json!({"name": "example", "x_future": true}))?;
// Send explicitly when your application intends the change:
let response = request.send().await?;
```

Rust methods return the regular request builder, including `.json()`, `.query()`,
`.header()`, `.multipart()`, `.bytes()`, `.send()`, and `.stream()`.

## Swift

```swift
import Erebine
import Foundation
let client = try Client(apiKey: key, projectID: project)
let response = try await client.api.getProjectIdV1ManagementEndpoints(
    options: .init(query: [URLQueryItem(name: "limit", value: "20")]))
let endpoints = try response.json()
let body: JSONValue = ["name": "example", "x_future": true]
let updated = try await client.api.patchProjectIdV1ManagementEndpointsId(
    id: endpointID, options: .json(body))
```

Swift methods accept `RequestOptions` for queries, headers, JSON/multipart/raw
bytes and return `APIResponse`. Explicit ID arguments take precedence over IDs
in options. Streaming uses `client.stream(Operations.operationName, options:)`.

## Routing

Workspace-scoped endpoint URLs have a dedicated variant:

```rust
let routing = erebine::Routing::WorkspaceEndpoint {
    workspace: workspace_id.to_owned(), endpoint: endpoint_slug.to_owned()
};
```

```swift
let routing = Routing.workspaceEndpoint(workspace: workspaceID, endpoint: endpointSlug)
```

Each workspace and endpoint is escaped independently. Endpoint-only, workspace
or project direct routing, workspace semantic routing, and custom domains remain
available. Project and endpoint overrides may be supplied through request
parameters. Dashboard operations must use a separate `.dashboard` client with
caller-managed session/CSRF headers; redirects are not followed automatically.

## Uploads and cancellation

The catalog exposes upload initialization, preflight, parts, file/chunk transfer,
resume/status, completion, cancellation, and deletion individually. Supply chunk
bytes and documented checksum headers through the standard request builder;
applications control file I/O, chunk sizing, polling, and retries. No upload,
provisioning, cancellation, or retry is performed implicitly.

CORS preflight is exposed as
`options_project_id_endpoint_slug_v1_chat_completions` / 
`optionsProjectIdEndpointSlugV1ChatCompletions`. Use a client without bearer
authentication when reproducing a browser preflight, and supply `Origin` and
`Access-Control-Request-Method` through request headers.
