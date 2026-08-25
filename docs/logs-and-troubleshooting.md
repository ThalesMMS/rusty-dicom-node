# Logs and troubleshooting

This document covers:

- where `dicom-node-client` writes logs
- how to control verbosity
- common failure modes and how to diagnose them
- what to capture when filing a bug

It applies to both the **CLI** and the **TUI**.

## Log locations

On every run, `dicom-node-client` writes a stable log file:

- `logs/app.log` under the application data directory

The app data directory is platform-specific (see **Data Storage Locations** in the README):

- Linux: `~/.local/share/rusty-dicom-node/`
- macOS: `~/Library/Application Support/com.ThalesMMS.rusty-dicom-node/`
- Windows: `%LOCALAPPDATA%\ThalesMMS\rusty-dicom-node\`

So a typical full path looks like:

- Linux: `~/.local/share/rusty-dicom-node/logs/app.log`
- macOS: `~/Library/Application Support/com.ThalesMMS.rusty-dicom-node/logs/app.log`

### Using operation summaries to find the right log

Most long-running operations emit an **operation summary** at the end (and the TUI stores the same summary in task history).

- In the **CLI**, look for a summary field or line that references the log path.
- In the **TUI**, open the **Tasks** pane, select the task, press `Enter`, and look for the same `logs` reference.

## Verbosity controls

Logging is controlled via the standard `tracing` / `EnvFilter` mechanism.

### CLI

Set `RUST_LOG` when running the CLI:

```bash
# Info-level logs (default when RUST_LOG is not set)
RUST_LOG=info dicom-node-client query --node pacs --patient-name "DOE^JOHN"

# More detail
RUST_LOG=debug dicom-node-client retrieve --node pacs --study-instance-uid 1.2.3

# Very verbose (usually too much for normal use)
RUST_LOG=trace dicom-node-client import ./incoming

# Only this crate (reduces noise from dependencies)
RUST_LOG=dicom_node_client=debug dicom-node-client storage-scp
```

If the app crashes, also consider:

```bash
RUST_BACKTRACE=1 dicom-node-client ...
```

### TUI

The TUI uses the same logging system. Set `RUST_LOG` before launching:

```bash
RUST_LOG=dicom_node_client=debug dicom-node-client tui
```

Tip: if the TUI is running inside a terminal multiplexer (tmux/screen) or over SSH, capturing `logs/app.log` is usually the most reliable way to preserve diagnostic output.

## Common failure modes

### Association rejected / cannot connect

Symptoms:

- CLI errors like "connection refused", "timed out", or association rejected.
- TUI task ends in **Failed** with a message about association/connect.

Checklist:

1. Verify the peer is reachable (DNS/IP, routing, firewall):
   - try `ping` (if allowed) and `nc -vz <host> <port>` / `telnet <host> <port>`
2. Verify the remote node configuration:
   - correct `host` / `port`
   - correct remote **Called AE Title** (the peer's AE title)
3. Verify your local AE title:
   - many PACS enforce a whitelist of calling AEs
4. Check `logs/app.log` for association negotiation details.

Related docs:

- [Node setup](./node-setup.md)

### DIMSE status indicates failure

DICOM services can return failure or warning statuses even when the TCP association succeeds.

Symptoms:

- Query returns no results or terminates early.
- Retrieve/send completes but indicates partial success or failures.

Checklist:

- Look at the final summary block (CLI) or task details (TUI). It will usually contain a status code.
- Check remote logs (PACS side) if available.

Common causes:

- querying at the wrong level/model (study-root vs patient-root)
- requesting fields the peer does not support
- insufficient permissions on the PACS

Related docs:

- [Query filters](./query-filters.md)

### C-MOVE retrieval fails (no listener / wrong move destination)

C-MOVE sends objects to the **move destination AE**, which must have an active Storage SCP listening.

Symptoms:

- retrieve fails quickly with an error indicating move destination issues
- retrieve runs but reports zero completed objects

Checklist:

1. Ensure `--move-destination` (or the node's configured default) is correct.
2. Ensure something is listening for that destination:
   - CLI `retrieve` will start an embedded Storage SCP automatically when needed
   - or run a standalone listener: `dicom-node-client storage-scp`
3. Confirm that the destination AE title / host / port the PACS is configured to send to matches your machine.

Related docs:

- [C-MOVE retrieve](./retrieve-c-move.md)
- [Storage SCP](./storage-scp.md)

### Import failures (permissions / safety limits / ZIP hardening)

Symptoms:

- import reports unreadable files
- import fails with a message about limits
- ZIP imports reject entries

Checklist:

- Check filesystem permissions for the import path.
- For ZIPs: ensure the archive is not using unsafe paths (absolute paths, `..` traversal).
- If you expect large imports, review import safety limits in `config.json`.

Related docs:

- [Import and local indexing](./import-and-local-indexing.md)

### Local DB / storage permissions

Symptoms:

- errors writing to the database or store directory
- errors creating `logs/app.log`

Checklist:

- Confirm the application data directory is writable.
- On macOS: if running in a sandboxed environment or with tightened filesystem permissions, ensure the app can write under `~/Library/Application Support/...`.

## What to capture for a bug report

Include:

- the exact command (or the TUI command string) and what you expected
- the relevant portion of `logs/app.log`
- the operation summary (use `--json` when available)
- the node configuration involved (redact sensitive IPs/hostnames if needed)

If reporting a protocol interoperability issue, also include:

- remote node vendor/version (if known)
- whether the operation was C-FIND, C-MOVE, or C-STORE
- the query level/model and any key filters
