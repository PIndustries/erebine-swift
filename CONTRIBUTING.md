# Contributing

Changes must include the exact Erebine documentation URL or upstream API contract.
Edit `api/operations.json`, then run `python3 scripts/generate.py`. Do not edit the
generated operation definitions by hand. Match the sibling SDK catalog before
releasing a coordinated version. Preserve unknown JSON fields and event names.
Add a regression fixture for protocol changes. Never commit keys, cookies, or
customer data. Run the checks in `.github/workflows/ci.yml` before submitting.
Update COVERAGE.md when a verification boundary changes; adding a constant alone
is not live endpoint verification.
