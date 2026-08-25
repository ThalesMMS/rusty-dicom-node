# Desktop chrome fallback (en-US). Same hyphenated IDs as i18n/en-US.ftl.
# Do not use dotted message IDs.

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
desktop-archive-instances-heading = Archive instances heading
desktop-archive-json = JSON
desktop-archive-loading = Loading studies…
desktop-archive-no-filter-match = No studies match the filter.
desktop-archive-no-instances = No instances found.
desktop-archive-no-match = Archive no match
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
desktop-counter-cfind-requests = Counter C-FIND requests
desktop-counter-cmove-requests = Counter C-MOVE requests
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
count-studies =
    { $n ->
        [one] { $n } study
       *[other] { $n } studies
    }
count-series =
    { $n ->
        [one] { $n } series
       *[other] { $n } series
    }
count-instances =
    { $n ->
        [one] { $n } instance
       *[other] { $n } instances
    }
count-nodes =
    { $n ->
        [one] { $n } node
       *[other] { $n } nodes
    }
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
desktop-import-choose-archive = Import choose archive
desktop-import-choose-dir = Choose a directory to import
desktop-import-choose-folder = Import choose folder
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
desktop-nodes-col-move = Nodes col move
desktop-nodes-configured = Configured nodes
desktop-nodes-confirm-delete = Delete node "{ $name }"?
desktop-nodes-default-port = Nodes default port
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
desktop-nodes-save-changes = Nodes save changes
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
desktop-query-activity-title = Query activity title { $node }
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
desktop-query-running = Query running
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
desktop-server-cget-requests = Server C-GET requests
desktop-server-cmove-requests = Server C-MOVE requests
desktop-server-cmove-subops = C-MOVE sub-ops completed / failed
desktop-server-control-failed = Server control failed
desktop-server-counter-bytes = Bytes ingested
desktop-server-counter-failed = C-STORE failed
desktop-server-counter-find = C-FIND requests / matches
desktop-server-counter-get = C-GET requests
desktop-server-counter-move = C-MOVE requests
desktop-server-counter-move-sub = C-MOVE sub-ops completed / failed
desktop-server-counter-received = C-STORE received
desktop-server-counter-stored = C-STORE stored
desktop-server-cstore-failed = Server C-STORE failed
desktop-server-cstore-received = C-STORE received
desktop-server-cstore-stored = Server C-STORE stored
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
desktop-server-ready = Server ready
desktop-server-review-failures = Server review failures
desktop-server-session-ended = Session ended: received { $received }, stored { $stored }, failed { $failed }.
desktop-server-start = Start server
desktop-server-started-title = Server started title
desktop-server-stop = Stop server
desktop-server-stopped = STOPPED
desktop-server-stopped-pill = STOPPED
desktop-server-stopped-status = Server stopped status
desktop-server-stopped-title = Server stopped title
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
