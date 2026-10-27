# Live validation — 2026-10-26

Both SDKs were exercised in an authorized test environment using direct routing.
Credentials remained outside the native SDK processes.
A restrictive localhost proxy injected authentication on that host and forwarded
only the bounded validation routes. Native SDK requests crossed the SSH tunnel;
SDK processes never received the key. Fake-credential local tests independently
verify SDK Authorization/header construction.

| Workflow | Rust | Swift |
| --- | --- | --- |
| Discover available models | HTTP 200; configured ID found | HTTP 200; configured ID found |
| Chat Completions | HTTP 200; choices decoded; request ID retained | HTTP 200; choices decoded; request ID retained |
| Responses | HTTP 200; output array decoded | HTTP 200; output array decoded |
| Chat SSE | JSON events decoded; usage received | JSON events decoded; usage received |
| MCP initialize and initialized notification | passed | passed |
| MCP tool discovery | 21 tools returned | 21 tools returned |
| MCP explicit session termination | passed | passed |

Inference prompts contained no user/customer content, requested a maximum of 64
output tokens, passed store=false, and declared no tools in the initial phase. The later inference-first
phase used an explicit synthetic client function as described below. No infrastructure execution or administrative mutation was run.
This validates transport and response shapes, not application-level task quality
or all fields and error conditions.

Selected discovery routes also returned successful responses. These checks do
not establish complete administrative or execution API parity. Per-account
configuration, inventory, and diagnostics remain internal.

No account IDs, keys, cookies, customer payloads, or raw account responses are
committed. The live examples require an explicitly configured loopback validation
proxy and are not invoked by CI or ordinary package tests.

## Inference-first validation expansion

Both native inference helpers passed the following additional live checks on
2026-10-26 with the same SSH authentication boundary:

- Retrieve a namespaced model ID containing a slash on the direct routing base.
- Request strict JSON-schema output and decode the generated {"ok":true} object.
- Force a declared sdk_echo client function, decode its arguments, supply the
  local synthetic result under its call ID, and obtain a visible follow-up answer.
- Embed a two-text batch with float vectors, then with base64 vectors.
- Rerank two documents and score two candidates through their separate APIs.
- Upload a generated 0.25-second silent PCM WAV as multipart transcription input
  and decode the returned transcript object. Transcript content was not evaluated.

These checks used up to 128 output tokens, minimal reasoning where requested,
store=false for generated responses, synthetic prompts/audio, and no external
or server-owned tools. The local test suites also exercise speech binary/SSE,
translation, System 1 request construction, fragmented parallel tool calls,
reasoning/refusal separation, and native WebSocket transcription. Speech, System 1, and realtime local checks are not reported as live service
verification.
Management was subsequently validated with a separate management-scoped key and
project; see [MANAGEMENT.md](MANAGEMENT.md). See INFERENCE.md for inference proof.

## Temporary isolated worker validation

A later pass enrolled disposable CPU inference and code-execution workers on an
isolated bridge network. Resource limits were enforced, no host ports were
published, and the execution worker could access only a synthetic sandbox.
Bootstrap credentials were single-use and revoked after enrollment. Account
identities and operator configuration remain internal.

Each native SDK passed 23 execution checks covering discovery, real directory
and file reads, an approval-gated write with content verification, rejection,
waiting cancellation, and sandbox enforcement. A separate six-step run per SDK
approved a controlled sleep job, verified it was executing, then cancelled it
and verified the terminal state. These counts describe scenarios, not unique
API operations. Async state reads use bounded GET-only polling; writes are
never retried by the validation driver.

Each SDK reached Chat Completions on the temporary CPU model, assembled Chat
SSE event shapes, and retrieved/updated/deleted stored completions. At that phase
positive generated-token counts and visible output were not asserted; those
success labels are transport/shape evidence and are superseded by the stricter
2026-10-27 checks below. The worker-specific Responses check failed: the backend reported
a tokenizer/tool-parser incompatibility, also reproduced directly against the
worker engine. This fixture does not establish Responses support for that
model; earlier direct-routing Responses validation remains separate evidence.

The opt-in worker inference examples report a nonzero exit on failure and log
only check names, counts, and generic diagnostics. The generic worker scenario
files under `api/` require a private fixture controller; they do not enroll
workers, contain credentials, or run during normal tests or CI.

Each SDK additionally verified endpoint suspend/unprovision/detachment, attach/
provision, and eventual active-model state. Both SDKs drained the temporary
traffic member to weight zero and restored weight one. Swift initially escaped
a colon in the worker identifier; preserving the RFC 3986 path-segment colon
fixed the live route, with an HTTP regression test added.

Both SDKs passed 23 selected chat/endpoint checks, including template application,
branch lifecycle, traffic changes, and health/config reads. CORS PUT is excluded
from that passing count. The worker lifecycle and execution checks above are
reported separately to keep the proof boundaries explicit.

Cleanup removed both worker containers, their isolated network, bootstrap files,
private worker state, and the temporary cleanup timer. Temporary agent identities
were revoked and active account fixtures deleted. Terminal execution/audit
history may remain on the service. Previously stable host workloads retained their original start times and
restart counts and remained running, with no unhealthy containers observed.
Preexisting unstable workloads were not modified. Public SDK files were scanned against the private credential
and fixture values before publication.

## Responses/CORS conformance follow-up — 2026-10-27

The first temporary model used a tokenizer without `<|python_tag|>`, required by
its configured `llama3_json` tool parser. A pinned tiny Llama 3 fixture resolved
non-streaming Responses generation. Both native SDKs decoded real output and
usage, retrieved stored content, listed responses, chained a follow-up, and
deleted stored responses. A token-budget-limited `incomplete` result with actual
output and usage is accepted; an empty or failed response is rejected.

The stronger checks exposed remaining service failures:

- Responses `input_items` returned an empty array for explicit message input in
  a workspace with zero-data retention disabled.
- Retrieval changed output message IDs while preserving content and usage.
  Applications should not infer that output item IDs survived this round trip.
- Public Responses SSE emitted lifecycle events but ended with zero output
  items/tokens. The same request directly against the isolated engine streamed
  text and a terminal snapshot with generated output and usage. This isolates
  the discrepancy to the engine-to-public-API path. Disabling tools and using
  explicit message input did not resolve it. Public routing also intermittently
  returned 503 `backend_unavailable` during this pass.
- CORS PUT returned 500 `internal_error` with “Failed to create CORS
  configuration” for minimal, complete, and alias bodies, with both the existing
  management credential and a new disposable scoped key. Invalid wildcard plus
  credentials correctly returned 400. GET still returned defaults after failed
  updates. No CORS update is counted as successful.

The earlier SSE event-count-only check was insufficient and is superseded by
these terminal-output/usage assertions. HTTP 200 and event arrival do not prove
successful generation. Independent Responses checks now continue after a
contract failure, retain individual results, and exit nonzero if any failed.
Background cancellation verifies the queued/in-progress state, cancellation,
and a subsequent cancelled snapshot; cleanup records an already-absent 404
separately from an actual successful delete.

`api/worker-cors-scenarios.json` reproduces the CORS matrix without embedding
credentials or account identifiers. These live scenarios are opt-in and do not
run in CI. `scripts/check_worker_fixture.py MODEL_DIRECTORY` checks tokenizer
metadata before provisioning with the default tool parser; it performs no
network access, weight loading, or model code execution. It is a metadata
preflight, not a guarantee of hardware compatibility or model quality.

Use `EREBINE_WORKER_INFERENCE_MODE=responses` with the worker inference example
to isolate Responses checks from Chat workflows. This changes only the opt-in
validation example; SDK requests are preserved without protocol fallbacks.

The same stricter output checks also reject the temporary worker's Chat and batch
results when they contain null message content and zero completion tokens,
even if HTTP status and batch job status indicate success. Earlier batch
checks established upload/scheduling/polling/download transport only. Positive
output/usage remains unverified on this CPU worker path.

Batch deletion requires the original workspace header and returns file metadata
with `status: "deleted"`, rather than the OpenAI `{deleted: true}` envelope.
The owning workspace could still download the deleted fixture's content during
validation. A tombstone is not proof of physical content removal. Only synthetic
fixtures were used; account-specific diagnostics stay internal.

Both repositories include `scripts/test_worker_validation.py` in CI. Its fake
loopback server tests valid output plus empty Chat, empty Chat SSE, empty or
failed Responses SSE, missing terminal snapshots, and numeric token assertions.
These regressions protect the validators from counting empty 200 responses as
successful generation. They are local validator proof, not live service proof.

A chained request accepted the parent response ID and produced a child, but this
does not establish faithful context reconstruction while input-item history is
empty. Local validator regressions passed all six worker profiles and both
minimum-number profiles per SDK. Cleanup removed active fixture workspaces and
worker resources; a deleted fixture file became inaccessible (403) after its
owning workspace was deleted. This is access-control evidence, not proof that
the service physically purged its bytes.
