# Fluent catalog (nl-NL). Message IDs are hyphenated identifiers
# (cli-about, tui-pane-remote-nodes, desktop-nav-dashboard, error-import-file-too-large).
# Dotted names are Fluent attributes (message + .attr), not message IDs.
# Do not translate DICOM tokens (C-FIND, C-MOVE, C-STORE, SOP, AE, UID) or JSON/CSV machine keys.


## CLI
cli-about = Terminalgerichte DICOM-nodeclient, gebouwd met dicom-rs
cli-arg-accession-number = Filter op accession number (substring, hoofdletterongevoelig).
cli-arg-ae-title = Application Entity title
cli-arg-destination-node = Naam of id van de bestemmingsnode
cli-arg-duplicate = Filter op duplicaatstatus.
cli-arg-export = Exporteer resultaten als JSON of CSV.
cli-arg-host = Hostnaam of IP
cli-arg-imported-at =
    Filter op importtijdstip. Ondersteunt VALUE, START..END, ..END, START...
    Vergelijking is lexicografisch (aanbevolen formaat: RFC3339).
cli-arg-json = Geef een samenvatting van de operatie als JSON (stabiel schema).
cli-arg-level = Niveau voor query/retrieve
cli-arg-metrics-json = Druk bij afsluiten van de server de laatste in-memory metrics-snapshot af als JSON.
cli-arg-modality = Filter op modaliteit. Kommagescheiden lijst (bijv. CT,MR).
cli-arg-model = Informatmodel voor query/retrieve
cli-arg-move-destination = Voorkeursbestemming-AE title voor C-MOVE
cli-arg-name = Weergavenaam van de node
cli-arg-node = Naam of id van de opgeslagen node
cli-arg-notes = Vrije notities
cli-arg-out = Pad van het uitvoerbestand. Indien weggelaten, schrijft naar stdout.
cli-arg-path = Bestand of map om te importeren
cli-arg-patient-id = Filter op patiënt-ID (substring, hoofdletterongevoelig).
cli-arg-patient-name = Filter op patiëntennaam (substring, hoofdletterongevoelig).
cli-arg-port = Poort
cli-arg-series-description = Filter op seriesbeschrijving (substring, hoofdletterongevoelig).
cli-arg-series-instance-uid = Series Instance UID
cli-arg-sop-instance-uid = SOP Instance UID
cli-arg-source-path = Filter op bronpad (substring, hoofdletterongevoelig).
cli-arg-study-date =
    Filter op studydatum. Ondersteunt VALUE, START..END, ..END, START...
    Vergelijking is lexicografisch (aanbevolen formaat: YYYYMMDD).
cli-arg-study-date-from = Ondergrens van de studydatum (YYYYMMDD)
cli-arg-study-date-to = Bovengrens van de studydatum (YYYYMMDD)
cli-arg-study-description = Filter op studybeschrijving (substring, hoofdletterongevoelig).
cli-arg-study-instance-uid = Study Instance UID
cli-cmd-import-about = Importeer DICOM-bestanden vanaf een pad
cli-cmd-local-about = Inspecteer het lokale archief
cli-cmd-local-series-about = Toon geïndexeerde series van een study
cli-cmd-local-studies-about = Toon geïndexeerde lokale studies
cli-cmd-node-about = Beheer opgeslagen externe DICOM-nodes
cli-cmd-node-add-about = Voeg een externe node toe
cli-cmd-node-delete-about = Verwijder een opgeslagen node
cli-cmd-node-edit-about = Bewerk een opgeslagen node
cli-cmd-node-list-about = Toon opgeslagen nodes
cli-cmd-query-about = Raadpleeg een externe node (C-FIND)
cli-cmd-retrieve-about = Haal data op van een externe node (C-MOVE)
cli-cmd-send-about = Verstuur lokale studies of series (C-STORE)
cli-cmd-send-series-about = Verstuur een series naar een bestemmingsnode
cli-cmd-send-study-about = Verstuur een study naar een bestemmingsnode
cli-cmd-serve-about = Start de DICOM-server
cli-cmd-storage-scp-about = Start een Storage SCP-listener
cli-cmd-tui-about = Open de interactieve terminalinterface
cli-flag-help = Toon help
cli-flag-lang = Taal van de interface (BCP-47-tag). Overschrijft DICOM_NODE_LANG, de opgeslagen locale en de systeemlocale.
cli-flag-version = Toon versie
cli-heading-arguments = Argumenten:
cli-heading-commands = Commando's:
cli-heading-options = Opties:
cli-heading-usage = Gebruik:
cli-import-accepted = accepted={ $n }
cli-import-complete = Import voltooid
cli-import-duplicates = duplicates={ $n }
cli-import-scanned = scanned={ $n }
cli-msg-cancel-sigint = Annulering aangevraagd (SIGINT). Wachten op gecontroleerde afsluiting...
cli-msg-failures = fouten:
cli-msg-import-failed = Import mislukt: { $error }
cli-msg-no-local-series = Geen geïndexeerde series voor study { $uid }
cli-msg-no-local-studies = Geen geïndexeerde lokale studies
cli-msg-no-saved-nodes = Geen opgeslagen nodes
cli-msg-query-failed = Query mislukt: { $error }
cli-msg-removed-nodes =
    Verwijderd { $count ->
        [one] { $count } node
       *[other] { $count } nodes
    }
cli-msg-results-count =
    Resultaten: { $count ->
        [one] { $count } overeenkomst
       *[other] { $count } overeenkomsten
    }
cli-msg-retrieve-failed = Retrieve mislukt: { $error }
cli-msg-saved-node = Node opgeslagen { $name } [{ $id }] => { $ae }@{ $host }:{ $port }
cli-msg-send-failed = Verzenden mislukt: { $error }
cli-msg-showing-failures = (eerste { $shown } van { $total } fouten getoond)
cli-msg-starting-server =
    DICOM-server starten met { $count ->
        [one] { $count } lokale AE
       *[other] { $count } lokale AE's
    }: { $aes }
cli-msg-starting-server-no-aes = DICOM-server starten zonder geconfigureerde lokale AE's
cli-msg-starting-storage-scp = Storage SCP starten op { $addr } met AE title { $ae }
cli-msg-updated-node = Node bijgewerkt { $name } [{ $id }] => { $ae }@{ $host }:{ $port }
cli-send-attempted = attempted={ $n }
cli-send-failed-count = failed={ $n }
cli-send-sent = sent={ $n }
cli-value-name-file = FILE
cli-value-name-format = FORMAT
cli-value-name-locale = LOCALE
cli-value-name-path = PATH
tui-detail-more-series =
    ... { $n ->
        [one] { $n } serie extra
       *[other] { $n } series extra
    }
tui-row-instance-count =
    { $n ->
        [one] { $n } instantie
       *[other] { $n } instanties
    }
tui-row-study-counts = { $series }s/{ $instances }i
count-nodes =
    { $n ->
        [one] { $n } knooppunt
       *[other] { $n } knooppunten
    }
count-instances =
    { $n ->
        [one] { $n } instantie
       *[other] { $n } instanties
    }
count-series =
    { $n ->
        [one] { $n } serie
       *[other] { $n } series
    }
count-studies =
    { $n ->
        [one] { $n } studie
       *[other] { $n } studies
    }
format-datetime = { $date } { $time }
format-date = { $day }-{ $month }-{ $year }

## Common
common-accession = Accessie
common-add = Toevoegen
common-back = Terug
common-bytes = bytes
common-cancel = Annuleren
common-clear = Wissen
common-close = Sluiten
common-date = Datum
common-delete = Node verwijderen
common-description = Beschrijving
common-disabled = uitgeschakeld
common-duplicates = Duplicaten
common-edit = Bewerken
common-enabled = ingeschakeld
common-error = Fout
common-filter = Filteren
common-host = hostnaam
common-import = Importeren
common-instance = Instantie
common-language = Taal
common-loading = Laden
common-matches = Overeenkomsten
common-modality = Modaliteit
common-name = Naam
common-network = Netwerk
common-no = nee
common-none = geen
common-notes = Notities
common-optional = optioneel
common-path = Bron
common-patient = Patiënt
common-patient-id = Patiënt-ID
common-patient-name = Patiëntnaam
common-port = Poort
common-query = bevraging
common-refresh = Vernieuwen
common-required = vereist
common-retrieve = Ophalen
common-save = Opslaan
common-search = Zoeken
common-send = Verzenden
common-series = series
common-start = Starten
common-status = toestand
common-stop = Stoppen
common-studies = onderzoeken
common-study = Onderzoek
common-unknown = onbekend
common-unknown-series = <Series>
common-unknown-study = <Studies>
common-yes = ja

## Errors
error-ae-empty = AE title mag niet leeg zijn
error-ae-invalid-char = AE title bevat ongeldig teken '{ $character }'; toegestaan: A-Z, 0-9, spatie
error-ae-required = AE title is verplicht
error-ae-too-long = AE title mag maximaal 16 tekens zijn
error-ae-whitespace = AE title mag geen voorloop- of eindspaties hebben
error-archive-patient-retrieve-out-of-scope = Patient-niveau retrieve valt buiten het bereik
error-archive-retrieve-uid-required = { $name } is vereist voor dit retrieve-niveau
error-archive-study-root-patient-query = Study Root-query's ondersteunen Patient-niveau niet
error-archive-study-root-patient-retrieve = Study Root-retrieve ondersteunt Patient-niveau niet
error-assoc-negotiation-failed = association-onderhandeling met { $name } ({ $addr }) mislukt; hint: controleer called AE title, presentation contexts/transfer syntaxes en of de peer associations accepteert
error-assoc-no-addresses = geen socketadressen voor { $name } op { $host }:{ $port }
error-assoc-receive = association ontvangen
error-assoc-resolving = { $name } omzetten op { $host }:{ $port }: { $err }
error-assoc-timeout = time-out bij wachten op DIMSE-antwoord; hint: controleer netwerk, AE title/host/poort en peer-respons
error-assoc-transport = transportonderbreking tijdens wachten op DIMSE-antwoord; hint: de peer sloot de verbinding of netwerkapparatuur reset deze
error-assoc-unreachable = { $name } [{ $ae }] op { $host }:{ $port } niet bereikt binnen { $seconds }s: { $err }. Controleer host/IP, poort en netwerkbereikbaarheid
error-cancel-sigint = Annulering aangevraagd (SIGINT). Wachten op netjes afsluiten...
error-config-must-be-positive = ongeldige config: { $name } moet > 0 zijn (of null om uit te schakelen)
error-config-duplicate-bind-port = ongeldige config: dubbele lokale AE-bindpoort { $port }
error-config-local-ae-max-assoc = ongeldige config: lokale AE { $title } max_concurrent_associations moet > 0 zijn
error-config-local-ae-no-services = ongeldige config: lokale AE { $title } moet minstens één service inschakelen
error-config-must-be-positive-required = ongeldige config: { $name } moet > 0 zijn
error-dicom-meta-incomplete = DICOM-file meta is onvolledig
error-dicom-patient-move-unsupported = C-MOVE op patiëntniveau wordt door deze client niet ondersteund
error-dicom-required-attribute = vereist DICOM-attribuut ontbreekt: ({ $group },{ $element })
error-dicom-series-uid-required-image = series_instance_uid is vereist voor retrieve op imageniveau
error-dicom-series-uid-required-series = series_instance_uid is vereist voor retrieve op serieniveau
error-dicom-sop-uid-required-image = sop_instance_uid is vereist voor retrieve op imageniveau
error-dicom-study-uid-required = study_instance_uid is vereist
error-dicom-validating-move = move-verzoek valideren
error-export-creating-file = exportbestand maken { $path }: { $err }
error-export-flushing-series-csv = CSV series flushen: { $err }
error-export-flushing-studies-csv = CSV studies flushen: { $err }
error-export-serializing-series-json = series-JSON serialiseren: { $err }
error-export-serializing-studies-json = studies-JSON serialiseren: { $err }
error-export-writing-series-csv-header = CSV-kop series schrijven: { $err }
error-export-writing-series-csv-row = CSV-rij series schrijven: { $err }
error-export-writing-studies-csv-header = CSV-kop studies schrijven: { $err }
error-export-writing-studies-csv-row = CSV-rij studies schrijven: { $err }
error-import-cleanup-failed = { $source }: opschonen mislukt: { $reason }
error-import-corrupt-zip = Beschadigde ZIP: { $details }
error-import-dicom-parse-failed = DICOM-parse mislukt: { $err }
error-import-dicom-validation-failed = DICOM-validatie mislukt: { $err }
error-import-duplicate-zip-path = Dubbel ZIP-pad: { $details }
error-import-file-too-large = bestand te groot: { $details }
error-import-invalid-dicom = Ongeldige DICOM: { $details }
error-import-limit-exceeded = { $limit } overschreden: { $details }
error-import-not-regular-file = geen gewoon bestand
error-import-opening-file = bestand openen: { $err }
error-import-opening-kind = { $kind } { $path } openen
error-import-opening-staged-file = staged bestand openen: { $err }
error-import-opening-zip-archive = ZIP-archief openen { $path }
error-import-opening-zip-entry = ZIP-item openen: { $err }
error-import-opening-zip-file = ZIP-importbestand openen { $path }
error-import-path-does-not-exist = Importpad bestaat niet: { $path }
error-import-reading-directory = importdirectory lezen { $path }
error-import-reading-file = bestand lezen: { $err }
error-import-reading-file-metadata = bestandsmetadata lezen voor { $path }
error-import-reading-metadata = metadata lezen voor { $kind } { $path }
error-import-reading-zip-entry = ZIP-item lezen: { $err }
error-import-removing-staged-after-cancel = staged bestand verwijderen na annulering { $path }
error-import-skipped = Overgeslagen: { $details }
error-import-unreadable = Onleesbaar bestand: { $details }
error-import-unsafe-zip-path = Onveilig ZIP-pad: { $details }
error-import-zip-entry-count-exceeded = limiet aantal ZIP-items overschreden: archief heeft { $count } items, limiet is { $limit }
error-import-zip-entry-size-exceeded = ZIP-itemgrootte { $size } overschrijdt limiet { $limit }
error-import-zip-total-bytes-exceeded = limiet uitgepakte ZIP-bytes overschreden: huidig totaal { $current } plus itemgrootte { $entry } overschrijdt limiet { $limit }
error-net-binding-storage-scp = Storage SCP binden op { $addr } voor AE { $ae }. Een andere lokale DICOM-ontvanger gebruikt die poort mogelijk al. Werk storage_scp_port/local_aes bij in { $config } of stop de conflicterende listener
error-net-building-file-meta = file-meta-tabel opbouwen
error-net-cannot-send-transfer-syntax = bron-transfer syntax { $source } kan niet met onderhandelde { $negotiated } worden verzonden
error-net-cget-dataset-empty = gecodeerde C-GET C-STORE-dataset is leeg
error-net-cget-dataset-odd-length = gecodeerde C-GET C-STORE-dataset eindigde met een fragment van oneven lengte
error-net-cget-peer-released = peer gaf de associatie vrij tijdens C-GET
error-net-cget-store-unexpected-dataset = onverwacht dataset fragment in C-GET C-STORE response
error-net-cget-unexpected-command = onverwacht command 0x{ $command } while waiting for C-STORE-RSP
error-net-cget-unexpected-pdu = onverwacht PDU during C-GET C-STORE suboperation: { $pdu }
error-net-creating-incoming-dir = Storage SCP-.incoming-map aanmaken
error-net-creating-path = { $path } aanmaken
error-net-dataset-empty = gecodeerde dataset is leeg maar COMMAND_DATA_SET_TYPE vereist een dataset
error-net-dataset-odd-length = gecodeerde dataset eindigde met een fragment van oneven lengte
error-net-dimse-failed = { $operation } mislukt met status 0x{ $status } ({ $meaning }){ $hint }
error-net-establishing-assoc = Storage SCP-associatie tot stand brengen
error-net-file-meta-length = lezen File Meta Information length
error-net-file-meta-tag = lezen File Meta Information tag
error-net-file-meta-value = File Meta Information-waarde overslaan
error-net-file-meta-vr = lezen File Meta Information VR
error-net-file-position = lezen file position
error-net-flushing-path = { $path } flushen
error-net-flushing-temp-dataset = tijdelijk datasetbestand flushen
error-net-hint-suffix = ; aanwijzing: { $hint }
error-net-incomplete-command = onvolledig { $operation } command response
error-net-incomplete-identifier = onvolledig { $operation } response identifier
error-net-invalid-affected-sop = ongeldig { $operation } affected SOP class UID
error-net-invalid-status = ongeldig { $operation } status
error-net-listener-address = lezen storage SCP listener address
error-net-listener-nonblocking = listener in non-blocking modus zetten
error-net-listener-port = lezen storage SCP listener port
error-net-local-aes-empty = local_aes moet minstens één AE bevatten om Storage SCP te starten
error-net-locating-dataset = dataset zoeken in { $path }
error-net-malformed-dimse = malformed { $operation } DIMSE response: { $details }; hint: peer sent an ongeldig or onverwacht DIMSE command set
error-net-missing-affected-sop = ontbreekt { $operation } affected SOP class UID
error-net-missing-command-field = ontbreekt command field
error-net-missing-cstore-rsp-command-field = ontbreekt C-STORE response command field
error-net-missing-cstore-rsp-status = ontbreekt C-STORE response status
error-net-missing-destination = ontbreekt C-MOVE destination
error-net-missing-dicm = ontbreekt Part 10 DICM marker
error-net-missing-message-id = ontbreekt { $operation } message id
error-net-missing-qr-level = { $operation } identifier is ontbreekt QueryRetrieveLevel
error-net-missing-required-command-field = ontbreekt required command field { $name } ({ $tag })
error-net-missing-status = ontbreekt { $operation } status
error-net-move-destination-unresolved = move_destination is niet opgelost
error-net-no-cget-store-context = geen onderhandelde C-GET-opslag-presentation context voor SOP Class { $sop } en transfer syntax { $syntax }
error-net-no-compatible-context = { $path }: geen compatibele onderhandelde presentation context voor bron-transfer syntax { $syntax }
error-net-no-dimse-provider = geen DIMSE-provider geregistreerd voor commando 0x{ $command } en abstract syntax { $syntax }
error-net-no-presentation-context = geen onderhandelde presentation context
error-net-no-presentation-context-for-file = { $path }: geen onderhandelde presentation context
error-net-no-presentation-context-id = ontbreekt negotiated presentation context { $id }
error-net-opening-path = openen { $path }
error-net-part10-preamble = lezen Part 10 preamble
error-net-path-error = { $path }: { $err }
error-net-pdata-feed-complete = cannot feed P-DATA fragment into a complete accumulator (ontbreekt take())
error-net-peer-aborted = peer heeft de associatie afgebroken tijdens C-GET C-STORE-suboperatie: { $source }
error-net-peer-socket = lezen storage SCP peer socket address
error-net-reading-command-dataset = lezen command dataset
error-net-reading-identifier = lezen { $operation } identifier
error-net-reading-incoming-dataset = lezen incoming C-STORE dataset
error-net-reading-response-dataset = lezen { $operation } response dataset
error-net-remote-aborted = externe heeft de associatie afgebroken: { $source }
error-net-restoring-read-timeout = association-leestime-out herstellen
error-net-restoring-write-timeout = association-schrijftime-out herstellen
error-net-rewinding-dataset = terugspoelen naar het eerste dataset-element
error-net-scp-thread-panicked = Storage SCP-thread is in panic
error-net-seeking-temp-dataset = tijdelijk datasetbestand seeken
error-net-serializing-cget-dataset = C-GET-suboperatie-dataset serialiseren voor { $path }
error-net-serializing-dataset = dataset serialiseren voor { $path } met transfer syntax { $syntax }
error-net-setting-socket-blocking = geaccepteerde opslagsocket in blocking modus zetten
error-net-sending-buffered-dataset = gebufferde dataset verzenden voor { $path }
error-net-store-status = externe gaf C-STORE-status 0x{ $status } ({ $meaning }) terug{ $hint }
error-net-streaming-dataset = C-STORE-dataset streamen
error-net-unexpected-command-field = onverwacht CommandField 0x{ $actual } (expected 0x{ $expected } for { $rsp })
error-net-unexpected-dataset-fragment = onverwacht dataset fragment in C-STORE response
error-net-unexpected-pdu = onverwacht PDU during { $operation }: { $pdu }
error-net-unknown-status = ongeldig { $operation } status 0x{ $status }
error-net-unsupported-model-sop = niet ondersteund { $operation } model SOP class UID: { $uid }
error-net-unsupported-qr-level = niet ondersteund QueryRetrieveLevel: { $level }
error-net-unsupported-transfer-syntax = niet ondersteund negotiated transfer syntax
error-net-writing-command-dataset = schrijven command dataset
error-net-writing-identifier = schrijven { $operation } identifier
error-net-writing-path = schrijven { $path }
error-net-writing-response-dataset = schrijven { $operation } response dataset
error-net-writing-temp-dataset = schrijven dataset bytes to temp file
error-node-host-empty = knooppunt-host mag niet leeg zijn
error-node-name-empty = knooppuntnaam mag niet leeg zijn
error-node-not-found = extern knooppunt niet gevonden: { $id }
error-operation-cancelled = bewerking geannuleerd
error-port-invalid = ongeldige poort: { $value }
error-port-range = poort moet tussen 1 en 65535 liggen
error-query-no-study-uid = Match heeft geen StudyInstanceUID; retrieve onmogelijk.
error-query-unsupported-level = niet-ondersteund queryniveau: { $value }
error-query-unsupported-model = niet-ondersteund querymodel: { $value }
error-retrieve-canceled = retrieve geannuleerd door het externe knooppunt (status=0x{ $status }, completed={ $completed }, failed={ $failed }, warning={ $warning }, remaining={ $remaining }, { $scp })
error-retrieve-failed = retrieve mislukt met status=0x{ $status } (completed={ $completed }, failed={ $failed }, warning={ $warning }, remaining={ $remaining }, { $scp })
error-retrieve-nothing-arrived = retrieve voor bestemming { $destination } eindigde met completed={ $completed } maar er kwam niets aan bij de lokale Storage SCP ({ $scp }). Controleer AE-toewijzing of poort: { $listener } moet vrij zijn en het externe knooppunt moet AE { $destination } naar deze app mappen
error-send-no-files-series = geen lokale geïndexeerde bestanden voor serie { $uid }
error-send-no-files-study = geen lokale geïndexeerde bestanden voor studie { $uid }
error-task-cancelled = Taak geannuleerd
error-task-none-to-cancel = Geen actieve taak om te annuleren (er draait niets)
error-tracing-init = tracing subscriber initialiseren: { $err }
error-uid-component-numeric = UID-component '{ $part }' moet numeriek zijn
error-uid-component-too-long = UID-component '{ $part }' is te lang
error-uid-dot-ends = UID mag niet beginnen of eindigen met een punt
error-uid-empty = UID mag niet leeg zijn
error-uid-empty-component = UID mag geen lege componenten bevatten
error-uid-leading-zeros = UID-component '{ $part }' mag geen voorloopnullen hebben
error-uid-too-long = UID mag maximaal 64 tekens zijn

## TUI
tui-bool-no = nee
tui-bool-off = uit
tui-bool-on = aan
tui-bool-yes = ja
tui-command-placeholder = Typ een commando of gebruik paneelsneltoetsen.
tui-config-ae-title = AE title: { $value }
tui-config-edit-hint = Druk op Tab om dit venster te richten, daarna op 'c' om te bewerken.
tui-config-hint = Druk op Tab om dit venster te richten, daarna op 'c' om te bewerken.
tui-config-listener = Luisteraar: { $value }
tui-config-max-pdu = max_pdu_length: { $value }
tui-config-promiscuous = allow_promiscuous_storage: { $value }
tui-config-strict-pdu = strict_pdu: { $value }
tui-config-ts-pref = TS-voorkeur: { $value }
tui-controls-hint = Tab velden · Enter bevestigt · Esc annuleert
tui-detail-ae-title = AE Title
tui-detail-instance = Instantiedetail
tui-detail-name = Naam
tui-detail-node = Nodedetail
tui-detail-placeholder-followup = Verplaats de focus naar een lijstvenster en wijzig de selectie om deze weergave bij te werken.
tui-detail-query = Queryresultdetail
tui-detail-select-node = Selecteer een extern knooppunt om de metadata te bekijken.
tui-detail-series = Seriesdetail
tui-detail-study = Studydetail
tui-empty-command-placeholder = Typ een commando of gebruik paneelsneltoetsen.
tui-empty-detail-instance = Selecteer een instantie om te bekijken, of ga met Esc terug naar series.
tui-empty-detail-node = Selecteer een extern knooppunt om de metadata te bekijken.
tui-empty-detail-query = Selecteer een queryresultaat om metadata en retrieve-context te bekijken.
tui-empty-detail-series = Selecteer een serie om te bekijken, of ga met Esc terug naar studies.
tui-empty-detail-study = Selecteer een lokale studie om patiënt- en seriemetadata te bekijken.
tui-empty-instances = Er zijn geen geïndexeerde instanties voor deze series.
tui-empty-instances-hint = Druk op Esc om terug te gaan naar series.
tui-empty-local-instances = Er zijn geen geïndexeerde instanties voor deze series.
tui-empty-local-instances-hint = Druk op Esc om terug te gaan naar series.
tui-empty-local-series = Er zijn geen geïndexeerde series voor deze study.
tui-empty-local-series-hint = Druk op Esc om terug te gaan naar lokale studies.
tui-empty-local-studies = Er zijn nog geen geïndexeerde studies beschikbaar.
tui-empty-local-studies-cmd = Voorbeeld: import path=/data/inbox
tui-empty-local-studies-hint = Importeer eerst lokale DICOM-bestanden.
tui-empty-no-name = <geen naam>
tui-empty-query = Er is nog geen query uitgevoerd.
tui-empty-query-body =
    Selecteer een extern knooppunt en druk op 'f' om te zoeken.
    Of: query node=pacs
        patient_name="DOE^JOHN"
    Druk op 'm' op een geselecteerd resultaat om retrieve te openen.
tui-empty-query-cmd = Of: query node=pacs
tui-empty-query-hint = Selecteer een extern knooppunt en druk op 'f' om te zoeken.
tui-empty-query-last-target = Laatste querydoel: { $name }
tui-empty-query-none = Er is nog geen query uitgevoerd.
tui-empty-query-retrieve-hint = Druk op 'm' op een geselecteerd resultaat om retrieve te openen.
tui-empty-remote-nodes = Er zijn nog geen externe nodes opgeslagen.
tui-empty-remote-nodes-cmd = Of: node add name=pacs
tui-empty-remote-nodes-hint = Druk op 'a' in dit paneel om er een toe te voegen.
tui-empty-series = Er zijn geen geïndexeerde series voor deze study.
tui-empty-series-hint = Druk op Esc om terug te gaan naar lokale studies.
tui-empty-studies = Er zijn nog geen geïndexeerde studies beschikbaar.
tui-empty-studies-hint = Importeer eerst lokale DICOM-bestanden.
tui-empty-tasks-history = Geen taakgeschiedenis.
tui-empty-tasks-queued = Geen taken in de wachtrij.
tui-fallback-no-name = <geen naam>
tui-field-accession = Accession-nummer
tui-field-ae-title = AE title
tui-field-bind-addr = Bind-adres
tui-field-date-from = Datum van
tui-field-date-to = Datum tot
tui-field-destination-node = Bestemmingsnode
tui-field-host = hostnaam
tui-field-instance-uid = Instance UID
tui-field-kind = Soort
tui-field-level = Niveau
tui-field-local-ae = Lokale AE
tui-field-max-pdu = Max PDU
tui-field-modality = Modaliteit
tui-field-model = model
tui-field-move-destination = Move-bestemming
tui-field-name = Naam
tui-field-notes = Notities
tui-field-path = Pad
tui-field-patient-id = Patiënt-ID
tui-field-patient-name = Patiëntnaam
tui-field-port = Poort
tui-field-promiscuous = onbeperkt
tui-field-series-uid = Series UID
tui-field-sop-uid = SOP Instance UID
tui-field-strict-pdu = Strikte PDU
tui-field-study-description = Studybeschrijving
tui-field-study-uid = Study UID
tui-footer-back-series = Esc terug naar series
tui-footer-back-studies = Esc terug naar studies
tui-footer-cancel-task = c annuleren
tui-footer-edit-config = c config bewerken
tui-footer-enter-series = Enter series openen
tui-footer-esc-series = Esc terug naar series
tui-footer-esc-studies = Esc terug naar studies
tui-footer-help = F1/? hulp
tui-footer-inspect = Enter inspecteren
tui-footer-next = Volgende: { $text }
tui-footer-nodes = a/e/d/f knooppunten
tui-footer-panes = Tab panelen
tui-footer-queued =
    { $n ->
        [one] { $n } in wachtrij
       *[other] { $n } in wachtrij
    }
tui-footer-quit = q afsluiten
tui-footer-refresh = r vernieuwen
tui-footer-retrieve = m ophalen
tui-footer-run-command = Enter voer commando uit
tui-footer-task-scope = t wachtrij/geschiedenis
tui-form-add-node = Externe node toevoegen
tui-form-add-remote-node = Externe node toevoegen
tui-form-delete-confirm = Extern knooppunt { $name } [{ $ae }] op { $host }:{ $port } verwijderen?
tui-form-delete-node = Externe node verwijderen
tui-form-delete-remote-node = Externe node verwijderen
tui-form-edit-node = Externe node bewerken
tui-form-edit-remote-node = Externe node bewerken
tui-form-err-ae-required = ! AE title is verplicht
tui-form-err-bind-required = ! bind-adres is verplicht
tui-form-err-host-required = ! host is verplicht
tui-form-err-local-ae-invalid = ! ongeldige lokale AE title: { $err }
tui-form-err-local-ae-required = ! lokale AE title is verplicht
tui-form-err-modality-empty = modality mag niet leeg zijn
tui-form-err-move-dest-invalid = ! ongeldige move-bestemming AE title: { $err }
tui-form-err-name-required = ! knooppunt name is required
tui-form-err-port-required = ! poort is verplicht
tui-form-err-uid-empty = UID mag niet leeg zijn
tui-form-err-uid-empty-component = UID mag geen lege componenten bevatten
tui-form-error-line = Fout: { $error }
tui-form-field-accession = Accession-nummer
tui-form-field-ae-title = AE title
tui-form-field-bind-addr = Bind-adres
tui-form-field-date-from = Datum van
tui-form-field-date-to = Datum tot
tui-form-field-dest-node = Bestemmingsnode
tui-form-field-destination = Doel-AE
tui-form-field-host = hostnaam
tui-form-field-instance-uid = SOP Instance UID
tui-form-field-kind = Soort
tui-form-field-level = Niveau
tui-form-field-local-ae = Lokale AE
tui-form-field-modality = Modaliteit
tui-form-field-model = model
tui-form-field-move-dest = Move-bestemming
tui-form-field-name = Naam
tui-form-field-notes = Notities
tui-form-field-path = Pad
tui-form-field-patient-id = Patiënt-ID
tui-form-field-patient-name = Patiëntnaam
tui-form-field-port = Poort
tui-form-field-series-uid = Series Instance UID
tui-form-field-sop-uid = SOP Instance UID
tui-form-field-study-desc = Studybeschrijving
tui-form-field-study-uid = Study Instance UID
tui-form-field-uid = UID
tui-form-hint-bind = hint: meestal 0.0.0.0 (alle interfaces) of 127.0.0.1
tui-form-hint-local-ae = hint: tot 16 tekens (A-Z, 0-9, spatie), bijv. ARCHIVE_AE
tui-form-hint-move-dest = hint: optioneel; overschrijft de C-MOVE-bestemming AE title
tui-form-hint-name = hint: een kort label (bijv. PACS)
tui-form-import = Lokale bestanden importeren
tui-form-import-local = Lokale bestanden importeren
tui-form-import-local-files = Lokale bestanden importeren
tui-form-mode-add = create a new extern knooppunt
tui-form-mode-edit = update the selected extern knooppunt
tui-form-query-node = Externe node queryen
tui-form-query-remote-node = Externe node queryen
tui-form-remote-node-line = Extern knooppunt: { $name } [{ $ae }] { $host }:{ $port }
tui-form-retrieve = Matches ophalen
tui-form-retrieve-matches = Matches ophalen
tui-form-send-series = Series verzenden
tui-form-send-study = Study verzenden
tui-form-storage-intro = Lokale Storage SCP-instellingen bewerken (opgeslagen in config.json).
tui-form-storage-scp = Storage SCP-instellingen
tui-form-storage-scp-settings = Storage SCP-instellingen
tui-help-ae-title = AE title: { $value }
tui-help-aedf = a/e/d/f     Add, edit, delete, or query from the selected knooppunt
tui-help-c = c           Storage SCP-instellingen bewerken (als de focus op het Config-venster staat)
tui-help-canonical-names = Canonieke namen komen overeen met CLI-flags zonder '--', met underscores.
tui-help-close = Sluit help met Esc, F1 of ?.
tui-help-common-commands = Veelgebruikte commando's
tui-help-config = c           Storage SCP-instellingen bewerken (als de focus op het Config-venster staat)
tui-help-config-path = Configpad: { $value }
tui-help-current-config = Huidige configuratie
tui-help-data-dir = Datamap: { $value }
tui-help-enter-default = Enter       Run the command input, submit the active modal, or open series from Lokale studies
tui-help-enter-instance = Enter       Geen lokale-vensteractie in instantieweergave
tui-help-enter-local-instance = Enter       Geen lokale-vensteractie in instantieweergave
tui-help-enter-local-series = Enter       Instanties van de geselecteerde lokale serie openen, of opdrachtinvoer uitvoeren / actieve modal verzenden
tui-help-enter-local-study = Enter       Series van de geselecteerde lokale study openen, of opdrachtinvoer uitvoeren / actieve modal verzenden
tui-help-enter-series = Enter       Instanties van de geselecteerde lokale serie openen, of opdrachtinvoer uitvoeren / actieve modal verzenden
tui-help-enter-study = Enter       Series van de geselecteerde lokale study openen, of opdrachtinvoer uitvoeren / actieve modal verzenden
tui-help-esc-default = Esc         Help/modal sluiten, terug van lokale series, of focus terug naar opdrachtinvoer
tui-help-esc-instance = Esc         Terug van lokale instanties naar series, help/modal sluiten, of focus terug naar opdrachtinvoer
tui-help-esc-instances = Esc         Terug van lokale instanties naar series, help/modal sluiten, of focus terug naar opdrachtinvoer
tui-help-esc-series = Esc         Terug van lokale series naar studies, help/modal sluiten, of focus terug naar opdrachtinvoer
tui-help-f1 = F1 of ?     Help openen
tui-help-import-send = i/s         Importeren local files or send selected study/series
tui-help-is = i/s         Importeren local files or send selected study/series
tui-help-listener = Luisteraar: { $value }
tui-help-log-dir = Logmap: { $value }
tui-help-m = m           Ophalen vanaf het geselecteerde queryresultaat
tui-help-max-pdu = max_pdu_length: { $value }
tui-help-move = Omhoog/omlaag of j/k   Selectie in lijstvensters verplaatsen
tui-help-nodes = a/e/d/f     Add, edit, delete, or query from the selected knooppunt
tui-help-open = F1 of ?     Help openen
tui-help-promiscuous = allow_promiscuous_storage: { $value }
tui-help-q = q           Afsluiten als er geen modal actief is en de focus niet in de opdrachtinvoer staat
tui-help-quit = q           Afsluiten als er geen modal actief is en de focus niet in de opdrachtinvoer staat
tui-help-r = r           Vernieuwen panes when focus is neet in command input
tui-help-receiver-mode = Ontvangermodus: { $value }
tui-receiver-mode-on-demand = op aanvraag voor lokale retrieve
tui-receiver-mode-standalone = zelfstandig via storage-scp
tui-help-refresh = r           Vernieuwen panes when focus is neet in command input
tui-help-retrieve = m           Ophalen vanaf het geselecteerde queryresultaat
tui-help-strict-pdu = strict_pdu: { $value }
tui-help-tab = Tab / Shift-Tab  Gericht venster wisselen
tui-help-title = Sneltoetsen
tui-help-ts-pref = preferred_store_transfer_syntax: { $value }
tui-help-updown = Omhoog/omlaag of j/k   Selectie in lijstvensters verplaatsen
tui-input-placeholder = Typ een commando of gebruik paneelsneltoetsen.
tui-log-command = > { $command }
tui-log-error = fout: { $error }
tui-log-refreshed = vernieuwd
tui-logs-capped-suffix = beperkt
tui-logs-label = Logboeken:
tui-pane-command = Commando
tui-pane-config = configuratie
tui-pane-detail = detail
tui-pane-detail-hint = { $title } (PgUp/PgDn wanneer u niet typt)
tui-pane-help = helptekst
tui-pane-instance-detail = Instantiedetail
tui-pane-instances-for = Instanties van: { $uid }
tui-pane-local-studies = Lokale studies
tui-pane-logs = Logboeken ({ $shown }/{ $total }{ $capped })
tui-pane-logs-capped = Logboeken ({ $shown }/{ $total } capped)
tui-pane-logs-uncapped = Logboeken ({ $shown }/{ $total })
tui-pane-node-detail = Nodedetail
tui-pane-query-detail = Queryresultdetail
tui-pane-query-node = Knooppunt bevragen
tui-pane-query-result-detail = Queryresultdetail
tui-pane-query-results = Query-/retrieve-resultaten
tui-pane-query-retrieve-results = Query-/retrieve-resultaten
tui-pane-remote-nodes = Externe nodes
tui-pane-series-detail = Seriesdetail
tui-pane-series-for = Series van: { $uid }
tui-pane-series-unknown = Series van: <onbekende study>
tui-pane-study-detail = Studydetail
tui-pane-task-details = Taakdetail
tui-pane-tasks-history = Taken (geschiedenis)
tui-pane-tasks-queued = Taken (wachtrij)
tui-pane-unknown-series = <onbekende serie>
tui-pane-unknown-study = Series van: <onbekende study>
tui-row-inst = inst
tui-status-cancel-requested = Annulerenlation requested
tui-status-config = configuratie
tui-status-configured-listener = Geconfigureerde listener { $addr } als AE { $ae } ({ $mode })
tui-status-data = gegevens
tui-status-failure = mislukking: { $failure }
tui-status-listener = luisteraar
tui-status-local-ae = Lokale AE
tui-status-mode = Modus
tui-status-mode-on-demand = op aanvraag
tui-status-mode-standalone = zelfstandig
tui-status-no-active-task = Geen actieve taak to cancel (nothing running)
tui-status-pdu = PDU
tui-status-promiscuous = onbeperkt
tui-status-query-before-retrieve = Query a extern knooppunt first so retrieve knows which knooppunt to use
tui-status-query-failed = query mislukt: { $error }
tui-status-queued-op = Bewerking in wachtrij: { $op }
tui-status-retrieve-failed = ophalen mislukt: { $error }
tui-status-retrieve-open-failed = kon niet openen retrieve stream: { $error }
tui-status-saved-node = saved knooppunt { $name } ({ $id })
tui-status-saved-scp = Storage SCP-instellingen opgeslagen (herstart vereist)
tui-status-select-node = selecteer eerst een extern knooppunt
tui-status-select-query = selecteer eerst een queryresultaat
tui-status-select-study = selecteer eerst een lokale study
tui-status-strict = Strikt
tui-status-task-cancelled = Taak geannuleerd
tui-status-task-cancelled-detail = Taak geannuleerd: { $other }
tui-status-ts-pref = TS-voorkeur
tui-status-updated-node = updated knooppunt { $name } ({ $id })
tui-suggest-back-series = Esc — terug naar series
tui-suggest-edit-config = c — config bewerken
tui-suggest-help = F1/? — hulp
tui-suggest-inspect-task = Enter — taak inspecteren
tui-suggest-node-add = node add <ae-title> <host:port>
tui-suggest-query = f — query a knooppunt
tui-suggest-query-node = f — query selected knooppunt
tui-suggest-retrieve = m — selectie ophalen
tui-suggest-run-command = Enter — commando uitvoeren
tui-suggest-send-series = s — geselecteerde serie verzenden
tui-suggest-view-series = Enter — series bekijken
tui-task-cancelled = Geannuleerd
tui-task-cancelling = Annuleren
tui-task-failed = Mislukt
tui-task-failed-generic = Taak mislukt: { $error }
tui-task-import-done = Importeren complete: { $report }
tui-task-import-failed = Import mislukt: { $error }
tui-task-importing = Importeren van { $path }...
tui-task-query-done =
    Query voltooid: { $count ->
        [one] { $count } overeenkomst
       *[other] { $count } overeenkomsten
    }
tui-task-query-failed = Query mislukt: { $error }
tui-task-querying = Query naar { $node }...
tui-task-queued = In wachtrij
tui-task-retrieve-done = Ophalen voltooid: { $outcome }
tui-task-retrieve-failed = Retrieve mislukt: { $error }
tui-task-retrieving = Retrieve van { $node }...
tui-task-running = Actief
tui-task-sending-series = Series { $uid } verzenden naar { $node }...
tui-task-sending-study = Study { $uid } verzenden naar { $node }...
tui-task-send-done = Verzenden voltooid: { $outcome }
tui-task-status-cancelled = geannuleerd
tui-task-status-cancelling = annuleren
tui-task-status-failed = mislukt
tui-task-status-ok = ok
tui-task-status-queued = in wachtrij
tui-task-status-running = actief
tui-task-succeeded = Geslaagd
tui-terminal-too-small = Terminal te klein - wijzig het vensterformaat

## Desktop
desktop-action-activity = Activiteit { $count }
desktop-action-activity-empty = Activiteit
desktop-action-import = Importeren
desktop-action-inspect-archive = Lokale archief inspecteren
desktop-action-inspect-archive-desc = Bekijk studies, series en instanties; verzend of exporteer daarna.
desktop-action-manage-peers = Peers beheren
desktop-action-manage-peers-desc = Voeg PACS- of workstation-knooppunten toe en bewerk ze voor query, retrieve en store.
desktop-action-monitor-scp = Storage-SCP bewaken
desktop-action-query = bevraging
desktop-action-refresh = Status vernieuwen
desktop-action-refresh-status = Status vernieuwen
desktop-action-reveal-log = Logbestand tonen
desktop-action-send = Verzenden
desktop-action-start-scp = Storage-SCP starten
desktop-activity-empty = Nog geen sessieactiviteit.
desktop-activity-title = Activiteit
desktop-app-title = DICOM Node
desktop-archive-csv = CSV
desktop-archive-details = details
desktop-archive-empty = Het lokale archief is leeg.
desktop-archive-export-fail = Export { $scope } mislukt
desktop-archive-export-ok =
    { $rows ->
        [one] { $rows } { $scope }-rij geëxporteerd naar { $path }.
       *[other] { $rows } { $scope }-rijen geëxporteerd naar { $path }.
    }
desktop-archive-export-studies = Studies exporteren
desktop-archive-export-title = Exporteer { $scope }
desktop-archive-filter = Filteren op patiënt, UID, beschrijving, modaliteit…
desktop-archive-filter-placeholder = Filteren op patiënt, UID, beschrijving, modaliteit…
desktop-archive-inst-abbrev = { $count } inst.
desktop-archive-instance-meta = { $bytes } · TS { $ts } · geïmporteerd { $imported }
desktop-archive-instances = Instanties
desktop-archive-instances-heading = Instanties
desktop-archive-json = JSON
desktop-archive-loading = Studies laden…
desktop-archive-no-filter-match = Geen studies komen overeen met het filter.
desktop-archive-no-instances = Geen instanties gevonden.
desktop-archive-no-match = Geen studies komen overeen met het filter.
desktop-archive-no-nodes = Geen nodes
desktop-archive-no-series = Geen series gevonden.
desktop-archive-reveal-file = Bestand tonen
desktop-archive-select-series = Selecteer een series.
desktop-archive-select-study = Selecteer een study.
desktop-archive-send-fail = { $label }: { $sent }/{ $attempted } verzonden, { $failed } mislukt. { $failures }
desktop-archive-send-fail-title = { $label } mislukt
desktop-archive-send-ok = { $label }: { $sent }/{ $attempted } instanties verzonden.
desktop-archive-send-series = Series verzenden
desktop-archive-send-series-label = Serie → { $destination }
desktop-archive-send-study = Study verzenden
desktop-archive-send-study-label = Onderzoek → { $destination }
desktop-archive-send-to = Verzenden naar
desktop-archive-series = series
desktop-archive-series-count =
    #{ $number } · { $count ->
        [one] { $count } instantie
       *[other] { $count } instanties
    }
desktop-archive-series-fallback = series
desktop-archive-studies = onderzoeken
desktop-archive-study-date = Studydatum
desktop-archive-study-uid = Study UID
desktop-archive-subtitle = Inventaris van studies, series en instanties uit het lokale SQLite-archief.
desktop-archive-title = Lokaal archief
desktop-brand-title = DICOM Node
desktop-col-description = Beschrijving
desktop-col-instances = Instanties
desktop-col-modalities = Modaliteiten
desktop-col-patient-id = Patiënt-ID
desktop-common-cancel = Annuleren
desktop-common-clear = Wissen
desktop-common-disabled = uitgeschakeld
desktop-common-enabled = ingeschakeld
desktop-common-loading = Laden…
desktop-common-no = nee
desktop-common-refresh = Vernieuwen
desktop-common-yes = ja
desktop-counter-assoc-accepted = Geaccepteerde associaties
desktop-counter-bytes-ingested = Ingenomen bytes
desktop-counter-cfind-requests = C-FIND-verzoeken
desktop-counter-cmove-requests = C-MOVE-verzoeken
desktop-counter-cstore-failed = C-STORE mislukt
desktop-counter-cstore-stored = C-STORE opgeslagen
desktop-dashboard-counter-assoc-accepted = Geaccepteerde associaties
desktop-dashboard-counter-bytes-ingested = Ingenomen bytes
desktop-dashboard-counter-c-find-requests = C-FIND-verzoeken
desktop-dashboard-counter-c-move-requests = C-MOVE-verzoeken
desktop-dashboard-counter-c-store-failed = C-STORE mislukt
desktop-dashboard-counter-c-store-stored = C-STORE opgeslagen
desktop-dashboard-empty-studies = Nog geen lokale studies.
desktop-dashboard-inspect-archive-body = Bekijk studies, ga naar series en instanties, en verzend of exporteer.
desktop-dashboard-inspect-archive-title = Lokaal archief inspecteren
desktop-dashboard-kv-ae-title = AE-titel
desktop-dashboard-kv-data-dir = Gegevensmap
desktop-dashboard-kv-listener = luisteraar
desktop-dashboard-kv-log-file = Logbestand
desktop-dashboard-kv-max-pdu = Max. PDU
desktop-dashboard-kv-promiscuous = Promiscuous opslag
desktop-dashboard-kv-server = dienst
desktop-dashboard-kv-store-syntax = Store-syntax
desktop-dashboard-kv-strict-pdu = Strikte PDU
desktop-dashboard-listener-missing = Listener nog niet geladen.
desktop-dashboard-live-counters = Live-tellers
desktop-dashboard-loading-metrics = Metrieken laden…
desktop-dashboard-loading-status = Lokale status laden…
desktop-dashboard-loading-studies = Studies laden…
desktop-dashboard-local-node = Lokale node
desktop-dashboard-manage-peers-body = Voeg PACS- of werkstationnodes toe en bewerk ze voor query, retrieve en store.
desktop-dashboard-manage-peers-title = Peers beheren
desktop-dashboard-metric-instances = Instanties
desktop-dashboard-metric-nodes = Externe nodes
desktop-dashboard-metric-series = series
desktop-dashboard-metric-studies = onderzoeken
desktop-dashboard-monitor-scp = Storage SCP bewaken
desktop-dashboard-recent-studies = Recente studies
desktop-dashboard-start-scp = Storage SCP starten
desktop-dashboard-subtitle = Lokaal archief, netwerkpeers en SCP-activiteit in één oogopslag.
desktop-dashboard-title = Operator-dashboard
desktop-doc-title = DICOM Node
desktop-import-accepted = Geaccepteerd
desktop-import-accepted-bytes = Geaccepteerde bytes
desktop-import-activity-detail = { $accepted }/{ $scanned } geaccepteerd, { $duplicates } duplicaten, { $bytes }
desktop-import-activity-fail = Import mislukt
desktop-import-activity-ok = Import voltooid
desktop-import-choose-archive = Kies een ZIP-archief om te importeren
desktop-import-choose-dir = Kies een map om te importeren
desktop-import-choose-folder = Map
desktop-import-choose-zip = Kies een ZIP-archief om te importeren
desktop-import-cleanup = Opruimen
desktop-import-clear-path = Pad wissen
desktop-import-complete = Import voltooid
desktop-import-dup-sha = SHA-256
desktop-import-dup-sop = SOP UID
desktop-import-dup-total = Totaal
desktop-import-duplicates = Duplicaten
desktop-import-failed = Import mislukt
desktop-import-failed-cleanup = Opruimen mislukt
desktop-import-failures = Mislukkingen
desktop-import-failures-heading =
    { $count ->
        [one] { $count } mislukking:
       *[other] { $count } mislukkingen:
    }
desktop-import-failures-more = … en nog { $count }
desktop-import-files-progress = { $label } bestanden
desktop-import-folder = Map
desktop-import-invalid-dicom = Ongeldige DICOM
desktop-import-pick-dir = Kies een map om te importeren
desktop-import-pick-zip = Kies een ZIP-archief om te importeren
desktop-import-placeholder = /path/to/dicom-folder or /path/to/archive.zip
desktop-import-rejected = Afgewezen
desktop-import-report = Importrapport
desktop-import-running = Importeren…
desktop-import-scanned = Gescand
desktop-import-skipped = Overgeslagen
desktop-import-source = Bron
desktop-import-start = Import starten
desktop-import-stored = Opgeslagen
desktop-import-subtitle = Indexeer DICOM-bestanden uit recursieve mappen of ZIP-archieven in het beheerde lokale archief.
desktop-import-title = Importeren
desktop-import-unreadable = Onleesbaar
desktop-import-zip = ZIP
desktop-import-zip-filter = ZIP-archieven
desktop-lang-label = Taal
desktop-listener-not-loaded = Listener nog niet geladen.
desktop-live-counters = Live-tellers
desktop-loading = Laden
desktop-loading-local-status = Lokale status laden…
desktop-loading-metrics = Metrieken laden…
desktop-loading-studies = Studies laden…
desktop-local-node = Lokale node
desktop-locale-label = Taal
desktop-logs-activity-detail =
    { $count ->
        [one] { $count } regel geladen
       *[other] { $count } regels geladen
    }
desktop-logs-activity-fail = Logvernieuwing mislukt
desktop-logs-activity-ok = Log vernieuwd
desktop-logs-auto = AUTOMATISCH
desktop-logs-auto-refresh = Automatisch vernieuwen
desktop-logs-empty = Het logbestand is leeg.
desktop-logs-found = LOGBESTAND GEVONDEN
desktop-logs-lines =
    { $count ->
        [one] { $count } regel
       *[other] { $count } regels
    }
desktop-logs-loading = Log laden…
desktop-logs-missing = Het actieve logbestand is nog niet aangemaakt.
desktop-logs-refresh-failed = Logvernieuwing mislukt
desktop-logs-refreshed = Log vernieuwd
desktop-logs-reveal = Tonen
desktop-logs-subtitle = Begrensde staart van het actieve desktop-logbestand.
desktop-logs-tail = Staart
desktop-logs-title = Logboeken
desktop-logs-truncated = AFGEKAPT
desktop-logs-waiting = WACHTEN OP LOGBESTAND
desktop-metric-instances = Instanties
desktop-metric-remote-nodes = Externe nodes
desktop-metric-series = series
desktop-metric-studies = onderzoeken
desktop-nav-archive = Lokaal archief
desktop-nav-dashboard = Overzicht
desktop-nav-import = Importeren
desktop-nav-logs = Logboeken
desktop-nav-network = Netwerk
desktop-nav-nodes = Externe nodes
desktop-nav-query = Query / ophalen
desktop-nav-server = Storage-server
desktop-no-local-studies = Nog geen lokale studies.
desktop-nodes-add = Node toevoegen
desktop-nodes-added = Node "{ $name }" toegevoegd.
desktop-nodes-ae-length = AE-titel mag maximaal 16 tekens zijn.
desktop-nodes-ae-title = AE-titel
desktop-nodes-col-move = Move-best.
desktop-nodes-configured = Geconfigureerde nodes
desktop-nodes-confirm-delete = Node "{ $name }" verwijderen?
desktop-nodes-default-port = Standaardpoort 104
desktop-nodes-delete = Node verwijderen
desktop-nodes-delete-title = Node verwijderen
desktop-nodes-deleted = Node "{ $name }" verwijderd.
desktop-nodes-edit = Node bewerken
desktop-nodes-edit-title = Node bewerken
desktop-nodes-empty = Nog geen externe nodes.
desktop-nodes-err-ae = AE-titel is verplicht.
desktop-nodes-err-ae-len = AE-titel mag maximaal 16 tekens hebben.
desktop-nodes-err-host = Host is verplicht.
desktop-nodes-err-name = Naam is verplicht.
desktop-nodes-err-port = Poort moet tussen 1 en 65535 liggen.
desktop-nodes-host = hostnaam
desktop-nodes-move-dest = Move-bestemming
desktop-nodes-move-placeholder = Standaard: lokale AE
desktop-nodes-name = Naam
desktop-nodes-need-ae = AE-titel is verplicht.
desktop-nodes-need-host = Host is verplicht.
desktop-nodes-need-name = Naam is verplicht.
desktop-nodes-notes = Notities
desktop-nodes-notes-placeholder = Verslagkamer-PACS
desktop-nodes-placeholder-ae = PACS01
desktop-nodes-placeholder-host = 192.168.0.10
desktop-nodes-placeholder-move = Standaard: lokale AE
desktop-nodes-placeholder-name = main-pacs
desktop-nodes-placeholder-notes = Verslagkamer-PACS
desktop-nodes-port = Poort
desktop-nodes-port-104 = Standaardpoort 104
desktop-nodes-port-range = Poort moet tussen 1 en 65535 liggen.
desktop-nodes-save = Wijzigingen opslaan
desktop-nodes-save-changes = Wijzigingen opslaan
desktop-nodes-subtitle = PACS- en werkstationpeers voor query, retrieve en store.
desktop-nodes-summary = Node-overzicht
desktop-nodes-title = Externe nodes
desktop-nodes-total = Totaal nodes
desktop-nodes-updated = Node "{ $name }" bijgewerkt.
desktop-nodes-with-move = Met Move-bestemming
desktop-promiscuous = Promiscuous storage
desktop-query-accession = Accession nr.
desktop-query-activity-detail = { $count } { $count ->
        [one] match
       *[other] matches
    } op niveau { $level }
desktop-query-activity-fail = C-FIND { $node } mislukt
desktop-query-activity-ok = C-FIND { $node }
desktop-query-activity-title = C-FIND { $node }
desktop-query-clear = Wissen
desktop-query-col-accession = accessienummer
desktop-query-criteria = Zoekcriteria
desktop-query-date-from = Studydatum van
desktop-query-date-to = Studydatum tot
desktop-query-kv-series-uid = Series UID
desktop-query-kv-sop-uid = SOP UID
desktop-query-kv-study-uid = Study UID
desktop-query-level = Niveau
desktop-query-matches =
    { $count ->
        [one] { $count } match
       *[other] { $count } matches
    }
desktop-query-missing-study-uid = Match heeft geen StudyInstanceUID; ophalen onmogelijk.
desktop-query-modality = Modaliteit
desktop-query-no-matches = Geen matches.
desktop-query-no-nodes = Geen nodes geconfigureerd
desktop-query-patient-id = Patiënt-ID
desktop-query-patient-name = Patiëntnaam
desktop-query-placeholder-description = CHEST*
desktop-query-placeholder-modality = CT, MR, …
desktop-query-placeholder-name = DOE^JOHN or DOE*
desktop-query-placeholder-patient = DOE^JOHN or DOE*
desktop-query-querying = Bezig met query…
desktop-query-remote-node = Externe node
desktop-query-results = Resultaten
desktop-query-retrieve = Ophalen
desktop-query-retrieve-activity-detail = completed={ $completed }, warning={ $warning }, failed={ $failed }
desktop-query-retrieve-activity-fail = C-MOVE { $node } mislukt
desktop-query-retrieve-activity-ok = C-MOVE { $node }
desktop-query-retrieve-finished = Retrieve voltooid: voltooid { $completed }, waarschuwingen { $warning }, mislukt { $failed }.
desktop-query-retrieve-selected = Selectie ophalen
desktop-query-run = C-FIND uitvoeren
desktop-query-run-select = Voer een query uit en selecteer een match.
desktop-query-running = Bezig met query…
desktop-query-search-criteria = Zoekcriteria
desktop-query-select-hint = Voer een query uit en selecteer een match.
desktop-query-selected = Geselecteerde match
desktop-query-selected-match = Geselecteerde match
desktop-query-series-uid = Series Instance UID
desktop-query-sop-uid = SOP Instance UID
desktop-query-study-description = Studybeschrijving
desktop-query-study-uid = Study Instance UID
desktop-query-subtitle = C-FIND naar een externe node, inspecteer matches, daarna C-MOVE naar het lokale archief.
desktop-query-title = Query / ophalen
desktop-recent-studies = Recente studies
desktop-scp-listening = SCP luistert
desktop-scp-stopped = SCP gestopt
desktop-server-activity-fail = Storage-SCP-besturing mislukt
desktop-server-activity-started = Storage SCP gestart
desktop-server-activity-started-detail = Listener gestart.
desktop-server-activity-stopped = Storage SCP gestopt
desktop-server-activity-stopped-detail = received={ $received }, stored={ $stored }, failed={ $failed }
desktop-server-activity-stopped-empty = Geen actieve sessie.
desktop-server-addr-ae = { $addr } · AE { $ae }
desktop-server-assoc-accepted = Geaccepteerde associaties
desktop-server-assoc-rejected = Afgewezen associaties
desktop-server-cfind-req-matches = C-FIND-verzoeken / matches
desktop-server-cget-requests = C-GET-verzoeken
desktop-server-cmove-requests = C-MOVE-verzoeken
desktop-server-cmove-subops = C-MOVE-suboperaties voltooid / mislukt
desktop-server-control-failed = Storage-SCP-besturing mislukt
desktop-server-counter-bytes = Ingenomen bytes
desktop-server-counter-failed = C-STORE mislukt
desktop-server-counter-find = C-FIND-verzoeken / matches
desktop-server-counter-get = C-GET-verzoeken
desktop-server-counter-move = C-MOVE-verzoeken
desktop-server-counter-move-sub = C-MOVE-suboperaties voltooid / mislukt
desktop-server-counter-received = C-STORE ontvangen
desktop-server-counter-stored = C-STORE opgeslagen
desktop-server-cstore-failed = C-STORE mislukt
desktop-server-cstore-received = C-STORE ontvangen
desktop-server-cstore-stored = C-STORE opgeslagen
desktop-server-dimse = DIMSE-tellers
desktop-server-failed = Mislukt
desktop-server-health-loading = Metrieken laden
desktop-server-health-ready = Klaar voor inkomend C-STORE
desktop-server-health-review = Mislukkingen bekijken
desktop-server-health-stopped = Gestopt
desktop-server-listener-started = Listener gestart.
desktop-server-listening = LUISTERT
desktop-server-loading-metrics = Metrieken laden…
desktop-server-logs = Logboeken
desktop-server-no-session = Geen actieve sessie.
desktop-server-rate = +{ $rate } / peiling
desktop-server-ready = Klaar voor inkomend C-STORE
desktop-server-review-failures = Mislukkingen bekijken
desktop-server-session-ended = Sessie beëindigd: ontvangen { $received }, opgeslagen { $stored }, mislukt { $failed }.
desktop-server-start = Server starten
desktop-server-started-title = Storage SCP gestart
desktop-server-stop = Server stoppen
desktop-server-stopped = GESTOPT
desktop-server-stopped-pill = GESTOPT
desktop-server-stopped-status = Gestopt
desktop-server-stopped-title = Storage SCP gestopt
desktop-server-stored = Opgeslagen
desktop-server-subtitle = Zelfstandige Storage SCP voor inkomend C-STORE en lokale archiefindexering.
desktop-server-title = Storage-server
desktop-status-listening = luistert
desktop-status-loading = Laden
desktop-status-scp-listening = SCP luistert
desktop-status-scp-stopped = SCP gestopt
desktop-status-stopped = gestopt
desktop-store-syntax = Store-syntax
desktop-strict-pdu = Strikte PDU
desktop-strip-pdu = PDU { $value }
desktop-table-accession = Accessie
desktop-table-ae-title = AE-titel
desktop-table-date = Datum
desktop-table-description = Beschrijving
desktop-table-endpoint = Eindpunt
desktop-table-instances = Instanties
desktop-table-modalities = Modaliteiten
desktop-table-modality = Modaliteit
desktop-table-move-dest = Move-best.
desktop-table-name = Naam
desktop-table-notes = Notities
desktop-table-patient = Patiënt
desktop-table-patient-id = Patiënt-ID
desktop-table-series = series
desktop-table-updated = Bijgewerkt
desktop-title-refresh-status = Status vernieuwen
desktop-title-reveal-log = Logbestand tonen
ae = AE
patient-name =
    "DOE^JOHN"
    Druk op 'm' op een geselecteerd resultaat om retrieve te openen.
port = Poort

## Summary
summary-ae = AE
summary-counts = Aantallen
summary-criteria = criteria
summary-duration = Duur
summary-duration-ms = { $ms }ms
summary-failures = Mislukt:
summary-kind = Soort
summary-logs = Logboeken:
summary-peer = tegenhanger
summary-status = toestand
summary-title = Operatiesamenvatting
tui-detail-created = Aangemaakt

tui-form-hint-port-range = hint: een getal van 1 tot 65535, bijv. 104
tui-form-hint-promiscuous = hint: opslag van elk calling AE title toestaan
tui-form-hint-strict-pdu = hint: PDU-groottecontroles tijdens associaties afdwingen
tui-form-hint-max-pdu-bytes = hint: bytes, bijv. 16384
tui-form-limits-heading = Limits (bytes; blank/geen = unlimited):
tui-form-field-max-file-import = Max. bestandsimportbytes
tui-form-field-max-zip-entry = Max. ZIP-invoerbytes
tui-form-field-max-zip-total = Max. ZIP-totaalbytes
tui-form-field-max-zip-count = Max. aantal ZIP-invoeren
tui-form-field-max-store-object = Max. store-objectbytes
tui-form-unlimited = onbeperkt
tui-form-err-max-pdu-required = ! max. PDU-lengte is verplicht
tui-form-err-max-pdu-gt-zero = ! max. PDU-lengte moet een geheel getal groter dan 0 zijn
tui-form-err-limit-gt-zero = ! { $label } moet een geheel getal groter dan 0 zijn
tui-form-controls-scp = Typ om te bewerken. Spatie schakelt selectievakjes. Tab/Shift-Tab of Omhoog/Omlaag wisselt velden. Enter slaat op. Esc annuleert.
tui-form-submit-uid-required = UID is verplicht
tui-form-submit-dest-required = destination knooppunt is required
tui-form-submit-nonneg-int = { $label } moet een niet-negatief geheel getal zijn
tui-form-submit-gt-zero = { $label } moet groter zijn dan 0
tui-form-submit-local-ae-required = lokale AE title is verplicht
tui-form-submit-local-ae-invalid = lokale AE title is ongeldig: { $err }
tui-form-submit-bind-required = bind-adres is verplicht
tui-form-submit-port-required = poort is verplicht
tui-form-submit-max-pdu-required = max. PDU-lengte is verplicht
tui-form-submit-max-pdu-int = max. PDU-lengte moet een geheel getal zijn
tui-form-submit-max-pdu-gt-zero = max. PDU-lengte moet groter zijn dan 0
tui-form-submit-patient-retrieve = ophalen op patiëntniveau wordt niet ondersteund
tui-form-submit-no-study-uid = geselecteerd resultaat bevat geen study UID
tui-form-submit-date-format = verwacht YYYYMMDD
tui-form-submit-modality-len = modaliteit mag hoogstens 16 tekens zijn
tui-form-submit-modality-chars = modaliteit moet A-Z of 0-9 zijn
tui-form-submit-name-required = nodenaam is verplicht
tui-form-submit-ae-required = AE title is verplicht
tui-form-submit-host-required = host is verplicht
tui-form-submit-move-dest-invalid = move-bestemming AE title is ongeldig: { $err }
tui-form-submit-dates-both = datum vanaf en datum tot moeten beide zijn ingesteld, of geen van beide
tui-form-submit-date-from-invalid = datum vanaf is ongeldig: { $err }
tui-form-submit-date-to-invalid = datum tot is ongeldig: { $err }
tui-form-submit-date-order = datum vanaf moet op of vóór datum tot liggen
tui-form-submit-study-uid-series-query = study UID is verplicht voor query’s op serieniveau
tui-form-submit-study-uid-image-query = study UID is verplicht voor query’s op imageniveau
tui-form-submit-series-uid-image-query = series UID is verplicht voor query’s op imageniveau
tui-form-submit-study-uid-required = study UID is verplicht
tui-form-submit-study-uid-invalid = study UID is ongeldig: { $err }
tui-form-submit-series-uid-series-retrieve = series UID is verplicht voor ophalen op serieniveau
tui-form-submit-series-uid-image-retrieve = series UID is verplicht voor ophalen op imageniveau
tui-form-submit-instance-uid-image-retrieve = instance UID is verplicht voor ophalen op imageniveau
tui-form-submit-series-uid-invalid = series UID is ongeldig: { $err }
tui-form-submit-instance-uid-invalid = instance UID is ongeldig: { $err }
tui-form-submit-import-path-required = importpad is verplicht
tui-form-submit-import-path-type = importpad moet een bestand of map zijn: { $path }
tui-form-submit-import-access = toegang tot importpad { $path }
tui-form-submit-import-open = importbestand { $path } openen
tui-form-submit-import-read-dir = importdirectory { $path } lezen
tui-log-welcome = Press F1 or ? for help. Focus Extern knooppunts and press 'a' to add one.
tui-log-logging-to = Loggen naar { $path }
tui-command-help-heading = opdrachten:
tui-command-help-next-1 = opmerking: de voettekst toont contextuele 'Next:'-suggesties op basis van het actieve deelvenster en de selectie.
tui-command-help-next-2 = Het zijn alleen hints; u kunt altijd elk commando typen.
tui-command-help-canonical = opmerking: canonieke namen komen overeen met CLI-flags zonder '--', met underscores.
tui-command-help-cancel = annuleren (alias: stop)
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
tui-command-help-refresh = vernieuwen
tui-command-help-quit = afsluiten
tui-inspect-task = Taak #{ $id }
tui-inspect-status = Toestand: { $status }
tui-inspect-description = Beschrijving: { $description }
tui-inspect-progress = Voortgang: { $progress }
tui-inspect-summary = Samenvatting:
tui-inspect-no-logs = (geen logboeken)
tui-field-sop-class-uid = SOP Class UID
tui-field-transfer-syntax-uid = Transfer Syntax UID
tui-field-sha256 = SHA-256
tui-status-removed-nodes =
    verwijderd { $count ->
        [one] { $count } node
       *[other] { $count } nodes
    }
tui-status-removed-nodes-target =
    verwijderd { $count ->
        [one] { $count } node
       *[other] { $count } nodes
    }; laatste doel was { $name }
tui-status-more-failures =
    en { $n ->
        [one] { $n } fout weggelaten
       *[other] { $n } fouten weggelaten
    }
tui-status-retrieve-ok = retrieve status=0x{ $status } completed={ $completed } failed={ $failed } warning={ $warning } remaining={ $remaining }
tui-status-import-counts = scanned={ $scanned } accepted={ $accepted } duplicates={ $duplicates } unreadable={ $unreadable } invalid_dicom={ $invalid } rejected_total={ $rejected } stored_bytes={ $bytes }
tui-status-send-ok = send attempted={ $attempted } sent={ $sent } failed={ $failed }
tui-log-query-start = Query naar { $node } starten
tui-log-retrieve-start = Ophalen van { $node } starten
tui-log-import-start = Import van { $path } starten
tui-log-send-study-start = Verzenden van study { $uid } naar { $node } starten
tui-log-send-series-start = Verzenden van serie { $uid } naar { $node } starten
tui-log-cancelled-before-start = geannuleerd vóór de start
tui-log-cancelled = geannuleerd
error-unknown-command = onbekende opdracht: { $command }
error-node-subcommand-required = node-subcommand vereist
error-local-subcommand-required = local-subcommand vereist
error-unsupported-node-subcommand = unsupported knooppunt subcommand: { $command }
error-unsupported-local-subcommand = niet-ondersteund local-subcommand: { $command }
error-expected-kv = verwacht argument key=value, gekregen { $arg }
error-missing-required-arg = ontbrekend verplicht argument: { $key }
error-missing-required-arg-one-of = ontbrekend verplicht argument: een van { $keys }
error-parsing-command = commando parseren
error-edit-form-lost-target = edit form lost its target knooppunt
error-task-already-running = er draait al een achtergrondtaak
error-task-thread-launch = achtergrondtaakthread starten mislukt: { $error }
error-task-disconnected = achtergrondtaakthread verbroken voordat een resultaat werd verzonden
error-task-kind-missing = achtergrondtaakthread verbroken maar active_task_kind was None: onverwachte toestand
error-serve-exited = serve gestopt met fout: { $error }
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
summary-title = Operatiesamenvatting
summary-kind = Soort
summary-status = toestand
summary-duration = Duur
summary-duration-ms = { $ms }ms
summary-peer = tegenhanger
summary-ae = AE
summary-criteria = criteria
summary-counts = Aantallen
summary-failures = Mislukt:
summary-logs = Logboeken:
summary-unserializable = <niet serialiseerbaar>
summary-log-lines = regels { $start }-{ $end }
