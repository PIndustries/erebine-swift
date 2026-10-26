# API coverage and verification

The native Rust and Swift SDKs cover the reviewed public HTTP surface with
**377 operation bindings and 377 native API methods each**. Project/routing
configuration is inherited from Client, resource IDs are explicit arguments,
and all request/response JSON fields remain available. This is HTTP binding
coverage; complete typed schemas and live server conformance are separate gates.

## Public contract audit — 2026-10-26

- 112 public documentation pages reviewed, including curl examples.
- 323 concrete method/path references reconciled in `api/reference-audit.json`.
  Example identifiers normalize to resource parameters; workspace-scoped endpoint
  paths use a dedicated routing variant. One integration source download is
  classified as a static asset rather than an API.
- All 286 erectl v2.7.3 help entries classified in
  `api/cli-command-audit.json`: captured requests, command groups, or local CLI
  behavior (configuration files, shell completion, host deployment, help).
- 283 synthetic outgoing CLI requests replayed through each native transport.
  This includes complete archive/directory request chains: initialization,
  chunk/file transfer, checksum headers, resume, and completion. CLI captures
  used fake credentials and a loopback server. Synthetic server replies drove
  later requests; they are not authoritative response schemas.
- Every one of the 377 catalog bindings is sent through each SDK's native HTTP
  transport in local tests. CORS OPTIONS, workspace endpoint/direct/semantic
  routing, JSON/multipart/binary bodies, errors, SSE, MCP, and realtime are covered.
- `scripts/check_catalog.py` runs in CI to reject missing audit bindings,
  duplicate route shapes, invalid parameters, or credential-bearing fixtures.
  Code generation is deterministic and checked for drift.

See [API.md](API.md), [INFERENCE.md](INFERENCE.md), [MCP.md](MCP.md), and
[MANAGEMENT.md](MANAGEMENT.md) for usage. Both libraries support raw method/path
requests as an escape hatch. Dashboard operations require caller-supplied
session/CSRF headers; a router API key does not create a dashboard session.

## Live verification and remaining gates

Selected inference and disposable management workflows passed live validation;
see [LIVE_VALIDATION.md](LIVE_VALIDATION.md). Live results are narrower than the
complete local transport matrix. Account credentials, project configuration,
resource identifiers, deployment inventory, and per-account diagnostics remain
internal.

Provisioning/traffic changes, model version lifecycles, agent execution/approvals,
webhook delivery, billing, dashboard authentication, large/resumable uploads,
and pagination at scale still need an appropriate live test environment. Existing
bindings and CLI request evidence do not establish successful end-to-end behavior.
MCP GET notifications and explicit Last-Event-ID resume are locally verified;
automatic reconnect, sampling, roots, and elicitation are not implemented.

No authoritative OpenAPI document or server route inventory was available. The
reviewed docs and CLI version bound the claim: there are no unresolved references
in that inventory, but undocumented server operations and complete request/response
schema parity cannot be certified from those sources. Full parity certification
and a stable release must wait for those contracts and remaining live checks.

Public documentation hashes are recorded in `api/sources.json`; CLI version,
binary hash, and capture provenance are in `api/cli-contracts.json`.
