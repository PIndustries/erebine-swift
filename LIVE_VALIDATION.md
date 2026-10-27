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

Each SDK also generated real Chat Completions on the temporary CPU model,
assembled Chat SSE including usage, and retrieved/updated/deleted stored
completions. The worker-specific Responses check failed: the backend reported
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
