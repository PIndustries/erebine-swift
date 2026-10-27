# Management integration and live validation

Management APIs use the project-scoped router origin, a management-scoped bearer
key, and the same native request builder as inference. Use generated operations
from `api/operations.json`; management responses remain lossless JSON. Keep keys
in an application secret provider or environment, never source code.

```swift
let env = ProcessInfo.processInfo.environment
guard let key = env["EREBINE_API_KEY"], let project = env["EREBINE_PROJECT_ID"] else {
    throw ErebineError.invalid("Missing Erebine configuration")
}
let client = try Client(apiKey: key, projectID: project)
let response = try await client.send(Operations.getProjectIdV1ManagementEndpoints)
let endpoints = try response.json()
```

The shared `api/management-scenarios.json` defines 71 checks. Native drivers are
`examples/management_smoke.rs` (Rust) and
`Examples/ManagementSmoke/ManagementSmoke.swift` (Swift). Drivers accept
`EREBINE_MANAGEMENT_PROXY=http://127.0.0.1:PORT`; the proxy supplies project ID,
a unique fixture prefix, and expiry at `GET /__management/config?client=rust`
(or `swift`), then injects authorization for upstream project requests.
The live run used an in-memory restrictive proxy: read-only discovery plus
writes to uniquely prefixed resources created by that run, with a cleanup ledger.
The SDK processes never received the account credential. The proxy is validation
infrastructure, not a required part of SDK usage. Do not point these examples at
an unrestricted production proxy.

## Verified 2026-10-26

Both SDKs independently returned the same result:

| Result | Per SDK |
| --- | ---: |
| Passed live steps | 62 |
| Environment unavailable | 1 |
| Dependent steps skipped | 8 |
| Failed steps | 0 |
| Successful fixture cleanups | 8 |

Successful workflows include management/discovery/settings/usage reads;
workspace create/read/update/visibility; template create/update/version history;
conversation create/update and message item lifecycle; multipart file upload,
metadata and exact content download; temporary API-key creation, quota, IP
filter, rotation and revocation; join-key creation/revocation; SLO CRUD/history;
and webhook configuration CRUD/history. This initial pass did not send a webhook
test delivery; the later extension below did.

All temporary workspaces, templates, conversations, files, API keys, join keys,
SLOs, and webhooks were deleted or revoked. The proxy cleanup ledger reported
zero remaining active fixtures. Services may retain audit or soft-deleted records.
Only newly created credentials were rotated/revoked.

Additional live validation requires suitably configured disposable resources and
separate administrator access. Deployment inventories, project identifiers,
account scopes, and per-account diagnostics remain internal. The later isolated-worker pass below covers execution and selected chat/endpoint
workflows. Invites, billing, and destructive infrastructure operations remain
unverified.

## Observed contract details

- API-key creation wraps metadata under `api_key`; the one-time secret is
  `raw_key`. Join-key creation returns `join_key` and a secret `token`.
- Join-key creation required `router_addresses` on this deployment.
- The IP filter accepted a literal IPv4 address; a `/32` CIDR was rejected with
  `invalid_request`. SDKs preserve supplied JSON and do not enforce either form.
- SLO numeric targets may return integral JSON numbers even when submitted as
  decimals. Scenario assertions compare the returned numeric representation.

These are observed server behaviors, not guarantees for every deployment.
Per-account live reports are retained internally. Public scenarios use only
synthetic identifiers, names, addresses, and content.

## Additional native live checks

A later live pass verified, independently in each SDK:

- 38 extended checks for checksum-verified parts, directory files, archive parts,
  upload status/resume/cancellation, model metadata, version creation/promotion/
  rollback, HF override preview, scoped template updates/deletion, and disposable
  agent metadata CRUD.
- Nine MCP checks for initialization, tools/prompts/resources/templates, prompt
  retrieval, resource reads, ping, and session close.
- Synthetic HTTPS webhook delivery, delivery history, disabling/deleting the
  test registration, and receiver-side HMAC-SHA256 verification.
- Disposable-key authentication, scope enforcement, quota responses, IP filters,
  revocation, and rejection of revoked credentials.

Workspace template details can be read through the project template GET route,
but mutations use `PATCH` and `DELETE` on
`/{project_id}/v1/workspaces/{id_1}/chat-templates/{id_2}`. The nested GET returned
405 during validation and is not advertised as a binding. A project-scoped
template mutation does not substitute for a workspace-scoped mutation.

Export creation, status reads, pagination requests, and pending-job cancellation
were exercised. Successful export downloads remain unverified. Test results and
server diagnostics stay internal; completion of a job is not sufficient proof of
a working download. Completed export audit records may remain, as the documented
DELETE operation cancels jobs rather than erasing history.

The live driver supports an explicit `EREBINE_MANAGEMENT_SCENARIOS` path for a
private scenario file. Binary bodies, query pairs, status/error assertions,
bounded delays, and cleanup of matching fixture records are supported. Expected
errors must actually occur; unexpected success fails validation. Duplicate
cleanup actions are suppressed, and HTTP/contract/cleanup failures produce a
nonzero process exit. Never use a fixture prefix shared with preexisting data.

## Isolated worker follow-up

See [live validation](LIVE_VALIDATION.md) for execution and CPU inference proof.
The worker validation adds message creation, chat context, branch fork/list/delete,
chat memory/member reads, visibility updates, execution-workspace linking, and
chat-template application. Memory/member reads do not establish memory mutation
or multi-user access-control behavior.

Chat message creation uses `POST /{project_id}/v1/chats/{id}/messages`, documented
by `erectl chat new --message`. Both catalogs now include this binding. OpenAI
inference headers alone did not populate the management chat message history.
Endpoint membership mutations take the bound **worker ID**, while attaching a
worker takes its **agent ID**.

CORS reads and endpoint health reads/checks succeeded, but CORS PUT returned
HTTP 500 for both the CLI-shaped and expanded request shapes. The failure is
retained as a service issue, not reported as a passing mutation.

Validation cleanup specifications are resolved after response variables have
been saved. Polling is limited to GET, has a maximum of 300 attempts, and a
maximum two-second delay. An unmet polling condition fails the check.

The CORS follow-up isolates persistence failure from request validation and
authentication; see [live validation](LIVE_VALIDATION.md). Batch/file cleanup
must retain `X-Workspace-Id`. A 404 from the wrong workspace does not establish
that the original file was deleted. Scenario drivers support minimum numeric
assertions (`min_numbers`) to require positive generated-token usage.
