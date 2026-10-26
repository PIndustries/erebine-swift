# API coverage and verification

Full one-to-one API coverage is the goal. This experimental SDK does not yet
certify complete Erebine API or schema parity.

## Implemented bindings

Both SDKs share **376 method/path bindings** in `api/operations.json`, sourced
from public documentation and the official erectl v2.7.3 client. Every entry has
a named operation, source URL, and router/dashboard surface. The latest expansion
adds 103 bindings for endpoint lifecycle, chats/templates, execution, settings,
model management, and related CLI features.

Requests preserve arbitrary JSON, queries, headers, multipart files, and binary
bytes. Responses preserve status, headers, and body. Typed inference helpers are
optional; management bindings accept JSON rather than claiming complete typed
schemas. Native SSE, MCP request/response sessions, and WebSocket transcription
are also implemented. See [INFERENCE.md](INFERENCE.md).

Dashboard operations require caller-supplied dashboard authentication, including
cookies/CSRF where applicable. A router management key does not establish a
browser session. Raw method/path requests remain available.

## Evidence

- Local transport tests cover escaping, queries, JSON/multipart/binary bodies,
  errors, SSE, MCP, realtime, and construction of every catalog entry.
- `api/cli-contracts.json` contains 271 synthetic outgoing requests captured from
  the official CLI against a loopback server with fake credentials. Each is
  replayed through each SDK's native HTTP transport. This verifies CLI request
  construction, not remote acceptance or response schema completeness.
- Both SDKs passed 62 live management checks on 2026-10-26, with eight successful
  resource cleanups each. Chat creation was environment-unavailable and eight
  dependent checks were skipped. See [MANAGEMENT.md](MANAGEMENT.md).
- Earlier live inference checks passed on a separate deployment; see
  [LIVE_VALIDATION.md](LIVE_VALIDATION.md). Local tests alone do not prove live
  realtime, speech generation, translation, or System1 compatibility.

## Remaining parity gates

The supplied management project has no deployed models, endpoints, or agents.
Endpoint provisioning, traffic changes, model uploads/version lifecycles, and
agent/execution/approval workflows have bindings and CLI request evidence but
lack live end-to-end validation. Platform administrator discovery returned
`403 platform_admin_required`. Billing, authentication/SSO/2FA browser flows,
invites, webhook delivery, destructive execution, pagination at scale, and
resumable uploads also remain unverified. No infrastructure was provisioned or
existing routing/billing configuration changed during validation.

MCP subscription listeners, reconnect/resume, sampling, roots, and elicitation
remain unsupported. Complete authoritative request/response schemas and a server
route inventory are still needed to certify full parity. Public OpenAPI URLs
returned 404 during discovery; CLI coverage is evidence for that CLI version,
not proof of every server route.

`api/sources.json` records public documentation hashes;
`api/cli-contracts.json` records CLI version, binary hash, and capture provenance.
`api/extraction-exclusions.json` lists incomplete/wildcard references excluded
from extraction. Stable releases should follow schema reconciliation and the
remaining live workflow checks.
