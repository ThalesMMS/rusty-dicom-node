# Fluent catalog (uk-UA). Message IDs are hyphenated identifiers
# (cli-about, tui-pane-remote-nodes, desktop-nav-dashboard, error-import-file-too-large).
# Dotted names are Fluent attributes (message + .attr), not message IDs.
# Do not translate DICOM tokens (C-FIND, C-MOVE, C-STORE, SOP, AE, UID) or JSON/CSV machine keys.


## CLI
cli-about = Термінальний клієнт DICOM-вузла на базі dicom-rs
cli-arg-accession-number = Фільтрувати за accession number (підрядок, без урахування регістру).
cli-arg-ae-title = Application Entity title
cli-arg-destination-node = Назва або id вузла призначення
cli-arg-duplicate = Фільтрувати за статусом дубліката.
cli-arg-export = Експортувати результати як JSON або CSV.
cli-arg-host = Ім’я хоста або IP
cli-arg-imported-at =
    Фільтрувати за часом імпорту. Підтримує VALUE, START..END, ..END, START...
    Порівняння лексикографічне (рекомендований формат: RFC3339).
cli-arg-json = Вивести підсумковий звіт операції як JSON (стабільна схема).
cli-arg-level = Рівень запиту/отримання
cli-arg-metrics-json = Надрукувати підсумковий знімок метрик сервера в пам’яті як JSON при виході з сервера.
cli-arg-modality = Фільтрувати за модальністю. Список через кому (напр. CT,MR).
cli-arg-model = Інформаційна модель запиту/отримання
cli-arg-move-destination = Бажаний AE title призначення для C-MOVE
cli-arg-name = Відображувана назва вузла
cli-arg-node = Назва або id збереженого вузла
cli-arg-notes = Вільні примітки
cli-arg-out = Шлях до файлу виводу. Якщо не вказано, пише в stdout.
cli-arg-path = Файл або каталог для імпорту
cli-arg-patient-id = Фільтрувати за ID пацієнта (підрядок, без урахування регістру).
cli-arg-patient-name = Фільтрувати за ім’ям пацієнта (підрядок, без урахування регістру).
cli-arg-port = Порт
cli-arg-series-description = Фільтрувати за описом серії (підрядок, без урахування регістру).
cli-arg-series-instance-uid = Series Instance UID
cli-arg-sop-instance-uid = SOP Instance UID
cli-arg-source-path = Фільтрувати за шляхом джерела (підрядок, без урахування регістру).
cli-arg-study-date =
    Фільтрувати за датою дослідження. Підтримує VALUE, START..END, ..END, START...
    Дати порівнюються лексикографічно (рекомендований формат: YYYYMMDD).
cli-arg-study-date-from = Нижня межа дати дослідження (YYYYMMDD)
cli-arg-study-date-to = Верхня межа дати дослідження (YYYYMMDD)
cli-arg-study-description = Фільтрувати за описом дослідження (підрядок, без урахування регістру).
cli-arg-study-instance-uid = Study Instance UID
cli-cmd-import-about = Імпортувати файли DICOM зі шляху
cli-cmd-local-about = Переглянути локальний архів
cli-cmd-local-series-about = Перелічити індексовані серії дослідження
cli-cmd-local-studies-about = Перелічити індексовані локальні дослідження
cli-cmd-node-about = Керувати збереженими віддаленими DICOM-вузлами
cli-cmd-node-add-about = Додати віддалений вузол
cli-cmd-node-delete-about = Видалити збережений вузол
cli-cmd-node-edit-about = Редагувати збережений вузол
cli-cmd-node-list-about = Перелічити збережені вузли
cli-cmd-query-about = Запитати віддалений вузол (C-FIND)
cli-cmd-retrieve-about = Отримати з віддаленого вузла (C-MOVE)
cli-cmd-send-about = Надіслати локальні дослідження або серії (C-STORE)
cli-cmd-send-series-about = Надіслати серію на вузол призначення
cli-cmd-send-study-about = Надіслати дослідження на вузол призначення
cli-cmd-serve-about = Запустити DICOM-сервер
cli-cmd-storage-scp-about = Запустити слухач Storage SCP
cli-cmd-tui-about = Відкрити інтерактивний терміналний інтерфейс
cli-flag-help = Показати довідку
cli-flag-lang = Мова інтерфейсу (тег BCP-47). Перевизначає DICOM_NODE_LANG, збережену локаль і локаль ОС.
cli-flag-version = Показати версію
cli-heading-arguments = Аргументи:
cli-heading-commands = Команди:
cli-heading-options = Параметри:
cli-heading-usage = Використання:
cli-import-accepted = accepted={ $n }
cli-import-complete = Імпорт завершено
cli-import-duplicates = duplicates={ $n }
cli-import-scanned = scanned={ $n }
cli-msg-cancel-sigint = Запитано скасування (SIGINT). Очікування коректного завершення...
cli-msg-failures = збої:
cli-msg-import-failed = Імпорт не вдався: { $error }
cli-msg-no-local-series = Немає індексованих серій для дослідження { $uid }
cli-msg-no-local-studies = Немає індексованих локальних досліджень
cli-msg-no-saved-nodes = Немає збережених вузлів
cli-msg-query-failed = Запит не вдався: { $error }
cli-msg-removed-nodes =
    Видалено { $count ->
        [one] { $count } вузол
        [few] { $count } вузли
        [many] { $count } вузлів
       *[other] { $count } вузлів
    }
cli-msg-results-count =
    Результати: { $count ->
        [one] { $count } збіг
        [few] { $count } збіги
        [many] { $count } збігів
       *[other] { $count } збігів
    }
cli-msg-retrieve-failed = Отримання не вдалося: { $error }
cli-msg-saved-node = Збережено вузол { $name } [{ $id }] => { $ae }@{ $host }:{ $port }
cli-msg-send-failed = Надсилання не вдалося: { $error }
cli-msg-showing-failures = (показано перші { $shown } з { $total } збоїв)
cli-msg-starting-server =
    Запуск DICOM-сервера з { $count ->
        [one] { $count } локальний AE
        [few] { $count } локальні AE
        [many] { $count } локальних AE
       *[other] { $count } локальних AE
    }: { $aes }
cli-msg-starting-server-no-aes = Запуск DICOM-сервера без налаштованих локальних AE
cli-msg-starting-storage-scp = Запуск storage SCP на { $addr } з AE title { $ae }
cli-msg-updated-node = Оновлено вузол { $name } [{ $id }] => { $ae }@{ $host }:{ $port }
cli-send-attempted = attempted={ $n }
cli-send-failed-count = failed={ $n }
cli-send-sent = sent={ $n }
cli-value-name-file = FILE
cli-value-name-format = FORMAT
cli-value-name-locale = LOCALE
cli-value-name-path = PATH
tui-detail-more-series =
    ... { $n ->
        [one] { $n } серія ще
        [few] { $n } серії ще
        [many] { $n } серій ще
       *[other] { $n } серій ще
    }
tui-row-instance-count =
    { $n ->
        [one] { $n } екз.
        [few] { $n } екз.
        [many] { $n } екз.
       *[other] { $n } екз.
    }
tui-row-study-counts = { $series }s/{ $instances }i
count-nodes =
    { $n ->
        [one] { $n } вузол
        [few] { $n } вузли
        [many] { $n } вузлів
       *[other] { $n } вузлів
    }
count-instances =
    { $n ->
        [one] { $n } екземпляр
        [few] { $n } екземпляри
        [many] { $n } екземплярів
       *[other] { $n } екземплярів
    }
count-series =
    { $n ->
        [one] { $n } серія
        [few] { $n } серії
        [many] { $n } серій
       *[other] { $n } серій
    }
count-studies =
    { $n ->
        [one] { $n } дослідження
        [few] { $n } дослідження
        [many] { $n } досліджень
       *[other] { $n } досліджень
    }
format-datetime = { $date } { $time }
format-date = { $day }.{ $month }.{ $year }

## Common
common-accession = Номер звернення
common-add = Додати
common-back = Назад
common-bytes = Байти
common-cancel = Скасувати
common-clear = Очистити
common-close = Закрити
common-date = Дата
common-delete = Видалити вузол
common-description = Опис
common-disabled = вимкнено
common-duplicates = Дублікати
common-edit = Редагувати
common-enabled = увімкнено
common-error = Помилка
common-filter = Фільтр
common-host = Хост
common-import = Імпорт
common-instance = Примірник
common-language = Мова
common-loading = Завантаження
common-matches = Збіги
common-modality = Модальність
common-name = Ім’я
common-network = Мережа
common-no = ні
common-none = немає
common-notes = Нотатки
common-optional = необов’язково
common-path = Джерело
common-patient = Пацієнт
common-patient-id = ID пацієнта
common-patient-name = Ім’я пацієнта
common-port = Порт
common-query = Запит
common-refresh = Оновити
common-required = обов’язково
common-retrieve = Отримати
common-save = Зберегти
common-search = Пошук
common-send = Надіслати
common-series = Серії
common-start = Запустити
common-status = Статус
common-stop = Зупинити
common-studies = Дослідження
common-study = Дослідження
common-unknown = невідомо
common-unknown-series = <Серії>
common-unknown-study = <Дослідження>
common-yes = так

## Errors
error-ae-empty = AE title не може бути порожнім
error-ae-invalid-char = AE title містить неприпустимий символ '{ $character }'; дозволено: A-Z, 0-9, пробіл
error-ae-required = AE title обов’язковий
error-ae-too-long = AE title має містити щонайбільше 16 символів
error-ae-whitespace = AE title не може мати пробіли на початку чи в кінці
error-archive-patient-retrieve-out-of-scope = retrieve рівня Patient поза межами підтримки
error-archive-retrieve-uid-required = для цього рівня retrieve потрібен { $name }
error-archive-study-root-patient-query = запити Study Root не підтримують рівень Patient
error-archive-study-root-patient-retrieve = retrieve Study Root не підтримує рівень Patient
error-assoc-negotiation-failed = узгодження асоціації не вдалося з { $name } ({ $addr }); підказка: перевірте called AE title, presentation contexts/transfer syntaxes і що вузол приймає асоціації
error-assoc-no-addresses = немає адрес сокета для { $name } на { $host }:{ $port }
error-assoc-receive = прийом асоціації
error-assoc-resolving = розв’язання { $name } на { $host }:{ $port }: { $err }
error-assoc-timeout = час очікування відповіді DIMSE вичерпано; підказка: перевірте мережу, AE title/хост/порт і відгук вузла
error-assoc-transport = переривання транспорту під час очікування відповіді DIMSE; підказка: вузол закрив з’єднання або мережевий пристрій його скинув
error-assoc-unreachable = не вдалося досягти { $name } [{ $ae }] на { $host }:{ $port } за { $seconds }с: { $err }. Перевірте хост/IP, порт і доступність мережі
error-cancel-sigint = Запит на скасування (SIGINT). Очікування коректного завершення...
error-config-must-be-positive = неприпустима config: { $name } має бути > 0 (або null, щоб вимкнути)
error-config-duplicate-bind-port = неприпустима config: повторюваний bind-порт локального AE { $port }
error-config-local-ae-max-assoc = неприпустима config: локальний AE { $title } max_concurrent_associations має бути > 0
error-config-local-ae-no-services = неприпустима config: локальний AE { $title } має увімкнути принаймні одну службу
error-config-must-be-positive-required = неприпустима config: { $name } має бути > 0
error-dicom-meta-incomplete = метадані файлу DICOM неповні
error-dicom-patient-move-unsupported = C-MOVE на рівні пацієнта не підтримується цим клієнтом
error-dicom-required-attribute = відсутній обов’язковий атрибут DICOM: ({ $group },{ $element })
error-dicom-series-uid-required-image = series_instance_uid обов’язковий для отримання на рівні зображення
error-dicom-series-uid-required-series = series_instance_uid обов’язковий для отримання на рівні серії
error-dicom-sop-uid-required-image = sop_instance_uid обов’язковий для отримання на рівні зображення
error-dicom-study-uid-required = study_instance_uid обов’язковий
error-dicom-validating-move = перевірка запиту move
error-export-creating-file = створення файлу експорту { $path }: { $err }
error-export-flushing-series-csv = скидання CSV серій: { $err }
error-export-flushing-studies-csv = скидання CSV досліджень: { $err }
error-export-serializing-series-json = серіалізація JSON серій: { $err }
error-export-serializing-studies-json = серіалізація JSON досліджень: { $err }
error-export-writing-series-csv-header = запис заголовка CSV серій: { $err }
error-export-writing-series-csv-row = запис рядка CSV серій: { $err }
error-export-writing-studies-csv-header = запис заголовка CSV досліджень: { $err }
error-export-writing-studies-csv-row = запис рядка CSV досліджень: { $err }
error-import-cleanup-failed = { $source }: очищення не вдалося: { $reason }
error-import-corrupt-zip = Пошкоджений ZIP: { $details }
error-import-dicom-parse-failed = розбір DICOM не вдався: { $err }
error-import-dicom-validation-failed = перевірка DICOM не вдалася: { $err }
error-import-duplicate-zip-path = Дубльований шлях ZIP: { $details }
error-import-file-too-large = файл занадто великий: { $details }
error-import-invalid-dicom = Неприпустимий DICOM: { $details }
error-import-limit-exceeded = { $limit } перевищено: { $details }
error-import-not-regular-file = не звичайний файл
error-import-opening-file = відкриття файлу: { $err }
error-import-opening-kind = відкриття { $kind } { $path }
error-import-opening-staged-file = відкриття проміжного файлу: { $err }
error-import-opening-zip-archive = відкриття ZIP-архіву { $path }
error-import-opening-zip-entry = відкриття запису ZIP: { $err }
error-import-opening-zip-file = відкриття ZIP-файлу імпорту { $path }
error-import-path-does-not-exist = Шлях імпорту не існує: { $path }
error-import-reading-directory = читання каталогу імпорту { $path }
error-import-reading-file = читання файлу: { $err }
error-import-reading-file-metadata = читання метаданих файлу для { $path }
error-import-reading-metadata = читання метаданих для { $kind } { $path }
error-import-reading-zip-entry = читання запису ZIP: { $err }
error-import-removing-staged-after-cancel = видалення проміжного файлу після скасування { $path }
error-import-skipped = Пропущено: { $details }
error-import-unreadable = Нечитабельний файл: { $details }
error-import-unsafe-zip-path = Небезпечний шлях ZIP: { $details }
error-import-zip-entry-count-exceeded = перевищено ліміт кількості записів ZIP: архів має { $count } записів, ліміт { $limit }
error-import-zip-entry-size-exceeded = розмір запису ZIP { $size } перевищує ліміт { $limit }
error-import-zip-total-bytes-exceeded = перевищено ліміт загальних розпакованих байтів ZIP: поточна сума { $current } плюс розмір запису { $entry } перевищує ліміт { $limit }
error-net-binding-storage-scp = прив’язка Storage SCP на { $addr } для AE { $ae }. Інший локальний DICOM-приймач, можливо, уже використовує цей порт. Оновіть storage_scp_port/local_aes у { $config } або зупиніть конфліктний слухач
error-net-building-file-meta = побудова таблиці file meta
error-net-cannot-send-transfer-syntax = не можна надіслати вихідний transfer syntax { $source } з узгодженим { $negotiated }
error-net-cget-dataset-empty = закодований набір даних C-GET C-STORE порожній
error-net-cget-dataset-odd-length = закодований набір C-GET C-STORE завершився фрагментом непарної довжини
error-net-cget-peer-released = вузол звільнив асоціацію під час C-GET
error-net-cget-store-unexpected-dataset = неочікуваний dataset fragment in C-GET C-STORE response
error-net-cget-unexpected-command = неочікуваний command 0x{ $command } while waiting for C-STORE-RSP
error-net-cget-unexpected-pdu = неочікуваний PDU during C-GET C-STORE suboperation: { $pdu }
error-net-creating-incoming-dir = створення каталогу .incoming Storage SCP
error-net-creating-path = створення { $path }
error-net-dataset-empty = закодований набір порожній, але COMMAND_DATA_SET_TYPE вимагає набір даних
error-net-dataset-odd-length = закодований набір завершився фрагментом непарної довжини
error-net-dimse-failed = { $operation } завершилося зі статусом 0x{ $status } ({ $meaning }){ $hint }
error-net-establishing-assoc = встановлення асоціації Storage SCP
error-net-file-meta-length = читання File Meta Information length
error-net-file-meta-tag = читання File Meta Information tag
error-net-file-meta-value = пропуск значення File Meta Information
error-net-file-meta-vr = читання File Meta Information VR
error-net-file-position = читання file position
error-net-flushing-path = скидання { $path }
error-net-flushing-temp-dataset = скидання тимчасового файлу набору даних
error-net-hint-suffix = ; підказка: { $hint }
error-net-incomplete-command = неповний { $operation } command response
error-net-incomplete-identifier = неповний { $operation } response identifier
error-net-invalid-affected-sop = недійсний { $operation } affected SOP class UID
error-net-invalid-status = недійсний { $operation } status
error-net-listener-address = читання storage SCP listener address
error-net-listener-nonblocking = увімкнення неблокувального режиму слухача
error-net-listener-port = читання storage SCP listener port
error-net-local-aes-empty = local_aes має містити принаймні один AE для запуску Storage SCP
error-net-locating-dataset = пошук набору даних у { $path }
error-net-malformed-dimse = malformed { $operation } DIMSE response: { $details }; підказка: peer sent an недійсний or неочікуваний DIMSE command set
error-net-missing-affected-sop =  відсутній { $operation } affected SOP class UID
error-net-missing-command-field =  відсутній command field
error-net-missing-cstore-rsp-command-field =  відсутній C-STORE response command field
error-net-missing-cstore-rsp-status =  відсутній C-STORE response status
error-net-missing-destination =  відсутній C-MOVE destination
error-net-missing-dicm =  відсутній Part 10 DICM marker
error-net-missing-message-id =  відсутній { $operation } message id
error-net-missing-qr-level = { $operation } identifier is  відсутній QueryRetrieveLevel
error-net-missing-required-command-field =  відсутній required command field { $name } ({ $tag })
error-net-missing-status =  відсутній { $operation } status
error-net-move-destination-unresolved = move_destination не розв’язано
error-net-no-cget-store-context = немає узгодженого presentation context сховища C-GET для SOP Class { $sop } і transfer syntax { $syntax }
error-net-no-compatible-context = { $path }: немає сумісного узгодженого presentation context для вихідного transfer syntax { $syntax }
error-net-no-dimse-provider = немає зареєстрованого постачальника DIMSE для команди 0x{ $command } і abstract syntax { $syntax }
error-net-no-presentation-context = немає узгодженого presentation context
error-net-no-presentation-context-for-file = { $path }: немає узгодженого presentation context
error-net-no-presentation-context-id =  відсутній negotiated presentation context { $id }
error-net-opening-path = відкриття { $path }
error-net-part10-preamble = читання Part 10 preamble
error-net-path-error = { $path }: { $err }
error-net-pdata-feed-complete = cannot feed P-DATA fragment into a complete accumulator ( відсутній take())
error-net-peer-aborted = вузол перервав асоціацію під час підоперації C-GET C-STORE: { $source }
error-net-peer-socket = читання storage SCP peer socket address
error-net-reading-command-dataset = читання command dataset
error-net-reading-identifier = читання { $operation } identifier
error-net-reading-incoming-dataset = читання incoming C-STORE dataset
error-net-reading-response-dataset = читання { $operation } response dataset
error-net-remote-aborted = віддалена сторона перервала асоціацію: { $source }
error-net-restoring-read-timeout = відновлення тайм-ауту читання association
error-net-restoring-write-timeout = відновлення тайм-ауту запису association
error-net-rewinding-dataset = перемотування до першого елемента набору даних
error-net-scp-thread-panicked = потік Storage SCP аварійно завершився
error-net-seeking-temp-dataset = позиціювання в тимчасовому файлі набору
error-net-serializing-cget-dataset = серіалізація набору підоперації C-GET для { $path }
error-net-serializing-dataset = серіалізація набору для { $path } з transfer syntax { $syntax }
error-net-setting-socket-blocking = переведення прийнятого сокета зберігання в блокувальний режим
error-net-sending-buffered-dataset = надсилання буферизованого набору для { $path }
error-net-store-status = віддалена сторона повернула статус C-STORE 0x{ $status } ({ $meaning }){ $hint }
error-net-streaming-dataset = потокове передавання набору C-STORE
error-net-unexpected-command-field = неочікуваний CommandField 0x{ $actual } (expected 0x{ $expected } for { $rsp })
error-net-unexpected-dataset-fragment = неочікуваний dataset fragment in C-STORE response
error-net-unexpected-pdu = неочікуваний PDU during { $operation }: { $pdu }
error-net-unknown-status = недійсний { $operation } status 0x{ $status }
error-net-unsupported-model-sop = не підтримується { $operation } model SOP class UID: { $uid }
error-net-unsupported-qr-level = не підтримується QueryRetrieveLevel: { $level }
error-net-unsupported-transfer-syntax = не підтримується negotiated transfer syntax
error-net-writing-command-dataset = запис command dataset
error-net-writing-identifier = запис { $operation } identifier
error-net-writing-path = запис { $path }
error-net-writing-response-dataset = запис { $operation } response dataset
error-net-writing-temp-dataset = запис dataset bytes to temp file
error-node-host-empty = хост вузла не може бути порожнім
error-node-name-empty = ім’я вузла не може бути порожнім
error-node-not-found = віддалений вузол не знайдено: { $id }
error-operation-cancelled = операцію скасовано
error-port-invalid = неприпустимий порт: { $value }
error-port-range = порт має бути від 1 до 65535
error-query-no-study-uid = Збіг не має StudyInstanceUID; отримати неможливо.
error-query-unsupported-level = непідтримуваний рівень запиту: { $value }
error-query-unsupported-model = непідтримувана модель запиту: { $value }
error-retrieve-canceled = retrieve скасовано віддаленим вузлом (status=0x{ $status }, completed={ $completed }, failed={ $failed }, warning={ $warning }, remaining={ $remaining }, { $scp })
error-retrieve-failed = retrieve завершився з помилкою status=0x{ $status } (completed={ $completed }, failed={ $failed }, warning={ $warning }, remaining={ $remaining }, { $scp })
error-retrieve-nothing-arrived = retrieve для призначення { $destination } завершився з completed={ $completed }, але до локального Storage SCP нічого не надійшло ({ $scp }). Перевірте зіставлення AE або порт: { $listener } має бути вільним, а віддалений вузол має зіставляти AE { $destination } з цим застосунком
error-send-no-files-series = немає локальних проіндексованих файлів для серії { $uid }
error-send-no-files-study = немає локальних проіндексованих файлів для дослідження { $uid }
error-task-cancelled = Завдання скасовано
error-task-none-to-cancel = Немає активного завдання для скасування (нічого не виконується)
error-tracing-init = ініціалізація tracing subscriber: { $err }
error-uid-component-numeric = Компонент UID '{ $part }' має бути числовим
error-uid-component-too-long = Компонент UID '{ $part }' занадто довгий
error-uid-dot-ends = UID не може починатися або закінчуватися крапкою
error-uid-empty = UID не може бути порожнім
error-uid-empty-component = UID не може містити порожні компоненти
error-uid-leading-zeros = Компонент UID '{ $part }' не може мати провідних нулів
error-uid-too-long = UID має містити щонайбільше 64 символи

## TUI
tui-bool-no = ні
tui-bool-off = вимк.
tui-bool-on = увімк.
tui-bool-yes = так
tui-command-placeholder = Введіть команду або скористайтеся скороченнями панелей.
tui-config-ae-title = AE title: { $value }
tui-config-edit-hint = Натисніть Tab, щоб сфокусувати цю панель, потім 'c' для редагування.
tui-config-hint = Натисніть Tab, щоб сфокусувати цю панель, потім 'c' для редагування.
tui-config-listener = Слухач: { $value }
tui-config-max-pdu = max_pdu_length: { $value }
tui-config-promiscuous = allow_promiscuous_storage: { $value }
tui-config-strict-pdu = strict_pdu: { $value }
tui-config-ts-pref = Перевага TS: { $value }
tui-controls-hint = Tab поля · Enter підтверджує · Esc скасовує
tui-detail-ae-title = AE title
tui-detail-instance = Деталі екземпляра
tui-detail-name = Ім’я
tui-detail-node = Деталі вузла
tui-detail-placeholder-followup = Перенесіть фокус на панель списку та змініть вибір, щоб оновити цей вигляд.
tui-detail-query = Деталі результату запиту
tui-detail-select-node = Виберіть віддалений вузол, щоб переглянути його метадані.
tui-detail-series = Деталі серії
tui-detail-study = Деталі дослідження
tui-empty-command-placeholder = Введіть команду або скористайтеся скороченнями панелей.
tui-empty-detail-instance = Виберіть примірник для перегляду або поверніться до серій клавішею Esc.
tui-empty-detail-node = Виберіть віддалений вузол, щоб переглянути його метадані.
tui-empty-detail-query = Виберіть результат запиту, щоб переглянути метадані та контекст retrieve.
tui-empty-detail-series = Виберіть серію для перегляду або поверніться до досліджень клавішею Esc.
tui-empty-detail-study = Виберіть локальне дослідження, щоб переглянути метадані пацієнта та серій.
tui-empty-instances = Для цієї серії немає індексованих екземплярів.
tui-empty-instances-hint = Натисніть Esc, щоб повернутися до серій.
tui-empty-local-instances = Для цієї серії немає індексованих екземплярів.
tui-empty-local-instances-hint = Натисніть Esc, щоб повернутися до серій.
tui-empty-local-series = Для цього дослідження немає індексованих серій.
tui-empty-local-series-hint = Натисніть Esc, щоб повернутися до локальних досліджень.
tui-empty-local-studies = Ще немає індексованих досліджень.
tui-empty-local-studies-cmd = Приклад: import path=/data/inbox
tui-empty-local-studies-hint = Спочатку імпортуйте локальні файли DICOM.
tui-empty-no-name = <без назви>
tui-empty-query = Запит ще не виконувався.
tui-empty-query-body =
    Виберіть віддалений вузол і натисніть 'f' для запиту.
    Або: query node=pacs
        patient_name="DOE^JOHN"
    Натисніть 'm' на вибраному результаті, щоб відкрити retrieve.
tui-empty-query-cmd = Або: query node=pacs
tui-empty-query-hint = Виберіть віддалений вузол і натисніть 'f' для запиту.
tui-empty-query-last-target = Остання ціль запиту: { $name }
tui-empty-query-none = Запит ще не виконувався.
tui-empty-query-retrieve-hint = Натисніть 'm' на вибраному результаті, щоб відкрити retrieve.
tui-empty-remote-nodes = Ще не збережено жодного віддаленого вузла.
tui-empty-remote-nodes-cmd = Або: node add name=pacs
tui-empty-remote-nodes-hint = Натисніть 'a' на цій панелі, щоб додати.
tui-empty-series = Для цього дослідження немає індексованих серій.
tui-empty-series-hint = Натисніть Esc, щоб повернутися до локальних досліджень.
tui-empty-studies = Ще немає індексованих досліджень.
tui-empty-studies-hint = Спочатку імпортуйте локальні файли DICOM.
tui-empty-tasks-history = Немає історії завдань.
tui-empty-tasks-queued = Немає завдань у черзі.
tui-fallback-no-name = <без назви>
tui-field-accession = Номер accession
tui-field-ae-title = AE title
tui-field-bind-addr = Адреса bind
tui-field-date-from = Дата від
tui-field-date-to = Дата до
tui-field-destination-node = Вузол призначення
tui-field-host = Хост
tui-field-instance-uid = Instance UID
tui-field-kind = Тип
tui-field-level = Рівень
tui-field-local-ae = Локальний AE
tui-field-max-pdu = Макс. PDU
tui-field-modality = Модальність
tui-field-model = Модель
tui-field-move-destination = Призначення Move
tui-field-name = Ім’я
tui-field-notes = Примітки
tui-field-path = Шлях
tui-field-patient-id = ID пацієнта
tui-field-patient-name = Ім’я пацієнта
tui-field-port = Порт
tui-field-promiscuous = Проміскуїтетний
tui-field-series-uid = Series UID
tui-field-sop-uid = SOP Instance UID
tui-field-strict-pdu = Суворий PDU
tui-field-study-description = Опис дослідження
tui-field-study-uid = Study UID
tui-footer-back-series = Esc назад до серій
tui-footer-back-studies = Esc назад до досліджень
tui-footer-cancel-task = c скасувати
tui-footer-edit-config = c редагувати config
tui-footer-enter-series = Enter серії
tui-footer-esc-series = Esc назад до серій
tui-footer-esc-studies = Esc назад до досліджень
tui-footer-help = F1/? довідка
tui-footer-inspect = Enter переглянути
tui-footer-next = Далі: { $text }
tui-footer-nodes = a/e/d/f вузли
tui-footer-panes = Tab панелі
tui-footer-queued =
    { $n ->
        [one] { $n } у черзі
        [few] { $n } у черзі
        [many] { $n } у черзі
       *[other] { $n } у черзі
    }
tui-footer-quit = q вийти
tui-footer-refresh = r оновити
tui-footer-retrieve = m отримати
tui-footer-run-command = Enter виконати команду
tui-footer-task-scope = t черга/історія
tui-form-add-node = Додати віддалений вузол
tui-form-add-remote-node = Додати віддалений вузол
tui-form-delete-confirm = Видалити віддалений вузол { $name } [{ $ae }] на { $host }:{ $port }?
tui-form-delete-node = Видалити віддалений вузол
tui-form-delete-remote-node = Видалити віддалений вузол
tui-form-edit-node = Редагувати віддалений вузол
tui-form-edit-remote-node = Редагувати віддалений вузол
tui-form-err-ae-required = ! AE title обов’язковий
tui-form-err-bind-required = ! адреса bind обов’язкова
tui-form-err-host-required = ! хост обов’язковий
tui-form-err-local-ae-invalid = ! неприпустимий локальний AE title: { $err }
tui-form-err-local-ae-required = ! локальний AE title обов’язковий
tui-form-err-modality-empty = модальність не може бути порожньою
tui-form-err-move-dest-invalid = ! неприпустимий AE title призначення Move: { $err }
tui-form-err-name-required = ! назва вузла обов’язкова
tui-form-err-port-required = ! порт обов’язковий
tui-form-err-uid-empty = UID не може бути порожнім
tui-form-err-uid-empty-component = UID не може містити порожні компоненти
tui-form-error-line = Помилка: { $error }
tui-form-field-accession = Номер accession
tui-form-field-ae-title = AE title
tui-form-field-bind-addr = Адреса bind
tui-form-field-date-from = Дата від
tui-form-field-date-to = Дата до
tui-form-field-dest-node = Вузол призначення
tui-form-field-destination = AE призначення
tui-form-field-host = Хост
tui-form-field-instance-uid = SOP Instance UID
tui-form-field-kind = Тип
tui-form-field-level = Рівень
tui-form-field-local-ae = Локальний AE
tui-form-field-modality = Модальність
tui-form-field-model = Модель
tui-form-field-move-dest = Призначення Move
tui-form-field-name = Ім’я
tui-form-field-notes = Примітки
tui-form-field-path = Шлях
tui-form-field-patient-id = ID пацієнта
tui-form-field-patient-name = Ім’я пацієнта
tui-form-field-port = Порт
tui-form-field-series-uid = Series Instance UID
tui-form-field-sop-uid = SOP Instance UID
tui-form-field-study-desc = Опис дослідження
tui-form-field-study-uid = Study Instance UID
tui-form-field-uid = UID
tui-form-hint-bind = підказка: зазвичай 0.0.0.0 (усі інтерфейси) або 127.0.0.1
tui-form-hint-local-ae = підказка: щонайбільше 16 символів (A-Z, 0-9, пробіл), напр. ARCHIVE_AE
tui-form-hint-move-dest = підказка: необов’язково; перевизначає AE title призначення C-MOVE
tui-form-hint-name = підказка: коротка мітка (напр. PACS)
tui-form-import = Імпортувати локальні файли
tui-form-import-local = Імпортувати локальні файли
tui-form-import-local-files = Імпортувати локальні файли
tui-form-mode-add = створити новий віддалений вузол
tui-form-mode-edit = оновити вибраний віддалений вузол
tui-form-query-node = Запитати віддалений вузол
tui-form-query-remote-node = Запитати віддалений вузол
tui-form-remote-node-line = Віддалений вузол: { $name } [{ $ae }] { $host }:{ $port }
tui-form-retrieve = Отримати збіги
tui-form-retrieve-matches = Отримати збіги
tui-form-send-series = Надіслати серію
tui-form-send-study = Надіслати дослідження
tui-form-storage-intro = Редагуйте локальні параметри Storage SCP (зберігається в config.json).
tui-form-storage-scp = Параметри Storage SCP
tui-form-storage-scp-settings = Параметри Storage SCP
tui-help-ae-title = AE title: { $value }
tui-help-aedf = a/e/d/f     Додати, редагувати, видалити або запит з вибраного вузла
tui-help-c = c           Редагувати Storage SCP (коли фокус на панелі Config)
tui-help-canonical-names = Канонічні імена збігаються з прапорцями CLI без '--', з підкресленнями.
tui-help-close = Закрийте довідку клавішами Esc, F1 або ?.
tui-help-common-commands = Типові команди
tui-help-config = c           Редагувати Storage SCP (коли фокус на панелі Config)
tui-help-config-path = Шлях config: { $value }
tui-help-current-config = Поточна конфігурація
tui-help-data-dir = Каталог даних: { $value }
tui-help-enter-default = Enter       Виконати команду, надіслати активне модальне вікно або відкрити серії з Локальних досліджень
tui-help-enter-instance = Enter       Немає дії панелі Local у режимі екземплярів
tui-help-enter-local-instance = Enter       Немає дії панелі Local у режимі екземплярів
tui-help-enter-local-series = Enter       Відкрити екземпляри вибраної локальної серії або виконати команду / надіслати активне модальне вікно
tui-help-enter-local-study = Enter       Відкрити серії вибраного локального дослідження або виконати команду / надіслати активне модальне вікно
tui-help-enter-series = Enter       Відкрити екземпляри вибраної локальної серії або виконати команду / надіслати активне модальне вікно
tui-help-enter-study = Enter       Відкрити серії вибраного локального дослідження або виконати команду / надіслати активне модальне вікно
tui-help-esc-default = Esc         Закрити довідку/модальне вікно, повернутися з локальних серій або повернути фокус у поле команди
tui-help-esc-instance = Esc         Повернутися з локальних екземплярів до серій, закрити довідку/модальне вікно або повернути фокус у поле команди
tui-help-esc-instances = Esc         Повернутися з локальних екземплярів до серій, закрити довідку/модальне вікно або повернути фокус у поле команди
tui-help-esc-series = Esc         Повернутися з локальних серій до досліджень, закрити довідку/модальне вікно або повернути фокус у поле команди
tui-help-f1 = F1 або ?     Відкрити довідку
tui-help-import-send = i/s         Імпортувати локальні файли або надіслати вибране дослідження/серію
tui-help-is = i/s         Імпортувати локальні файли або надіслати вибране дослідження/серію
tui-help-listener = Слухач: { $value }
tui-help-log-dir = Каталог журналів: { $value }
tui-help-m = m           Отримати з вибраного результату запиту
tui-help-max-pdu = max_pdu_length: { $value }
tui-help-move = Up/Down або j/k   Перемістити вибір у панелях списків
tui-help-nodes = a/e/d/f     Додати, редагувати, видалити або запит з вибраного вузла
tui-help-open = F1 або ?     Відкрити довідку
tui-help-promiscuous = allow_promiscuous_storage: { $value }
tui-help-q = q           Вийти, коли немає активного модального вікна і фокус не в полі команди
tui-help-quit = q           Вийти, коли немає активного модального вікна і фокус не в полі команди
tui-help-r = r           Оновити панелі, коли фокус не в полі команди
tui-help-receiver-mode = Режим приймача: { $value }
tui-receiver-mode-on-demand = на вимогу для локального retrieve
tui-receiver-mode-standalone = автономно через storage-scp
tui-help-refresh = r           Оновити панелі, коли фокус не в полі команди
tui-help-retrieve = m           Отримати з вибраного результату запиту
tui-help-strict-pdu = strict_pdu: { $value }
tui-help-tab = Tab / Shift-Tab  Змінити активну панель
tui-help-title = Клавіші
tui-help-ts-pref = preferred_store_transfer_syntax: { $value }
tui-help-updown = Up/Down або j/k   Перемістити вибір у панелях списків
tui-input-placeholder = Введіть команду або скористайтеся скороченнями панелей.
tui-log-command = > { $command }
tui-log-error = помилка: { $error }
tui-log-refreshed = оновлено
tui-logs-capped-suffix = обмежено
tui-logs-label = Журнали:
tui-pane-command = Команда
tui-pane-config = Конфігурація
tui-pane-detail = Деталі
tui-pane-detail-hint = { $title } (PgUp/PgDn коли не вводите текст)
tui-pane-help = Довідка
tui-pane-instance-detail = Деталі екземпляра
tui-pane-instances-for = Екземпляри для: { $uid }
tui-pane-local-studies = Локальні дослідження
tui-pane-logs = Журнали ({ $shown }/{ $total }{ $capped })
tui-pane-logs-capped = Журнали ({ $shown }/{ $total } capped)
tui-pane-logs-uncapped = Журнали ({ $shown }/{ $total })
tui-pane-node-detail = Деталі вузла
tui-pane-query-detail = Деталі результату запиту
tui-pane-query-node = Запит вузла
tui-pane-query-result-detail = Деталі результату запиту
tui-pane-query-results = Результати запиту / отримання
tui-pane-query-retrieve-results = Результати запиту / отримання
tui-pane-remote-nodes = Віддалені вузли
tui-pane-series-detail = Деталі серії
tui-pane-series-for = Серії для: { $uid }
tui-pane-series-unknown = Серії для: <невідоме дослідження>
tui-pane-study-detail = Деталі дослідження
tui-pane-task-details = Деталі завдання
tui-pane-tasks-history = Завдання (історія)
tui-pane-tasks-queued = Завдання (черга)
tui-pane-unknown-series = <невідома серія>
tui-pane-unknown-study = Серії для: <невідоме дослідження>
tui-row-inst = inst
tui-status-cancel-requested = Скасуватиlation requested
tui-status-config = Конфігурація
tui-status-configured-listener = Налаштовано слухач { $addr } як AE { $ae } ({ $mode })
tui-status-data = Дані
tui-status-failure = збій: { $failure }
tui-status-listener = Слухач
tui-status-local-ae = Локальний AE
tui-status-mode = Режим
tui-status-mode-on-demand = на вимогу
tui-status-mode-standalone = автономний
tui-status-no-active-task = Немає активного завдання для скасування (нічого не виконується)
tui-status-pdu = PDU
tui-status-promiscuous = Проміскуїтетний
tui-status-query-before-retrieve = Спочатку виконайте запит до віддаленого вузла, щоб отримання знало, який вузол використати
tui-status-query-failed = запит не вдався: { $error }
tui-status-queued-op = Операція в черзі: { $op }
tui-status-retrieve-failed = отримання не вдалося: { $error }
tui-status-retrieve-open-failed = не вдалося відкрити потік отримання: { $error }
tui-status-saved-node = збережено вузол { $name } ({ $id })
tui-status-saved-scp = Параметри Storage SCP збережено (потрібен перезапуск)
tui-status-select-node = спочатку виберіть віддалений вузол
tui-status-select-query = спочатку виберіть результат запиту
tui-status-select-study = спочатку виберіть локальне дослідження
tui-status-strict = Суворий
tui-status-task-cancelled = Завдання скасовано
tui-status-task-cancelled-detail = Завдання скасовано: { $other }
tui-status-ts-pref = Pref. TS
tui-status-updated-node = оновлено вузол { $name } ({ $id })
tui-suggest-back-series = Esc — назад до серій
tui-suggest-edit-config = c — редагувати config
tui-suggest-help = F1/? — довідка
tui-suggest-inspect-task = Enter — переглянути завдання
tui-suggest-node-add = node add <ae-title> <host:port>
tui-suggest-query = f — запит до вузла
tui-suggest-query-node = f — запит до вибраного вузла
tui-suggest-retrieve = m — отримати вибране
tui-suggest-run-command = Enter — виконати команду
tui-suggest-send-series = s — надіслати вибрану серію
tui-suggest-view-series = Enter — переглянути серії
tui-task-cancelled = Скасовано
tui-task-cancelling = Скасування
tui-task-failed = Помилка
tui-task-failed-generic = Завдання не вдалося: { $error }
tui-task-import-done = Імпортувати complete: { $report }
tui-task-import-failed = Імпорт не вдався: { $error }
tui-task-importing = Імпорт { $path }...
tui-task-query-done =
    Запит завершено: { $count ->
        [one] { $count } збіг
        [few] { $count } збіги
        [many] { $count } збігів
       *[other] { $count } збігів
    }
tui-task-query-failed = Запит не вдався: { $error }
tui-task-querying = Запит до { $node }...
tui-task-queued = У черзі
tui-task-retrieve-done = Отримання завершено: { $outcome }
tui-task-retrieve-failed = Отримання не вдалося: { $error }
tui-task-retrieving = Отримання з { $node }...
tui-task-running = Виконується
tui-task-sending-series = Надсилання серії { $uid } на { $node }...
tui-task-sending-study = Надсилання дослідження { $uid } на { $node }...
tui-task-send-done = Надсилання завершено: { $outcome }
tui-task-status-cancelled = скасовано
tui-task-status-cancelling = скасовується
tui-task-status-failed = помилка
tui-task-status-ok = ok
tui-task-status-queued = у черзі
tui-task-status-running = виконується
tui-task-succeeded = Успіх
tui-terminal-too-small = Термінал замалий — змініть розмір

## Desktop
desktop-action-activity = Активність { $count }
desktop-action-activity-empty = Активність
desktop-action-import = Імпорт
desktop-action-inspect-archive = Переглянути локальний архів
desktop-action-inspect-archive-desc = Перегляньте дослідження, серії та примірники, потім надішліть або експортуйте.
desktop-action-manage-peers = Керувати пірами
desktop-action-manage-peers-desc = Додавайте й редагуйте вузли PACS або станцій для query, retrieve і store.
desktop-action-monitor-scp = Моніторинг Storage SCP
desktop-action-query = Запит
desktop-action-refresh = Оновити стан
desktop-action-refresh-status = Оновити стан
desktop-action-reveal-log = Показати файл журналу
desktop-action-send = Надіслати
desktop-action-start-scp = Запустити Storage SCP
desktop-activity-empty = Ще немає активності сеансу.
desktop-activity-title = Активність
desktop-app-title = DICOM Node
desktop-archive-csv = CSV
desktop-archive-details = Подробиці
desktop-archive-empty = Локальний архів порожній.
desktop-archive-export-fail = Експорт { $scope } не вдався
desktop-archive-export-ok =
    { $rows ->
        [one] Експортовано { $rows } рядок { $scope } до { $path }.
       *[other] Експортовано { $rows } рядків { $scope } до { $path }.
    }
desktop-archive-export-studies = Експортувати дослідження
desktop-archive-export-title = Експорт { $scope }
desktop-archive-filter = Фільтр за пацієнтом, UID, описом, модальністю…
desktop-archive-filter-placeholder = Фільтр за пацієнтом, UID, описом, модальністю…
desktop-archive-inst-abbrev =
    { $count ->
        [one] { $count } екз.
        [few] { $count } екз.
        [many] { $count } екз.
       *[other] { $count } екз.
    }
desktop-archive-instance-meta = { $bytes } · TS { $ts } · імпортовано { $imported }
desktop-archive-instances = Екземпляри
desktop-archive-instances-heading = Екземпляри
desktop-archive-json = JSON
desktop-archive-loading = Завантаження досліджень…
desktop-archive-no-filter-match = Жодне дослідження не відповідає фільтру.
desktop-archive-no-instances = Екземплярів не знайдено.
desktop-archive-no-match = Жодне дослідження не відповідає фільтру.
desktop-archive-no-nodes = Немає вузлів
desktop-archive-no-series = Серій не знайдено.
desktop-archive-reveal-file = Показати файл
desktop-archive-select-series = Виберіть серію.
desktop-archive-select-study = Виберіть дослідження.
desktop-archive-send-fail = { $label }: { $sent }/{ $attempted } надіслано, { $failed } збоїв. { $failures }
desktop-archive-send-fail-title = { $label } не вдалося
desktop-archive-send-ok = { $label }: надіслано { $sent }/{ $attempted } екземплярів.
desktop-archive-send-series = Надіслати серію
desktop-archive-send-series-label = Серія → { $destination }
desktop-archive-send-study = Надіслати дослідження
desktop-archive-send-study-label = Дослідження → { $destination }
desktop-archive-send-to = Надіслати до
desktop-archive-series = Серії
desktop-archive-series-count =
    #{ $number } · { $count ->
        [one] { $count } екземпляр
       *[other] { $count } екземплярів
    }
desktop-archive-series-fallback = Серії
desktop-archive-studies = Дослідження
desktop-archive-study-date = Дата дослідження
desktop-archive-study-uid = Study UID
desktop-archive-subtitle = Інвентар досліджень, серій і екземплярів з локального архіву SQLite.
desktop-archive-title = Локальний архів
desktop-brand-title = DICOM Node
desktop-col-description = Опис
desktop-col-instances = Екземпляри
desktop-col-modalities = Модальності
desktop-col-patient-id = ID пацієнта
desktop-common-cancel = Скасувати
desktop-common-clear = Очистити
desktop-common-disabled = вимкнено
desktop-common-enabled = увімкнено
desktop-common-loading = Завантаження…
desktop-common-no = ні
desktop-common-refresh = Оновити
desktop-common-yes = так
desktop-counter-assoc-accepted = Прийняті асоціації
desktop-counter-bytes-ingested = Прийняті байти
desktop-counter-cfind-requests = Запити C-FIND
desktop-counter-cmove-requests = Запити C-MOVE
desktop-counter-cstore-failed = C-STORE збій
desktop-counter-cstore-stored = C-STORE збережено
desktop-dashboard-counter-assoc-accepted = Прийняті асоціації
desktop-dashboard-counter-bytes-ingested = Прийняті байти
desktop-dashboard-counter-c-find-requests = Запити C-FIND
desktop-dashboard-counter-c-move-requests = Запити C-MOVE
desktop-dashboard-counter-c-store-failed = C-STORE збій
desktop-dashboard-counter-c-store-stored = C-STORE збережено
desktop-dashboard-empty-studies = Ще немає локальних досліджень.
desktop-dashboard-inspect-archive-body = Перегляньте дослідження, серії й екземпляри, потім надішліть або експортуйте.
desktop-dashboard-inspect-archive-title = Переглянути локальний архів
desktop-dashboard-kv-ae-title = Заголовок AE
desktop-dashboard-kv-data-dir = Каталог даних
desktop-dashboard-kv-listener = Слухач
desktop-dashboard-kv-log-file = Файл журналу
desktop-dashboard-kv-max-pdu = Макс. PDU
desktop-dashboard-kv-promiscuous = Необмежене зберігання
desktop-dashboard-kv-server = Сервер
desktop-dashboard-kv-store-syntax = Синтаксис store
desktop-dashboard-kv-strict-pdu = Строгий PDU
desktop-dashboard-listener-missing = Listener ще не завантажено.
desktop-dashboard-live-counters = Живі лічильники
desktop-dashboard-loading-metrics = Завантаження метрик…
desktop-dashboard-loading-status = Завантаження локального стану…
desktop-dashboard-loading-studies = Завантаження досліджень…
desktop-dashboard-local-node = Локальний вузол
desktop-dashboard-manage-peers-body = Додавайте й редагуйте вузли PACS або станцій для запиту, отримання й store.
desktop-dashboard-manage-peers-title = Керувати пірами
desktop-dashboard-metric-instances = Екземпляри
desktop-dashboard-metric-nodes = Віддалені вузли
desktop-dashboard-metric-series = Серії
desktop-dashboard-metric-studies = Дослідження
desktop-dashboard-monitor-scp = Моніторити Storage SCP
desktop-dashboard-recent-studies = Останні дослідження
desktop-dashboard-start-scp = Запустити Storage SCP
desktop-dashboard-subtitle = Локальний архів, мережеві піри та активність SCP одним поглядом.
desktop-dashboard-title = Панель оператора
desktop-doc-title = DICOM Node
desktop-import-accepted = Прийнято
desktop-import-accepted-bytes = Прийняті байти
desktop-import-activity-detail = { $accepted }/{ $scanned } прийнято, { $duplicates } дублікатів, { $bytes }
desktop-import-activity-fail = Імпорт не вдався
desktop-import-activity-ok = Імпорт завершено
desktop-import-choose-archive = Виберіть ZIP-архів для імпорту
desktop-import-choose-dir = Виберіть каталог для імпорту
desktop-import-choose-folder = Тека
desktop-import-choose-zip = Виберіть ZIP-архів для імпорту
desktop-import-cleanup = Очищення
desktop-import-clear-path = Очистити шлях
desktop-import-complete = Імпорт завершено
desktop-import-dup-sha = SHA-256
desktop-import-dup-sop = SOP UID
desktop-import-dup-total = Разом
desktop-import-duplicates = Дублікати
desktop-import-failed = Імпорт не вдався
desktop-import-failed-cleanup = Очищення не вдалося
desktop-import-failures = Збої
desktop-import-failures-heading =
    { $count ->
        [one] { $count } збій:
       *[other] { $count } збоїв:
    }
desktop-import-failures-more = … і ще { $count }
desktop-import-files-progress = { $label } файлів
desktop-import-folder = Тека
desktop-import-invalid-dicom = Некоректний DICOM
desktop-import-pick-dir = Виберіть каталог для імпорту
desktop-import-pick-zip = Виберіть ZIP-архів для імпорту
desktop-import-placeholder = /path/to/dicom-folder or /path/to/archive.zip
desktop-import-rejected = Відхилено
desktop-import-report = Звіт імпорту
desktop-import-running = Імпорт…
desktop-import-scanned = Проскановано
desktop-import-skipped = Пропущено
desktop-import-source = Джерело
desktop-import-start = Почати імпорт
desktop-import-stored = Збережено
desktop-import-subtitle = Індексуйте файли DICOM з рекурсивних тек або ZIP у керований локальний архів.
desktop-import-title = Імпорт
desktop-import-unreadable = Нечитабельно
desktop-import-zip = ZIP
desktop-import-zip-filter = ZIP-архіви
desktop-lang-label = Мова
desktop-listener-not-loaded = Listener ще не завантажено.
desktop-live-counters = Живі лічильники
desktop-loading = Завантаження
desktop-loading-local-status = Завантаження локального стану…
desktop-loading-metrics = Завантаження метрик…
desktop-loading-studies = Завантаження досліджень…
desktop-local-node = Локальний вузол
desktop-locale-label = Мова
desktop-logs-activity-detail =
    { $count ->
        [one] { $count } рядок завантажено
       *[other] { $count } рядків завантажено
    }
desktop-logs-activity-fail = Не вдалося оновити журнал
desktop-logs-activity-ok = Журнал оновлено
desktop-logs-auto = АВТО
desktop-logs-auto-refresh = Автооновлення
desktop-logs-empty = Файл журналу порожній.
desktop-logs-found = ФАЙЛ ЖУРНАЛУ ЗНАЙДЕНО
desktop-logs-lines =
    { $count ->
        [one] { $count } рядок
        [few] { $count } рядки
        [many] { $count } рядків
       *[other] { $count } рядків
    }
desktop-logs-loading = Завантаження журналу…
desktop-logs-missing = Активний файл журналу ще не створено.
desktop-logs-refresh-failed = Не вдалося оновити журнал
desktop-logs-refreshed = Журнал оновлено
desktop-logs-reveal = Показати
desktop-logs-subtitle = Обмежений хвіст активного файлу журналу стільниці.
desktop-logs-tail = Хвіст
desktop-logs-title = Журнали
desktop-logs-truncated = ОБРІЗАНО
desktop-logs-waiting = ОЧІКУВАННЯ ФАЙЛУ ЖУРНАЛУ
desktop-metric-instances = Екземпляри
desktop-metric-remote-nodes = Віддалені вузли
desktop-metric-series = Серії
desktop-metric-studies = Дослідження
desktop-nav-archive = Локальний архів
desktop-nav-dashboard = Панель
desktop-nav-import = Імпорт
desktop-nav-logs = Журнали
desktop-nav-network = Мережа
desktop-nav-nodes = Віддалені вузли
desktop-nav-query = Запит / отримання
desktop-nav-server = Сервер зберігання
desktop-no-local-studies = Ще немає локальних досліджень.
desktop-nodes-add = Додати вузол
desktop-nodes-added = Додано вузол «{ $name }».
desktop-nodes-ae-length = Заголовок AE має бути не більше 16 символів.
desktop-nodes-ae-title = Заголовок AE
desktop-nodes-col-move = Призн. Move
desktop-nodes-configured = Налаштовані вузли
desktop-nodes-confirm-delete = Видалити вузол «{ $name }»?
desktop-nodes-default-port = Типовий порт 104
desktop-nodes-delete = Видалити вузол
desktop-nodes-delete-title = Видалити вузол
desktop-nodes-deleted = Видалено вузол «{ $name }».
desktop-nodes-edit = Редагувати вузол
desktop-nodes-edit-title = Редагувати вузол
desktop-nodes-empty = Ще немає віддалених вузлів.
desktop-nodes-err-ae = Потрібен AE title.
desktop-nodes-err-ae-len = AE title — не більше 16 символів.
desktop-nodes-err-host = Потрібен хост.
desktop-nodes-err-name = Потрібна назва.
desktop-nodes-err-port = Порт має бути 1–65535.
desktop-nodes-host = Хост
desktop-nodes-move-dest = Призначення Move
desktop-nodes-move-placeholder = Типово: локальний AE
desktop-nodes-name = Ім’я
desktop-nodes-need-ae = Заголовок AE обов’язковий.
desktop-nodes-need-host = Хост обов’язковий.
desktop-nodes-need-name = Назва обов’язкова.
desktop-nodes-notes = Нотатки
desktop-nodes-notes-placeholder = PACS кабінету опису
desktop-nodes-placeholder-ae = PACS01
desktop-nodes-placeholder-host = 192.168.0.10
desktop-nodes-placeholder-move = Типово: локальний AE
desktop-nodes-placeholder-name = main-pacs
desktop-nodes-placeholder-notes = PACS кабінету опису
desktop-nodes-port = Порт
desktop-nodes-port-104 = Типовий порт 104
desktop-nodes-port-range = Порт має бути від 1 до 65535.
desktop-nodes-save = Зберегти зміни
desktop-nodes-save-changes = Зберегти зміни
desktop-nodes-subtitle = Піри PACS і станцій для запиту, отримання й store.
desktop-nodes-summary = Підсумок вузлів
desktop-nodes-title = Віддалені вузли
desktop-nodes-total = Усього вузлів
desktop-nodes-updated = Оновлено вузол «{ $name }».
desktop-nodes-with-move = З призначенням Move
desktop-promiscuous = Необмежене зберігання
desktop-query-accession = Accession №
desktop-query-activity-detail = { $count } { $count ->
        [one] збіг
       *[other] збігів
    } на рівні { $level }
desktop-query-activity-fail = C-FIND { $node } не вдалося
desktop-query-activity-ok = C-FIND { $node }
desktop-query-activity-title = C-FIND { $node }
desktop-query-clear = Очистити
desktop-query-col-accession = номер направлення
desktop-query-criteria = Критерії пошуку
desktop-query-date-from = Дата дослідження з
desktop-query-date-to = Дата дослідження до
desktop-query-kv-series-uid = Series UID
desktop-query-kv-sop-uid = SOP UID
desktop-query-kv-study-uid = Study UID
desktop-query-level = Рівень
desktop-query-matches =
    { $count ->
        [one] { $count } збіг
       *[other] { $count } збігів
    }
desktop-query-missing-study-uid = У збігу немає StudyInstanceUID; отримати неможливо.
desktop-query-modality = Модальність
desktop-query-no-matches = Немає збігів.
desktop-query-no-nodes = Вузли не налаштовано
desktop-query-patient-id = ID пацієнта
desktop-query-patient-name = Ім’я пацієнта
desktop-query-placeholder-description = CHEST*
desktop-query-placeholder-modality = CT, MR, …
desktop-query-placeholder-name = DOE^JOHN or DOE*
desktop-query-placeholder-patient = DOE^JOHN or DOE*
desktop-query-querying = Запит…
desktop-query-remote-node = Віддалений вузол
desktop-query-results = Результати
desktop-query-retrieve = Отримати
desktop-query-retrieve-activity-detail = completed={ $completed }, warning={ $warning }, failed={ $failed }
desktop-query-retrieve-activity-fail = C-MOVE { $node } не вдалося
desktop-query-retrieve-activity-ok = C-MOVE { $node }
desktop-query-retrieve-finished = Отримання завершено: виконано { $completed }, попереджень { $warning }, збоїв { $failed }.
desktop-query-retrieve-selected = Отримати вибране
desktop-query-run = Виконати C-FIND
desktop-query-run-select = Виконайте запит і виберіть збіг.
desktop-query-running = Запит…
desktop-query-search-criteria = Критерії пошуку
desktop-query-select-hint = Виконайте запит і виберіть збіг.
desktop-query-selected = Вибраний збіг
desktop-query-selected-match = Вибраний збіг
desktop-query-series-uid = Series Instance UID
desktop-query-sop-uid = SOP Instance UID
desktop-query-study-description = Опис дослідження
desktop-query-study-uid = Study Instance UID
desktop-query-subtitle = C-FIND до віддаленого вузла, перегляд збігів, потім C-MOVE до локального архіву.
desktop-query-title = Запит / отримання
desktop-recent-studies = Останні дослідження
desktop-scp-listening = SCP слухає
desktop-scp-stopped = SCP зупинено
desktop-server-activity-fail = Помилка керування Storage SCP
desktop-server-activity-started = Storage SCP запущено
desktop-server-activity-started-detail = Listener запущено.
desktop-server-activity-stopped = Storage SCP зупинено
desktop-server-activity-stopped-detail = received={ $received }, stored={ $stored }, failed={ $failed }
desktop-server-activity-stopped-empty = Немає активного сеансу.
desktop-server-addr-ae = { $addr } · AE { $ae }
desktop-server-assoc-accepted = Прийняті асоціації
desktop-server-assoc-rejected = Відхилені асоціації
desktop-server-cfind-req-matches = Запити / збіги C-FIND
desktop-server-cget-requests = Запити C-GET
desktop-server-cmove-requests = Запити C-MOVE
desktop-server-cmove-subops = Під операції C-MOVE завершено / збій
desktop-server-control-failed = Помилка керування Storage SCP
desktop-server-counter-bytes = Прийняті байти
desktop-server-counter-failed = C-STORE збій
desktop-server-counter-find = Запити / збіги C-FIND
desktop-server-counter-get = Запити C-GET
desktop-server-counter-move = Запити C-MOVE
desktop-server-counter-move-sub = Під операції C-MOVE завершено / збій
desktop-server-counter-received = C-STORE отримано
desktop-server-counter-stored = C-STORE збережено
desktop-server-cstore-failed = C-STORE збій
desktop-server-cstore-received = C-STORE отримано
desktop-server-cstore-stored = C-STORE збережено
desktop-server-dimse = Лічильники DIMSE
desktop-server-failed = Збої
desktop-server-health-loading = Завантаження метрик
desktop-server-health-ready = Готовий до вхідного C-STORE
desktop-server-health-review = Переглянути збої
desktop-server-health-stopped = Зупинено
desktop-server-listener-started = Listener запущено.
desktop-server-listening = СЛУХАЄ
desktop-server-loading-metrics = Завантаження метрик…
desktop-server-logs = Журнали
desktop-server-no-session = Немає активного сеансу.
desktop-server-rate = +{ $rate } / опитування
desktop-server-ready = Готовий до вхідного C-STORE
desktop-server-review-failures = Переглянути збої
desktop-server-session-ended = Сеанс завершено: отримано { $received }, збережено { $stored }, збоїв { $failed }.
desktop-server-start = Запустити сервер
desktop-server-started-title = Storage SCP запущено
desktop-server-stop = Зупинити сервер
desktop-server-stopped = ЗУПИНЕНО
desktop-server-stopped-pill = ЗУПИНЕНО
desktop-server-stopped-status = Зупинено
desktop-server-stopped-title = Storage SCP зупинено
desktop-server-stored = Збережено
desktop-server-subtitle = Автономний Storage SCP для вхідного C-STORE та індексації локального архіву.
desktop-server-title = Сервер зберігання
desktop-status-listening = слухає
desktop-status-loading = Завантаження
desktop-status-scp-listening = SCP слухає
desktop-status-scp-stopped = SCP зупинено
desktop-status-stopped = зупинено
desktop-store-syntax = Синтаксис store
desktop-strict-pdu = Строгий PDU
desktop-strip-pdu = PDU { $value }
desktop-table-accession = Номер звернення
desktop-table-ae-title = AE title
desktop-table-date = Дата
desktop-table-description = Опис
desktop-table-endpoint = Кінцева точка
desktop-table-instances = Екземпляри
desktop-table-modalities = Модальності
desktop-table-modality = Модальність
desktop-table-move-dest = Призн. Move
desktop-table-name = Ім’я
desktop-table-notes = Нотатки
desktop-table-patient = Пацієнт
desktop-table-patient-id = ID пацієнта
desktop-table-series = Серії
desktop-table-updated = Оновлено
desktop-title-refresh-status = Оновити стан
desktop-title-reveal-log = Показати файл журналу
ae = AE
patient-name =
    "DOE^JOHN"
    Натисніть 'm' на вибраному результаті, щоб відкрити retrieve.
port = Порт

## Summary
summary-ae = AE
summary-counts = Лічильники
summary-criteria = Критерії
summary-duration = Тривалість
summary-duration-ms = { $ms }ms
summary-failures = Збої:
summary-kind = Тип
summary-logs = Журнали:
summary-peer = Пір
summary-status = Статус
summary-title = Підсумок операції
tui-detail-created = Створено

tui-form-hint-port-range = підказка: число від 1 до 65535, напр. 104
tui-form-hint-promiscuous = підказка: дозволити зберігання від будь-якого викликаючого AE title
tui-form-hint-strict-pdu = підказка: перевіряти розмір PDU під час асоціацій
tui-form-hint-max-pdu-bytes = підказка: байти, напр. 16384
tui-form-limits-heading = Limits (bytes; blank/немає = unlimited):
tui-form-field-max-file-import = Макс. байтів імпорту файлу
tui-form-field-max-zip-entry = Макс. байтів запису ZIP
tui-form-field-max-zip-total = Макс. загальних байтів ZIP
tui-form-field-max-zip-count = Макс. кількість записів ZIP
tui-form-field-max-store-object = Макс. байтів об’єкта store
tui-form-unlimited = без обмежень
tui-form-err-max-pdu-required = ! макс. довжина PDU обов’язкова
tui-form-err-max-pdu-gt-zero = ! макс. довжина PDU має бути цілим числом більшим за 0
tui-form-err-limit-gt-zero = ! { $label } має бути цілим числом більшим за 0
tui-form-controls-scp = Ввод для редагування. Пробіл перемикає прапорці. Tab/Shift-Tab або Вгору/Вниз змінюють поля. Enter зберігає. Esc скасовує.
tui-form-submit-uid-required = UID обов’язковий
tui-form-submit-dest-required = destination вузол is required
tui-form-submit-nonneg-int = { $label } має бути невід’ємним цілим
tui-form-submit-gt-zero = { $label } має бути більшим за 0
tui-form-submit-local-ae-required = локальний AE title обов’язковий
tui-form-submit-local-ae-invalid = локальний AE title некоректний: { $err }
tui-form-submit-bind-required = адреса прив’язки обов’язкова
tui-form-submit-port-required = порт обов’язковий
tui-form-submit-max-pdu-required = макс. довжина PDU обов’язкова
tui-form-submit-max-pdu-int = макс. довжина PDU має бути цілим числом
tui-form-submit-max-pdu-gt-zero = макс. довжина PDU має бути більшою за 0
tui-form-submit-patient-retrieve = отримання на рівні пацієнта не підтримується
tui-form-submit-no-study-uid = вибраний результат не містить study UID
tui-form-submit-date-format = очікується YYYYMMDD
tui-form-submit-modality-len = модальність має містити щонайбільше 16 символів
tui-form-submit-modality-chars = модальність має бути A-Z або 0-9
tui-form-submit-name-required = назва вузла обов’язкова
tui-form-submit-ae-required = AE title обов’язковий
tui-form-submit-host-required = хост обов’язковий
tui-form-submit-move-dest-invalid = AE title призначення переміщення некоректний: { $err }
tui-form-submit-dates-both = дату від і дату до треба задати обидві, або жодну
tui-form-submit-date-from-invalid = дата від некоректна: { $err }
tui-form-submit-date-to-invalid = дата до некоректна: { $err }
tui-form-submit-date-order = дата від має бути не пізніша за дату до
tui-form-submit-study-uid-series-query = study UID обов’язковий для запитів на рівні серії
tui-form-submit-study-uid-image-query = study UID обов’язковий для запитів на рівні зображення
tui-form-submit-series-uid-image-query = series UID обов’язковий для запитів на рівні зображення
tui-form-submit-study-uid-required = study UID обов’язковий
tui-form-submit-study-uid-invalid = study UID некоректний: { $err }
tui-form-submit-series-uid-series-retrieve = series UID обов’язковий для отримання на рівні серії
tui-form-submit-series-uid-image-retrieve = series UID обов’язковий для отримання на рівні зображення
tui-form-submit-instance-uid-image-retrieve = instance UID обов’язковий для отримання на рівні зображення
tui-form-submit-series-uid-invalid = series UID некоректний: { $err }
tui-form-submit-instance-uid-invalid = instance UID некоректний: { $err }
tui-form-submit-import-path-required = шлях імпорту обов’язковий
tui-form-submit-import-path-type = шлях імпорту має бути файлом або каталогом: { $path }
tui-form-submit-import-access = доступ до шляху імпорту { $path }
tui-form-submit-import-open = відкриття файлу імпорту { $path }
tui-form-submit-import-read-dir = читання каталогу імпорту { $path }
tui-log-welcome = Press F1 or ? for help. Focus Віддалений вузолs and press 'a' to add one.
tui-log-logging-to = Журнал: { $path }
tui-command-help-heading = команди:
tui-command-help-next-1 = примітка: у підвалі показано контекстні підказки 'Next:' залежно від активної панелі та вибору.
tui-command-help-next-2 = Це лише підказки; ви завжди можете ввести будь-яку команду.
tui-command-help-canonical = примітка: канонічні імена збігаються з прапорцями CLI без '--', через підкреслення.
tui-command-help-cancel = cancel (псевдонім: stop)
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
tui-command-help-refresh = оновити
tui-command-help-quit = вихід
tui-inspect-task = Завдання #{ $id }
tui-inspect-status = Стан: { $status }
tui-inspect-description = Опис: { $description }
tui-inspect-progress = Прогрес: { $progress }
tui-inspect-summary = Підсумок:
tui-inspect-no-logs = (немає журналів)
tui-field-sop-class-uid = SOP Class UID
tui-field-transfer-syntax-uid = Transfer Syntax UID
tui-field-sha256 = SHA-256
tui-status-removed-nodes =
    видалено { $count ->
        [one] { $count } вузол
        [few] { $count } вузли
        [many] { $count } вузлів
       *[other] { $count } вузлів
    }
tui-status-removed-nodes-target =
    видалено { $count ->
        [one] { $count } вузол
        [few] { $count } вузли
        [many] { $count } вузлів
       *[other] { $count } вузлів
    }; остання ціль { $name }
tui-status-more-failures =
    і { $n ->
        [one] { $n } пропущений збій
        [few] { $n } пропущені збої
        [many] { $n } пропущених збоїв
       *[other] { $n } пропущених збоїв
    }
tui-status-retrieve-ok = retrieve status=0x{ $status } completed={ $completed } failed={ $failed } warning={ $warning } remaining={ $remaining }
tui-status-import-counts = scanned={ $scanned } accepted={ $accepted } duplicates={ $duplicates } unreadable={ $unreadable } invalid_dicom={ $invalid } rejected_total={ $rejected } stored_bytes={ $bytes }
tui-status-send-ok = send attempted={ $attempted } sent={ $sent } failed={ $failed }
tui-log-query-start = Запуск запиту до { $node }
tui-log-retrieve-start = Запуск отримання з { $node }
tui-log-import-start = Запуск імпорту { $path }
tui-log-send-study-start = Запуск надсилання дослідження { $uid } до { $node }
tui-log-send-series-start = Запуск надсилання серії { $uid } до { $node }
tui-log-cancelled-before-start = скасовано до запуску
tui-log-cancelled = скасовано
error-unknown-command = невідома команда: { $command }
error-node-subcommand-required = потрібна підкоманда node
error-local-subcommand-required = потрібна підкоманда local
error-unsupported-node-subcommand = unsupported вузол subcommand: { $command }
error-unsupported-local-subcommand = непідтримувана підкоманда local: { $command }
error-expected-kv = очікувався аргумент key=value, отримано { $arg }
error-missing-required-arg = бракує обов’язкового аргументу: { $key }
error-missing-required-arg-one-of = бракує обов’язкового аргументу: один із { $keys }
error-parsing-command = розбір команди
error-edit-form-lost-target = edit form lost its target вузол
error-task-already-running = фонове завдання вже виконується
error-task-thread-launch = не вдалося запустити потік фонового завдання: { $error }
error-task-disconnected = потік фонового завдання від’єднався до надсилання результату
error-task-kind-missing = потік фонового завдання від’єднався, але active_task_kind був None: неочікуваний стан
error-serve-exited = serve завершився з помилкою: { $error }
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
summary-title = Підсумок операції
summary-kind = Тип
summary-status = Статус
summary-duration = Тривалість
summary-duration-ms = { $ms }ms
summary-peer = Пір
summary-ae = AE
summary-criteria = Критерії
summary-counts = Лічильники
summary-failures = Збої:
summary-logs = Журнали:
summary-unserializable = <не серіалізується>
summary-log-lines = рядки { $start }-{ $end }
