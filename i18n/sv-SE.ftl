# Fluent catalog (sv-SE). Message IDs are hyphenated identifiers
# (cli-about, tui-pane-remote-nodes, desktop-nav-dashboard, error-import-file-too-large).
# Dotted names are Fluent attributes (message + .attr), not message IDs.
# Do not translate DICOM tokens (C-FIND, C-MOVE, C-STORE, SOP, AE, UID) or JSON/CSV machine keys.


## CLI
cli-about = Terminalfokuserad DICOM-nodklient byggd med dicom-rs
cli-arg-accession-number = Filtrera på accession number (delsträng, skiftlägesokänsligt).
cli-arg-ae-title = Application Entity title
cli-arg-destination-node = Målnodens namn eller id
cli-arg-duplicate = Filtrera på dubblettstatus.
cli-arg-export = Exportera resultat som JSON eller CSV.
cli-arg-host = Värdnamn eller IP
cli-arg-imported-at =
    Filtrera på importtidpunkt. Stöder VALUE, START..END, ..END, START...
    Jämförelsen är lexikografisk (rekommenderat format: RFC3339).
cli-arg-json = Skriv en slutlig operationssammanfattning som JSON (stabilt schema).
cli-arg-level = Fråga-/hämtningsnivå
cli-arg-metrics-json = Skriv ut den slutliga minnesögonblicksbilden av servermått som JSON när servern avslutas.
cli-arg-modality = Filtrera på modalitet. Kommaseparerad lista (t.ex. CT,MR).
cli-arg-model = Informationsmodell för fråga/hämtning
cli-arg-move-destination = Föredragen C-MOVE-destinations-AE title
cli-arg-name = Visningsnamn för noden
cli-arg-node = Sparat nodnamn eller id
cli-arg-notes = Fria anteckningar
cli-arg-out = Sökväg till utdatafil. Om den utelämnas skrivs till stdout.
cli-arg-path = Fil eller katalog att importera
cli-arg-patient-id = Filtrera på patient-ID (delsträng, skiftlägesokänsligt).
cli-arg-patient-name = Filtrera på patientnamn (delsträng, skiftlägesokänsligt).
cli-arg-port = portnummer
cli-arg-series-description = Filtrera på seriebeskrivning (delsträng, skiftlägesokänsligt).
cli-arg-series-instance-uid = Series Instance UID
cli-arg-sop-instance-uid = SOP Instance UID
cli-arg-source-path = Filtrera på källsökväg (delsträng, skiftlägesokänsligt).
cli-arg-study-date =
    Filtrera på undersökningsdatum. Stöder VALUE, START..END, ..END, START...
    Datum jämförs lexikografiskt (rekommenderat format: YYYYMMDD).
cli-arg-study-date-from = Undre gräns för undersökningsdatum (YYYYMMDD)
cli-arg-study-date-to = Övre gräns för undersökningsdatum (YYYYMMDD)
cli-arg-study-description = Filtrera på undersökningsbeskrivning (delsträng, skiftlägesokänsligt).
cli-arg-study-instance-uid = Study Instance UID
cli-cmd-import-about = Importera DICOM-filer från en sökväg
cli-cmd-local-about = Inspektera det lokala arkivet
cli-cmd-local-series-about = Lista indexerade serier för en undersökning
cli-cmd-local-studies-about = Lista indexerade lokala undersökningar
cli-cmd-node-about = Hantera sparade fjärr-DICOM-noder
cli-cmd-node-add-about = Lägg till en fjärrnod
cli-cmd-node-delete-about = Ta bort en sparad nod
cli-cmd-node-edit-about = Redigera en sparad nod
cli-cmd-node-list-about = Lista sparade noder
cli-cmd-query-about = Fråga en fjärrnod (C-FIND)
cli-cmd-retrieve-about = Hämta från en fjärrnod (C-MOVE)
cli-cmd-send-about = Skicka lokala undersökningar eller serier (C-STORE)
cli-cmd-send-series-about = Skicka en serie till en målnod
cli-cmd-send-study-about = Skicka en undersökning till en målnod
cli-cmd-serve-about = Kör DICOM-servern
cli-cmd-storage-scp-about = Kör en Storage SCP-lyssnare
cli-cmd-tui-about = Öppna det interaktiva terminalgränssnittet
cli-flag-help = Visa hjälpen
cli-flag-lang = Gränssnittsspråk (BCP-47-tagg). Åsidosätter DICOM_NODE_LANG, sparad locale och operativsystemets locale.
cli-flag-version = Visa versionen
cli-heading-arguments = Argument:
cli-heading-commands = Kommandon:
cli-heading-options = Alternativ:
cli-heading-usage = Användning:
cli-import-accepted = accepted={ $n }
cli-import-complete = Import klar
cli-import-duplicates = duplicates={ $n }
cli-import-scanned = scanned={ $n }
cli-msg-cancel-sigint = Avbrott begärt (SIGINT). Väntar på kontrollerad nedstängning...
cli-msg-failures = fel:
cli-msg-import-failed = Import misslyckades: { $error }
cli-msg-no-local-series = Inga indexerade serier för undersökning { $uid }
cli-msg-no-local-studies = Inga indexerade lokala undersökningar
cli-msg-no-saved-nodes = Inga sparade noder
cli-msg-query-failed = Fråga misslyckades: { $error }
cli-msg-removed-nodes =
    Tog bort { $count ->
        [one] { $count } nod
       *[other] { $count } noder
    }
cli-msg-results-count =
    Resultat: { $count ->
        [one] { $count } träff
       *[other] { $count } träffar
    }
cli-msg-retrieve-failed = Hämtning misslyckades: { $error }
cli-msg-saved-node = Sparade noden { $name } [{ $id }] => { $ae }@{ $host }:{ $port }
cli-msg-send-failed = Sändning misslyckades: { $error }
cli-msg-showing-failures = (visar de första { $shown } av { $total } fel)
cli-msg-starting-server =
    Startar DICOM-server med { $count ->
        [one] { $count } lokal AE
       *[other] { $count } lokala AE
    }: { $aes }
cli-msg-starting-server-no-aes = Startar DICOM-servern utan konfigurerade lokala AE:er
cli-msg-starting-storage-scp = Startar storage SCP på { $addr } med AE title { $ae }
cli-msg-updated-node = Uppdaterade noden { $name } [{ $id }] => { $ae }@{ $host }:{ $port }
cli-send-attempted = attempted={ $n }
cli-send-failed-count = failed={ $n }
cli-send-sent = sent={ $n }
cli-value-name-file = FILE
cli-value-name-format = FORMAT
cli-value-name-locale = LOCALE
cli-value-name-path = PATH
tui-detail-more-series =
    ... { $n ->
        [one] { $n } serie till
       *[other] { $n } serier till
    }
tui-row-instance-count =
    { $n ->
        [one] { $n } instans
       *[other] { $n } instanser
    }
tui-row-study-counts = { $series }s/{ $instances }i
count-nodes =
    { $n ->
        [one] { $n } nod
       *[other] { $n } noder
    }
count-instances =
    { $n ->
        [one] { $n } instans
       *[other] { $n } instanser
    }
count-series =
    { $n ->
        [one] { $n } serie
       *[other] { $n } serier
    }
count-studies =
    { $n ->
        [one] { $n } undersökning
       *[other] { $n } undersökningar
    }
format-datetime = { $date } { $time }
format-date = { $year }-{ $month }-{ $day }

## Common
common-accession = accessionsnr
common-add = Lägg till
common-back = Tillbaka
common-bytes = Byte
common-cancel = Avbryt
common-clear = Rensa
common-close = Stäng
common-date = Datum
common-delete = Ta bort nod
common-description = Beskrivning
common-disabled = inaktiverad
common-duplicates = Dubbletter
common-edit = Redigera
common-enabled = aktiverad
common-error = Fel
common-filter = filtrering
common-host = Värd
common-import = Importera
common-instance = Instans
common-language = Språk
common-loading = Laddar
common-matches = Träffar
common-modality = Modalitet
common-name = Namn
common-network = Nätverk
common-no = nej
common-none = ingen
common-notes = Anteckningar
common-optional = valfritt
common-path = Källa
common-patient = patient
common-patient-id = Patient-ID
common-patient-name = Patientnamn
common-port = portnummer
common-query = Fråga
common-refresh = Uppdatera
common-required = obligatoriskt
common-retrieve = Hämta
common-save = Spara
common-search = Sök
common-send = Skicka
common-series = Serier
common-start = Starta
common-status = tillstånd
common-stop = Stoppa
common-studies = Undersökningar
common-study = Undersökning
common-unknown = okänd
common-unknown-series = <Serier>
common-unknown-study = <Undersökningar>
common-yes = ja

## Errors
error-ae-empty = AE title får inte vara tom
error-ae-invalid-char = AE title innehåller ogiltigt tecken '{ $character }'; tillåtet: A-Z, 0-9, mellanslag
error-ae-required = AE title krävs
error-ae-too-long = AE title får vara högst 16 tecken
error-ae-whitespace = AE title får inte ha inledande eller avslutande blanksteg
error-archive-patient-retrieve-out-of-scope = retrieve på Patient-nivå ligger utanför omfattningen
error-archive-retrieve-uid-required = { $name } krävs för denna retrieve-nivå
error-archive-study-root-patient-query = Study Root-frågor stöder inte Patient-nivå
error-archive-study-root-patient-retrieve = Study Root-retrieve stöder inte Patient-nivå
error-assoc-negotiation-failed = associationsförhandling misslyckades med { $name } ({ $addr }); tips: kontrollera called AE title, presentation contexts/transfer syntaxes och att motparten accepterar associationer
error-assoc-no-addresses = inga socketadresser för { $name } på { $host }:{ $port }
error-assoc-receive = mottagning av association
error-assoc-resolving = slår upp { $name } på { $host }:{ $port }: { $err }
error-assoc-timeout = tidsgräns vid väntan på DIMSE-svar; tips: kontrollera nätverk, AE title/värd/port och motpartens svar
error-assoc-transport = transportavbrott vid väntan på DIMSE-svar; tips: motparten stängde anslutningen eller nätverksutrustning återställde den
error-assoc-unreachable = kunde inte nå { $name } [{ $ae }] på { $host }:{ $port } inom { $seconds }s: { $err }. Kontrollera värd/IP, port och nätverksåtkomst
error-cancel-sigint = Avbrott begärt (SIGINT). Väntar på kontrollerad avstängning...
error-config-must-be-positive = ogiltig config: { $name } måste vara > 0 (eller null för att inaktivera)
error-config-duplicate-bind-port = ogiltig config: duplicerad lokal AE-bindport { $port }
error-config-local-ae-max-assoc = ogiltig config: lokal AE { $title } max_concurrent_associations måste vara > 0
error-config-local-ae-no-services = ogiltig config: lokal AE { $title } måste aktivera minst en tjänst
error-config-must-be-positive-required = ogiltig config: { $name } måste vara > 0
error-dicom-meta-incomplete = DICOM-filmeta är ofullständig
error-dicom-patient-move-unsupported = C-MOVE på patientnivå stöds inte av den här klienten
error-dicom-required-attribute = obligatoriskt DICOM-attribut saknas: ({ $group },{ $element })
error-dicom-series-uid-required-image = series_instance_uid krävs för hämtning på bildnivå
error-dicom-series-uid-required-series = series_instance_uid krävs för hämtning på seriesnivå
error-dicom-sop-uid-required-image = sop_instance_uid krävs för hämtning på bildnivå
error-dicom-study-uid-required = study_instance_uid krävs
error-dicom-validating-move = validerar move-begäran
error-export-creating-file = skapar exportfil { $path }: { $err }
error-export-flushing-series-csv = spolar serie-CSV: { $err }
error-export-flushing-studies-csv = spolar studie-CSV: { $err }
error-export-serializing-series-json = serialiserar serie-JSON: { $err }
error-export-serializing-studies-json = serialiserar studie-JSON: { $err }
error-export-writing-series-csv-header = skriver CSV-huvud för serier: { $err }
error-export-writing-series-csv-row = skriver CSV-rad för serier: { $err }
error-export-writing-studies-csv-header = skriver CSV-huvud för studier: { $err }
error-export-writing-studies-csv-row = skriver CSV-rad för studier: { $err }
error-import-cleanup-failed = { $source }: rensning misslyckades: { $reason }
error-import-corrupt-zip = Skadad ZIP: { $details }
error-import-dicom-parse-failed = DICOM-parsning misslyckades: { $err }
error-import-dicom-validation-failed = DICOM-validering misslyckades: { $err }
error-import-duplicate-zip-path = Duplicerad ZIP-sökväg: { $details }
error-import-file-too-large = filen är för stor: { $details }
error-import-invalid-dicom = Ogiltig DICOM: { $details }
error-import-limit-exceeded = { $limit } överskreds: { $details }
error-import-not-regular-file = inte en vanlig fil
error-import-opening-file = öppnar fil: { $err }
error-import-opening-kind = öppnar { $kind } { $path }
error-import-opening-staged-file = öppnar mellanlagrad fil: { $err }
error-import-opening-zip-archive = öppnar ZIP-arkiv { $path }
error-import-opening-zip-entry = öppnar ZIP-post: { $err }
error-import-opening-zip-file = öppnar ZIP-importfil { $path }
error-import-path-does-not-exist = Importsökvägen finns inte: { $path }
error-import-reading-directory = läser importkatalog { $path }
error-import-reading-file = läser fil: { $err }
error-import-reading-file-metadata = läser filmetadata för { $path }
error-import-reading-metadata = läser metadata för { $kind } { $path }
error-import-reading-zip-entry = läser ZIP-post: { $err }
error-import-removing-staged-after-cancel = tar bort mellanlagrad fil efter avbrott { $path }
error-import-skipped = Överhoppad: { $details }
error-import-unreadable = Oläsbar fil: { $details }
error-import-unsafe-zip-path = Osäker ZIP-sökväg: { $details }
error-import-zip-entry-count-exceeded = gränsen för antal ZIP-poster överskreds: arkivet har { $count } poster, gränsen är { $limit }
error-import-zip-entry-size-exceeded = ZIP-postens storlek { $size } överskrider gränsen { $limit }
error-import-zip-total-bytes-exceeded = gränsen för totalt extraherade ZIP-byte överskreds: nuvarande totalt { $current } plus poststorlek { $entry } överskrider gränsen { $limit }
error-net-binding-storage-scp = binder Storage SCP på { $addr } för AE { $ae }. En annan lokal DICOM-mottagare kan redan använda den porten. Uppdatera storage_scp_port/local_aes i { $config } eller stoppa den konflikterande lyssnaren
error-net-building-file-meta = bygger file meta-tabell
error-net-cannot-send-transfer-syntax = käll-transfer syntax { $source } kan inte skickas med förhandlad { $negotiated }
error-net-cget-dataset-empty = kodad C-GET C-STORE-dataset är tom
error-net-cget-dataset-odd-length = kodad C-GET C-STORE-dataset slutade med ett fragment av udda längd
error-net-cget-peer-released = peern släppte associationen under C-GET
error-net-cget-store-unexpected-dataset = oväntad dataset fragment in C-GET C-STORE response
error-net-cget-unexpected-command = oväntad command 0x{ $command } while waiting for C-STORE-RSP
error-net-cget-unexpected-pdu = oväntad PDU during C-GET C-STORE suboperation: { $pdu }
error-net-creating-incoming-dir = skapar Storage SCP-.incoming-katalog
error-net-creating-path = skapar { $path }
error-net-dataset-empty = kodad dataset är tom men COMMAND_DATA_SET_TYPE anger att en dataset krävs
error-net-dataset-odd-length = kodad dataset slutade med ett fragment av udda längd
error-net-dimse-failed = { $operation } misslyckades med status 0x{ $status } ({ $meaning }){ $hint }
error-net-establishing-assoc = upprättar Storage SCP-association
error-net-file-meta-length = läser File Meta Information length
error-net-file-meta-tag = läser File Meta Information tag
error-net-file-meta-value = hoppar över File Meta Information-värde
error-net-file-meta-vr = läser File Meta Information VR
error-net-file-position = läser file position
error-net-flushing-path = spolar { $path }
error-net-flushing-temp-dataset = spolar temporär datasetfil
error-net-hint-suffix = ; tips: { $hint }
error-net-incomplete-command = ofullständig { $operation } command response
error-net-incomplete-identifier = ofullständig { $operation } response identifier
error-net-invalid-affected-sop = ogiltig { $operation } affected SOP class UID
error-net-invalid-status = ogiltig { $operation } status
error-net-listener-address = läser storage SCP listener address
error-net-listener-nonblocking = ställer in lyssnaren i icke-blockerande läge
error-net-listener-port = läser storage SCP listener port
error-net-local-aes-empty = local_aes måste innehålla minst en AE för att starta Storage SCP
error-net-locating-dataset = letar dataset i { $path }
error-net-malformed-dimse = malformed { $operation } DIMSE response: { $details }; tips: peer sent an ogiltig or oväntad DIMSE command set
error-net-missing-affected-sop = saknas { $operation } affected SOP class UID
error-net-missing-command-field = saknas command field
error-net-missing-cstore-rsp-command-field = saknas C-STORE response command field
error-net-missing-cstore-rsp-status = saknas C-STORE response status
error-net-missing-destination = saknas C-MOVE destination
error-net-missing-dicm = saknas Part 10 DICM marker
error-net-missing-message-id = saknas { $operation } message id
error-net-missing-qr-level = { $operation } identifier is saknas QueryRetrieveLevel
error-net-missing-required-command-field = saknas required command field { $name } ({ $tag })
error-net-missing-status = saknas { $operation } status
error-net-move-destination-unresolved = move_destination kunde inte lösas
error-net-no-cget-store-context = ingen förhandlad C-GET-lagrings-presentation context för SOP Class { $sop } och transfer syntax { $syntax }
error-net-no-compatible-context = { $path }: ingen kompatibel förhandlad presentation context för käll-transfer syntax { $syntax }
error-net-no-dimse-provider = ingen DIMSE-leverantör registrerad för kommando 0x{ $command } och abstract syntax { $syntax }
error-net-no-presentation-context = ingen förhandlad presentation context
error-net-no-presentation-context-for-file = { $path }: ingen förhandlad presentation context
error-net-no-presentation-context-id = saknas negotiated presentation context { $id }
error-net-opening-path = öppnar { $path }
error-net-part10-preamble = läser Part 10 preamble
error-net-path-error = { $path }: { $err }
error-net-pdata-feed-complete = cannot feed P-DATA fragment into a complete accumulator (saknas take())
error-net-peer-aborted = peern avbröt associationen under C-GET C-STORE-deloperation: { $source }
error-net-peer-socket = läser storage SCP peer socket address
error-net-reading-command-dataset = läser command dataset
error-net-reading-identifier = läser { $operation } identifier
error-net-reading-incoming-dataset = läser incoming C-STORE dataset
error-net-reading-response-dataset = läser { $operation } response dataset
error-net-remote-aborted = fjärrsidan avbröt associationen: { $source }
error-net-restoring-read-timeout = återställer association-lästimeout
error-net-restoring-write-timeout = återställer association-skrivtimeout
error-net-rewinding-dataset = spolar tillbaka till första dataset-elementet
error-net-scp-thread-panicked = Storage SCP-tråden panikade
error-net-seeking-temp-dataset = söker i temporär datasetfil
error-net-serializing-cget-dataset = serialiserar C-GET-deloperationsdataset för { $path }
error-net-serializing-dataset = serialiserar dataset för { $path } med transfer syntax { $syntax }
error-net-setting-socket-blocking = ställer in accepterad lagringssocket i blockerande läge
error-net-sending-buffered-dataset = skickar buffrad dataset för { $path }
error-net-store-status = fjärrsidan returnerade C-STORE-status 0x{ $status } ({ $meaning }){ $hint }
error-net-streaming-dataset = strömmar C-STORE-dataset
error-net-unexpected-command-field = oväntad CommandField 0x{ $actual } (expected 0x{ $expected } for { $rsp })
error-net-unexpected-dataset-fragment = oväntad dataset fragment in C-STORE response
error-net-unexpected-pdu = oväntad PDU during { $operation }: { $pdu }
error-net-unknown-status = ogiltig { $operation } status 0x{ $status }
error-net-unsupported-model-sop = stöds inte { $operation } model SOP class UID: { $uid }
error-net-unsupported-qr-level = stöds inte QueryRetrieveLevel: { $level }
error-net-unsupported-transfer-syntax = stöds inte negotiated transfer syntax
error-net-writing-command-dataset = skriver command dataset
error-net-writing-identifier = skriver { $operation } identifier
error-net-writing-path = skriver { $path }
error-net-writing-response-dataset = skriver { $operation } response dataset
error-net-writing-temp-dataset = skriver dataset bytes to temp file
error-node-host-empty = nodvärd får inte vara tom
error-node-name-empty = nodnamn får inte vara tomt
error-node-not-found = fjärrnod hittades inte: { $id }
error-operation-cancelled = åtgärden avbröts
error-port-invalid = ogiltig port: { $value }
error-port-range = porten måste vara mellan 1 och 65535
error-query-no-study-uid = Träffen saknar StudyInstanceUID; kan inte hämta.
error-query-unsupported-level = frågenivå stöds inte: { $value }
error-query-unsupported-model = frågemodell stöds inte: { $value }
error-retrieve-canceled = retrieve avbröts av fjärrnoden (status=0x{ $status }, completed={ $completed }, failed={ $failed }, warning={ $warning }, remaining={ $remaining }, { $scp })
error-retrieve-failed = retrieve misslyckades med status=0x{ $status } (completed={ $completed }, failed={ $failed }, warning={ $warning }, remaining={ $remaining }, { $scp })
error-retrieve-nothing-arrived = retrieve för destination { $destination } avslutades med completed={ $completed } men inget kom till lokal Storage SCP ({ $scp }). Kontrollera AE-mappning eller port: { $listener } måste vara ledigt och fjärrnoden måste mappa AE { $destination } till den här appen
error-send-no-files-series = inga lokala indexerade filer för serie { $uid }
error-send-no-files-study = inga lokala indexerade filer för studie { $uid }
error-task-cancelled = Uppgiften avbröts
error-task-none-to-cancel = Ingen aktiv uppgift att avbryta (ingenting körs)
error-tracing-init = initierar tracing-prenumerant: { $err }
error-uid-component-numeric = UID-komponenten '{ $part }' måste vara numerisk
error-uid-component-too-long = UID-komponenten '{ $part }' är för lång
error-uid-dot-ends = UID får inte börja eller sluta med en punkt
error-uid-empty = UID får inte vara tomt
error-uid-empty-component = UID får inte innehålla tomma komponenter
error-uid-leading-zeros = UID-komponenten '{ $part }' får inte ha inledande nollor
error-uid-too-long = UID får vara högst 64 tecken

## TUI
tui-bool-no = nej
tui-bool-off = av
tui-bool-on = på
tui-bool-yes = ja
tui-command-placeholder = Skriv ett kommando eller använd panelgenvägar.
tui-config-ae-title = AE-titel: { $value }
tui-config-edit-hint = Tryck på Tab för att fokusera den här panelen och sedan 'c' för att redigera.
tui-config-hint = Tryck på Tab för att fokusera den här panelen och sedan 'c' för att redigera.
tui-config-listener = Lyssnare: { $value }
tui-config-max-pdu = max_pdu_length: { $value }
tui-config-promiscuous = allow_promiscuous_storage: { $value }
tui-config-strict-pdu = strict_pdu: { $value }
tui-config-ts-pref = TS-preferens: { $value }
tui-controls-hint = Tab fält · Enter bekräftar · Esc avbryter
tui-detail-ae-title = AE-titel
tui-detail-instance = Instansdetalj
tui-detail-name = Namn
tui-detail-node = Noddetalj
tui-detail-placeholder-followup = Byt fokus till en listpanel och flytta urvalet för att uppdatera den här vyn.
tui-detail-query = Frågeresultatdetalj
tui-detail-select-node = Välj en fjärrnod för att granska dess metadata.
tui-detail-series = Seriedetalj
tui-detail-study = Undersökningsdetalj
tui-empty-command-placeholder = Skriv ett kommando eller använd panelgenvägar.
tui-empty-detail-instance = Välj en instans för att granska den, eller gå tillbaka till serier med Esc.
tui-empty-detail-node = Välj en fjärrnod för att granska dess metadata.
tui-empty-detail-query = Välj ett frågeresultat för att granska metadata och retrieve-kontext.
tui-empty-detail-series = Välj en serie för att granska den, eller gå tillbaka till undersökningar med Esc.
tui-empty-detail-study = Välj en lokal undersökning för att granska patient- och seriemetadata.
tui-empty-instances = Inga indexerade instanser finns för den här serien.
tui-empty-instances-hint = Tryck på Esc för att återgå till serier.
tui-empty-local-instances = Inga indexerade instanser finns för den här serien.
tui-empty-local-instances-hint = Tryck på Esc för att återgå till serier.
tui-empty-local-series = Inga indexerade serier finns för den här undersökningen.
tui-empty-local-series-hint = Tryck på Esc för att återgå till lokala undersökningar.
tui-empty-local-studies = Inga indexerade undersökningar finns ännu.
tui-empty-local-studies-cmd = Exempel: import path=/data/inbox
tui-empty-local-studies-hint = Importera lokala DICOM-filer först.
tui-empty-no-name = <inget namn>
tui-empty-query = Ingen fråga har körts ännu.
tui-empty-query-body =
    Välj en fjärrnod och tryck på 'f' för att fråga.
    Eller: query node=pacs
        patient_name="DOE^JOHN"
    Tryck på 'm' på ett valt resultat för att öppna retrieve.
tui-empty-query-cmd = Eller: query node=pacs
tui-empty-query-hint = Välj en fjärrnod och tryck på 'f' för att fråga.
tui-empty-query-last-target = Senaste frågemål: { $name }
tui-empty-query-none = Ingen fråga har körts ännu.
tui-empty-query-retrieve-hint = Tryck på 'm' på ett valt resultat för att öppna retrieve.
tui-empty-remote-nodes = Inga fjärrnoder är sparade ännu.
tui-empty-remote-nodes-cmd = Eller: node add name=pacs
tui-empty-remote-nodes-hint = Tryck på 'a' i den här panelen för att lägga till en.
tui-empty-series = Inga indexerade serier finns för den här undersökningen.
tui-empty-series-hint = Tryck på Esc för att återgå till lokala undersökningar.
tui-empty-studies = Inga indexerade undersökningar finns ännu.
tui-empty-studies-hint = Importera lokala DICOM-filer först.
tui-empty-tasks-history = Ingen uppgiftshistorik.
tui-empty-tasks-queued = Inga uppgifter i kön.
tui-fallback-no-name = <inget namn>
tui-field-accession = Accessionsnummer
tui-field-ae-title = AE-titel
tui-field-bind-addr = Bind-adress
tui-field-date-from = Datum från
tui-field-date-to = Datum till
tui-field-destination-node = Målnod
tui-field-host = Värd
tui-field-instance-uid = Instance UID
tui-field-kind = Typ
tui-field-level = Nivå
tui-field-local-ae = Lokal AE
tui-field-max-pdu = Max PDU
tui-field-modality = Modalitet
tui-field-model = Modell
tui-field-move-destination = Move-destination
tui-field-name = Namn
tui-field-notes = Anteckningar
tui-field-path = Sökväg
tui-field-patient-id = Patient-ID
tui-field-patient-name = Patientnamn
tui-field-port = portnummer
tui-field-promiscuous = Promiskuös
tui-field-series-uid = Series UID
tui-field-sop-uid = SOP Instance UID
tui-field-strict-pdu = Strikt PDU
tui-field-study-description = Undersökningsbeskrivning
tui-field-study-uid = Study UID
tui-footer-back-series = Esc tillbaka till serier
tui-footer-back-studies = Esc tillbaka till undersökningar
tui-footer-cancel-task = c avbryt
tui-footer-edit-config = c redigera config
tui-footer-enter-series = Enter serier
tui-footer-esc-series = Esc tillbaka till serier
tui-footer-esc-studies = Esc tillbaka till undersökningar
tui-footer-help = F1/? hjälp
tui-footer-inspect = Enter inspektera
tui-footer-next = Nästa: { $text }
tui-footer-nodes = a/e/d/f noder
tui-footer-panes = Tab paneler
tui-footer-queued =
    { $n ->
        [one] { $n } i kö
       *[other] { $n } i kö
    }
tui-footer-quit = q avsluta
tui-footer-refresh = r uppdatera
tui-footer-retrieve = m hämta
tui-footer-run-command = Enter kör kommando
tui-footer-task-scope = t kö/historik
tui-form-add-node = Lägg till fjärrnod
tui-form-add-remote-node = Lägg till fjärrnod
tui-form-delete-confirm = Ta bort fjärrnoden { $name } [{ $ae }] på { $host }:{ $port }?
tui-form-delete-node = Ta bort fjärrnod
tui-form-delete-remote-node = Ta bort fjärrnod
tui-form-edit-node = Redigera fjärrnod
tui-form-edit-remote-node = Redigera fjärrnod
tui-form-err-ae-required = ! AE title krävs
tui-form-err-bind-required = ! bind-adress krävs
tui-form-err-host-required = ! värd krävs
tui-form-err-local-ae-invalid = ! ogiltig lokal AE title: { $err }
tui-form-err-local-ae-required = ! lokal AE title krävs
tui-form-err-modality-empty = modalitet får inte vara tom
tui-form-err-move-dest-invalid = ! ogiltig Move-destinations-AE title: { $err }
tui-form-err-name-required = ! nodnamn krävs
tui-form-err-port-required = ! port krävs
tui-form-err-uid-empty = UID får inte vara tomt
tui-form-err-uid-empty-component = UID får inte innehålla tomma komponenter
tui-form-error-line = Fel: { $error }
tui-form-field-accession = Accessionsnummer
tui-form-field-ae-title = AE-titel
tui-form-field-bind-addr = Bind-adress
tui-form-field-date-from = Datum från
tui-form-field-date-to = Datum till
tui-form-field-dest-node = Målnod
tui-form-field-destination = Destinations-AE
tui-form-field-host = Värd
tui-form-field-instance-uid = SOP Instance UID
tui-form-field-kind = Typ
tui-form-field-level = Nivå
tui-form-field-local-ae = Lokal AE
tui-form-field-modality = Modalitet
tui-form-field-model = Modell
tui-form-field-move-dest = Move-destination
tui-form-field-name = Namn
tui-form-field-notes = Anteckningar
tui-form-field-path = Sökväg
tui-form-field-patient-id = Patient-ID
tui-form-field-patient-name = Patientnamn
tui-form-field-port = portnummer
tui-form-field-series-uid = Series Instance UID
tui-form-field-sop-uid = SOP Instance UID
tui-form-field-study-desc = Undersökningsbeskrivning
tui-form-field-study-uid = Study Instance UID
tui-form-field-uid = UID
tui-form-hint-bind = tips: vanligtvis 0.0.0.0 (alla gränssnitt) eller 127.0.0.1
tui-form-hint-local-ae = tips: högst 16 tecken (A-Z, 0-9, blanksteg), t.ex. ARCHIVE_AE
tui-form-hint-move-dest = tips: valfritt; åsidosätter destinationens AE title för C-MOVE
tui-form-hint-name = tips: en kort etikett (t.ex. PACS)
tui-form-import = Importera lokala filer
tui-form-import-local = Importera lokala filer
tui-form-import-local-files = Importera lokala filer
tui-form-mode-add = skapa en ny fjärrnod
tui-form-mode-edit = uppdatera den valda fjärrnoden
tui-form-query-node = Fråga fjärrnod
tui-form-query-remote-node = Fråga fjärrnod
tui-form-remote-node-line = Fjärrnod: { $name } [{ $ae }] { $host }:{ $port }
tui-form-retrieve = Hämta träffar
tui-form-retrieve-matches = Hämta träffar
tui-form-send-series = Skicka serie
tui-form-send-study = Skicka undersökning
tui-form-storage-intro = Redigera lokala Storage SCP-inställningar (sparas i config.json).
tui-form-storage-scp = Storage SCP-inställningar
tui-form-storage-scp-settings = Storage SCP-inställningar
tui-help-ae-title = AE-titel: { $value }
tui-help-aedf = a/e/d/f     Lägg till, redigera, ta bort eller fråga från den valda noden
tui-help-c = c           Redigera Storage SCP (när fokus är på Config-panelen)
tui-help-canonical-names = Kanoniska namn matchar CLI-flaggor utan '--', med understreck.
tui-help-close = Stäng hjälpen med Esc, F1 eller ?.
tui-help-common-commands = Vanliga kommandon
tui-help-config = c           Redigera Storage SCP (när fokus är på Config-panelen)
tui-help-config-path = Config-sökväg: { $value }
tui-help-current-config = Aktuell konfiguration
tui-help-data-dir = Datakatalog: { $value }
tui-help-enter-default = Enter       Kör kommandot, skicka in aktiv modal eller öppna serier från Lokala undersökningar
tui-help-enter-instance = Enter       Ingen åtgärd i Lokal-panelen i instansvyn
tui-help-enter-local-instance = Enter       Ingen åtgärd i Lokal-panelen i instansvyn
tui-help-enter-local-series = Enter       Öppna instanser för den valda lokala serien, eller kör kommandot / skicka in aktiv modal
tui-help-enter-local-study = Enter       Öppna serier för den valda lokala undersökningen, eller kör kommandot / skicka in aktiv modal
tui-help-enter-series = Enter       Öppna instanser för den valda lokala serien, eller kör kommandot / skicka in aktiv modal
tui-help-enter-study = Enter       Öppna serier för den valda lokala undersökningen, eller kör kommandot / skicka in aktiv modal
tui-help-esc-default = Esc         Stäng hjälp/modal, återgå från lokala serier eller återgå till kommandoraden
tui-help-esc-instance = Esc         Återgå från lokala instanser till serier, stäng hjälp/modal eller återgå till kommandoraden
tui-help-esc-instances = Esc         Återgå från lokala instanser till serier, stäng hjälp/modal eller återgå till kommandoraden
tui-help-esc-series = Esc         Återgå från lokala serier till undersökningar, stäng hjälp/modal eller återgå till kommandoraden
tui-help-f1 = F1 eller ?     Öppna hjälpen
tui-help-import-send = i/s         Importera lokala filer eller skicka vald undersökning/serie
tui-help-is = i/s         Importera lokala filer eller skicka vald undersökning/serie
tui-help-listener = Lyssnare: { $value }
tui-help-log-dir = Loggkatalog: { $value }
tui-help-m = m           Hämta från det valda frågeresultatet
tui-help-max-pdu = max_pdu_length: { $value }
tui-help-move = Up/Down eller j/k   Flytta urval i listpaneler
tui-help-nodes = a/e/d/f     Lägg till, redigera, ta bort eller fråga från den valda noden
tui-help-open = F1 eller ?     Öppna hjälpen
tui-help-promiscuous = allow_promiscuous_storage: { $value }
tui-help-q = q           Avsluta när ingen modal är aktiv och fokus inte är i kommandoraden
tui-help-quit = q           Avsluta när ingen modal är aktiv och fokus inte är i kommandoraden
tui-help-r = r           Uppdatera paneler när fokus inte är i kommandoraden
tui-help-receiver-mode = Mottagarläge: { $value }
tui-receiver-mode-on-demand = vid behov för lokal retrieve
tui-receiver-mode-standalone = fristående via storage-scp
tui-help-refresh = r           Uppdatera paneler när fokus inte är i kommandoraden
tui-help-retrieve = m           Hämta från det valda frågeresultatet
tui-help-strict-pdu = strict_pdu: { $value }
tui-help-tab = Tab / Shift-Tab  Byt fokuserad panel
tui-help-title = Tangentbindningar
tui-help-ts-pref = preferred_store_transfer_syntax: { $value }
tui-help-updown = Up/Down eller j/k   Flytta urval i listpaneler
tui-input-placeholder = Skriv ett kommando eller använd panelgenvägar.
tui-log-command = > { $command }
tui-log-error = fel: { $error }
tui-log-refreshed = uppdaterad
tui-logs-capped-suffix = begränsat
tui-logs-label = Loggar:
tui-pane-command = Kommando
tui-pane-config = Konfiguration
tui-pane-detail = Detalj
tui-pane-detail-hint = { $title } (PgUp/PgDn när du inte skriver)
tui-pane-help = Hjälp
tui-pane-instance-detail = Instansdetalj
tui-pane-instances-for = Instanser för: { $uid }
tui-pane-local-studies = Lokala undersökningar
tui-pane-logs = Loggar ({ $shown }/{ $total }{ $capped })
tui-pane-logs-capped = Loggar ({ $shown }/{ $total } capped)
tui-pane-logs-uncapped = Loggar ({ $shown }/{ $total })
tui-pane-node-detail = Noddetalj
tui-pane-query-detail = Frågeresultatdetalj
tui-pane-query-node = Fråga nod
tui-pane-query-result-detail = Frågeresultatdetalj
tui-pane-query-results = Fråga / Hämtning – resultat
tui-pane-query-retrieve-results = Fråga / Hämtning – resultat
tui-pane-remote-nodes = Fjärrnoder
tui-pane-series-detail = Seriedetalj
tui-pane-series-for = Serier för: { $uid }
tui-pane-series-unknown = Serier för: <okänd undersökning>
tui-pane-study-detail = Undersökningsdetalj
tui-pane-task-details = Uppgiftsdetalj
tui-pane-tasks-history = Uppgifter (historik)
tui-pane-tasks-queued = Uppgifter (kö)
tui-pane-unknown-series = <okänd serie>
tui-pane-unknown-study = Serier för: <okänd undersökning>
tui-row-inst = inst
tui-status-cancel-requested = Avbrytlation requested
tui-status-config = Konfiguration
tui-status-configured-listener = Konfigurerade lyssnare { $addr } som AE { $ae } ({ $mode })
tui-status-data = data
tui-status-failure = fel: { $failure }
tui-status-listener = Lyssnare
tui-status-local-ae = Lokal AE
tui-status-mode = Läge
tui-status-mode-on-demand = vid behov
tui-status-mode-standalone = fristående
tui-status-no-active-task = Ingen aktiv uppgift att avbryta (inget körs)
tui-status-pdu = PDU
tui-status-promiscuous = Promiskuös
tui-status-query-before-retrieve = Fråga en fjärrnod först så att hämtningen vet vilken nod som ska användas
tui-status-query-failed = fråga misslyckades: { $error }
tui-status-queued-op = Köad åtgärd: { $op }
tui-status-retrieve-failed = hämtning misslyckades: { $error }
tui-status-retrieve-open-failed = kunde inte öppna hämtningsström: { $error }
tui-status-saved-node = sparade nod { $name } ({ $id })
tui-status-saved-scp = Storage SCP-inställningar sparade (omstart krävs)
tui-status-select-node = välj en fjärrnod först
tui-status-select-query = välj ett frågeresultat först
tui-status-select-study = välj en lokal undersökning först
tui-status-strict = Strikt
tui-status-task-cancelled = Uppgiften avbröts
tui-status-task-cancelled-detail = Uppgiften avbröts: { $other }
tui-status-ts-pref = TS-pref
tui-status-updated-node = uppdaterade nod { $name } ({ $id })
tui-suggest-back-series = Esc — tillbaka till serier
tui-suggest-edit-config = c — redigera config
tui-suggest-help = F1/? — hjälp
tui-suggest-inspect-task = Enter — inspektera uppgift
tui-suggest-node-add = node add <ae-title> <host:port>
tui-suggest-query = f — fråga en nod
tui-suggest-query-node = f — fråga vald nod
tui-suggest-retrieve = m — hämta vald
tui-suggest-run-command = Enter — kör kommando
tui-suggest-send-series = s — skicka vald serie
tui-suggest-view-series = Enter — visa serier
tui-task-cancelled = Avbruten
tui-task-cancelling = Avbryter
tui-task-failed = Misslyckades
tui-task-failed-generic = Uppgift misslyckades: { $error }
tui-task-import-done = Importera complete: { $report }
tui-task-import-failed = Import misslyckades: { $error }
tui-task-importing = Importerar { $path }...
tui-task-query-done =
    Fråga klar: { $count ->
        [one] { $count } träff
       *[other] { $count } träffar
    }
tui-task-query-failed = Fråga misslyckades: { $error }
tui-task-querying = Frågar { $node }...
tui-task-queued = I kö
tui-task-retrieve-done = Hämtning klar: { $outcome }
tui-task-retrieve-failed = Hämtning misslyckades: { $error }
tui-task-retrieving = Hämtar från { $node }...
tui-task-running = Körs
tui-task-sending-series = Skickar serie { $uid } till { $node }...
tui-task-sending-study = Skickar undersökning { $uid } till { $node }...
tui-task-send-done = Sändning klar: { $outcome }
tui-task-status-cancelled = avbruten
tui-task-status-cancelling = avbryts
tui-task-status-failed = misslyckades
tui-task-status-ok = ok
tui-task-status-queued = i kö
tui-task-status-running = körs
tui-task-succeeded = Lyckades
tui-terminal-too-small = Terminalen är för liten – ändra storlek

## Desktop
desktop-action-activity = Aktivitet { $count }
desktop-action-activity-empty = Aktivitet
desktop-action-import = Importera
desktop-action-inspect-archive = Inspektera lokalt arkiv
desktop-action-inspect-archive-desc = Granska undersökningar, serier och instanser; skicka eller exportera sedan.
desktop-action-manage-peers = Hantera peers
desktop-action-manage-peers-desc = Lägg till och redigera PACS- eller arbetsstationsnoder för query, retrieve och store.
desktop-action-monitor-scp = Övervaka Storage SCP
desktop-action-query = Fråga
desktop-action-refresh = Uppdatera status
desktop-action-refresh-status = Uppdatera status
desktop-action-reveal-log = Visa loggfil
desktop-action-send = Skicka
desktop-action-start-scp = Starta Storage SCP
desktop-activity-empty = Ingen sessionsaktivitet ännu.
desktop-activity-title = Aktivitet
desktop-app-title = DICOM Node
desktop-archive-csv = CSV
desktop-archive-details = Detaljer
desktop-archive-empty = Det lokala arkivet är tomt.
desktop-archive-export-fail = Export { $scope } misslyckades
desktop-archive-export-ok =
    { $rows ->
        [one] Exporterade { $rows } { $scope }-rad till { $path }.
       *[other] Exporterade { $rows } { $scope }-rader till { $path }.
    }
desktop-archive-export-studies = Exportera undersökningar
desktop-archive-export-title = Exportera { $scope }
desktop-archive-filter = Filtrera efter patient, UID, beskrivning, modalitet…
desktop-archive-filter-placeholder = Filtrera efter patient, UID, beskrivning, modalitet…
desktop-archive-inst-abbrev = { $count } inst.
desktop-archive-instance-meta = { $bytes } · TS { $ts } · importerad { $imported }
desktop-archive-instances = Instanser
desktop-archive-instances-heading = Instanser
desktop-archive-json = JSON
desktop-archive-loading = Läser undersökningar…
desktop-archive-no-filter-match = Inga undersökningar matchar filtret.
desktop-archive-no-instances = Inga instanser hittades.
desktop-archive-no-match = Inga undersökningar matchar filtret.
desktop-archive-no-nodes = Inga noder
desktop-archive-no-series = Inga serier hittades.
desktop-archive-reveal-file = Visa fil
desktop-archive-select-series = Välj en serie.
desktop-archive-select-study = Välj en undersökning.
desktop-archive-send-fail = { $label }: { $sent }/{ $attempted } skickade, { $failed } misslyckades. { $failures }
desktop-archive-send-fail-title = { $label } misslyckades
desktop-archive-send-ok = { $label }: skickade { $sent }/{ $attempted } instanser.
desktop-archive-send-series = Skicka serie
desktop-archive-send-series-label = Serie → { $destination }
desktop-archive-send-study = Skicka undersökning
desktop-archive-send-study-label = Undersökning → { $destination }
desktop-archive-send-to = Skicka till
desktop-archive-series = Serier
desktop-archive-series-count =
    #{ $number } · { $count ->
        [one] { $count } instans
       *[other] { $count } instanser
    }
desktop-archive-series-fallback = Serier
desktop-archive-studies = Undersökningar
desktop-archive-study-date = Undersökningsdatum
desktop-archive-study-uid = Study UID
desktop-archive-subtitle = Inventering av undersökningar, serier och instanser från det lokala SQLite-arkivet.
desktop-archive-title = Lokalt arkiv
desktop-brand-title = DICOM Node
desktop-col-description = Beskrivning
desktop-col-instances = Instanser
desktop-col-modalities = Modaliteter
desktop-col-patient-id = Patient-ID
desktop-common-cancel = Avbryt
desktop-common-clear = Rensa
desktop-common-disabled = inaktiverad
desktop-common-enabled = aktiverad
desktop-common-loading = Laddar…
desktop-common-no = nej
desktop-common-refresh = Uppdatera
desktop-common-yes = ja
desktop-counter-assoc-accepted = Godkända associationer
desktop-counter-bytes-ingested = Intagna byte
desktop-counter-cfind-requests = C-FIND-begäranden
desktop-counter-cmove-requests = C-MOVE-begäranden
desktop-counter-cstore-failed = C-STORE misslyckade
desktop-counter-cstore-stored = C-STORE lagrade
desktop-dashboard-counter-assoc-accepted = Godkända associationer
desktop-dashboard-counter-bytes-ingested = Intagna byte
desktop-dashboard-counter-c-find-requests = C-FIND-begäranden
desktop-dashboard-counter-c-move-requests = C-MOVE-begäranden
desktop-dashboard-counter-c-store-failed = C-STORE misslyckade
desktop-dashboard-counter-c-store-stored = C-STORE lagrade
desktop-dashboard-empty-studies = Inga lokala undersökningar ännu.
desktop-dashboard-inspect-archive-body = Granska undersökningar, gå in i serier och instanser, skicka eller exportera sedan.
desktop-dashboard-inspect-archive-title = Inspektera lokalt arkiv
desktop-dashboard-kv-ae-title = AE-titel
desktop-dashboard-kv-data-dir = Datakatalog
desktop-dashboard-kv-listener = Lyssnare
desktop-dashboard-kv-log-file = Loggfil
desktop-dashboard-kv-max-pdu = Max PDU
desktop-dashboard-kv-promiscuous = Promiskuös lagring
desktop-dashboard-kv-server = tjänst
desktop-dashboard-kv-store-syntax = Store-syntax
desktop-dashboard-kv-strict-pdu = Strikt PDU
desktop-dashboard-listener-missing = Listener inte inläst ännu.
desktop-dashboard-live-counters = Live-räknare
desktop-dashboard-loading-metrics = Läser mätvärden…
desktop-dashboard-loading-status = Läser lokal status…
desktop-dashboard-loading-studies = Läser undersökningar…
desktop-dashboard-local-node = Lokal nod
desktop-dashboard-manage-peers-body = Lägg till och redigera PACS- eller arbetsstationsnoder för fråga, hämtning och store.
desktop-dashboard-manage-peers-title = Hantera peers
desktop-dashboard-metric-instances = Instanser
desktop-dashboard-metric-nodes = Fjärrnoder
desktop-dashboard-metric-series = Serier
desktop-dashboard-metric-studies = Undersökningar
desktop-dashboard-monitor-scp = Övervaka Storage SCP
desktop-dashboard-recent-studies = Senaste undersökningar
desktop-dashboard-start-scp = Starta Storage SCP
desktop-dashboard-subtitle = Lokalt arkiv, nätverkspeers och SCP-aktivitet i en vy.
desktop-dashboard-title = Operatörsöversikt
desktop-doc-title = DICOM Node
desktop-import-accepted = Godkända
desktop-import-accepted-bytes = Godkända byte
desktop-import-activity-detail = { $accepted }/{ $scanned } godkända, { $duplicates } dubbletter, { $bytes }
desktop-import-activity-fail = Import misslyckades
desktop-import-activity-ok = Import klar
desktop-import-choose-archive = Välj ett ZIP-arkiv att importera
desktop-import-choose-dir = Välj en katalog att importera
desktop-import-choose-folder = Mapp
desktop-import-choose-zip = Välj ett ZIP-arkiv att importera
desktop-import-cleanup = Städning
desktop-import-clear-path = Rensa sökväg
desktop-import-complete = Import klar
desktop-import-dup-sha = SHA-256
desktop-import-dup-sop = SOP UID
desktop-import-dup-total = Totalt
desktop-import-duplicates = Dubbletter
desktop-import-failed = Import misslyckades
desktop-import-failed-cleanup = Städning misslyckades
desktop-import-failures = Fel
desktop-import-failures-heading =
    { $count ->
        [one] { $count } fel:
       *[other] { $count } fel:
    }
desktop-import-failures-more = … och { $count } till
desktop-import-files-progress = { $label } filer
desktop-import-folder = Mapp
desktop-import-invalid-dicom = Ogiltig DICOM
desktop-import-pick-dir = Välj en katalog att importera
desktop-import-pick-zip = Välj ett ZIP-arkiv att importera
desktop-import-placeholder = /path/to/dicom-folder or /path/to/archive.zip
desktop-import-rejected = Avvisade
desktop-import-report = Importrapport
desktop-import-running = Importerar…
desktop-import-scanned = Skannade
desktop-import-skipped = Hoppad över
desktop-import-source = Källa
desktop-import-start = Starta import
desktop-import-stored = Lagrade
desktop-import-subtitle = Indexera DICOM-filer från rekursiva mappar eller ZIP-arkiv till det hanterade lokala arkivet.
desktop-import-title = Importera
desktop-import-unreadable = Oläsbar
desktop-import-zip = ZIP
desktop-import-zip-filter = ZIP-arkiv
desktop-lang-label = Språk
desktop-listener-not-loaded = Listener inte inläst ännu.
desktop-live-counters = Live-räknare
desktop-loading = Laddar
desktop-loading-local-status = Läser lokal status…
desktop-loading-metrics = Läser mätvärden…
desktop-loading-studies = Läser undersökningar…
desktop-local-node = Lokal nod
desktop-locale-label = Språk
desktop-logs-activity-detail =
    { $count ->
        [one] { $count } rad inläst
       *[other] { $count } rader inlästa
    }
desktop-logs-activity-fail = Logguppdatering misslyckades
desktop-logs-activity-ok = Logg uppdaterad
desktop-logs-auto = AUTOMATISK
desktop-logs-auto-refresh = Automatisk uppdatering
desktop-logs-empty = Loggfilen är tom.
desktop-logs-found = LOGGFIL HITTAD
desktop-logs-lines =
    { $count ->
        [one] { $count } rad
       *[other] { $count } rader
    }
desktop-logs-loading = Läser logg…
desktop-logs-missing = Den aktiva loggfilen har inte skapats ännu.
desktop-logs-refresh-failed = Logguppdatering misslyckades
desktop-logs-refreshed = Logg uppdaterad
desktop-logs-reveal = Visa
desktop-logs-subtitle = Begränsad svans av den aktiva skrivbordsloggfilen.
desktop-logs-tail = Svans
desktop-logs-title = Loggar
desktop-logs-truncated = KAPAD
desktop-logs-waiting = VÄNTAR PÅ LOGGFIL
desktop-metric-instances = Instanser
desktop-metric-remote-nodes = Fjärrnoder
desktop-metric-series = Serier
desktop-metric-studies = Undersökningar
desktop-nav-archive = Lokalt arkiv
desktop-nav-dashboard = Översikt
desktop-nav-import = Importera
desktop-nav-logs = Loggar
desktop-nav-network = Nätverk
desktop-nav-nodes = Fjärrnoder
desktop-nav-query = Fråga / hämta
desktop-nav-server = Lagringsserver
desktop-no-local-studies = Inga lokala undersökningar ännu.
desktop-nodes-add = Lägg till nod
desktop-nodes-added = Lade till noden "{ $name }".
desktop-nodes-ae-length = AE-titel får vara högst 16 tecken.
desktop-nodes-ae-title = AE-titel
desktop-nodes-col-move = Move-mål
desktop-nodes-configured = Konfigurerade noder
desktop-nodes-confirm-delete = Ta bort noden "{ $name }"?
desktop-nodes-default-port = Standardport 104
desktop-nodes-delete = Ta bort nod
desktop-nodes-delete-title = Ta bort nod
desktop-nodes-deleted = Tog bort noden "{ $name }".
desktop-nodes-edit = Redigera nod
desktop-nodes-edit-title = Redigera nod
desktop-nodes-empty = Inga fjärrnoder ännu.
desktop-nodes-err-ae = AE-titel krävs.
desktop-nodes-err-ae-len = AE-titel får vara högst 16 tecken.
desktop-nodes-err-host = Värd krävs.
desktop-nodes-err-name = Namn krävs.
desktop-nodes-err-port = Port måste vara 1–65535.
desktop-nodes-host = Värd
desktop-nodes-move-dest = Move-destination
desktop-nodes-move-placeholder = Standard: lokal AE
desktop-nodes-name = Namn
desktop-nodes-need-ae = AE-titel krävs.
desktop-nodes-need-host = Värd krävs.
desktop-nodes-need-name = Namn krävs.
desktop-nodes-notes = Anteckningar
desktop-nodes-notes-placeholder = Granskningsrums-PACS
desktop-nodes-placeholder-ae = PACS01
desktop-nodes-placeholder-host = 192.168.0.10
desktop-nodes-placeholder-move = Standard: lokal AE
desktop-nodes-placeholder-name = main-pacs
desktop-nodes-placeholder-notes = Granskningsrums-PACS
desktop-nodes-port = portnummer
desktop-nodes-port-104 = Standardport 104
desktop-nodes-port-range = Port måste vara 1–65535.
desktop-nodes-save = Spara ändringar
desktop-nodes-save-changes = Spara ändringar
desktop-nodes-subtitle = PACS- och arbetsstationspeers för fråga, hämtning och store.
desktop-nodes-summary = Nodöversikt
desktop-nodes-title = Fjärrnoder
desktop-nodes-total = Totalt antal noder
desktop-nodes-updated = Uppdaterade noden "{ $name }".
desktop-nodes-with-move = Med Move-destination
desktop-promiscuous = Promiskuös lagring
desktop-query-accession = Accession nr
desktop-query-activity-detail = { $count } { $count ->
        [one] träff
       *[other] träffar
    } på nivå { $level }
desktop-query-activity-fail = C-FIND { $node } misslyckades
desktop-query-activity-ok = C-FIND { $node }
desktop-query-activity-title = C-FIND { $node }
desktop-query-clear = Rensa
desktop-query-col-accession = accessionsnr
desktop-query-criteria = Sökkriterier
desktop-query-date-from = Undersökningsdatum från
desktop-query-date-to = Undersökningsdatum till
desktop-query-kv-series-uid = Series UID
desktop-query-kv-sop-uid = SOP UID
desktop-query-kv-study-uid = Study UID
desktop-query-level = Nivå
desktop-query-matches =
    { $count ->
        [one] { $count } träff
       *[other] { $count } träffar
    }
desktop-query-missing-study-uid = Träffen har ingen StudyInstanceUID; kan inte hämtas.
desktop-query-modality = Modalitet
desktop-query-no-matches = Inga träffar.
desktop-query-no-nodes = Inga noder konfigurerade
desktop-query-patient-id = Patient-ID
desktop-query-patient-name = Patientnamn
desktop-query-placeholder-description = CHEST*
desktop-query-placeholder-modality = CT, MR, …
desktop-query-placeholder-name = DOE^JOHN or DOE*
desktop-query-placeholder-patient = DOE^JOHN or DOE*
desktop-query-querying = Frågar…
desktop-query-remote-node = Fjärrnod
desktop-query-results = Resultat
desktop-query-retrieve = Hämta
desktop-query-retrieve-activity-detail = completed={ $completed }, warning={ $warning }, failed={ $failed }
desktop-query-retrieve-activity-fail = C-MOVE { $node } misslyckades
desktop-query-retrieve-activity-ok = C-MOVE { $node }
desktop-query-retrieve-finished = Hämtning klar: slutförda { $completed }, varningar { $warning }, misslyckade { $failed }.
desktop-query-retrieve-selected = Hämta valda
desktop-query-run = Kör C-FIND
desktop-query-run-select = Kör en fråga och välj en träff.
desktop-query-running = Frågar…
desktop-query-search-criteria = Sökkriterier
desktop-query-select-hint = Kör en fråga och välj en träff.
desktop-query-selected = Vald träff
desktop-query-selected-match = Vald träff
desktop-query-series-uid = Series Instance UID
desktop-query-sop-uid = SOP Instance UID
desktop-query-study-description = Undersökningsbeskrivning
desktop-query-study-uid = Study Instance UID
desktop-query-subtitle = C-FIND till en fjärrnod, granska träffar, sedan C-MOVE till det lokala arkivet.
desktop-query-title = Fråga / hämta
desktop-recent-studies = Senaste undersökningar
desktop-scp-listening = SCP lyssnar
desktop-scp-stopped = SCP stoppad
desktop-server-activity-fail = Storage-SCP-styrning misslyckades
desktop-server-activity-started = Storage SCP startad
desktop-server-activity-started-detail = Listener startad.
desktop-server-activity-stopped = Storage SCP stoppad
desktop-server-activity-stopped-detail = received={ $received }, stored={ $stored }, failed={ $failed }
desktop-server-activity-stopped-empty = Ingen aktiv session.
desktop-server-addr-ae = { $addr } · AE { $ae }
desktop-server-assoc-accepted = Godkända associationer
desktop-server-assoc-rejected = Avvisade associationer
desktop-server-cfind-req-matches = C-FIND-begäranden / träffar
desktop-server-cget-requests = C-GET-begäranden
desktop-server-cmove-requests = C-MOVE-begäranden
desktop-server-cmove-subops = C-MOVE-deloperationer slutförda / misslyckade
desktop-server-control-failed = Storage-SCP-styrning misslyckades
desktop-server-counter-bytes = Intagna byte
desktop-server-counter-failed = C-STORE misslyckade
desktop-server-counter-find = C-FIND-begäranden / träffar
desktop-server-counter-get = C-GET-begäranden
desktop-server-counter-move = C-MOVE-begäranden
desktop-server-counter-move-sub = C-MOVE-deloperationer slutförda / misslyckade
desktop-server-counter-received = C-STORE mottagna
desktop-server-counter-stored = C-STORE lagrade
desktop-server-cstore-failed = C-STORE misslyckade
desktop-server-cstore-received = C-STORE mottagna
desktop-server-cstore-stored = C-STORE lagrade
desktop-server-dimse = DIMSE-räknare
desktop-server-failed = Misslyckade
desktop-server-health-loading = Läser mätvärden
desktop-server-health-ready = Redo för inkommande C-STORE
desktop-server-health-review = Granska fel
desktop-server-health-stopped = Stoppad
desktop-server-listener-started = Listener startad.
desktop-server-listening = LYSSNAR
desktop-server-loading-metrics = Läser mätvärden…
desktop-server-logs = Loggar
desktop-server-no-session = Ingen aktiv session.
desktop-server-rate = +{ $rate } / avfrågning
desktop-server-ready = Redo för inkommande C-STORE
desktop-server-review-failures = Granska fel
desktop-server-session-ended = Session avslutad: mottagna { $received }, lagrade { $stored }, misslyckade { $failed }.
desktop-server-start = Starta server
desktop-server-started-title = Storage SCP startad
desktop-server-stop = Stoppa server
desktop-server-stopped = STOPPAD
desktop-server-stopped-pill = STOPPAD
desktop-server-stopped-status = Stoppad
desktop-server-stopped-title = Storage SCP stoppad
desktop-server-stored = Lagrade
desktop-server-subtitle = Fristående Storage SCP för inkommande C-STORE och lokal arkivindexering.
desktop-server-title = Lagringsserver
desktop-status-listening = lyssnar
desktop-status-loading = Laddar
desktop-status-scp-listening = SCP lyssnar
desktop-status-scp-stopped = SCP stoppad
desktop-status-stopped = stoppad
desktop-store-syntax = Store-syntax
desktop-strict-pdu = Strikt PDU
desktop-strip-pdu = PDU { $value }
desktop-table-accession = accessionsnr
desktop-table-ae-title = AE-titel
desktop-table-date = Datum
desktop-table-description = Beskrivning
desktop-table-endpoint = Slutpunkt
desktop-table-instances = Instanser
desktop-table-modalities = Modaliteter
desktop-table-modality = Modalitet
desktop-table-move-dest = Move-mål
desktop-table-name = Namn
desktop-table-notes = Anteckningar
desktop-table-patient = patient
desktop-table-patient-id = Patient-ID
desktop-table-series = Serier
desktop-table-updated = Uppdaterad
desktop-title-refresh-status = Uppdatera status
desktop-title-reveal-log = Visa loggfil
ae = AE
patient-name =
    "DOE^JOHN"
    Tryck på 'm' på ett valt resultat för att öppna retrieve.
port = portnummer

## Summary
summary-ae = AE
summary-counts = Antal
summary-criteria = Kriterier
summary-duration = Varaktighet
summary-duration-ms = { $ms }ms
summary-failures = Fel:
summary-kind = Typ
summary-logs = Loggar:
summary-peer = motpart
summary-status = tillstånd
summary-title = Åtgärdssammanfattning
tui-detail-created = Skapad

tui-form-hint-port-range = tips: ett tal från 1 till 65535, t.ex. 104
tui-form-hint-promiscuous = tips: tillåt lagring från valfri anropande AE title
tui-form-hint-strict-pdu = tips: tvinga PDU-storlekskontroller under associationer
tui-form-hint-max-pdu-bytes = tips: byte, t.ex. 16384
tui-form-limits-heading = Limits (bytes; blank/ingen = unlimited):
tui-form-field-max-file-import = Max filimportbyte
tui-form-field-max-zip-entry = Max ZIP-postbyte
tui-form-field-max-zip-total = Max ZIP-totalbyte
tui-form-field-max-zip-count = Max antal ZIP-poster
tui-form-field-max-store-object = Max lagringsobjektbyte
tui-form-unlimited = obegränsat
tui-form-err-max-pdu-required = ! max PDU-längd krävs
tui-form-err-max-pdu-gt-zero = ! max PDU-längd måste vara ett heltal större än 0
tui-form-err-limit-gt-zero = ! { $label } måste vara ett heltal större än 0
tui-form-controls-scp = Skriv för att redigera. Mellanslag växlar kryssrutor. Tab/Shift-Tab eller Upp/Ned byter fält. Enter sparar. Esc avbryter.
tui-form-submit-uid-required = UID krävs
tui-form-submit-dest-required = destination nod is required
tui-form-submit-nonneg-int = { $label } måste vara ett icke-negativt heltal
tui-form-submit-gt-zero = { $label } måste vara större än 0
tui-form-submit-local-ae-required = lokal AE title krävs
tui-form-submit-local-ae-invalid = lokal AE title är ogiltig: { $err }
tui-form-submit-bind-required = bind-adress krävs
tui-form-submit-port-required = port krävs
tui-form-submit-max-pdu-required = max PDU-längd krävs
tui-form-submit-max-pdu-int = max PDU-längd måste vara ett heltal
tui-form-submit-max-pdu-gt-zero = max PDU-längd måste vara större än 0
tui-form-submit-patient-retrieve = hämtning på patientnivå stöds inte
tui-form-submit-no-study-uid = markerat resultat saknar study UID
tui-form-submit-date-format = förväntat YYYYMMDD
tui-form-submit-modality-len = modalitet får vara högst 16 tecken
tui-form-submit-modality-chars = modalitet måste vara A-Z eller 0-9
tui-form-submit-name-required = nodnamn krävs
tui-form-submit-ae-required = AE title krävs
tui-form-submit-host-required = värd krävs
tui-form-submit-move-dest-invalid = flyttdestinations-AE title är ogiltig: { $err }
tui-form-submit-dates-both = datum från och datum till måste båda anges, eller inget
tui-form-submit-date-from-invalid = datum från är ogiltigt: { $err }
tui-form-submit-date-to-invalid = datum till är ogiltigt: { $err }
tui-form-submit-date-order = datum från måste vara samma dag eller före datum till
tui-form-submit-study-uid-series-query = study UID krävs för frågor på serienivå
tui-form-submit-study-uid-image-query = study UID krävs för frågor på bildenivå
tui-form-submit-series-uid-image-query = series UID krävs för frågor på bildenivå
tui-form-submit-study-uid-required = study UID krävs
tui-form-submit-study-uid-invalid = study UID är ogiltigt: { $err }
tui-form-submit-series-uid-series-retrieve = series UID krävs för hämtning på serienivå
tui-form-submit-series-uid-image-retrieve = series UID krävs för hämtning på bildenivå
tui-form-submit-instance-uid-image-retrieve = instance UID krävs för hämtning på bildenivå
tui-form-submit-series-uid-invalid = series UID är ogiltigt: { $err }
tui-form-submit-instance-uid-invalid = instance UID är ogiltigt: { $err }
tui-form-submit-import-path-required = importsökväg krävs
tui-form-submit-import-path-type = importsökväg måste vara en fil eller katalog: { $path }
tui-form-submit-import-access = åtkomst till importsökväg { $path }
tui-form-submit-import-open = öppnar importfil { $path }
tui-form-submit-import-read-dir = läser importkatalog { $path }
tui-log-welcome = Press F1 or ? for help. Focus Fjärrnods and press 'a' to add one.
tui-log-logging-to = Loggar till { $path }
tui-command-help-heading = kommandon:
tui-command-help-next-1 = obs: sidfoten visar kontextuella 'Next:'-förslag utifrån den fokuserade rutan och valet.
tui-command-help-next-2 = Det är bara tips; du kan alltid skriva vilket kommando som helst.
tui-command-help-canonical = obs: kanoniska namn matchar CLI-flaggor utan '--' och använder understreck.
tui-command-help-cancel = avbryt (alias: stop)
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
tui-command-help-refresh = uppdatera
tui-command-help-quit = avsluta
tui-inspect-task = Uppgift #{ $id }
tui-inspect-status = Tillstånd: { $status }
tui-inspect-description = Beskrivning: { $description }
tui-inspect-progress = Förlopp: { $progress }
tui-inspect-summary = Sammanfattning:
tui-inspect-no-logs = (inga loggar)
tui-field-sop-class-uid = SOP Class UID
tui-field-transfer-syntax-uid = Transfer Syntax UID
tui-field-sha256 = SHA-256
tui-status-removed-nodes =
    tog bort { $count ->
        [one] { $count } nod
       *[other] { $count } noder
    }
tui-status-removed-nodes-target =
    tog bort { $count ->
        [one] { $count } nod
       *[other] { $count } noder
    }; senaste målet var { $name }
tui-status-more-failures =
    och { $n ->
        [one] { $n } fel utelämnat
       *[other] { $n } fel utelämnade
    }
tui-status-retrieve-ok = retrieve status=0x{ $status } completed={ $completed } failed={ $failed } warning={ $warning } remaining={ $remaining }
tui-status-import-counts = scanned={ $scanned } accepted={ $accepted } duplicates={ $duplicates } unreadable={ $unreadable } invalid_dicom={ $invalid } rejected_total={ $rejected } stored_bytes={ $bytes }
tui-status-send-ok = send attempted={ $attempted } sent={ $sent } failed={ $failed }
tui-log-query-start = Startar fråga mot { $node }
tui-log-retrieve-start = Startar hämtning från { $node }
tui-log-import-start = Startar import av { $path }
tui-log-send-study-start = Startar sändning av studie { $uid } till { $node }
tui-log-send-series-start = Startar sändning av serie { $uid } till { $node }
tui-log-cancelled-before-start = avbruten före start
tui-log-cancelled = avbruten
error-unknown-command = okänt kommando: { $command }
error-node-subcommand-required = node-underkommando krävs
error-local-subcommand-required = local-underkommando krävs
error-unsupported-node-subcommand = unsupported nod subcommand: { $command }
error-unsupported-local-subcommand = local-underkommando stöds inte: { $command }
error-expected-kv = förväntade argumentet key=value, fick { $arg }
error-missing-required-arg = saknat obligatoriskt argument: { $key }
error-missing-required-arg-one-of = saknat obligatoriskt argument: en av { $keys }
error-parsing-command = tolkar kommando
error-edit-form-lost-target = edit form lost its target nod
error-task-already-running = en bakgrundsuppgift körs redan
error-task-thread-launch = kunde inte starta bakgrundsuppgiftens tråd: { $error }
error-task-disconnected = bakgrundsuppgiftens tråd kopplades från innan ett resultat skickades
error-task-kind-missing = bakgrundstråden kopplades från men active_task_kind var None: oväntat tillstånd
error-serve-exited = serve avslutades med fel: { $error }
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
summary-title = Åtgärdssammanfattning
summary-kind = Typ
summary-status = tillstånd
summary-duration = Varaktighet
summary-duration-ms = { $ms }ms
summary-peer = motpart
summary-ae = AE
summary-criteria = Kriterier
summary-counts = Antal
summary-failures = Fel:
summary-logs = Loggar:
summary-unserializable = <ej serialiserbar>
summary-log-lines = rader { $start }-{ $end }
