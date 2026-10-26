# Live validation — 2026-10-26

Both SDKs were exercised against the user's authorized Erebine project, using
workspace-scoped direct routing. The existing API key remained on an SSH host.
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

Separate account probes confirmed endpoint/workspace/template listings and the
provider manifest returned HTTP 200. Management API-key and execution-tool listing
returned HTTP 403. This credential does not establish administrative or execution
API parity. An authoritative route/schema contract and appropriately scoped
isolated test project are still needed for full one-to-one certification.

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
reasoning/refusal separation, and native WebSocket transcription. No speech,
System 1, or realtime deployment was identified in the available model catalog,
so those successful local checks are not reported as live service verification.
Management is deferred. See INFERENCE.md for the complete proof matrix.
