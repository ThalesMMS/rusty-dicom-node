# CLI/TUI parity checklist

This document tracks feature parity between the command-line interface (CLI)
and the text UI (TUI).

- **CLI**: `dicom-node-client ...`
- **TUI**: `dicom-node-client tui` (then type commands in the input pane or use pane shortcuts)

## Legend

- ✅ Supported
- ⚠️ Supported with limitations / notable differences
- ❌ Not supported
- 📝 Documented (link)
- 🧪 Tested (link)

## Parity matrix

| Operation | CLI support | TUI support | Documented | Tested | Notes / gaps |
| --- | --- | --- | --- | --- | --- |
| Launch UI | `tui` | `tui` | README: [Quick start](../README.md#quick-start) | — | — |
| Help / discover commands | `--help`, `help <cmd>` | `help` / `?` / `F1` help overlay | README: [TUI panes](../README.md#tui-panes) | 🧪 [tests/cli_help_smoke_integration.rs](../tests/cli_help_smoke_integration.rs) | TUI help is interactive; CLI help is via clap output. |
| Refresh UI / data | — | `refresh` / `r` | README: [TUI panes](../README.md#tui-panes) | — | TUI-only. |
| Quit | Ctrl-C / exit shell | `quit`/`exit` / `q` (when not in input) | README: [TUI panes](../README.md#tui-panes) | — | — |
| Node: add | `node add ...` | `node add ...` (command) / Nodes pane `a` | docs: [Node setup](./node-setup.md) | — | TUI supports both typed command and modal. |
| Node: edit | `node edit ...` | `node edit ...` (command) / Nodes pane `e` | docs: [Node setup](./node-setup.md) | — | — |
| Node: delete | `node delete ...` | `node delete ...` (command) / Nodes pane `d` | docs: [Node setup](./node-setup.md) | — | — |
| Node: list | `node list` | Nodes pane (list) | docs: [Node setup](./node-setup.md) | — | TUI is inherently list-based; CLI prints nodes. |
| Import: filesystem dir / file | `import <path>` | `import path=<path>` (command) / Local pane `i` | docs: [Import and local indexing](./import-and-local-indexing.md) | 🧪 [tests/batch_import_integration.rs](../tests/batch_import_integration.rs) | CLI accepts positional path; TUI uses `path=`. |
| Import: ZIP | `import <archive.zip>` | `import path=<archive.zip>` | docs: [Import and local indexing](./import-and-local-indexing.md) | 🧪 [tests/zip_*_integration.rs](../tests) | ZIP safety hardening applies to both. |
| Query: C-FIND | `query --node <name> ...` | `query node=<name> ...` / Nodes pane `f` (modal) | docs: [Query filters](./query-filters.md) | 🧪 [tests/find_integration.rs](../tests/find_integration.rs) | Filter names differ (CLI flags vs TUI key=value). |
| Retrieve: C-MOVE | `retrieve --node <name> --study-instance-uid ... [--move-destination ...]` | `retrieve node=<name> study_uid=... [dest=...]` / Query pane `m` (modal) | docs: [Retrieve (C-MOVE)](./retrieve-c-move.md) | 🧪 [tests/move_integration.rs](../tests/move_integration.rs) / 🧪 [tests/timeout_integration.rs](../tests/timeout_integration.rs) | Destination defaults/validation handled in shared core. |
| Send: C-STORE (from local inventory) | `send study ...` / `send series ...` | `send-study ...` / `send-series ...` / Local pane `s` (modal) | docs: [Send (C-STORE)](./send.md) | 🧪 [tests/store_integration.rs](../tests/store_integration.rs) | Send is local-inventory based. |
| Local inventory: list studies | `local studies ...` | `local studies ...` (command) / Local pane list | docs: [Local inventory inspection](./local-inventory-inspection.md) | 🧪 [tests/local_filters_and_export_integration.rs](../tests/local_filters_and_export_integration.rs) | TUI supports filters but does not support export. |
| Local inventory: drill-down (study→series→instances) | ❌ (no instances subcommand) | Local pane Enter/Esc navigation | docs: [Local inventory inspection](./local-inventory-inspection.md) | — | CLI supports studies+series; TUI additionally supports instance-level drill-down. |
| Local inventory: list series | `local series <study_instance_uid> ...` | Drill-down in Local pane (Enter) | docs: [Local inventory inspection](./local-inventory-inspection.md) | 🧪 [tests/local_filters_and_export_integration.rs](../tests/local_filters_and_export_integration.rs) | CLI requires explicit study UID; TUI navigates interactively. |
| Local inventory: export CSV/JSON | `local studies --export csv|json --out <file>` | ❌ | docs: [Local inventory inspection](./local-inventory-inspection.md) | 🧪 [tests/local_filters_and_export_integration.rs](../tests/local_filters_and_export_integration.rs) | Explicitly CLI-only today. |
| Run storage SCP (standalone) | `storage-scp` | ❌ | docs: [Storage SCP](./storage-scp.md) | — | TUI does not expose a “run storage-scp forever” mode. |
| Retrieve: embedded local storage SCP | ✅ (handled internally for local moves as needed) | ✅ (handled internally for local moves as needed) | docs: [Retrieve (C-MOVE)](./retrieve-c-move.md) | 🧪 [tests/move_integration.rs](../tests/move_integration.rs) | Both rely on shared core behavior. |
| View logs | CLI stdout/stderr + log file | Logs pane | docs: [Logs and troubleshooting](./logs-and-troubleshooting.md) | — | TUI provides in-app log view; CLI relies on terminal/file. |
| Task cancellation | Ctrl-C (process) | `cancel` command / Tasks pane `c` | README: [TUI panes](../README.md#tui-panes) | 🧪 [tests/cancellation_integration.rs](../tests/cancellation_integration.rs) | TUI supports per-task cancellation; CLI is per-process. |

## Gaps and decisions

This section explains intentional non-parity and what we plan to do about it.

### Intentional non-parity (document as not supported)

- **TUI-only UI affordances (refresh/help overlays, pane shortcuts)**
  - **Gap:** No equivalent CLI commands for `refresh` / `r` or interactive help overlays.
  - **Decision:** **Document as not supported**. These are UI-only concepts.
  - **Notes:** CLI users should rely on re-running commands and `--help`/`help <cmd>`.

- **TUI-only local instance drill-down (study → series → instances)**
  - **Gap:** CLI exposes `local studies` and `local series <study_uid>` but does not expose an instance-level listing subcommand.
  - **Decision:** **Document as not supported (for now)**.
  - **Reasoning:** Adding a new CLI command is a product surface expansion; out of scope for this documentation-focused task.

- **CLI-only local export (CSV/JSON)**
  - **Gap:** `local studies --export ... --out ...` exists only in CLI.
  - **Decision:** **Document as not supported in TUI**.
  - **Reasoning:** TUI currently focuses on interactive inspection; export is a batch/reporting feature.

- **CLI-only standalone `storage-scp` mode**
  - **Gap:** TUI does not provide a way to run an always-on storage SCP server.
  - **Decision:** **Document as not supported in TUI**.
  - **Notes:** Both CLI and TUI can still trigger an *embedded* local storage SCP when required by the shared C-MOVE “local destination” workflow.

### “Where practical” parity actions

- **Tests:** Add lightweight smoke tests that ensure CLI help lists expected top-level commands and subcommands. Avoid brittle snapshot tests.
- **Docs:** Ensure each supported operation has at least one CLI and one TUI example where applicable.

## Maintenance

This matrix is intentionally lightweight and should be updated when:

- a new CLI command is added/removed
- TUI gains/loses an operation or shortcut
- documentation or tests are added for an operation
