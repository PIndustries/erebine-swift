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
and webhook configuration CRUD/history. No webhook test delivery was sent.

All temporary workspaces, templates, conversations, files, API keys, join keys,
SLOs, and webhooks were deleted or revoked. The proxy cleanup ledger reported
zero remaining active fixtures. Services may retain audit or soft-deleted records.
Only newly created credentials were rotated/revoked.

Additional live validation requires suitably configured disposable resources and
separate administrator access. Deployment inventories, project identifiers,
account scopes, and per-account diagnostics remain internal. Provisioning, agent
execution, chat context/branches/memory, template application to a chat, webhook
delivery, invites, billing, and destructive execution are not live-verified.

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
