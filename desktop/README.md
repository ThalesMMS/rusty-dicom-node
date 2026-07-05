# DICOM Node — Desktop UI

A [Tauri 2](https://v2.tauri.app) desktop app for `dicom-node-client`. It reuses the
core library (`AppServices`) directly — same config, same SQLite archive, and the
same data directory as the CLI/TUI, so both frontends can be used interchangeably.

## Features

- **Dashboard** — local node status, archive stats, quick actions
- **Query / Retrieve** — C-FIND against a remote node with C-MOVE retrieval (cancellable)
- **Local Archive** — browse studies/series, C-STORE send to any configured node
- **Remote Nodes** — add / edit / delete peers
- **Import** — recursive directory or ZIP import with live progress
- **Storage Server** — start/stop the standalone storage SCP and watch live metrics

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
- `src/` — React + TypeScript frontend (Vite). `src/types.ts` mirrors the Rust serde
  models; `src/api.ts` wraps `invoke` calls.
- Import progress is streamed to the UI via the `import-progress` Tauri event.
