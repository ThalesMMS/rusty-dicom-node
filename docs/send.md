# Sending (C-STORE SCU)

This app can act as a **C-STORE SCU** (sender) to push locally stored DICOM instances to another DICOM node.

Supported sources:

- **Local inventory → send to configured node** (supported)
- Filesystem paths → send directly (not currently supported as a `send <path>` CLI; use `import` first, then `send`)

## Prerequisites

1. You have DICOM instances available locally.
   - Either retrieve them (C-MOVE) with [`retrieve`](./retrieve-c-move.md), or
   - import them from disk with [`import`](./import-and-local-indexing.md)
2. You have a **destination node** configured (AE title, host, port).
   - See [`docs/node-setup.md`](./node-setup.md)

## CLI

### 1) Add (or verify) the destination node

```bash
# Example destination node
cargo run -- node add \
  --name archive \
  --ae-title ARCHIVEAE \
  --host 10.0.0.11 \
  --port 104

cargo run -- node list
```

### 2) Send an entire study

Send all instances in a Study Instance UID from your local inventory:

```bash
cargo run -- send study \
  --study-instance-uid 1.2.3.4.5 \
  --destination-node archive
```

### 3) Send a single series

```bash
cargo run -- send series \
  --series-instance-uid 1.2.3.4.5.6 \
  --destination-node archive
```

### JSON output

Use `--json` on the top-level `send` command to print a final, stable-schema operation summary:

```bash
cargo run -- send --json study \
  --study-instance-uid 1.2.3.4.5 \
  --destination-node archive
```

## TUI

Sending is driven from the **Local** pane.

1. Start the TUI:

   ```bash
   cargo run -- tui
   ```

2. Ensure you have local data:
   - retrieve a study (C-MOVE), or
   - import from disk

3. Focus the **Local** pane (use `Tab` to cycle panes).

4. Press `s` to open the **Send** modal.

5. Choose:

- **Send study**: select a study UID and destination node
- **Send series**: drill into a study to select a series UID, then choose destination node

You can also type commands in the input prompt:

```text
send-study node=archive study_uid=1.2.3.4.5
send-series destination_node=archive series_uid=1.2.3.4.5.6
```

Progress is shown as a background task; inspect details in the **Tasks** pane.

## Notes / limitations

- The `send` operation only sends from objects that are present in the local inventory (SQLite + managed storage directory).
- If your destination node rejects associations or stores nothing, see the troubleshooting guidance in [`docs/retrieve-c-move.md`](./retrieve-c-move.md) and log inspection notes in the README.
