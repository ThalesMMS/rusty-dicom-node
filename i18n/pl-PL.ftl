# Fluent catalog (pl-PL). Message IDs are hyphenated identifiers
# (cli-about, tui-pane-remote-nodes, desktop-nav-dashboard, error-import-file-too-large).
# Dotted names are Fluent attributes (message + .attr), not message IDs.
# Do not translate DICOM tokens (C-FIND, C-MOVE, C-STORE, SOP, AE, UID) or JSON/CSV machine keys.


## CLI
cli-about = Klient węzła DICOM zorientowany na terminal, zbudowany z dicom-rs
cli-arg-accession-number = Filtruj po numerze accession (podciąg, bez rozróżniania wielkości liter).
cli-arg-ae-title = Application Entity title
cli-arg-destination-node = Nazwa lub id węzła docelowego
cli-arg-duplicate = Filtruj po statusie duplikatu.
cli-arg-export = Eksportuj wyniki jako JSON lub CSV.
cli-arg-host = Nazwa hosta lub IP
cli-arg-imported-at =
    Filtruj po czasie importu. Obsługuje VALUE, START..END, ..END, START...
    Porównanie jest leksykograficzne (zalecany format: RFC3339).
cli-arg-json = Wypisz końcowe podsumowanie operacji jako JSON (stabilny schemat).
cli-arg-level = Poziom query/retrieve
cli-arg-metrics-json = Przy wyjściu serwera wypisz końcowy zrzut metryk w pamięci jako JSON.
cli-arg-modality = Filtruj po modalności. Lista rozdzielana przecinkami (np. CT,MR).
cli-arg-model = Model informacji query/retrieve
cli-arg-move-destination = Preferowany AE title docelowy dla C-MOVE
cli-arg-name = Wyświetlana nazwa węzła
cli-arg-node = Nazwa lub id zapisanego węzła
cli-arg-notes = Swobodne notatki
cli-arg-out = Ścieżka pliku wyjściowego. Jeśli pominięta, zapisuje na stdout.
cli-arg-path = Plik lub katalog do importu
cli-arg-patient-id = Filtruj po ID pacjenta (podciąg, bez rozróżniania wielkości liter).
cli-arg-patient-name = Filtruj po nazwisku pacjenta (podciąg, bez rozróżniania wielkości liter).
cli-arg-port = numer portu
cli-arg-series-description = Filtruj po opisie serii (podciąg, bez rozróżniania wielkości liter).
cli-arg-series-instance-uid = Series Instance UID
cli-arg-sop-instance-uid = SOP Instance UID
cli-arg-source-path = Filtruj po ścieżce źródłowej (podciąg, bez rozróżniania wielkości liter).
cli-arg-study-date =
    Filtruj po dacie badania. Obsługuje VALUE, START..END, ..END, START...
    Porównanie jest leksykograficzne (zalecany format: YYYYMMDD).
cli-arg-study-date-from = Dolna granica daty badania (YYYYMMDD)
cli-arg-study-date-to = Górna granica daty badania (YYYYMMDD)
cli-arg-study-description = Filtruj po opisie badania (podciąg, bez rozróżniania wielkości liter).
cli-arg-study-instance-uid = Study Instance UID
cli-cmd-import-about = Importuj pliki DICOM ze ścieżki
cli-cmd-local-about = Przejrzyj lokalne archiwum
cli-cmd-local-series-about = Wypisz zindeksowane serie badania
cli-cmd-local-studies-about = Wypisz zindeksowane lokalne badania
cli-cmd-node-about = Zarządzaj zapisanymi zdalnymi węzłami DICOM
cli-cmd-node-add-about = Dodaj zdalny węzeł
cli-cmd-node-delete-about = Usuń zapisany węzeł
cli-cmd-node-edit-about = Edytuj zapisany węzeł
cli-cmd-node-list-about = Wypisz zapisane węzły
cli-cmd-query-about = Odpytaj zdalny węzeł (C-FIND)
cli-cmd-retrieve-about = Pobierz ze zdalnego węzła (C-MOVE)
cli-cmd-send-about = Wyślij lokalne badania lub serie (C-STORE)
cli-cmd-send-series-about = Wyślij serię do węzła docelowego
cli-cmd-send-study-about = Wyślij badanie do węzła docelowego
cli-cmd-serve-about = Uruchom serwer DICOM
cli-cmd-storage-scp-about = Uruchom listener Storage SCP
cli-cmd-tui-about = Otwórz interaktywny interfejs w terminalu
cli-flag-help = Wyświetl pomoc
cli-flag-lang = Język interfejsu (znacznik BCP-47). Nadpisuje DICOM_NODE_LANG, zapisane locale i locale systemu.
cli-flag-version = Wyświetl wersję
cli-heading-arguments = Argumenty:
cli-heading-commands = Polecenia:
cli-heading-options = Opcje:
cli-heading-usage = Użycie:
cli-import-accepted = accepted={ $n }
cli-import-complete = Import zakończony
cli-import-duplicates = duplicates={ $n }
cli-import-scanned = scanned={ $n }
cli-msg-cancel-sigint = Żądanie anulowania (SIGINT). Oczekiwanie na kontrolowane zamknięcie...
cli-msg-failures = błędy:
cli-msg-import-failed = Import nie powiódł się: { $error }
cli-msg-no-local-series = Brak zindeksowanych serii dla badania { $uid }
cli-msg-no-local-studies = Brak zindeksowanych lokalnych badań
cli-msg-no-saved-nodes = Brak zapisanych węzłów
cli-msg-query-failed = Zapytanie nie powiodło się: { $error }
cli-msg-removed-nodes =
    Usunięto { $count ->
        [one] { $count } węzeł
        [few] { $count } węzły
        [many] { $count } węzłów
       *[other] { $count } węzłów
    }
cli-msg-results-count =
    Wyniki: { $count ->
        [one] { $count } dopasowanie
        [few] { $count } dopasowania
        [many] { $count } dopasowań
       *[other] { $count } dopasowań
    }
cli-msg-retrieve-failed = Retrieve nie powiódł się: { $error }
cli-msg-saved-node = Zapisano węzeł { $name } [{ $id }] => { $ae }@{ $host }:{ $port }
cli-msg-send-failed = Wysyłanie nie powiodło się: { $error }
cli-msg-showing-failures = (pokazano pierwsze { $shown } z { $total } błędów)
cli-msg-starting-server =
    Uruchamianie serwera DICOM z { $count ->
        [one] { $count } lokalne AE
        [few] { $count } lokalne AE
        [many] { $count } lokalnych AE
       *[other] { $count } lokalnych AE
    }: { $aes }
cli-msg-starting-server-no-aes = Uruchamianie serwera DICOM bez skonfigurowanych lokalnych AE
cli-msg-starting-storage-scp = Uruchamianie storage SCP pod { $addr } z AE title { $ae }
cli-msg-updated-node = Zaktualizowano węzeł { $name } [{ $id }] => { $ae }@{ $host }:{ $port }
cli-send-attempted = attempted={ $n }
cli-send-failed-count = failed={ $n }
cli-send-sent = sent={ $n }
cli-value-name-file = FILE
cli-value-name-format = FORMAT
cli-value-name-locale = LOCALE
cli-value-name-path = PATH
tui-detail-more-series =
    ... { $n ->
        [one] { $n } seria więcej
        [few] { $n } serie więcej
        [many] { $n } serii więcej
       *[other] { $n } serii więcej
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
        [one] { $n } węzeł
        [few] { $n } węzły
        [many] { $n } węzłów
       *[other] { $n } węzłów
    }
count-instances =
    { $n ->
        [one] { $n } instancja
        [few] { $n } instancje
        [many] { $n } instancji
       *[other] { $n } instancji
    }
count-series =
    { $n ->
        [one] { $n } seria
        [few] { $n } serie
        [many] { $n } serii
       *[other] { $n } serii
    }
count-studies =
    { $n ->
        [one] { $n } badanie
        [few] { $n } badania
        [many] { $n } badań
       *[other] { $n } badań
    }
format-datetime = { $date } { $time }
format-date = { $day }.{ $month }.{ $year }

## Common
common-accession = Numer dostępu
common-add = Dodaj
common-back = Wstecz
common-bytes = Bajty
common-cancel = Anuluj
common-clear = Wyczyść
common-close = Zamknij
common-date = Data
common-delete = Usuń węzeł
common-description = Opis
common-disabled = wyłączone
common-duplicates = Duplikaty
common-edit = Edytuj
common-enabled = włączone
common-error = Błąd
common-filter = Filtr
common-host = nazwa hosta
common-import = Importuj
common-instance = Instancja
common-language = Język
common-loading = Ładowanie
common-matches = Dopasowania
common-modality = Modalność
common-name = Nazwa
common-network = Sieć
common-no = nie
common-none = brak
common-notes = Notatki
common-optional = opcjonalne
common-path = Źródło
common-patient = Pacjent
common-patient-id = ID pacjenta
common-patient-name = Imię pacjenta
common-port = numer portu
common-query = Zapytaj
common-refresh = Odśwież
common-required = wymagane
common-retrieve = Pobierz
common-save = Zapisz
common-search = Szukaj
common-send = Wyślij
common-series = Serie
common-start = Uruchom
common-status = stan
common-stop = Zatrzymaj
common-studies = Badania
common-study = Badanie
common-unknown = nieznany
common-unknown-series = <Serie>
common-unknown-study = <Badania>
common-yes = tak

## Errors
error-ae-empty = AE title nie może być pusty
error-ae-invalid-char = AE title zawiera nieprawidłowy znak '{ $character }'; dozwolone: A-Z, 0-9, spacja
error-ae-required = AE title jest wymagany
error-ae-too-long = AE title może mieć co najwyżej 16 znaków
error-ae-whitespace = AE title nie może mieć spacji wiodących ani końcowych
error-archive-patient-retrieve-out-of-scope = retrieve na poziomie Patient jest poza zakresem
error-archive-retrieve-uid-required = { $name } jest wymagane dla tego poziomu retrieve
error-archive-study-root-patient-query = zapytania Study Root nie obsługują poziomu Patient
error-archive-study-root-patient-retrieve = retrieve Study Root nie obsługuje poziomu Patient
error-assoc-negotiation-failed = negocjacja association z { $name } ({ $addr }) nie powiodła się; wskazówka: sprawdź called AE title, presentation contexts/transfer syntaxes i czy peer akceptuje association
error-assoc-no-addresses = brak adresów gniazda dla { $name } pod { $host }:{ $port }
error-assoc-receive = odbiór association
error-assoc-resolving = rozwiązywanie { $name } pod { $host }:{ $port }: { $err }
error-assoc-timeout = przekroczono czas oczekiwania na odpowiedź DIMSE; wskazówka: sprawdź sieć, AE title/host/port i reakcję peera
error-assoc-transport = przerwanie transportu podczas oczekiwania na odpowiedź DIMSE; wskazówka: peer zamknął połączenie lub urządzenie sieciowe je zresetowało
error-assoc-unreachable = nie udało się dotrzeć do { $name } [{ $ae }] pod { $host }:{ $port } w { $seconds }s: { $err }. Sprawdź host/IP, port i dostępność sieci
error-cancel-sigint = Żądanie anulowania (SIGINT). Oczekiwanie na poprawne zakończenie...
error-config-must-be-positive = nieprawidłowa konfiguracja: { $name } musi być > 0 (lub null, aby wyłączyć)
error-config-duplicate-bind-port = nieprawidłowa konfiguracja: zduplikowany port bind lokalnego AE { $port }
error-config-local-ae-max-assoc = nieprawidłowa konfiguracja: lokalny AE { $title } max_concurrent_associations musi być > 0
error-config-local-ae-no-services = nieprawidłowa konfiguracja: lokalny AE { $title } musi włączyć co najmniej jedną usługę
error-config-must-be-positive-required = nieprawidłowa konfiguracja: { $name } musi być > 0
error-dicom-meta-incomplete = file meta DICOM jest niekompletne
error-dicom-patient-move-unsupported = C-MOVE na poziomie pacjenta nie jest obsługiwane przez tego klienta
error-dicom-required-attribute = brak wymaganego atrybutu DICOM: ({ $group },{ $element })
error-dicom-series-uid-required-image = series_instance_uid jest wymagane przy retrieve na poziomie obrazu
error-dicom-series-uid-required-series = series_instance_uid jest wymagane przy retrieve na poziomie serii
error-dicom-sop-uid-required-image = sop_instance_uid jest wymagane przy retrieve na poziomie obrazu
error-dicom-study-uid-required = wymagane jest study_instance_uid
error-dicom-validating-move = walidacja żądania move
error-export-creating-file = tworzenie pliku eksportu { $path }: { $err }
error-export-flushing-series-csv = zrzut CSV serii: { $err }
error-export-flushing-studies-csv = zrzut CSV badań: { $err }
error-export-serializing-series-json = serializacja JSON serii: { $err }
error-export-serializing-studies-json = serializacja JSON badań: { $err }
error-export-writing-series-csv-header = zapis nagłówka CSV serii: { $err }
error-export-writing-series-csv-row = zapis wiersza CSV serii: { $err }
error-export-writing-studies-csv-header = zapis nagłówka CSV badań: { $err }
error-export-writing-studies-csv-row = zapis wiersza CSV badań: { $err }
error-import-cleanup-failed = { $source }: czyszczenie nie powiodło się: { $reason }
error-import-corrupt-zip = Uszkodzony ZIP: { $details }
error-import-dicom-parse-failed = parsowanie DICOM nie powiodło się: { $err }
error-import-dicom-validation-failed = walidacja DICOM nie powiodła się: { $err }
error-import-duplicate-zip-path = Zduplikowana ścieżka ZIP: { $details }
error-import-file-too-large = plik zbyt duży: { $details }
error-import-invalid-dicom = Nieprawidłowy DICOM: { $details }
error-import-limit-exceeded = przekroczono { $limit }: { $details }
error-import-not-regular-file = to nie jest zwykły plik
error-import-opening-file = otwieranie pliku: { $err }
error-import-opening-kind = otwieranie { $kind } { $path }
error-import-opening-staged-file = otwieranie pliku w stagingu: { $err }
error-import-opening-zip-archive = otwieranie archiwum ZIP { $path }
error-import-opening-zip-entry = otwieranie wpisu ZIP: { $err }
error-import-opening-zip-file = otwieranie pliku ZIP importu { $path }
error-import-path-does-not-exist = Ścieżka importu nie istnieje: { $path }
error-import-reading-directory = odczyt katalogu importu { $path }
error-import-reading-file = odczyt pliku: { $err }
error-import-reading-file-metadata = odczyt metadanych pliku { $path }
error-import-reading-metadata = odczyt metadanych { $kind } { $path }
error-import-reading-zip-entry = odczyt wpisu ZIP: { $err }
error-import-removing-staged-after-cancel = usuwanie pliku staging po anulowaniu { $path }
error-import-skipped = Pominięto: { $details }
error-import-unreadable = Nieczytelny plik: { $details }
error-import-unsafe-zip-path = Niebezpieczna ścieżka ZIP: { $details }
error-import-zip-entry-count-exceeded = przekroczono limit liczby wpisów ZIP: archiwum ma { $count } wpisów, limit to { $limit }
error-import-zip-entry-size-exceeded = rozmiar wpisu ZIP { $size } przekracza limit { $limit }
error-import-zip-total-bytes-exceeded = przekroczono limit rozpakowanych bajtów ZIP: bieżąca suma { $current } plus rozmiar wpisu { $entry } przekracza limit { $limit }
error-net-binding-storage-scp = bindowanie Storage SCP pod { $addr } dla AE { $ae }. Inny lokalny odbiornik DICOM może już używać tego portu. Zaktualizuj storage_scp_port/local_aes w { $config } lub zatrzymaj konfliktujący nasłuch
error-net-building-file-meta = budowanie tabeli file meta
error-net-cannot-send-transfer-syntax = nie można wysłać źródłowej składni transferu { $source } z wynegocjowaną { $negotiated }
error-net-cget-dataset-empty = zakodowany zbiór danych C-GET C-STORE jest pusty
error-net-cget-dataset-odd-length = zakodowany zbiór C-GET C-STORE zakończył się fragmentem nieparzystej długości
error-net-cget-peer-released = węzeł zwolnił asocjację podczas C-GET
error-net-cget-store-unexpected-dataset = nieoczekiwane dataset fragment in C-GET C-STORE response
error-net-cget-unexpected-command = nieoczekiwane command 0x{ $command } while waiting for C-STORE-RSP
error-net-cget-unexpected-pdu = nieoczekiwane PDU during C-GET C-STORE suboperation: { $pdu }
error-net-creating-incoming-dir = tworzenie katalogu .incoming Storage SCP
error-net-creating-path = tworzenie { $path }
error-net-dataset-empty = zakodowany zbiór jest pusty, ale COMMAND_DATA_SET_TYPE wymaga zbioru
error-net-dataset-odd-length = zakodowany zbiór zakończył się fragmentem nieparzystej długości
error-net-dimse-failed = { $operation } nie powiodło się ze statusem 0x{ $status } ({ $meaning }){ $hint }
error-net-establishing-assoc = nawiązywanie asocjacji Storage SCP
error-net-file-meta-length = odczyt File Meta Information length
error-net-file-meta-tag = odczyt File Meta Information tag
error-net-file-meta-value = pomijanie wartości File Meta Information
error-net-file-meta-vr = odczyt File Meta Information VR
error-net-file-position = odczyt file position
error-net-flushing-path = opróżnianie { $path }
error-net-flushing-temp-dataset = opróżnianie tymczasowego pliku zbioru
error-net-hint-suffix = ; wskazówka: { $hint }
error-net-incomplete-command = niekompletne { $operation } command response
error-net-incomplete-identifier = niekompletne { $operation } response identifier
error-net-invalid-affected-sop = nieprawidłowe { $operation } affected SOP class UID
error-net-invalid-status = nieprawidłowe { $operation } status
error-net-listener-address = odczyt storage SCP listener address
error-net-listener-nonblocking = ustawianie trybu nieblokującego nasłuchu
error-net-listener-port = odczyt storage SCP listener port
error-net-local-aes-empty = local_aes musi zawierać co najmniej jedno AE, aby uruchomić Storage SCP
error-net-locating-dataset = wyszukiwanie zbioru w { $path }
error-net-malformed-dimse = malformed { $operation } DIMSE response: { $details }; wskazówka: peer sent an nieprawidłowe or nieoczekiwane DIMSE command set
error-net-missing-affected-sop = brak { $operation } affected SOP class UID
error-net-missing-command-field = brak command field
error-net-missing-cstore-rsp-command-field = brak C-STORE response command field
error-net-missing-cstore-rsp-status = brak C-STORE response status
error-net-missing-destination = brak C-MOVE destination
error-net-missing-dicm = brak Part 10 DICM marker
error-net-missing-message-id = brak { $operation } message id
error-net-missing-qr-level = { $operation } identifier is brak QueryRetrieveLevel
error-net-missing-required-command-field = brak required command field { $name } ({ $tag })
error-net-missing-status = brak { $operation } status
error-net-move-destination-unresolved = nie rozwiązano move_destination
error-net-no-cget-store-context = brak wynegocjowanego kontekstu prezentacji magazynu C-GET dla SOP Class { $sop } i składni { $syntax }
error-net-no-compatible-context = { $path }: brak zgodnego wynegocjowanego kontekstu prezentacji dla źródłowej składni { $syntax }
error-net-no-dimse-provider = brak zarejestrowanego dostawcy DIMSE dla polecenia 0x{ $command } i składni abstrakcyjnej { $syntax }
error-net-no-presentation-context = brak wynegocjowanego kontekstu prezentacji
error-net-no-presentation-context-for-file = { $path }: brak wynegocjowanego kontekstu prezentacji
error-net-no-presentation-context-id = brak negotiated presentation context { $id }
error-net-opening-path = otwieranie { $path }
error-net-part10-preamble = odczyt Part 10 preamble
error-net-path-error = { $path }: { $err }
error-net-pdata-feed-complete = cannot feed P-DATA fragment into a complete accumulator (brak take())
error-net-peer-aborted = węzeł przerwał asocjację podczas podoperacji C-GET C-STORE: { $source }
error-net-peer-socket = odczyt storage SCP peer socket address
error-net-reading-command-dataset = odczyt command dataset
error-net-reading-identifier = odczyt { $operation } identifier
error-net-reading-incoming-dataset = odczyt incoming C-STORE dataset
error-net-reading-response-dataset = odczyt { $operation } response dataset
error-net-remote-aborted = strona zdalna przerwała asocjację: { $source }
error-net-restoring-read-timeout = przywracanie limitu czasu odczytu association
error-net-restoring-write-timeout = przywracanie limitu czasu zapisu association
error-net-rewinding-dataset = przewijanie do pierwszego elementu zbioru
error-net-scp-thread-panicked = wątek Storage SCP uległ panice
error-net-seeking-temp-dataset = przeszukiwanie tymczasowego pliku zbioru
error-net-serializing-cget-dataset = serializacja zbioru podoperacji C-GET dla { $path }
error-net-serializing-dataset = serializacja zbioru dla { $path } ze składnią transferu { $syntax }
error-net-setting-socket-blocking = ustawianie zaakceptowanego gniazda magazynu w tryb blokujący
error-net-sending-buffered-dataset = wysyłanie buforowanego zbioru dla { $path }
error-net-store-status = strona zdalna zwróciła status C-STORE 0x{ $status } ({ $meaning }){ $hint }
error-net-streaming-dataset = strumieniowanie zbioru C-STORE
error-net-unexpected-command-field = nieoczekiwane CommandField 0x{ $actual } (expected 0x{ $expected } for { $rsp })
error-net-unexpected-dataset-fragment = nieoczekiwane dataset fragment in C-STORE response
error-net-unexpected-pdu = nieoczekiwane PDU during { $operation }: { $pdu }
error-net-unknown-status = nieprawidłowe { $operation } status 0x{ $status }
error-net-unsupported-model-sop = nieobsługiwane { $operation } model SOP class UID: { $uid }
error-net-unsupported-qr-level = nieobsługiwane QueryRetrieveLevel: { $level }
error-net-unsupported-transfer-syntax = nieobsługiwane negotiated transfer syntax
error-net-writing-command-dataset = zapis command dataset
error-net-writing-identifier = zapis { $operation } identifier
error-net-writing-path = zapis { $path }
error-net-writing-response-dataset = zapis { $operation } response dataset
error-net-writing-temp-dataset = zapis dataset bytes to temp file
error-node-host-empty = host węzła nie może być pusty
error-node-name-empty = nazwa węzła nie może być pusta
error-node-not-found = nie znaleziono węzła zdalnego: { $id }
error-operation-cancelled = operacja anulowana
error-port-invalid = nieprawidłowy port: { $value }
error-port-range = port musi być między 1 a 65535
error-query-no-study-uid = Dopasowanie nie ma StudyInstanceUID; retrieve niemożliwe.
error-query-unsupported-level = nieobsługiwany poziom zapytania: { $value }
error-query-unsupported-model = nieobsługiwany model zapytania: { $value }
error-retrieve-canceled = retrieve anulowany przez węzeł zdalny (status=0x{ $status }, completed={ $completed }, failed={ $failed }, warning={ $warning }, remaining={ $remaining }, { $scp })
error-retrieve-failed = retrieve nie powiódł się ze status=0x{ $status } (completed={ $completed }, failed={ $failed }, warning={ $warning }, remaining={ $remaining }, { $scp })
error-retrieve-nothing-arrived = retrieve dla przeznaczenia { $destination } zakończył się z completed={ $completed }, ale nic nie dotarło do lokalnego Storage SCP ({ $scp }). Sprawdź mapowanie AE lub port: { $listener } musi być wolny, a węzeł zdalny musi mapować AE { $destination } na tę aplikację
error-send-no-files-series = brak zindeksowanych lokalnych plików dla serii { $uid }
error-send-no-files-study = brak zindeksowanych lokalnych plików dla badania { $uid }
error-task-cancelled = Zadanie anulowane
error-task-none-to-cancel = Brak aktywnego zadania do anulowania (nic nie jest uruchomione)
error-tracing-init = inicjowanie tracing subscriber: { $err }
error-uid-component-numeric = składowa UID '{ $part }' musi być liczbowa
error-uid-component-too-long = składowa UID '{ $part }' jest zbyt długa
error-uid-dot-ends = UID nie może zaczynać się ani kończyć kropką
error-uid-empty = UID nie może być pusty
error-uid-empty-component = UID nie może zawierać pustych składowych
error-uid-leading-zeros = składowa UID '{ $part }' nie może mieć zer wiodących
error-uid-too-long = UID może mieć co najwyżej 64 znaki

## TUI
tui-bool-no = nie
tui-bool-off = wył.
tui-bool-on = wł.
tui-bool-yes = tak
tui-command-placeholder = Wpisz polecenie lub użyj skrótów panelu.
tui-config-ae-title = AE title: { $value }
tui-config-edit-hint = Naciśnij Tab, aby uaktywnić ten panel, potem 'c', aby edytować.
tui-config-hint = Naciśnij Tab, aby uaktywnić ten panel, potem 'c', aby edytować.
tui-config-listener = Nasłuch: { $value }
tui-config-max-pdu = max_pdu_length: { $value }
tui-config-promiscuous = allow_promiscuous_storage: { $value }
tui-config-strict-pdu = strict_pdu: { $value }
tui-config-ts-pref = Preferencja TS: { $value }
tui-controls-hint = Tab pola · Enter zatwierdza · Esc anuluje
tui-detail-ae-title = AE Title
tui-detail-instance = Szczegóły instancji
tui-detail-name = Nazwa
tui-detail-node = Szczegóły węzła
tui-detail-placeholder-followup = Przenieś fokus na panel listy i zmień zaznaczenie, aby odświeżyć ten widok.
tui-detail-query = Szczegóły wyniku zapytania
tui-detail-select-node = Wybierz zdalny węzeł, aby sprawdzić jego metadane.
tui-detail-series = Szczegóły serii
tui-detail-study = Szczegóły badania
tui-empty-command-placeholder = Wpisz polecenie lub użyj skrótów panelu.
tui-empty-detail-instance = Wybierz instancję, aby ją sprawdzić, albo wróć do serii klawiszem Esc.
tui-empty-detail-node = Wybierz zdalny węzeł, aby sprawdzić jego metadane.
tui-empty-detail-query = Wybierz wynik zapytania, aby sprawdzić metadane i kontekst retrieve.
tui-empty-detail-series = Wybierz serię, aby ją sprawdzić, albo wróć do badań klawiszem Esc.
tui-empty-detail-study = Wybierz lokalne badanie, aby sprawdzić metadane pacjenta i serii.
tui-empty-instances = Brak zindeksowanych instancji dla tej serii.
tui-empty-instances-hint = Naciśnij Esc, aby wrócić do serii.
tui-empty-local-instances = Brak zindeksowanych instancji dla tej serii.
tui-empty-local-instances-hint = Naciśnij Esc, aby wrócić do serii.
tui-empty-local-series = Brak zindeksowanych serii dla tego badania.
tui-empty-local-series-hint = Naciśnij Esc, aby wrócić do badań lokalnych.
tui-empty-local-studies = Brak zindeksowanych badań.
tui-empty-local-studies-cmd = Przykład: import path=/data/inbox
tui-empty-local-studies-hint = Najpierw zaimportuj lokalne pliki DICOM.
tui-empty-no-name = <brak nazwy>
tui-empty-query = Nie uruchomiono jeszcze żadnego zapytania.
tui-empty-query-body =
    Wybierz zdalny węzeł i naciśnij 'f', aby wykonać zapytanie.
    Lub: query node=pacs
        patient_name="DOE^JOHN"
    Naciśnij 'm' na wybranym wyniku, aby otworzyć retrieve.
tui-empty-query-cmd = Lub: query node=pacs
tui-empty-query-hint = Wybierz zdalny węzeł i naciśnij 'f', aby wykonać zapytanie.
tui-empty-query-last-target = Ostatni cel zapytania: { $name }
tui-empty-query-none = Nie uruchomiono jeszcze żadnego zapytania.
tui-empty-query-retrieve-hint = Naciśnij 'm' na wybranym wyniku, aby otworzyć retrieve.
tui-empty-remote-nodes = Nie zapisano jeszcze żadnych węzłów zdalnych.
tui-empty-remote-nodes-cmd = Lub: node add name=pacs
tui-empty-remote-nodes-hint = Naciśnij 'a' w tym panelu, aby dodać jeden.
tui-empty-series = Brak zindeksowanych serii dla tego badania.
tui-empty-series-hint = Naciśnij Esc, aby wrócić do badań lokalnych.
tui-empty-studies = Brak zindeksowanych badań.
tui-empty-studies-hint = Najpierw zaimportuj lokalne pliki DICOM.
tui-empty-tasks-history = Brak historii zadań.
tui-empty-tasks-queued = Brak zadań w kolejce.
tui-fallback-no-name = <brak nazwy>
tui-field-accession = Numer accession
tui-field-ae-title = AE title
tui-field-bind-addr = Adres bindowania
tui-field-date-from = Data od
tui-field-date-to = Data do
tui-field-destination-node = Węzeł docelowy
tui-field-host = nazwa hosta
tui-field-instance-uid = Instance UID
tui-field-kind = Rodzaj
tui-field-level = Poziom
tui-field-local-ae = Lokalne AE
tui-field-max-pdu = Max PDU
tui-field-modality = Modalność
tui-field-model = model
tui-field-move-destination = Przeznaczenie move
tui-field-name = Nazwa
tui-field-notes = Notatki
tui-field-path = Ścieżka
tui-field-patient-id = ID pacjenta
tui-field-patient-name = Nazwisko pacjenta
tui-field-port = numer portu
tui-field-promiscuous = Promiskuitywny
tui-field-series-uid = Series UID
tui-field-sop-uid = SOP Instance UID
tui-field-strict-pdu = Ścisłe PDU
tui-field-study-description = Opis badania
tui-field-study-uid = Study UID
tui-footer-back-series = Esc wróć do serii
tui-footer-back-studies = Esc wróć do badań
tui-footer-cancel-task = c anuluj
tui-footer-edit-config = c edytuj konfigurację
tui-footer-enter-series = Enter serie
tui-footer-esc-series = Esc wróć do serii
tui-footer-esc-studies = Esc wróć do badań
tui-footer-help = F1/? pomoc
tui-footer-inspect = Enter podgląd
tui-footer-next = Dalej: { $text }
tui-footer-nodes = a/e/d/f węzły
tui-footer-panes = Tab panele
tui-footer-queued =
    { $n ->
        [one] { $n } w kolejce
        [few] { $n } w kolejce
        [many] { $n } w kolejce
       *[other] { $n } w kolejce
    }
tui-footer-quit = q wyjdź
tui-footer-refresh = r odśwież
tui-footer-retrieve = m pobierz
tui-footer-run-command = Enter uruchom polecenie
tui-footer-task-scope = t kolejka/historia
tui-form-add-node = Dodaj węzeł zdalny
tui-form-add-remote-node = Dodaj węzeł zdalny
tui-form-delete-confirm = Usunąć zdalny węzeł { $name } [{ $ae }] pod { $host }:{ $port }?
tui-form-delete-node = Usuń węzeł zdalny
tui-form-delete-remote-node = Usuń węzeł zdalny
tui-form-edit-node = Edytuj węzeł zdalny
tui-form-edit-remote-node = Edytuj węzeł zdalny
tui-form-err-ae-required = ! AE title jest wymagany
tui-form-err-bind-required = ! adres bindowania jest wymagany
tui-form-err-host-required = ! host jest wymagany
tui-form-err-local-ae-invalid = ! nieprawidłowy lokalny AE title: { $err }
tui-form-err-local-ae-required = ! lokalny AE title jest wymagany
tui-form-err-modality-empty = modality nie może być puste
tui-form-err-move-dest-invalid = ! nieprawidłowy AE title celu przeniesienia: { $err }
tui-form-err-name-required = ! węzeł name is required
tui-form-err-port-required = ! port jest wymagany
tui-form-err-uid-empty = UID nie może być pusty
tui-form-err-uid-empty-component = UID nie może zawierać pustych składowych
tui-form-error-line = Błąd: { $error }
tui-form-field-accession = Numer accession
tui-form-field-ae-title = AE title
tui-form-field-bind-addr = Adres bindowania
tui-form-field-date-from = Data od
tui-form-field-date-to = Data do
tui-form-field-dest-node = Węzeł docelowy
tui-form-field-destination = Docelowy AE
tui-form-field-host = nazwa hosta
tui-form-field-instance-uid = SOP Instance UID
tui-form-field-kind = Rodzaj
tui-form-field-level = Poziom
tui-form-field-local-ae = Lokalne AE
tui-form-field-modality = Modalność
tui-form-field-model = model
tui-form-field-move-dest = Przeznaczenie move
tui-form-field-name = Nazwa
tui-form-field-notes = Notatki
tui-form-field-path = Ścieżka
tui-form-field-patient-id = ID pacjenta
tui-form-field-patient-name = Nazwisko pacjenta
tui-form-field-port = numer portu
tui-form-field-series-uid = Series Instance UID
tui-form-field-sop-uid = SOP Instance UID
tui-form-field-study-desc = Opis badania
tui-form-field-study-uid = Study Instance UID
tui-form-field-uid = UID
tui-form-hint-bind = wskazówka: zwykle 0.0.0.0 (wszystkie interfejsy) lub 127.0.0.1
tui-form-hint-local-ae = wskazówka: do 16 znaków (A-Z, 0-9, spacja), np. ARCHIVE_AE
tui-form-hint-move-dest = wskazówka: opcjonalne; nadpisuje docelowy AE title C-MOVE
tui-form-hint-name = wskazówka: krótka etykieta (np. PACS)
tui-form-import = Importuj pliki lokalne
tui-form-import-local = Importuj pliki lokalne
tui-form-import-local-files = Importuj pliki lokalne
tui-form-mode-add = create a new węzeł zdalny
tui-form-mode-edit = update the selected węzeł zdalny
tui-form-query-node = Odpytaj węzeł zdalny
tui-form-query-remote-node = Odpytaj węzeł zdalny
tui-form-remote-node-line = Węzeł zdalny: { $name } [{ $ae }] { $host }:{ $port }
tui-form-retrieve = Retrieve dopasowań
tui-form-retrieve-matches = Retrieve dopasowań
tui-form-send-series = Wyślij serię
tui-form-send-study = Wyślij badanie
tui-form-storage-intro = Edytuj lokalne ustawienia Storage SCP (zapisane w config.json).
tui-form-storage-scp = Ustawienia Storage SCP
tui-form-storage-scp-settings = Ustawienia Storage SCP
tui-help-ae-title = AE title: { $value }
tui-help-aedf = a/e/d/f     Add, edit, delete, or query from the selected węzeł
tui-help-c = c           Edytuj ustawienia Storage SCP (gdy fokus jest na panelu Konfiguracja)
tui-help-canonical-names = Nazwy kanoniczne odpowiadają flagom CLI bez '--' i używają podkreśleń.
tui-help-close = Zamknij pomoc klawiszami Esc, F1 lub ?.
tui-help-common-commands = Typowe polecenia
tui-help-config = c           Edytuj ustawienia Storage SCP (gdy fokus jest na panelu Konfiguracja)
tui-help-config-path = Ścieżka konfiguracji: { $value }
tui-help-current-config = Bieżąca konfiguracja
tui-help-data-dir = Katalog danych: { $value }
tui-help-enter-default = Enter       Run the command input, submit the active modal, or open series from Badania lokalne
tui-help-enter-instance = Enter       Brak akcji panelu lokalnego w widoku instancji
tui-help-enter-local-instance = Enter       Brak akcji panelu lokalnego w widoku instancji
tui-help-enter-local-series = Enter       Otwórz instancje zaznaczonej lokalnej serii, lub uruchom polecenie / wyślij aktywny modal
tui-help-enter-local-study = Enter       Otwórz serie zaznaczonego lokalnego badania, lub uruchom polecenie / wyślij aktywny modal
tui-help-enter-series = Enter       Otwórz instancje zaznaczonej lokalnej serii, lub uruchom polecenie / wyślij aktywny modal
tui-help-enter-study = Enter       Otwórz serie zaznaczonego lokalnego badania, lub uruchom polecenie / wyślij aktywny modal
tui-help-esc-default = Esc         Zamknij pomoc/modal, wróć z lokalnych serii lub przywróć fokus do pola polecenia
tui-help-esc-instance = Esc         Wróć z lokalnych instancji do serii, zamknij pomoc/modal lub przywróć fokus do pola polecenia
tui-help-esc-instances = Esc         Wróć z lokalnych instancji do serii, zamknij pomoc/modal lub przywróć fokus do pola polecenia
tui-help-esc-series = Esc         Wróć z lokalnych serii do badań, zamknij pomoc/modal lub przywróć fokus do pola polecenia
tui-help-f1 = F1 lub ?     Otwórz pomoc
tui-help-import-send = i/s         Importuj local files or send selected study/series
tui-help-is = i/s         Importuj local files or send selected study/series
tui-help-listener = Nasłuch: { $value }
tui-help-log-dir = Katalog dzienników: { $value }
tui-help-m = m           Pobierz z zaznaczonego wyniku zapytania
tui-help-max-pdu = max_pdu_length: { $value }
tui-help-move = Góra/dół lub j/k   Przesuń zaznaczenie w panelach list
tui-help-nodes = a/e/d/f     Add, edit, delete, or query from the selected węzeł
tui-help-open = F1 lub ?     Otwórz pomoc
tui-help-promiscuous = allow_promiscuous_storage: { $value }
tui-help-q = q           Wyjdź, gdy żaden modal nie jest aktywny i fokus nie jest w polu polecenia
tui-help-quit = q           Wyjdź, gdy żaden modal nie jest aktywny i fokus nie jest w polu polecenia
tui-help-r = r           Odśwież panes when focus is niet in command input
tui-help-receiver-mode = Tryb odbiornika: { $value }
tui-receiver-mode-on-demand = na żądanie dla lokalnego retrieve
tui-receiver-mode-standalone = samodzielny przez storage-scp
tui-help-refresh = r           Odśwież panes when focus is niet in command input
tui-help-retrieve = m           Pobierz z zaznaczonego wyniku zapytania
tui-help-strict-pdu = strict_pdu: { $value }
tui-help-tab = Tab / Shift-Tab  Zmień aktywny panel
tui-help-title = Skróty klawiszowe
tui-help-ts-pref = preferred_store_transfer_syntax: { $value }
tui-help-updown = Góra/dół lub j/k   Przesuń zaznaczenie w panelach list
tui-input-placeholder = Wpisz polecenie lub użyj skrótów panelu.
tui-log-command = > { $command }
tui-log-error = błąd: { $error }
tui-log-refreshed = odświeżono
tui-logs-capped-suffix = ograniczone
tui-logs-label = Dzienniki:
tui-pane-command = Polecenie
tui-pane-config = Konfiguracja
tui-pane-detail = Szczegóły
tui-pane-detail-hint = { $title } (PgUp/PgDn gdy nie trwa wpisywanie)
tui-pane-help = Pomoc
tui-pane-instance-detail = Szczegóły instancji
tui-pane-instances-for = Instancje dla: { $uid }
tui-pane-local-studies = Badania lokalne
tui-pane-logs = Logi ({ $shown }/{ $total }{ $capped })
tui-pane-logs-capped = Dzienniki ({ $shown }/{ $total } capped)
tui-pane-logs-uncapped = Dzienniki ({ $shown }/{ $total })
tui-pane-node-detail = Szczegóły węzła
tui-pane-query-detail = Szczegóły wyniku zapytania
tui-pane-query-node = Zapytaj węzeł
tui-pane-query-result-detail = Szczegóły wyniku zapytania
tui-pane-query-results = Wyniki zapytania / retrieve
tui-pane-query-retrieve-results = Wyniki zapytania / retrieve
tui-pane-remote-nodes = Węzły zdalne
tui-pane-series-detail = Szczegóły serii
tui-pane-series-for = Serie dla: { $uid }
tui-pane-series-unknown = Serie dla: <nieznane badanie>
tui-pane-study-detail = Szczegóły badania
tui-pane-task-details = Szczegóły zadania
tui-pane-tasks-history = Zadania (historia)
tui-pane-tasks-queued = Zadania (kolejka)
tui-pane-unknown-series = <nieznana seria>
tui-pane-unknown-study = Serie dla: <nieznane badanie>
tui-row-inst = inst
tui-status-cancel-requested = Anulujlation requested
tui-status-config = Konfiguracja
tui-status-configured-listener = Skonfigurowany nasłuch { $addr } jako AE { $ae } ({ $mode })
tui-status-data = dane
tui-status-failure = błąd: { $failure }
tui-status-listener = Nasłuch
tui-status-local-ae = Lokalne AE
tui-status-mode = Tryb
tui-status-mode-on-demand = na żądanie
tui-status-mode-standalone = samodzielny
tui-status-no-active-task = Brak aktywnego zadania to cancel (nothing running)
tui-status-pdu = PDU
tui-status-promiscuous = Promiskuitywny
tui-status-query-before-retrieve = Query a węzeł zdalny first so retrieve knows which węzeł to use
tui-status-query-failed = zapytanie nie powiodło się: { $error }
tui-status-queued-op = Operacja w kolejce: { $op }
tui-status-retrieve-failed = pobranie nie powiodło się: { $error }
tui-status-retrieve-open-failed = nie można otworzyć retrieve stream: { $error }
tui-status-saved-node = saved węzeł { $name } ({ $id })
tui-status-saved-scp = Zapisano ustawienia Storage SCP (wymagany restart)
tui-status-select-node = najpierw wybierz zdalny węzeł
tui-status-select-query = najpierw wybierz wynik zapytania
tui-status-select-study = najpierw wybierz lokalne badanie
tui-status-strict = Ścisły
tui-status-task-cancelled = Zadanie anulowane
tui-status-task-cancelled-detail = Zadanie anulowane: { $other }
tui-status-ts-pref = Preferencja TS
tui-status-updated-node = updated węzeł { $name } ({ $id })
tui-suggest-back-series = Esc — wróć do serii
tui-suggest-edit-config = c — edytuj konfigurację
tui-suggest-help = F1/? — pomoc
tui-suggest-inspect-task = Enter — podgląd zadania
tui-suggest-node-add = node add <ae-title> <host:port>
tui-suggest-query = f — query a węzeł
tui-suggest-query-node = f — query selected węzeł
tui-suggest-retrieve = m — pobierz zaznaczone
tui-suggest-run-command = Enter — uruchom polecenie
tui-suggest-send-series = s — wyślij zaznaczoną serię
tui-suggest-view-series = Enter — zobacz serie
tui-task-cancelled = Anulowane
tui-task-cancelling = Anulowanie
tui-task-failed = Niepowodzenie
tui-task-failed-generic = Zadanie nie powiodło się: { $error }
tui-task-import-done = Importuj complete: { $report }
tui-task-import-failed = Import nie powiódł się: { $error }
tui-task-importing = Import { $path }...
tui-task-query-done =
    Zapytanie zakończone: { $count ->
        [one] { $count } dopasowanie
        [few] { $count } dopasowania
        [many] { $count } dopasowań
       *[other] { $count } dopasowań
    }
tui-task-query-failed = Zapytanie nie powiodło się: { $error }
tui-task-querying = Zapytanie do { $node }...
tui-task-queued = W kolejce
tui-task-retrieve-done = Pobranie zakończone: { $outcome }
tui-task-retrieve-failed = Retrieve nie powiódł się: { $error }
tui-task-retrieving = Retrieve z { $node }...
tui-task-running = W toku
tui-task-sending-series = Wysyłanie serii { $uid } do { $node }...
tui-task-sending-study = Wysyłanie badania { $uid } do { $node }...
tui-task-send-done = Wysyłanie zakończone: { $outcome }
tui-task-status-cancelled = anulowano
tui-task-status-cancelling = anulowanie
tui-task-status-failed = niepowodzenie
tui-task-status-ok = ok
tui-task-status-queued = w kolejce
tui-task-status-running = w toku
tui-task-succeeded = Powodzenie
tui-terminal-too-small = Terminal za mały — zmień rozmiar okna

## Desktop
desktop-action-activity = Aktywność { $count }
desktop-action-activity-empty = Aktywność
desktop-action-import = Importuj
desktop-action-inspect-archive = Sprawdź lokalne archiwum
desktop-action-inspect-archive-desc = Przejrzyj badania, serie i instancje, potem wyślij lub eksportuj.
desktop-action-manage-peers = Zarządzaj peerami
desktop-action-manage-peers-desc = Dodawaj i edytuj węzły PACS lub stacje używane do query, retrieve i store.
desktop-action-monitor-scp = Monitoruj Storage SCP
desktop-action-query = Zapytaj
desktop-action-refresh = Odśwież stan
desktop-action-refresh-status = Odśwież stan
desktop-action-reveal-log = Pokaż plik dziennika
desktop-action-send = Wyślij
desktop-action-start-scp = Uruchom Storage SCP
desktop-activity-empty = Brak aktywności sesji.
desktop-activity-title = Aktywność
desktop-app-title = DICOM Node
desktop-archive-csv = CSV
desktop-archive-details = Szczegóły
desktop-archive-empty = Lokalne archiwum jest puste.
desktop-archive-export-fail = Eksport { $scope } nieudany
desktop-archive-export-ok =
    { $rows ->
        [one] Wyeksportowano { $rows } wiersz { $scope } do { $path }.
       *[other] Wyeksportowano { $rows } wierszy { $scope } do { $path }.
    }
desktop-archive-export-studies = Eksportuj badania
desktop-archive-export-title = Eksportuj { $scope }
desktop-archive-filter = Filtruj według pacjenta, UID, opisu, modalności…
desktop-archive-filter-placeholder = Filtruj według pacjenta, UID, opisu, modalności…
desktop-archive-inst-abbrev =
    { $count ->
        [one] { $count } inst.
        [few] { $count } inst.
        [many] { $count } inst.
       *[other] { $count } inst.
    }
desktop-archive-instance-meta = { $bytes } · TS { $ts } · zaimportowano { $imported }
desktop-archive-instances = Instancje
desktop-archive-instances-heading = Instancje
desktop-archive-json = JSON
desktop-archive-loading = Ładowanie badań…
desktop-archive-no-filter-match = Żadne badanie nie pasuje do filtra.
desktop-archive-no-instances = Nie znaleziono instancji.
desktop-archive-no-match = Żadne badanie nie pasuje do filtra.
desktop-archive-no-nodes = Brak węzłów
desktop-archive-no-series = Nie znaleziono serii.
desktop-archive-reveal-file = Pokaż plik
desktop-archive-select-series = Wybierz serię.
desktop-archive-select-study = Wybierz badanie.
desktop-archive-send-fail = { $label }: { $sent }/{ $attempted } wysłano, { $failed } nieudanych. { $failures }
desktop-archive-send-fail-title = { $label } nieudane
desktop-archive-send-ok = { $label }: wysłano { $sent }/{ $attempted } instancji.
desktop-archive-send-series = Wyślij serię
desktop-archive-send-series-label = Seria → { $destination }
desktop-archive-send-study = Wyślij badanie
desktop-archive-send-study-label = Badanie → { $destination }
desktop-archive-send-to = Wyślij do
desktop-archive-series = Serie
desktop-archive-series-count =
    #{ $number } · { $count ->
        [one] { $count } instancja
       *[other] { $count } instancji
    }
desktop-archive-series-fallback = Serie
desktop-archive-studies = Badania
desktop-archive-study-date = Data badania
desktop-archive-study-uid = Study UID
desktop-archive-subtitle = Inwentarz badań, serii i instancji z lokalnego archiwum SQLite.
desktop-archive-title = Archiwum lokalne
desktop-brand-title = DICOM Node
desktop-col-description = Opis
desktop-col-instances = Instancje
desktop-col-modalities = Modalności
desktop-col-patient-id = ID pacjenta
desktop-common-cancel = Anuluj
desktop-common-clear = Wyczyść
desktop-common-disabled = wyłączone
desktop-common-enabled = włączone
desktop-common-loading = Ładowanie…
desktop-common-no = nie
desktop-common-refresh = Odśwież
desktop-common-yes = tak
desktop-counter-assoc-accepted = Zaakceptowane asocjacje
desktop-counter-bytes-ingested = Bajty pobrane
desktop-counter-cfind-requests = Żądania C-FIND
desktop-counter-cmove-requests = Żądania C-MOVE
desktop-counter-cstore-failed = C-STORE nieudane
desktop-counter-cstore-stored = C-STORE zapisane
desktop-dashboard-counter-assoc-accepted = Zaakceptowane asocjacje
desktop-dashboard-counter-bytes-ingested = Bajty pobrane
desktop-dashboard-counter-c-find-requests = Żądania C-FIND
desktop-dashboard-counter-c-move-requests = Żądania C-MOVE
desktop-dashboard-counter-c-store-failed = C-STORE nieudane
desktop-dashboard-counter-c-store-stored = C-STORE zapisane
desktop-dashboard-empty-studies = Brak lokalnych badań.
desktop-dashboard-inspect-archive-body = Przejrzyj badania, wejdź w serie i instancje, potem wyślij lub eksportuj.
desktop-dashboard-inspect-archive-title = Przeglądaj archiwum lokalne
desktop-dashboard-kv-ae-title = Tytuł AE
desktop-dashboard-kv-data-dir = Katalog danych
desktop-dashboard-kv-listener = Nasłuch
desktop-dashboard-kv-log-file = Plik dziennika
desktop-dashboard-kv-max-pdu = Maks. PDU
desktop-dashboard-kv-promiscuous = Pamięć promiscuous
desktop-dashboard-kv-server = Serwer
desktop-dashboard-kv-store-syntax = Składnia store
desktop-dashboard-kv-strict-pdu = Ścisłe PDU
desktop-dashboard-listener-missing = Listener jeszcze nie załadowany.
desktop-dashboard-live-counters = Liczniki na żywo
desktop-dashboard-loading-metrics = Ładowanie metryk…
desktop-dashboard-loading-status = Ładowanie stanu lokalnego…
desktop-dashboard-loading-studies = Ładowanie badań…
desktop-dashboard-local-node = Węzeł lokalny
desktop-dashboard-manage-peers-body = Dodawaj i edytuj węzły PACS lub stacji do zapytań, pobierania i store.
desktop-dashboard-manage-peers-title = Zarządzaj parami
desktop-dashboard-metric-instances = Instancje
desktop-dashboard-metric-nodes = Węzły zdalne
desktop-dashboard-metric-series = Serie
desktop-dashboard-metric-studies = Badania
desktop-dashboard-monitor-scp = Monitoruj Storage SCP
desktop-dashboard-recent-studies = Ostatnie badania
desktop-dashboard-start-scp = Uruchom Storage SCP
desktop-dashboard-subtitle = Lokalne archiwum, pary sieciowe i aktywność SCP w jednym widoku.
desktop-dashboard-title = Pulpit operatora
desktop-doc-title = DICOM Node
desktop-import-accepted = Zaakceptowane
desktop-import-accepted-bytes = Zaakceptowane bajty
desktop-import-activity-detail = { $accepted }/{ $scanned } zaakceptowane, { $duplicates } duplikatów, { $bytes }
desktop-import-activity-fail = Import nieudany
desktop-import-activity-ok = Import zakończony
desktop-import-choose-archive = Wybierz archiwum ZIP do importu
desktop-import-choose-dir = Wybierz katalog do importu
desktop-import-choose-folder = Folder
desktop-import-choose-zip = Wybierz archiwum ZIP do importu
desktop-import-cleanup = Czyszczenie
desktop-import-clear-path = Wyczyść ścieżkę
desktop-import-complete = Import zakończony
desktop-import-dup-sha = SHA-256
desktop-import-dup-sop = SOP UID
desktop-import-dup-total = Razem
desktop-import-duplicates = Duplikaty
desktop-import-failed = Import nieudany
desktop-import-failed-cleanup = Czyszczenie nieudane
desktop-import-failures = Błędy
desktop-import-failures-heading =
    { $count ->
        [one] { $count } błąd:
       *[other] { $count } błędów:
    }
desktop-import-failures-more = … i jeszcze { $count }
desktop-import-files-progress = { $label } plików
desktop-import-folder = folder
desktop-import-invalid-dicom = Nieprawidłowy DICOM
desktop-import-pick-dir = Wybierz katalog do importu
desktop-import-pick-zip = Wybierz archiwum ZIP do importu
desktop-import-placeholder = /path/to/dicom-folder or /path/to/archive.zip
desktop-import-rejected = Odrzucone
desktop-import-report = Raport importu
desktop-import-running = Importowanie…
desktop-import-scanned = Przeskanowane
desktop-import-skipped = Pominięte
desktop-import-source = Źródło
desktop-import-start = Rozpocznij import
desktop-import-stored = Zapisane
desktop-import-subtitle = Indeksuj pliki DICOM z folderów rekurencyjnych lub archiwów ZIP do zarządzanego archiwum lokalnego.
desktop-import-title = Importuj
desktop-import-unreadable = Nieczytelne
desktop-import-zip = ZIP
desktop-import-zip-filter = Archiwa ZIP
desktop-lang-label = Język
desktop-listener-not-loaded = Listener jeszcze nie załadowany.
desktop-live-counters = Liczniki na żywo
desktop-loading = Ładowanie
desktop-loading-local-status = Ładowanie stanu lokalnego…
desktop-loading-metrics = Ładowanie metryk…
desktop-loading-studies = Ładowanie badań…
desktop-local-node = Węzeł lokalny
desktop-locale-label = Język
desktop-logs-activity-detail =
    { $count ->
        [one] { $count } wiersz załadowany
       *[other] { $count } wierszy załadowanych
    }
desktop-logs-activity-fail = Odświeżenie dziennika nieudane
desktop-logs-activity-ok = Dziennik odświeżony
desktop-logs-auto = AUTO-ODŚW.
desktop-logs-auto-refresh = Automatyczne odświeżanie
desktop-logs-empty = Plik dziennika jest pusty.
desktop-logs-found = ZNALEZIONO PLIK DZIENNIKA
desktop-logs-lines =
    { $count ->
        [one] { $count } wiersz
        [few] { $count } wiersze
        [many] { $count } wierszy
       *[other] { $count } wierszy
    }
desktop-logs-loading = Ładowanie dziennika…
desktop-logs-missing = Aktywny plik dziennika nie został jeszcze utworzony.
desktop-logs-refresh-failed = Odświeżenie dziennika nieudane
desktop-logs-refreshed = Dziennik odświeżony
desktop-logs-reveal = Pokaż
desktop-logs-subtitle = Ograniczony ogon aktywnego pliku dziennika pulpitu.
desktop-logs-tail = Ogon
desktop-logs-title = Dzienniki
desktop-logs-truncated = OBCIĘTE
desktop-logs-waiting = OCZEKIWANIE NA PLIK DZIENNIKA
desktop-metric-instances = Instancje
desktop-metric-remote-nodes = Węzły zdalne
desktop-metric-series = Serie
desktop-metric-studies = Badania
desktop-nav-archive = Archiwum lokalne
desktop-nav-dashboard = Pulpit
desktop-nav-import = Importuj
desktop-nav-logs = Dzienniki
desktop-nav-network = Sieć
desktop-nav-nodes = Węzły zdalne
desktop-nav-query = Zapytanie / pobranie
desktop-nav-server = Serwer przechowywania
desktop-no-local-studies = Brak lokalnych badań.
desktop-nodes-add = Dodaj węzeł
desktop-nodes-added = Dodano węzeł „{ $name }”.
desktop-nodes-ae-length = Tytuł AE może mieć co najwyżej 16 znaków.
desktop-nodes-ae-title = Tytuł AE
desktop-nodes-col-move = Cel Move
desktop-nodes-configured = Skonfigurowane węzły
desktop-nodes-confirm-delete = Usunąć węzeł „{ $name }”?
desktop-nodes-default-port = Domyślny port 104
desktop-nodes-delete = Usuń węzeł
desktop-nodes-delete-title = Usuń węzeł
desktop-nodes-deleted = Usunięto węzeł „{ $name }”.
desktop-nodes-edit = Edytuj węzeł
desktop-nodes-edit-title = Edytuj węzeł
desktop-nodes-empty = Brak węzłów zdalnych.
desktop-nodes-err-ae = Tytuł AE jest wymagany.
desktop-nodes-err-ae-len = Tytuł AE może mieć co najwyżej 16 znaków.
desktop-nodes-err-host = Host jest wymagany.
desktop-nodes-err-name = Nazwa jest wymagana.
desktop-nodes-err-port = Port musi być z zakresu 1–65535.
desktop-nodes-host = nazwa hosta
desktop-nodes-move-dest = Cel Move
desktop-nodes-move-placeholder = Domyślnie: lokalne AE
desktop-nodes-name = Nazwa
desktop-nodes-need-ae = Tytuł AE jest wymagany.
desktop-nodes-need-host = Host jest wymagany.
desktop-nodes-need-name = Nazwa jest wymagana.
desktop-nodes-notes = Notatki
desktop-nodes-notes-placeholder = PACS pracowni opisowej
desktop-nodes-placeholder-ae = PACS01
desktop-nodes-placeholder-host = 192.168.0.10
desktop-nodes-placeholder-move = Domyślnie: lokalne AE
desktop-nodes-placeholder-name = main-pacs
desktop-nodes-placeholder-notes = PACS pracowni opisowej
desktop-nodes-port = numer portu
desktop-nodes-port-104 = Domyślny port 104
desktop-nodes-port-range = Port musi być w zakresie 1–65535.
desktop-nodes-save = Zapisz zmiany
desktop-nodes-save-changes = Zapisz zmiany
desktop-nodes-subtitle = Pary PACS i stacji do zapytań, pobierania i store.
desktop-nodes-summary = Podsumowanie węzłów
desktop-nodes-title = Węzły zdalne
desktop-nodes-total = Łącznie węzłów
desktop-nodes-updated = Zaktualizowano węzeł „{ $name }”.
desktop-nodes-with-move = Z celem Move
desktop-promiscuous = Pamięć promiscuous
desktop-query-accession = Accession nr
desktop-query-activity-detail = { $count } { $count ->
        [one] trafienie
       *[other] trafień
    } na poziomie { $level }
desktop-query-activity-fail = C-FIND { $node } nieudane
desktop-query-activity-ok = C-FIND { $node }
desktop-query-activity-title = C-FIND { $node }
desktop-query-clear = Wyczyść
desktop-query-col-accession = numer accession
desktop-query-criteria = Kryteria wyszukiwania
desktop-query-date-from = Data badania od
desktop-query-date-to = Data badania do
desktop-query-kv-series-uid = Series UID
desktop-query-kv-sop-uid = SOP UID
desktop-query-kv-study-uid = Study UID
desktop-query-level = Poziom
desktop-query-matches =
    { $count ->
        [one] { $count } trafienie
       *[other] { $count } trafień
    }
desktop-query-missing-study-uid = Trafienie nie ma StudyInstanceUID; nie można pobrać.
desktop-query-modality = Modalność
desktop-query-no-matches = Brak trafień.
desktop-query-no-nodes = Brak skonfigurowanych węzłów
desktop-query-patient-id = ID pacjenta
desktop-query-patient-name = Imię pacjenta
desktop-query-placeholder-description = CHEST*
desktop-query-placeholder-modality = CT, MR, …
desktop-query-placeholder-name = DOE^JOHN or DOE*
desktop-query-placeholder-patient = DOE^JOHN or DOE*
desktop-query-querying = Zapytanie…
desktop-query-remote-node = Węzeł zdalny
desktop-query-results = Wyniki
desktop-query-retrieve = Pobierz
desktop-query-retrieve-activity-detail = completed={ $completed }, warning={ $warning }, failed={ $failed }
desktop-query-retrieve-activity-fail = C-MOVE { $node } nieudane
desktop-query-retrieve-activity-ok = C-MOVE { $node }
desktop-query-retrieve-finished = Pobieranie zakończone: ukończone { $completed }, ostrzeżenia { $warning }, nieudane { $failed }.
desktop-query-retrieve-selected = Pobierz wybrane
desktop-query-run = Uruchom C-FIND
desktop-query-run-select = Uruchom zapytanie i wybierz trafienie.
desktop-query-running = Zapytanie…
desktop-query-search-criteria = Kryteria wyszukiwania
desktop-query-select-hint = Uruchom zapytanie i wybierz trafienie.
desktop-query-selected = Wybrane trafienie
desktop-query-selected-match = Wybrane trafienie
desktop-query-series-uid = Series Instance UID
desktop-query-sop-uid = SOP Instance UID
desktop-query-study-description = Opis badania
desktop-query-study-uid = Study Instance UID
desktop-query-subtitle = C-FIND do węzła zdalnego, przegląd trafień, potem C-MOVE do archiwum lokalnego.
desktop-query-title = Zapytanie / pobranie
desktop-recent-studies = Ostatnie badania
desktop-scp-listening = SCP nasłuchuje
desktop-scp-stopped = SCP zatrzymany
desktop-server-activity-fail = Sterowanie Storage SCP nieudane
desktop-server-activity-started = Storage SCP uruchomiony
desktop-server-activity-started-detail = Listener uruchomiony.
desktop-server-activity-stopped = Storage SCP zatrzymany
desktop-server-activity-stopped-detail = received={ $received }, stored={ $stored }, failed={ $failed }
desktop-server-activity-stopped-empty = Brak aktywnej sesji.
desktop-server-addr-ae = { $addr } · AE { $ae }
desktop-server-assoc-accepted = Zaakceptowane asocjacje
desktop-server-assoc-rejected = Odrzucone asocjacje
desktop-server-cfind-req-matches = Żądania / trafienia C-FIND
desktop-server-cget-requests = Żądania C-GET
desktop-server-cmove-requests = Żądania C-MOVE
desktop-server-cmove-subops = Podoperacje C-MOVE ukończone / nieudane
desktop-server-control-failed = Sterowanie Storage SCP nieudane
desktop-server-counter-bytes = Bajty pobrane
desktop-server-counter-failed = C-STORE nieudane
desktop-server-counter-find = Żądania / trafienia C-FIND
desktop-server-counter-get = Żądania C-GET
desktop-server-counter-move = Żądania C-MOVE
desktop-server-counter-move-sub = Podoperacje C-MOVE ukończone / nieudane
desktop-server-counter-received = C-STORE odebrane
desktop-server-counter-stored = C-STORE zapisane
desktop-server-cstore-failed = C-STORE nieudane
desktop-server-cstore-received = C-STORE odebrane
desktop-server-cstore-stored = C-STORE zapisane
desktop-server-dimse = Liczniki DIMSE
desktop-server-failed = Nieudane
desktop-server-health-loading = Ładowanie metryk
desktop-server-health-ready = Gotowy na przychodzące C-STORE
desktop-server-health-review = Przejrzyj błędy
desktop-server-health-stopped = Zatrzymany
desktop-server-listener-started = Listener uruchomiony.
desktop-server-listening = NASŁUCHUJE
desktop-server-loading-metrics = Ładowanie metryk…
desktop-server-logs = Dzienniki
desktop-server-no-session = Brak aktywnej sesji.
desktop-server-rate = +{ $rate } / odpytanie
desktop-server-ready = Gotowy na przychodzące C-STORE
desktop-server-review-failures = Przejrzyj błędy
desktop-server-session-ended = Sesja zakończona: odebrane { $received }, zapisane { $stored }, nieudane { $failed }.
desktop-server-start = Uruchom serwer
desktop-server-started-title = Storage SCP uruchomiony
desktop-server-stop = Zatrzymaj serwer
desktop-server-stopped = ZATRZYMANY
desktop-server-stopped-pill = ZATRZYMANY
desktop-server-stopped-status = Zatrzymany
desktop-server-stopped-title = Storage SCP zatrzymany
desktop-server-stored = Zapisane
desktop-server-subtitle = Samodzielny Storage SCP dla przychodzącego C-STORE i indeksowania archiwum lokalnego.
desktop-server-title = Serwer przechowywania
desktop-status-listening = nasłuchuje
desktop-status-loading = Ładowanie
desktop-status-scp-listening = SCP nasłuchuje
desktop-status-scp-stopped = SCP zatrzymany
desktop-status-stopped = zatrzymany
desktop-store-syntax = Składnia store
desktop-strict-pdu = Ścisłe PDU
desktop-strip-pdu = PDU { $value }
desktop-table-accession = Numer dostępu
desktop-table-ae-title = Tytuł AE
desktop-table-date = Data
desktop-table-description = Opis
desktop-table-endpoint = Punkt końcowy
desktop-table-instances = Instancje
desktop-table-modalities = Modalności
desktop-table-modality = Modalność
desktop-table-move-dest = Cel Move
desktop-table-name = Nazwa
desktop-table-notes = Notatki
desktop-table-patient = Pacjent
desktop-table-patient-id = ID pacjenta
desktop-table-series = Serie
desktop-table-updated = Zaktualizowano
desktop-title-refresh-status = Odśwież stan
desktop-title-reveal-log = Pokaż plik dziennika
ae = AE
patient-name =
    "DOE^JOHN"
    Naciśnij 'm' na wybranym wyniku, aby otworzyć retrieve.
port = numer portu

## Summary
summary-ae = AE
summary-counts = Liczniki
summary-criteria = Kryteria
summary-duration = Czas trwania
summary-duration-ms = { $ms }ms
summary-failures = Niepowodzenia:
summary-kind = Rodzaj
summary-logs = Dzienniki:
summary-peer = Węzeł
summary-status = stan
summary-title = Podsumowanie operacji
tui-detail-created = Utworzono

tui-form-hint-port-range = wskazówka: liczba od 1 do 65535, np. 104
tui-form-hint-promiscuous = wskazówka: zezwól na zapis z dowolnego wywołującego AE title
tui-form-hint-strict-pdu = wskazówka: wymuszaj kontrole rozmiaru PDU podczas asocjacji
tui-form-hint-max-pdu-bytes = wskazówka: bajty, np. 16384
tui-form-limits-heading = Limits (bytes; blank/brak = unlimited):
tui-form-field-max-file-import = Maks. bajty importu pliku
tui-form-field-max-zip-entry = Maks. bajty wpisu ZIP
tui-form-field-max-zip-total = Maks. łączne bajty ZIP
tui-form-field-max-zip-count = Maks. liczba wpisów ZIP
tui-form-field-max-store-object = Maks. bajty obiektu store
tui-form-unlimited = bez limitu
tui-form-err-max-pdu-required = ! maks. długość PDU jest wymagana
tui-form-err-max-pdu-gt-zero = ! maks. długość PDU musi być liczbą całkowitą większą niż 0
tui-form-err-limit-gt-zero = ! { $label } musi być liczbą całkowitą większą niż 0
tui-form-controls-scp = Pisz, aby edytować. Spacja przełącza pola. Tab/Shift-Tab lub Góra/Dół zmienia pola. Enter zapisuje. Esc anuluje.
tui-form-submit-uid-required = UID jest wymagane
tui-form-submit-dest-required = destination węzeł is required
tui-form-submit-nonneg-int = { $label } musi być nieujemną liczbą całkowitą
tui-form-submit-gt-zero = { $label } musi być większe niż 0
tui-form-submit-local-ae-required = lokalny AE title jest wymagany
tui-form-submit-local-ae-invalid = lokalny AE title jest nieprawidłowy: { $err }
tui-form-submit-bind-required = adres bindowania jest wymagany
tui-form-submit-port-required = port jest wymagany
tui-form-submit-max-pdu-required = maks. długość PDU jest wymagana
tui-form-submit-max-pdu-int = maks. długość PDU musi być liczbą całkowitą
tui-form-submit-max-pdu-gt-zero = maks. długość PDU musi być większa niż 0
tui-form-submit-patient-retrieve = pobranie na poziomie pacjenta nie jest obsługiwane
tui-form-submit-no-study-uid = zaznaczony wynik nie zawiera study UID
tui-form-submit-date-format = oczekiwano YYYYMMDD
tui-form-submit-modality-len = modalność może mieć co najwyżej 16 znaków
tui-form-submit-modality-chars = modalność musi być A-Z lub 0-9
tui-form-submit-name-required = nazwa węzła jest wymagana
tui-form-submit-ae-required = AE title jest wymagany
tui-form-submit-host-required = host jest wymagany
tui-form-submit-move-dest-invalid = AE title celu przeniesienia jest nieprawidłowy: { $err }
tui-form-submit-dates-both = data od i data do muszą być obie ustawione albo żadna
tui-form-submit-date-from-invalid = data od jest nieprawidłowa: { $err }
tui-form-submit-date-to-invalid = data do jest nieprawidłowa: { $err }
tui-form-submit-date-order = data od musi być nie późniejsza niż data do
tui-form-submit-study-uid-series-query = study UID jest wymagane dla zapytań na poziomie serii
tui-form-submit-study-uid-image-query = study UID jest wymagane dla zapytań na poziomie obrazu
tui-form-submit-series-uid-image-query = series UID jest wymagane dla zapytań na poziomie obrazu
tui-form-submit-study-uid-required = study UID jest wymagane
tui-form-submit-study-uid-invalid = study UID jest nieprawidłowe: { $err }
tui-form-submit-series-uid-series-retrieve = series UID jest wymagane do pobrania na poziomie serii
tui-form-submit-series-uid-image-retrieve = series UID jest wymagane do pobrania na poziomie obrazu
tui-form-submit-instance-uid-image-retrieve = instance UID jest wymagane do pobrania na poziomie obrazu
tui-form-submit-series-uid-invalid = series UID jest nieprawidłowe: { $err }
tui-form-submit-instance-uid-invalid = instance UID jest nieprawidłowe: { $err }
tui-form-submit-import-path-required = ścieżka importu jest wymagana
tui-form-submit-import-path-type = ścieżka importu musi być plikiem lub katalogiem: { $path }
tui-form-submit-import-access = dostęp do ścieżki importu { $path }
tui-form-submit-import-open = otwieranie pliku importu { $path }
tui-form-submit-import-read-dir = odczyt katalogu importu { $path }
tui-log-welcome = Press F1 or ? for help. Focus Węzeł zdalnys and press 'a' to add one.
tui-log-logging-to = Logowanie do { $path }
tui-command-help-heading = polecenia:
tui-command-help-next-1 = uwaga: stopka pokazuje kontekstowe podpowiedzi 'Next:' na podstawie aktywnego panelu i wyboru.
tui-command-help-next-2 = To tylko wskazówki; zawsze możesz wpisać dowolne polecenie.
tui-command-help-canonical = uwaga: nazwy kanoniczne odpowiadają flagom CLI bez '--', z podkreśleniami.
tui-command-help-cancel = anuluj (alias: stop)
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
tui-command-help-refresh = odśwież
tui-command-help-quit = wyjdź
tui-inspect-task = Zadanie #{ $id }
tui-inspect-status = Stan: { $status }
tui-inspect-description = Opis: { $description }
tui-inspect-progress = Postęp: { $progress }
tui-inspect-summary = Podsumowanie:
tui-inspect-no-logs = (brak dzienników)
tui-field-sop-class-uid = SOP Class UID
tui-field-transfer-syntax-uid = Transfer Syntax UID
tui-field-sha256 = SHA-256
tui-status-removed-nodes =
    usunięto { $count ->
        [one] { $count } węzeł
        [few] { $count } węzły
        [many] { $count } węzłów
       *[other] { $count } węzłów
    }
tui-status-removed-nodes-target =
    usunięto { $count ->
        [one] { $count } węzeł
        [few] { $count } węzły
        [many] { $count } węzłów
       *[other] { $count } węzłów
    }; ostatni cel to { $name }
tui-status-more-failures =
    oraz { $n ->
        [one] { $n } pominięta awaria
        [few] { $n } pominięte awarie
        [many] { $n } pominiętych awarii
       *[other] { $n } pominiętych awarii
    }
tui-status-retrieve-ok = retrieve status=0x{ $status } completed={ $completed } failed={ $failed } warning={ $warning } remaining={ $remaining }
tui-status-import-counts = scanned={ $scanned } accepted={ $accepted } duplicates={ $duplicates } unreadable={ $unreadable } invalid_dicom={ $invalid } rejected_total={ $rejected } stored_bytes={ $bytes }
tui-status-send-ok = send attempted={ $attempted } sent={ $sent } failed={ $failed }
tui-log-query-start = Uruchamianie zapytania do { $node }
tui-log-retrieve-start = Uruchamianie pobierania z { $node }
tui-log-import-start = Uruchamianie importu { $path }
tui-log-send-study-start = Uruchamianie wysyłania badania { $uid } do { $node }
tui-log-send-series-start = Uruchamianie wysyłania serii { $uid } do { $node }
tui-log-cancelled-before-start = anulowano przed startem
tui-log-cancelled = anulowano
error-unknown-command = nieznane polecenie: { $command }
error-node-subcommand-required = wymagany podpolecenie node
error-local-subcommand-required = wymagane podpolecenie local
error-unsupported-node-subcommand = unsupported węzeł subcommand: { $command }
error-unsupported-local-subcommand = nieobsługiwane podpolecenie local: { $command }
error-expected-kv = oczekiwano argumentu key=value, otrzymano { $arg }
error-missing-required-arg = brak wymaganego argumentu: { $key }
error-missing-required-arg-one-of = brak wymaganego argumentu: jeden z { $keys }
error-parsing-command = parsowanie polecenia
error-edit-form-lost-target = edit form lost its target węzeł
error-task-already-running = zadanie w tle już działa
error-task-thread-launch = nie udało się uruchomić wątku zadania w tle: { $error }
error-task-disconnected = wątek zadania w tle rozłączył się przed wysłaniem wyniku
error-task-kind-missing = wątek w tle rozłączył się, ale active_task_kind było None: nieoczekiwany stan
error-serve-exited = serve zakończył się błędem: { $error }
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
summary-title = Podsumowanie operacji
summary-kind = Rodzaj
summary-status = stan
summary-duration = Czas trwania
summary-duration-ms = { $ms }ms
summary-peer = Węzeł
summary-ae = AE
summary-criteria = Kryteria
summary-counts = Liczniki
summary-failures = Niepowodzenia:
summary-logs = Dzienniki:
summary-unserializable = <nieserializowalne>
summary-log-lines = wiersze { $start }-{ $end }
