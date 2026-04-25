# Release checklist

## Current release posture

- Current channel: prerelease only
- Current install story: build from source from a checkout
- Current GitHub release state: no tags and no published releases yet

This project already has CI, tests, and a usable source-build path, but it should still treat upcoming releases as `0.y.z` prereleases until the stable gates below are closed.

## Versioning strategy

- Follow Semantic Versioning, but stay in the `0.y.z` range until the stable gates are met.
- Use prerelease identifiers for externally shared builds, for example `v0.1.0-alpha.1`, `v0.1.0-beta.1`, or `v0.1.0-rc.1`.
- Keep `CHANGELOG.md` updated under `Unreleased`, then cut the relevant entries into the tagged version during release prep.

## What to put in early releases

Until a binary packaging workflow exists, prerelease notes should explicitly say that installation is source-first:

1. source tarball or GitHub-generated source archive
2. the exact tested Rust toolchain floor (`rust-version = 1.75` today)
3. the existing build/run commands from `README.md`
4. notable known limitations that still matter for evaluators

## Prerelease checklist

- [ ] Run `cargo fmt --check`
- [ ] Run `cargo check`
- [ ] Run `cargo clippy --all-targets --all-features -- -D warnings`
- [ ] Run `cargo test`
- [ ] Update `CHANGELOG.md`
- [ ] Re-read `README.md` install and quick-start commands against the current CLI
- [ ] Summarize any user-visible limitations honestly in the release notes
- [ ] Tag in prerelease form (`v0.y.z-alpha.N`, `beta`, or `rc`) until the stable gates are closed

### Release evidence for tagged prereleases

Every tagged prerelease should preserve a minimal provenance record in the GitHub release notes or in a checked-in release note file. Record enough detail for a later evaluator to identify the exact source snapshot, toolchain, validation scope, and artifact set.

- [ ] Tag name and full commit SHA, for example `v0.1.0-alpha.1` -> `0123456789abcdef0123456789abcdef01234567`
- [ ] Exact `rustc --version` output
- [ ] Exact `cargo --version` output
- [ ] Target triple(s) tested or built, for example `x86_64-unknown-linux-gnu`
- [ ] Exact release-validation commands run, including the checklist commands above
- [ ] SHA256 checksums for every attached binary, archive, or installer
- [ ] For source-only releases with no attached assets, SHA256 checksum for the exact source archive being shared, such as the GitHub-generated `tar.gz` or `zip`
- [ ] Explicit maturity statement: source-only prerelease, or supported binary artifact prerelease

For source-only prereleases, say clearly that the source archive and release notes are the preserved artifacts, and that cross-platform binary assets are not promised yet. If binaries are attached, name the supported target triple for each asset and do not imply support for targets that were not built and checked.

### Prerelease notes template

Keep prerelease notes short, but include the audit trail:

```text
## v0.y.z-alpha.N

Commit: <full commit SHA>
Maturity: source-only prerelease; no cross-platform binary guarantee
Rust toolchain:
- rustc: <rustc --version>
- cargo: <cargo --version>
Targets tested/built:
- <target triple>
Validation:
- cargo fmt --check
- cargo check
- cargo clippy --all-targets --all-features -- -D warnings
- cargo test
Artifacts:
- Source archive: <filename or URL>
- SHA256: <checksum>
```

## Stable release gates for 1.0.0

Do not cut `1.0.0` until the repository is comfortable treating the CLI/TUI as a stable operator-facing tool. At minimum:

- [ ] issue #15 is closed with end-to-end interoperability coverage for FIND, MOVE, STORE, and local ingest
- [ ] issue #11 is closed so long-running TUI operations do not freeze the UI without progress state
- [ ] issue #7 is closed so users get persistent logs under `logs_dir` for debugging real PACS interactions
- [ ] issues #8 and #9 are closed so node validation and local ordering behavior are predictable
- [ ] issues #10 and #13 are closed so README, CLI help, and TUI command/form behavior tell one coherent story
