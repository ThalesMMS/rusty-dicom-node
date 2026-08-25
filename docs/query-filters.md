# Query levels and filters (CLI + TUI)

This project supports DICOM query/retrieve (Q/R) via **C-FIND** (query) and uses the results for **C-MOVE** (retrieve).

This document focuses on:

- Which **query levels** you can use
- Which **filters** are supported
- How those map to **CLI flags** and **TUI inputs**

> Note: “Query” here refers to remote **C-FIND** queries against a configured node. “Local inventory” filtering is documented separately.

## Query levels

You can query at these levels:

- **patient**
- **study**
- **series**
- **image** (instance)

### CLI

Use `--level`:

```bash
rusty-dicom-node query --node <NODE_NAME> --level study
```

### TUI

In the TUI, run a query via:

- Nodes pane: select a node and use the **query action** (opens a query modal), or
- Type a `query ...` command in the input pane.

The query UI/command includes a **level** field.

## Models (QueryInformationModel)

The query uses a DICOM *Query Information Model*.

### CLI

Use `--model`:

```bash
rusty-dicom-node query --node <NODE_NAME> --model study-root --level study
```

If omitted, the app uses its default query model.

### TUI

The query modal/command includes a **model** field (where supported).

## Filter mapping

Filters can be provided at different query levels. In general:

- **Patient-level** keys apply to patient/study/series/image queries.
- **Study-level** keys apply to study/series/image queries.
- **Series-level** keys apply to series/image queries.
- **Image-level** keys apply to image queries.

### Common CLI pattern

```bash
rusty-dicom-node query \
  --node <NODE_NAME> \
  --level study \
  --patient-name "DOE^JOHN" \
  --patient-id "12345" \
  --study-date "20250101-20251231"
```

### Common TUI pattern

Use the query modal and fill in the same fields (patient name/id, dates, modality, etc.).

If you prefer the command line inside the TUI input pane, use `query node=<...> level=<...> ...` and provide the same filter names shown in the UI.

## Supported filters

The exact set of filters is exposed by the CLI flags and TUI query modal/command.

Below is the canonical “what you can filter by” list as currently supported.

### Patient / study identity

- **Patient Name**
  - CLI: `--patient-name <NAME>`
  - TUI: Patient Name field
- **Patient ID**
  - CLI: `--patient-id <ID>`
  - TUI: Patient ID field

### Study

- **Study Instance UID**
  - CLI: `--study-instance-uid <UID>`
  - TUI: Study Instance UID field
- **Study Date**
  - CLI: `--study-date <DATE_OR_RANGE>`
  - TUI: Study Date field
- **Accession Number**
  - CLI: `--accession-number <VALUE>`
  - TUI: Accession Number field

### Series

- **Series Instance UID**
  - CLI: `--series-instance-uid <UID>`
  - TUI: Series Instance UID field
- **Modality**
  - CLI: `--modality <MODALITY>`
  - TUI: Modality field

### Image (instance)

- **SOP Instance UID**
  - CLI: `--sop-instance-uid <UID>`
  - TUI: SOP Instance UID field

## Date/range syntax

Some date-like keys accept a DICOM-style range expression:

- Single date: `YYYYMMDD`
- Open/closed ranges: `YYYYMMDD-YYYYMMDD`, `-YYYYMMDD`, `YYYYMMDD-`

Examples:

```bash
# studies on a single day
rusty-dicom-node query --node <NODE_NAME> --level study --study-date 20250115

# studies in a date range
rusty-dicom-node query --node <NODE_NAME> --level study --study-date 20250101-20250131
```

## Output formats

### Human-readable output (default)

By default, results are printed in a human-readable format.

### JSON output

If supported, use `--json`:

```bash
rusty-dicom-node query --node <NODE_NAME> --level study --json
```

This is useful for scripting.

## Limitations and gotchas

- A remote node may not support all combinations of model/level/keys; if you get no results, try a higher-level query (e.g., `study`) and fewer filters.
- Exact matching behavior is determined by the remote PACS/VNA.
- Patient name matching is often prefix/wildcard-based on the remote system; try `DOE*`-style patterns if your PACS supports them.

## See also

- [Node setup](./node-setup.md)
- Retrieve (C-MOVE) docs (see `docs/`)
