# dicom-node-client

[![CI](https://github.com/ThalesMMS/rusty-dicom-node/actions/workflows/ci.yml/badge.svg)](https://github.com/ThalesMMS/rusty-dicom-node/actions/workflows/ci.yml)
[![License: MIT OR Apache-2.0](https://img.shields.io/badge/license-MIT%20OR%20Apache--2.0-blue.svg)](#license)

A terminal-first DICOM node client built around `dicom-rs`.

## Release status

This repository does not publish GitHub releases yet. For now, treat `main` as a build-from-source prerelease track, not a stable packaged product.

- Track packaging-facing changes in [`CHANGELOG.md`](CHANGELOG.md).
- Use the prerelease-only versioning and release gates in [`docs/release-checklist.md`](docs/release-checklist.md).
- Until a tagged prerelease exists, installation support is source-first and no binary artifact contract is promised yet.

This project intentionally does **not** include any image viewer, thumbnailer, or preview feature. It focuses on:

- Remote DICOM node persistence and editing
- C-FIND study/series/image querying
- C-MOVE retrieval with an embedded storage SCP
- Local study indexing in SQLite (schema is initialized/updated automatically on startup; see `src/db.rs`)
- C-STORE sending of local study/series content to other nodes
- Importing DICOM files from directories recursively (with configurable safety limits)
- Importing ZIP files containing DICOM files, even when the files do not use a `.dcm` extension (with ZIP safety hardening)
- A `ratatui` + `crossterm` command-driven TUI

## Installation

Until the first tagged prerelease exists, the supported installation path is a local source build.

Prerequisites:

- Rust 1.88 or newer
- Cargo
- A C compiler for the bundled SQLite dependency used by `rusqlite`

Build from source:

```bash
git clone https://github.com/ThalesMMS/rusty-dicom-node.git
cd rusty-dicom-node
cargo build --release
./target/release/dicom-node-client --help
```

On Windows:

```powershell
target\release\dicom-node-client.exe --help
```

Install locally from a checkout:

```bash
cargo install --path .
dicom-node-client --help
```

## Quick start (first success)

This section is written to get you from zero to a successful end-to-end run:

- configure your **local AE title**
- add a **remote node**
- run a **C-FIND** query
- **retrieve** a study (C-MOVE)
- **import** from disk into the local index
- inspect the local inventory
- **send** to another node (C-STORE)
- check logs / task results

All commands below assume you are in a source checkout and use `cargo run -- ...`.
After `cargo install --path .`, replace `cargo run --` with `dicom-node-client`.

### 0) Build + verify the binary

```bash
cargo build --release
./target/release/dicom-node-client --help
```

### 1) Initialize config and learn where data lives

On first run, the app creates:

- a config file (paths depend on OS)
- a local SQLite database
- a managed storage directory for received/imported objects

Run any command once to initialize:

```bash
cargo run -- --help >/dev/null
```

Then find the config + data locations:

- See **“Configuration”** and **“Log locations”** sections below in this README.
- See [`docs/node-setup.md`](docs/node-setup.md) for a deeper explanation of AE titles, nodes, and move destinations.
- See [`docs/query-filters.md`](docs/query-filters.md) for supported query levels and filters.
- See [`docs/retrieve-c-move.md`](docs/retrieve-c-move.md) for C-MOVE retrieval prerequisites, examples, and troubleshooting.
- See [`docs/import-and-local-indexing.md`](docs/import-and-local-indexing.md) for importing from disk and what gets indexed locally.
- See [`docs/send.md`](docs/send.md) for sending local studies/series (C-STORE SCU) to another node.
- See [`docs/storage-scp.md`](docs/storage-scp.md) for running a standalone Storage SCP (C-STORE receiver).
- See [`docs/logs-and-troubleshooting.md`](docs/logs-and-troubleshooting.md) for log locations, verbosity, and troubleshooting common failures.

Notes:

- Your **local AE title** is what remote nodes will use as the *move destination* for C-MOVE.
- C-MOVE requires that something is listening as a **storage SCP** for the move destination AE.
  `dicom-node-client retrieve ...` will start an embedded storage SCP automatically when needed.

### 2) Add a remote node

Create a named entry for a PACS / test SCP you can reach:

```bash
cargo run -- node add \
  --name pacs \
  --ae-title PACSAE \
  --host 10.0.0.10 \
  --port 104 \
  --move-destination DICOMNODECLIENT

cargo run -- node list
```

- `--name` is a local nickname used by other commands (`--node pacs`).
- `--ae-title/--host/--port` describe the remote peer.
- `--move-destination` is the default destination AE used by `retrieve` if you don’t override it.

### 3) Run a first query (C-FIND)

```bash
cargo run -- query \
  --node pacs \
  --patient-name "DOE^JOHN" \
  --study-date-from 20240101 \
  --study-date-to 20241231 \
  --modality CT
```

If you want machine-readable output:

```bash
cargo run -- query --node pacs --patient-name "DOE^JOHN" --json
```

### 4) Retrieve a study (C-MOVE)

You need a Study Instance UID from query results:

```bash
cargo run -- retrieve \
  --node pacs \
  --study-instance-uid 1.2.3.4.5 \
  --move-destination DICOMNODECLIENT
```

What to expect:

- progress is shown in the terminal
- datasets are written under the app’s managed storage directory (see config)
- the local SQLite index is updated as objects arrive

### 5) Import local files into the index (filesystem or ZIP)

If you already have DICOM files on disk:

```bash
cargo run -- import /path/to/folder-or-archive.zip
```

Use `--json` to capture an operation summary:

```bash
cargo run -- import /path/to/folder-or-archive.zip --json
```

### 6) Inspect the local inventory

```bash
cargo run -- local studies
```

More details (filters, series listing, export, and TUI drill-down):

- docs: [Local inventory inspection](./docs/local-inventory-inspection.md)


### 7) Send to another node (C-STORE SCU)

First add (or reuse) a destination node:

```bash
cargo run -- node add --name archive --ae-title ARCHIVEAE --host 10.0.0.11 --port 104
```

Send an entire study (by Study Instance UID):

```bash
cargo run -- send study --study-instance-uid 1.2.3.4.5 --destination-node archive
```

Or send a single series:

```bash
cargo run -- send series --series-instance-uid 1.2.3.4.5.6 --destination-node archive
```

### 8) Check logs / task summaries

- CLI commands print a human summary; many support `--json`.
- The TUI has a dedicated **Tasks** pane to inspect running/finished operations.
- Logs are also written to disk (see "Log locations" below).

### TUI (same workflow)

Start the TUI:

```bash
cargo run -- tui
```

Common first-success flow in the TUI:

1. Add a node: focus **Nodes** pane → press `a` (or type `node add ...` in the input prompt).
2. Query: select a node → press `f` (or type `query node=pacs ...`).
3. Retrieve: in the **Query** pane → press `m` on a selected result (or type `retrieve node=pacs study_uid=...`).
4. Import: in the **Local** pane → press `i` (or type `import path=...`).
5. Inspect: in **Local** pane, use `Enter` to drill down studies → series → instances.
6. Send: in **Local** pane → press `s` (or type `send-study ...` / `send-series ...`).
7. Review results: focus **Tasks** or **Logs** pane.

### TUI panes

Most list panes now include a right-side header counter showing the current selection and total items (for example `3/120`, or `-/0` when nothing is selected or the list is empty). When a list contains more items than can fit in the current pane height, the UI shows small up/down indicators (`▲` / `▼`) to hint that more items exist off-screen.

The Logs pane header shows how many log entries are visible vs total, and indicates when older entries are hidden by the visible window ("capped").

Background tasks (query/retrieve/import/send) run without freezing the UI. While a task is running, the footer shows a spinner + elapsed time and how many tasks are queued.

A Tasks pane is available for inspecting queued and recently finished tasks:

- Press `Tab` until the Tasks pane is focused.
- Use `Up/Down` (or `j/k`) to select a task.
- Press `t` to toggle between queued tasks and task history.
- Press `Enter` to open a task details modal, including per-task logs and the final status.

Tasks pane: focus, navigation, toggle, details

```text
Footer: / Running query node=pacs... 00:03 | 2 queued

[Tab] Tasks
> #12 Running  Querying pacs...       00:03
  #13 Queued   Retrieving from pacs...
  #14 Queued   Importing ./incoming...

Up/Down or j/k move selection  |  t queued/history  |  Enter details
```

Then enter commands at the bottom prompt:

```text
node add name=pacs ae=PACSAE host=10.0.0.10 port=104 dest=DICOMNODECLIENT
import path=/path/to/folder-or-archive.zip
query node=pacs patient_name="DOE^JOHN" date_from=20240101 date_to=20241231 modality=CT accession=ACC-123
retrieve node=pacs study_uid=1.2.3.4.5 dest=DICOMNODECLIENT
send-study node=archive study_uid=1.2.3.4.5
send-series destination_node=archive series_uid=1.2.3.4.5.6
```

After `cargo install --path .`, replace `cargo run --` with `dicom-node-client`.

## Build Requirements

`rusqlite` is built with bundled SQLite, so source builds need a working C compiler. GitHub Actions Ubuntu runners include the required compiler toolchain.

| Platform | Support | Notes |
| --- | --- | --- |
| Linux | Supported | Install Rust and the standard distribution build tools, including a C compiler. |
| macOS | Supported | Install Rust and Apple Command Line Tools or Xcode. |
| Windows | Supported | Install Rust with the MSVC toolchain and Microsoft C++ Build Tools. |

## Security checks (dependencies & supply chain)

This project uses two Rust ecosystem security tools:

- `cargo audit` (RustSec) to detect vulnerable or yanked dependencies.
- `cargo deny` to enforce policy around advisories, licenses, crate bans, and allowed sources.

Run locally from a checkout:

```bash
# RustSec advisories / yanked crates
cargo install cargo-audit --locked
cargo audit

# Policy checks (uses ./deny.toml)
cargo install cargo-deny --locked
cargo deny check
```

If CI fails:

- **Advisory/vulnerability**: update the dependency (preferred), or add a narrowly-scoped exception in `deny.toml` under the appropriate section (with a comment explaining why).
- **License issue**: either switch to an alternative dependency or update the `licenses.allow`/`licenses.exceptions` entries in `deny.toml`.
- **Source issue**: dependencies are expected to come from crates.io; git/path dependencies will be rejected by the `sources` policy.

## Testing

Run the full test suite, including in-process DICOM integration tests:

```bash
cargo test
```

The integration tests start C-FIND, C-MOVE, and C-STORE test SCPs in-process
using `dicom-ul`. They bind only to `127.0.0.1`, allocate ephemeral ports, and
use isolated temporary data directories so they can run in parallel without an
external PACS or DICOM service.

Incoming C-STORE datasets handled by the embedded `storage_scp` are streamed to
a per-request temporary file (rather than buffered fully in memory) before being
parsed and persisted into the managed `store/` directory. Temp files are cleaned
up on success and on most failure paths.

## Local inventory filtering & export limitations

- **Case-insensitive matching depends on SQLite behavior**: text filters use `LOWER(column) LIKE LOWER(?)` for substring matching. This is broadly case-insensitive for ASCII, but behavior for non-ASCII characters depends on SQLite build options and collation support.

- **Date/time filtering is lexicographic**: `study_date` and `imported_at` filters treat stored values as strings and apply inclusive ranges lexicographically. For reliable results:
  - Use `YYYYMMDD` for `study_date`.
  - Use a consistent, sortable timestamp format for `imported_at` (the app stores ISO/RFC3339-ish timestamps).

- **TUI filtering is partial**: the TUI supports filtering via command arguments for `local studies` (e.g. `local studies patient_name=doe modality=CT imported_at=20250101.. duplicate=true`). Export is **CLI-only**.

- **No "retrieved_at" support yet**: the current local index schema records `imported_at` timestamps, but does not record a separate retrieve timestamp.

## Troubleshooting: DICOM networking errors

The networking layer distinguishes several classes of failures so you can tell
"peer rejected the association" apart from "peer replied with a DIMSE failure
status" or "the connection dropped".

### Association negotiation failures

Examples:

- Wrong **called AE title** (peer rejects association)
- No acceptable **presentation context** / transfer syntax

What it means:

- The DICOM association was not established, so no DIMSE operation was sent.

What to check:

- You are connecting to the right host/port.
- The remote AE title matches what the peer expects.
- The operation's SOP Class / transfer syntax is supported by the peer.

### Malformed DIMSE response

Examples:

- Response command set is missing required elements (e.g. Status)
- Response command field does not match the expected response type

What it means:

- The peer sent an invalid DIMSE response (or bytes were corrupted / decoded
  incorrectly). This is treated as a parse/validation error, not a status
  failure.

What to check:

- Peer implementation quirks; try capturing traffic with a DICOM-capable proxy.
- Confirm both sides agree on transfer syntax and maximum PDU length.

### DIMSE status failure / warning / cancel

Examples:

- `status=0x0000` success
- `status=0xFF00/0xFF01` pending (multi-response operations like C-FIND/C-MOVE)
- `status=0xBxxx` warning (operation completed with warnings)
- `status=0xAxxx` / `0xCxxx` failure
- `status=0xFE00` cancel

What it means:

- The peer parsed the request and produced a semantic result. Failures often
  include a short meaning (and sometimes a hint) to help diagnose the cause.

What to check:

- For C-MOVE failures, verify the move destination AE title is known to the
  PACS.
- For C-STORE failures, verify SOP classes / transfer syntaxes are accepted.

### Timeout waiting for response

What it means:

- The association was established, but no response arrived before the configured
  receive timeout.

What to check:

- Peer performance / load.
- Network stability.
- Whether the peer keeps the connection open while processing.

### Transport interruption (connection drop)

Examples:

- TCP connection reset/closed mid-operation

What it means:

- The association was interrupted at the transport layer while waiting for a
  DIMSE response.

What to check:

- Middleboxes/NAT/firewalls dropping idle connections.
- Peer crash/restart.
- MTU / network path issues if failures correlate with large datasets.

## Data Storage Locations

Application data is stored in the platform-specific local data directory:

- Linux: `~/.local/share/rusty-dicom-node/`
- macOS: `~/Library/Application Support/com.ThalesMMS.rusty-dicom-node/`
- Windows: `%LOCALAPPDATA%\ThalesMMS\rusty-dicom-node\`

The data directory contains:

- `config.json` - application configuration
  - The embedded Storage SCP (C-STORE/C-ECHO) now supports inbound association allowlists:
    - `allowed_calling_aet`: list of allowed **Calling AE Titles**.
    - `allowed_peer_ips`: list of allowed peer IPs, as exact IPs (e.g. `127.0.0.1`) or CIDR ranges (e.g. `10.0.0.0/8`, `fd00::/8`).

    If a list is empty or omitted, that check is skipped (backward-compatible allow-all behavior). If both lists are configured, **both** must match (AND).

    Example snippet:

    ```json
    {
      "allowed_calling_aet": ["MODALITY1", "PACS_A"],
      "allowed_peer_ips": ["127.0.0.1", "10.0.0.0/8", "192.168.1.0/24"]
    }
    ```

    Security note: AE Titles are not strong authentication; combine with network controls (firewalls/VPN) as needed.
- `rusty-dicom-node.sqlite3` - local SQLite index
  - The main catalog table is `local_instances`.
  - Study list ordering is backed by a `local_studies` summary table + index (`idx_local_studies_ordering`).
  - Numeric ordering for SeriesNumber / InstanceNumber uses persisted sort keys on `local_instances` (e.g. `series_number_sort_class`, `series_number_sort_int`, `instance_number_sort_class`, `instance_number_sort_int`).
  - Upgrade note: on first run after upgrading, SQLite may spend time backfilling the new summary rows/sort keys and building indexes. This is a one-time cost.
  - Compatibility note: the catalog schema avoids SQLite generated columns/expression indexes, so it should work on older SQLite versions (the app builds `rusqlite` with bundled SQLite).
- `store/` - managed local DICOM object storage
- `logs/` - application logs

Existing users upgrading from pre-release versions will have data from the
legacy location migrated automatically.

## Command interfaces

This project exposes two command surfaces:

- CLI for scripting and automation, using `subcommand --flag value`
- TUI for interactive use, using `command key=value`

The TUI accepts both canonical parameter names and short aliases. Canonical
TUI names match the CLI flag names without the leading `--`, using underscores
instead of hyphens. When a value contains spaces or shell-sensitive characters,
quote it in the TUI input, for example `patient_name="DOE^JOHN"` or
`study_description="Head CT"`.

### CLI syntax

Use the CLI when you want shell history, scripts, or automation:

```bash
dicom-node-client node add --name pacs --ae-title PACSAE --host 10.0.0.10 --port 104 --move-destination DICOMNODECLIENT --notes "Primary archive"
dicom-node-client node edit pacs --host 10.0.0.11 --port 11112 --move-destination DICOMNODECLIENT
dicom-node-client node delete pacs
dicom-node-client node list

dicom-node-client import /data/inbox

# Local inventory listing (filtering + export)
dicom-node-client local studies --patient-name doe --modality CT,MR
dicom-node-client local studies --study-date 20240101..20241231 --duplicate false
dicom-node-client local studies --imported-at ..2025-01-01T00:00:00Z --export json
dicom-node-client local studies --export csv --out /tmp/studies.csv

# Exported fields
#
# Exports are metadata-only (no pixel data / bulk binary content).
# JSON uses these exact keys; CSV uses the same names as headers.
#
# Study export row (local studies)
# - study_instance_uid: Stable StudyInstanceUID (primary identifier)
# - patient_name: PatientName (as indexed)
# - patient_id: PatientID (as indexed)
# - accession_number: AccessionNumber (may be empty)
# - study_date_max: Latest StudyDate seen for the study (string, typically YYYYMMDD)
# - study_description: StudyDescription
# - modalities: Comma-separated distinct modalities observed in the study
# - series_count: Number of series indexed for the study
# - instance_count: Number of instances indexed for the study
#
# Series export row (local series)
# - study_instance_uid: Parent StudyInstanceUID
# - series_instance_uid: Stable SeriesInstanceUID (primary identifier within the study)
# - series_number: SeriesNumber (may be null/empty depending on source)
# - series_description: SeriesDescription
# - modality: Series modality
# - instance_count: Number of instances indexed for the series
# - imported_at_max: Latest imported_at timestamp among instances in the series (string)

# List series within a study (supports filters + export)
dicom-node-client local series 1.2.3.4.5 --modality CT --duplicate true
dicom-node-client local series 1.2.3.4.5 --export csv

dicom-node-client query --node pacs --model study-root --level study --patient-name "DOE^JOHN" --patient-id MRN-123 --accession-number ACC-123 --study-instance-uid 1.2.3 --series-instance-uid 1.2.3.4 --sop-instance-uid 1.2.3.4.5 --study-date-from 20240101 --study-date-to 20241231 --modality CT --study-description "Head CT"
dicom-node-client retrieve --node pacs --study-instance-uid 1.2.3 --series-instance-uid 1.2.3.4 --sop-instance-uid 1.2.3.4.5 --move-destination DICOMNODECLIENT
dicom-node-client send study --study-instance-uid 1.2.3 --destination-node archive
dicom-node-client send series --series-instance-uid 1.2.3.4 --destination-node archive
dicom-node-client storage-scp
```

### TUI syntax

Inside the TUI, the command line at the bottom accepts the same operations in
`key=value` form:

```text
help
refresh
node add name=pacs ae=PACSAE host=10.0.0.10 port=104 dest=DICOMNODECLIENT notes="Primary archive"
node edit target=pacs ae_title=PACSAE host=10.0.0.11 port=11112 move_destination=DICOMNODECLIENT
node delete target=pacs
import path=/data/inbox
query node=pacs model=study level=study patient_name="DOE^JOHN" patient_id=MRN-123 accession=ACC-123 study_uid=1.2.3 series_uid=1.2.3.4 instance_uid=1.2.3.4.5 date_from=20240101 date_to=20241231 modality=CT study_description="Head CT"
retrieve node=pacs study_instance_uid=1.2.3 series_instance_uid=1.2.3.4 sop_instance_uid=1.2.3.4.5 move_destination=DICOMNODECLIENT
send-study destination_node=archive study=1.2.3
send-series node=archive series_instance_uid=1.2.3.4
```

### TUI alias support

The TUI accepts the following short aliases in addition to canonical names:

- `ae` or `ae_title`
- `dest` or `move_destination`
- `accession` or `accession_number`
- `study` or `study_uid` or `study_instance_uid`
- `series` or `series_uid` or `series_instance_uid`
- `instance_uid` or `sop_instance_uid`
- `date_from` or `study_date_from`
- `date_to` or `study_date_to`
- `node` or `destination_node` for `send-study` and `send-series`

### CLI to TUI parameter mapping

| CLI flag or argument | TUI canonical name | TUI alias or shorthand |
| --- | --- | --- |
| `--ae-title` | `ae_title` | `ae` |
| `--move-destination` | `move_destination` | `dest` |
| `--accession-number` | `accession_number` | `accession` |
| `--study-instance-uid` | `study_instance_uid` | `study_uid`, `study` |
| `--series-instance-uid` | `series_instance_uid` | `series_uid`, `series` |
| `--sop-instance-uid` | `sop_instance_uid` | `instance_uid` |
| `--study-date-from` | `study_date_from` | `date_from` |
| `--study-date-to` | `study_date_to` | `date_to` |
| `--destination-node` | `destination_node` | `node` |
| positional `node` in `node edit` and `node delete` | `target` | `id`, `name` |
| positional import path | `path` | none |

The CLI uses `send study` and `send series` subcommands, while the TUI uses the
hyphenated commands `send-study` and `send-series`.

## Import safety limits

Imports (directories and ZIP archives) are designed to be streaming and bounded-memory, and can be constrained via `config.json` to reduce risk from extremely large trees or archives.

Common import-related limits (all optional; `null` disables a limit):

- `max_file_import_bytes`: reject single files larger than this (checked via file metadata before reading).
- `max_import_total_files`: stop scanning once this many candidates have been seen.
- `max_import_directory_depth`: maximum recursion depth when importing a directory.
- `max_import_path_length`: reject overly-long filesystem paths / ZIP entry paths.

ZIP-specific hardening limits (all optional):

- `max_zip_entry_count`: maximum number of entries processed from an archive.
- `max_zip_entry_bytes`: maximum uncompressed size per entry.
- `max_zip_total_bytes`: maximum total uncompressed bytes processed across all entries.

ZIP safety notes:

- Unsafe entry paths (absolute paths, `..` components) are rejected.
- If a ZIP contains multiple entries targeting the same normalized path, later entries are rejected (no overwrite).

## Import summary counts

After an import, the summary includes:

- `scanned_files`: candidates encountered (directory entries or ZIP entries).
- `accepted`: successfully imported and persisted.
- `duplicates`: candidates identified as already present in the index (with a breakdown by duplicate cause).
- `invalid_dicom`: candidates that could be read but did not parse as a valid DICOM object.
- `unreadable`: candidates that could not be read/staged (permissions, I/O errors, limit rejections, ZIP corruption, unsafe ZIP paths, etc.).
- `skipped`: candidates skipped intentionally (if applicable).
- `failed_cleanup`: candidates where a temp/staged file cleanup failed.

## Operation summaries (CLI + TUI)

Most network and ingest commands emit a structured **operation summary** at the end.

- In the **CLI**, the default output includes the normal command output (for example query matches, import report, etc.) followed by a concise summary block.
- In the **TUI**, completed tasks show the same summary content in the task details modal.

### JSON output mode

For scripting, supported commands also accept `--json` to emit a stable JSON summary (instead of human-readable output):

```bash
# Query (C-FIND)
dicom-node-client query --node pacs --patient-name "DOE^JOHN" --json

# Retrieve (C-MOVE)
dicom-node-client retrieve --node pacs --study-instance-uid 1.2.3 --move-destination DICOMNODECLIENT --json

# Send (C-STORE SCU)
dicom-node-client send study --study-instance-uid 1.2.3 --destination-node archive --json

# Import (directory or zip)
dicom-node-client import ./incoming --json

# Storage SCP session
dicom-node-client storage-scp --json
```

The JSON shape is designed to be stable across versions:

- A schema version field is included (`schema_version`).
- Enums serialize to explicit strings (do not rely on Rust `Debug` output).
- Optional fields are omitted when not applicable.

### Log references

Summaries may include `logs` references pointing at the application's log file (typically `logs/app.log`).

- CLI: use the `logs` path from the JSON summary, or read the path shown in the human-readable summary block.
- TUI: the task detail view shows the same summary (including the log path) so you can jump to the right file without guessing.

## Cancelling long-running tasks

Long-running operations (query/retrieve/import/send) run as background tasks so the TUI stays responsive.

### TUI

- Open the **Tasks** pane (press `Tab` until focused).
- Select the running task.
- Press `c` to request cancellation.

The task will immediately switch to **Cancelling**, then to **Cancelled** once the underlying operation reaches a cancellation checkpoint.

### CLI

While a long-running CLI operation is running, press **Ctrl-C** to request cooperative cancellation.

### What to expect

- Cancellation is **cooperative**: the operation stops at safe checkpoints. Some work may complete after you request cancellation, but new work should not be started once cancellation is observed.
- Partial results/counters (for example, instances sent or files imported before cancellation) may be shown in task details and history.
- Temporary/staging files are cleaned up best-effort on cancellation.

## Known Limitations

- Some DICOM protocol operations do not send protocol-level DIMSE cancel/abort; cancellation is implemented primarily via cooperative checkpoints.

## Layout

```text
src/
  cli.rs            clap command definitions
  config.rs         application paths and config
  db.rs             SQLite persistence
  dicom.rs          DICOM object helpers and dataset builders
  importer.rs       directory/ZIP import + indexer
  models.rs         domain models
  services.rs       application service layer
  tui.rs            interactive terminal UI
  net/
    assoc.rs        association helpers and DIMSE command builders
    find.rs         C-FIND SCU
    move_scu.rs     C-MOVE SCU
    store_scu.rs    C-STORE SCU
    storage_scp.rs  embedded C-STORE / C-ECHO SCP
    transfer.rs     supported storage SOP classes
```

## Notes

`config.json` now carries a `preferred_store_transfer_syntax` setting which controls the default C-STORE transfer syntax preference proposed to peers. Supported values are:

- `jpeg2000_lossless`
- `explicit_vr_little_endian`
- `implicit_vr_little_endian`
- `deflated_explicit_vr_little_endian`
- `explicit_vr_big_endian`

The default is `jpeg2000_lossless`.

## License

Licensed under either of Apache License, Version 2.0 or MIT license at your option.
