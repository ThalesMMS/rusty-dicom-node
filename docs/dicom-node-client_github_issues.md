# dicom-node-client: publication readiness review and GitHub issue drafts

## Overall assessment

This codebase is a promising DICOM networking prototype with a reasonably clean service split and a useful first TUI, but it is not yet publication-ready as a public CLI repository. The two strongest signals are:
- the README still describes the project as a scaffold and explicitly says it was not compiled or cargo-check validated in the authoring environment;
- the repo still contains scaffold residue in runtime paths (`ProjectDirs::from("br", "openai", "dicom-node-client")`).

The most important technical blockers before a public release are:
1. the exposed TLS flag is not implemented in the transport layer;
2. C-MOVE success validation can fail for idempotent re-retrieves when objects are already present locally;
3. DIMSE response handling is optimistic about P-DATA fragmentation;
4. importer safety and memory behavior need hardening;
5. the TUI blocks during long operations and still lacks a release-quality information architecture.

---

## Issue 1 — Rename the application data namespace and add a migration from the scaffold path

**Title**
Rename the application data namespace and migrate existing data from the scaffold path

**Labels**
`release` `config` `breaking-change`

**Body**
### Summary
The application still stores user data under a scaffold-era namespace: `ProjectDirs::from("br", "openai", "dicom-node-client")`.

For a public release, the runtime storage path should use the real publisher/org namespace, not a leftover scaffold identifier.

### Why this matters
- Public releases should not ship with scaffold branding in runtime paths.
- Changing the namespace later will fragment config and local DB locations.
- The first public version is the best time to define a stable storage convention.

### Proposed scope
- Replace the current `ProjectDirs` tuple with the actual publisher/org namespace.
- Add a one-time migration from the old data directory to the new one.
- Emit a clear message when a migration is performed.
- Document the final config/data/log paths per platform.

### Acceptance criteria
- [ ] `AppPaths::discover()` uses the final public namespace
- [ ] Existing `config.json`, SQLite DB, and managed store can be migrated automatically
- [ ] Migration is idempotent and covered by tests
- [ ] README documents where config/data/logs live on Linux/macOS/Windows

---

## Issue 2 — Add release metadata, license, install docs, and CI

**Title**
Turn the scaffold into a release-ready public repository

**Labels**
`release` `docs` `ci`

**Body**
### Summary
The repo is still framed as a scaffold. The README says the code was authored without a Rust toolchain and was not compiled or `cargo check`-validated, and `Cargo.toml` still lacks the usual publication metadata (`license`, `repository`, `homepage`, `readme`, `keywords`, `categories`, `rust-version`).

### Why this matters
A public repository needs a reproducible build, clear ownership, and a trustworthy README before other users can adopt it.

### Proposed scope
- Add missing `Cargo.toml` metadata.
- Add a LICENSE file.
- Add GitHub Actions for `cargo fmt --check`, `cargo check`, `cargo clippy`, and `cargo test`.
- Replace scaffold wording in README with actual support/install/build guidance.
- Add platform notes and a minimal support matrix.

### Acceptance criteria
- [ ] `Cargo.toml` includes public release metadata
- [ ] LICENSE is present
- [ ] CI runs on PRs and main
- [ ] README no longer says the project was not compiled in the authoring environment
- [ ] README includes installation/build/run instructions and known limitations

---

## Issue 3 — Implement TLS support or remove the TLS flag until it exists

**Title**
Implement DICOM TLS support or remove the TLS flag from the public interface

**Labels**
`bug` `networking` `security` `release-blocker`

**Body**
### Summary
Remote nodes persist a `use_tls` flag, and both CLI/TUI expose TLS as a user-configurable option. However, association creation currently only builds plain `ClientAssociationOptions` and does not branch on `node.use_tls`.

### Why this matters
A public CLI must not expose a security option that has no effect. This creates a false expectation of encrypted transport.

### Proposed scope
Choose one of these paths:
1. Fully implement DICOM TLS, including certificate/config handling and documentation; or
2. Remove/hide the TLS flag from CLI, TUI, DB-backed UX, and README until support is real.

### Acceptance criteria
- [ ] There is no user-visible TLS option unless it actually changes transport behavior
- [ ] If implemented, TLS has configuration docs and interoperability tests
- [ ] If deferred, TLS is removed from CLI args, TUI forms, README examples, and node rendering

---

## Issue 4 — Fix false-negative retrieve validation for idempotent local C-MOVE

**Title**
Fix local C-MOVE success validation when objects are already indexed

**Labels**
`bug` `retrieve` `release-blocker`

**Body**
### Summary
`validate_retrieve_outcome()` currently treats a retrieve as failure when `local_instances_after <= local_instances_before`. That breaks valid idempotent retrieves where the remote node resent objects that are already indexed locally.

### Why this matters
Re-running a successful retrieve against the same study should not be reported as failure just because the local row count did not increase.

### Proposed scope
- Replace the current count-delta heuristic with a more reliable success model.
- Consider using:
  - DIMSE status + sub-operation counters;
  - actual received C-STORE count during the temporary local SCP session;
  - duplicate/update counts from ingest.
- Keep the “wrong AE mapping / nothing arrived” detection, but avoid false negatives for duplicates.

### Acceptance criteria
- [ ] Re-retrieving an already indexed study can succeed without increasing the DB row count
- [ ] Wrong-destination / no-ingest scenarios are still detected
- [ ] Tests cover first ingest, duplicate ingest, and failed/no-arrival cases

---

## Issue 5 — Make DIMSE response parsing robust to fragmented P-DATA

**Title**
Handle fragmented DIMSE command and dataset PDUs across FIND, MOVE, and STORE flows

**Labels**
`bug` `networking` `interop` `release-blocker`

**Body**
### Summary
Several SCU paths assume the command dataset is fully available in `data[0].data` after a single `association.receive()`. That is optimistic and may fail against peers that fragment command/data payloads differently.

### Why this matters
Interoperability problems against real PACS are exactly the kind of issue that appears after publication if DIMSE parsing is too optimistic.

### Proposed scope
- Introduce a shared helper that accumulates command fragments until `is_last`.
- Reuse it in C-FIND, C-MOVE, and C-STORE response handling.
- Add tests for fragmented command and fragmented dataset scenarios.

### Acceptance criteria
- [ ] No SCU path assumes the first `PDataValue` contains the whole command dataset
- [ ] Fragmented command/data responses are covered by tests
- [ ] Error messages remain clear when remote PDUs are malformed

---

## Issue 6 — Harden importer behavior for missing paths, archive safety, and memory usage

**Title**
Harden importer path validation, ZIP safety, and large-file memory behavior

**Labels**
`bug` `import` `performance` `security`

**Body**
### Summary
Importer behavior is still too forgiving/optimistic for a public release:
- missing/invalid paths can degrade into “rejected” counts instead of explicit user errors;
- ZIP entries are read fully into memory;
- ZIP parsing clones buffers before DICOM parsing;
- regular files are opened once for metadata and then fully re-read into memory.

### Why this matters
Real DICOM imports can be large, malformed, or hostile. Public-facing tooling needs predictable error handling and memory behavior.

### Proposed scope
- Fail fast for missing root paths / unreadable inputs.
- Add configurable limits for archive entry size, total extracted bytes, and entry count.
- Reduce unnecessary buffer duplication in ZIP import.
- Improve per-file rejection reporting so users know why files were skipped.

### Acceptance criteria
- [ ] Invalid root paths return explicit errors
- [ ] ZIP imports have size/count guards
- [ ] Memory copies are reduced where possible
- [ ] Import reports can distinguish rejected vs duplicate vs unreadable vs invalid-DICOM cases

---

## Issue 7 — Add persistent logging and write traces into `logs_dir`

**Title**
Write application logs to the configured logs directory and surface log locations to users

**Labels**
`observability` `docs`

**Body**
### Summary
`AppPaths` creates a `logs_dir`, but runtime logging is currently only initialized through `tracing_subscriber::fmt()` and does not appear to write to files.

### Why this matters
For a networking CLI/TUI, log files are essential for debugging remote interoperability, failed retrieves, and storage-SCP behavior.

### Proposed scope
- Add file-backed logging in `logs_dir`.
- Optionally split logs by run/session and keep stderr/stdout output for interactive use.
- Show the active log path in startup output / help / TUI status.

### Acceptance criteria
- [ ] Logs are written to files under `logs_dir`
- [ ] Users can easily discover the current log file location
- [ ] Network/import/storage failures leave actionable traces

---

## Issue 8 — Normalize and validate node configuration more strictly

**Title**
Tighten remote node validation and define stable normalization/lookup rules

**Labels**
`bug` `cli` `db`

**Body**
### Summary
Current validation is too loose for public release:
- AE title validation only checks non-empty and max length;
- `parse_port()` accepts `0`;
- remote node names are unique with case-sensitive semantics, but listing is case-insensitive;
- lookups by name are direct string matches, which can produce confusing UX.

### Why this matters
Public CLIs need predictable identifiers and input validation, especially for DICOM node definitions.

### Proposed scope
- Validate AE title character set and whitespace rules.
- Reject port `0`.
- Decide and document whether node names are case-sensitive or case-insensitive.
- Normalize names / AE titles consistently before persistence and lookup.

### Acceptance criteria
- [ ] Invalid AE titles are rejected with actionable messages
- [ ] Port `0` is rejected
- [ ] Node lookup semantics are documented and tested
- [ ] Unique constraints and list ordering match the chosen normalization policy

---

## Issue 9 — Sort series and instance numbers numerically, not lexicographically

**Title**
Sort local series and instance numbers numerically in DB queries

**Labels**
`bug` `db` `ux`

**Body**
### Summary
Series and instance ordering currently uses string sorting (`COALESCE(..., '')`), which will place `"10"` before `"2"`.

### Why this matters
Incorrect ordering affects:
- local series display;
- study/series send order;
- general trust in the local index.

### Proposed scope
- Use numeric ordering when `series_number` / `instance_number` are numeric.
- Keep a deterministic fallback for non-numeric values.
- Add tests for mixed numeric/non-numeric DICOM IS values.

### Acceptance criteria
- [ ] Numeric values sort as humans expect (`2 < 10`)
- [ ] Mixed numeric/non-numeric cases have deterministic fallback behavior
- [ ] Tests cover study and series file ordering

---

## Issue 10 — Align CLI, TUI command grammar, and README examples

**Title**
Unify CLI syntax, TUI command syntax, and README examples

**Labels**
`cli` `docs` `tui`

**Body**
### Summary
The project currently exposes two command surfaces:
- Clap-based CLI using positional/subcommand syntax;
- TUI command input using `key=value` syntax.

That split is acceptable, but the naming and examples need to be explicitly aligned. Right now, public docs risk confusing users (for example, TUI examples use `node edit target=...`, while the CLI uses a positional `node` argument).

### Why this matters
A public CLI/TUI can tolerate multiple interfaces, but not ambiguous documentation.

### Proposed scope
- Define the exact relationship between CLI and TUI command grammar.
- Standardize naming where practical (`dest` vs `move_destination`, `ae` vs `ae_title`, etc.).
- Add examples that clearly label “CLI syntax” vs “TUI command syntax”.
- Consider adding a shared parser/alias registry to reduce drift.

### Acceptance criteria
- [ ] README clearly separates CLI syntax from TUI command syntax
- [ ] Common argument names are aligned or intentionally documented as aliases
- [ ] Help output and README examples match actual behavior
- [ ] Regression tests cover at least the documented TUI commands

---

## Issue 11 — Make TUI operations non-blocking and add progress state

**Title**
Move long-running TUI operations off the UI thread and add progress/busy feedback

**Labels**
`tui` `ux` `performance` `release-blocker`

**Body**
### Summary
The TUI performs query, retrieve, import, and send operations synchronously inside event handlers. On slower networks or larger imports, the UI will freeze until the operation completes.

### Why this matters
This is one of the biggest differences between a prototype TUI and a publishable TUI.

### Proposed scope
- Add a background task runner for long operations.
- Show busy/progress state in the UI.
- Prevent duplicate submissions while a task is running.
- Add cancellation where feasible (or at least a clear “working…” state).

### Acceptance criteria
- [ ] The TUI remains responsive during query/retrieve/import/send
- [ ] Users can see what operation is running
- [ ] Re-entrant submissions are blocked or queued safely
- [ ] Task completion/failure is reported cleanly in logs/status

---

## Issue 12 — Redesign the TUI around master/detail panes and readable data views

**Title**
Redesign the TUI layout to support study/series/detail workflows

**Labels**
`tui` `ux`

**Body**
### Summary
The current TUI is a strong first pass, but it still renders most data as single-line list rows. Long UIDs dominate the screen, and there is no real detail pane for the selected node, study, or query result.

### Why this matters
A TUI for DICOM workflows needs quick inspection of:
- selected remote node details;
- selected study metadata;
- series breakdown of a local study;
- selected query result metadata and retrieve context.

### Proposed scope
- Add a master/detail design instead of only flat lists.
- Add a local study → local series drill-down.
- Add a query result detail panel.
- Improve column layout for date/modality/patient/description/UID fields.
- Rework the compressed top status line for readability.

### Acceptance criteria
- [ ] Local studies have a visible series drill-down
- [ ] Query results have a detail pane
- [ ] Selected node metadata is readable without truncation-heavy rows
- [ ] The status area is readable on standard terminal widths

---

## Issue 13 — Bring TUI forms to parity with CLI and prevent invalid retrieve combinations

**Title**
Expand TUI query/retrieve forms to match CLI capabilities and enforce valid combinations

**Labels**
`tui` `cli` `ux`

**Body**
### Summary
The TUI query form currently supports only a subset of CLI filters. It omits fields such as accession number, study description, series UID, and SOP UID. The retrieve flow also still exposes model/level combinations that are later rejected.

### Why this matters
Advanced users will notice that the TUI cannot drive the same workflow breadth as the CLI.

### Proposed scope
- Add the missing query filters from `QueryCriteria`.
- Add advanced retrieve controls where appropriate.
- Prevent or disable invalid retrieve combinations (for example, patient-level retrieve).
- Make form defaults smarter when launched from selected query results.

### Acceptance criteria
- [ ] TUI query supports the same practical filters as the CLI
- [ ] Invalid retrieve combinations are prevented in the UI, not only rejected later
- [ ] Tests cover the expanded form mapping

---

## Issue 14 — Upgrade the TUI command editor and terminal lifecycle handling

**Title**
Improve the TUI command editor and make terminal restoration panic-safe

**Labels**
`tui` `ux` `stability`

**Body**
### Summary
The command input currently behaves like an append-only buffer plus backspace. It lacks cursor movement, delete/home/end, history, and richer editing behavior. Terminal restoration is also handled manually rather than through a guard/panic-safe cleanup strategy.

### Why this matters
These details have a large impact on perceived polish in terminal applications.

### Proposed scope
- Add cursor-aware editing for the command line.
- Add command history and optional completion.
- Support paste-friendly editing.
- Introduce RAII/guard-based terminal cleanup and panic-safe restoration.
- Handle very small terminal sizes gracefully.

### Acceptance criteria
- [ ] Command input supports cursor movement and inline editing
- [ ] Command history works
- [ ] Terminal is restored correctly after errors/panics
- [ ] Small terminal sizes show a friendly fallback message instead of broken layout

---

## Issue 15 — Add end-to-end interoperability tests with a real DICOM peer

**Title**
Add integration tests for C-FIND, C-MOVE, C-STORE, and local storage SCP interoperability

**Labels**
`test` `interop` `release-blocker`

**Body**
### Summary
The codebase already includes useful unit tests, but a public DICOM networking tool needs end-to-end coverage against real or realistic peers.

### Why this matters
The largest remaining risks are interoperability risks, not syntax-level bugs.

### Proposed scope
- Add integration tests using sample DICOM data and a controllable peer (for example, a test SCP harness or containerized PACS emulator).
- Cover:
  - C-FIND query round-trip
  - C-MOVE to the embedded local storage SCP
  - C-STORE send of a local study/series
  - duplicate/idempotent ingest
  - fragmented DIMSE responses if the harness can simulate them

### Acceptance criteria
- [ ] Integration tests exist for FIND, MOVE, STORE, and local ingest
- [ ] CI can run at least a minimal interoperability suite
- [ ] The tests cover duplicate/idempotent retrieve behavior
