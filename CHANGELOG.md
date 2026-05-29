# Changelog

All notable project changes that affect users or release packaging should be documented in this file.

The repository has not published a GitHub release yet, so changes accumulate under `Unreleased` until the first tagged prerelease.

## [Unreleased]

### Added
- Introduced the source-first CLI surface for remote node management, import, query, retrieve, send, local inventory, and `storage-scp` workflows.
- Added discoverable Detail pane scrolling via a header hint for PageUp/PageDown and subtle ▲/▼ overflow indicators when more content exists above/below.
- Exposed import and storage object size safety limits in the TUI Storage SCP config modal (ZIP entry count/size, total ZIP size, max file import bytes, max inbound store object bytes).
- Added import traversal safety limits for max total files, directory depth, and path length.
- Implemented remote node commands for adding, editing, deleting, and listing configured DICOM nodes.
- Included a `ratatui` + `crossterm` TUI with panes for remote nodes, query/retrieve results, local studies/series, details, logs, and command input.
- Added TUI modal forms for node management, query, and retrieve flows, plus an embedded command prompt with command history.
- Enabled DICOM import from single files, folders, and ZIP archives, including files without a `.dcm` extension.
- Implemented SHA-256 duplicate detection using SOP Instance UID and content hash so repeated imports do not create duplicate local records.
- Hardened ZIP imports against unsafe paths (zip-slip), duplicate entry path collisions, and corrupt entries, while keeping extraction streaming/bounded-memory.
- Added ZIP import safety limits for entry count and imported byte size, plus staged-file cleanup for failed or duplicate imports.
- Expanded batch import reporting to include skipped/failed-cleanup counts and duplicate classification breakdown.
- Included DICOM networking support for C-FIND SCU study/series/image queries, C-MOVE SCU retrieval, C-STORE SCU sending, and C-STORE/C-ECHO SCP receiving.
- Added local SQLite indexing for imported and retrieved DICOM instances, with study and series listing commands.
- Covered in-process DICOM integration tests for C-FIND, C-MOVE, C-STORE, duplicate handling, local retrieval, and transfer syntax negotiation.
- Added configurable C-STORE transfer syntax preference, inbound storage SCP object size limits, and inbound association allowlists (`allowed_calling_aet`, `allowed_peer_ips`).
- Added CI prerelease evidence output and GitHub Release assets with pinned Rust toolchain version, target triple, source archive, and SHA256 checksum.
- Documented the current prerelease-only release posture in `README.md`
- Added `docs/release-checklist.md` with versioning guidance, prerelease steps, and stable-release gates
- Made long-running TUI operations (query/retrieve/import/send) run as background tasks with queued/running/succeeded/failed lifecycle, task log streaming, and a Tasks pane/modal for inspecting per-task logs and errors.

### Changed
- Improved migration checks for legacy prerelease data locations.
- Wrapped long TUI log entries so evaluator-facing status and error messages remain readable.
- Trimmed editable node patch fields so accidental surrounding whitespace is not persisted.
- Storage SCP C-STORE receive path now streams incoming datasets to a temporary file before parsing/persisting, avoiding buffering full objects in memory.

### Notes
- Incoming C-STORE datasets are spooled under the OS temp directory during receipt; temp files are removed on success and on error/abort paths.

### Fixed
- Tightened TUI modal rendering around narrow terminals and edge-case form state.
- Cleaned up staged import files after parse failures, validation failures, and duplicate imports.
