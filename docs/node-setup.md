# Node setup: AE titles, peers, and move destinations

This doc explains how `dicom-node-client` models DICOM peers (“nodes”), how AE titles are used, and how to configure things so that **C-FIND**, **C-MOVE** (retrieve), and **C-STORE** (send) work reliably.

> Scope: this is a workflow doc (CLI + TUI), not a full DICOM networking primer.

## Concepts

### Application Entity (AE) titles

- Every DICOM association has a **Calling AE title** (the client) and a **Called AE title** (the server).
- In this app:
  - Your **local AE title** is the calling AE title used when connecting to a remote node.
  - A configured node’s **AE title** is the called AE title used when connecting to that remote node.

### Nodes (known peers)

A **node** is a named entry in the app’s config which stores:

- `name` — a local nickname used by commands (for example `--node pacs`)
- `ae_title` — the remote peer’s Called AE title
- `host` / `port` — where to connect
- `move_destination` (optional) — default destination AE title to use for **retrieve** (C-MOVE)

### Move destinations (C-MOVE)

C-MOVE is different from C-FIND:

- With C-FIND, the remote node returns responses on the same association.
- With C-MOVE, the remote node **opens a new connection** to a *third party* (the **move destination AE**) and sends objects there using C-STORE.

In practice:

- The move destination AE title must be recognized by the remote PACS.
- There must be a **Storage SCP** listening for that AE title at a host/port reachable by the remote PACS.

`dicom-node-client retrieve ...` can start an embedded Storage SCP automatically when the move destination is local (see the retrieve docs for details).

## Where configuration lives

On first run the app creates:

- a config file
- a local SQLite database
- a managed storage directory (received/imported objects)

For details and paths, see README: **Configuration** and **Log locations**.

## Configure your local AE title

Your local AE title is used as the Calling AE title when the app connects to a remote node.

How to set it depends on whether you prefer editing the config file directly or using the TUI’s config editor.

### TUI

1. Run the TUI:

   ```bash
   dicom-node-client tui
   ```

2. Focus the **Config** pane (press `Tab` until it is selected).
3. Press `c` to open the config editor modal.
4. Set your local AE title (look for a field like `local_ae_title`).
5. Save and close.

### CLI / config file

Edit the config file directly and set the local AE title.

- Search for a key like `local_ae_title`.
- Use an uppercase string without spaces (common convention), for example `DICOMNODECLIENT`.

Then re-run a command (or restart the TUI) to pick up the new config.

## Add and manage nodes

### Add a node (CLI)

```bash
dicom-node-client node add \
  --name pacs \
  --ae-title PACSAE \
  --host 10.0.0.10 \
  --port 104 \
  --move-destination DICOMNODECLIENT
```

Notes:

- `--name` is your local nickname.
- `--ae-title/--host/--port` must match the remote node’s DICOM listener configuration.
- `--move-destination` sets a *default* destination AE for retrievals from this node.

List nodes:

```bash
dicom-node-client node list
```

Edit a node:

```bash
dicom-node-client node edit --name pacs --host 10.0.0.20
```

Delete a node:

```bash
dicom-node-client node delete --name pacs
```

### Add a node (TUI)

1. Run the TUI: `dicom-node-client tui`
2. Focus the **Nodes** pane.
3. Press:
   - `a` to add
   - `e` to edit the selected node
   - `d` to delete the selected node

You can also use typed commands in the input prompt:

- `node add name=pacs ae_title=PACSAE host=10.0.0.10 port=104 move_destination=DICOMNODECLIENT`
- `node edit name=pacs host=10.0.0.20`
- `node delete name=pacs`

## Verifying connectivity

There is no dedicated “ping” command.

The simplest connectivity check is to run a narrow query:

```bash
dicom-node-client query --node pacs --level study --patient-name "DOE^JOHN"
```

If associations are being rejected, see the troubleshooting section in README and the logs/troubleshooting doc.

## Common setup pitfalls

- **AE title mismatch**: remote node rejects the association, or routes C-MOVE to a destination it doesn’t know.
- **Port confusion**: DICOM listeners often run on 104 / 11112 / custom ports; verify your PACS configuration.
- **C-MOVE reachability**: the remote PACS must be able to reach the move destination’s host/port (NAT and firewalls are common blockers).
- **Move destination AE not registered on the PACS**: PACS may require whitelisting destination AEs.
