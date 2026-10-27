# Changelog

## 26.10.27.1 — package 26.10.27-build.1

Initial experimental release of the community SDK, with 380 reviewed HTTP
bindings, inference helpers, streaming, MCP, and opt-in realtime support.

Local transport tests and validator regressions pass. Live testing exposed
service-side CORS, CPU inference output, Responses history/streaming/readiness,
and file-retention issues. Full live API/schema parity is not certified; see
LIVE_VALIDATION.md and COVERAGE.md. Earlier status/shape-only success labels are
superseded by checks requiring generated output and positive token usage.
