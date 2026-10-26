# API coverage and verification

Full one-to-one API coverage is the project goal. Version 0.1 is an experimental,
source-attributed HTTP binding; it is **not a certification of complete Erebine
API or schema parity**.

## What is implemented

Both native SDKs use the same reviewed `api/operations.json` catalog (273
method/path entries, documentation retrieved 2026-10-26). Every catalog entry has
a named operation definition, a source URL, and a router/dashboard surface.
Requests preserve caller-supplied JSON, query parameters, headers, and binary
bytes. Responses retain status, headers, and the original body. Typed helpers are
optional; the catalog does not imply a complete typed schema for every field.

Implemented transport capabilities:

- Endpoint, direct-model, semantic, and custom-domain routing.
- JSON, multipart form-data, and raw binary requests; binary and empty responses.
- Incremental SSE with Unicode/chunk boundary handling, multiline data, comments,
  IDs, retry fields, vendor event names, and `[DONE]` handling.
- Structured HTTP errors retaining unknown vendor envelopes, request IDs, and
  Retry-After. There are no automatic retries or implicit model/tool calls.
- Separate clients for router and dashboard origins/authentication surfaces.
  Dashboard cookies and CSRF tokens must be supplied by the caller. No browser
  login automation, key provisioning, or implicit session sharing occurs.
- Raw method/path escape hatch for documented operations missing from the catalog.

The operation catalog includes inference, stored completions, Responses,
conversations, files, uploads, models/versioning, semantic-router management,
workspace/document/memory routes, branches, SLOs, usage/exports, API keys, agents,
approvals, webhooks, maintenance, members, and documented dashboard billing/GDPR
routes. Some dashboard responses are HTML or redirects; use the raw response.

## Deferred management and remaining contract gaps

The current implementation milestone is inference first; see INFERENCE.md for
its typed helpers, realtime transport, and live validation matrix. Management
expansion is deferred. Offline official-CLI request captures have been collected
as scratch evidence for future management work, but are not promoted to live
management validation.

The public docs describe additional CLI features without a complete method/path
and request/response contract. These are **not implemented as guessed bindings**:

| Family | Contract still needed |
| --- | --- |
| Endpoint lifecycle | create/update/provision/unprovision, agent membership and traffic weights, health probes |
| Chat lifecycle | full create/list/update/archive and execution workspace linking |
| Chat templates | create/update/promote/version/apply; listing is bound and live-verified |
| Execution | full executions/history/cancellation, preferences, context, learnings |
| Settings | exact project update/delete route and payload |
| Authentication | complete login/SSO/2FA/session lifecycle API; browser-facing flows are not an SDK login implementation |
| MCP | native request/response sessions are implemented; subscription listeners, reconnect/resume, sampling, roots, and elicitation remain unsupported |
| Realtime | native WebSocket transcription is implemented and locally protocol-tested; no live realtime endpoint was identified |

Sources: [CLI endpoints](https://erebine.ai/docs/erectl/endpoints),
[CLI platform](https://erebine.ai/docs/erectl/platform),
[CLI templates](https://erebine.ai/docs/erectl/templates),
[execution](https://erebine.ai/docs/eem),
[authentication](https://erebine.ai/docs/authentication),
[MCP](https://erebine.ai/docs/mcp).
An authoritative OpenAPI document or router source is needed to close these gaps.
The standard public `/openapi.json` locations on the dashboard and router returned
404 during this implementation.

## Proof boundaries

Local regression tests use a loopback HTTP fixture. They verify
request methods, escaping, query repetition, body formats, headers, empty/binary
responses, redirects, error envelopes, and SSE. Every generated operation is
checked for successful URL construction. This is transport/catalog validation,
not proof that every remote handler accepts a request or that every parameter is
correct. Separate opt-in live checks passed for both SDKs against the authorized
account: model discovery, Chat Completions, Responses, SSE with usage, and MCP
initialization/tool discovery/session termination. Those inference checks made
bounded billable requests with store=false. The key stayed on the SSH host and
was injected by a restrictive loopback proxy. See LIVE_VALIDATION.md. Management
and execution discovery returned HTTP 403; administrative conformance remains
unverified with this account credential.

## Closing full parity

1. Reconcile the catalog with the authoritative upstream route inventory.
2. Add exact request/response schemas and representative fixtures per operation.
3. Exercise documented auth scopes against a disposable live project.
4. Verify pagination, upload checksums/resume, cancellation, webhooks, and EEM
   approval/execution workflows end to end.
5. Publish a stable version only after these gates pass.

`api/extraction-exclusions.json` records wildcard and incomplete references that
were excluded during discovery. `api/sources.json` records source hashes so future
changes can be reviewed. Catalog entries that share a route but differ only in
placeholder spelling are normalized; independent resource IDs use `id_1`, `id_2`.
