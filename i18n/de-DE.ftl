# Fluent catalog (de-DE). Message IDs are hyphenated identifiers
# (cli-about, tui-pane-remote-nodes, desktop-nav-dashboard, error-import-file-too-large).
# Dotted names are Fluent attributes (message + .attr), not message IDs.
# Do not translate DICOM tokens (C-FIND, C-MOVE, C-STORE, SOP, AE, UID) or JSON/CSV machine keys.


## CLI
cli-about = Terminal-orientierter DICOM-Knoten-Client auf Basis von dicom-rs
cli-arg-accession-number = Nach Accession-Nummer filtern (Teilzeichenkette, ohne Groß-/Kleinschreibung).
cli-arg-ae-title = Application Entity title
cli-arg-destination-node = Name oder ID des Zielknotens
cli-arg-duplicate = Nach Duplikatstatus filtern.
cli-arg-export = Ergebnisse als JSON oder CSV exportieren.
cli-arg-host = Hostname oder IP
cli-arg-imported-at =
    Nach Importzeitpunkt filtern. Unterstützt VALUE, START..END, ..END, START...
        Lexikografischer Vergleich (empfohlenes Format: RFC3339).
cli-arg-json = Abschließende Operationszusammenfassung als JSON ausgeben (stabiles Schema).
cli-arg-level = Abfrage-/Abrufebene
cli-arg-metrics-json = Beim Beenden den In-Memory-Metrik-Snapshot als JSON ausgeben.
cli-arg-modality = Nach Modalität filtern. Kommagetrennte Liste (z. B. CT,MR).
cli-arg-model = Informationsmodell für Abfrage/Abruf
cli-arg-move-destination = Bevorzugter C-MOVE-Ziel-AE-Titel
cli-arg-name = Anzeigename des Knotens
cli-arg-node = Name oder ID des gespeicherten Knotens
cli-arg-notes = Freitextnotizen
cli-arg-out = Ausgabedateipfad. Ohne Angabe: Ausgabe auf stdout.
cli-arg-path = Zu importierende Datei oder Verzeichnis
cli-arg-patient-id = Nach Patienten-ID filtern (Teilzeichenkette, ohne Groß-/Kleinschreibung).
cli-arg-patient-name = Nach Patientenname filtern (Teilzeichenkette, ohne Groß-/Kleinschreibung).
cli-arg-port = TCP-Port
cli-arg-series-description = Nach Serienbeschreibung filtern (Teilzeichenkette, ohne Groß-/Kleinschreibung).
cli-arg-series-instance-uid = Series Instance UID
cli-arg-sop-instance-uid = SOP Instance UID
cli-arg-source-path = Nach Quellpfad filtern (Teilzeichenkette, ohne Groß-/Kleinschreibung).
cli-arg-study-date =
    Nach Studiendatum filtern. Unterstützt VALUE, START..END, ..END, START...
        Daten werden lexikografisch verglichen (empfohlenes Format: YYYYMMDD).
cli-arg-study-date-from = Untere Grenze des Studiendatums (YYYYMMDD)
cli-arg-study-date-to = Obere Grenze des Studiendatums (YYYYMMDD)
cli-arg-study-description = Nach Studienbeschreibung filtern (Teilzeichenkette, ohne Groß-/Kleinschreibung).
cli-arg-study-instance-uid = Study Instance UID
cli-cmd-import-about = DICOM-Dateien von einem Pfad importieren
cli-cmd-local-about = Lokales Archiv prüfen
cli-cmd-local-series-about = Indizierte Serien einer Studie auflisten
cli-cmd-local-studies-about = Indizierte lokale Studien auflisten
cli-cmd-node-about = Gespeicherte entfernte DICOM-Knoten verwalten
cli-cmd-node-add-about = Entfernten Knoten hinzufügen
cli-cmd-node-delete-about = Gespeicherten Knoten löschen
cli-cmd-node-edit-about = Gespeicherten Knoten bearbeiten
cli-cmd-node-list-about = Gespeicherte Knoten auflisten
cli-cmd-query-about = Entfernten Knoten abfragen (C-FIND)
cli-cmd-retrieve-about = Von einem entfernten Knoten abrufen (C-MOVE)
cli-cmd-send-about = Lokale Studien oder Serien senden (C-STORE)
cli-cmd-send-series-about = Eine Serie an einen Zielknoten senden
cli-cmd-send-study-about = Eine Studie an einen Zielknoten senden
cli-cmd-serve-about = DICOM-Server starten
cli-cmd-storage-scp-about = Storage-SCP-Listener starten
cli-cmd-tui-about = Interaktive Terminaloberfläche öffnen
cli-flag-help = Hilfe anzeigen
cli-flag-lang = Oberflächensprache (BCP-47-Tag). Überschreibt DICOM_NODE_LANG, die gespeicherte Locale und die Systemlocale.
cli-flag-version = Version anzeigen
cli-heading-arguments = Argumente:
cli-heading-commands = Befehle:
cli-heading-options = Optionen:
cli-heading-usage = Verwendung:
cli-import-accepted = accepted={ $n }
cli-import-complete = Import abgeschlossen
cli-import-duplicates = duplicates={ $n }
cli-import-scanned = scanned={ $n }
cli-msg-cancel-sigint = Abbruch angefordert (SIGINT). Warte auf geordnetes Herunterfahren...
cli-msg-failures = Fehler:
cli-msg-import-failed = Import fehlgeschlagen: { $error }
cli-msg-no-local-series = Keine indizierten Serien für Studie { $uid }
cli-msg-no-local-studies = Keine indizierten lokalen Studien
cli-msg-no-saved-nodes = Keine gespeicherten Knoten
cli-msg-query-failed = Abfrage fehlgeschlagen: { $error }
cli-msg-removed-nodes =
    Entfernt { $count ->
        [one] { $count } Knoten
       *[other] { $count } Knoten
    }
cli-msg-results-count =
    Ergebnisse: { $count ->
        [one] { $count } Treffer
       *[other] { $count } Treffer
    }
cli-msg-retrieve-failed = Abruf fehlgeschlagen: { $error }
cli-msg-saved-node = Knoten gespeichert { $name } [{ $id }] => { $ae }@{ $host }:{ $port }
cli-msg-send-failed = Senden fehlgeschlagen: { $error }
cli-msg-showing-failures = (zeige erste { $shown } von { $total } Fehlern)
cli-msg-starting-server =
    Starte DICOM-Server mit { $count ->
        [one] { $count } lokale AE
       *[other] { $count } lokale AEs
    }: { $aes }
cli-msg-starting-server-no-aes = DICOM-Server startet ohne konfigurierte lokale AEs
cli-msg-starting-storage-scp = Storage-SCP startet unter { $addr } mit AE-Titel { $ae }
cli-msg-updated-node = Knoten aktualisiert { $name } [{ $id }] => { $ae }@{ $host }:{ $port }
cli-send-attempted = attempted={ $n }
cli-send-failed-count = failed={ $n }
cli-send-sent = sent={ $n }
cli-value-name-file = FILE
cli-value-name-format = FORMAT
cli-value-name-locale = LOCALE
cli-value-name-path = PATH
tui-detail-more-series =
    ... { $n ->
        [one] { $n } weitere Serie
       *[other] { $n } weitere Serien
    }
tui-row-instance-count =
    { $n ->
        [one] { $n } Inst.
       *[other] { $n } Inst.
    }
tui-row-study-counts = { $series }s/{ $instances }i
count-nodes =
    { $n ->
        [one] { $n } Knoten
       *[other] { $n } Knoten
    }
count-instances =
    { $n ->
        [one] { $n } Instanz
       *[other] { $n } Instanzen
    }
count-series =
    { $n ->
        [one] { $n } Serie
       *[other] { $n } Serien
    }
count-studies =
    { $n ->
        [one] { $n } Studie
       *[other] { $n } Studien
    }
format-datetime = { $date } { $time }
format-date = { $day }.{ $month }.{ $year }

## Common
common-accession = Accession-Nr.
common-add = Hinzufügen
common-back = Zurück
common-bytes = Byteanzahl
common-cancel = Abbrechen
common-clear = Leeren
common-close = Schließen
common-date = Datum
common-delete = Knoten löschen
common-description = Beschreibung
common-disabled = deaktiviert
common-duplicates = Duplikate
common-edit = Bearbeiten
common-enabled = aktiviert
common-error = Fehler
common-filter = Suchfilter
common-host = Hostname
common-import = Importieren
common-instance = Instanz
common-language = Sprache
common-loading = Laden
common-matches = Treffer
common-modality = Modalität
common-name = Bezeichnung
common-network = Netzwerk
common-no = nein
common-none = keine
common-notes = Notizen
common-optional = wahlfrei
common-path = Quelle
common-patient = Patient/in
common-patient-id = Patienten-ID
common-patient-name = Patientenname
common-port = TCP-Port
common-query = Abfragen
common-refresh = Aktualisieren
common-required = erforderlich
common-retrieve = Abrufen
common-save = Speichern
common-search = Suchen
common-send = Senden
common-series = Serien
common-start = Starten
common-status = Zustand
common-stop = Stoppen
common-studies = Studien
common-study = Studie
common-unknown = unbekannt
common-unknown-series = <Serien>
common-unknown-study = <Studien>
common-yes = ja

## Errors
error-ae-empty = AE title darf nicht leer sein
error-ae-invalid-char = AE title enthält ungültiges Zeichen '{ $character }'; erlaubt: A-Z, 0-9, Leerzeichen
error-ae-required = AE-Titel ist erforderlich
error-ae-too-long = AE title darf höchstens 16 Zeichen haben
error-ae-whitespace = AE title darf keine führenden oder nachgestellten Leerzeichen haben
error-archive-patient-retrieve-out-of-scope = Patient-Level-Retrieve liegt außerhalb des Umfangs
error-archive-retrieve-uid-required = { $name } ist für diese Retrieve-Ebene erforderlich
error-archive-study-root-patient-query = Study-Root-Abfragen unterstützen die Patient-Ebene nicht
error-archive-study-root-patient-retrieve = Study-Root-Retrieve unterstützt die Patient-Ebene nicht
error-assoc-negotiation-failed = Associationsverhandlung mit { $name } ({ $addr }) fehlgeschlagen; Hinweis: called AE title, presentation contexts/transfer syntaxes prüfen und ob der Peer Associations akzeptiert
error-assoc-no-addresses = keine Socket-Adressen für { $name } unter { $host }:{ $port } aufgelöst
error-assoc-receive = Association empfangen
error-assoc-resolving = { $name } wird aufgelöst unter { $host }:{ $port }: { $err }
error-assoc-timeout = Zeitüberschreitung beim Warten auf DIMSE-Antwort; Hinweis: Netzwerk, AE title/Host/Port und Peer-Antwort prüfen
error-assoc-transport = Transportunterbrechung beim Warten auf DIMSE-Antwort; Hinweis: Peer hat die Verbindung geschlossen oder ein Netzwerkgerät hat sie zurückgesetzt
error-assoc-unreachable = { $name } [{ $ae }] unter { $host }:{ $port } innerhalb von { $seconds }s nicht erreichbar: { $err }. Host/IP, Port und Netzwerkerreichbarkeit prüfen
error-cancel-sigint = Abbruch angefordert (SIGINT). Warte auf geordnetes Herunterfahren...
error-config-must-be-positive = ungültige Konfiguration: { $name } muss > 0 sein (oder null zum Deaktivieren)
error-config-duplicate-bind-port = ungültige Konfiguration: doppelter lokaler AE-Bind-Port { $port }
error-config-local-ae-max-assoc = ungültige Konfiguration: lokale AE { $title } max_concurrent_associations muss > 0 sein
error-config-local-ae-no-services = ungültige Konfiguration: lokale AE { $title } muss mindestens einen Dienst aktivieren
error-config-must-be-positive-required = ungültige Konfiguration: { $name } muss > 0 sein
error-dicom-meta-incomplete = DICOM-Dateimeta ist unvollständig
error-dicom-patient-move-unsupported = C-MOVE auf Patientenebene wird von diesem Client-Scaffold nicht unterstützt
error-dicom-required-attribute = erforderliches DICOM-Attribut fehlt: ({ $group },{ $element })
error-dicom-series-uid-required-image = series_instance_uid ist für Retrieve auf Bildebene erforderlich
error-dicom-series-uid-required-series = series_instance_uid ist für Retrieve auf Serienebene erforderlich
error-dicom-sop-uid-required-image = sop_instance_uid ist für Retrieve auf Bildebene erforderlich
error-dicom-study-uid-required = study_instance_uid ist erforderlich
error-dicom-validating-move = Move-Anfrage wird validiert
error-export-creating-file = Exportdatei wird erstellt { $path }: { $err }
error-export-flushing-series-csv = CSV der Serien wird geschrieben (flush): { $err }
error-export-flushing-studies-csv = CSV der Studien wird geschrieben (flush): { $err }
error-export-serializing-series-json = JSON der Serien wird serialisiert: { $err }
error-export-serializing-studies-json = JSON der Studien wird serialisiert: { $err }
error-export-writing-series-csv-header = CSV-Kopfzeile der Serien wird geschrieben: { $err }
error-export-writing-series-csv-row = CSV-Zeile der Serien wird geschrieben: { $err }
error-export-writing-studies-csv-header = CSV-Kopfzeile der Studien wird geschrieben: { $err }
error-export-writing-studies-csv-row = CSV-Zeile der Studien wird geschrieben: { $err }
error-import-cleanup-failed = { $source }: Bereinigung fehlgeschlagen: { $reason }
error-import-corrupt-zip = Beschädigtes ZIP: { $details }
error-import-dicom-parse-failed = DICOM-Analyse fehlgeschlagen: { $err }
error-import-dicom-validation-failed = DICOM-Validierung fehlgeschlagen: { $err }
error-import-duplicate-zip-path = ZIP enthält mehrere Einträge, die auf '{ $path }' zeigen
error-import-file-too-large = Datei zu groß: { $details }
error-import-invalid-dicom = Ungültiges DICOM: { $details }
error-import-limit-exceeded = { $limit } überschritten: { $details }
error-import-not-regular-file = keine reguläre Datei
error-import-opening-file = Datei wird geöffnet: { $err }
error-import-opening-kind = { $kind } { $path } wird geöffnet
error-import-opening-staged-file = bereitgestellte Datei wird geöffnet: { $err }
error-import-opening-zip-archive = ZIP-Archiv wird geöffnet { $path }
error-import-opening-zip-entry = ZIP-Eintrag wird geöffnet: { $err }
error-import-opening-zip-file = ZIP-Importdatei wird geöffnet { $path }
error-import-path-does-not-exist = Importpfad existiert nicht: { $path }
error-import-reading-directory = Importverzeichnis wird gelesen { $path }
error-import-reading-file = Datei wird gelesen: { $err }
error-import-reading-file-metadata = Dateimetadaten werden gelesen für { $path }
error-import-reading-metadata = Metadaten werden gelesen für { $kind } { $path }
error-import-reading-zip-entry = ZIP-Eintrag wird gelesen: { $err }
error-import-removing-staged-after-cancel = bereitgestellte Datei wird nach Abbruch entfernt { $path }
error-import-skipped = { $source }: übersprungen: { $reason }
error-import-unreadable = Datei nicht lesbar: { $details }
error-import-unsafe-zip-path = Eintragspfad verlässt das Archiv
error-import-zip-entry-count-exceeded = ZIP-Eintragsanzahl überschritten: Archiv hat { $count } Einträge, Limit ist { $limit }
error-import-zip-entry-size-exceeded = ZIP-Eintragsgröße { $size } überschreitet Limit { $limit }
error-import-zip-total-bytes-exceeded = Limit der entpackten ZIP-Bytes überschritten: aktueller Gesamtbetrag { $current } plus Eintragsgröße { $entry } überschreitet Limit { $limit }
error-net-binding-storage-scp = Storage-SCP wird gebunden an { $addr } für AE { $ae }. Ein anderer lokaler DICOM-Empfänger verwendet diesen Port möglicherweise bereits. Aktualisieren Sie storage_scp_port/local_aes in { $config } oder beenden Sie den konfliktierenden Listener
error-net-building-file-meta = File-Meta-Tabelle wird erstellt
error-net-cannot-send-transfer-syntax = Quell-transfer syntax kann nicht gesendet werden { $source } mit ausgehandelter transfer syntax { $negotiated }
error-net-cget-dataset-empty = kodiertes C-GET-C-STORE-Dataset ist leer
error-net-cget-dataset-odd-length = kodiertes C-GET-C-STORE-Dataset endete mit einem nachlaufenden Fragment ungerader Länge
error-net-cget-peer-released = Peer hat die Association während C-GET freigegeben
error-net-cget-store-unexpected-dataset = unerwartetes Dataset-Fragment in der C-GET-C-STORE-Antwort
error-net-cget-unexpected-command = unerwarteter Befehl 0x{ $command } beim Warten auf C-STORE-RSP
error-net-cget-unexpected-pdu = unerwartete PDU während der C-GET-C-STORE-Unteroperation: { $pdu }
error-net-creating-incoming-dir = Storage-SCP-.incoming-Verzeichnis wird erstellt
error-net-creating-path = erstellen { $path }
error-net-dataset-empty = kodiertes Dataset ist leer, aber COMMAND_DATA_SET_TYPE verlangt ein Dataset
error-net-dataset-odd-length = kodiertes Dataset endete mit einem nachlaufenden Fragment ungerader Länge
error-net-dimse-failed = { $operation } fehlgeschlagen mit Status 0x{ $status } ({ $meaning }){ $hint }
error-net-establishing-assoc = Storage-SCP-Association wird aufgebaut
error-net-file-meta-length = File-Meta-Information-Länge wird gelesen
error-net-file-meta-tag = File-Meta-Information-Tag wird gelesen
error-net-file-meta-value = File-Meta-Information-Wert wird übersprungen
error-net-file-meta-vr = File-Meta-Information-VR wird gelesen
error-net-file-position = Dateiposition wird gelesen
error-net-flushing-path = leeren { $path }
error-net-flushing-temp-dataset = temporäre Dataset-Datei wird geleert
error-net-hint-suffix = ; Hinweis: { $hint }
error-net-incomplete-command = unvollständig { $operation } Befehlsantwort
error-net-incomplete-identifier = unvollständig { $operation } Antwort-Identifikator
error-net-invalid-affected-sop = ungültig { $operation } affected SOP class UID
error-net-invalid-status = ungültig { $operation } status
error-net-listener-address = Storage-SCP-Listener-Adresse wird gelesen
error-net-listener-nonblocking = Listener wird auf nonblocking gesetzt
error-net-listener-port = Storage-SCP-Listener-Port wird gelesen
error-net-local-aes-empty = local_aes muss mindestens ein AE enthalten, um den Storage-SCP zu starten
error-net-locating-dataset = Dataset wird gesucht in { $path }
error-net-malformed-dimse = fehlerhafte { $operation } DIMSE-Antwort: { $details }; Hinweis: Peer hat ein ungültiges oder unerwartetes DIMSE-command set gesendet
error-net-missing-affected-sop = fehlend { $operation } affected SOP class UID
error-net-missing-command-field = Befehlsfeld fehlt
error-net-missing-cstore-rsp-command-field = Befehlsfeld der C-STORE-Antwort fehlt
error-net-missing-cstore-rsp-status = Status der C-STORE-Antwort fehlt
error-net-missing-destination = C-MOVE-Ziel fehlt
error-net-missing-dicm = Part-10-DICM-Marker fehlt
error-net-missing-message-id = fehlend { $operation } message id
error-net-missing-qr-level = { $operation } Identifikator ohne QueryRetrieveLevel
error-net-missing-required-command-field = erforderliches Befehlsfeld fehlt { $name } ({ $tag })
error-net-missing-status = fehlend { $operation } status
error-net-move-destination-unresolved = move_destination wurde nicht aufgelöst
error-net-no-cget-store-context = kein ausgehandelter C-GET-Speicher-presentation context für SOP Class { $sop } und transfer syntax { $syntax }
error-net-no-compatible-context = { $path }: kein kompatibler ausgehandelter presentation context für die Quell-transfer syntax { $syntax }
error-net-no-dimse-provider = kein DIMSE-Anbieter für Befehl registriert 0x{ $command } und abstract syntax { $syntax }
error-net-no-presentation-context = kein ausgehandelter presentation context
error-net-no-presentation-context-for-file = { $path }: kein ausgehandelter presentation context
error-net-no-presentation-context-id = ausgehandelter presentation context fehlt { $id }
error-net-opening-path = öffnen { $path }
error-net-part10-preamble = Part-10-Präambel wird gelesen
error-net-path-error = { $path }: { $err }
error-net-pdata-feed-complete = P-DATA-Fragment kann nicht in einen vollständigen Akkumulator eingespeist werden (take() fehlt)
error-net-peer-aborted = Peer hat die Association während der C-GET-C-STORE-Unteroperation abgebrochen: { $source }
error-net-peer-socket = Storage-SCP-Peer-Socketadresse wird gelesen
error-net-reading-command-dataset = Befehls-Dataset wird gelesen
error-net-reading-identifier = lesen { $operation } identifier
error-net-reading-incoming-dataset = eingehendes C-STORE-Dataset wird gelesen
error-net-reading-response-dataset = lesen { $operation } response dataset
error-net-remote-aborted = Gegenstelle hat die Association abgebrochen: { $source }
error-net-restoring-read-timeout = Association-Lese-Timeout wird wiederhergestellt
error-net-restoring-write-timeout = Association-Schreib-Timeout wird wiederhergestellt
error-net-rewinding-dataset = Zurückspulen zum ersten Dataset-Element
error-net-scp-thread-panicked = Storage-SCP-Thread ist abgestürzt
error-net-seeking-temp-dataset = temporäre Dataset-Datei wird positioniert
error-net-serializing-cget-dataset = C-GET-Unteroperations-Dataset wird serialisiert für { $path }
error-net-serializing-dataset = Dataset wird serialisiert für { $path } mit transfer syntax { $syntax }
error-net-setting-socket-blocking = akzeptierter Speichersocket wird auf blocking gesetzt
error-net-sending-buffered-dataset = gepuffertes Dataset wird gesendet für { $path }
error-net-store-status = Gegenstelle lieferte C-STORE-Status 0x{ $status } ({ $meaning }){ $hint }
error-net-streaming-dataset = C-STORE-Dataset wird gestreamt
error-net-unexpected-command-field = unerwartetes CommandField 0x{ $actual } (erwartet 0x{ $expected } for { $rsp })
error-net-unexpected-dataset-fragment = unerwartetes Dataset-Fragment in der C-STORE-Antwort
error-net-unexpected-pdu = unerwartete PDU während { $operation }: { $pdu }
error-net-unknown-status = unbekannt oder ungültig { $operation } status 0x{ $status }
error-net-unsupported-model-sop = nicht unterstützt { $operation } model SOP class UID: { $uid }
error-net-unsupported-qr-level = nicht unterstütztes QueryRetrieveLevel: { $level }
error-net-unsupported-transfer-syntax = nicht unterstützte ausgehandelte transfer syntax
error-net-writing-command-dataset = Befehls-Dataset wird geschrieben
error-net-writing-identifier = schreiben { $operation } identifier
error-net-writing-path = schreiben { $path }
error-net-writing-response-dataset = schreiben { $operation } response dataset
error-net-writing-temp-dataset = Dataset-Bytes werden in temporäre Datei geschrieben
error-node-host-empty = Knoten-Host darf nicht leer sein
error-node-name-empty = Knotenname darf nicht leer sein
error-node-not-found = entfernter Knoten nicht gefunden: { $id }
error-operation-cancelled = Vorgang abgebrochen
error-port-invalid = ungültiger Port: { $value }
error-port-range = Port muss zwischen 1 und 65535 liegen
error-query-no-study-uid = Treffer hat keine StudyInstanceUID; Abruf nicht möglich.
error-query-unsupported-level = nicht unterstützte Query-Ebene: { $value }
error-query-unsupported-model = nicht unterstütztes Query-Modell: { $value }
error-retrieve-canceled = Retrieve wurde vom entfernten Knoten abgebrochen (status=0x{ $status }, completed={ $completed }, failed={ $failed }, warning={ $warning }, remaining={ $remaining }, { $scp })
error-retrieve-failed = Retrieve fehlgeschlagen mit status=0x{ $status } (completed={ $completed }, failed={ $failed }, warning={ $warning }, remaining={ $remaining }, { $scp })
error-retrieve-nothing-arrived = Retrieve für Ziel { $destination } mit completed={ $completed } beendet, aber nichts am lokalen Storage SCP angekommen ({ $scp }). AE-Zuordnung oder Port prüfen: sicherstellen, dass { $listener } frei ist und der entfernte Knoten AE { $destination } dieser App zuordnet
error-send-no-files-series = keine lokalen Dateien für Serie { $uid } indexiert
error-send-no-files-study = keine lokalen Dateien für Studie { $uid } indexiert
error-task-cancelled = Aufgabe abgebrochen
error-task-none-to-cancel = Keine aktive Aufgabe zum Abbrechen (nichts läuft)
error-tracing-init = tracing subscriber wird initialisiert: { $err }
error-uid-component-numeric = UID-Komponente „{ $part }“ muss numerisch sein
error-uid-component-too-long = UID-Komponente „{ $part }“ ist zu lang
error-uid-dot-ends = UID darf nicht mit einem Punkt beginnen oder enden
error-uid-empty = UID darf nicht leer sein
error-uid-empty-component = UID darf keine leeren Komponenten enthalten
error-uid-leading-zeros = UID-Komponente „{ $part }“ darf keine führenden Nullen haben
error-uid-too-long = UID darf höchstens 64 Zeichen haben

## TUI
tui-bool-no = nein
tui-bool-off = aus
tui-bool-on = ein
tui-bool-yes = ja
tui-command-placeholder = Befehl eingeben oder Bereichstastenkürzel nutzen.
tui-config-ae-title = AE title: { $value }
tui-config-edit-hint = Tab drücken, um diesen Bereich zu fokussieren, dann 'c' zum Bearbeiten.
tui-config-hint = Tab drücken, um diesen Bereich zu fokussieren, dann 'c' zum Bearbeiten.
tui-config-listener = Empfänger: { $value }
tui-config-max-pdu = max_pdu_length: { $value }
tui-config-promiscuous = allow_promiscuous_storage: { $value }
tui-config-strict-pdu = strict_pdu: { $value }
tui-config-ts-pref = TS-Präferenz: { $value }
tui-controls-hint = Tab Felder · Enter bestätigt · Esc bricht ab
tui-detail-ae-title = AE Title
tui-detail-instance = Instanzdetail
tui-detail-name = Bezeichnung
tui-detail-node = Knotendetail
tui-detail-placeholder-followup = Fokus auf einen Listenbereich setzen und die Auswahl ändern, um diese Ansicht zu aktualisieren.
tui-detail-query = Abfrageergebnis-Detail
tui-detail-select-node = Wählen Sie einen entfernten Knoten, um dessen Metadaten zu prüfen.
tui-detail-series = Seriendetail
tui-detail-study = Studiendetail
tui-empty-command-placeholder = Befehl eingeben oder Bereichstastenkürzel nutzen.
tui-empty-detail-instance = Wählen Sie eine Instanz zur Prüfung, oder kehren Sie mit Esc zu den Serien zurück.
tui-empty-detail-node = Wählen Sie einen entfernten Knoten, um dessen Metadaten zu prüfen.
tui-empty-detail-query = Wählen Sie ein Abfrageergebnis, um Metadaten und den Retrieve-Kontext zu prüfen.
tui-empty-detail-series = Wählen Sie eine Serie zur Prüfung, oder kehren Sie mit Esc zu den Studien zurück.
tui-empty-detail-study = Wählen Sie eine lokale Studie, um Patienten- und Serienmetadaten zu prüfen.
tui-empty-instances = Für diese Serie sind keine indizierten Instanzen vorhanden.
tui-empty-instances-hint = Esc drücken, um zu den Serien zurückzukehren.
tui-empty-local-instances = Für diese Serie sind keine indizierten Instanzen vorhanden.
tui-empty-local-instances-hint = Esc drücken, um zu den Serien zurückzukehren.
tui-empty-local-series = Für diese Studie sind keine indizierten Serien vorhanden.
tui-empty-local-series-hint = Esc drücken, um zu den lokalen Studien zurückzukehren.
tui-empty-local-studies = Es sind noch keine indizierten Studien vorhanden.
tui-empty-local-studies-cmd = Beispiel: import path=/data/inbox
tui-empty-local-studies-hint = Importieren Sie zuerst lokale DICOM-Dateien.
tui-empty-no-name = <kein Name>
tui-empty-query = Es wurde noch keine Abfrage ausgeführt.
tui-empty-query-body =
    Wählen Sie einen entfernten Knoten und drücken Sie 'f' für eine Abfrage.
    Oder: query node=pacs
        patient_name="DOE^JOHN"
    Drücken Sie 'm' auf einem ausgewählten Ergebnis, um retrieve zu öffnen.
tui-empty-query-cmd = Oder: query node=pacs
tui-empty-query-hint = Wählen Sie einen entfernten Knoten und drücken Sie 'f' für eine Abfrage.
tui-empty-query-last-target = Letztes Abfrageziel: { $name }
tui-empty-query-none = Es wurde noch keine Abfrage ausgeführt.
tui-empty-query-retrieve-hint = Drücken Sie 'm' auf einem ausgewählten Ergebnis, um retrieve zu öffnen.
tui-empty-remote-nodes =
    Es sind noch keine entfernten Knoten gespeichert.
    
    Drücken Sie in diesem Bereich „a“, um einen hinzuzufügen.
    Oder: node add name=pacs
        ae=PACSAE host=10.0.0.10
        port=104
tui-empty-remote-nodes-cmd = Oder: node add name=pacs
tui-empty-remote-nodes-hint = Drücken Sie in diesem Bereich „a“, um einen hinzuzufügen.
tui-empty-series = Für diese Studie sind keine indizierten Serien vorhanden.
tui-empty-series-hint = Esc drücken, um zu den lokalen Studien zurückzukehren.
tui-empty-studies = Es sind noch keine indizierten Studien vorhanden.
tui-empty-studies-hint = Importieren Sie zuerst lokale DICOM-Dateien.
tui-empty-tasks-history = Kein Aufgabenverlauf.
tui-empty-tasks-queued = Keine Aufgaben in der Warteschlange.
tui-fallback-no-name = <kein Name>
tui-field-accession = Accession-Nummer
tui-field-ae-title = AE-Titel
tui-field-bind-addr = Bind-Adresse
tui-field-date-from = Datum von
tui-field-date-to = Datum bis
tui-field-destination-node = Zielknoten
tui-field-host = Hostname
tui-field-instance-uid = Instance UID
tui-field-kind = Art
tui-field-level = Ebene
tui-field-local-ae = Lokales AE
tui-field-max-pdu = Max. PDU
tui-field-modality = Modalität
tui-field-model = Modell
tui-field-move-destination = C-MOVE-Ziel
tui-field-name = Bezeichnung
tui-field-notes = Notizen
tui-field-path = Pfad
tui-field-patient-id = Patienten-ID
tui-field-patient-name = Patientenname
tui-field-port = TCP-Port
tui-field-promiscuous = Promiskuitiv
tui-field-series-uid = Series UID
tui-field-sop-uid = SOP Instance UID
tui-field-strict-pdu = Striktes PDU
tui-field-study-description = Studienbeschreibung
tui-field-study-uid = Study UID
tui-footer-back-series = Esc zurück zu Serien
tui-footer-back-studies = Esc zurück zu Studien
tui-footer-cancel-task = c Abbrechen
tui-footer-edit-config = c Konfig. bearbeiten
tui-footer-enter-series = Enter Serien
tui-footer-esc-series = Esc zurück zu Serien
tui-footer-esc-studies = Esc zurück zu Studien
tui-footer-help = F1/? Hilfe
tui-footer-inspect = Enter prüfen
tui-footer-next = Weiter: { $text }
tui-footer-nodes = a/e/d/f Knoten
tui-footer-panes = Tab Bereiche
tui-footer-queued =
    { $n ->
        [one] { $n } in der Warteschlange
       *[other] { $n } in der Warteschlange
    }
tui-footer-quit = q beenden
tui-footer-refresh = r aktualisieren
tui-footer-retrieve = m Abrufen
tui-footer-run-command = Enter Befehl ausführen
tui-footer-task-scope = t Warteschlange/Verlauf
tui-form-add-node = Entfernten Knoten hinzufügen
tui-form-add-remote-node = Entfernten Knoten hinzufügen
tui-form-delete-confirm = Entfernten Knoten { $name } [{ $ae }] unter { $host }:{ $port } löschen?
tui-form-delete-node = Entfernten Knoten löschen
tui-form-delete-remote-node = Entfernten Knoten löschen
tui-form-edit-node = Entfernten Knoten bearbeiten
tui-form-edit-remote-node = Entfernten Knoten bearbeiten
tui-form-err-ae-required = ! AE title is erforderlich
tui-form-err-bind-required = ! bind address is erforderlich
tui-form-err-host-required = ! host is erforderlich
tui-form-err-local-ae-invalid = ! ungültiger lokaler AE-Titel: { $err }
tui-form-err-local-ae-required = ! local AE title is erforderlich
tui-form-err-modality-empty = modality darf nicht leer sein
tui-form-err-move-dest-invalid = ! ungültiger Move-Ziel-AE-Titel: { $err }
tui-form-err-name-required = ! Knotenname is erforderlich
tui-form-err-port-required = ! port is erforderlich
tui-form-err-uid-empty = UID darf nicht leer sein
tui-form-err-uid-empty-component = UID darf keine leeren Komponenten enthalten
tui-form-error-line = Fehler: { $error }
tui-form-field-accession = Accession-Nummer
tui-form-field-ae-title = AE-Titel
tui-form-field-bind-addr = Bind-Adresse
tui-form-field-date-from = Datum von
tui-form-field-date-to = Datum bis
tui-form-field-dest-node = Zielknoten
tui-form-field-destination = Ziel-AE
tui-form-field-host = Hostname
tui-form-field-instance-uid = SOP Instance UID
tui-form-field-kind = Art
tui-form-field-level = Ebene
tui-form-field-local-ae = Lokales AE
tui-form-field-modality = Modalität
tui-form-field-model = Modell
tui-form-field-move-dest = C-MOVE-Ziel
tui-form-field-name = Bezeichnung
tui-form-field-notes = Notizen
tui-form-field-path = Pfad
tui-form-field-patient-id = Patienten-ID
tui-form-field-patient-name = Patientenname
tui-form-field-port = TCP-Port
tui-form-field-series-uid = Series Instance UID
tui-form-field-sop-uid = SOP Instance UID
tui-form-field-study-desc = Studienbeschreibung
tui-form-field-study-uid = Study Instance UID
tui-form-field-uid = UID
tui-form-hint-bind = Hinweis: meist 0.0.0.0 (alle Schnittstellen) oder 127.0.0.1
tui-form-hint-local-ae = Hinweis: bis zu 16 Zeichen (A-Z, 0-9, Leerzeichen), z. B. ARCHIVE_AE
tui-form-hint-move-dest = Hinweis: optional; überschreibt den Ziel-AE-Titel für C-MOVE
tui-form-hint-name = Hinweis: kurze Bezeichnung (z. B. PACS)
tui-form-import = Lokale Dateien importieren
tui-form-import-local = Lokale Dateien importieren
tui-form-import-local-files = Lokale Dateien importieren
tui-form-mode-add = create a new entfernter Knoten
tui-form-mode-edit = update the selected entfernter Knoten
tui-form-query-node = Entfernten Knoten abfragen
tui-form-query-remote-node = Entfernten Knoten abfragen
tui-form-remote-node-line = Entfernter Knoten: { $name } [{ $ae }] { $host }:{ $port }
tui-form-retrieve = Treffer abrufen
tui-form-retrieve-matches = Treffer abrufen
tui-form-send-series = Serie senden
tui-form-send-study = Studie senden
tui-form-storage-intro = Lokale Storage-SCP-Einstellungen bearbeiten (in config.json gespeichert).
tui-form-storage-scp = Storage-SCP-Einstellungen
tui-form-storage-scp-settings = Storage-SCP-Einstellungen
tui-help-ae-title = AE title: { $value }
tui-help-aedf = a/e/d/f     Add, edit, delete, or query from the selected Knoten
tui-help-c = c           Storage-SCP-Einstellungen bearbeiten (Fokus auf Konfigurationsbereich)
tui-help-canonical-names = Kanonische Namen entsprechen CLI-Flags ohne '--' und nutzen Unterstriche.
tui-help-close = Hilfe mit Esc, F1 oder ? schließen.
tui-help-common-commands = Häufige Befehle
tui-help-config = c           Storage-SCP-Einstellungen bearbeiten (Fokus auf Konfigurationsbereich)
tui-help-config-path = Konfigurationspfad: { $value }
tui-help-current-config = Aktuelle Konfiguration
tui-help-data-dir = Datenverzeichnis: { $value }
tui-help-enter-default = Enter       Run the command input, submit the active modal, or open series from Lokale Studien
tui-help-enter-instance = Enter       Keine Lokalbereich-Aktion in der Instanzansicht
tui-help-enter-local-instance = Enter       Keine Lokalbereich-Aktion in der Instanzansicht
tui-help-enter-local-series = Enter       Instanzen der ausgewählten lokalen Serie öffnen, oder Befehlseingabe ausführen / aktives Modal senden
tui-help-enter-local-study = Enter       Serien der ausgewählten lokalen Studie öffnen, oder Befehlseingabe ausführen / aktives Modal senden
tui-help-enter-series = Enter       Instanzen der ausgewählten lokalen Serie öffnen, oder Befehlseingabe ausführen / aktives Modal senden
tui-help-enter-study = Enter       Serien der ausgewählten lokalen Studie öffnen, oder Befehlseingabe ausführen / aktives Modal senden
tui-help-esc-default = Esc         Hilfe/Modal schließen, von lokalen Serien zurück, oder Fokus zur Befehlseingabe
tui-help-esc-instance = Esc         Von lokalen Instanzen zu Serien zurück, Hilfe/Modal schließen, oder Fokus zur Befehlseingabe
tui-help-esc-instances = Esc         Von lokalen Instanzen zu Serien zurück, Hilfe/Modal schließen, oder Fokus zur Befehlseingabe
tui-help-esc-series = Esc         Von lokalen Serien zu Studien zurück, Hilfe/Modal schließen, oder Fokus zur Befehlseingabe
tui-help-f1 = F1 or ?     Hilfe öffnen
tui-help-import-send = i/s         Importieren local files or send selected study/series
tui-help-is = i/s         Importieren local files or send selected study/series
tui-help-listener = Empfänger: { $value }
tui-help-log-dir = Protokollverzeichnis: { $value }
tui-help-m = m           Vom ausgewählten Abfrageergebnis abrufen
tui-help-max-pdu = max_pdu_length: { $value }
tui-help-move = Auf/Ab oder j/k   Auswahl in Listenbereichen bewegen
tui-help-nodes = a/e/d/f     Add, edit, delete, or query from the selected Knoten
tui-help-open = F1 or ?     Hilfe öffnen
tui-help-promiscuous = allow_promiscuous_storage: { $value }
tui-help-q = q           Beenden, wenn kein Modal aktiv ist und der Fokus nicht in der Befehlseingabe liegt
tui-help-quit = q           Beenden, wenn kein Modal aktiv ist und der Fokus nicht in der Befehlseingabe liegt
tui-help-r = r           Aktualisieren panes when focus is neint in command input
tui-help-receiver-mode = Empfängermodus: { $value }
tui-receiver-mode-on-demand = bei Bedarf für lokalen Retrieve
tui-receiver-mode-standalone = eigenständig über storage-scp
tui-help-refresh = r           Aktualisieren panes when focus is neint in command input
tui-help-retrieve = m           Vom ausgewählten Abfrageergebnis abrufen
tui-help-strict-pdu = strict_pdu: { $value }
tui-help-tab = Tab / Shift-Tab  Fokusbereich wechseln
tui-help-title = Tastenkürzel
tui-help-ts-pref = preferred_store_transfer_syntax: { $value }
tui-help-updown = Auf/Ab oder j/k   Auswahl in Listenbereichen bewegen
tui-input-placeholder = Befehl eingeben oder Bereichstastenkürzel nutzen.
tui-log-command = > { $command }
tui-log-error = Fehler: { $error }
tui-log-refreshed = aktualisiert
tui-logs-capped-suffix = begrenzt
tui-logs-label = Protokolle:
tui-pane-command = Befehl
tui-pane-config = Konfiguration
tui-pane-detail = Einzelansicht
tui-pane-detail-hint = { $title } (PgUp/PgDn wenn nicht getippt wird)
tui-pane-help = Hilfe
tui-pane-instance-detail = Instanzdetail
tui-pane-instances-for = Instanzen für: { $uid }
tui-pane-local-studies = Lokale Studien
tui-pane-logs = Protokolle ({ $shown }/{ $total }{ $capped })
tui-pane-logs-capped = Protokolle ({ $shown }/{ $total } capped)
tui-pane-logs-uncapped = Protokolle ({ $shown }/{ $total })
tui-pane-node-detail = Knotendetail
tui-pane-query-detail = Abfrageergebnis-Detail
tui-pane-query-node = Knoten abfragen
tui-pane-query-result-detail = Abfrageergebnis-Detail
tui-pane-query-results = Abfrage-/Abruf-Ergebnisse
tui-pane-query-retrieve-results = Abfrage-/Abruf-Ergebnisse
tui-pane-remote-nodes = Entfernte Knoten
tui-pane-series-detail = Seriendetail
tui-pane-series-for = Serien für: { $uid }
tui-pane-series-unknown = Serien für: <unbekannte Studie>
tui-pane-study-detail = Studiendetail
tui-pane-task-details = Aufgabendetail
tui-pane-tasks-history = Aufgaben (Verlauf)
tui-pane-tasks-queued = Aufgaben (Warteschlange)
tui-pane-unknown-series = <unbekannte Serie>
tui-pane-unknown-study = Serien für: <unbekannte Studie>
tui-row-inst = inst
tui-status-cancel-requested = Abbrechenlation requested
tui-status-config = Konfiguration
tui-status-configured-listener = Konfigurierter Listener { $addr } als AE { $ae } ({ $mode })
tui-status-data = Daten
tui-status-failure = Fehler: { $failure }
tui-status-listener = Empfänger
tui-status-local-ae = Lokales AE
tui-status-mode = Modus
tui-status-mode-on-demand = bei Bedarf
tui-status-mode-standalone = eigenständig
tui-status-no-active-task = Keine aktive Aufgabe to cancel (nichts läuft)
tui-status-pdu = PDU
tui-status-promiscuous = Promiskuitiv
tui-status-query-before-retrieve = Query a entfernter Knoten first so retrieve knows which Knoten to use
tui-status-query-failed = Abfrage fehlgeschlagen: { $error }
tui-status-queued-op = Operation in Warteschlange: { $op }
tui-status-retrieve-failed = Abruf fehlgeschlagen: { $error }
tui-status-retrieve-open-failed = konnte nicht geöffnet werden retrieve stream: { $error }
tui-status-saved-node = saved Knoten { $name } ({ $id })
tui-status-saved-scp = Storage SCP settings saved (restart erforderlich)
tui-status-select-node = wählen Sie zuerst einen entfernten Knoten
tui-status-select-query = zuerst ein Abfrageergebnis auswählen
tui-status-select-study = zuerst eine lokale Studie auswählen
tui-status-strict = Strikt
tui-status-task-cancelled = Aufgabe abgebrochen
tui-status-task-cancelled-detail = Aufgabe abgebrochen: { $other }
tui-status-ts-pref = TS-Präferenz
tui-status-updated-node = updated Knoten { $name } ({ $id })
tui-suggest-back-series = Esc — zurück zu Serien
tui-suggest-edit-config = c — Konfig. bearbeiten
tui-suggest-help = F1/? — Hilfe
tui-suggest-inspect-task = Enter — Aufgabe prüfen
tui-suggest-node-add = node add <ae-title> <host:port>
tui-suggest-query = f — query a Knoten
tui-suggest-query-node = f — query selected Knoten
tui-suggest-retrieve = m — Auswahl abrufen
tui-suggest-run-command = Enter — Befehl ausführen
tui-suggest-send-series = s — ausgewählte Serie senden
tui-suggest-view-series = Enter — Serien anzeigen
tui-task-cancelled = Abgebrochen
tui-task-cancelling = Wird abgebrochen
tui-task-failed = Fehlgeschlagen
tui-task-failed-generic = Aufgabe fehlgeschlagen: { $error }
tui-task-import-done = Importieren complete: { $report }
tui-task-import-failed = Import fehlgeschlagen: { $error }
tui-task-importing = Import von { $path }...
tui-task-query-done =
    Abfrage abgeschlossen: { $count ->
        [one] { $count } Treffer
       *[other] { $count } Treffer
    }
tui-task-query-failed = Abfrage fehlgeschlagen: { $error }
tui-task-querying = Abfrage von { $node }...
tui-task-queued = In Warteschlange
tui-task-retrieve-done = Abruf abgeschlossen: { $outcome }
tui-task-retrieve-failed = Abruf fehlgeschlagen: { $error }
tui-task-retrieving = Abruf von { $node }...
tui-task-running = Läuft
tui-task-sending-series = Sende Serie { $uid } an { $node }...
tui-task-sending-study = Sende Studie { $uid } an { $node }...
tui-task-send-done = Senden abgeschlossen: { $outcome }
tui-task-status-cancelled = abgebrochen
tui-task-status-cancelling = wird abgebrochen
tui-task-status-failed = fehlgeschlagen
tui-task-status-ok = ok
tui-task-status-queued = wartend
tui-task-status-running = läuft
tui-task-succeeded = Erfolgreich
tui-terminal-too-small = Terminal zu klein — bitte Größe anpassen

## Desktop
desktop-action-activity = Aktivität { $count }
desktop-action-activity-empty = Aktivität
desktop-action-import = Importieren
desktop-action-inspect-archive = Lokales Archiv prüfen
desktop-action-inspect-archive-desc = Studien, Serien und Instanzen prüfen, dann senden oder exportieren.
desktop-action-manage-peers = Peers verwalten
desktop-action-manage-peers-desc = PACS- oder Workstation-Knoten für Query, Retrieve und Store hinzufügen und bearbeiten.
desktop-action-monitor-scp = Storage-SCP überwachen
desktop-action-query = Abfragen
desktop-action-refresh = Status aktualisieren
desktop-action-refresh-status = Status aktualisieren
desktop-action-reveal-log = Protokolldatei anzeigen
desktop-action-send = Senden
desktop-action-start-scp = Storage-SCP starten
desktop-activity-empty = Noch keine Sitzungsaktivität.
desktop-activity-title = Aktivität
desktop-app-title = DICOM Node
desktop-archive-csv = CSV
desktop-archive-details = Einzelheiten
desktop-archive-empty = Das lokale Archiv ist leer.
desktop-archive-export-fail = Export { $scope } fehlgeschlagen
desktop-archive-export-ok =
    { $rows ->
        [one] { $rows } { $scope }-Zeile nach { $path } exportiert.
       *[other] { $rows } { $scope }-Zeilen nach { $path } exportiert.
    }
desktop-archive-export-studies = Studien exportieren
desktop-archive-export-title = { $scope } exportieren
desktop-archive-filter = Filtern nach Patient, UID, Beschreibung, Modalität…
desktop-archive-filter-placeholder = Filtern nach Patient, UID, Beschreibung, Modalität…
desktop-archive-inst-abbrev =
    { $count ->
        [one] { $count } Inst.
       *[other] { $count } Inst.
    }
desktop-archive-instance-meta = { $bytes } · TS { $ts } · importiert { $imported }
desktop-archive-instances = Instanzen
desktop-archive-instances-heading = Instanzen
desktop-archive-json = JSON
desktop-archive-loading = Studien werden geladen…
desktop-archive-no-filter-match = Keine Studien entsprechen dem Filter.
desktop-archive-no-instances = Keine Instanzen gefunden.
desktop-archive-no-match = Keine Studien entsprechen dem Filter.
desktop-archive-no-nodes = Keine Knoten
desktop-archive-no-series = Keine Serien gefunden.
desktop-archive-reveal-file = Datei anzeigen
desktop-archive-select-series = Wählen Sie eine Serie.
desktop-archive-select-study = Wählen Sie eine Studie.
desktop-archive-send-fail = { $label }: { $sent }/{ $attempted } gesendet, { $failed } fehlgeschlagen. { $failures }
desktop-archive-send-fail-title = { $label } fehlgeschlagen
desktop-archive-send-ok = { $label }: { $sent }/{ $attempted } Instanzen gesendet.
desktop-archive-send-series = Serie senden
desktop-archive-send-series-label = Serie → { $destination }
desktop-archive-send-study = Studie senden
desktop-archive-send-study-label = Studie → { $destination }
desktop-archive-send-to = Senden an
desktop-archive-series = Serien
desktop-archive-series-count =
    #{ $number } · { $count ->
        [one] { $count } Instanz
       *[other] { $count } Instanzen
    }
desktop-archive-series-fallback = Serien
desktop-archive-studies = Studien
desktop-archive-study-date = Studiendatum
desktop-archive-study-uid = Study UID
desktop-archive-subtitle = Bestand an Studien, Serien und Instanzen aus dem lokalen SQLite-Archiv.
desktop-archive-title = Lokales Archiv
desktop-brand-title = DICOM Node
desktop-col-description = Beschreibung
desktop-col-instances = Instanzen
desktop-col-modalities = Modalitäten
desktop-col-patient-id = Patienten-ID
desktop-common-cancel = Abbrechen
desktop-common-clear = Leeren
desktop-common-disabled = deaktiviert
desktop-common-enabled = aktiviert
desktop-common-loading = Laden…
desktop-common-no = nein
desktop-common-refresh = Aktualisieren
desktop-common-yes = ja
desktop-counter-assoc-accepted = Akzeptierte Assoziationen
desktop-counter-bytes-ingested = Aufgenommene Bytes
desktop-counter-cfind-requests = C-FIND-Anfragen
desktop-counter-cmove-requests = C-MOVE-Anfragen
desktop-counter-cstore-failed = C-STORE fehlgeschlagen
desktop-counter-cstore-stored = C-STORE gespeichert
desktop-dashboard-counter-assoc-accepted = Akzeptierte Assoziationen
desktop-dashboard-counter-bytes-ingested = Aufgenommene Bytes
desktop-dashboard-counter-c-find-requests = C-FIND-Anfragen
desktop-dashboard-counter-c-move-requests = C-MOVE-Anfragen
desktop-dashboard-counter-c-store-failed = C-STORE fehlgeschlagen
desktop-dashboard-counter-c-store-stored = C-STORE gespeichert
desktop-dashboard-empty-studies = Noch keine lokalen Studien.
desktop-dashboard-inspect-archive-body = Studien prüfen, in Serien und Instanzen wechseln, dann senden oder exportieren.
desktop-dashboard-inspect-archive-title = Lokales Archiv prüfen
desktop-dashboard-kv-ae-title = AE-Titel
desktop-dashboard-kv-data-dir = Datenverzeichnis
desktop-dashboard-kv-listener = Empfänger
desktop-dashboard-kv-log-file = Protokolldatei
desktop-dashboard-kv-max-pdu = Max. PDU
desktop-dashboard-kv-promiscuous = Promiskuitiver Speicher
desktop-dashboard-kv-server = Dienst
desktop-dashboard-kv-store-syntax = Store-Syntax
desktop-dashboard-kv-strict-pdu = Strikte PDU
desktop-dashboard-listener-missing = Listener noch nicht geladen.
desktop-dashboard-live-counters = Live-Zähler
desktop-dashboard-loading-metrics = Metriken werden geladen…
desktop-dashboard-loading-status = Lokaler Status wird geladen…
desktop-dashboard-loading-studies = Studien werden geladen…
desktop-dashboard-local-node = Lokaler Knoten
desktop-dashboard-manage-peers-body = PACS- oder Workstation-Knoten für Abfrage, Abruf und Speicherung hinzufügen und bearbeiten.
desktop-dashboard-manage-peers-title = Peers verwalten
desktop-dashboard-metric-instances = Instanzen
desktop-dashboard-metric-nodes = Entfernte Knoten
desktop-dashboard-metric-series = Serien
desktop-dashboard-metric-studies = Studien
desktop-dashboard-monitor-scp = Storage SCP überwachen
desktop-dashboard-recent-studies = Aktuelle Studien
desktop-dashboard-start-scp = Storage SCP starten
desktop-dashboard-subtitle = Lokales Archiv, Netzwerk-Peers und SCP-Aktivität auf einen Blick.
desktop-dashboard-title = Operator-Übersicht
desktop-doc-title = DICOM Node
desktop-import-accepted = Akzeptiert
desktop-import-accepted-bytes = Akzeptierte Bytes
desktop-import-activity-detail = { $accepted }/{ $scanned } akzeptiert, { $duplicates } Duplikate, { $bytes }
desktop-import-activity-fail = Import fehlgeschlagen
desktop-import-activity-ok = Import abgeschlossen
desktop-import-choose-archive = Wählen Sie ein ZIP-Archiv zum Import
desktop-import-choose-dir = Wählen Sie ein Verzeichnis zum Import
desktop-import-choose-folder = Ordner
desktop-import-choose-zip = Wählen Sie ein ZIP-Archiv zum Import
desktop-import-cleanup = Bereinigung
desktop-import-clear-path = Pfad leeren
desktop-import-complete = Import abgeschlossen
desktop-import-dup-sha = SHA-256
desktop-import-dup-sop = SOP UID
desktop-import-dup-total = Gesamt
desktop-import-duplicates = Duplikate
desktop-import-failed = Import fehlgeschlagen
desktop-import-failed-cleanup = Bereinigung fehlgeschlagen
desktop-import-failures = Fehler
desktop-import-failures-heading =
    { $count ->
        [one] { $count } Fehler:
       *[other] { $count } Fehler:
    }
desktop-import-failures-more = … und { $count } weitere
desktop-import-files-progress = { $label } Dateien
desktop-import-folder = Ordner
desktop-import-invalid-dicom = Ungültiges DICOM
desktop-import-pick-dir = Wählen Sie ein Verzeichnis zum Import
desktop-import-pick-zip = Wählen Sie ein ZIP-Archiv zum Import
desktop-import-placeholder = /path/to/dicom-folder or /path/to/archive.zip
desktop-import-rejected = Abgelehnt
desktop-import-report = Importbericht
desktop-import-running = Importiere…
desktop-import-scanned = Gescannt
desktop-import-skipped = Übersprungen
desktop-import-source = Quelle
desktop-import-start = Import starten
desktop-import-stored = Gespeichert
desktop-import-subtitle = DICOM-Dateien aus rekursiven Ordnern oder ZIP-Archiven ins verwaltete lokale Archiv indexieren.
desktop-import-title = Importieren
desktop-import-unreadable = Unlesbar
desktop-import-zip = ZIP
desktop-import-zip-filter = ZIP-Archive
desktop-lang-label = Sprache
desktop-listener-not-loaded = Listener noch nicht geladen.
desktop-live-counters = Live-Zähler
desktop-loading = Laden
desktop-loading-local-status = Lokaler Status wird geladen…
desktop-loading-metrics = Metriken werden geladen…
desktop-loading-studies = Studien werden geladen…
desktop-local-node = Lokaler Knoten
desktop-locale-label = Sprache
desktop-logs-activity-detail =
    { $count ->
        [one] { $count } Zeile geladen
       *[other] { $count } Zeilen geladen
    }
desktop-logs-activity-fail = Protokollaktualisierung fehlgeschlagen
desktop-logs-activity-ok = Protokoll aktualisiert
desktop-logs-auto = AUTO-AKT.
desktop-logs-auto-refresh = Automatisch aktualisieren
desktop-logs-empty = Die Protokolldatei ist leer.
desktop-logs-found = PROTOKOLLDATEI GEFUNDEN
desktop-logs-lines =
    { $count ->
        [one] { $count } Zeile
       *[other] { $count } Zeilen
    }
desktop-logs-loading = Protokoll wird geladen…
desktop-logs-missing = Die aktive Protokolldatei wurde noch nicht erstellt.
desktop-logs-refresh-failed = Protokollaktualisierung fehlgeschlagen
desktop-logs-refreshed = Protokoll aktualisiert
desktop-logs-reveal = Anzeigen
desktop-logs-subtitle = Begrenztes Ende der aktiven Desktop-Protokolldatei.
desktop-logs-tail = Ende
desktop-logs-title = Protokolle
desktop-logs-truncated = GEKÜRZT
desktop-logs-waiting = WARTE AUF PROTOKOLLDATEI
desktop-metric-instances = Instanzen
desktop-metric-remote-nodes = Entfernte Knoten
desktop-metric-series = Serien
desktop-metric-studies = Studien
desktop-nav-archive = Lokales Archiv
desktop-nav-dashboard = Übersicht
desktop-nav-import = Importieren
desktop-nav-logs = Protokolle
desktop-nav-network = Netzwerk
desktop-nav-nodes = Entfernte Knoten
desktop-nav-query = Abfrage / Abruf
desktop-nav-server = Speicherserver
desktop-no-local-studies = Noch keine lokalen Studien.
desktop-nodes-add = Knoten hinzufügen
desktop-nodes-added = Knoten "{ $name }" hinzugefügt.
desktop-nodes-ae-length = AE-Titel darf höchstens 16 Zeichen haben.
desktop-nodes-ae-title = AE-Titel
desktop-nodes-col-move = Move-Ziel
desktop-nodes-configured = Konfigurierte Knoten
desktop-nodes-confirm-delete = Knoten "{ $name }" löschen?
desktop-nodes-default-port = Standardport 104
desktop-nodes-delete = Knoten löschen
desktop-nodes-delete-title = Knoten löschen
desktop-nodes-deleted = Knoten "{ $name }" gelöscht.
desktop-nodes-edit = Knoten bearbeiten
desktop-nodes-edit-title = Knoten bearbeiten
desktop-nodes-empty = Noch keine entfernten Knoten.
desktop-nodes-err-ae = AE-Titel ist erforderlich.
desktop-nodes-err-ae-len = AE-Titel darf höchstens 16 Zeichen haben.
desktop-nodes-err-host = Host ist erforderlich.
desktop-nodes-err-name = Name ist erforderlich.
desktop-nodes-err-port = Port muss zwischen 1 und 65535 liegen.
desktop-nodes-host = Hostname
desktop-nodes-move-dest = Move-Ziel
desktop-nodes-move-placeholder = Standard: lokale AE
desktop-nodes-name = Bezeichnung
desktop-nodes-need-ae = AE-Titel ist erforderlich.
desktop-nodes-need-host = Host ist erforderlich.
desktop-nodes-need-name = Name ist erforderlich.
desktop-nodes-notes = Notizen
desktop-nodes-notes-placeholder = Befundungsraum-PACS
desktop-nodes-placeholder-ae = PACS01
desktop-nodes-placeholder-host = 192.168.0.10
desktop-nodes-placeholder-move = Standard: lokale AE
desktop-nodes-placeholder-name = main-pacs
desktop-nodes-placeholder-notes = Befundungsraum-PACS
desktop-nodes-port = TCP-Port
desktop-nodes-port-104 = Standardport 104
desktop-nodes-port-range = Port muss zwischen 1 und 65535 liegen.
desktop-nodes-save = Änderungen speichern
desktop-nodes-save-changes = Änderungen speichern
desktop-nodes-subtitle = PACS- und Workstation-Peers für Abfrage, Abruf und Speicherung.
desktop-nodes-summary = Knotenübersicht
desktop-nodes-title = Entfernte Knoten
desktop-nodes-total = Knoten gesamt
desktop-nodes-updated = Knoten "{ $name }" aktualisiert.
desktop-nodes-with-move = Mit Move-Ziel
desktop-promiscuous = Promiskuitiver Speicher
desktop-query-accession = Accession-Nr.
desktop-query-activity-detail = { $count } { $count ->
        [one] Treffer
       *[other] Treffer
    } auf Ebene { $level }
desktop-query-activity-fail = C-FIND { $node } fehlgeschlagen
desktop-query-activity-ok = C-FIND { $node }
desktop-query-activity-title = C-FIND { $node }
desktop-query-clear = Leeren
desktop-query-col-accession = Accession-Nr.
desktop-query-criteria = Suchkriterien
desktop-query-date-from = Studiendatum von
desktop-query-date-to = Studiendatum bis
desktop-query-kv-series-uid = Series UID
desktop-query-kv-sop-uid = SOP UID
desktop-query-kv-study-uid = Study UID
desktop-query-level = Ebene
desktop-query-matches =
    { $count ->
        [one] { $count } Treffer
       *[other] { $count } Treffer
    }
desktop-query-missing-study-uid = Treffer hat keine StudyInstanceUID; Abruf nicht möglich.
desktop-query-modality = Modalität
desktop-query-no-matches = Keine Treffer.
desktop-query-no-nodes = Keine Knoten konfiguriert
desktop-query-patient-id = Patienten-ID
desktop-query-patient-name = Patientenname
desktop-query-placeholder-description = CHEST*
desktop-query-placeholder-modality = CT, MR, …
desktop-query-placeholder-name = DOE^JOHN or DOE*
desktop-query-placeholder-patient = DOE^JOHN or DOE*
desktop-query-querying = Abfrage…
desktop-query-remote-node = Entfernter Knoten
desktop-query-results = Ergebnisse
desktop-query-retrieve = Abrufen
desktop-query-retrieve-activity-detail = completed={ $completed }, warning={ $warning }, failed={ $failed }
desktop-query-retrieve-activity-fail = C-MOVE { $node } fehlgeschlagen
desktop-query-retrieve-activity-ok = C-MOVE { $node }
desktop-query-retrieve-finished = Abruf beendet: abgeschlossen { $completed }, Warnungen { $warning }, fehlgeschlagen { $failed }.
desktop-query-retrieve-selected = Auswahl abrufen
desktop-query-run = C-FIND ausführen
desktop-query-run-select = Führen Sie eine Abfrage aus und wählen Sie einen Treffer.
desktop-query-running = Abfrage…
desktop-query-search-criteria = Suchkriterien
desktop-query-select-hint = Führen Sie eine Abfrage aus und wählen Sie einen Treffer.
desktop-query-selected = Ausgewählter Treffer
desktop-query-selected-match = Ausgewählter Treffer
desktop-query-series-uid = Series Instance UID
desktop-query-sop-uid = SOP Instance UID
desktop-query-study-description = Studienbeschreibung
desktop-query-study-uid = Study Instance UID
desktop-query-subtitle = C-FIND an einen entfernten Knoten, Treffer prüfen, dann C-MOVE ins lokale Archiv.
desktop-query-title = Abfrage / Abruf
desktop-recent-studies = Aktuelle Studien
desktop-scp-listening = SCP horcht
desktop-scp-stopped = SCP gestoppt
desktop-server-activity-fail = Storage-SCP-Steuerung fehlgeschlagen
desktop-server-activity-started = Storage SCP gestartet
desktop-server-activity-started-detail = Listener gestartet.
desktop-server-activity-stopped = Storage SCP gestoppt
desktop-server-activity-stopped-detail = received={ $received }, stored={ $stored }, failed={ $failed }
desktop-server-activity-stopped-empty = Keine aktive Sitzung.
desktop-server-addr-ae = { $addr } · AE { $ae }
desktop-server-assoc-accepted = Akzeptierte Assoziationen
desktop-server-assoc-rejected = Abgelehnte Assoziationen
desktop-server-cfind-req-matches = C-FIND-Anfragen / Treffer
desktop-server-cget-requests = C-GET-Anfragen
desktop-server-cmove-requests = C-MOVE-Anfragen
desktop-server-cmove-subops = C-MOVE-Unteroperationen abgeschlossen / fehlgeschlagen
desktop-server-control-failed = Storage-SCP-Steuerung fehlgeschlagen
desktop-server-counter-bytes = Aufgenommene Bytes
desktop-server-counter-failed = C-STORE fehlgeschlagen
desktop-server-counter-find = C-FIND-Anfragen / Treffer
desktop-server-counter-get = C-GET-Anfragen
desktop-server-counter-move = C-MOVE-Anfragen
desktop-server-counter-move-sub = C-MOVE-Unteroperationen abgeschlossen / fehlgeschlagen
desktop-server-counter-received = C-STORE empfangen
desktop-server-counter-stored = C-STORE gespeichert
desktop-server-cstore-failed = C-STORE fehlgeschlagen
desktop-server-cstore-received = C-STORE empfangen
desktop-server-cstore-stored = C-STORE gespeichert
desktop-server-dimse = DIMSE-Zähler
desktop-server-failed = Fehlgeschlagen
desktop-server-health-loading = Metriken werden geladen
desktop-server-health-ready = Bereit für eingehendes C-STORE
desktop-server-health-review = Fehler prüfen
desktop-server-health-stopped = Gestoppt
desktop-server-listener-started = Listener gestartet.
desktop-server-listening = HORCHT
desktop-server-loading-metrics = Metriken werden geladen…
desktop-server-logs = Protokolle
desktop-server-no-session = Keine aktive Sitzung.
desktop-server-rate = +{ $rate } / Abfrage
desktop-server-ready = Bereit für eingehendes C-STORE
desktop-server-review-failures = Fehler prüfen
desktop-server-session-ended = Sitzung beendet: empfangen { $received }, gespeichert { $stored }, fehlgeschlagen { $failed }.
desktop-server-start = Server starten
desktop-server-started-title = Storage SCP gestartet
desktop-server-stop = Server stoppen
desktop-server-stopped = GESTOPPT
desktop-server-stopped-pill = GESTOPPT
desktop-server-stopped-status = Gestoppt
desktop-server-stopped-title = Storage SCP gestoppt
desktop-server-stored = Gespeichert
desktop-server-subtitle = Eigenständiger Storage SCP für eingehendes C-STORE und lokale Archivindexierung.
desktop-server-title = Speicherserver
desktop-status-listening = horcht
desktop-status-loading = Laden
desktop-status-scp-listening = SCP horcht
desktop-status-scp-stopped = SCP gestoppt
desktop-status-stopped = gestoppt
desktop-store-syntax = Store-Syntax
desktop-strict-pdu = Strikte PDU
desktop-strip-pdu = PDU { $value }
desktop-table-accession = Accession-Nr.
desktop-table-ae-title = AE-Titel
desktop-table-date = Datum
desktop-table-description = Beschreibung
desktop-table-endpoint = Endpunkt
desktop-table-instances = Instanzen
desktop-table-modalities = Modalitäten
desktop-table-modality = Modalität
desktop-table-move-dest = Move-Ziel
desktop-table-name = Bezeichnung
desktop-table-notes = Notizen
desktop-table-patient = Patient/in
desktop-table-patient-id = Patienten-ID
desktop-table-series = Serien
desktop-table-updated = Aktualisiert
desktop-title-refresh-status = Status aktualisieren
desktop-title-reveal-log = Protokolldatei anzeigen
ae = AE
patient-name =
    "DOE^JOHN"
    Drücken Sie 'm' auf einem ausgewählten Ergebnis, um retrieve zu öffnen.
port = TCP-Port

## Summary
summary-ae = AE
summary-counts = Zähler
summary-criteria = Kriterien
summary-duration = Dauer
summary-duration-ms = { $ms }ms
summary-failures = Fehler:
summary-kind = Art
summary-logs = Protokolle:
summary-peer = Gegenstelle
summary-status = Zustand
summary-title = Operationszusammenfassung
tui-detail-created = Erstellt

tui-form-hint-port-range = Hinweis: eine Zahl von 1 bis 65535, z. B. 104
tui-form-hint-promiscuous = Hinweis: Speicherung von jedem rufenden AE-Titel zulassen
tui-form-hint-strict-pdu = Hinweis: PDU-Größenprüfungen während Assoziationen erzwingen
tui-form-hint-max-pdu-bytes = Hinweis: Bytes, z. B. 16384
tui-form-limits-heading = Limits (bytes; blank/keine = unlimited):
tui-form-field-max-file-import = Max. Dateiimportbytes
tui-form-field-max-zip-entry = Max. ZIP-Eintragsbytes
tui-form-field-max-zip-total = Max. ZIP-Gesamtbytes
tui-form-field-max-zip-count = Max. ZIP-Eintragsanzahl
tui-form-field-max-store-object = Max. Speicherobjektbytes
tui-form-unlimited = unbegrenzt
tui-form-err-max-pdu-required = ! max PDU length is erforderlich
tui-form-err-max-pdu-gt-zero = ! max. PDU-Länge muss eine ganze Zahl größer als 0 sein
tui-form-err-limit-gt-zero = ! { $label } muss eine ganze Zahl größer als 0 sein
tui-form-controls-scp = Tippen zum Bearbeiten. Leertaste schaltet Kontrollkästchen. Tab/Umschalt-Tab oder Auf/Ab wechselt Felder. Enter speichert. Esc bricht ab.
tui-form-submit-uid-required = UID is erforderlich
tui-form-submit-dest-required = destination Knoten is erforderlich
tui-form-submit-nonneg-int = { $label } muss eine nichtnegative ganze Zahl sein
tui-form-submit-gt-zero = { $label } muss größer als 0 sein
tui-form-submit-local-ae-required = local AE title is erforderlich
tui-form-submit-local-ae-invalid = lokaler AE-Titel ist ungültig: { $err }
tui-form-submit-bind-required = bind address is erforderlich
tui-form-submit-port-required = port is erforderlich
tui-form-submit-max-pdu-required = max PDU length is erforderlich
tui-form-submit-max-pdu-int = max. PDU-Länge muss eine ganze Zahl sein
tui-form-submit-max-pdu-gt-zero = max. PDU-Länge muss größer als 0 sein
tui-form-submit-patient-retrieve = Abruf auf Patientenebene wird nicht unterstützt
tui-form-submit-no-study-uid = ausgewähltes Ergebnis enthält kein study UID
tui-form-submit-date-format = erwartet YYYYMMDD
tui-form-submit-modality-len = Modalität darf höchstens 16 Zeichen haben
tui-form-submit-modality-chars = Modalität muss A-Z oder 0-9 sein
tui-form-submit-name-required = Knotenname is erforderlich
tui-form-submit-ae-required = AE title is erforderlich
tui-form-submit-host-required = host is erforderlich
tui-form-submit-move-dest-invalid = Move-Ziel-AE-Titel ist ungültig: { $err }
tui-form-submit-dates-both = Datum von und Datum bis müssen beide gesetzt sein oder keines
tui-form-submit-date-from-invalid = Datum von ist ungültig: { $err }
tui-form-submit-date-to-invalid = Datum bis ist ungültig: { $err }
tui-form-submit-date-order = Datum von muss am oder vor Datum bis liegen
tui-form-submit-study-uid-series-query = study UID is erforderlich for series-level queries
tui-form-submit-study-uid-image-query = study UID is erforderlich for image-level queries
tui-form-submit-series-uid-image-query = series UID is erforderlich for image-level queries
tui-form-submit-study-uid-required = study UID is erforderlich
tui-form-submit-study-uid-invalid = study UID ist ungültig: { $err }
tui-form-submit-series-uid-series-retrieve = series UID is erforderlich for series-level retrieve
tui-form-submit-series-uid-image-retrieve = series UID is erforderlich for image-level retrieve
tui-form-submit-instance-uid-image-retrieve = instance UID is erforderlich for image-level retrieve
tui-form-submit-series-uid-invalid = series UID ist ungültig: { $err }
tui-form-submit-instance-uid-invalid = instance UID ist ungültig: { $err }
tui-form-submit-import-path-required = import path is erforderlich
tui-form-submit-import-path-type = Importpfad muss eine Datei oder ein Verzeichnis sein: { $path }
tui-form-submit-import-access = Zugriff auf Importpfad { $path }
tui-form-submit-import-open = Import-Datei { $path } wird geöffnet
tui-form-submit-import-read-dir = Importverzeichnis { $path } wird gelesen
tui-log-welcome = Press F1 or ? for help. Focus Entfernter Knotens and press 'a' to add one.
tui-log-logging-to = Protokollierung nach { $path }
tui-command-help-heading = Befehle:
tui-command-help-next-1 = Hinweis: Die Fußzeile zeigt kontextbezogene 'Next:'-Vorschläge je nach fokussiertem Bereich und Auswahl.
tui-command-help-next-2 = Es sind nur Hinweise; Sie können jederzeit jeden Befehl eingeben.
tui-command-help-canonical = Hinweis: Kanonische Namen entsprechen CLI-Flags ohne '--', mit Unterstrichen.
tui-command-help-cancel = cancel (Alias: stop)
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
tui-command-help-refresh = aktualisieren
tui-command-help-quit = beenden
tui-inspect-task = Aufgabe #{ $id }
tui-inspect-status = Zustand: { $status }
tui-inspect-description = Beschreibung: { $description }
tui-inspect-progress = Fortschritt: { $progress }
tui-inspect-summary = Zusammenfassung:
tui-inspect-no-logs = (keine Protokolle)
tui-field-sop-class-uid = SOP Class UID
tui-field-transfer-syntax-uid = Transfer Syntax UID
tui-field-sha256 = SHA-256
tui-status-removed-nodes =
    entfernt { $count ->
        [one] { $count } Knoten
       *[other] { $count } Knoten
    }
tui-status-removed-nodes-target =
    entfernt { $count ->
        [one] { $count } Knoten
       *[other] { $count } Knoten
    }; letztes Ziel war { $name }
tui-status-more-failures =
    und { $n ->
        [one] { $n } Fehler ausgelassen
       *[other] { $n } Fehler ausgelassen
    }
tui-status-retrieve-ok = retrieve status=0x{ $status } completed={ $completed } failed={ $failed } warning={ $warning } remaining={ $remaining }
tui-status-import-counts = scanned={ $scanned } accepted={ $accepted } duplicates={ $duplicates } unreadable={ $unreadable } invalid_dicom={ $invalid } rejected_total={ $rejected } stored_bytes={ $bytes }
tui-status-send-ok = send attempted={ $attempted } sent={ $sent } failed={ $failed }
tui-log-query-start = Abfrage gegen { $node } wird gestartet
tui-log-retrieve-start = Abruf von { $node } wird gestartet
tui-log-import-start = Import von { $path } wird gestartet
tui-log-send-study-start = Senden der Studie { $uid } an { $node } wird gestartet
tui-log-send-series-start = Senden der Serie { $uid } an { $node } wird gestartet
tui-log-cancelled-before-start = abgebrochen vor dem Start
tui-log-cancelled = abgebrochen
error-unknown-command = unbekannter Befehl: { $command }
error-node-subcommand-required = node subcommand erforderlich
error-local-subcommand-required = local subcommand erforderlich
error-unsupported-node-subcommand = unsupported Knoten subcommand: { $command }
error-unsupported-local-subcommand = nicht unterstützter local-Unterbefehl: { $command }
error-expected-kv = Argument key=value erwartet, erhalten { $arg }
error-missing-required-arg = missing erforderlich argument: { $key }
error-missing-required-arg-one-of = missing erforderlich argument: one of { $keys }
error-parsing-command = Befehl wird analysiert
error-edit-form-lost-target = edit form lost its target Knoten
error-task-already-running = Hintergrundaufgabe läuft bereits
error-task-thread-launch = Hintergrund-Task-Thread konnte nicht gestartet werden: { $error }
error-task-disconnected = Hintergrund-Task-Thread wurde getrennt, bevor ein Ergebnis gesendet wurde
error-task-kind-missing = Hintergrund-Task-Thread getrennt, aber active_task_kind war None: unerwarteter Zustand
error-serve-exited = serve wurde mit Fehler beendet: { $error }
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
summary-title = Operationszusammenfassung
summary-kind = Art
summary-status = Zustand
summary-duration = Dauer
summary-duration-ms = { $ms }ms
summary-peer = Gegenstelle
summary-ae = AE
summary-criteria = Kriterien
summary-counts = Zähler
summary-failures = Fehler:
summary-logs = Protokolle:
summary-unserializable = <nicht serialisierbar>
summary-log-lines = Zeilen { $start }-{ $end }
