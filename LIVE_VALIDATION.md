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
| Chat SSE | 13 JSON events decoded; usage received | 13 JSON events decoded; usage received |
| MCP initialize and initialized notification | passed | passed |
| MCP tool discovery | 21 tools returned | 21 tools returned |
| MCP explicit session termination | passed | passed |

Inference prompts contained no user/customer content, requested a maximum of 64
output tokens, passed store=false, and declared no tools. No tool was invoked by
the live checks. No infrastructure execution or administrative mutation was run.
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
