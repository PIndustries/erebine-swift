# Release version policy

Release names use `YY.MM.DD.BUILD`. The first build on 27 October 2026 is
`26.10.27.1`. Increment BUILD for another release on the same date; reset it to 1
on a new release date. Dates use America/Chicago.

Cargo and Swift Package Manager require a three-part semantic version. Preserve
the date and build as `YY.M.D-build.BUILD`, so this release's package version and
Git tag are `26.10.27-build.1`. Numeric month/day components omit leading zeroes;
the human release name keeps the two-digit month and day. These are prerelease
versions under SemVer. The GitHub release title uses the four-part release name;
the actual Git tag uses the package version.

`release.json` records both versions. Keep it coordinated across the Rust and
Swift SDKs and run `python3 scripts/check_release_version.py` before release.
The Rust manifest and lockfile must match the package version. Swift obtains its
version from the Git tag, not from Package.swift.

Pin experimental versions explicitly. A successful build or tag does not certify
full live API parity; read COVERAGE.md and LIVE_VALIDATION.md for current limits.

Release process:

1. Update release.json, installation examples, and CHANGELOG.md in both repos.
2. Update the Rust package version and lockfile; keep both API catalogs aligned.
3. Validate the package, CI, and the archive's contents without private data.
4. Push the semantic-version tag and create the four-part named GitHub prerelease.
5. Verify SwiftPM resolves the exact remote tag and Erebine product.
6. Publish the Rust crate with an authorized crates.io account, then verify the
   registry version before advertising registry installation as available.

For the Rust upload, run `cargo publish --locked --all-features --registry crates-io`
after authenticating locally. Never paste registry tokens into chat or commit them.
Build/verification directories are temporary and must be removed afterward.
