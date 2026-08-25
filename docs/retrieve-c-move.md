# Retrieve (C-MOVE)

This project can retrieve remote DICOM objects using a DICOM **C-MOVE** operation.

At a high level:

1. You run a C-MOVE request against a remote PACS (the **source**).
2. The source PACS opens a new association to the **move destination** AE and sends objects via C-STORE.
3. The move destination must therefore be running a **Storage SCP** (listener) and must be reachable from the source.

If you are moving studies to your local machine, the "destination" is typically the local Storage SCP that this project can run automatically (or that you run explicitly).

## Prerequisites

### 1) Remote node configuration

You need a configured remote node (the PACS you will query/retrieve from):

- `aet`: the remote AE Title
- `host`: hostname/IP
- `port`: the DICOM port

See [Node setup](./node-setup.md) for details and examples.

### 2) Move destination is configured and reachable

A C-MOVE requires a **move destination AE Title**. The source PACS will send the images to that AE.

Common choices:

- **Local destination**: move images to your local machine (recommended for evaluation).
- **Peer destination**: move images to another DICOM node you have configured.

Important constraints:

- The source PACS must be able to open an inbound connection to the destination host/port.
- Firewalls/NAT frequently break C-MOVE; if you are on a laptop behind NAT, you may need a VPN or to use a destination on the same network as the PACS.

### 3) A Storage SCP must be running at the destination

The move destination must accept inbound C-STORE requests.

- For **local moves**, the app can start a Storage SCP automatically when needed (depending on your configuration).
- You can also run Storage SCP explicitly via the CLI (`storage-scp`) for debugging.

See [Storage SCP](./storage-scp.md) for details.

## Retrieve via CLI

### Retrieve a study to the default destination

Retrieve a study by Study Instance UID:

```bash
dicom-node-client retrieve \
  --node <REMOTE_NODE_NAME> \
  --study-instance-uid <STUDY_UID>
```

Notes:

- `--node` selects the configured remote PACS.
- `--study-instance-uid` is required.
- The move destination is chosen based on your configuration and/or defaults.

### Retrieve a study to an explicit move destination

```bash
dicom-node-client retrieve \
  --node <REMOTE_NODE_NAME> \
  --study-instance-uid <STUDY_UID> \
  --move-destination <DEST_AET>
```

Where `<DEST_AET>` is the AE Title of the destination.

### Retrieve a specific series (optional)

If you only want a single series:

```bash
dicom-node-client retrieve \
  --node <REMOTE_NODE_NAME> \
  --study-instance-uid <STUDY_UID> \
  --series-instance-uid <SERIES_UID>
```

### Retrieve a specific instance (optional)

```bash
dicom-node-client retrieve \
  --node <REMOTE_NODE_NAME> \
  --study-instance-uid <STUDY_UID> \
  --sop-instance-uid <SOP_UID>
```

### JSON output

To emit a machine-readable operation summary:

```bash
dicom-node-client retrieve --json \
  --node <REMOTE_NODE_NAME> \
  --study-instance-uid <STUDY_UID>
```

## Retrieve via TUI

The TUI runs retrieval as a background task.

Typical flow:

1. Start the TUI:

   ```bash
   dicom-node-client tui
   ```

2. Ensure you have a remote node configured (Nodes pane).
3. Run a query against that node (Query pane).
4. Select a query result.
5. Trigger **Retrieve** (via the Retrieve modal/action; see the on-screen help).
6. Monitor progress in the **Tasks** pane, and inspect task logs/details.

If the retrieval requires a specific move destination, the retrieve modal lets you enter it.

## Expected output and progress

C-MOVE progress depends on the remote PACS implementation.

Common patterns:

- You may see periodic progress updates (remaining/completed/failed sub-operations).
- Final status may still be "success" even if some instances failed, depending on the DIMSE status.

In the CLI, results are summarized at completion; in the TUI, you can inspect task details.

## Cancellation and timeouts

- In the **TUI**, retrieval runs as a cancelable task; you can cancel it from the Tasks pane.
- In the **CLI**, retrieval runs to completion; use Ctrl+C to stop the process.

Timeouts can manifest as:

- association negotiation failures
- DIMSE timeouts mid-transfer
- the source never opening a store association to the destination

When diagnosing timeouts, confirm:

- the destination Storage SCP is listening on the expected interface/port
- the source PACS can reach that address/port
- the move destination AE Title matches what the source expects

## Troubleshooting checklist

1. **Association rejected**: verify AE Titles, host/port, and that the remote node allows your calling AE.
2. **Nothing arrives at destination**: destination may not be reachable from the source (firewall/NAT), or wrong move destination AET.
3. **Partial retrieve**: check DIMSE final status and any failed sub-operations.
4. **Local indexing**: receiving objects does not automatically mean they are indexed in the local DB; see [Import + local indexing](./import-and-local-indexing.md).

## Related documentation

- [Node setup](./node-setup.md)
- [Query filters](./query-filters.md)
- [Storage SCP](./storage-scp.md)
- [Import + local indexing](./import-and-local-indexing.md)
