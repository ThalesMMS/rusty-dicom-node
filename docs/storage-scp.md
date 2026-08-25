# Storage SCP (C-STORE receiver)

`dicom-node-client storage-scp` runs a **DICOM Storage SCP** (a C-STORE receiver). Use it when you need a DICOM node that can accept inbound stores from a PACS or modality, or as the **receive endpoint for C-MOVE** (see also: [Retrieve (C-MOVE)](./retrieve-c-move.md)).

> Notes on parity
>
>- The CLI exposes a standalone `storage-scp` command.
>- The TUI does **not** expose a “run storage-scp forever” mode; however, the app can start an internal receiver automatically when doing local C-MOVE retrievals.

## When you need this

- **Receiving images pushed to you** (remote C-STORE SCU 3 your Storage SCP).
- **Receiving results of a C-MOVE** where the move destination AE title resolves to your machine.
- **Debugging interoperability** with a remote DICOM sender (association negotiation, presentation contexts, etc.).

## Prerequisites / concepts

### AE Title

Your Storage SCP listens under a **local AE title** (for example `DICOMNODECLIENT`). A remote sender must target that AE title when opening an association.

- The **remote** node config (in your `known_nodes`) is used when *you connect out* (query/retrieve/send).
- The **local AE title** is used when *others connect to you* (storage-scp / move destination).

See: [Node setup](./node-setup.md)

### Port and bind address

Storage SCP binds to a TCP address/port on your machine.

- If you bind to `127.0.0.1`, only local processes can connect.
- If you bind to `0.0.0.0`, other machines can connect (subject to firewall rules).

## Run it (CLI)

```bash
# Start a receiver with default config
# (Press Ctrl-C to stop)
dicom-node-client storage-scp
```

### JSON output

For scripting, `--json` emits a stable summary of the session when it exits:

```bash
dicom-node-client storage-scp --json
```

## Storage directory behavior

Incoming instances are written to a local storage directory (owned by the application).

What to expect:

- Files are stored on disk as they are received.
- Filenames/layout are implementation-defined (do not depend on a specific folder structure).
- This command is intended to be safe to run repeatedly; existing files are not modified.

## Interaction with local indexing

The local database/index is populated via **import**.

- `storage-scp` receives DICOM and writes it to disk.
- To make received content searchable via `dicom-node-client local ...` commands or the TUI **Local** pane, import the receiver’s storage directory after a session completes.

```bash
# Example: after receiving, import into the local DB
# (use the path shown in the storage-scp summary/logs)
dicom-node-client import /path/to/received/dicom
```

See: [Import and local indexing](./import-and-local-indexing.md)

## Stopping the server

- Press **Ctrl-C** to request shutdown.
- The server should stop accepting new associations and exit.

## Troubleshooting

- **Association rejected / can’t connect**: verify bind address/port, firewall rules, and that the remote sender targets your local AE title.
- **C-MOVE sends nothing**: confirm the *move destination AE title* resolves (on the remote PACS) to your host/port, and that your Storage SCP is reachable.
- **Where are the logs?**: see [Logs and troubleshooting](./logs-and-troubleshooting.md) and the `logs` path in the operation summary.

## Related documentation

- [Node setup](./node-setup.md)
- [Retrieve (C-MOVE)](./retrieve-c-move.md)
- [Import and local indexing](./import-and-local-indexing.md)
- [CLI/TUI parity checklist](./cli-tui-parity.md)
