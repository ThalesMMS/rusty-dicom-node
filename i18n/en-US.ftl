# Fluent catalog (en-US). Message IDs are hyphenated identifiers
# (cli-about, tui-pane-remote-nodes, desktop-nav-dashboard, error-import-file-too-large).
# Dotted names are Fluent attributes (message + .attr), not message IDs.
# Do not translate DICOM tokens (C-FIND, C-MOVE, C-STORE, SOP, AE, UID) or JSON/CSV machine keys.


## CLI
cli-about = Terminal-first DICOM node client built with dicom-rs
cli-arg-accession-number = Filter by accession number (case-insensitive substring).
cli-arg-ae-title = Application Entity title
cli-arg-destination-node = Destination node name or id
cli-arg-duplicate = Filter by duplicate status.
cli-arg-export = Export results as JSON or CSV.
cli-arg-host = Hostname or IP
cli-arg-imported-at =
    Filter by import timestamp. Supports VALUE, START..END, ..END, START...
    Compared lexicographically (recommended format: RFC3339).
cli-arg-json = Output a final operation summary as JSON (stable schema).
cli-arg-level = Query/retrieve level
cli-arg-metrics-json = Print the final in-memory server metrics snapshot as JSON when the server exits.
cli-arg-modality = Filter by modality. Comma-separated list (e.g. CT,MR).
cli-arg-model = Query/retrieve information model
cli-arg-move-destination = Preferred C-MOVE destination AE title
cli-arg-name = Display name for the node
cli-arg-node = Saved node name or id
cli-arg-notes = Free-form notes
cli-arg-out = Output file path. If omitted, writes to stdout.
cli-arg-path = File or directory to import
cli-arg-patient-id = Filter by patient ID (case-insensitive substring).
cli-arg-patient-name = Filter by patient name (case-insensitive substring).
cli-arg-port = Port
cli-arg-series-description = Filter by series description (case-insensitive substring).
cli-arg-series-instance-uid = Series Instance UID
cli-arg-sop-instance-uid = SOP Instance UID
cli-arg-source-path = Filter by source path (case-insensitive substring).
cli-arg-study-date =
    Filter by study date. Supports VALUE, START..END, ..END, START...
    Dates are compared lexicographically (recommended format: YYYYMMDD).
cli-arg-study-date-from = Study date lower bound (YYYYMMDD)
cli-arg-study-date-to = Study date upper bound (YYYYMMDD)
cli-arg-study-description = Filter by study description (case-insensitive substring).
cli-arg-study-instance-uid = Study Instance UID
cli-cmd-import-about = Import DICOM files from a path
cli-cmd-local-about = Inspect the local archive
cli-cmd-local-series-about = List indexed series for a study
cli-cmd-local-studies-about = List indexed local studies
cli-cmd-node-about = Manage saved remote DICOM nodes
cli-cmd-node-add-about = Add a remote node
cli-cmd-node-delete-about = Delete a saved node
cli-cmd-node-edit-about = Edit a saved node
cli-cmd-node-list-about = List saved nodes
cli-cmd-query-about = Query a remote node (C-FIND)
cli-cmd-retrieve-about = Retrieve from a remote node (C-MOVE)
cli-cmd-send-about = Send local studies or series (C-STORE)
cli-cmd-send-series-about = Send a series to a destination node
cli-cmd-send-study-about = Send a study to a destination node
cli-cmd-serve-about = Run the DICOM server
cli-cmd-storage-scp-about = Run a Storage SCP listener
cli-cmd-tui-about = Open the interactive terminal UI
cli-flag-help = Print help
cli-flag-lang = UI language (BCP-47 tag). Overrides DICOM_NODE_LANG, persisted locale, and the OS locale.
cli-flag-version = Print version
cli-heading-arguments = Arguments:
cli-heading-commands = Commands:
cli-heading-options = Options:
cli-heading-usage = Usage:
cli-import-accepted = accepted={ $n }
cli-import-complete = Import complete
cli-import-duplicates = duplicates={ $n }
cli-import-scanned = scanned={ $n }
cli-msg-cancel-sigint = Cancellation requested (SIGINT). Waiting for graceful shutdown...
cli-msg-failures = failures:
cli-msg-import-failed = Import failed: { $error }
cli-msg-no-local-series = No indexed series for study { $uid }
cli-msg-no-local-studies = No indexed local studies
cli-msg-no-saved-nodes = No saved nodes
cli-msg-query-failed = Query failed: { $error }
cli-msg-removed-nodes =
    Removed { $count ->
        [one] { $count } node
       *[other] { $count } nodes
    }
cli-msg-results-count =
    Results: { $count ->
        [one] { $count } match
       *[other] { $count } matches
    }
cli-msg-retrieve-failed = Retrieve failed: { $error }
cli-msg-saved-node = Saved node { $name } [{ $id }] => { $ae }@{ $host }:{ $port }
cli-msg-send-failed = Send failed: { $error }
cli-msg-showing-failures = (showing first { $shown } of { $total } failures)
cli-msg-starting-server =
    Starting DICOM server with { $count ->
        [one] { $count } local AE
       *[other] { $count } local AEs
    }: { $aes }
cli-msg-starting-server-no-aes = Starting DICOM server with no configured local AEs
cli-msg-starting-storage-scp = Starting storage SCP at { $addr } with AE title { $ae }
cli-msg-updated-node = Updated node { $name } [{ $id }] => { $ae }@{ $host }:{ $port }
cli-send-attempted = attempted={ $n }
cli-send-failed-count = failed={ $n }
cli-send-sent = sent={ $n }
cli-value-name-file = FILE
cli-value-name-format = FORMAT
cli-value-name-locale = LOCALE
cli-value-name-path = PATH
tui-detail-more-series =
    ... { $n ->
        [one] { $n } more series
       *[other] { $n } more series
    }
tui-row-instance-count =
    { $n ->
        [one] { $n } inst.
       *[other] { $n } inst.
    }
tui-row-study-counts = { $series }s/{ $instances }i
count-nodes =
    { $n ->
        [one] { $n } node
       *[other] { $n } nodes
    }
count-instances =
    { $n ->
        [one] { $n } instance
       *[other] { $n } instances
    }
count-series =
    { $n ->
        [one] { $n } series
       *[other] { $n } series
    }
count-studies =
    { $n ->
        [one] { $n } study
       *[other] { $n } studies
    }
format-datetime = { $date } { $time }
format-date = { $month }/{ $day }/{ $year }

## Common
common-accession = Accession
common-add = Add
common-back = Back
common-bytes = Bytes
common-cancel = Cancel
common-clear = Clear
common-close = Close
common-date = Date
common-delete = Delete
common-description = Description
common-disabled = disabled
common-duplicates = Duplicates
common-edit = Edit
common-enabled = enabled
common-error = Error
common-filter = Filter
common-host = Host
common-import = Import
common-instance = Instance
common-language = Language
common-loading = Loading
common-matches = Matches
common-modality = Modality
common-name = Name
common-network = Network
common-no = no
common-none = none
common-notes = Notes
common-optional = optional
common-path = Path
common-patient = Patient
common-patient-id = Patient ID
common-patient-name = Patient name
common-port = Port
common-query = Query
common-refresh = Refresh
common-required = required
common-retrieve = Retrieve
common-save = Save
common-search = Search
common-send = Send
common-series = Series
common-start = Start
common-status = Status
common-stop = Stop
common-studies = Studies
common-study = Study
common-unknown = unknown
common-unknown-series = <unknown series>
common-unknown-study = <unknown study>
common-yes = yes

## Errors
error-ae-empty = AE title cannot be empty
error-ae-invalid-char = AE title contains invalid character '{ $character }'; allowed: A-Z, 0-9, space
error-ae-required = AE title is required
error-ae-too-long = AE title must be at most 16 characters
error-ae-whitespace = AE title cannot have leading or trailing whitespace
error-archive-patient-retrieve-out-of-scope = Patient level retrieve is out of scope
error-archive-retrieve-uid-required = { $name } is required for this retrieve level
error-archive-study-root-patient-query = Study Root queries do not support Patient level
error-archive-study-root-patient-retrieve = Study Root retrieve does not support Patient level
error-assoc-negotiation-failed = association negotiation failed with { $name } ({ $addr }); hint: verify called AE title, presentation contexts/transfer syntaxes, and that the peer accepts associations
error-assoc-no-addresses = no socket addresses resolved for { $name } at { $host }:{ $port }
error-assoc-receive = association receive
error-assoc-resolving = resolving { $name } at { $host }:{ $port }: { $err }
error-assoc-timeout = timeout waiting for DIMSE response; hint: check network connectivity, AE title/host/port, and peer responsiveness
error-assoc-transport = transport interruption while waiting for DIMSE response; hint: peer closed the connection or a network middlebox reset it
error-assoc-unreachable = could not reach { $name } [{ $ae }] at { $host }:{ $port } within { $seconds }s: { $err }. Check host/IP, port, and network reachability
error-cancel-sigint = Cancellation requested (SIGINT). Waiting for graceful shutdown...
error-config-must-be-positive = invalid config: { $name } must be > 0 (or null to disable)
error-config-duplicate-bind-port = invalid config: duplicate local AE bind port { $port }
error-config-local-ae-max-assoc = invalid config: local AE { $title } max_concurrent_associations must be > 0
error-config-local-ae-no-services = invalid config: local AE { $title } must enable at least one service
error-config-must-be-positive-required = invalid config: { $name } must be > 0
error-dicom-meta-incomplete = DICOM file meta is incomplete
error-dicom-patient-move-unsupported = patient-level C-MOVE is not supported by this client scaffold
error-dicom-required-attribute = required DICOM attribute missing: ({ $group },{ $element })
error-dicom-series-uid-required-image = series_instance_uid is required for image-level retrieve
error-dicom-series-uid-required-series = series_instance_uid is required for series-level retrieve
error-dicom-sop-uid-required-image = sop_instance_uid is required for image-level retrieve
error-dicom-study-uid-required = study_instance_uid is required
error-dicom-validating-move = validating move request
error-export-creating-file = creating export file { $path }: { $err }
error-export-flushing-series-csv = flushing series CSV: { $err }
error-export-flushing-studies-csv = flushing studies CSV: { $err }
error-export-serializing-series-json = serializing series JSON: { $err }
error-export-serializing-studies-json = serializing studies JSON: { $err }
error-export-writing-series-csv-header = writing series CSV header: { $err }
error-export-writing-series-csv-row = writing series CSV row: { $err }
error-export-writing-studies-csv-header = writing studies CSV header: { $err }
error-export-writing-studies-csv-row = writing studies CSV row: { $err }
error-import-cleanup-failed = { $source }: cleanup failed: { $reason }
error-import-corrupt-zip = Corrupt ZIP: { $details }
error-import-dicom-parse-failed = DICOM parse failed: { $err }
error-import-dicom-validation-failed = DICOM validation failed: { $err }
error-import-duplicate-zip-path = Duplicate ZIP path: { $details }
error-import-file-too-large = file too large: { $details }
error-import-invalid-dicom = Invalid DICOM: { $details }
error-import-limit-exceeded = { $limit } exceeded: { $details }
error-import-not-regular-file = not a regular file
error-import-opening-file = opening file: { $err }
error-import-opening-kind = opening { $kind } { $path }
error-import-opening-staged-file = opening staged file: { $err }
error-import-opening-zip-archive = opening ZIP archive { $path }
error-import-opening-zip-entry = opening ZIP entry: { $err }
error-import-opening-zip-file = opening ZIP import file { $path }
error-import-path-does-not-exist = Import path does not exist: { $path }
error-import-reading-directory = reading import directory { $path }
error-import-reading-file = reading file: { $err }
error-import-reading-file-metadata = reading file metadata for { $path }
error-import-reading-metadata = reading metadata for { $kind } { $path }
error-import-reading-zip-entry = reading ZIP entry: { $err }
error-import-removing-staged-after-cancel = removing staged file after cancellation { $path }
error-import-skipped = Skipped: { $details }
error-import-unreadable = Unreadable file: { $details }
error-import-unsafe-zip-path = Unsafe ZIP path: { $details }
error-import-zip-entry-count-exceeded = ZIP entry count limit exceeded: archive has { $count } entries, limit is { $limit }
error-import-zip-entry-size-exceeded = ZIP entry size { $size } exceeds limit { $limit }
error-import-zip-total-bytes-exceeded = ZIP total extracted bytes limit exceeded: current total { $current } plus entry size { $entry } exceeds limit { $limit }
error-net-binding-storage-scp = binding storage SCP at { $addr } for AE { $ae }. Another local DICOM receiver may already be using that port. Update storage_scp_port/local_aes in { $config } or stop the conflicting listener
error-net-building-file-meta = building file meta table
error-net-cannot-send-transfer-syntax = cannot send source transfer syntax { $source } with negotiated transfer syntax { $negotiated }
error-net-cget-dataset-empty = encoded C-GET C-STORE dataset is empty
error-net-cget-dataset-odd-length = encoded C-GET C-STORE dataset ended with an odd-length trailing fragment
error-net-cget-peer-released = peer released association during C-GET
error-net-cget-store-unexpected-dataset = unexpected dataset fragment in C-GET C-STORE response
error-net-cget-unexpected-command = unexpected command 0x{ $command } while waiting for C-STORE-RSP
error-net-cget-unexpected-pdu = unexpected PDU during C-GET C-STORE suboperation: { $pdu }
error-net-creating-incoming-dir = creating storage SCP .incoming dir
error-net-creating-path = creating { $path }
error-net-dataset-empty = encoded dataset is empty but COMMAND_DATA_SET_TYPE indicates a dataset is required
error-net-dataset-odd-length = encoded dataset ended with an odd-length trailing fragment
error-net-dimse-failed = { $operation } failed with status 0x{ $status } ({ $meaning }){ $hint }
error-net-establishing-assoc = establishing storage SCP association
error-net-file-meta-length = reading File Meta Information length
error-net-file-meta-tag = reading File Meta Information tag
error-net-file-meta-value = skipping File Meta Information value
error-net-file-meta-vr = reading File Meta Information VR
error-net-file-position = reading file position
error-net-flushing-path = flushing { $path }
error-net-flushing-temp-dataset = flushing temp dataset file
error-net-hint-suffix = ; hint: { $hint }
error-net-incomplete-command = incomplete { $operation } command response
error-net-incomplete-identifier = incomplete { $operation } response identifier
error-net-invalid-affected-sop = invalid { $operation } affected SOP class UID
error-net-invalid-status = invalid { $operation } status
error-net-listener-address = reading storage SCP listener address
error-net-listener-nonblocking = setting listener nonblocking mode
error-net-listener-port = reading storage SCP listener port
error-net-local-aes-empty = local_aes must contain at least one AE to start storage SCP
error-net-locating-dataset = locating dataset in { $path }
error-net-malformed-dimse = malformed { $operation } DIMSE response: { $details }; hint: peer sent an invalid or unexpected DIMSE command set
error-net-missing-affected-sop = missing { $operation } affected SOP class UID
error-net-missing-command-field = missing command field
error-net-missing-cstore-rsp-command-field = missing C-STORE response command field
error-net-missing-cstore-rsp-status = missing C-STORE response status
error-net-missing-destination = missing C-MOVE destination
error-net-missing-dicm = missing Part 10 DICM marker
error-net-missing-message-id = missing { $operation } message id
error-net-missing-qr-level = { $operation } identifier is missing QueryRetrieveLevel
error-net-missing-required-command-field = missing required command field { $name } ({ $tag })
error-net-missing-status = missing { $operation } status
error-net-move-destination-unresolved = move_destination was not resolved
error-net-no-cget-store-context = no negotiated C-GET storage presentation context for SOP Class { $sop } and transfer syntax { $syntax }
error-net-no-compatible-context = { $path }: no compatible negotiated presentation context for source transfer syntax { $syntax }
error-net-no-dimse-provider = no DIMSE provider registered for command 0x{ $command } and abstract syntax { $syntax }
error-net-no-presentation-context = no negotiated presentation context
error-net-no-presentation-context-for-file = { $path }: no negotiated presentation context
error-net-no-presentation-context-id = missing negotiated presentation context { $id }
error-net-opening-path = opening { $path }
error-net-part10-preamble = reading Part 10 preamble
error-net-path-error = { $path }: { $err }
error-net-pdata-feed-complete = cannot feed P-DATA fragment into a complete accumulator (missing take())
error-net-peer-aborted = peer aborted association during C-GET C-STORE suboperation: { $source }
error-net-peer-socket = reading storage SCP peer socket address
error-net-reading-command-dataset = reading command dataset
error-net-reading-identifier = reading { $operation } identifier
error-net-reading-incoming-dataset = reading incoming C-STORE dataset
error-net-reading-response-dataset = reading { $operation } response dataset
error-net-remote-aborted = remote aborted association: { $source }
error-net-restoring-read-timeout = restoring association read timeout
error-net-restoring-write-timeout = restoring association write timeout
error-net-rewinding-dataset = rewinding to first dataset element
error-net-scp-thread-panicked = storage SCP thread panicked
error-net-seeking-temp-dataset = seeking temp dataset file
error-net-serializing-cget-dataset = serializing C-GET suboperation dataset for { $path }
error-net-serializing-dataset = serializing dataset for { $path } with transfer syntax { $syntax }
error-net-setting-socket-blocking = setting accepted storage socket to blocking mode
error-net-sending-buffered-dataset = sending buffered dataset for { $path }
error-net-store-status = remote returned C-STORE status 0x{ $status } ({ $meaning }){ $hint }
error-net-streaming-dataset = streaming C-STORE dataset
error-net-unexpected-command-field = unexpected CommandField 0x{ $actual } (expected 0x{ $expected } for { $rsp })
error-net-unexpected-dataset-fragment = unexpected dataset fragment in C-STORE response
error-net-unexpected-pdu = unexpected PDU during { $operation }: { $pdu }
error-net-unknown-status = unknown or invalid { $operation } status 0x{ $status }
error-net-unsupported-model-sop = unsupported { $operation } model SOP class UID: { $uid }
error-net-unsupported-qr-level = unsupported QueryRetrieveLevel: { $level }
error-net-unsupported-transfer-syntax = unsupported negotiated transfer syntax
error-net-writing-command-dataset = writing command dataset
error-net-writing-identifier = writing { $operation } identifier
error-net-writing-path = writing { $path }
error-net-writing-response-dataset = writing { $operation } response dataset
error-net-writing-temp-dataset = writing dataset bytes to temp file
error-node-host-empty = node host cannot be empty
error-node-name-empty = node name cannot be empty
error-node-not-found = remote node not found: { $id }
error-operation-cancelled = operation cancelled
error-port-invalid = invalid port: { $value }
error-port-range = port must be between 1 and 65535
error-query-no-study-uid = Match has no StudyInstanceUID; cannot retrieve.
error-query-unsupported-level = unsupported query level: { $value }
error-query-unsupported-model = unsupported query model: { $value }
error-retrieve-canceled = retrieve was canceled by the remote node (status=0x{ $status }, completed={ $completed }, failed={ $failed }, warning={ $warning }, remaining={ $remaining }, { $scp })
error-retrieve-failed = retrieve failed with status=0x{ $status } (completed={ $completed }, failed={ $failed }, warning={ $warning }, remaining={ $remaining }, { $scp })
error-retrieve-nothing-arrived = retrieve finished for destination { $destination } with completed={ $completed } but nothing arrived at the local storage SCP ({ $scp }). Check for AE mapping or port misconfiguration: ensure { $listener } is free and that the remote node maps AE { $destination } to this app
error-send-no-files-series = no local files indexed for series { $uid }
error-send-no-files-study = no local files indexed for study { $uid }
error-task-cancelled = Task cancelled
error-task-none-to-cancel = No active task to cancel (nothing is running)
error-tracing-init = initializing tracing subscriber: { $err }
error-uid-component-numeric = UID component '{ $part }' must be numeric
error-uid-component-too-long = UID component '{ $part }' is too long
error-uid-dot-ends = UID cannot start or end with a dot
error-uid-empty = UID cannot be empty
error-uid-empty-component = UID cannot contain empty components
error-uid-leading-zeros = UID component '{ $part }' cannot have leading zeros
error-uid-too-long = UID must be at most 64 characters

## TUI
tui-bool-no = no
tui-bool-off = off
tui-bool-on = on
tui-bool-yes = yes
tui-command-placeholder = Type a command or use pane shortcuts.
tui-config-ae-title = AE title: { $value }
tui-config-edit-hint = Press Tab to focus this pane, then press 'c' to edit.
tui-config-hint = Press Tab to focus this pane, then press 'c' to edit.
tui-config-listener = Listener: { $value }
tui-config-max-pdu = max_pdu_length: { $value }
tui-config-promiscuous = allow_promiscuous_storage: { $value }
tui-config-strict-pdu = strict_pdu: { $value }
tui-config-ts-pref = TS preference: { $value }
tui-controls-hint = Tab fields · Enter confirms · Esc cancels
tui-detail-ae-title = AE Title
tui-detail-instance = Instance Detail
tui-detail-name = Name
tui-detail-node = Node Detail
tui-detail-placeholder-followup = Move focus to a list pane and change the selection to update this view.
tui-detail-query = Query Result Detail
tui-detail-select-node = Select a remote node to inspect its metadata.
tui-detail-series = Series Detail
tui-detail-study = Study Detail
tui-empty-command-placeholder = Type a command or use pane shortcuts.
tui-empty-detail-instance = Select an instance to inspect it, or return to series with Esc.
tui-empty-detail-node = Select a remote node to inspect its metadata.
tui-empty-detail-query = Select a query result to inspect metadata and retrieve context.
tui-empty-detail-series = Select a series to inspect it, or return to studies with Esc.
tui-empty-detail-study = Select a local study to inspect patient and series metadata.
tui-empty-instances = No indexed instances are available for this series.
tui-empty-instances-hint = Press Esc to return to series.
tui-empty-local-instances = No indexed instances are available for this series.
tui-empty-local-instances-hint = Press Esc to return to series.
tui-empty-local-series = No indexed series are available for this study.
tui-empty-local-series-hint = Press Esc to return to local studies.
tui-empty-local-studies = No indexed studies are available yet.
tui-empty-local-studies-cmd = Example: import path=/data/inbox
tui-empty-local-studies-hint = Import local DICOM files first.
tui-empty-no-name = <no name>
tui-empty-query = No query has been run yet.
tui-empty-query-body =
    Select a remote node and press 'f' to query.
    Or: query node=pacs patient_name="DOE^JOHN"
    Press 'm' on a selected result to open retrieve.
tui-empty-query-cmd = Or: query node=pacs
tui-empty-query-hint = Select a remote node and press 'f' to query.
tui-empty-query-last-target = Last query target: { $name }
tui-empty-query-none = No query has been run yet.
tui-empty-query-retrieve-hint = Press 'm' on a selected result to open retrieve.
tui-empty-remote-nodes = No remote nodes are saved yet.
tui-empty-remote-nodes-cmd = Or: node add name=pacs
tui-empty-remote-nodes-hint = Press 'a' in this pane to add one.
tui-empty-series = No indexed series are available for this study.
tui-empty-series-hint = Press Esc to return to local studies.
tui-empty-studies = No indexed studies are available yet.
tui-empty-studies-hint = Import local DICOM files first.
tui-empty-tasks-history = No task history.
tui-empty-tasks-queued = No queued tasks.
tui-fallback-no-name = <no name>
tui-field-accession = Accession number
tui-field-ae-title = AE title
tui-field-bind-addr = Bind addr
tui-field-date-from = Date from
tui-field-date-to = Date to
tui-field-destination-node = Destination node
tui-field-host = Host
tui-field-instance-uid = Instance UID
tui-field-kind = Kind
tui-field-level = Level
tui-field-local-ae = Local AE
tui-field-max-pdu = Max PDU
tui-field-modality = Modality
tui-field-model = Model
tui-field-move-destination = Move destination
tui-field-name = Name
tui-field-notes = Notes
tui-field-path = Path
tui-field-patient-id = Patient ID
tui-field-patient-name = Patient name
tui-field-port = Port
tui-field-promiscuous = Promiscuous
tui-field-series-uid = Series UID
tui-field-sop-uid = SOP Instance UID
tui-field-strict-pdu = Strict PDU
tui-field-study-description = Study description
tui-field-study-uid = Study UID
tui-footer-back-series = Esc back to series
tui-footer-back-studies = Esc back to studies
tui-footer-cancel-task = c cancel
tui-footer-edit-config = c edit config
tui-footer-enter-series = Enter series
tui-footer-esc-series = Esc back to series
tui-footer-esc-studies = Esc back to studies
tui-footer-help = F1/? help
tui-footer-inspect = Enter inspect
tui-footer-next = Next: { $text }
tui-footer-nodes = a/e/d/f nodes
tui-footer-panes = Tab panes
tui-footer-queued =
    { $n ->
        [one] { $n } queued
       *[other] { $n } queued
    }
tui-footer-quit = q quit
tui-footer-refresh = r refresh
tui-footer-retrieve = m retrieve
tui-footer-run-command = Enter run command
tui-footer-task-scope = t queued/history
tui-form-add-node = Add Remote Node
tui-form-add-remote-node = Add Remote Node
tui-form-delete-confirm = Delete remote node { $name } [{ $ae }] at { $host }:{ $port }?
tui-form-delete-node = Delete Remote Node
tui-form-delete-remote-node = Delete Remote Node
tui-form-edit-node = Edit Remote Node
tui-form-edit-remote-node = Edit Remote Node
tui-form-err-ae-required = ! AE title is required
tui-form-err-bind-required = ! bind address is required
tui-form-err-host-required = ! host is required
tui-form-err-local-ae-invalid = ! invalid local AE title: { $err }
tui-form-err-local-ae-required = ! local AE title is required
tui-form-err-modality-empty = modality cannot be empty
tui-form-err-move-dest-invalid = ! invalid Move destination AE title: { $err }
tui-form-err-name-required = ! node name is required
tui-form-err-port-required = ! port is required
tui-form-err-uid-empty = UID cannot be empty
tui-form-err-uid-empty-component = UID cannot contain empty components
tui-form-error-line = Error: { $error }
tui-form-field-accession = Accession number
tui-form-field-ae-title = AE title
tui-form-field-bind-addr = Bind address
tui-form-field-date-from = Date from
tui-form-field-date-to = Date to
tui-form-field-dest-node = Destination node
tui-form-field-destination = Destination AE
tui-form-field-host = Host
tui-form-field-instance-uid = SOP Instance UID
tui-form-field-kind = Kind
tui-form-field-level = Level
tui-form-field-local-ae = Local AE
tui-form-field-modality = Modality
tui-form-field-model = Model
tui-form-field-move-dest = Move destination
tui-form-field-name = Name
tui-form-field-notes = Notes
tui-form-field-path = Path
tui-form-field-patient-id = Patient ID
tui-form-field-patient-name = Patient name
tui-form-field-port = Port
tui-form-field-series-uid = Series Instance UID
tui-form-field-sop-uid = SOP Instance UID
tui-form-field-study-desc = Study description
tui-form-field-study-uid = Study Instance UID
tui-form-field-uid = UID
tui-form-hint-bind = hint: usually 0.0.0.0 (all interfaces) or 127.0.0.1
tui-form-hint-local-ae = hint: up to 16 characters (A-Z, 0-9, space), e.g. ARCHIVE_AE
tui-form-hint-move-dest = hint: optional; overrides the C-MOVE destination AE title
tui-form-hint-name = hint: a short label (e.g. PACS)
tui-form-import = Import Local Files
tui-form-import-local = Import Local Files
tui-form-import-local-files = Import Local Files
tui-form-mode-add = create a new remote node
tui-form-mode-edit = update the selected remote node
tui-form-query-node = Query Remote Node
tui-form-query-remote-node = Query Remote Node
tui-form-remote-node-line = Remote node: { $name } [{ $ae }] { $host }:{ $port }
tui-form-retrieve = Retrieve Matches
tui-form-retrieve-matches = Retrieve Matches
tui-form-send-series = Send Series
tui-form-send-study = Send Study
tui-form-storage-intro = Edit local Storage SCP settings (saved to config.json).
tui-form-storage-scp = Storage SCP Settings
tui-form-storage-scp-settings = Storage SCP Settings
tui-help-ae-title = AE title: { $value }
tui-help-aedf = a/e/d/f     Add, edit, delete, or query from the selected node
tui-help-c = c           Edit Storage SCP settings (when focus is on Config pane)
tui-help-canonical-names = Canonical names match CLI flags without '--', using underscores.
tui-help-close = Close help with Esc, F1, or ?.
tui-help-common-commands = Common commands
tui-help-config = c           Edit Storage SCP settings (when focus is on Config pane)
tui-help-config-path = Config path: { $value }
tui-help-current-config = Current configuration
tui-help-data-dir = Data dir: { $value }
tui-help-enter-default = Enter       Run the command input, submit the active modal, or open series from Local Studies
tui-help-enter-instance = Enter       No Local-pane action in instance view
tui-help-enter-local-instance = Enter       No Local-pane action in instance view
tui-help-enter-local-series = Enter       Open instances for the selected local series, or run the command input / submit the active modal
tui-help-enter-local-study = Enter       Open series for the selected local study, or run the command input / submit the active modal
tui-help-enter-series = Enter       Open instances for the selected local series, or run the command input / submit the active modal
tui-help-enter-study = Enter       Open series for the selected local study, or run the command input / submit the active modal
tui-help-esc-default = Esc         Close help/modal, return from Local series, or return focus to command input
tui-help-esc-instance = Esc         Return from Local instances to series, close help/modal, or return focus to command input
tui-help-esc-instances = Esc         Return from Local instances to series, close help/modal, or return focus to command input
tui-help-esc-series = Esc         Return from Local series to studies, close help/modal, or return focus to command input
tui-help-f1 = F1 or ?     Open help
tui-help-import-send = i/s         Import local files or send selected study/series
tui-help-is = i/s         Import local files or send selected study/series
tui-help-listener = Listener: { $value }
tui-help-log-dir = Log dir: { $value }
tui-help-m = m           Retrieve from the selected query result
tui-help-max-pdu = max_pdu_length: { $value }
tui-help-move = Up/Down or j/k   Move selection in list panes
tui-help-nodes = a/e/d/f     Add, edit, delete, or query from the selected node
tui-help-open = F1 or ?     Open help
tui-help-promiscuous = allow_promiscuous_storage: { $value }
tui-help-q = q           Quit when no modal is active and focus is not in command input
tui-help-quit = q           Quit when no modal is active and focus is not in command input
tui-help-r = r           Refresh panes when focus is not in command input
tui-help-receiver-mode = Receiver mode: { $value }
tui-receiver-mode-on-demand = on-demand for local retrieve
tui-receiver-mode-standalone = standalone via storage-scp
tui-help-refresh = r           Refresh panes when focus is not in command input
tui-help-retrieve = m           Retrieve from the selected query result
tui-help-strict-pdu = strict_pdu: { $value }
tui-help-tab = Tab / Shift-Tab  Change focused pane
tui-help-title = Keybindings
tui-help-ts-pref = preferred_store_transfer_syntax: { $value }
tui-help-updown = Up/Down or j/k   Move selection in list panes
tui-input-placeholder = Type a command or use pane shortcuts.
tui-log-command = > { $command }
tui-log-error = error: { $error }
tui-log-refreshed = refreshed
tui-logs-capped-suffix = capped
tui-logs-label = Logs:
tui-pane-command = Command
tui-pane-config = Config
tui-pane-detail = Detail
tui-pane-detail-hint = { $title } (PgUp/PgDn when not typing)
tui-pane-help = Help
tui-pane-instance-detail = Instance Detail
tui-pane-instances-for = Instances for: { $uid }
tui-pane-local-studies = Local Studies
tui-pane-logs = Logs ({ $shown }/{ $total }{ $capped })
tui-pane-logs-capped = Logs ({ $shown }/{ $total } capped)
tui-pane-logs-uncapped = Logs ({ $shown }/{ $total })
tui-pane-node-detail = Node Detail
tui-pane-query-detail = Query Result Detail
tui-pane-query-node = Query node
tui-pane-query-result-detail = Query Result Detail
tui-pane-query-results = Query / Retrieve Results
tui-pane-query-retrieve-results = Query / Retrieve Results
tui-pane-remote-nodes = Remote Nodes
tui-pane-series-detail = Series Detail
tui-pane-series-for = Series for: { $uid }
tui-pane-series-unknown = Series for: <unknown study>
tui-pane-study-detail = Study Detail
tui-pane-task-details = Task Detail
tui-pane-tasks-history = Tasks (history)
tui-pane-tasks-queued = Tasks (queued)
tui-pane-unknown-series = <unknown series>
tui-pane-unknown-study = Series for: <unknown study>
tui-row-inst = inst
tui-status-cancel-requested = Cancellation requested
tui-status-config = Config
tui-status-configured-listener = Configured listener { $addr } as AE { $ae } ({ $mode })
tui-status-data = Data
tui-status-failure = failure: { $failure }
tui-status-listener = Listener
tui-status-local-ae = Local AE
tui-status-mode = Mode
tui-status-mode-on-demand = on-demand
tui-status-mode-standalone = standalone
tui-status-no-active-task = No active task to cancel (nothing running)
tui-status-pdu = PDU
tui-status-promiscuous = Promiscuous
tui-status-query-before-retrieve = Query a remote node first so retrieve knows which node to use
tui-status-query-failed = query failed: { $error }
tui-status-queued-op = Queued operation: { $op }
tui-status-retrieve-failed = retrieve failed: { $error }
tui-status-retrieve-open-failed = could not open retrieve stream: { $error }
tui-status-saved-node = saved node { $name } ({ $id })
tui-status-saved-scp = Storage SCP settings saved (restart required)
tui-status-select-node = select a remote node first
tui-status-select-query = select a query result first
tui-status-select-study = select a local study first
tui-status-strict = Strict
tui-status-task-cancelled = Task cancelled
tui-status-task-cancelled-detail = Task cancelled: { $other }
tui-status-ts-pref = TS Pref
tui-status-updated-node = updated node { $name } ({ $id })
tui-suggest-back-series = Esc — back to series
tui-suggest-edit-config = c — edit config
tui-suggest-help = F1/? — help
tui-suggest-inspect-task = Enter — inspect task
tui-suggest-node-add = node add <ae-title> <host:port>
tui-suggest-query = f — query a node
tui-suggest-query-node = f — query selected node
tui-suggest-retrieve = m — retrieve selected
tui-suggest-run-command = Enter — run command
tui-suggest-send-series = s — send selected series
tui-suggest-view-series = Enter — view series
tui-task-cancelled = Cancelled
tui-task-cancelling = Cancelling
tui-task-failed = Failed
tui-task-failed-generic = Task failed: { $error }
tui-task-import-done = Import complete: { $report }
tui-task-import-failed = Import failed: { $error }
tui-task-importing = Importing { $path }...
tui-task-query-done =
    Query complete: { $count ->
        [one] { $count } match
       *[other] { $count } matches
    }
tui-task-query-failed = Query failed: { $error }
tui-task-querying = Querying { $node }...
tui-task-queued = Queued
tui-task-retrieve-done = Retrieve complete: { $outcome }
tui-task-retrieve-failed = Retrieve failed: { $error }
tui-task-retrieving = Retrieving from { $node }...
tui-task-running = Running
tui-task-sending-series = Sending series { $uid } to { $node }...
tui-task-sending-study = Sending study { $uid } to { $node }...
tui-task-send-done = Send complete: { $outcome }
tui-task-status-cancelled = cancelled
tui-task-status-cancelling = cancelling
tui-task-status-failed = failed
tui-task-status-ok = ok
tui-task-status-queued = queued
tui-task-status-running = running
tui-task-succeeded = Succeeded
tui-terminal-too-small = Terminal too small - please resize

## Desktop
desktop-action-activity = Activity
desktop-action-activity-empty = Activity
desktop-action-import = Import
desktop-action-inspect-archive = Action inspect archive
desktop-action-inspect-archive-desc = Action inspect archive desc
desktop-action-manage-peers = Action manage peers
desktop-action-manage-peers-desc = Action manage peers desc
desktop-action-monitor-scp = Action monitor SCP
desktop-action-query = Query
desktop-action-refresh = Refresh status
desktop-action-refresh-status = Refresh status
desktop-action-reveal-log = Reveal log file
desktop-action-send = Send
desktop-action-start-scp = Action start SCP
desktop-activity-empty = No session activity yet.
desktop-activity-title = Activity
desktop-app-title = DICOM Node
desktop-archive-csv = CSV
desktop-archive-details = Details
desktop-archive-empty = The local archive is empty.
desktop-archive-export-fail = Export { $scope } failed
desktop-archive-export-ok =
    { $rows ->
    [one] Exported { $rows } { $scope } row to { $path }.
    *[other] Exported { $rows } { $scope } rows to { $path }.
    }
desktop-archive-export-studies = Export studies
desktop-archive-export-title = Export { $scope }
desktop-archive-filter = Filter by patient, UID, description, modality…
desktop-archive-filter-placeholder = Filter by patient, UID, description, modality…
desktop-archive-inst-abbrev =
    { $count ->
        [one] { $count } inst.
       *[other] { $count } inst.
    }
desktop-archive-instance-meta = { $bytes } · TS { $ts } · imported { $imported }
desktop-archive-instances = Instances
desktop-archive-instances-heading = Instances
desktop-archive-json = JSON
desktop-archive-loading = Loading studies…
desktop-archive-no-filter-match = No studies match the filter.
desktop-archive-no-instances = No instances found.
desktop-archive-no-match = No studies match the filter.
desktop-archive-no-nodes = No nodes
desktop-archive-no-series = No series found.
desktop-archive-reveal-file = Reveal file
desktop-archive-select-series = Select a series.
desktop-archive-select-study = Select a study.
desktop-archive-send-fail = { $label }: { $sent }/{ $attempted } sent, { $failed } failed. { $failures }
desktop-archive-send-fail-title = { $label } failed
desktop-archive-send-ok = { $label }: sent { $sent }/{ $attempted } instances.
desktop-archive-send-series = Send series
desktop-archive-send-series-label = Series → { $destination }
desktop-archive-send-study = Send study
desktop-archive-send-study-label = Study → { $destination }
desktop-archive-send-to = Send to
desktop-archive-series = Series
desktop-archive-series-count =
    #{ $number } · { $count ->
        [one] { $count } instance
       *[other] { $count } instances
    }
desktop-archive-series-fallback = Series
desktop-archive-studies = Studies
desktop-archive-study-date = Study date
desktop-archive-study-uid = Study UID
desktop-archive-subtitle = Study, series, and instance inventory from the local SQLite archive.
desktop-archive-title = Local Archive
desktop-brand-title = DICOM Node
desktop-col-description = Description
desktop-col-instances = Instances
desktop-col-modalities = Modalities
desktop-col-patient-id = Patient ID
desktop-common-cancel = Cancel
desktop-common-clear = Clear
desktop-common-disabled = disabled
desktop-common-enabled = enabled
desktop-common-loading = Loading…
desktop-common-no = no
desktop-common-refresh = Refresh
desktop-common-yes = yes
desktop-counter-assoc-accepted = Associations accepted
desktop-counter-bytes-ingested = Bytes ingested
desktop-counter-cfind-requests = C-FIND requests
desktop-counter-cmove-requests = C-MOVE requests
desktop-counter-cstore-failed = C-STORE failed
desktop-counter-cstore-stored = C-STORE stored
desktop-dashboard-counter-assoc-accepted = Associations accepted
desktop-dashboard-counter-bytes-ingested = Bytes ingested
desktop-dashboard-counter-c-find-requests = C-FIND requests
desktop-dashboard-counter-c-move-requests = C-MOVE requests
desktop-dashboard-counter-c-store-failed = C-STORE failed
desktop-dashboard-counter-c-store-stored = C-STORE stored
desktop-dashboard-empty-studies = No local studies yet.
desktop-dashboard-inspect-archive-body = Review studies, drill into series and instances, then send or export.
desktop-dashboard-inspect-archive-title = Inspect Local Archive
desktop-dashboard-kv-ae-title = AE title
desktop-dashboard-kv-data-dir = Data dir
desktop-dashboard-kv-listener = Listener
desktop-dashboard-kv-log-file = Log file
desktop-dashboard-kv-max-pdu = Max PDU
desktop-dashboard-kv-promiscuous = Promiscuous storage
desktop-dashboard-kv-server = Server
desktop-dashboard-kv-store-syntax = Store syntax
desktop-dashboard-kv-strict-pdu = Strict PDU
desktop-dashboard-listener-missing = Listener not loaded yet.
desktop-dashboard-live-counters = Live counters
desktop-dashboard-loading-metrics = Loading metrics…
desktop-dashboard-loading-status = Loading local status…
desktop-dashboard-loading-studies = Loading studies…
desktop-dashboard-local-node = Local node
desktop-dashboard-manage-peers-body = Add and edit PACS or workstation nodes used by query, retrieve, and store.
desktop-dashboard-manage-peers-title = Manage Peers
desktop-dashboard-metric-instances = Instances
desktop-dashboard-metric-nodes = Remote nodes
desktop-dashboard-metric-series = Series
desktop-dashboard-metric-studies = Studies
desktop-dashboard-monitor-scp = Monitor Storage SCP
desktop-dashboard-recent-studies = Recent studies
desktop-dashboard-start-scp = Start Storage SCP
desktop-dashboard-subtitle = Local archive, network peers, and SCP activity at a glance.
desktop-dashboard-title = Operator Dashboard
desktop-doc-title = DICOM Node
desktop-import-accepted = Accepted
desktop-import-accepted-bytes = Accepted bytes
desktop-import-activity-detail = { $accepted }/{ $scanned } accepted, { $duplicates } duplicates, { $bytes }
desktop-import-activity-fail = Import failed
desktop-import-activity-ok = Import complete
desktop-import-choose-archive = Choose ZIP
desktop-import-choose-dir = Choose a directory to import
desktop-import-choose-folder = Choose folder
desktop-import-choose-zip = Choose a ZIP archive to import
desktop-import-cleanup = Cleanup
desktop-import-clear-path = Clear path
desktop-import-complete = Import complete
desktop-import-dup-sha = SHA-256
desktop-import-dup-sop = SOP UID
desktop-import-dup-total = Total
desktop-import-duplicates = Duplicates
desktop-import-failed = Import failed
desktop-import-failed-cleanup = Failed cleanup
desktop-import-failures = Failures
desktop-import-failures-heading =
    { $count ->
    [one] { $count } failure:
    *[other] { $count } failures:
    }
desktop-import-failures-more = … and { $count } more
desktop-import-files-progress = { $label } files
desktop-import-folder = Folder
desktop-import-invalid-dicom = Invalid DICOM
desktop-import-pick-dir = Choose a directory to import
desktop-import-pick-zip = Choose a ZIP archive to import
desktop-import-placeholder = /path/to/dicom-folder or /path/to/archive.zip
desktop-import-rejected = Rejected
desktop-import-report = Import report
desktop-import-running = Importing…
desktop-import-scanned = Scanned
desktop-import-skipped = Skipped
desktop-import-source = Source
desktop-import-start = Start import
desktop-import-stored = Stored
desktop-import-subtitle = Index DICOM files from recursive folders or ZIP archives into the managed local archive.
desktop-import-title = Import
desktop-import-unreadable = Unreadable
desktop-import-zip = ZIP
desktop-import-zip-filter = ZIP archives
desktop-lang-label = Language
desktop-listener-not-loaded = Listener not loaded
desktop-live-counters = Live counters
desktop-loading = Loading
desktop-loading-local-status = Loading local status
desktop-loading-metrics = Loading metrics…
desktop-loading-studies = Loading studies…
desktop-local-node = Local node
desktop-locale-label = Language
desktop-logs-activity-detail =
    { $count ->
    [one] { $count } line loaded
    *[other] { $count } lines loaded
    }
desktop-logs-activity-fail = Log refresh failed
desktop-logs-activity-ok = Log refreshed
desktop-logs-auto = AUTO
desktop-logs-auto-refresh = Auto refresh
desktop-logs-empty = The log file is empty.
desktop-logs-found = LOG FILE FOUND
desktop-logs-lines =
    { $count ->
        [one] { $count } line
       *[other] { $count } lines
    }
desktop-logs-loading = Loading log…
desktop-logs-missing = The active log file has not been created yet.
desktop-logs-refresh-failed = Log refresh failed
desktop-logs-refreshed = Log refreshed
desktop-logs-reveal = Reveal
desktop-logs-subtitle = Bounded tail of the active desktop log file.
desktop-logs-tail = Tail
desktop-logs-title = Logs
desktop-logs-truncated = TRUNCATED
desktop-logs-waiting = WAITING FOR LOG FILE
desktop-metric-instances = Instances
desktop-metric-remote-nodes = Remote nodes
desktop-metric-series = Series
desktop-metric-studies = Studies
desktop-nav-archive = Local Archive
desktop-nav-dashboard = Dashboard
desktop-nav-import = Import
desktop-nav-logs = Logs
desktop-nav-network = Network
desktop-nav-nodes = Remote Nodes
desktop-nav-query = Query / Retrieve
desktop-nav-server = Storage Server
desktop-no-local-studies = No local studies yet.
desktop-nodes-add = Add node
desktop-nodes-added = Added node "{ $name }".
desktop-nodes-ae-length = AE title must be 16 characters or fewer.
desktop-nodes-ae-title = AE title
desktop-nodes-col-move = Move dest.
desktop-nodes-configured = Configured nodes
desktop-nodes-confirm-delete = Delete node "{ $name }"?
desktop-nodes-default-port = Default port 104
desktop-nodes-delete = Delete node
desktop-nodes-delete-title = Delete node
desktop-nodes-deleted = Deleted node "{ $name }".
desktop-nodes-edit = Edit node
desktop-nodes-edit-title = Edit node
desktop-nodes-empty = No remote nodes yet.
desktop-nodes-err-ae = Desktop nodes AE
desktop-nodes-err-ae-len = Desktop nodes AE len
desktop-nodes-err-host = Desktop nodes host
desktop-nodes-err-name = Desktop nodes name
desktop-nodes-err-port = Desktop nodes port
desktop-nodes-host = Host
desktop-nodes-move-dest = Move destination
desktop-nodes-move-placeholder = Defaults to local AE
desktop-nodes-name = Name
desktop-nodes-need-ae = AE title is required.
desktop-nodes-need-host = Host is required.
desktop-nodes-need-name = Name is required.
desktop-nodes-notes = Notes
desktop-nodes-notes-placeholder = Reading room PACS
desktop-nodes-placeholder-ae = PACS01
desktop-nodes-placeholder-host = 192.168.0.10
desktop-nodes-placeholder-move = Defaults to local AE
desktop-nodes-placeholder-name = main-pacs
desktop-nodes-placeholder-notes = Reading room PACS
desktop-nodes-port = Port
desktop-nodes-port-104 = Default port 104
desktop-nodes-port-range = Port must be 1-65535.
desktop-nodes-save = Save changes
desktop-nodes-save-changes = Save changes
desktop-nodes-subtitle = PACS and workstation peers for query, retrieve, and store operations.
desktop-nodes-summary = Node summary
desktop-nodes-title = Remote Nodes
desktop-nodes-total = Total nodes
desktop-nodes-updated = Updated node "{ $name }".
desktop-nodes-with-move = With move destination
desktop-promiscuous = Promiscuous
desktop-query-accession = Accession #
desktop-query-activity-detail =
    { $count } { $count ->
    [one] match
    *[other] matches
    } at { $level } level
desktop-query-activity-fail = C-FIND { $node } failed
desktop-query-activity-ok = C-FIND { $node }
desktop-query-activity-title = C-FIND { $node }
desktop-query-clear = Cancel
desktop-query-col-accession = Accession
desktop-query-criteria = Search criteria
desktop-query-date-from = Study date from
desktop-query-date-to = Study date to
desktop-query-kv-series-uid = Series UID
desktop-query-kv-sop-uid = SOP UID
desktop-query-kv-study-uid = Study UID
desktop-query-level = Level
desktop-query-matches =
    { $count ->
    [one] { $count } match
    *[other] { $count } matches
    }
desktop-query-missing-study-uid = Match has no StudyInstanceUID; cannot retrieve.
desktop-query-modality = Modality
desktop-query-no-matches = No matches.
desktop-query-no-nodes = No nodes configured
desktop-query-patient-id = Patient ID
desktop-query-patient-name = Patient name
desktop-query-placeholder-description = CHEST*
desktop-query-placeholder-modality = CT, MR, …
desktop-query-placeholder-name = DOE^JOHN or DOE*
desktop-query-placeholder-patient = DOE^JOHN or DOE*
desktop-query-querying = Querying…
desktop-query-remote-node = Remote node
desktop-query-results = Results
desktop-query-retrieve = Retrieve
desktop-query-retrieve-activity-detail = completed={ $completed }, warning={ $warning }, failed={ $failed }
desktop-query-retrieve-activity-fail = C-MOVE { $node } failed
desktop-query-retrieve-activity-ok = C-MOVE { $node }
desktop-query-retrieve-finished = Retrieve finished: completed { $completed }, warnings { $warning }, failed { $failed }.
desktop-query-retrieve-selected = Retrieve selected
desktop-query-run = Run C-FIND
desktop-query-run-select = Run a query and select a match.
desktop-query-running = Querying…
desktop-query-search-criteria = Search criteria
desktop-query-select-hint = Run a query and select a match.
desktop-query-selected = Selected match
desktop-query-selected-match = Selected match
desktop-query-series-uid = Series Instance UID
desktop-query-sop-uid = SOP Instance UID
desktop-query-study-description = Study description
desktop-query-study-uid = Study Instance UID
desktop-query-subtitle = C-FIND a remote node, inspect matches, then C-MOVE into the local archive.
desktop-query-title = Query / Retrieve
desktop-recent-studies = Recent studies
desktop-scp-listening = SCP listening
desktop-scp-stopped = SCP stopped
desktop-server-activity-fail = Storage SCP control failed
desktop-server-activity-started = Storage SCP started
desktop-server-activity-started-detail = Listener started.
desktop-server-activity-stopped = Storage SCP stopped
desktop-server-activity-stopped-detail = received={ $received }, stored={ $stored }, failed={ $failed }
desktop-server-activity-stopped-empty = No active session.
desktop-server-addr-ae = { $addr } · AE { $ae }
desktop-server-assoc-accepted = Accepted associations
desktop-server-assoc-rejected = Rejected associations
desktop-server-cfind-req-matches = C-FIND requests / matches
desktop-server-cget-requests = C-GET requests
desktop-server-cmove-requests = C-MOVE requests
desktop-server-cmove-subops = C-MOVE sub-ops completed / failed
desktop-server-control-failed = Storage SCP control failed
desktop-server-counter-bytes = Bytes ingested
desktop-server-counter-failed = C-STORE failed
desktop-server-counter-find = C-FIND requests / matches
desktop-server-counter-get = C-GET requests
desktop-server-counter-move = C-MOVE requests
desktop-server-counter-move-sub = C-MOVE sub-ops completed / failed
desktop-server-counter-received = C-STORE received
desktop-server-counter-stored = C-STORE stored
desktop-server-cstore-failed = C-STORE failed
desktop-server-cstore-received = C-STORE received
desktop-server-cstore-stored = C-STORE stored
desktop-server-dimse = DIMSE counters
desktop-server-failed = Failed
desktop-server-health-loading = Loading metrics
desktop-server-health-ready = Ready for inbound C-STORE
desktop-server-health-review = Review failures
desktop-server-health-stopped = Stopped
desktop-server-listener-started = Listener started.
desktop-server-listening = LISTENING
desktop-server-loading-metrics = Loading metrics…
desktop-server-logs = Logs
desktop-server-no-session = No active session.
desktop-server-rate = +{ $rate } / poll
desktop-server-ready = Ready for inbound C-STORE
desktop-server-review-failures = Review failures
desktop-server-session-ended = Session ended: received { $received }, stored { $stored }, failed { $failed }.
desktop-server-start = Start server
desktop-server-started-title = Storage SCP started
desktop-server-stop = Stop server
desktop-server-stopped = STOPPED
desktop-server-stopped-pill = STOPPED
desktop-server-stopped-status = Stopped
desktop-server-stopped-title = Storage SCP stopped
desktop-server-stored = Stored
desktop-server-subtitle = Standalone storage SCP for inbound C-STORE and local archive indexing.
desktop-server-title = Storage Server
desktop-status-listening = listening
desktop-status-loading = Loading
desktop-status-scp-listening = SCP listening
desktop-status-scp-stopped = SCP stopped
desktop-status-stopped = stopped
desktop-store-syntax = Store syntax
desktop-strict-pdu = Strict PDU
desktop-strip-pdu = PDU { $value }
desktop-table-accession = Accession
desktop-table-ae-title = AE Title
desktop-table-date = Date
desktop-table-description = Description
desktop-table-endpoint = Endpoint
desktop-table-instances = Instances
desktop-table-modalities = Modalities
desktop-table-modality = Modality
desktop-table-move-dest = Move dest.
desktop-table-name = Name
desktop-table-notes = Notes
desktop-table-patient = Patient
desktop-table-patient-id = Patient ID
desktop-table-series = Series
desktop-table-updated = Updated
desktop-title-refresh-status = Refresh status
desktop-title-reveal-log = Reveal log file
ae = AE
patient-name =
    "DOE^JOHN"
    Press 'm' on a selected result to open retrieve.
port = Port

## Summary
summary-ae = AE
summary-counts = Counts
summary-criteria = Criteria
summary-duration = Duration
summary-duration-ms = { $ms }ms
summary-failures = Failures:
summary-kind = Kind
summary-logs = Logs:
summary-peer = Peer
summary-status = Status
summary-title = Operation summary
tui-detail-created = Created

tui-form-hint-port-range = hint: a number from 1 to 65535, e.g. 104
tui-form-hint-promiscuous = hint: allow storage from any calling AE title
tui-form-hint-strict-pdu = hint: enforce PDU size checks during associations
tui-form-hint-max-pdu-bytes = hint: bytes, e.g. 16384
tui-form-limits-heading = Limits (bytes; blank/none = unlimited):
tui-form-field-max-file-import = Max file import bytes
tui-form-field-max-zip-entry = Max zip entry bytes
tui-form-field-max-zip-total = Max zip total bytes
tui-form-field-max-zip-count = Max zip entry count
tui-form-field-max-store-object = Max store object bytes
tui-form-unlimited = unlimited
tui-form-err-max-pdu-required = ! max PDU length is required
tui-form-err-max-pdu-gt-zero = ! max PDU length must be an integer greater than 0
tui-form-err-limit-gt-zero = ! { $label } must be an integer greater than 0
tui-form-controls-scp = Type to edit. Space toggles checkboxes. Tab/Shift-Tab or Up/Down move fields. Enter saves. Esc cancels.
tui-form-submit-uid-required = UID is required
tui-form-submit-dest-required = destination node is required
tui-form-submit-nonneg-int = { $label } must be a non-negative integer
tui-form-submit-gt-zero = { $label } must be greater than 0
tui-form-submit-local-ae-required = local AE title is required
tui-form-submit-local-ae-invalid = local AE title is invalid: { $err }
tui-form-submit-bind-required = bind address is required
tui-form-submit-port-required = port is required
tui-form-submit-max-pdu-required = max PDU length is required
tui-form-submit-max-pdu-int = max PDU length must be an integer
tui-form-submit-max-pdu-gt-zero = max PDU length must be greater than 0
tui-form-submit-patient-retrieve = patient-level retrieve is not supported
tui-form-submit-no-study-uid = selected result does not include a study UID
tui-form-submit-date-format = expected YYYYMMDD
tui-form-submit-modality-len = modality must be at most 16 characters
tui-form-submit-modality-chars = modality must be A-Z or 0-9
tui-form-submit-name-required = node name is required
tui-form-submit-ae-required = AE title is required
tui-form-submit-host-required = host is required
tui-form-submit-move-dest-invalid = move destination AE title is invalid: { $err }
tui-form-submit-dates-both = both date from and date to must be set, or neither
tui-form-submit-date-from-invalid = date from is invalid: { $err }
tui-form-submit-date-to-invalid = date to is invalid: { $err }
tui-form-submit-date-order = date from must be on or before date to
tui-form-submit-study-uid-series-query = study UID is required for series-level queries
tui-form-submit-study-uid-image-query = study UID is required for image-level queries
tui-form-submit-series-uid-image-query = series UID is required for image-level queries
tui-form-submit-study-uid-required = study UID is required
tui-form-submit-study-uid-invalid = study UID is invalid: { $err }
tui-form-submit-series-uid-series-retrieve = series UID is required for series-level retrieve
tui-form-submit-series-uid-image-retrieve = series UID is required for image-level retrieve
tui-form-submit-instance-uid-image-retrieve = instance UID is required for image-level retrieve
tui-form-submit-series-uid-invalid = series UID is invalid: { $err }
tui-form-submit-instance-uid-invalid = instance UID is invalid: { $err }
tui-form-submit-import-path-required = import path is required
tui-form-submit-import-path-type = import path must be a file or directory: { $path }
tui-form-submit-import-access = accessing import path { $path }
tui-form-submit-import-open = opening import file { $path }
tui-form-submit-import-read-dir = reading import directory { $path }
tui-log-welcome = Press F1 or ? for help. Focus Remote nodes and press 'a' to add one.
tui-log-logging-to = Logging to { $path }
tui-command-help-heading = commands:
tui-command-help-next-1 = note: the footer shows contextual 'Next:' suggestions based on the focused pane and selection.
tui-command-help-next-2 = They are hints only; you can always type any command.
tui-command-help-canonical = note: canonical names match CLI flags without '--', using underscores.
tui-command-help-cancel = cancel (alias: stop)
tui-command-help-cmds =
    {"  node add name=<n> ae=<AE> (or ae_title=<AE>) host=<host> port=<port>"}{"\u000A"}
    {"           [dest=<AE> (or move_destination=<AE>)] [notes=..]"}{"\u000A"}
    {"  node edit target=<id|name> [name=..] [ae=<AE> (or ae_title=<AE>)]"}{"\u000A"}
    {"            [host=..] [port=..] [dest=<AE> (or move_destination=<AE>)] [notes=..]"}{"\u000A"}
    {"  node delete target=<id|name> (or id=<id> / name=<name>)"}{"\u000A"}
    {"  import path=<folder|file|zip>"}{"\u000A"}
    {"  query node=<name> [model=patient|study] [level=patient|study|series|image]"}{"\u000A"}
    {"        [patient_name=..] [patient_id=..] [accession=<n> (or accession_number=<n>)]"}{"\u000A"}
    {"        [study_uid=<uid> (or study_instance_uid=<uid>)]"}{"\u000A"}
    {"        [series_uid=<uid> (or series_instance_uid=<uid>)]"}{"\u000A"}
    {"        [instance_uid=<uid> (or sop_instance_uid=<uid>)]"}{"\u000A"}
    {"        [date_from=YYYYMMDD (or study_date_from=YYYYMMDD)]"}{"\u000A"}
    {"        [date_to=YYYYMMDD (or study_date_to=YYYYMMDD)] [modality=..] [study_description=..]"}{"\u000A"}
    {"  retrieve node=<name> study_uid=<uid> (or study_instance_uid=<uid>)"}{"\u000A"}
    {"           [series_uid=.. (or series_instance_uid=..)]"}{"\u000A"}
    {"           [instance_uid=.. (or sop_instance_uid=..)]"}{"\u000A"}
    {"           [dest=<AE> (or move_destination=<AE>)]"}{"\u000A"}
    {"  send-study node=<name> (or destination_node=<name>)"}{"\u000A"}
    {"             study_uid=<uid> (or study_instance_uid=<uid> or study=<uid>)"}{"\u000A"}
    {"  send-series node=<name> (or destination_node=<name>)"}{"\u000A"}
    {"              series_uid=<uid> (or series_instance_uid=<uid> or series=<uid>)"}{"\u000A"}
    {"  local studies [patient_name=..] [patient_id=..] [study_description=..]"}{"\u000A"}
    {"              [study_date=VALUE|START..END|START..|..END]"}{"\u000A"}
    {"              [modality=CT,MR,..] [imported_at=VALUE|START..END|START..|..END]"}{"\u000A"}
    {"              [duplicate=true|false]"}{"\u000A"}
    {"  local series study_uid=<uid> (or study_instance_uid=<uid> or study=<uid>)"}{"\u000A"}
    {"  local instances series_uid=<uid> (or series_instance_uid=<uid> or series=<uid>)"}
tui-command-help-refresh = refresh
tui-command-help-quit = quit
tui-inspect-task = Task #{ $id }
tui-inspect-status = Status: { $status }
tui-inspect-description = Description: { $description }
tui-inspect-progress = Progress: { $progress }
tui-inspect-summary = Summary:
tui-inspect-no-logs = (no logs)
tui-field-sop-class-uid = SOP Class UID
tui-field-transfer-syntax-uid = Transfer Syntax UID
tui-field-sha256 = SHA-256
tui-status-removed-nodes =
    removed { $count ->
        [one] { $count } node
       *[other] { $count } nodes
    }
tui-status-removed-nodes-target =
    removed { $count ->
        [one] { $count } node
       *[other] { $count } nodes
    }; last target was { $name }
tui-status-more-failures =
    and { $n ->
        [one] { $n } failure omitted
       *[other] { $n } failures omitted
    }
tui-status-retrieve-ok = retrieve status=0x{ $status } completed={ $completed } failed={ $failed } warning={ $warning } remaining={ $remaining }
tui-status-import-counts = scanned={ $scanned } accepted={ $accepted } duplicates={ $duplicates } unreadable={ $unreadable } invalid_dicom={ $invalid } rejected_total={ $rejected } stored_bytes={ $bytes }
tui-status-send-ok = send attempted={ $attempted } sent={ $sent } failed={ $failed }
tui-log-query-start = Starting query against { $node }
tui-log-retrieve-start = Starting retrieve from { $node }
tui-log-import-start = Starting import of { $path }
tui-log-send-study-start = Starting send study { $uid } to { $node }
tui-log-send-series-start = Starting send series { $uid } to { $node }
tui-log-cancelled-before-start = cancelled before start
tui-log-cancelled = cancelled
error-unknown-command = unknown command: { $command }
error-node-subcommand-required = node subcommand required
error-local-subcommand-required = local subcommand required
error-unsupported-node-subcommand = unsupported node subcommand: { $command }
error-unsupported-local-subcommand = unsupported local subcommand: { $command }
error-expected-kv = expected key=value argument, got { $arg }
error-missing-required-arg = missing required argument: { $key }
error-missing-required-arg-one-of = missing required argument: one of { $keys }
error-parsing-command = parsing command
error-edit-form-lost-target = edit form lost its target node
error-task-already-running = background task already running
error-task-thread-launch = failed to launch background task thread: { $error }
error-task-disconnected = background task thread disconnected before sending a result
error-task-kind-missing = background task thread disconnected but active_task_kind was None: unexpected state
error-serve-exited = serve exited with error: { $error }
cli-msg-node-list-row = { $name } [{ $id }]  { $ae }@{ $host }:{ $port }  move_dest={ $dest }
cli-msg-local-study-row = { $uid } | patient={ $patient } | date={ $date } | desc={ $desc } | modalities={ $modalities } | series={ $series } | instances={ $instances }
cli-import-unreadable = unreadable={ $n }
cli-import-invalid-dicom = invalid_dicom={ $n }
cli-import-rejected-total = rejected_total={ $n }
cli-import-skipped = skipped={ $n }
cli-import-failed-cleanup = failed_cleanup={ $n }
cli-import-total = total={ $n }
cli-import-stored-bytes = stored_bytes={ $n }
cli-import-dup-detail = duplicates={ $n } (by_sop_instance_uid={ $sop }, by_sha256={ $sha })
summary-title = Operation summary
summary-kind = Kind
summary-status = Status
summary-duration = Duration
summary-duration-ms = { $ms }ms
summary-peer = Peer
summary-ae = AE
summary-criteria = Criteria
summary-counts = Counts
summary-failures = Failures:
summary-logs = Logs:
summary-unserializable = <unserializable>
summary-log-lines = lines { $start }-{ $end }
