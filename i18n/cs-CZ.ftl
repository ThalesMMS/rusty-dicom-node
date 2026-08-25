# Fluent catalog (cs-CZ). Message IDs are hyphenated identifiers
# (cli-about, tui-pane-remote-nodes, desktop-nav-dashboard, error-import-file-too-large).
# Dotted names are Fluent attributes (message + .attr), not message IDs.
# Do not translate DICOM tokens (C-FIND, C-MOVE, C-STORE, SOP, AE, UID) or JSON/CSV machine keys.


## CLI
cli-about = Terminálový DICOM uzel postavený na dicom-rs
cli-arg-accession-number = Filtrovat podle accession number (podřetězec, bez rozlišení velikosti písmen).
cli-arg-ae-title = Application Entity title
cli-arg-destination-node = Název nebo id cílového uzlu
cli-arg-duplicate = Filtrovat podle stavu duplicity.
cli-arg-export = Exportovat výsledky jako JSON nebo CSV.
cli-arg-host = Název hostitele nebo IP
cli-arg-imported-at =
    Filtrovat podle času importu. Podporuje VALUE, START..END, ..END, START...
    Porovnání je lexikografické (doporučený formát: RFC3339).
cli-arg-json = Vypsat závěrečný souhrn operace jako JSON (stabilní schéma).
cli-arg-level = Úroveň dotazu/načtení
cli-arg-metrics-json = Při ukončení serveru vypsat závěrečný snímek metrik v paměti jako JSON.
cli-arg-modality = Filtrovat podle modality. Seznam oddělený čárkami (např. CT,MR).
cli-arg-model = Informační model dotazu/načtení
cli-arg-move-destination = Preferovaný cílový AE title pro C-MOVE
cli-arg-name = Zobrazovaný název uzlu
cli-arg-node = Název nebo id uloženého uzlu
cli-arg-notes = Volné poznámky
cli-arg-out = Cesta k výstupnímu souboru. Pokud chybí, zapisuje na stdout.
cli-arg-path = Soubor nebo adresář k importu
cli-arg-patient-id = Filtrovat podle ID pacienta (podřetězec, bez rozlišení velikosti písmen).
cli-arg-patient-name = Filtrovat podle jména pacienta (podřetězec, bez rozlišení velikosti písmen).
cli-arg-port = číslo portu
cli-arg-series-description = Filtrovat podle popisu série (podřetězec, bez rozlišení velikosti písmen).
cli-arg-series-instance-uid = Series Instance UID
cli-arg-sop-instance-uid = SOP Instance UID
cli-arg-source-path = Filtrovat podle zdrojové cesty (podřetězec, bez rozlišení velikosti písmen).
cli-arg-study-date =
    Filtrovat podle data studie. Podporuje VALUE, START..END, ..END, START...
    Data se porovnávají lexikograficky (doporučený formát: YYYYMMDD).
cli-arg-study-date-from = Dolní mez data studie (YYYYMMDD)
cli-arg-study-date-to = Horní mez data studie (YYYYMMDD)
cli-arg-study-description = Filtrovat podle popisu studie (podřetězec, bez rozlišení velikosti písmen).
cli-arg-study-instance-uid = Study Instance UID
cli-cmd-import-about = Importovat soubory DICOM z cesty
cli-cmd-local-about = Prohlédnout lokální archiv
cli-cmd-local-series-about = Vypsat indexované série studie
cli-cmd-local-studies-about = Vypsat indexované lokální studie
cli-cmd-node-about = Spravovat uložené vzdálené DICOM uzly
cli-cmd-node-add-about = Přidat vzdálený uzel
cli-cmd-node-delete-about = Odstranit uložený uzel
cli-cmd-node-edit-about = Upravit uložený uzel
cli-cmd-node-list-about = Vypsat uložené uzly
cli-cmd-query-about = Dotázat vzdálený uzel (C-FIND)
cli-cmd-retrieve-about = Načíst ze vzdáleného uzlu (C-MOVE)
cli-cmd-send-about = Odeslat lokální studie nebo série (C-STORE)
cli-cmd-send-series-about = Odeslat sérii na cílový uzel
cli-cmd-send-study-about = Odeslat studii na cílový uzel
cli-cmd-serve-about = Spustit DICOM server
cli-cmd-storage-scp-about = Spustit posluchač Storage SCP
cli-cmd-tui-about = Otevřít interaktivní terminálové rozhraní
cli-flag-help = Zobrazit nápovědu
cli-flag-lang = Jazyk rozhraní (značka BCP-47). Přepíše DICOM_NODE_LANG, uložené locale i locale operačního systému.
cli-flag-version = Zobrazit verzi
cli-heading-arguments = Argumenty:
cli-heading-commands = Příkazy:
cli-heading-options = Přepínače:
cli-heading-usage = Použití:
cli-import-accepted = accepted={ $n }
cli-import-complete = Import dokončen
cli-import-duplicates = duplicates={ $n }
cli-import-scanned = scanned={ $n }
cli-msg-cancel-sigint = Požadováno zrušení (SIGINT). Čeká se na řízené ukončení...
cli-msg-failures = selhání:
cli-msg-import-failed = Import selhal: { $error }
cli-msg-no-local-series = Žádné indexované série pro studii { $uid }
cli-msg-no-local-studies = Žádné indexované lokální studie
cli-msg-no-saved-nodes = Žádné uložené uzly
cli-msg-query-failed = Dotaz selhal: { $error }
cli-msg-removed-nodes =
    Odstraněno { $count ->
        [one] { $count } uzel
        [few] { $count } uzly
        [many] { $count } uzlů
       *[other] { $count } uzlů
    }
cli-msg-results-count =
    Výsledky: { $count ->
        [one] { $count } shoda
        [few] { $count } shody
        [many] { $count } shod
       *[other] { $count } shod
    }
cli-msg-retrieve-failed = Načtení selhalo: { $error }
cli-msg-saved-node = Uložen uzel { $name } [{ $id }] => { $ae }@{ $host }:{ $port }
cli-msg-send-failed = Odeslání selhalo: { $error }
cli-msg-showing-failures = (zobrazeno prvních { $shown } z { $total } selhání)
cli-msg-starting-server =
    Spouštění DICOM serveru s { $count ->
        [one] { $count } lokální AE
        [few] { $count } lokální AE
        [many] { $count } lokálních AE
       *[other] { $count } lokálních AE
    }: { $aes }
cli-msg-starting-server-no-aes = Spouštění DICOM serveru bez nakonfigurovaných lokálních AE
cli-msg-starting-storage-scp = Spouštění storage SCP na { $addr } s AE title { $ae }
cli-msg-updated-node = Aktualizován uzel { $name } [{ $id }] => { $ae }@{ $host }:{ $port }
cli-send-attempted = attempted={ $n }
cli-send-failed-count = failed={ $n }
cli-send-sent = sent={ $n }
cli-value-name-file = FILE
cli-value-name-format = FORMAT
cli-value-name-locale = LOCALE
cli-value-name-path = PATH
tui-detail-more-series =
    ... { $n ->
        [one] { $n } série navíc
        [few] { $n } série navíc
        [many] { $n } sérií navíc
       *[other] { $n } sérií navíc
    }
tui-row-instance-count =
    { $n ->
        [one] { $n } inst.
        [few] { $n } inst.
        [many] { $n } inst.
       *[other] { $n } inst.
    }
tui-row-study-counts = { $series }s/{ $instances }i
count-nodes =
    { $n ->
        [one] { $n } uzel
        [few] { $n } uzly
        [many] { $n } uzlů
       *[other] { $n } uzlů
    }
count-instances =
    { $n ->
        [one] { $n } instance
        [few] { $n } instance
        [many] { $n } instancí
       *[other] { $n } instancí
    }
count-series =
    { $n ->
        [one] { $n } série
        [few] { $n } série
        [many] { $n } sérií
       *[other] { $n } sérií
    }
count-studies =
    { $n ->
        [one] { $n } studie
        [few] { $n } studie
        [many] { $n } studií
       *[other] { $n } studií
    }
format-datetime = { $date } { $time }
format-date = { $day }.{ $month }.{ $year }

## Common
common-accession = accession
common-add = Přidat
common-back = Zpět
common-bytes = Bajty
common-cancel = Zrušit
common-clear = Vymazat
common-close = Zavřít
common-date = Datum
common-delete = Odstranit uzel
common-description = Popis
common-disabled = vypnuto
common-duplicates = Duplikáty
common-edit = Upravit
common-enabled = zapnuto
common-error = Chyba
common-filter = Filtr
common-host = Hostitel
common-import = import
common-instance = instance
common-language = Jazyk
common-loading = Načítání
common-matches = Shody
common-modality = Modalita
common-name = Název
common-network = Síť
common-no = ne
common-none = žádné
common-notes = Poznámky
common-optional = volitelné
common-path = Zdroj
common-patient = Pacient
common-patient-id = ID pacienta
common-patient-name = Jméno pacienta
common-port = číslo portu
common-query = Dotaz
common-refresh = Obnovit
common-required = povinné
common-retrieve = Načíst
common-save = Uložit
common-search = Hledat
common-send = Odeslat
common-series = Série
common-start = Spustit
common-status = Stav
common-stop = Zastavit
common-studies = Studie
common-study = Vyšetření
common-unknown = neznámý
common-unknown-series = <Série>
common-unknown-study = <Studie>
common-yes = ano

## Errors
error-ae-empty = AE title nesmí být prázdný
error-ae-invalid-char = AE title obsahuje neplatný znak '{ $character }'; povoleno: A-Z, 0-9, mezera
error-ae-required = AE title je povinný
error-ae-too-long = AE title smí mít nejvýše 16 znaků
error-ae-whitespace = AE title nesmí mít úvodní ani koncové mezery
error-archive-patient-retrieve-out-of-scope = retrieve na úrovni Patient je mimo rozsah
error-archive-retrieve-uid-required = { $name } je pro tuto úroveň retrieve povinné
error-archive-study-root-patient-query = dotazy Study Root nepodporují úroveň Patient
error-archive-study-root-patient-retrieve = retrieve Study Root nepodporuje úroveň Patient
error-assoc-negotiation-failed = vyjednání asociace selhalo s { $name } ({ $addr }); nápověda: ověřte called AE title, presentation contexts/transfer syntaxes a že protistrana asociace přijímá
error-assoc-no-addresses = žádné socket adresy pro { $name } na { $host }:{ $port }
error-assoc-receive = příjem asociace
error-assoc-resolving = překlad { $name } na { $host }:{ $port }: { $err }
error-assoc-timeout = vypršel čas čekání na odpověď DIMSE; nápověda: zkontrolujte síť, AE title/hostitele/port a odezvu peeru
error-assoc-transport = přerušení transportu při čekání na odpověď DIMSE; nápověda: peer uzavřel spojení nebo je síťové zařízení resetovalo
error-assoc-unreachable = nelze dosáhnout { $name } [{ $ae }] na { $host }:{ $port } do { $seconds }s: { $err }. Zkontrolujte hostitele/IP, port a síťovou dostupnost
error-cancel-sigint = Požadováno zrušení (SIGINT). Čeká se na řízené ukončení...
error-config-must-be-positive = neplatná config: { $name } musí být > 0 (nebo null pro vypnutí)
error-config-duplicate-bind-port = neplatná config: duplicitní bind port lokálního AE { $port }
error-config-local-ae-max-assoc = neplatná config: lokální AE { $title } max_concurrent_associations musí být > 0
error-config-local-ae-no-services = neplatná config: lokální AE { $title } musí povolit alespoň jednu službu
error-config-must-be-positive-required = neplatná config: { $name } musí být > 0
error-dicom-meta-incomplete = meta souboru DICOM je neúplné
error-dicom-patient-move-unsupported = C-MOVE na úrovni pacienta tento klientský scaffold nepodporuje
error-dicom-required-attribute = chybí povinný atribut DICOM: ({ $group },{ $element })
error-dicom-series-uid-required-image = series_instance_uid je povinné pro načtení na úrovni snímku
error-dicom-series-uid-required-series = series_instance_uid je povinné pro načtení na úrovni série
error-dicom-sop-uid-required-image = sop_instance_uid je povinné pro načtení na úrovni snímku
error-dicom-study-uid-required = study_instance_uid je povinné
error-dicom-validating-move = ověřování požadavku move
error-export-creating-file = vytváření exportního souboru { $path }: { $err }
error-export-flushing-series-csv = vyprázdnění CSV sérií: { $err }
error-export-flushing-studies-csv = vyprázdnění CSV studií: { $err }
error-export-serializing-series-json = serializace sérií do JSON: { $err }
error-export-serializing-studies-json = serializace studií do JSON: { $err }
error-export-writing-series-csv-header = zápis CSV záhlaví sérií: { $err }
error-export-writing-series-csv-row = zápis CSV řádku sérií: { $err }
error-export-writing-studies-csv-header = zápis CSV záhlaví studií: { $err }
error-export-writing-studies-csv-row = zápis CSV řádku studií: { $err }
error-import-cleanup-failed = { $source }: úklid selhal: { $reason }
error-import-corrupt-zip = Poškozený ZIP: { $details }
error-import-dicom-parse-failed = parsování DICOM selhalo: { $err }
error-import-dicom-validation-failed = validace DICOM selhala: { $err }
error-import-duplicate-zip-path = Duplicitní cesta ZIP: { $details }
error-import-file-too-large = soubor je příliš velký: { $details }
error-import-invalid-dicom = Neplatný DICOM: { $details }
error-import-limit-exceeded = { $limit } překročen: { $details }
error-import-not-regular-file = není běžný soubor
error-import-opening-file = otevírání souboru: { $err }
error-import-opening-kind = otevírání { $kind } { $path }
error-import-opening-staged-file = otevírání dočasně uloženého souboru: { $err }
error-import-opening-zip-archive = otevírání ZIP archivu { $path }
error-import-opening-zip-entry = otevírání ZIP položky: { $err }
error-import-opening-zip-file = otevírání ZIP souboru importu { $path }
error-import-path-does-not-exist = Cesta importu neexistuje: { $path }
error-import-reading-directory = čtení importního adresáře { $path }
error-import-reading-file = čtení souboru: { $err }
error-import-reading-file-metadata = čtení metadat souboru pro { $path }
error-import-reading-metadata = čtení metadat pro { $kind } { $path }
error-import-reading-zip-entry = čtení ZIP položky: { $err }
error-import-removing-staged-after-cancel = odstraňování dočasně uloženého souboru po zrušení { $path }
error-import-skipped = Přeskočeno: { $details }
error-import-unreadable = Nečitelný soubor: { $details }
error-import-unsafe-zip-path = Nebezpečná cesta ZIP: { $details }
error-import-zip-entry-count-exceeded = překročen limit počtu ZIP položek: archiv má { $count } položek, limit je { $limit }
error-import-zip-entry-size-exceeded = velikost ZIP položky { $size } překračuje limit { $limit }
error-import-zip-total-bytes-exceeded = překročen limit celkových rozbalených ZIP bajtů: aktuální součet { $current } plus velikost položky { $entry } překračuje limit { $limit }
error-net-binding-storage-scp = vazba Storage SCP na { $addr } pro AE { $ae }. Jiný lokální DICOM přijímač už možná používá tento port. Aktualizujte storage_scp_port/local_aes v { $config } nebo zastavte konfliktní posluchač
error-net-building-file-meta = sestavování tabulky file meta
error-net-cannot-send-transfer-syntax = nelze odeslat zdrojovou transfer syntax { $source } se sjednanou transfer syntax { $negotiated }
error-net-cget-dataset-empty = kódovaná datová sada C-GET C-STORE je prázdná
error-net-cget-dataset-odd-length = kódovaná datová sada C-GET C-STORE skončila fragmentem liché délky
error-net-cget-peer-released = protějšek uvolnil asociaci během C-GET
error-net-cget-store-unexpected-dataset = neočekávané dataset fragment in C-GET C-STORE response
error-net-cget-unexpected-command = neočekávané command 0x{ $command } while waiting for C-STORE-RSP
error-net-cget-unexpected-pdu = neočekávané PDU during C-GET C-STORE suboperation: { $pdu }
error-net-creating-incoming-dir = vytváření adresáře .incoming Storage SCP
error-net-creating-path = vytváření { $path }
error-net-dataset-empty = kódovaná datová sada je prázdná, ale COMMAND_DATA_SET_TYPE vyžaduje dataset
error-net-dataset-odd-length = kódovaná datová sada skončila fragmentem liché délky
error-net-dimse-failed = { $operation } selhalo se stavem 0x{ $status } ({ $meaning }){ $hint }
error-net-establishing-assoc = navazování asociace Storage SCP
error-net-file-meta-length = čtení File Meta Information length
error-net-file-meta-tag = čtení File Meta Information tag
error-net-file-meta-value = přeskakování hodnoty File Meta Information
error-net-file-meta-vr = čtení File Meta Information VR
error-net-file-position = čtení file position
error-net-flushing-path = vyprázdnění { $path }
error-net-flushing-temp-dataset = vyprázdnění dočasného souboru datasetu
error-net-hint-suffix = ; nápověda: { $hint }
error-net-incomplete-command = neúplné { $operation } command response
error-net-incomplete-identifier = neúplné { $operation } response identifier
error-net-invalid-affected-sop = neplatné { $operation } affected SOP class UID
error-net-invalid-status = neplatné { $operation } status
error-net-listener-address = čtení storage SCP listener address
error-net-listener-nonblocking = nastavení neblokujícího režimu posluchače
error-net-listener-port = čtení storage SCP listener port
error-net-local-aes-empty = local_aes musí obsahovat alespoň jedno AE pro spuštění Storage SCP
error-net-locating-dataset = vyhledávání datasetu v { $path }
error-net-malformed-dimse = malformed { $operation } DIMSE response: { $details }; nápověda: peer sent an neplatné or neočekávané DIMSE command set
error-net-missing-affected-sop = chybí { $operation } affected SOP class UID
error-net-missing-command-field = chybí command field
error-net-missing-cstore-rsp-command-field = chybí C-STORE response command field
error-net-missing-cstore-rsp-status = chybí C-STORE response status
error-net-missing-destination = chybí C-MOVE destination
error-net-missing-dicm = chybí Part 10 DICM marker
error-net-missing-message-id = chybí { $operation } message id
error-net-missing-qr-level = { $operation } identifier is chybí QueryRetrieveLevel
error-net-missing-required-command-field = chybí required command field { $name } ({ $tag })
error-net-missing-status = chybí { $operation } status
error-net-move-destination-unresolved = move_destination se nepodařilo vyřešit
error-net-no-cget-store-context = žádný sjednaný prezentační kontext úložiště C-GET pro SOP Class { $sop } a transfer syntax { $syntax }
error-net-no-compatible-context = { $path }: žádný kompatibilní sjednaný prezentační kontext pro zdrojovou transfer syntax { $syntax }
error-net-no-dimse-provider = není registrován poskytovatel DIMSE pro příkaz 0x{ $command } a abstraktní syntax { $syntax }
error-net-no-presentation-context = žádný sjednaný prezentační kontext
error-net-no-presentation-context-for-file = { $path }: žádný sjednaný prezentační kontext
error-net-no-presentation-context-id = chybí negotiated presentation context { $id }
error-net-opening-path = otevírání { $path }
error-net-part10-preamble = čtení Part 10 preamble
error-net-path-error = { $path }: { $err }
error-net-pdata-feed-complete = cannot feed P-DATA fragment into a complete accumulator (chybí take())
error-net-peer-aborted = protějšek přerušil asociaci během dílčí operace C-GET C-STORE: { $source }
error-net-peer-socket = čtení storage SCP peer socket address
error-net-reading-command-dataset = čtení command dataset
error-net-reading-identifier = čtení { $operation } identifier
error-net-reading-incoming-dataset = čtení incoming C-STORE dataset
error-net-reading-response-dataset = čtení { $operation } response dataset
error-net-remote-aborted = vzdálená strana přerušila asociaci: { $source }
error-net-restoring-read-timeout = obnovení timeoutu čtení association
error-net-restoring-write-timeout = obnovení timeoutu zápisu association
error-net-rewinding-dataset = přetáčení na první prvek datasetu
error-net-scp-thread-panicked = vlákno Storage SCP zkolabovalo
error-net-seeking-temp-dataset = posun v dočasném souboru datasetu
error-net-serializing-cget-dataset = serializace datasetu dílčí operace C-GET pro { $path }
error-net-serializing-dataset = serializace datasetu pro { $path } s transfer syntax { $syntax }
error-net-setting-socket-blocking = nastavení přijatého úložného socketu do blokujícího režimu
error-net-sending-buffered-dataset = odesílání vyrovnaného datasetu pro { $path }
error-net-store-status = vzdálená strana vrátila stav C-STORE 0x{ $status } ({ $meaning }){ $hint }
error-net-streaming-dataset = streamování datasetu C-STORE
error-net-unexpected-command-field = neočekávané CommandField 0x{ $actual } (expected 0x{ $expected } for { $rsp })
error-net-unexpected-dataset-fragment = neočekávané dataset fragment in C-STORE response
error-net-unexpected-pdu = neočekávané PDU during { $operation }: { $pdu }
error-net-unknown-status = neplatné { $operation } status 0x{ $status }
error-net-unsupported-model-sop = nepodporováno { $operation } model SOP class UID: { $uid }
error-net-unsupported-qr-level = nepodporováno QueryRetrieveLevel: { $level }
error-net-unsupported-transfer-syntax = nepodporováno negotiated transfer syntax
error-net-writing-command-dataset = zápis command dataset
error-net-writing-identifier = zápis { $operation } identifier
error-net-writing-path = zápis { $path }
error-net-writing-response-dataset = zápis { $operation } response dataset
error-net-writing-temp-dataset = zápis dataset bytes to temp file
error-node-host-empty = hostitel uzlu nesmí být prázdný
error-node-name-empty = název uzlu nesmí být prázdný
error-node-not-found = vzdálený uzel nenalezen: { $id }
error-operation-cancelled = operace zrušena
error-port-invalid = neplatný port: { $value }
error-port-range = port musí být mezi 1 a 65535
error-query-no-study-uid = Shoda nemá StudyInstanceUID; nelze načíst.
error-query-unsupported-level = nepodporovaná úroveň dotazu: { $value }
error-query-unsupported-model = nepodporovaný model dotazu: { $value }
error-retrieve-canceled = načtení bylo zrušeno vzdáleným uzlem (status=0x{ $status }, completed={ $completed }, failed={ $failed }, warning={ $warning }, remaining={ $remaining }, { $scp })
error-retrieve-failed = načtení selhalo se status=0x{ $status } (completed={ $completed }, failed={ $failed }, warning={ $warning }, remaining={ $remaining }, { $scp })
error-retrieve-nothing-arrived = načtení skončilo pro cíl { $destination } s completed={ $completed }, ale do lokálního storage SCP nic nedorazilo ({ $scp }). Zkontrolujte mapování AE nebo špatný port: ověřte, že { $listener } je volný a že vzdálený uzel mapuje AE { $destination } na tuto aplikaci
error-send-no-files-series = žádné lokální soubory indexované pro sérii { $uid }
error-send-no-files-study = žádné lokální soubory indexované pro studii { $uid }
error-task-cancelled = Úloha zrušena
error-task-none-to-cancel = Žádná aktivní úloha ke zrušení (nic neběží)
error-tracing-init = inicializace tracing subscriber: { $err }
error-uid-component-numeric = Komponenta UID '{ $part }' musí být číselná
error-uid-component-too-long = Komponenta UID '{ $part }' je příliš dlouhá
error-uid-dot-ends = UID nesmí začínat ani končit tečkou
error-uid-empty = UID nesmí být prázdné
error-uid-empty-component = UID nesmí obsahovat prázdné komponenty
error-uid-leading-zeros = Komponenta UID '{ $part }' nesmí mít úvodní nuly
error-uid-too-long = UID smí mít nejvýše 64 znaků

## TUI
tui-bool-no = ne
tui-bool-off = vypnuto
tui-bool-on = zapnuto
tui-bool-yes = ano
tui-command-placeholder = Zadejte příkaz nebo použijte zkratky panelu.
tui-config-ae-title = AE title: { $value }
tui-config-edit-hint = Stiskněte Tab pro fokus tohoto panelu a poté 'c' pro úpravu.
tui-config-hint = Stiskněte Tab pro fokus tohoto panelu a poté 'c' pro úpravu.
tui-config-listener = Posluchač: { $value }
tui-config-max-pdu = max_pdu_length: { $value }
tui-config-promiscuous = allow_promiscuous_storage: { $value }
tui-config-strict-pdu = strict_pdu: { $value }
tui-config-ts-pref = Preference TS: { $value }
tui-controls-hint = Tab pole · Enter potvrdí · Esc zruší
tui-detail-ae-title = AE title
tui-detail-instance = Detail instance
tui-detail-name = Název
tui-detail-node = Detail uzlu
tui-detail-placeholder-followup = Přepněte fokus na seznamový panel a posuňte výběr, aby se tento pohled aktualizoval.
tui-detail-query = Detail výsledku dotazu
tui-detail-select-node = Vyberte vzdálený uzel pro kontrolu metadat.
tui-detail-series = Detail série
tui-detail-study = Detail studie
tui-empty-command-placeholder = Zadejte příkaz nebo použijte zkratky panelu.
tui-empty-detail-instance = Vyberte instanci ke kontrole, nebo se klávesou Esc vraťte k sériím.
tui-empty-detail-node = Vyberte vzdálený uzel pro kontrolu metadat.
tui-empty-detail-query = Vyberte výsledek dotazu pro kontrolu metadat a kontextu retrieve.
tui-empty-detail-series = Vyberte sérii ke kontrole, nebo se klávesou Esc vraťte k vyšetřením.
tui-empty-detail-study = Vyberte místní vyšetření pro kontrolu metadat pacienta a sérií.
tui-empty-instances = Pro tuto sérii nejsou k dispozici žádné indexované instance.
tui-empty-instances-hint = Stiskněte Esc pro návrat k sériím.
tui-empty-local-instances = Pro tuto sérii nejsou k dispozici žádné indexované instance.
tui-empty-local-instances-hint = Stiskněte Esc pro návrat k sériím.
tui-empty-local-series = Pro tuto studii nejsou k dispozici žádné indexované série.
tui-empty-local-series-hint = Stiskněte Esc pro návrat k lokálním studiím.
tui-empty-local-studies = Zatím nejsou k dispozici žádné indexované studie.
tui-empty-local-studies-cmd = Příklad: import path=/data/inbox
tui-empty-local-studies-hint = Nejprve importujte lokální soubory DICOM.
tui-empty-no-name = <bez názvu>
tui-empty-query = Zatím nebyl spuštěn žádný dotaz.
tui-empty-query-body =
    Vyberte vzdálený uzel a stiskněte 'f' pro dotaz.
    Nebo: query node=pacs
        patient_name="DOE^JOHN"
    Stiskněte 'm' na vybraném výsledku pro otevření retrieve.
tui-empty-query-cmd = Nebo: query node=pacs
tui-empty-query-hint = Vyberte vzdálený uzel a stiskněte 'f' pro dotaz.
tui-empty-query-last-target = Poslední cíl dotazu: { $name }
tui-empty-query-none = Zatím nebyl spuštěn žádný dotaz.
tui-empty-query-retrieve-hint = Stiskněte 'm' na vybraném výsledku pro otevření retrieve.
tui-empty-remote-nodes = Zatím nejsou uložené žádné vzdálené uzly.
tui-empty-remote-nodes-cmd = Nebo: node add name=pacs
tui-empty-remote-nodes-hint = V tomto panelu stiskněte 'a' a přidejte jeden.
tui-empty-series = Pro tuto studii nejsou k dispozici žádné indexované série.
tui-empty-series-hint = Stiskněte Esc pro návrat k lokálním studiím.
tui-empty-studies = Zatím nejsou k dispozici žádné indexované studie.
tui-empty-studies-hint = Nejprve importujte lokální soubory DICOM.
tui-empty-tasks-history = Žádná historie úloh.
tui-empty-tasks-queued = Žádné úlohy ve frontě.
tui-fallback-no-name = <bez názvu>
tui-field-accession = Přístupové číslo
tui-field-ae-title = AE title
tui-field-bind-addr = Bind adresa
tui-field-date-from = Datum od
tui-field-date-to = Datum do
tui-field-destination-node = Cílový uzel
tui-field-host = Hostitel
tui-field-instance-uid = Instance UID
tui-field-kind = Typ
tui-field-level = Úroveň
tui-field-local-ae = Lokální AE
tui-field-max-pdu = Max. PDU
tui-field-modality = Modalita
tui-field-model = model
tui-field-move-destination = Cíl Move
tui-field-name = Název
tui-field-notes = Poznámky
tui-field-path = Cesta
tui-field-patient-id = ID pacienta
tui-field-patient-name = Jméno pacienta
tui-field-port = číslo portu
tui-field-promiscuous = Promiskuitní
tui-field-series-uid = Series UID
tui-field-sop-uid = SOP Instance UID
tui-field-strict-pdu = Striktní PDU
tui-field-study-description = Popis studie
tui-field-study-uid = Study UID
tui-footer-back-series = Esc zpět k sériím
tui-footer-back-studies = Esc zpět ke studiím
tui-footer-cancel-task = c zrušit
tui-footer-edit-config = c upravit config
tui-footer-enter-series = Enter série
tui-footer-esc-series = Esc zpět k sériím
tui-footer-esc-studies = Esc zpět ke studiím
tui-footer-help = F1/? nápověda
tui-footer-inspect = Enter prohlédnout
tui-footer-next = Další: { $text }
tui-footer-nodes = a/e/d/f uzly
tui-footer-panes = Tab panely
tui-footer-queued =
    { $n ->
        [one] { $n } ve frontě
        [few] { $n } ve frontě
        [many] { $n } ve frontě
       *[other] { $n } ve frontě
    }
tui-footer-quit = q konec
tui-footer-refresh = r obnovit
tui-footer-retrieve = m načíst
tui-footer-run-command = Enter spustit příkaz
tui-footer-task-scope = t fronta/historie
tui-form-add-node = Přidat vzdálený uzel
tui-form-add-remote-node = Přidat vzdálený uzel
tui-form-delete-confirm = Smazat vzdálený uzel { $name } [{ $ae }] na { $host }:{ $port }?
tui-form-delete-node = Odstranit vzdálený uzel
tui-form-delete-remote-node = Odstranit vzdálený uzel
tui-form-edit-node = Upravit vzdálený uzel
tui-form-edit-remote-node = Upravit vzdálený uzel
tui-form-err-ae-required = ! AE title je povinný
tui-form-err-bind-required = ! bind adresa je povinná
tui-form-err-host-required = ! hostitel je povinný
tui-form-err-local-ae-invalid = ! neplatný lokální AE title: { $err }
tui-form-err-local-ae-required = ! lokální AE title je povinný
tui-form-err-modality-empty = modalita nesmí být prázdná
tui-form-err-move-dest-invalid = ! neplatný cílový AE title pro Move: { $err }
tui-form-err-name-required = ! název uzlu je povinný
tui-form-err-port-required = ! port je povinný
tui-form-err-uid-empty = UID nesmí být prázdné
tui-form-err-uid-empty-component = UID nesmí obsahovat prázdné komponenty
tui-form-error-line = Chyba: { $error }
tui-form-field-accession = Přístupové číslo
tui-form-field-ae-title = AE title
tui-form-field-bind-addr = Bind adresa
tui-form-field-date-from = Datum od
tui-form-field-date-to = Datum do
tui-form-field-dest-node = Cílový uzel
tui-form-field-destination = Cílové AE
tui-form-field-host = Hostitel
tui-form-field-instance-uid = SOP Instance UID
tui-form-field-kind = Typ
tui-form-field-level = Úroveň
tui-form-field-local-ae = Lokální AE
tui-form-field-modality = Modalita
tui-form-field-model = model
tui-form-field-move-dest = Cíl Move
tui-form-field-name = Název
tui-form-field-notes = Poznámky
tui-form-field-path = Cesta
tui-form-field-patient-id = ID pacienta
tui-form-field-patient-name = Jméno pacienta
tui-form-field-port = číslo portu
tui-form-field-series-uid = Series Instance UID
tui-form-field-sop-uid = SOP Instance UID
tui-form-field-study-desc = Popis studie
tui-form-field-study-uid = Study Instance UID
tui-form-field-uid = UID
tui-form-hint-bind = nápověda: obvykle 0.0.0.0 (všechna rozhraní) nebo 127.0.0.1
tui-form-hint-local-ae = nápověda: nejvýše 16 znaků (A-Z, 0-9, mezera), např. ARCHIVE_AE
tui-form-hint-move-dest = nápověda: volitelné; přepíše cílové AE title pro C-MOVE
tui-form-hint-name = nápověda: krátký štítek (např. PACS)
tui-form-import = Importovat lokální soubory
tui-form-import-local = Importovat lokální soubory
tui-form-import-local-files = Importovat lokální soubory
tui-form-mode-add = vytvořit nový vzdálený uzel
tui-form-mode-edit = aktualizovat vybraný vzdálený uzel
tui-form-query-node = Dotázat vzdálený uzel
tui-form-query-remote-node = Dotázat vzdálený uzel
tui-form-remote-node-line = Vzdálený uzel: { $name } [{ $ae }] { $host }:{ $port }
tui-form-retrieve = Načíst shody
tui-form-retrieve-matches = Načíst shody
tui-form-send-series = Odeslat sérii
tui-form-send-study = Odeslat studii
tui-form-storage-intro = Upravte místní nastavení Storage SCP (uloženo do config.json).
tui-form-storage-scp = Nastavení Storage SCP
tui-form-storage-scp-settings = Nastavení Storage SCP
tui-help-ae-title = AE title: { $value }
tui-help-aedf = a/e/d/f     Přidat, upravit, smazat nebo dotazovat z vybraného uzlu
tui-help-c = c           Upravit Storage SCP (když je fokus na panelu Config)
tui-help-canonical-names = Kanonická jména odpovídají CLI příznakům bez '--', s podtržítky.
tui-help-close = Nápovědu zavřete Esc, F1 nebo ?.
tui-help-common-commands = Běžné příkazy
tui-help-config = c           Upravit Storage SCP (když je fokus na panelu Config)
tui-help-config-path = Cesta config: { $value }
tui-help-current-config = Aktuální konfigurace
tui-help-data-dir = Datový adresář: { $value }
tui-help-enter-default = Enter       Spustit příkaz, odeslat aktivní modal nebo otevřít série z Lokálních studií
tui-help-enter-instance = Enter       V zobrazení instancí žádná akce panelu Local
tui-help-enter-local-instance = Enter       V zobrazení instancí žádná akce panelu Local
tui-help-enter-local-series = Enter       Otevřít instance vybrané lokální série, nebo spustit příkaz / odeslat aktivní modal
tui-help-enter-local-study = Enter       Otevřít série vybrané lokální studie, nebo spustit příkaz / odeslat aktivní modal
tui-help-enter-series = Enter       Otevřít instance vybrané lokální série, nebo spustit příkaz / odeslat aktivní modal
tui-help-enter-study = Enter       Otevřít série vybrané lokální studie, nebo spustit příkaz / odeslat aktivní modal
tui-help-esc-default = Esc         Zavřít nápovědu/modal, vrátit se z lokálních sérií, nebo vrátit fokus na příkaz
tui-help-esc-instance = Esc         Vrátit se z lokálních instancí k sériím, zavřít nápovědu/modal, nebo vrátit fokus na příkaz
tui-help-esc-instances = Esc         Vrátit se z lokálních instancí k sériím, zavřít nápovědu/modal, nebo vrátit fokus na příkaz
tui-help-esc-series = Esc         Vrátit se z lokálních sérií ke studiím, zavřít nápovědu/modal, nebo vrátit fokus na příkaz
tui-help-f1 = F1 nebo ?     Otevřít nápovědu
tui-help-import-send = i/s         Importovat lokální soubory nebo odeslat vybranou studii/sérii
tui-help-is = i/s         Importovat lokální soubory nebo odeslat vybranou studii/sérii
tui-help-listener = Posluchač: { $value }
tui-help-log-dir = Adresář logů: { $value }
tui-help-m = m           Načíst z vybraného výsledku dotazu
tui-help-max-pdu = max_pdu_length: { $value }
tui-help-move = Up/Down nebo j/k   Posunout výběr v seznamových panelech
tui-help-nodes = a/e/d/f     Přidat, upravit, smazat nebo dotazovat z vybraného uzlu
tui-help-open = F1 nebo ?     Otevřít nápovědu
tui-help-promiscuous = allow_promiscuous_storage: { $value }
tui-help-q = q           Ukončit, když není aktivní modal a fokus není v příkazovém řádku
tui-help-quit = q           Ukončit, když není aktivní modal a fokus není v příkazovém řádku
tui-help-r = r           Obnovit panely, když fokus není v příkazovém řádku
tui-help-receiver-mode = Režim přijímače: { $value }
tui-receiver-mode-on-demand = na vyžádání pro místní retrieve
tui-receiver-mode-standalone = samostatný přes storage-scp
tui-help-refresh = r           Obnovit panely, když fokus není v příkazovém řádku
tui-help-retrieve = m           Načíst z vybraného výsledku dotazu
tui-help-strict-pdu = strict_pdu: { $value }
tui-help-tab = Tab / Shift-Tab  Změnit fokusovaný panel
tui-help-title = Klávesové zkratky
tui-help-ts-pref = preferred_store_transfer_syntax: { $value }
tui-help-updown = Up/Down nebo j/k   Posunout výběr v seznamových panelech
tui-input-placeholder = Zadejte příkaz nebo použijte zkratky panelu.
tui-log-command = > { $command }
tui-log-error = chyba: { $error }
tui-log-refreshed = obnoveno
tui-logs-capped-suffix = omezeno
tui-logs-label = Protokoly:
tui-pane-command = Příkaz
tui-pane-config = Konfigurace
tui-pane-detail = detail
tui-pane-detail-hint = { $title } (PgUp/PgDn když nepíšete)
tui-pane-help = Nápověda
tui-pane-instance-detail = Detail instance
tui-pane-instances-for = Instance pro: { $uid }
tui-pane-local-studies = Lokální studie
tui-pane-logs = Logy ({ $shown }/{ $total }{ $capped })
tui-pane-logs-capped = Protokoly ({ $shown }/{ $total } capped)
tui-pane-logs-uncapped = Protokoly ({ $shown }/{ $total })
tui-pane-node-detail = Detail uzlu
tui-pane-query-detail = Detail výsledku dotazu
tui-pane-query-node = Dotaz na uzel
tui-pane-query-result-detail = Detail výsledku dotazu
tui-pane-query-results = Výsledky dotazu / načtení
tui-pane-query-retrieve-results = Výsledky dotazu / načtení
tui-pane-remote-nodes = Vzdálené uzly
tui-pane-series-detail = Detail série
tui-pane-series-for = Série pro: { $uid }
tui-pane-series-unknown = Série pro: <neznámá studie>
tui-pane-study-detail = Detail studie
tui-pane-task-details = Detail úlohy
tui-pane-tasks-history = Úlohy (historie)
tui-pane-tasks-queued = Úlohy (fronta)
tui-pane-unknown-series = <neznámá série>
tui-pane-unknown-study = Série pro: <neznámá studie>
tui-row-inst = inst
tui-status-cancel-requested = Zrušitlation requested
tui-status-config = Konfigurace
tui-status-configured-listener = Nakonfigurován posluchač { $addr } jako AE { $ae } ({ $mode })
tui-status-data = data
tui-status-failure = selhání: { $failure }
tui-status-listener = Posluchač
tui-status-local-ae = Lokální AE
tui-status-mode = Režim
tui-status-mode-on-demand = na vyžádání
tui-status-mode-standalone = samostatný
tui-status-no-active-task = Žádná aktivní úloha ke zrušení (nic neběží)
tui-status-pdu = PDU
tui-status-promiscuous = Promiskuitní
tui-status-query-before-retrieve = Nejprve spusťte dotaz na vzdálený uzel, aby načtení vědělo, který uzel použít
tui-status-query-failed = dotaz selhal: { $error }
tui-status-queued-op = Zařazená operace: { $op }
tui-status-retrieve-failed = načtení selhalo: { $error }
tui-status-retrieve-open-failed = nelze otevřít proud načtení: { $error }
tui-status-saved-node = uložen uzel { $name } ({ $id })
tui-status-saved-scp = Nastavení Storage SCP uloženo (je nutný restart)
tui-status-select-node = nejprve vyberte vzdálený uzel
tui-status-select-query = nejprve vyberte výsledek dotazu
tui-status-select-study = nejprve vyberte lokální studii
tui-status-strict = Striktní
tui-status-task-cancelled = Úloha zrušena
tui-status-task-cancelled-detail = Úloha zrušena: { $other }
tui-status-ts-pref = Pref. TS
tui-status-updated-node = aktualizován uzel { $name } ({ $id })
tui-suggest-back-series = Esc — zpět k sériím
tui-suggest-edit-config = c — upravit config
tui-suggest-help = F1/? — nápověda
tui-suggest-inspect-task = Enter — prohlédnout úlohu
tui-suggest-node-add = node add <ae-title> <host:port>
tui-suggest-query = f — dotaz na uzel
tui-suggest-query-node = f — dotaz na vybraný uzel
tui-suggest-retrieve = m — načíst vybrané
tui-suggest-run-command = Enter — spustit příkaz
tui-suggest-send-series = s — odeslat vybranou sérii
tui-suggest-view-series = Enter — zobrazit série
tui-task-cancelled = Zrušeno
tui-task-cancelling = Ruší se
tui-task-failed = Selhalo
tui-task-failed-generic = Úloha selhala: { $error }
tui-task-import-done = Importovat complete: { $report }
tui-task-import-failed = Import selhal: { $error }
tui-task-importing = Importuji { $path }...
tui-task-query-done =
    Dotaz dokončen: { $count ->
        [one] { $count } shoda
        [few] { $count } shody
        [many] { $count } shod
       *[other] { $count } shod
    }
tui-task-query-failed = Dotaz selhal: { $error }
tui-task-querying = Dotazuji { $node }...
tui-task-queued = Ve frontě
tui-task-retrieve-done = Načtení dokončeno: { $outcome }
tui-task-retrieve-failed = Načtení selhalo: { $error }
tui-task-retrieving = Načítám z { $node }...
tui-task-running = Běží
tui-task-sending-series = Odesílám sérii { $uid } na { $node }...
tui-task-sending-study = Odesílám studii { $uid } na { $node }...
tui-task-send-done = Odeslání dokončeno: { $outcome }
tui-task-status-cancelled = zrušeno
tui-task-status-cancelling = ruší se
tui-task-status-failed = selhalo
tui-task-status-ok = ok
tui-task-status-queued = ve frontě
tui-task-status-running = běží
tui-task-succeeded = Úspěch
tui-terminal-too-small = Terminál je příliš malý – změňte velikost

## Desktop
desktop-action-activity = Aktivita { $count }
desktop-action-activity-empty = Aktivita
desktop-action-import = import
desktop-action-inspect-archive = Zkontrolovat místní archiv
desktop-action-inspect-archive-desc = Prohlédněte vyšetření, série a instance, poté odešlete nebo exportujte.
desktop-action-manage-peers = Spravovat peery
desktop-action-manage-peers-desc = Přidejte a upravte uzly PACS nebo stanic pro query, retrieve a store.
desktop-action-monitor-scp = Sledovat Storage SCP
desktop-action-query = Dotaz
desktop-action-refresh = Obnovit stav
desktop-action-refresh-status = Obnovit stav
desktop-action-reveal-log = Zobrazit soubor logu
desktop-action-send = Odeslat
desktop-action-start-scp = Spustit Storage SCP
desktop-activity-empty = Zatím žádná aktivita relace.
desktop-activity-title = Aktivita
desktop-app-title = DICOM Node
desktop-archive-csv = CSV
desktop-archive-details = Podrobnosti
desktop-archive-empty = Lokální archiv je prázdný.
desktop-archive-export-fail = Export { $scope } selhal
desktop-archive-export-ok =
    { $rows ->
        [one] Exportován { $rows } řádek { $scope } do { $path }.
       *[other] Exportováno { $rows } řádků { $scope } do { $path }.
    }
desktop-archive-export-studies = Exportovat studie
desktop-archive-export-title = Exportovat { $scope }
desktop-archive-filter = Filtrovat podle pacienta, UID, popisu, modality…
desktop-archive-filter-placeholder = Filtrovat podle pacienta, UID, popisu, modality…
desktop-archive-inst-abbrev =
    { $count ->
        [one] { $count } inst.
        [few] { $count } inst.
        [many] { $count } inst.
       *[other] { $count } inst.
    }
desktop-archive-instance-meta = { $bytes } · TS { $ts } · importováno { $imported }
desktop-archive-instances = Instance
desktop-archive-instances-heading = Instance
desktop-archive-json = JSON
desktop-archive-loading = Načítání studií…
desktop-archive-no-filter-match = Žádné studie neodpovídají filtru.
desktop-archive-no-instances = Nebyly nalezeny žádné instance.
desktop-archive-no-match = Žádné studie neodpovídají filtru.
desktop-archive-no-nodes = Žádné uzly
desktop-archive-no-series = Nebyly nalezeny žádné série.
desktop-archive-reveal-file = Zobrazit soubor
desktop-archive-select-series = Vyberte sérii.
desktop-archive-select-study = Vyberte studii.
desktop-archive-send-fail = { $label }: { $sent }/{ $attempted } odesláno, { $failed } selhalo. { $failures }
desktop-archive-send-fail-title = { $label } selhalo
desktop-archive-send-ok = { $label }: odesláno { $sent }/{ $attempted } instancí.
desktop-archive-send-series = Odeslat sérii
desktop-archive-send-series-label = Série → { $destination }
desktop-archive-send-study = Odeslat studii
desktop-archive-send-study-label = Studie → { $destination }
desktop-archive-send-to = Odeslat na
desktop-archive-series = Série
desktop-archive-series-count =
    #{ $number } · { $count ->
        [one] { $count } instance
       *[other] { $count } instancí
    }
desktop-archive-series-fallback = Série
desktop-archive-studies = Studie
desktop-archive-study-date = Datum studie
desktop-archive-study-uid = Study UID
desktop-archive-subtitle = Inventář studií, sérií a instancí z lokálního archivu SQLite.
desktop-archive-title = Lokální archiv
desktop-brand-title = DICOM Node
desktop-col-description = Popis
desktop-col-instances = Instance
desktop-col-modalities = Modality
desktop-col-patient-id = ID pacienta
desktop-common-cancel = Zrušit
desktop-common-clear = Vymazat
desktop-common-disabled = vypnuto
desktop-common-enabled = zapnuto
desktop-common-loading = Načítání…
desktop-common-no = ne
desktop-common-refresh = Obnovit
desktop-common-yes = ano
desktop-counter-assoc-accepted = Přijaté asociace
desktop-counter-bytes-ingested = Přijaté bajty
desktop-counter-cfind-requests = Požadavky C-FIND
desktop-counter-cmove-requests = Požadavky C-MOVE
desktop-counter-cstore-failed = C-STORE selhalo
desktop-counter-cstore-stored = C-STORE uloženo
desktop-dashboard-counter-assoc-accepted = Přijaté asociace
desktop-dashboard-counter-bytes-ingested = Přijaté bajty
desktop-dashboard-counter-c-find-requests = Požadavky C-FIND
desktop-dashboard-counter-c-move-requests = Požadavky C-MOVE
desktop-dashboard-counter-c-store-failed = C-STORE selhalo
desktop-dashboard-counter-c-store-stored = C-STORE uloženo
desktop-dashboard-empty-studies = Zatím žádné lokální studie.
desktop-dashboard-inspect-archive-body = Prohlédněte studie, sestupte do sérií a instancí, poté odešlete nebo exportujte.
desktop-dashboard-inspect-archive-title = Prohlédnout lokální archiv
desktop-dashboard-kv-ae-title = Titul AE
desktop-dashboard-kv-data-dir = Datový adresář
desktop-dashboard-kv-listener = Posluchač
desktop-dashboard-kv-log-file = Soubor logu
desktop-dashboard-kv-max-pdu = Max. PDU
desktop-dashboard-kv-promiscuous = Promiskuitní úložiště
desktop-dashboard-kv-server = server
desktop-dashboard-kv-store-syntax = Syntaxe store
desktop-dashboard-kv-strict-pdu = Přísné PDU
desktop-dashboard-listener-missing = Listener ještě není načten.
desktop-dashboard-live-counters = Živé čítače
desktop-dashboard-loading-metrics = Načítání metrik…
desktop-dashboard-loading-status = Načítání lokálního stavu…
desktop-dashboard-loading-studies = Načítání studií…
desktop-dashboard-local-node = Lokální uzel
desktop-dashboard-manage-peers-body = Přidávejte a upravujte uzly PACS nebo stanic pro dotaz, načtení a store.
desktop-dashboard-manage-peers-title = Spravovat peery
desktop-dashboard-metric-instances = Instance
desktop-dashboard-metric-nodes = Vzdálené uzly
desktop-dashboard-metric-series = Série
desktop-dashboard-metric-studies = Studie
desktop-dashboard-monitor-scp = Sledovat Storage SCP
desktop-dashboard-recent-studies = Nedávné studie
desktop-dashboard-start-scp = Spustit Storage SCP
desktop-dashboard-subtitle = Lokální archiv, síťové uzly a aktivita SCP na jednom místě.
desktop-dashboard-title = Operátorský přehled
desktop-doc-title = DICOM Node
desktop-import-accepted = Přijato
desktop-import-accepted-bytes = Přijaté bajty
desktop-import-activity-detail = { $accepted }/{ $scanned } přijato, { $duplicates } duplikátů, { $bytes }
desktop-import-activity-fail = Import selhal
desktop-import-activity-ok = Import dokončen
desktop-import-choose-archive = Vyberte ZIP archiv k importu
desktop-import-choose-dir = Vyberte adresář k importu
desktop-import-choose-folder = Složka
desktop-import-choose-zip = Vyberte ZIP archiv k importu
desktop-import-cleanup = Úklid
desktop-import-clear-path = Vymazat cestu
desktop-import-complete = Import dokončen
desktop-import-dup-sha = SHA-256
desktop-import-dup-sop = SOP UID
desktop-import-dup-total = Celkem
desktop-import-duplicates = Duplikáty
desktop-import-failed = Import selhal
desktop-import-failed-cleanup = Úklid selhal
desktop-import-failures = Selhání
desktop-import-failures-heading =
    { $count ->
        [one] { $count } selhání:
       *[other] { $count } selhání:
    }
desktop-import-failures-more = … a dalších { $count }
desktop-import-files-progress = { $label } souborů
desktop-import-folder = Složka
desktop-import-invalid-dicom = Neplatné DICOM
desktop-import-pick-dir = Vyberte adresář k importu
desktop-import-pick-zip = Vyberte ZIP archiv k importu
desktop-import-placeholder = /path/to/dicom-folder or /path/to/archive.zip
desktop-import-rejected = Odmítnuto
desktop-import-report = Zpráva o importu
desktop-import-running = Importuji…
desktop-import-scanned = Prohledáno
desktop-import-skipped = Přeskočeno
desktop-import-source = Zdroj
desktop-import-start = Spustit import
desktop-import-stored = Uloženo
desktop-import-subtitle = Indexujte soubory DICOM z rekurzivních složek nebo ZIP archivů do spravovaného lokálního archivu.
desktop-import-title = import
desktop-import-unreadable = Nečitelné
desktop-import-zip = ZIP
desktop-import-zip-filter = ZIP archivy
desktop-lang-label = Jazyk
desktop-listener-not-loaded = Listener ještě není načten.
desktop-live-counters = Živé čítače
desktop-loading = Načítání
desktop-loading-local-status = Načítání lokálního stavu…
desktop-loading-metrics = Načítání metrik…
desktop-loading-studies = Načítání studií…
desktop-local-node = Lokální uzel
desktop-locale-label = Jazyk
desktop-logs-activity-detail =
    { $count ->
        [one] { $count } řádek načten
       *[other] { $count } řádků načteno
    }
desktop-logs-activity-fail = Obnovení logu selhalo
desktop-logs-activity-ok = Log obnoven
desktop-logs-auto = AUTO-LÄGE
desktop-logs-auto-refresh = Automatické obnovení
desktop-logs-empty = Soubor logu je prázdný.
desktop-logs-found = SOUBOR LOGU NALEZEN
desktop-logs-lines =
    { $count ->
        [one] { $count } řádek
        [few] { $count } řádky
        [many] { $count } řádků
       *[other] { $count } řádků
    }
desktop-logs-loading = Načítání logu…
desktop-logs-missing = Aktivní soubor logu ještě nebyl vytvořen.
desktop-logs-refresh-failed = Obnovení logu selhalo
desktop-logs-refreshed = Log obnoven
desktop-logs-reveal = Zobrazit
desktop-logs-subtitle = Omezený konec aktivního souboru logu plochy.
desktop-logs-tail = Konec
desktop-logs-title = Logy
desktop-logs-truncated = ZKRÁCENO
desktop-logs-waiting = ČEKÁNÍ NA SOUBOR LOGU
desktop-metric-instances = Instance
desktop-metric-remote-nodes = Vzdálené uzly
desktop-metric-series = Série
desktop-metric-studies = Studie
desktop-nav-archive = Lokální archiv
desktop-nav-dashboard = Přehled
desktop-nav-import = import
desktop-nav-logs = Logy
desktop-nav-network = Síť
desktop-nav-nodes = Vzdálené uzly
desktop-nav-query = Dotaz / Načtení
desktop-nav-server = Úložný server
desktop-no-local-studies = Zatím žádné lokální studie.
desktop-nodes-add = Přidat uzel
desktop-nodes-added = Přidán uzel „{ $name }“.
desktop-nodes-ae-length = Titul AE smí mít nejvýše 16 znaků.
desktop-nodes-ae-title = Titul AE
desktop-nodes-col-move = Cíl Move
desktop-nodes-configured = Nakonfigurované uzly
desktop-nodes-confirm-delete = Odstranit uzel „{ $name }“?
desktop-nodes-default-port = Výchozí port 104
desktop-nodes-delete = Odstranit uzel
desktop-nodes-delete-title = Odstranit uzel
desktop-nodes-deleted = Odstraněn uzel „{ $name }“.
desktop-nodes-edit = Upravit uzel
desktop-nodes-edit-title = Upravit uzel
desktop-nodes-empty = Zatím žádné vzdálené uzly.
desktop-nodes-err-ae = Titul AE je povinný.
desktop-nodes-err-ae-len = Titul AE smí mít nejvýše 16 znaků.
desktop-nodes-err-host = Host je povinný.
desktop-nodes-err-name = Název je povinný.
desktop-nodes-err-port = Port musí být 1–65535.
desktop-nodes-host = Hostitel
desktop-nodes-move-dest = Cíl Move
desktop-nodes-move-placeholder = Výchozí: lokální AE
desktop-nodes-name = Název
desktop-nodes-need-ae = Titul AE je povinný.
desktop-nodes-need-host = Hostitel je povinný.
desktop-nodes-need-name = Název je povinný.
desktop-nodes-notes = Poznámky
desktop-nodes-notes-placeholder = PACS popisovny
desktop-nodes-placeholder-ae = PACS01
desktop-nodes-placeholder-host = 192.168.0.10
desktop-nodes-placeholder-move = Výchozí: lokální AE
desktop-nodes-placeholder-name = main-pacs
desktop-nodes-placeholder-notes = PACS popisovny
desktop-nodes-port = číslo portu
desktop-nodes-port-104 = Výchozí port 104
desktop-nodes-port-range = Port musí být 1–65535.
desktop-nodes-save = Uložit změny
desktop-nodes-save-changes = Uložit změny
desktop-nodes-subtitle = Peery PACS a stanic pro dotaz, načtení a store.
desktop-nodes-summary = Souhrn uzlů
desktop-nodes-title = Vzdálené uzly
desktop-nodes-total = Celkem uzlů
desktop-nodes-updated = Aktualizován uzel „{ $name }“.
desktop-nodes-with-move = S cílem Move
desktop-promiscuous = Promiskuitní úložiště
desktop-query-accession = Accession č.
desktop-query-activity-detail = { $count } { $count ->
        [one] shoda
       *[other] shod
    } na úrovni { $level }
desktop-query-activity-fail = C-FIND { $node } selhalo
desktop-query-activity-ok = C-FIND { $node }
desktop-query-activity-title = C-FIND { $node }
desktop-query-clear = Vymazat
desktop-query-col-accession = accession
desktop-query-criteria = Kritéria hledání
desktop-query-date-from = Datum studie od
desktop-query-date-to = Datum studie do
desktop-query-kv-series-uid = Series UID
desktop-query-kv-sop-uid = SOP UID
desktop-query-kv-study-uid = Study UID
desktop-query-level = Úroveň
desktop-query-matches =
    { $count ->
        [one] { $count } shoda
       *[other] { $count } shod
    }
desktop-query-missing-study-uid = Shoda nemá StudyInstanceUID; nelze načíst.
desktop-query-modality = Modalita
desktop-query-no-matches = Žádné shody.
desktop-query-no-nodes = Žádné nakonfigurované uzly
desktop-query-patient-id = ID pacienta
desktop-query-patient-name = Jméno pacienta
desktop-query-placeholder-description = CHEST*
desktop-query-placeholder-modality = CT, MR, …
desktop-query-placeholder-name = DOE^JOHN or DOE*
desktop-query-placeholder-patient = DOE^JOHN or DOE*
desktop-query-querying = Dotazování…
desktop-query-remote-node = Vzdálený uzel
desktop-query-results = Výsledky
desktop-query-retrieve = Načíst
desktop-query-retrieve-activity-detail = completed={ $completed }, warning={ $warning }, failed={ $failed }
desktop-query-retrieve-activity-fail = C-MOVE { $node } selhalo
desktop-query-retrieve-activity-ok = C-MOVE { $node }
desktop-query-retrieve-finished = Načtení dokončeno: dokončeno { $completed }, varování { $warning }, selhalo { $failed }.
desktop-query-retrieve-selected = Načíst vybrané
desktop-query-run = Spustit C-FIND
desktop-query-run-select = Spusťte dotaz a vyberte shodu.
desktop-query-running = Dotazování…
desktop-query-search-criteria = Kritéria hledání
desktop-query-select-hint = Spusťte dotaz a vyberte shodu.
desktop-query-selected = Vybraná shoda
desktop-query-selected-match = Vybraná shoda
desktop-query-series-uid = Series Instance UID
desktop-query-sop-uid = SOP Instance UID
desktop-query-study-description = Popis studie
desktop-query-study-uid = Study Instance UID
desktop-query-subtitle = C-FIND na vzdálený uzel, zkontrolujte shody, poté C-MOVE do lokálního archivu.
desktop-query-title = Dotaz / Načtení
desktop-recent-studies = Nedávné studie
desktop-scp-listening = SCP naslouchá
desktop-scp-stopped = SCP zastaven
desktop-server-activity-fail = Řízení Storage SCP selhalo
desktop-server-activity-started = Storage SCP spuštěn
desktop-server-activity-started-detail = Listener spuštěn.
desktop-server-activity-stopped = Storage SCP zastaven
desktop-server-activity-stopped-detail = received={ $received }, stored={ $stored }, failed={ $failed }
desktop-server-activity-stopped-empty = Žádná aktivní relace.
desktop-server-addr-ae = { $addr } · AE { $ae }
desktop-server-assoc-accepted = Přijaté asociace
desktop-server-assoc-rejected = Odmítnuté asociace
desktop-server-cfind-req-matches = Požadavky / shody C-FIND
desktop-server-cget-requests = Požadavky C-GET
desktop-server-cmove-requests = Požadavky C-MOVE
desktop-server-cmove-subops = Podoperace C-MOVE dokončené / selhané
desktop-server-control-failed = Řízení Storage SCP selhalo
desktop-server-counter-bytes = Přijaté bajty
desktop-server-counter-failed = C-STORE selhalo
desktop-server-counter-find = Požadavky / shody C-FIND
desktop-server-counter-get = Požadavky C-GET
desktop-server-counter-move = Požadavky C-MOVE
desktop-server-counter-move-sub = Podoperace C-MOVE dokončené / selhané
desktop-server-counter-received = C-STORE přijato
desktop-server-counter-stored = C-STORE uloženo
desktop-server-cstore-failed = C-STORE selhalo
desktop-server-cstore-received = C-STORE přijato
desktop-server-cstore-stored = C-STORE uloženo
desktop-server-dimse = Čítače DIMSE
desktop-server-failed = Selhalo
desktop-server-health-loading = Načítání metrik
desktop-server-health-ready = Připraven na příchozí C-STORE
desktop-server-health-review = Zkontrolovat selhání
desktop-server-health-stopped = Zastaveno
desktop-server-listener-started = Listener spuštěn.
desktop-server-listening = NASLOUCHÁ
desktop-server-loading-metrics = Načítání metrik…
desktop-server-logs = Logy
desktop-server-no-session = Žádná aktivní relace.
desktop-server-rate = +{ $rate } / dotaz
desktop-server-ready = Připraven na příchozí C-STORE
desktop-server-review-failures = Zkontrolovat selhání
desktop-server-session-ended = Relace skončila: přijato { $received }, uloženo { $stored }, selhalo { $failed }.
desktop-server-start = Spustit server
desktop-server-started-title = Storage SCP spuštěn
desktop-server-stop = Zastavit server
desktop-server-stopped = ZASTAVENO
desktop-server-stopped-pill = ZASTAVENO
desktop-server-stopped-status = Zastaveno
desktop-server-stopped-title = Storage SCP zastaven
desktop-server-stored = Uloženo
desktop-server-subtitle = Samostatný Storage SCP pro příchozí C-STORE a indexaci lokálního archivu.
desktop-server-title = Úložný server
desktop-status-listening = naslouchá
desktop-status-loading = Načítání
desktop-status-scp-listening = SCP naslouchá
desktop-status-scp-stopped = SCP zastaven
desktop-status-stopped = zastaveno
desktop-store-syntax = Syntaxe store
desktop-strict-pdu = Přísné PDU
desktop-strip-pdu = PDU { $value }
desktop-table-accession = accession
desktop-table-ae-title = Titul AE
desktop-table-date = Datum
desktop-table-description = Popis
desktop-table-endpoint = Koncový bod
desktop-table-instances = Instance
desktop-table-modalities = Modality
desktop-table-modality = Modalita
desktop-table-move-dest = Cíl Move
desktop-table-name = Název
desktop-table-notes = Poznámky
desktop-table-patient = Pacient
desktop-table-patient-id = ID pacienta
desktop-table-series = Série
desktop-table-updated = Aktualizováno
desktop-title-refresh-status = Obnovit stav
desktop-title-reveal-log = Zobrazit soubor logu
ae = AE
patient-name =
    "DOE^JOHN"
    Stiskněte 'm' na vybraném výsledku pro otevření retrieve.
port = číslo portu

## Summary
summary-ae = AE
summary-counts = Počty
summary-criteria = Kritéria
summary-duration = Trvání
summary-duration-ms = { $ms }ms
summary-failures = Selhání:
summary-kind = Druh
summary-logs = Protokoly:
summary-peer = Protějšek
summary-status = Stav
summary-title = Souhrn operace
tui-detail-created = Vytvořeno

tui-form-hint-port-range = nápověda: číslo od 1 do 65535, např. 104
tui-form-hint-promiscuous = nápověda: povolit ukládání od libovolného volajícího AE title
tui-form-hint-strict-pdu = nápověda: vynutit kontroly velikosti PDU během asociací
tui-form-hint-max-pdu-bytes = nápověda: bajty, např. 16384
tui-form-limits-heading = Limits (bytes; blank/žádné = unlimited):
tui-form-field-max-file-import = Max. bajtů importu souboru
tui-form-field-max-zip-entry = Max. bajtů položky ZIP
tui-form-field-max-zip-total = Max. celkových bajtů ZIP
tui-form-field-max-zip-count = Max. počet položek ZIP
tui-form-field-max-store-object = Max. bajtů objektu úložiště
tui-form-unlimited = neomezeno
tui-form-err-max-pdu-required = ! max. délka PDU je povinná
tui-form-err-max-pdu-gt-zero = ! max. délka PDU musí být celé číslo větší než 0
tui-form-err-limit-gt-zero = ! { $label } musí být celé číslo větší než 0
tui-form-controls-scp = Pište pro úpravu. Mezerník přepíná zaškrtávací pole. Tab/Shift-Tab nebo šipky mění pole. Enter uloží. Esc zruší.
tui-form-submit-uid-required = UID je povinné
tui-form-submit-dest-required = destination uzel is required
tui-form-submit-nonneg-int = { $label } musí být nezáporné celé číslo
tui-form-submit-gt-zero = { $label } musí být větší než 0
tui-form-submit-local-ae-required = lokální AE title je povinný
tui-form-submit-local-ae-invalid = lokální AE title je neplatný: { $err }
tui-form-submit-bind-required = adresa vazby je povinná
tui-form-submit-port-required = port je povinný
tui-form-submit-max-pdu-required = max. délka PDU je povinná
tui-form-submit-max-pdu-int = max. délka PDU musí být celé číslo
tui-form-submit-max-pdu-gt-zero = max. délka PDU musí být větší než 0
tui-form-submit-patient-retrieve = načtení na úrovni pacienta není podporováno
tui-form-submit-no-study-uid = vybraný výsledek neobsahuje study UID
tui-form-submit-date-format = očekáváno YYYYMMDD
tui-form-submit-modality-len = modalita smí mít nejvýše 16 znaků
tui-form-submit-modality-chars = modalita musí být A-Z nebo 0-9
tui-form-submit-name-required = název uzlu je povinný
tui-form-submit-ae-required = AE title je povinný
tui-form-submit-host-required = hostitel je povinný
tui-form-submit-move-dest-invalid = AE title cíle přesunu je neplatný: { $err }
tui-form-submit-dates-both = datum od i datum do musí být nastaveny obě, nebo žádné
tui-form-submit-date-from-invalid = datum od je neplatné: { $err }
tui-form-submit-date-to-invalid = datum do je neplatné: { $err }
tui-form-submit-date-order = datum od musí být stejné nebo dřívější než datum do
tui-form-submit-study-uid-series-query = study UID je povinné pro dotazy na úrovni série
tui-form-submit-study-uid-image-query = study UID je povinné pro dotazy na úrovni snímku
tui-form-submit-series-uid-image-query = series UID je povinné pro dotazy na úrovni snímku
tui-form-submit-study-uid-required = study UID je povinné
tui-form-submit-study-uid-invalid = study UID je neplatné: { $err }
tui-form-submit-series-uid-series-retrieve = series UID je povinné pro načtení na úrovni série
tui-form-submit-series-uid-image-retrieve = series UID je povinné pro načtení na úrovni snímku
tui-form-submit-instance-uid-image-retrieve = instance UID je povinné pro načtení na úrovni snímku
tui-form-submit-series-uid-invalid = series UID je neplatné: { $err }
tui-form-submit-instance-uid-invalid = instance UID je neplatné: { $err }
tui-form-submit-import-path-required = cesta importu je povinná
tui-form-submit-import-path-type = cesta importu musí být soubor nebo adresář: { $path }
tui-form-submit-import-access = přístup k cestě importu { $path }
tui-form-submit-import-open = otevírání importního souboru { $path }
tui-form-submit-import-read-dir = čtení importního adresáře { $path }
tui-log-welcome = Press F1 or ? for help. Focus Vzdálený uzels and press 'a' to add one.
tui-log-logging-to = Logování do { $path }
tui-command-help-heading = příkazy:
tui-command-help-next-1 = poznámka: zápatí ukazuje kontextové návrhy 'Next:' podle aktivního panelu a výběru.
tui-command-help-next-2 = Jsou to jen nápovědy; vždy můžete zadat libovolný příkaz.
tui-command-help-canonical = poznámka: kanonické názvy odpovídají CLI příznakům bez '--' a používají podtržítka.
tui-command-help-cancel = zrušit (alias: stop)
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
tui-command-help-refresh = obnovit
tui-command-help-quit = konec
tui-inspect-task = Úloha #{ $id }
tui-inspect-status = Stav: { $status }
tui-inspect-description = Popis: { $description }
tui-inspect-progress = Průběh: { $progress }
tui-inspect-summary = Shrnutí:
tui-inspect-no-logs = (žádné protokoly)
tui-field-sop-class-uid = SOP Class UID
tui-field-transfer-syntax-uid = Transfer Syntax UID
tui-field-sha256 = SHA-256
tui-status-removed-nodes =
    odstraněno { $count ->
        [one] { $count } uzel
        [few] { $count } uzly
        [many] { $count } uzlů
       *[other] { $count } uzlů
    }
tui-status-removed-nodes-target =
    odstraněno { $count ->
        [one] { $count } uzel
        [few] { $count } uzly
        [many] { $count } uzlů
       *[other] { $count } uzlů
    }; poslední cíl byl { $name }
tui-status-more-failures =
    a { $n ->
        [one] { $n } vynechané selhání
        [few] { $n } vynechaná selhání
        [many] { $n } vynechaných selhání
       *[other] { $n } vynechaných selhání
    }
tui-status-retrieve-ok = retrieve status=0x{ $status } completed={ $completed } failed={ $failed } warning={ $warning } remaining={ $remaining }
tui-status-import-counts = scanned={ $scanned } accepted={ $accepted } duplicates={ $duplicates } unreadable={ $unreadable } invalid_dicom={ $invalid } rejected_total={ $rejected } stored_bytes={ $bytes }
tui-status-send-ok = send attempted={ $attempted } sent={ $sent } failed={ $failed }
tui-log-query-start = Spouštění dotazu na { $node }
tui-log-retrieve-start = Spouštění načtení z { $node }
tui-log-import-start = Spouštění importu { $path }
tui-log-send-study-start = Spouštění odeslání studie { $uid } na { $node }
tui-log-send-series-start = Spouštění odeslání série { $uid } na { $node }
tui-log-cancelled-before-start = zrušeno před spuštěním
tui-log-cancelled = zrušeno
error-unknown-command = neznámý příkaz: { $command }
error-node-subcommand-required = je vyžadován podpříkaz node
error-local-subcommand-required = je vyžadován podpříkaz local
error-unsupported-node-subcommand = unsupported uzel subcommand: { $command }
error-unsupported-local-subcommand = nepodporovaný podpříkaz local: { $command }
error-expected-kv = očekáván argument key=value, obdrženo { $arg }
error-missing-required-arg = chybí povinný argument: { $key }
error-missing-required-arg-one-of = chybí povinný argument: jeden z { $keys }
error-parsing-command = parsování příkazu
error-edit-form-lost-target = edit form lost its target uzel
error-task-already-running = úloha na pozadí již běží
error-task-thread-launch = nepodařilo se spustit vlákno úlohy na pozadí: { $error }
error-task-disconnected = vlákno úlohy na pozadí se odpojilo před odesláním výsledku
error-task-kind-missing = vlákno úlohy na pozadí se odpojilo, ale active_task_kind bylo None: neočekávaný stav
error-serve-exited = serve skončil s chybou: { $error }
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
summary-title = Souhrn operace
summary-kind = Druh
summary-status = Stav
summary-duration = Trvání
summary-duration-ms = { $ms }ms
summary-peer = Protějšek
summary-ae = AE
summary-criteria = Kritéria
summary-counts = Počty
summary-failures = Selhání:
summary-logs = Protokoly:
summary-unserializable = <nelze serializovat>
summary-log-lines = řádky { $start }-{ $end }
