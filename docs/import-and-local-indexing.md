# Importing DICOM and local indexing

This project can ingest (“import”) DICOM files from your filesystem and index a subset of metadata into a local SQLite database for fast browsing/filtering and for sending studies/series to other nodes.

## What “import” does (high level)

When you import a path (file or directory):

1. The importer traverses the path and identifies candidate files.
2. Each file is parsed as DICOM.
3. Key tags are extracted and written into the local database (patients / studies / series / instances).
4. The source file path and import timestamp are recorded.
5. Duplicate handling:
   - Instances which have already been imported are marked as duplicates (but are still tracked).
   - Corrupt/unreadable inputs are skipped and reported.

Notes:
- Importing does **not** perform any network operation.
- Importing is distinct from *retrieving* (C-MOVE) and *sending* (C-STORE).

## CLI: import

Import a file or directory:

```bash
dicom-node-client import /path/to/dicom
```

Get a stable JSON summary instead of human text:

```bash
dicom-node-client import --json /path/to/dicom
```

What to expect:
- Progress is reported as the importer walks the directory tree.
- At the end you’ll see an operation summary including how many files were imported, skipped, or marked duplicate.

## TUI: import

In the TUI, importing is available from the **Local** pane.

Typical flow:

1. Start the TUI:

   ```bash
   dicom-node-client tui
   ```

2. Focus the **Local** pane (use `Tab` / `Shift+Tab`).
3. Press `i` to open the **Import** modal.
4. Enter a filesystem path and confirm.
5. The import runs as a background task; watch progress in the **Tasks** pane.

## What gets indexed

The local database is intended to support:

- Browsing local **studies** and **series**
- Filtering by common fields (patient, accession, modality, dates)
- Locating the set of instances belonging to a study/series for sending (C-STORE)

At minimum, the importer tracks:

- Patient identifiers (name / ID when present)
- Study identifiers (StudyInstanceUID, accession number, description, study date when present)
- Series identifiers (SeriesInstanceUID, modality, description when present)
- Instance identifiers (SOPInstanceUID)
- Source path and imported-at timestamp
- Duplicate status

Exact tag availability depends on the input data; missing tags remain empty.

## Duplicate and corrupt handling

- **Duplicates**: If an instance already exists in the local DB, the importer records the event as a duplicate.
- **Corrupt / non-DICOM**: Files which cannot be parsed as DICOM are skipped and counted as failures.

Use logs (see below) to diagnose why specific files were skipped.

## Verifying the import

After importing, you can verify local inventory:

- CLI:
  - `dicom-node-client local studies ...`
  - `dicom-node-client local series <study_instance_uid> ...`
- TUI:
  - Use the **Local** pane to browse studies and drill down into series and instances.

(See: `docs/local-inventory.md` for details on listing and filtering.)

## Troubleshooting

- If you see permission errors, ensure the process can read the input path.
- If you imported a directory but see zero results, confirm the directory actually contains DICOM files.
- For deeper diagnosis, consult log output (see `README.md` and `docs/...` for log locations).
