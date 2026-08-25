# Local inventory inspection

This project maintains a **local SQLite index** of imported DICOM so you can quickly inspect what you have on disk and (optionally) send it to a peer.

If you haven’t imported anything yet, start with:

- [Importing and local indexing](./import-and-local-indexing.md)

## What “local inventory” means

- The **import step** reads DICOM files from a path/zip and writes them into the local storage area.
- Metadata (patient/study/series/instance identifiers + a few common fields) is inserted into the local database.
- The **local commands/panes** read from that database; they do not query remote PACS.

## CLI: list local studies

List studies currently indexed locally:

```bash
dicom-node local studies
```

Common filters (can be combined):

```bash
# Filter by patient name (substring match)
dicom-node local studies --patient-name "DOE"

# Filter by patient id
dicom-node local studies --patient-id "12345"

# Filter by accession number
dicom-node local studies --accession-number "A0001"

# Filter by study date range
# (range syntax is documented in query-filters.md)
dicom-node local studies --study-date "20240101-20240201"
```

### Export

The CLI supports exporting the study listing:

```bash
# Export as JSON
dicom-node local studies --export json --out studies.json

# Export as CSV
dicom-node local studies --export csv --out studies.csv
```

Notes:

- The desktop app can export all studies, or the series for the selected study, as CSV/JSON.
- The terminal TUI shows the data but does not export.
- If `--out` is omitted in the CLI, the command writes to stdout.

## CLI: list local series for a study

Given a Study Instance UID:

```bash
dicom-node local series 1.2.840.113619.2.55.3.604688433.1234.1678901234.567
```

You can additionally filter series:

```bash
# Filter by modality
dicom-node local series <STUDY_UID> --modality CT

# Filter by series number
dicom-node local series <STUDY_UID> --series-number 2
```

## TUI: inspect local inventory

Open the TUI:

```bash
dicom-node tui
```

### Navigation

- Use **Tab / Shift+Tab** to focus different panes.
- Go to the **Local** pane.

### Studies → series → instances drill-down

- The Local pane starts at the **studies** view.
- Press **Enter** on a study to drill down into its **series**.
- Press **Enter** on a series to drill down into its **instances**.
- Press **Esc** to go back up one level.

This drill-down is a TUI convenience; the CLI currently exposes studies and series listings (instances are not exposed as a separate CLI listing).

### Import from the Local pane

From the Local pane, press **i** to open the import modal and import a directory/zip, then return to the studies listing.

## Tips and troubleshooting

- If your Local pane/CLI list is empty, ensure you have imported content (see [Importing and local indexing](./import-and-local-indexing.md)).
- If you imported files but don’t see expected records, check logs (see the Logs pane in the TUI, or `RUST_LOG=debug dicom-node ...`).
- Some files may be skipped during import (corrupt DICOM, unsupported zip paths, duplicates) — the import summary/logs will tell you what happened.
