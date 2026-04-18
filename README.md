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
- Local study indexing in SQLite
- C-STORE sending of local study/series content to other nodes
- Importing DICOM files from directories recursively
- Importing ZIP files containing DICOM files, even when the files do not use a `.dcm` extension
- A `ratatui` + `crossterm` command-driven TUI

## Installation

Until the first tagged prerelease exists, the supported installation path is a local source build.

Prerequisites:

- Rust 1.75 or newer
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

## Quick start

From a source checkout:

### CLI syntax

```bash
cargo run -- node add --name pacs --ae-title PACSAE --host 10.0.0.10 --port 104 --move-destination DICOMNODECLIENT
cargo run -- import /path/to/folder-or-archive.zip
cargo run -- query --node pacs --patient-name "DOE^JOHN" --study-date-from 20240101 --study-date-to 20241231 --modality CT --accession-number ACC-123
cargo run -- retrieve --node pacs --study-instance-uid 1.2.3.4.5 --move-destination DICOMNODECLIENT
cargo run -- send study --study-instance-uid 1.2.3.4.5 --destination-node archive
cargo run -- send series --series-instance-uid 1.2.3.4.5.6 --destination-node archive
cargo run -- local studies
cargo run -- storage-scp
```

### TUI syntax

Start the TUI:

```bash
cargo run -- tui
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

## Data Storage Locations

Application data is stored in the platform-specific local data directory:

- Linux: `~/.local/share/rusty-dicom-node/`
- macOS: `~/Library/Application Support/com.ThalesMMS.rusty-dicom-node/`
- Windows: `%LOCALAPPDATA%\ThalesMMS\rusty-dicom-node\`

The data directory contains:

- `config.json` - application configuration
- `rusty-dicom-node.sqlite3` - local SQLite index
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
dicom-node-client local studies
dicom-node-client local series 1.2.3.4.5

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

## Known Limitations

- Long-running DICOM operations use synchronous I/O and may block the TUI until the operation completes.
- See `docs/dicom-node-client_github_issues.md` for the broader roadmap and release-blocking work.

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

MIT license.
