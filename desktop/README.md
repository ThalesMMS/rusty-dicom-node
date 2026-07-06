# DICOM Node — Desktop UI

A [Tauri 2](https://v2.tauri.app) desktop app for `dicom-node-client`. It reuses the
core library (`AppServices`) directly — same config, same SQLite archive, and the
same data directory as the CLI/TUI, so both frontends can be used interchangeably.

## Features

- **Dashboard** — operator overview, live counters, recent studies, and quick actions
- **Query / Retrieve** — C-FIND against a remote node with C-MOVE retrieval (cancellable)
- **Local Archive** — study → series → instance drill-down, C-STORE send, file reveal, and CSV/JSON export
- **Remote Nodes** — add / edit / delete peers with inline validation
- **Import** — recursive directory or ZIP import with live progress and session path shortcuts
- **Storage Server** — start/stop the standalone storage SCP and watch live metrics/deltas
- **Logs** — bounded tail of the active `logs/app.log` file with Finder reveal

## Development

Prerequisites: Rust 1.88+, Node 18+, and the [Tauri 2 system deps](https://v2.tauri.app/start/prerequisites/).

```bash
cd desktop
npm install
npm run tauri dev
```

## Build a release bundle

```bash
cd desktop
npm run tauri build
```

Bundles are produced under `desktop/src-tauri/target/release/bundle/`.

## Architecture

- `src-tauri/src/lib.rs` — Tauri commands wrapping `dicom_node_client::services::AppServices`.
  Long-running operations (query, retrieve, import, send) run on blocking threads with
  a per-task cancel flag; the frontend can cancel them via `cancel_task`.
- The desktop app initializes the same stable `logs/app.log` file as the CLI and exposes
  bounded log tailing via `tail_log`.
- Archive export uses the shared library export helpers: all studies, or series for the
  selected study, in CSV/JSON.
- `src/` — React + TypeScript frontend (Vite). `src/types.ts` mirrors the Rust serde
  models; `src/api.ts` wraps `invoke` calls.
- Import progress is streamed to the UI via the `import-progress` Tauri event.
