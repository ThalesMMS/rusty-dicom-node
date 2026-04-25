# Changelog

All notable project changes that affect users or release packaging should be documented in this file.

The repository has not published a GitHub release yet, so changes accumulate under `Unreleased` until the first tagged prerelease.

## [Unreleased]

### Added
- Introduced the source-first CLI surface for remote node management, import, query, retrieve, send, local inventory, and `storage-scp` workflows.
- Implemented remote node commands for adding, editing, deleting, and listing configured DICOM nodes.
- Included a `ratatui` + `crossterm` TUI with panes for remote nodes, query/retrieve results, local studies/series, details, logs, and command input.
- Added TUI modal forms for node management, query, and retrieve flows, plus an embedded command prompt with command history.
- Enabled DICOM import from single files, folders, and ZIP archives, including files without a `.dcm` extension.
- Implemented SHA-256 duplicate detection using SOP Instance UID and content hash so repeated imports do not create duplicate local records.
- Added ZIP import safety limits for entry count and imported byte size, plus staged-file cleanup for failed or duplicate imports.
- Included DICOM networking support for C-FIND SCU study/series/image queries, C-MOVE SCU retrieval, C-STORE SCU sending, and C-STORE/C-ECHO SCP receiving.
- Added local SQLite indexing for imported and retrieved DICOM instances, with study and series listing commands.
- Covered in-process DICOM integration tests for C-FIND, C-MOVE, C-STORE, duplicate handling, local retrieval, and transfer syntax negotiation.
- Added configurable C-STORE transfer syntax preference and inbound storage SCP object size limits.
- Added CI prerelease evidence output and GitHub Release assets with pinned Rust toolchain version, target triple, source archive, and SHA256 checksum.
- Documented the current prerelease-only release posture in `README.md`
- Added `docs/release-checklist.md` with versioning guidance, prerelease steps, and stable-release gates

### Changed
- Improved migration checks for legacy prerelease data locations.
- Wrapped long TUI log entries so evaluator-facing status and error messages remain readable.
- Trimmed editable node patch fields so accidental surrounding whitespace is not persisted.

### Fixed
- Tightened TUI modal rendering around narrow terminals and edge-case form state.
- Cleaned up staged import files after parse failures, validation failures, and duplicate imports.
