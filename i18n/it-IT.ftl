# Fluent catalog (it-IT). Message IDs are hyphenated identifiers
# (cli-about, tui-pane-remote-nodes, desktop-nav-dashboard, error-import-file-too-large).
# Dotted names are Fluent attributes (message + .attr), not message IDs.
# Do not translate DICOM tokens (C-FIND, C-MOVE, C-STORE, SOP, AE, UID) or JSON/CSV machine keys.


## CLI
cli-about = Client DICOM orientato al terminale, basato su dicom-rs
cli-arg-accession-number = Filtra per numero di accession (sottostringa, senza distinzione di maiuscole).
cli-arg-ae-title = Application Entity title
cli-arg-destination-node = Nome o id del nodo di destinazione
cli-arg-duplicate = Filtra per stato di duplicato.
cli-arg-export = Esporta i risultati come JSON o CSV.
cli-arg-host = Hostname o IP
cli-arg-imported-at =
    Filtra per istante di importazione. Accetta VALUE, START..END, ..END, START...
    Il confronto è lessicografico (formato consigliato: RFC3339).
cli-arg-json = Emette un riepilogo finale dell'operazione in JSON (schema stabile).
cli-arg-level = Livello di query/retrieve
cli-arg-metrics-json = Stampa lo snapshot finale delle metriche in memoria come JSON all'uscita del server.
cli-arg-modality = Filtra per modalità. Elenco separato da virgole (es. CT,MR).
cli-arg-model = Modello informativo di query/retrieve
cli-arg-move-destination = AE title di destinazione preferito per C-MOVE
cli-arg-name = Nome visualizzato del nodo
cli-arg-node = Nome o id del nodo salvato
cli-arg-notes = Note in forma libera
cli-arg-out = Percorso del file di output. Se omesso, scrive su stdout.
cli-arg-path = File o directory da importare
cli-arg-patient-id = Filtra per ID paziente (sottostringa, senza distinzione di maiuscole).
cli-arg-patient-name = Filtra per nome del paziente (sottostringa, senza distinzione di maiuscole).
cli-arg-port = Porta
cli-arg-series-description = Filtra per descrizione della serie (sottostringa, senza distinzione di maiuscole).
cli-arg-series-instance-uid = Series Instance UID
cli-arg-sop-instance-uid = SOP Instance UID
cli-arg-source-path = Filtra per percorso di origine (sottostringa, senza distinzione di maiuscole).
cli-arg-study-date =
    Filtra per data dello studio. Accetta VALUE, START..END, ..END, START...
    Il confronto è lessicografico (formato consigliato: YYYYMMDD).
cli-arg-study-date-from = Limite inferiore della data dello studio (YYYYMMDD)
cli-arg-study-date-to = Limite superiore della data dello studio (YYYYMMDD)
cli-arg-study-description = Filtra per descrizione dello studio (sottostringa, senza distinzione di maiuscole).
cli-arg-study-instance-uid = Study Instance UID
cli-cmd-import-about = Importa file DICOM da un percorso
cli-cmd-local-about = Ispeziona l'archivio locale
cli-cmd-local-series-about = Elenca le serie indicizzate di uno studio
cli-cmd-local-studies-about = Elenca gli studi locali indicizzati
cli-cmd-node-about = Gestisci i nodi DICOM remoti salvati
cli-cmd-node-add-about = Aggiungi un nodo remoto
cli-cmd-node-delete-about = Elimina un nodo salvato
cli-cmd-node-edit-about = Modifica un nodo salvato
cli-cmd-node-list-about = Elenca i nodi salvati
cli-cmd-query-about = Interroga un nodo remoto (C-FIND)
cli-cmd-retrieve-about = Recupera da un nodo remoto (C-MOVE)
cli-cmd-send-about = Invia studi o serie locali (C-STORE)
cli-cmd-send-series-about = Invia una serie a un nodo di destinazione
cli-cmd-send-study-about = Invia uno studio a un nodo di destinazione
cli-cmd-serve-about = Avvia il server DICOM
cli-cmd-storage-scp-about = Avvia un listener Storage SCP
cli-cmd-tui-about = Apri l'interfaccia interattiva nel terminale
cli-flag-help = Mostra l'aiuto
cli-flag-lang = Lingua dell'interfaccia (tag BCP-47). Sovrascrive DICOM_NODE_LANG, il locale persistito e il locale del sistema.
cli-flag-version = Mostra la versione
cli-heading-arguments = Argomenti:
cli-heading-commands = Comandi:
cli-heading-options = Opzioni:
cli-heading-usage = Uso:
cli-import-accepted = accepted={ $n }
cli-import-complete = Importazione completata
cli-import-duplicates = duplicates={ $n }
cli-import-scanned = scanned={ $n }
cli-msg-cancel-sigint = Annullamento richiesto (SIGINT). In attesa di arresto controllato...
cli-msg-failures = errori:
cli-msg-import-failed = Importazione non riuscita: { $error }
cli-msg-no-local-series = Nessuna serie indicizzata per lo studio { $uid }
cli-msg-no-local-studies = Nessuno studio locale indicizzato
cli-msg-no-saved-nodes = Nessun nodo salvato
cli-msg-query-failed = Query non riuscita: { $error }
cli-msg-removed-nodes =
    Rimosso { $count ->
        [one] { $count } nodo
       *[other] { $count } nodi
    }
cli-msg-results-count =
    Risultati: { $count ->
        [one] { $count } corrispondenza
       *[other] { $count } corrispondenze
    }
cli-msg-retrieve-failed = Retrieve non riuscito: { $error }
cli-msg-saved-node = Nodo salvato { $name } [{ $id }] => { $ae }@{ $host }:{ $port }
cli-msg-send-failed = Invio non riuscito: { $error }
cli-msg-showing-failures = (mostrati i primi { $shown } di { $total } errori)
cli-msg-starting-server =
    Avvio del server DICOM con { $count ->
        [one] { $count } AE locale
       *[other] { $count } AE locali
    }: { $aes }
cli-msg-starting-server-no-aes = Avvio del server DICOM senza AE locali configurati
cli-msg-starting-storage-scp = Avvio dello storage SCP su { $addr } con AE title { $ae }
cli-msg-updated-node = Nodo aggiornato { $name } [{ $id }] => { $ae }@{ $host }:{ $port }
cli-send-attempted = attempted={ $n }
cli-send-failed-count = failed={ $n }
cli-send-sent = sent={ $n }
cli-value-name-file = FILE
cli-value-name-format = FORMAT
cli-value-name-locale = LOCALE
cli-value-name-path = PATH
tui-detail-more-series =
    ... { $n ->
        [one] { $n } altra serie
       *[other] { $n } altre serie
    }
tui-row-instance-count =
    { $n ->
        [one] { $n } ist.
       *[other] { $n } ist.
    }
tui-row-study-counts = { $series }s/{ $instances }i
count-nodes =
    { $n ->
        [one] { $n } nodo
       *[other] { $n } nodi
    }
count-instances =
    { $n ->
        [one] { $n } istanza
       *[other] { $n } istanze
    }
count-series =
    { $n ->
        [one] { $n } serie
       *[other] { $n } serie
    }
count-studies =
    { $n ->
        [one] { $n } studio
       *[other] { $n } studi
    }
format-datetime = { $date } { $time }
format-date = { $day }/{ $month }/{ $year }

## Common
common-accession = Accesso
common-add = Aggiungi
common-back = Indietro
common-bytes = Byte
common-cancel = Annulla
common-clear = Cancella
common-close = Chiudi
common-date = Data
common-delete = Elimina nodo
common-description = Descrizione
common-disabled = disabilitato
common-duplicates = Duplicati
common-edit = Modifica
common-enabled = abilitato
common-error = Errore
common-filter = Filtro
common-host = host
common-import = Importa
common-instance = Istanza
common-language = Lingua
common-loading = Caricamento
common-matches = Corrispondenze
common-modality = Modalità
common-name = Nome
common-network = Rete
common-no = No
common-none = nessuno
common-notes = Note
common-optional = facoltativo
common-path = Origine
common-patient = Paziente
common-patient-id = ID paziente
common-patient-name = Nome paziente
common-port = Porta
common-query = Interroga
common-refresh = Aggiorna
common-required = obbligatorio
common-retrieve = Recupera
common-save = Salva
common-search = Cerca
common-send = Invia
common-series = Serie
common-start = Avvia
common-status = Stato
common-stop = Arresta
common-studies = Studi
common-study = Studio
common-unknown = sconosciuto
common-unknown-series = <Serie>
common-unknown-study = <Studi>
common-yes = sì

## Errors
error-ae-empty = l'AE title non può essere vuoto
error-ae-invalid-char = l'AE title contiene il carattere non valido '{ $character }'; consentiti: A-Z, 0-9, spazio
error-ae-required = l'AE title è obbligatorio
error-ae-too-long = l'AE title deve avere al massimo 16 caratteri
error-ae-whitespace = l'AE title non può avere spazi iniziali o finali
error-archive-patient-retrieve-out-of-scope = il retrieve a livello Patient è fuori ambito
error-archive-retrieve-uid-required = { $name } è obbligatorio per questo livello di retrieve
error-archive-study-root-patient-query = le query Study Root non supportano il livello Patient
error-archive-study-root-patient-retrieve = il retrieve Study Root non supporta il livello Patient
error-assoc-negotiation-failed = negoziazione dell'association non riuscita con { $name } ({ $addr }); suggerimento: verificare called AE title, presentation contexts/transfer syntaxes e che il peer accetti le association
error-assoc-no-addresses = nessun indirizzo socket risolto per { $name } su { $host }:{ $port }
error-assoc-receive = ricezione dell'association
error-assoc-resolving = risoluzione di { $name } su { $host }:{ $port }: { $err }
error-assoc-timeout = timeout in attesa della risposta DIMSE; suggerimento: verificare rete, AE title/host/porta e reattività del peer
error-assoc-transport = interruzione di trasporto in attesa della risposta DIMSE; suggerimento: il peer ha chiuso la connessione o un dispositivo di rete l'ha reimpostata
error-assoc-unreachable = impossibile raggiungere { $name } [{ $ae }] su { $host }:{ $port } entro { $seconds }s: { $err }. Verificare host/IP, porta e raggiungibilità di rete
error-cancel-sigint = Annullamento richiesto (SIGINT). In attesa di arresto controllato...
error-config-must-be-positive = configurazione non valida: { $name } deve essere > 0 (o null per disabilitare)
error-config-duplicate-bind-port = configurazione non valida: porta di bind AE locale duplicata { $port }
error-config-local-ae-max-assoc = configurazione non valida: AE locale { $title } max_concurrent_associations deve essere > 0
error-config-local-ae-no-services = configurazione non valida: AE locale { $title } deve abilitare almeno un servizio
error-config-must-be-positive-required = configurazione non valida: { $name } deve essere > 0
error-dicom-meta-incomplete = i meta del file DICOM sono incompleti
error-dicom-patient-move-unsupported = il C-MOVE a livello patient non è supportato da questo scaffold del client
error-dicom-required-attribute = attributo DICOM obbligatorio mancante: ({ $group },{ $element })
error-dicom-series-uid-required-image = series_instance_uid è obbligatorio per il retrieve a livello image
error-dicom-series-uid-required-series = series_instance_uid è obbligatorio per il retrieve a livello series
error-dicom-sop-uid-required-image = sop_instance_uid è obbligatorio per il retrieve a livello image
error-dicom-study-uid-required = study_instance_uid è obbligatorio
error-dicom-validating-move = convalida della richiesta di move
error-export-creating-file = creazione del file di esportazione { $path }: { $err }
error-export-flushing-series-csv = svuotamento del CSV delle serie: { $err }
error-export-flushing-studies-csv = svuotamento del CSV degli studi: { $err }
error-export-serializing-series-json = serializzazione JSON delle serie: { $err }
error-export-serializing-studies-json = serializzazione JSON degli studi: { $err }
error-export-writing-series-csv-header = scrittura dell'intestazione CSV delle serie: { $err }
error-export-writing-series-csv-row = scrittura della riga CSV delle serie: { $err }
error-export-writing-studies-csv-header = scrittura dell'intestazione CSV degli studi: { $err }
error-export-writing-studies-csv-row = scrittura della riga CSV degli studi: { $err }
error-import-cleanup-failed = { $source }: pulizia non riuscita: { $reason }
error-import-corrupt-zip = ZIP danneggiato: { $details }
error-import-dicom-parse-failed = analisi DICOM non riuscita: { $err }
error-import-dicom-validation-failed = validazione DICOM non riuscita: { $err }
error-import-duplicate-zip-path = Percorso ZIP duplicato: { $details }
error-import-file-too-large = file troppo grande: { $details }
error-import-invalid-dicom = DICOM non valido: { $details }
error-import-limit-exceeded = { $limit } superato: { $details }
error-import-not-regular-file = non è un file regolare
error-import-opening-file = apertura del file: { $err }
error-import-opening-kind = apertura di { $kind } { $path }
error-import-opening-staged-file = apertura del file in staging: { $err }
error-import-opening-zip-archive = apertura dell'archivio ZIP { $path }
error-import-opening-zip-entry = apertura della voce ZIP: { $err }
error-import-opening-zip-file = apertura del file ZIP di importazione { $path }
error-import-path-does-not-exist = Il percorso di importazione non esiste: { $path }
error-import-reading-directory = lettura della directory di importazione { $path }
error-import-reading-file = lettura del file: { $err }
error-import-reading-file-metadata = lettura dei metadati del file per { $path }
error-import-reading-metadata = lettura dei metadati per { $kind } { $path }
error-import-reading-zip-entry = lettura della voce ZIP: { $err }
error-import-removing-staged-after-cancel = rimozione del file in staging dopo l'annullamento { $path }
error-import-skipped = Saltato: { $details }
error-import-unreadable = File illeggibile: { $details }
error-import-unsafe-zip-path = Percorso ZIP non sicuro: { $details }
error-import-zip-entry-count-exceeded = limite di voci ZIP superato: l'archivio ha { $count } voci, il limite è { $limit }
error-import-zip-entry-size-exceeded = dimensione della voce ZIP { $size } supera il limite { $limit }
error-import-zip-total-bytes-exceeded = limite di byte estratti dallo ZIP superato: totale attuale { $current } più dimensione della voce { $entry } supera il limite { $limit }
error-net-binding-storage-scp = bind dello Storage SCP su { $addr } per AE { $ae }. Un altro ricevitore DICOM locale potrebbe già usare quella porta. Aggiorna storage_scp_port/local_aes in { $config } o ferma il listener in conflitto
error-net-building-file-meta = costruzione della tabella file meta
error-net-cannot-send-transfer-syntax = impossibile inviare la transfer syntax di origine { $source } con quella negoziata { $negotiated }
error-net-cget-dataset-empty = il dataset C-GET C-STORE codificato è vuoto
error-net-cget-dataset-odd-length = il dataset C-GET C-STORE codificato è terminato con un frammento di lunghezza dispari
error-net-cget-peer-released = il peer ha rilasciato l’associazione durante C-GET
error-net-cget-store-unexpected-dataset = imprevisto dataset fragment in C-GET C-STORE response
error-net-cget-unexpected-command = imprevisto command 0x{ $command } while waiting for C-STORE-RSP
error-net-cget-unexpected-pdu = imprevisto PDU during C-GET C-STORE suboperation: { $pdu }
error-net-creating-incoming-dir = creazione della directory .incoming dello Storage SCP
error-net-creating-path = creazione di { $path }
error-net-dataset-empty = il dataset codificato è vuoto ma COMMAND_DATA_SET_TYPE indica che è richiesto
error-net-dataset-odd-length = il dataset codificato è terminato con un frammento di lunghezza dispari
error-net-dimse-failed = { $operation } non riuscito con stato 0x{ $status } ({ $meaning }){ $hint }
error-net-establishing-assoc = stabilimento dell’associazione Storage SCP
error-net-file-meta-length = lettura File Meta Information length
error-net-file-meta-tag = lettura File Meta Information tag
error-net-file-meta-value = salto del valore File Meta Information
error-net-file-meta-vr = lettura File Meta Information VR
error-net-file-position = lettura file position
error-net-flushing-path = flush di { $path }
error-net-flushing-temp-dataset = flush del file dataset temporaneo
error-net-hint-suffix = ; suggerimento: { $hint }
error-net-incomplete-command = incompleto { $operation } command response
error-net-incomplete-identifier = incompleto { $operation } response identifier
error-net-invalid-affected-sop = non valido { $operation } affected SOP class UID
error-net-invalid-status = non valido { $operation } status
error-net-listener-address = lettura storage SCP listener address
error-net-listener-nonblocking = impostazione modalità non bloccante del listener
error-net-listener-port = lettura storage SCP listener port
error-net-local-aes-empty = local_aes deve contenere almeno un AE per avviare lo Storage SCP
error-net-locating-dataset = individuazione del dataset in { $path }
error-net-malformed-dimse = malformed { $operation } DIMSE response: { $details }; suggerimento: peer sent an non valido or imprevisto DIMSE command set
error-net-missing-affected-sop = mancante { $operation } affected SOP class UID
error-net-missing-command-field = mancante command field
error-net-missing-cstore-rsp-command-field = mancante C-STORE response command field
error-net-missing-cstore-rsp-status = mancante C-STORE response status
error-net-missing-destination = mancante C-MOVE destination
error-net-missing-dicm = mancante Part 10 DICM marker
error-net-missing-message-id = mancante { $operation } message id
error-net-missing-qr-level = { $operation } identifier is mancante QueryRetrieveLevel
error-net-missing-required-command-field = mancante required command field { $name } ({ $tag })
error-net-missing-status = mancante { $operation } status
error-net-move-destination-unresolved = move_destination non è stato risolto
error-net-no-cget-store-context = nessun presentation context di archiviazione C-GET negoziato per SOP Class { $sop } e transfer syntax { $syntax }
error-net-no-compatible-context = { $path }: nessun presentation context negoziato compatibile per la transfer syntax di origine { $syntax }
error-net-no-dimse-provider = nessun provider DIMSE registrato per il comando 0x{ $command } e abstract syntax { $syntax }
error-net-no-presentation-context = nessun presentation context negoziato
error-net-no-presentation-context-for-file = { $path }: nessun presentation context negoziato
error-net-no-presentation-context-id = mancante negotiated presentation context { $id }
error-net-opening-path = apertura { $path }
error-net-part10-preamble = lettura Part 10 preamble
error-net-path-error = { $path }: { $err }
error-net-pdata-feed-complete = cannot feed P-DATA fragment into a complete accumulator (mancante take())
error-net-peer-aborted = il peer ha interrotto l’associazione durante la sotto-operazione C-GET C-STORE: { $source }
error-net-peer-socket = lettura storage SCP peer socket address
error-net-reading-command-dataset = lettura command dataset
error-net-reading-identifier = lettura { $operation } identifier
error-net-reading-incoming-dataset = lettura incoming C-STORE dataset
error-net-reading-response-dataset = lettura { $operation } response dataset
error-net-remote-aborted = il remoto ha interrotto l’associazione: { $source }
error-net-restoring-read-timeout = ripristino del timeout di lettura dell'association
error-net-restoring-write-timeout = ripristino del timeout di scrittura dell'association
error-net-rewinding-dataset = riavvolgimento al primo elemento del dataset
error-net-scp-thread-panicked = il thread dello Storage SCP è andato in panic
error-net-seeking-temp-dataset = seek nel file dataset temporaneo
error-net-serializing-cget-dataset = serializzazione del dataset della sotto-operazione C-GET per { $path }
error-net-serializing-dataset = serializzazione del dataset di { $path } con transfer syntax { $syntax }
error-net-setting-socket-blocking = impostazione del socket di archiviazione accettato in modalità bloccante
error-net-sending-buffered-dataset = invio del dataset in buffer per { $path }
error-net-store-status = il remoto ha restituito lo stato C-STORE 0x{ $status } ({ $meaning }){ $hint }
error-net-streaming-dataset = streaming del dataset C-STORE
error-net-unexpected-command-field = imprevisto CommandField 0x{ $actual } (expected 0x{ $expected } for { $rsp })
error-net-unexpected-dataset-fragment = imprevisto dataset fragment in C-STORE response
error-net-unexpected-pdu = imprevisto PDU during { $operation }: { $pdu }
error-net-unknown-status = non valido { $operation } status 0x{ $status }
error-net-unsupported-model-sop = non supportato { $operation } model SOP class UID: { $uid }
error-net-unsupported-qr-level = non supportato QueryRetrieveLevel: { $level }
error-net-unsupported-transfer-syntax = non supportato negotiated transfer syntax
error-net-writing-command-dataset = scrittura command dataset
error-net-writing-identifier = scrittura { $operation } identifier
error-net-writing-path = scrittura { $path }
error-net-writing-response-dataset = scrittura { $operation } response dataset
error-net-writing-temp-dataset = scrittura dataset bytes to temp file
error-node-host-empty = l'host del nodo non può essere vuoto
error-node-name-empty = il nome del nodo non può essere vuoto
error-node-not-found = nodo remoto non trovato: { $id }
error-operation-cancelled = operazione annullata
error-port-invalid = porta non valida: { $value }
error-port-range = la porta deve essere compresa tra 1 e 65535
error-query-no-study-uid = Il match non ha StudyInstanceUID; retrieve impossibile.
error-query-unsupported-level = livello di query non supportato: { $value }
error-query-unsupported-model = modello di query non supportato: { $value }
error-retrieve-canceled = retrieve annullato dal nodo remoto (status=0x{ $status }, completed={ $completed }, failed={ $failed }, warning={ $warning }, remaining={ $remaining }, { $scp })
error-retrieve-failed = retrieve non riuscito con status=0x{ $status } (completed={ $completed }, failed={ $failed }, warning={ $warning }, remaining={ $remaining }, { $scp })
error-retrieve-nothing-arrived = retrieve terminato per la destinazione { $destination } con completed={ $completed } ma nulla è arrivato allo storage SCP locale ({ $scp }). Verificare mapping AE o configurazione della porta: assicurarsi che { $listener } sia libero e che il nodo remoto associ l'AE { $destination } a questa applicazione
error-send-no-files-series = nessun file locale indicizzato per la serie { $uid }
error-send-no-files-study = nessun file locale indicizzato per lo studio { $uid }
error-task-cancelled = Attività annullata
error-task-none-to-cancel = Nessuna attività attiva da annullare (nulla è in esecuzione)
error-tracing-init = inizializzazione del subscriber di tracing: { $err }
error-uid-component-numeric = il componente UID '{ $part }' deve essere numerico
error-uid-component-too-long = il componente UID '{ $part }' è troppo lungo
error-uid-dot-ends = l'UID non può iniziare o finire con un punto
error-uid-empty = l'UID non può essere vuoto
error-uid-empty-component = l'UID non può contenere componenti vuoti
error-uid-leading-zeros = il componente UID '{ $part }' non può avere zeri iniziali
error-uid-too-long = l'UID deve avere al massimo 64 caratteri

## TUI
tui-bool-no = No
tui-bool-off = spento
tui-bool-on = acceso
tui-bool-yes = sì
tui-command-placeholder = Digita un comando o usa le scorciatoie del riquadro.
tui-config-ae-title = AE title: { $value }
tui-config-edit-hint = Premi Tab per mettere a fuoco questo riquadro, poi 'c' per modificare.
tui-config-hint = Premi Tab per mettere a fuoco questo riquadro, poi 'c' per modificare.
tui-config-listener = Ascoltatore: { $value }
tui-config-max-pdu = max_pdu_length: { $value }
tui-config-promiscuous = allow_promiscuous_storage: { $value }
tui-config-strict-pdu = strict_pdu: { $value }
tui-config-ts-pref = Preferenza TS: { $value }
tui-controls-hint = Tab campi · Invio conferma · Esc annulla
tui-detail-ae-title = AE Title
tui-detail-instance = Dettaglio istanza
tui-detail-name = Nome
tui-detail-node = Dettaglio nodo
tui-detail-placeholder-followup = Sposta il focus su un riquadro elenco e cambia la selezione per aggiornare questa vista.
tui-detail-query = Dettaglio risultato query
tui-detail-select-node = Seleziona un nodo remoto per ispezionarne i metadati.
tui-detail-series = Dettaglio serie
tui-detail-study = Dettaglio studio
tui-empty-command-placeholder = Digita un comando o usa le scorciatoie del riquadro.
tui-empty-detail-instance = Seleziona un'istanza per ispezionarla, oppure torna alle serie con Esc.
tui-empty-detail-node = Seleziona un nodo remoto per ispezionarne i metadati.
tui-empty-detail-query = Seleziona un risultato di query per ispezionare metadati e contesto retrieve.
tui-empty-detail-series = Seleziona una serie per ispezionarla, oppure torna agli studi con Esc.
tui-empty-detail-study = Seleziona uno studio locale per ispezionare metadati di paziente e serie.
tui-empty-instances = Nessuna istanza indicizzata disponibile per questa serie.
tui-empty-instances-hint = Premi Esc per tornare alle serie.
tui-empty-local-instances = Nessuna istanza indicizzata disponibile per questa serie.
tui-empty-local-instances-hint = Premi Esc per tornare alle serie.
tui-empty-local-series = Nessuna serie indicizzata disponibile per questo studio.
tui-empty-local-series-hint = Premi Esc per tornare agli studi locali.
tui-empty-local-studies = Nessuno studio indicizzato disponibile.
tui-empty-local-studies-cmd = Esempio: import path=/data/inbox
tui-empty-local-studies-hint = Importa prima i file DICOM locali.
tui-empty-no-name = <nessun nome>
tui-empty-query = Nessuna query è stata ancora eseguita.
tui-empty-query-body =
    Seleziona un nodo remoto e premi 'f' per interrogare.
    Oppure: query node=pacs
        patient_name="DOE^JOHN"
    Premi 'm' su un risultato selezionato per aprire retrieve.
tui-empty-query-cmd = Oppure: query node=pacs
tui-empty-query-hint = Seleziona un nodo remoto e premi 'f' per interrogare.
tui-empty-query-last-target = Ultimo bersaglio della query: { $name }
tui-empty-query-none = Nessuna query è stata ancora eseguita.
tui-empty-query-retrieve-hint = Premi 'm' su un risultato selezionato per aprire retrieve.
tui-empty-remote-nodes = Nessun nodo remoto salvato.
tui-empty-remote-nodes-cmd = Oppure: node add name=pacs
tui-empty-remote-nodes-hint = Premi 'a' in questo riquadro per aggiungerne uno.
tui-empty-series = Nessuna serie indicizzata disponibile per questo studio.
tui-empty-series-hint = Premi Esc per tornare agli studi locali.
tui-empty-studies = Nessuno studio indicizzato disponibile.
tui-empty-studies-hint = Importa prima i file DICOM locali.
tui-empty-tasks-history = Nessuna cronologia delle attività.
tui-empty-tasks-queued = Nessuna attività in coda.
tui-fallback-no-name = <nessun nome>
tui-field-accession = Numero di accession
tui-field-ae-title = AE title
tui-field-bind-addr = Ind. di bind
tui-field-date-from = Data da
tui-field-date-to = Data a
tui-field-destination-node = Nodo di destinazione
tui-field-host = host
tui-field-instance-uid = Instance UID
tui-field-kind = Tipo
tui-field-level = Livello
tui-field-local-ae = AE locale
tui-field-max-pdu = Max PDU
tui-field-modality = Modalità
tui-field-model = Modello
tui-field-move-destination = Destinazione move
tui-field-name = Nome
tui-field-notes = Note
tui-field-path = Percorso
tui-field-patient-id = ID paziente
tui-field-patient-name = Nome paziente
tui-field-port = Porta
tui-field-promiscuous = Promiscuo
tui-field-series-uid = Series UID
tui-field-sop-uid = SOP Instance UID
tui-field-strict-pdu = PDU strict
tui-field-study-description = Descrizione studio
tui-field-study-uid = Study UID
tui-footer-back-series = Esc torna alle serie
tui-footer-back-studies = Esc torna agli studi
tui-footer-cancel-task = c annulla
tui-footer-edit-config = c modifica config
tui-footer-enter-series = Enter serie
tui-footer-esc-series = Esc torna alle serie
tui-footer-esc-studies = Esc torna agli studi
tui-footer-help = F1/? aiuto
tui-footer-inspect = Enter ispeziona
tui-footer-next = Avanti: { $text }
tui-footer-nodes = a/e/d/f nodi
tui-footer-panes = Tab riquadri
tui-footer-queued =
    { $n ->
        [one] { $n } in coda
       *[other] { $n } in coda
    }
tui-footer-quit = q esci
tui-footer-refresh = r aggiorna
tui-footer-retrieve = m recupera
tui-footer-run-command = Enter esegui comando
tui-footer-task-scope = t coda/cronologia
tui-form-add-node = Aggiungi nodo remoto
tui-form-add-remote-node = Aggiungi nodo remoto
tui-form-delete-confirm = Eliminare il nodo remoto { $name } [{ $ae }] in { $host }:{ $port }?
tui-form-delete-node = Elimina nodo remoto
tui-form-delete-remote-node = Elimina nodo remoto
tui-form-edit-node = Modifica nodo remoto
tui-form-edit-remote-node = Modifica nodo remoto
tui-form-err-ae-required = ! l’AE title è obbligatorio
tui-form-err-bind-required = ! l’indirizzo di bind è obbligatorio
tui-form-err-host-required = ! l’host è obbligatorio
tui-form-err-local-ae-invalid = ! AE title locale non valido: { $err }
tui-form-err-local-ae-required = ! l’AE title locale è obbligatorio
tui-form-err-modality-empty = modality non può essere vuoto
tui-form-err-move-dest-invalid = ! AE title di destinazione move non valido: { $err }
tui-form-err-name-required = ! nodo name is required
tui-form-err-port-required = ! la porta è obbligatoria
tui-form-err-uid-empty = l'UID non può essere vuoto
tui-form-err-uid-empty-component = l'UID non può contenere componenti vuoti
tui-form-error-line = Errore: { $error }
tui-form-field-accession = Numero di accession
tui-form-field-ae-title = AE title
tui-form-field-bind-addr = Indirizzo di bind
tui-form-field-date-from = Data da
tui-form-field-date-to = Data a
tui-form-field-dest-node = Nodo di destinazione
tui-form-field-destination = AE di destinazione
tui-form-field-host = host
tui-form-field-instance-uid = SOP Instance UID
tui-form-field-kind = Tipo
tui-form-field-level = Livello
tui-form-field-local-ae = AE locale
tui-form-field-modality = Modalità
tui-form-field-model = Modello
tui-form-field-move-dest = Destinazione move
tui-form-field-name = Nome
tui-form-field-notes = Note
tui-form-field-path = Percorso
tui-form-field-patient-id = ID paziente
tui-form-field-patient-name = Nome paziente
tui-form-field-port = Porta
tui-form-field-series-uid = Series Instance UID
tui-form-field-sop-uid = SOP Instance UID
tui-form-field-study-desc = Descrizione studio
tui-form-field-study-uid = Study Instance UID
tui-form-field-uid = UID
tui-form-hint-bind = suggerimento: di solito 0.0.0.0 (tutte le interfacce) o 127.0.0.1
tui-form-hint-local-ae = suggerimento: fino a 16 caratteri (A-Z, 0-9, spazio), es. ARCHIVE_AE
tui-form-hint-move-dest = suggerimento: facoltativo; sostituisce l’AE title di destinazione C-MOVE
tui-form-hint-name = suggerimento: un’etichetta breve (es. PACS)
tui-form-import = Importa file locali
tui-form-import-local = Importa file locali
tui-form-import-local-files = Importa file locali
tui-form-mode-add = create a new nodo remoto
tui-form-mode-edit = update the selected nodo remoto
tui-form-query-node = Query nodo remoto
tui-form-query-remote-node = Query nodo remoto
tui-form-remote-node-line = Nodo remoto: { $name } [{ $ae }] { $host }:{ $port }
tui-form-retrieve = Retrieve dei match
tui-form-retrieve-matches = Retrieve dei match
tui-form-send-series = Invia serie
tui-form-send-study = Invia studio
tui-form-storage-intro = Modifica le impostazioni locali dello Storage SCP (salvate in config.json).
tui-form-storage-scp = Impostazioni Storage SCP
tui-form-storage-scp-settings = Impostazioni Storage SCP
tui-help-ae-title = AE title: { $value }
tui-help-aedf = a/e/d/f     Add, edit, delete, or query from the selected nodo
tui-help-c = c           Modifica impostazioni Storage SCP (quando il focus è sul riquadro Config)
tui-help-canonical-names = I nomi canonici coincidono con i flag CLI senza '--', usando underscore.
tui-help-close = Chiudi l'aiuto con Esc, F1 o ?.
tui-help-common-commands = Comandi comuni
tui-help-config = c           Modifica impostazioni Storage SCP (quando il focus è sul riquadro Config)
tui-help-config-path = Percorso config: { $value }
tui-help-current-config = Configurazione attuale
tui-help-data-dir = Dir. dati: { $value }
tui-help-enter-default = Enter       Run the command input, submit the active modal, or open series from Studi locali
tui-help-enter-instance = Invio       Nessuna azione del riquadro locale in vista istanza
tui-help-enter-local-instance = Invio       Nessuna azione del riquadro locale in vista istanza
tui-help-enter-local-series = Invio       Apri le istanze della serie locale selezionata, o esegui l’input comandi / invia la modale attiva
tui-help-enter-local-study = Invio       Apri le serie dello studio locale selezionato, o esegui l’input comandi / invia la modale attiva
tui-help-enter-series = Invio       Apri le istanze della serie locale selezionata, o esegui l’input comandi / invia la modale attiva
tui-help-enter-study = Invio       Apri le serie dello studio locale selezionato, o esegui l’input comandi / invia la modale attiva
tui-help-esc-default = Esc         Chiudi guida/modale, torna dalle serie locali, o riporta il focus all’input comandi
tui-help-esc-instance = Esc         Torna dalle istanze locali alle serie, chiudi guida/modale, o riporta il focus all’input comandi
tui-help-esc-instances = Esc         Torna dalle istanze locali alle serie, chiudi guida/modale, o riporta il focus all’input comandi
tui-help-esc-series = Esc         Torna dalle serie locali agli studi, chiudi guida/modale, o riporta il focus all’input comandi
tui-help-f1 = F1 o ?     Apri guida
tui-help-import-send = i/s         Importa local files or send selected study/series
tui-help-is = i/s         Importa local files or send selected study/series
tui-help-listener = Ascoltatore: { $value }
tui-help-log-dir = Dir. log: { $value }
tui-help-m = m           Recupera dal risultato di query selezionato
tui-help-max-pdu = max_pdu_length: { $value }
tui-help-move = Su/Giù o j/k   Sposta selezione nei riquadri elenco
tui-help-nodes = a/e/d/f     Add, edit, delete, or query from the selected nodo
tui-help-open = F1 o ?     Apri guida
tui-help-promiscuous = allow_promiscuous_storage: { $value }
tui-help-q = q           Esci quando nessuna modale è attiva e il focus non è nell’input comandi
tui-help-quit = q           Esci quando nessuna modale è attiva e il focus non è nell’input comandi
tui-help-r = r           Aggiorna panes when focus is not in command input
tui-help-receiver-mode = Modalità ricevitore: { $value }
tui-receiver-mode-on-demand = su richiesta per retrieve locale
tui-receiver-mode-standalone = autonomo via storage-scp
tui-help-refresh = r           Aggiorna panes when focus is not in command input
tui-help-retrieve = m           Recupera dal risultato di query selezionato
tui-help-strict-pdu = strict_pdu: { $value }
tui-help-tab = Tab / Shift-Tab  Cambia riquadro attivo
tui-help-title = Scorciatoie
tui-help-ts-pref = preferred_store_transfer_syntax: { $value }
tui-help-updown = Su/Giù o j/k   Sposta selezione nei riquadri elenco
tui-input-placeholder = Digita un comando o usa le scorciatoie del riquadro.
tui-log-command = > { $command }
tui-log-error = errore: { $error }
tui-log-refreshed = aggiornato
tui-logs-capped-suffix = limitato
tui-logs-label = Log:
tui-pane-command = Comando
tui-pane-config = configurazione
tui-pane-detail = Dettaglio
tui-pane-detail-hint = { $title } (PgUp/PgDn quando non si sta digitando)
tui-pane-help = Aiuto
tui-pane-instance-detail = Dettaglio istanza
tui-pane-instances-for = Istanze di: { $uid }
tui-pane-local-studies = Studi locali
tui-pane-logs = Log ({ $shown }/{ $total }{ $capped })
tui-pane-logs-capped = Log ({ $shown }/{ $total } capped)
tui-pane-logs-uncapped = Log ({ $shown }/{ $total })
tui-pane-node-detail = Dettaglio nodo
tui-pane-query-detail = Dettaglio risultato query
tui-pane-query-node = Interroga nodo
tui-pane-query-result-detail = Dettaglio risultato query
tui-pane-query-results = Risultati query / retrieve
tui-pane-query-retrieve-results = Risultati query / retrieve
tui-pane-remote-nodes = Nodi remoti
tui-pane-series-detail = Dettaglio serie
tui-pane-series-for = Serie di: { $uid }
tui-pane-series-unknown = Serie di: <studio sconosciuto>
tui-pane-study-detail = Dettaglio studio
tui-pane-task-details = Dettaglio attività
tui-pane-tasks-history = Attività (cronologia)
tui-pane-tasks-queued = Attività (in coda)
tui-pane-unknown-series = <serie sconosciuta>
tui-pane-unknown-study = Serie di: <studio sconosciuto>
tui-row-inst = inst
tui-status-cancel-requested = Annullalation requested
tui-status-config = configurazione
tui-status-configured-listener = Listener configurato { $addr } come AE { $ae } ({ $mode })
tui-status-data = dati
tui-status-failure = errore: { $failure }
tui-status-listener = ascoltatore
tui-status-local-ae = AE locale
tui-status-mode = Modalità
tui-status-mode-on-demand = su richiesta
tui-status-mode-standalone = autonomo
tui-status-no-active-task = Nessuna attività attiva to cancel (nulla in esecuzione)
tui-status-pdu = PDU
tui-status-promiscuous = Promiscuo
tui-status-query-before-retrieve = Query a nodo remoto first so retrieve knows which nodo to use
tui-status-query-failed = query non riuscita: { $error }
tui-status-queued-op = Operazione in coda: { $op }
tui-status-retrieve-failed = recupero non riuscito: { $error }
tui-status-retrieve-open-failed = impossibile aprire retrieve stream: { $error }
tui-status-saved-node = saved nodo { $name } ({ $id })
tui-status-saved-scp = Impostazioni Storage SCP salvate (riavvio richiesto)
tui-status-select-node = seleziona prima un nodo remoto
tui-status-select-query = seleziona prima un risultato di query
tui-status-select-study = seleziona prima uno studio locale
tui-status-strict = rigoroso
tui-status-task-cancelled = Attività annullata
tui-status-task-cancelled-detail = Attività annullata: { $other }
tui-status-ts-pref = Pref. TS
tui-status-updated-node = updated nodo { $name } ({ $id })
tui-suggest-back-series = Esc — torna alle serie
tui-suggest-edit-config = c — modifica config
tui-suggest-help = F1/? — guida
tui-suggest-inspect-task = Invio — ispeziona attività
tui-suggest-node-add = node add <ae-title> <host:port>
tui-suggest-query = f — query a nodo
tui-suggest-query-node = f — query selected nodo
tui-suggest-retrieve = m — recupera selezionati
tui-suggest-run-command = Invio — esegui comando
tui-suggest-send-series = s — invia serie selezionata
tui-suggest-view-series = Invio — vedi serie
tui-task-cancelled = Annullato
tui-task-cancelling = Annullamento
tui-task-failed = Non riuscito
tui-task-failed-generic = Attività non riuscita: { $error }
tui-task-import-done = Importa complete: { $report }
tui-task-import-failed = Importazione non riuscita: { $error }
tui-task-importing = Importazione di { $path }...
tui-task-query-done =
    Query completata: { $count ->
        [one] { $count } corrispondenza
       *[other] { $count } corrispondenze
    }
tui-task-query-failed = Query non riuscita: { $error }
tui-task-querying = Query su { $node }...
tui-task-queued = In coda
tui-task-retrieve-done = Recupero completato: { $outcome }
tui-task-retrieve-failed = Retrieve non riuscito: { $error }
tui-task-retrieving = Retrieve da { $node }...
tui-task-running = In esecuzione
tui-task-sending-series = Invio serie { $uid } a { $node }...
tui-task-sending-study = Invio studio { $uid } a { $node }...
tui-task-send-done = Invio completato: { $outcome }
tui-task-status-cancelled = annullato
tui-task-status-cancelling = annullamento
tui-task-status-failed = non riuscito
tui-task-status-ok = ok
tui-task-status-queued = in coda
tui-task-status-running = in esecuzione
tui-task-succeeded = Riuscito
tui-terminal-too-small = Terminale troppo piccolo - ridimensiona la finestra

## Desktop
desktop-action-activity = Attività { $count }
desktop-action-activity-empty = Attività
desktop-action-import = Importa
desktop-action-inspect-archive = Ispeziona archivio locale
desktop-action-inspect-archive-desc = Scorri studi, serie e istanze, poi invia o esporta.
desktop-action-manage-peers = Gestisci peer
desktop-action-manage-peers-desc = Aggiungi e modifica nodi PACS o workstation usati da query, retrieve e store.
desktop-action-monitor-scp = Monitora Storage SCP
desktop-action-query = Interroga
desktop-action-refresh = Aggiorna stato
desktop-action-refresh-status = Aggiorna stato
desktop-action-reveal-log = Mostra file di log
desktop-action-send = Invia
desktop-action-start-scp = Avvia Storage SCP
desktop-activity-empty = Nessuna attività di sessione ancora.
desktop-activity-title = Attività
desktop-app-title = DICOM Node
desktop-archive-csv = CSV
desktop-archive-details = Dettagli
desktop-archive-empty = L’archivio locale è vuoto.
desktop-archive-export-fail = Esportazione { $scope } non riuscita
desktop-archive-export-ok =
    { $rows ->
        [one] Esportata { $rows } riga { $scope } in { $path }.
       *[other] Esportate { $rows } righe { $scope } in { $path }.
    }
desktop-archive-export-studies = Esporta studi
desktop-archive-export-title = Esporta { $scope }
desktop-archive-filter = Filtra per paziente, UID, descrizione, modalità…
desktop-archive-filter-placeholder = Filtra per paziente, UID, descrizione, modalità…
desktop-archive-inst-abbrev =
    { $count ->
        [one] { $count } ist.
       *[other] { $count } ist.
    }
desktop-archive-instance-meta = { $bytes } · TS { $ts } · importato { $imported }
desktop-archive-instances = Istanze
desktop-archive-instances-heading = Istanze
desktop-archive-json = JSON
desktop-archive-loading = Caricamento studi…
desktop-archive-no-filter-match = Nessuno studio corrisponde al filtro.
desktop-archive-no-instances = Nessuna istanza trovata.
desktop-archive-no-match = Nessuno studio corrisponde al filtro.
desktop-archive-no-nodes = Nessun nodo
desktop-archive-no-series = Nessuna serie trovata.
desktop-archive-reveal-file = Mostra file
desktop-archive-select-series = Seleziona una serie.
desktop-archive-select-study = Seleziona uno studio.
desktop-archive-send-fail = { $label }: { $sent }/{ $attempted } inviate, { $failed } fallite. { $failures }
desktop-archive-send-fail-title = { $label } non riuscito
desktop-archive-send-ok = { $label }: inviate { $sent }/{ $attempted } istanze.
desktop-archive-send-series = Invia serie
desktop-archive-send-series-label = Serie → { $destination }
desktop-archive-send-study = Invia studio
desktop-archive-send-study-label = Studio → { $destination }
desktop-archive-send-to = Invia a
desktop-archive-series = Serie
desktop-archive-series-count =
    #{ $number } · { $count ->
        [one] { $count } istanza
       *[other] { $count } istanze
    }
desktop-archive-series-fallback = Serie
desktop-archive-studies = Studi
desktop-archive-study-date = Data studio
desktop-archive-study-uid = Study UID
desktop-archive-subtitle = Inventario di studi, serie e istanze dall’archivio SQLite locale.
desktop-archive-title = Archivio locale
desktop-brand-title = DICOM Node
desktop-col-description = Descrizione
desktop-col-instances = Istanze
desktop-col-modalities = Modalità
desktop-col-patient-id = ID paziente
desktop-common-cancel = Annulla
desktop-common-clear = Cancella
desktop-common-disabled = disabilitato
desktop-common-enabled = abilitato
desktop-common-loading = Caricamento…
desktop-common-no = No
desktop-common-refresh = Aggiorna
desktop-common-yes = sì
desktop-counter-assoc-accepted = Associazioni accettate
desktop-counter-bytes-ingested = Byte ingeriti
desktop-counter-cfind-requests = Richieste C-FIND
desktop-counter-cmove-requests = Richieste C-MOVE
desktop-counter-cstore-failed = C-STORE non riusciti
desktop-counter-cstore-stored = C-STORE archiviati
desktop-dashboard-counter-assoc-accepted = Associazioni accettate
desktop-dashboard-counter-bytes-ingested = Byte ingeriti
desktop-dashboard-counter-c-find-requests = Richieste C-FIND
desktop-dashboard-counter-c-move-requests = Richieste C-MOVE
desktop-dashboard-counter-c-store-failed = C-STORE non riusciti
desktop-dashboard-counter-c-store-stored = C-STORE archiviati
desktop-dashboard-empty-studies = Nessuno studio locale ancora.
desktop-dashboard-inspect-archive-body = Rivedi studi, apri serie e istanze, poi invia o esporta.
desktop-dashboard-inspect-archive-title = Ispeziona archivio locale
desktop-dashboard-kv-ae-title = Titolo AE
desktop-dashboard-kv-data-dir = Directory dati
desktop-dashboard-kv-listener = ascoltatore
desktop-dashboard-kv-log-file = File di log
desktop-dashboard-kv-max-pdu = PDU max
desktop-dashboard-kv-promiscuous = Storage promiscuo
desktop-dashboard-kv-server = server
desktop-dashboard-kv-store-syntax = Sintassi di store
desktop-dashboard-kv-strict-pdu = PDU rigoroso
desktop-dashboard-listener-missing = Listener non ancora caricato.
desktop-dashboard-live-counters = Contatori live
desktop-dashboard-loading-metrics = Caricamento metriche…
desktop-dashboard-loading-status = Caricamento stato locale…
desktop-dashboard-loading-studies = Caricamento studi…
desktop-dashboard-local-node = Nodo locale
desktop-dashboard-manage-peers-body = Aggiungi e modifica nodi PACS o workstation usati per query, recupero e store.
desktop-dashboard-manage-peers-title = Gestisci peer
desktop-dashboard-metric-instances = Istanze
desktop-dashboard-metric-nodes = Nodi remoti
desktop-dashboard-metric-series = Serie
desktop-dashboard-metric-studies = Studi
desktop-dashboard-monitor-scp = Monitora Storage SCP
desktop-dashboard-recent-studies = Studi recenti
desktop-dashboard-start-scp = Avvia Storage SCP
desktop-dashboard-subtitle = Archivio locale, peer di rete e attività SCP a colpo d’occhio.
desktop-dashboard-title = Cruscotto operatore
desktop-doc-title = DICOM Node
desktop-import-accepted = Accettati
desktop-import-accepted-bytes = Byte accettati
desktop-import-activity-detail = { $accepted }/{ $scanned } accettati, { $duplicates } duplicati, { $bytes }
desktop-import-activity-fail = Importazione non riuscita
desktop-import-activity-ok = Importazione completata
desktop-import-choose-archive = Scegli un archivio ZIP da importare
desktop-import-choose-dir = Scegli una directory da importare
desktop-import-choose-folder = Cartella
desktop-import-choose-zip = Scegli un archivio ZIP da importare
desktop-import-cleanup = Pulizia
desktop-import-clear-path = Cancella percorso
desktop-import-complete = Importazione completata
desktop-import-dup-sha = SHA-256
desktop-import-dup-sop = SOP UID
desktop-import-dup-total = Totale
desktop-import-duplicates = Duplicati
desktop-import-failed = Importazione non riuscita
desktop-import-failed-cleanup = Pulizia non riuscita
desktop-import-failures = Errori
desktop-import-failures-heading =
    { $count ->
        [one] { $count } errore:
       *[other] { $count } errori:
    }
desktop-import-failures-more = … e altri { $count }
desktop-import-files-progress = { $label } file
desktop-import-folder = Cartella
desktop-import-invalid-dicom = DICOM non valido
desktop-import-pick-dir = Scegli una directory da importare
desktop-import-pick-zip = Scegli un archivio ZIP da importare
desktop-import-placeholder = /path/to/dicom-folder or /path/to/archive.zip
desktop-import-rejected = Rifiutati
desktop-import-report = Report di importazione
desktop-import-running = Importazione…
desktop-import-scanned = Analizzati
desktop-import-skipped = Saltati
desktop-import-source = Origine
desktop-import-start = Avvia importazione
desktop-import-stored = Archiviati
desktop-import-subtitle = Indicizza file DICOM da cartelle ricorsive o archivi ZIP nell’archivio locale gestito.
desktop-import-title = Importa
desktop-import-unreadable = Illeggibile
desktop-import-zip = ZIP
desktop-import-zip-filter = Archivi ZIP
desktop-lang-label = Lingua
desktop-listener-not-loaded = Listener non ancora caricato.
desktop-live-counters = Contatori live
desktop-loading = Caricamento
desktop-loading-local-status = Caricamento stato locale…
desktop-loading-metrics = Caricamento metriche…
desktop-loading-studies = Caricamento studi…
desktop-local-node = Nodo locale
desktop-locale-label = Lingua
desktop-logs-activity-detail =
    { $count ->
        [one] { $count } riga caricata
       *[other] { $count } righe caricate
    }
desktop-logs-activity-fail = Aggiornamento log non riuscito
desktop-logs-activity-ok = Log aggiornato
desktop-logs-auto = AUTOMATICO
desktop-logs-auto-refresh = Aggiornamento automatico
desktop-logs-empty = Il file di log è vuoto.
desktop-logs-found = FILE DI LOG TROVATO
desktop-logs-lines =
    { $count ->
        [one] { $count } riga
       *[other] { $count } righe
    }
desktop-logs-loading = Caricamento log…
desktop-logs-missing = Il file di log attivo non è ancora stato creato.
desktop-logs-refresh-failed = Aggiornamento log non riuscito
desktop-logs-refreshed = Log aggiornato
desktop-logs-reveal = Mostra
desktop-logs-subtitle = Coda limitata del file di log attivo del desktop.
desktop-logs-tail = Coda
desktop-logs-title = Log
desktop-logs-truncated = TRONCATO
desktop-logs-waiting = IN ATTESA DEL FILE DI LOG
desktop-metric-instances = Istanze
desktop-metric-remote-nodes = Nodi remoti
desktop-metric-series = Serie
desktop-metric-studies = Studi
desktop-nav-archive = Archivio locale
desktop-nav-dashboard = Cruscotto
desktop-nav-import = Importa
desktop-nav-logs = Log
desktop-nav-network = Rete
desktop-nav-nodes = Nodi remoti
desktop-nav-query = Query / Recupero
desktop-nav-server = Server di archiviazione
desktop-no-local-studies = Nessuno studio locale ancora.
desktop-nodes-add = Aggiungi nodo
desktop-nodes-added = Nodo "{ $name }" aggiunto.
desktop-nodes-ae-length = Il titolo AE deve avere al massimo 16 caratteri.
desktop-nodes-ae-title = Titolo AE
desktop-nodes-col-move = Dest. Move
desktop-nodes-configured = Nodi configurati
desktop-nodes-confirm-delete = Eliminare il nodo "{ $name }"?
desktop-nodes-default-port = Porta predefinita 104
desktop-nodes-delete = Elimina nodo
desktop-nodes-delete-title = Elimina nodo
desktop-nodes-deleted = Nodo "{ $name }" eliminato.
desktop-nodes-edit = Modifica nodo
desktop-nodes-edit-title = Modifica nodo
desktop-nodes-empty = Nessun nodo remoto ancora.
desktop-nodes-err-ae = Il titolo AE è obbligatorio.
desktop-nodes-err-ae-len = Il titolo AE deve avere al massimo 16 caratteri.
desktop-nodes-err-host = L’host è obbligatorio.
desktop-nodes-err-name = Il nome è obbligatorio.
desktop-nodes-err-port = La porta deve essere tra 1 e 65535.
desktop-nodes-host = host
desktop-nodes-move-dest = Destinazione Move
desktop-nodes-move-placeholder = Predefinito: AE locale
desktop-nodes-name = Nome
desktop-nodes-need-ae = Il titolo AE è obbligatorio.
desktop-nodes-need-host = L’host è obbligatorio.
desktop-nodes-need-name = Il nome è obbligatorio.
desktop-nodes-notes = Note
desktop-nodes-notes-placeholder = PACS sala referti
desktop-nodes-placeholder-ae = PACS01
desktop-nodes-placeholder-host = 192.168.0.10
desktop-nodes-placeholder-move = Predefinito: AE locale
desktop-nodes-placeholder-name = main-pacs
desktop-nodes-placeholder-notes = PACS sala referti
desktop-nodes-port = Porta
desktop-nodes-port-104 = Porta predefinita 104
desktop-nodes-port-range = La porta deve essere tra 1 e 65535.
desktop-nodes-save = Salva modifiche
desktop-nodes-save-changes = Salva modifiche
desktop-nodes-subtitle = Peer PACS e workstation per query, recupero e store.
desktop-nodes-summary = Riepilogo nodi
desktop-nodes-title = Nodi remoti
desktop-nodes-total = Nodi totali
desktop-nodes-updated = Nodo "{ $name }" aggiornato.
desktop-nodes-with-move = Con destinazione Move
desktop-promiscuous = Storage promiscuo
desktop-query-accession = Accession n.
desktop-query-activity-detail = { $count } { $count ->
        [one] corrispondenza
       *[other] corrispondenze
    } al livello { $level }
desktop-query-activity-fail = C-FIND { $node } non riuscito
desktop-query-activity-ok = C-FIND { $node }
desktop-query-activity-title = C-FIND { $node }
desktop-query-clear = Cancella
desktop-query-col-accession = numero di accession
desktop-query-criteria = Criteri di ricerca
desktop-query-date-from = Data studio da
desktop-query-date-to = Data studio a
desktop-query-kv-series-uid = Series UID
desktop-query-kv-sop-uid = SOP UID
desktop-query-kv-study-uid = Study UID
desktop-query-level = Livello
desktop-query-matches =
    { $count ->
        [one] { $count } corrispondenza
       *[other] { $count } corrispondenze
    }
desktop-query-missing-study-uid = La corrispondenza non ha StudyInstanceUID; impossibile recuperare.
desktop-query-modality = Modalità
desktop-query-no-matches = Nessuna corrispondenza.
desktop-query-no-nodes = Nessun nodo configurato
desktop-query-patient-id = ID paziente
desktop-query-patient-name = Nome paziente
desktop-query-placeholder-description = CHEST*
desktop-query-placeholder-modality = CT, MR, …
desktop-query-placeholder-name = DOE^JOHN or DOE*
desktop-query-placeholder-patient = DOE^JOHN or DOE*
desktop-query-querying = Interrogazione…
desktop-query-remote-node = Nodo remoto
desktop-query-results = Risultati
desktop-query-retrieve = Recupera
desktop-query-retrieve-activity-detail = completed={ $completed }, warning={ $warning }, failed={ $failed }
desktop-query-retrieve-activity-fail = C-MOVE { $node } non riuscito
desktop-query-retrieve-activity-ok = C-MOVE { $node }
desktop-query-retrieve-finished = Recupero terminato: completate { $completed }, avvisi { $warning }, fallite { $failed }.
desktop-query-retrieve-selected = Recupera selezione
desktop-query-run = Esegui C-FIND
desktop-query-run-select = Esegui una query e seleziona una corrispondenza.
desktop-query-running = Interrogazione…
desktop-query-search-criteria = Criteri di ricerca
desktop-query-select-hint = Esegui una query e seleziona una corrispondenza.
desktop-query-selected = Corrispondenza selezionata
desktop-query-selected-match = Corrispondenza selezionata
desktop-query-series-uid = Series Instance UID
desktop-query-sop-uid = SOP Instance UID
desktop-query-study-description = Descrizione studio
desktop-query-study-uid = Study Instance UID
desktop-query-subtitle = C-FIND verso un nodo remoto, ispeziona le corrispondenze, poi C-MOVE nell’archivio locale.
desktop-query-title = Query / Recupero
desktop-recent-studies = Studi recenti
desktop-scp-listening = SCP in ascolto
desktop-scp-stopped = SCP fermato
desktop-server-activity-fail = Controllo Storage SCP non riuscito
desktop-server-activity-started = Storage SCP avviato
desktop-server-activity-started-detail = Listener avviato.
desktop-server-activity-stopped = Storage SCP fermato
desktop-server-activity-stopped-detail = received={ $received }, stored={ $stored }, failed={ $failed }
desktop-server-activity-stopped-empty = Nessuna sessione attiva.
desktop-server-addr-ae = { $addr } · AE { $ae }
desktop-server-assoc-accepted = Associazioni accettate
desktop-server-assoc-rejected = Associazioni rifiutate
desktop-server-cfind-req-matches = Richieste / corrispondenze C-FIND
desktop-server-cget-requests = Richieste C-GET
desktop-server-cmove-requests = Richieste C-MOVE
desktop-server-cmove-subops = Sotto-operazioni C-MOVE completate / fallite
desktop-server-control-failed = Controllo Storage SCP non riuscito
desktop-server-counter-bytes = Byte ingeriti
desktop-server-counter-failed = C-STORE non riusciti
desktop-server-counter-find = Richieste / corrispondenze C-FIND
desktop-server-counter-get = Richieste C-GET
desktop-server-counter-move = Richieste C-MOVE
desktop-server-counter-move-sub = Sotto-operazioni C-MOVE completate / fallite
desktop-server-counter-received = C-STORE ricevuti
desktop-server-counter-stored = C-STORE archiviati
desktop-server-cstore-failed = C-STORE non riusciti
desktop-server-cstore-received = C-STORE ricevuti
desktop-server-cstore-stored = C-STORE archiviati
desktop-server-dimse = Contatori DIMSE
desktop-server-failed = Falliti
desktop-server-health-loading = Caricamento metriche
desktop-server-health-ready = Pronto per C-STORE in ingresso
desktop-server-health-review = Esamina errori
desktop-server-health-stopped = Fermato
desktop-server-listener-started = Listener avviato.
desktop-server-listening = IN ASCOLTO
desktop-server-loading-metrics = Caricamento metriche…
desktop-server-logs = Log
desktop-server-no-session = Nessuna sessione attiva.
desktop-server-rate = +{ $rate } / rilevamento
desktop-server-ready = Pronto per C-STORE in ingresso
desktop-server-review-failures = Esamina errori
desktop-server-session-ended = Sessione terminata: ricevuti { $received }, archiviati { $stored }, falliti { $failed }.
desktop-server-start = Avvia server
desktop-server-started-title = Storage SCP avviato
desktop-server-stop = Ferma server
desktop-server-stopped = FERMATO
desktop-server-stopped-pill = FERMATO
desktop-server-stopped-status = Fermato
desktop-server-stopped-title = Storage SCP fermato
desktop-server-stored = Archiviati
desktop-server-subtitle = Storage SCP autonomo per C-STORE in ingresso e indicizzazione dell’archivio locale.
desktop-server-title = Server di archiviazione
desktop-status-listening = in ascolto
desktop-status-loading = Caricamento
desktop-status-scp-listening = SCP in ascolto
desktop-status-scp-stopped = SCP fermato
desktop-status-stopped = fermato
desktop-store-syntax = Sintassi di store
desktop-strict-pdu = PDU rigoroso
desktop-strip-pdu = PDU { $value }
desktop-table-accession = Accesso
desktop-table-ae-title = Titolo AE
desktop-table-date = Data
desktop-table-description = Descrizione
desktop-table-endpoint = endpoint
desktop-table-instances = Istanze
desktop-table-modalities = Modalità
desktop-table-modality = Modalità
desktop-table-move-dest = Dest. Move
desktop-table-name = Nome
desktop-table-notes = Note
desktop-table-patient = Paziente
desktop-table-patient-id = ID paziente
desktop-table-series = Serie
desktop-table-updated = Aggiornato
desktop-title-refresh-status = Aggiorna stato
desktop-title-reveal-log = Mostra file di log
ae = AE
patient-name =
    "DOE^JOHN"
    Premi 'm' su un risultato selezionato per aprire retrieve.
port = Porta

## Summary
summary-ae = AE
summary-counts = Conteggi
summary-criteria = Criteri
summary-duration = Durata
summary-duration-ms = { $ms }ms
summary-failures = Errori:
summary-kind = Tipo
summary-logs = Log:
summary-peer = controparte
summary-status = Stato
summary-title = Riepilogo operazione
tui-detail-created = Creato

tui-form-hint-port-range = suggerimento: un numero da 1 a 65535, es. 104
tui-form-hint-promiscuous = suggerimento: consenti archiviazione da qualsiasi AE title chiamante
tui-form-hint-strict-pdu = suggerimento: applica i controlli di dimensione PDU durante le associazioni
tui-form-hint-max-pdu-bytes = suggerimento: byte, es. 16384
tui-form-limits-heading = Limits (bytes; blank/nessuno = unlimited):
tui-form-field-max-file-import = Byte max. import file
tui-form-field-max-zip-entry = Byte max. voce ZIP
tui-form-field-max-zip-total = Byte totali max. ZIP
tui-form-field-max-zip-count = Numero max. voci ZIP
tui-form-field-max-store-object = Byte max. oggetto store
tui-form-unlimited = illimitato
tui-form-err-max-pdu-required = ! la lunghezza max. PDU è obbligatoria
tui-form-err-max-pdu-gt-zero = ! la lunghezza max. PDU deve essere un intero maggiore di 0
tui-form-err-limit-gt-zero = ! { $label } deve essere un intero maggiore di 0
tui-form-controls-scp = Digita per modificare. Spazio attiva le caselle. Tab/Shift-Tab o Su/Giù spostano i campi. Invio salva. Esc annulla.
tui-form-submit-uid-required = UID obbligatorio
tui-form-submit-dest-required = destination nodo is required
tui-form-submit-nonneg-int = { $label } deve essere un intero non negativo
tui-form-submit-gt-zero = { $label } deve essere maggiore di 0
tui-form-submit-local-ae-required = l’AE title locale è obbligatorio
tui-form-submit-local-ae-invalid = l’AE title locale non è valido: { $err }
tui-form-submit-bind-required = l’indirizzo di bind è obbligatorio
tui-form-submit-port-required = la porta è obbligatoria
tui-form-submit-max-pdu-required = la lunghezza max. PDU è obbligatoria
tui-form-submit-max-pdu-int = la lunghezza max. PDU deve essere un intero
tui-form-submit-max-pdu-gt-zero = la lunghezza max. PDU deve essere maggiore di 0
tui-form-submit-patient-retrieve = il recupero a livello paziente non è supportato
tui-form-submit-no-study-uid = il risultato selezionato non include uno study UID
tui-form-submit-date-format = atteso YYYYMMDD
tui-form-submit-modality-len = la modalità deve avere al massimo 16 caratteri
tui-form-submit-modality-chars = la modalità deve essere A-Z o 0-9
tui-form-submit-name-required = il nome del nodo è obbligatorio
tui-form-submit-ae-required = L’AE title è obbligatorio
tui-form-submit-host-required = l’host è obbligatorio
tui-form-submit-move-dest-invalid = l’AE title di destinazione move non è valido: { $err }
tui-form-submit-dates-both = data da e data a devono essere entrambe impostate, o nessuna
tui-form-submit-date-from-invalid = la data da non è valida: { $err }
tui-form-submit-date-to-invalid = la data a non è valida: { $err }
tui-form-submit-date-order = la data da deve essere precedente o uguale alla data a
tui-form-submit-study-uid-series-query = lo study UID è obbligatorio per le query a livello serie
tui-form-submit-study-uid-image-query = lo study UID è obbligatorio per le query a livello immagine
tui-form-submit-series-uid-image-query = lo series UID è obbligatorio per le query a livello immagine
tui-form-submit-study-uid-required = lo study UID è obbligatorio
tui-form-submit-study-uid-invalid = lo study UID non è valido: { $err }
tui-form-submit-series-uid-series-retrieve = lo series UID è obbligatorio per il recupero a livello serie
tui-form-submit-series-uid-image-retrieve = lo series UID è obbligatorio per il recupero a livello immagine
tui-form-submit-instance-uid-image-retrieve = l’instance UID è obbligatorio per il recupero a livello immagine
tui-form-submit-series-uid-invalid = lo series UID non è valido: { $err }
tui-form-submit-instance-uid-invalid = l’instance UID non è valido: { $err }
tui-form-submit-import-path-required = il percorso di import è obbligatorio
tui-form-submit-import-path-type = il percorso di import deve essere un file o una directory: { $path }
tui-form-submit-import-access = accesso al percorso di import { $path }
tui-form-submit-import-open = apertura file di import { $path }
tui-form-submit-import-read-dir = lettura directory di import { $path }
tui-log-welcome = Press F1 or ? for help. Focus Nodo remotos and press 'a' to add one.
tui-log-logging-to = Log su { $path }
tui-command-help-heading = comandi:
tui-command-help-next-1 = nota: il piè di pagina mostra suggerimenti contestuali 'Next:' in base al riquadro attivo e alla selezione.
tui-command-help-next-2 = Sono solo suggerimenti; puoi sempre digitare qualsiasi comando.
tui-command-help-canonical = nota: i nomi canonici coincidono con i flag CLI senza '--', usando underscore.
tui-command-help-cancel = annulla (alias: stop)
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
tui-command-help-refresh = aggiorna
tui-command-help-quit = esci
tui-inspect-task = Attività #{ $id }
tui-inspect-status = Stato: { $status }
tui-inspect-description = Descrizione: { $description }
tui-inspect-progress = Avanzamento: { $progress }
tui-inspect-summary = Riepilogo:
tui-inspect-no-logs = (nessun log)
tui-field-sop-class-uid = SOP Class UID
tui-field-transfer-syntax-uid = Transfer Syntax UID
tui-field-sha256 = SHA-256
tui-status-removed-nodes =
    rimosso { $count ->
        [one] { $count } nodo
       *[other] { $count } nodi
    }
tui-status-removed-nodes-target =
    rimosso { $count ->
        [one] { $count } nodo
       *[other] { $count } nodi
    }; ultimo obiettivo { $name }
tui-status-more-failures =
    e { $n ->
        [one] { $n } errore omesso
       *[other] { $n } errori omessi
    }
tui-status-retrieve-ok = retrieve status=0x{ $status } completed={ $completed } failed={ $failed } warning={ $warning } remaining={ $remaining }
tui-status-import-counts = scanned={ $scanned } accepted={ $accepted } duplicates={ $duplicates } unreadable={ $unreadable } invalid_dicom={ $invalid } rejected_total={ $rejected } stored_bytes={ $bytes }
tui-status-send-ok = send attempted={ $attempted } sent={ $sent } failed={ $failed }
tui-log-query-start = Avvio query verso { $node }
tui-log-retrieve-start = Avvio recupero da { $node }
tui-log-import-start = Avvio import di { $path }
tui-log-send-study-start = Avvio invio studio { $uid } a { $node }
tui-log-send-series-start = Avvio invio serie { $uid } a { $node }
tui-log-cancelled-before-start = annullato prima dell’avvio
tui-log-cancelled = annullato
error-unknown-command = comando sconosciuto: { $command }
error-node-subcommand-required = sottocomando node obbligatorio
error-local-subcommand-required = sottocomando local obbligatorio
error-unsupported-node-subcommand = unsupported nodo subcommand: { $command }
error-unsupported-local-subcommand = sottocomando local non supportato: { $command }
error-expected-kv = atteso argomento key=value, ricevuto { $arg }
error-missing-required-arg = argomento obbligatorio mancante: { $key }
error-missing-required-arg-one-of = argomento obbligatorio mancante: uno di { $keys }
error-parsing-command = analisi del comando
error-edit-form-lost-target = edit form lost its target nodo
error-task-already-running = un’attività in background è già in esecuzione
error-task-thread-launch = impossibile avviare il thread dell’attività in background: { $error }
error-task-disconnected = il thread dell’attività in background si è disconnesso prima di inviare un risultato
error-task-kind-missing = il thread in background si è disconnesso ma active_task_kind era None: stato inatteso
error-serve-exited = serve è uscito con errore: { $error }
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
summary-title = Riepilogo operazione
summary-kind = Tipo
summary-status = Stato
summary-duration = Durata
summary-duration-ms = { $ms }ms
summary-peer = controparte
summary-ae = AE
summary-criteria = Criteri
summary-counts = Conteggi
summary-failures = Errori:
summary-logs = Log:
summary-unserializable = <non serializzabile>
summary-log-lines = righe { $start }-{ $end }
