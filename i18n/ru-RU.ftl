# Fluent catalog (ru-RU). Message IDs are hyphenated identifiers
# (cli-about, tui-pane-remote-nodes, desktop-nav-dashboard, error-import-file-too-large).
# Dotted names are Fluent attributes (message + .attr), not message IDs.
# Do not translate DICOM tokens (C-FIND, C-MOVE, C-STORE, SOP, AE, UID) or JSON/CSV machine keys.


## CLI
cli-about = Терминальный клиент DICOM-узла на базе dicom-rs
cli-arg-accession-number = Фильтр по номеру accession (подстрока без учёта регистра).
cli-arg-ae-title = Application Entity title
cli-arg-destination-node = Имя или id узла назначения
cli-arg-duplicate = Фильтр по признаку дубликата.
cli-arg-export = Экспортировать результаты как JSON или CSV.
cli-arg-host = Имя хоста или IP
cli-arg-imported-at =
    Фильтр по времени импорта. Допускаются VALUE, START..END, ..END, START...
    Сравнение лексикографическое (рекомендуемый формат: RFC3339).
cli-arg-json = Вывести итоговую сводку операции в JSON (стабильная схема).
cli-arg-level = Уровень запроса/получения
cli-arg-metrics-json = При выходе сервера вывести снимок метрик из памяти в JSON.
cli-arg-modality = Фильтр по модальности. Список через запятую (напр. CT,MR).
cli-arg-model = Информационная модель запроса/получения
cli-arg-move-destination = Предпочтительный AE title назначения для C-MOVE
cli-arg-name = Отображаемое имя узла
cli-arg-node = Имя или id сохранённого узла
cli-arg-notes = Произвольные заметки
cli-arg-out = Путь к файлу вывода. Если не указан, пишет в stdout.
cli-arg-path = Файл или каталог для импорта
cli-arg-patient-id = Фильтр по ID пациента (подстрока без учёта регистра).
cli-arg-patient-name = Фильтр по имени пациента (подстрока без учёта регистра).
cli-arg-port = Порт
cli-arg-series-description = Фильтр по описанию серии (подстрока без учёта регистра).
cli-arg-series-instance-uid = Series Instance UID
cli-arg-sop-instance-uid = SOP Instance UID
cli-arg-source-path = Фильтр по исходному пути (подстрока без учёта регистра).
cli-arg-study-date =
    Фильтр по дате исследования. Допускаются VALUE, START..END, ..END, START...
    Даты сравниваются лексикографически (рекомендуемый формат: YYYYMMDD).
cli-arg-study-date-from = Нижняя граница даты исследования (YYYYMMDD)
cli-arg-study-date-to = Верхняя граница даты исследования (YYYYMMDD)
cli-arg-study-description = Фильтр по описанию исследования (подстрока без учёта регистра).
cli-arg-study-instance-uid = Study Instance UID
cli-cmd-import-about = Импортировать файлы DICOM из указанного пути
cli-cmd-local-about = Просмотреть локальный архив
cli-cmd-local-series-about = Показать проиндексированные серии исследования
cli-cmd-local-studies-about = Показать проиндексированные локальные исследования
cli-cmd-node-about = Управлять сохранёнными удалёнными DICOM-узлами
cli-cmd-node-add-about = Добавить удалённый узел
cli-cmd-node-delete-about = Удалить сохранённый узел
cli-cmd-node-edit-about = Изменить сохранённый узел
cli-cmd-node-list-about = Показать сохранённые узлы
cli-cmd-query-about = Запросить удалённый узел (C-FIND)
cli-cmd-retrieve-about = Получить данные с удалённого узла (C-MOVE)
cli-cmd-send-about = Отправить локальные исследования или серии (C-STORE)
cli-cmd-send-series-about = Отправить серию на узел назначения
cli-cmd-send-study-about = Отправить исследование на узел назначения
cli-cmd-serve-about = Запустить DICOM-сервер
cli-cmd-storage-scp-about = Запустить слушатель Storage SCP
cli-cmd-tui-about = Открыть интерактивный терминальный интерфейс
cli-flag-help = Показать справку
cli-flag-lang = Язык интерфейса (тег BCP-47). Переопределяет DICOM_NODE_LANG, сохранённую локаль и локаль ОС.
cli-flag-version = Показать версию
cli-heading-arguments = Аргументы:
cli-heading-commands = Команды:
cli-heading-options = Параметры:
cli-heading-usage = Использование:
cli-import-accepted = accepted={ $n }
cli-import-complete = Импорт завершён
cli-import-duplicates = duplicates={ $n }
cli-import-scanned = scanned={ $n }
cli-msg-cancel-sigint = Запрошена отмена (SIGINT). Ожидание корректного завершения...
cli-msg-failures = ошибки:
cli-msg-import-failed = Импорт не выполнен: { $error }
cli-msg-no-local-series = Нет проиндексированных серий для исследования { $uid }
cli-msg-no-local-studies = Нет проиндексированных локальных исследований
cli-msg-no-saved-nodes = Нет сохранённых узлов
cli-msg-query-failed = Запрос не выполнен: { $error }
cli-msg-removed-nodes =
    Удалено { $count ->
        [one] { $count } узел
        [few] { $count } узла
        [many] { $count } узлов
       *[other] { $count } узлов
    }
cli-msg-results-count =
    Результатов: { $count ->
        [one] { $count } совпадение
        [few] { $count } совпадения
        [many] { $count } совпадений
       *[other] { $count } совпадений
    }
cli-msg-retrieve-failed = Получение не выполнено: { $error }
cli-msg-saved-node = Сохранён узел { $name } [{ $id }] => { $ae }@{ $host }:{ $port }
cli-msg-send-failed = Отправка не выполнена: { $error }
cli-msg-showing-failures = (показаны первые { $shown } из { $total } ошибок)
cli-msg-starting-server =
    Запуск DICOM-сервера с { $count ->
        [one] { $count } локальный AE
        [few] { $count } локальных AE
        [many] { $count } локальных AE
       *[other] { $count } локальных AE
    }: { $aes }
cli-msg-starting-server-no-aes = Запуск DICOM-сервера без настроенных локальных AE
cli-msg-starting-storage-scp = Запуск Storage SCP на { $addr } с AE title { $ae }
cli-msg-updated-node = Обновлён узел { $name } [{ $id }] => { $ae }@{ $host }:{ $port }
cli-send-attempted = attempted={ $n }
cli-send-failed-count = failed={ $n }
cli-send-sent = sent={ $n }
cli-value-name-file = FILE
cli-value-name-format = FORMAT
cli-value-name-locale = LOCALE
cli-value-name-path = PATH
tui-detail-more-series =
    ... { $n ->
        [one] { $n } серия ещё
        [few] { $n } серии ещё
        [many] { $n } серий ещё
       *[other] { $n } серий ещё
    }
tui-row-instance-count =
    { $n ->
        [one] { $n } экз.
        [few] { $n } экз.
        [many] { $n } экз.
       *[other] { $n } экз.
    }
tui-row-study-counts = { $series }s/{ $instances }i
count-nodes =
    { $n ->
        [one] { $n } узел
        [few] { $n } узла
        [many] { $n } узлов
       *[other] { $n } узлов
    }
count-instances =
    { $n ->
        [one] { $n } экземпляр
        [few] { $n } экземпляра
        [many] { $n } экземпляров
       *[other] { $n } экземпляров
    }
count-series =
    { $n ->
        [one] { $n } серия
        [few] { $n } серии
        [many] { $n } серий
       *[other] { $n } серий
    }
count-studies =
    { $n ->
        [one] { $n } исследование
        [few] { $n } исследования
        [many] { $n } исследований
       *[other] { $n } исследований
    }
format-datetime = { $date } { $time }
format-date = { $day }.{ $month }.{ $year }

## Common
common-accession = Номер обращения
common-add = Добавить
common-back = Назад
common-bytes = Байты
common-cancel = Отмена
common-clear = Очистить
common-close = Закрыть
common-date = Дата
common-delete = Удалить узел
common-description = Описание
common-disabled = выключено
common-duplicates = Дубликаты
common-edit = Изменить
common-enabled = включено
common-error = Ошибка
common-filter = Фильтр
common-host = Хост
common-import = Импорт
common-instance = Инстанс
common-language = Язык
common-loading = Загрузка
common-matches = Совпадения
common-modality = Модальность
common-name = Имя
common-network = Сеть
common-no = нет
common-none = нет
common-notes = Заметки
common-optional = необязательно
common-path = Источник
common-patient = Пациент
common-patient-id = ID пациента
common-patient-name = Имя пациента
common-port = Порт
common-query = Запрос
common-refresh = Обновить
common-required = обязательно
common-retrieve = Извлечь
common-save = Сохранить
common-search = Поиск
common-send = Отправить
common-series = Серии
common-start = Запуск
common-status = Статус
common-stop = Стоп
common-studies = Исследования
common-study = Исследование
common-unknown = неизвестно
common-unknown-series = <Серии>
common-unknown-study = <Исследования>
common-yes = да

## Errors
error-ae-empty = AE title не может быть пустым
error-ae-invalid-char = AE title содержит недопустимый символ '{ $character }'; разрешено: A-Z, 0-9, пробел
error-ae-required = AE title обязателен
error-ae-too-long = AE title должен быть не длиннее 16 символов
error-ae-whitespace = AE title не может содержать пробелы в начале или в конце
error-archive-patient-retrieve-out-of-scope = retrieve уровня Patient вне области поддержки
error-archive-retrieve-uid-required = для этого уровня retrieve требуется { $name }
error-archive-study-root-patient-query = запросы Study Root не поддерживают уровень Patient
error-archive-study-root-patient-retrieve = retrieve Study Root не поддерживает уровень Patient
error-assoc-negotiation-failed = сбой согласования association с { $name } ({ $addr }); подсказка: проверьте called AE title, presentation contexts/transfer syntaxes и что узел принимает association
error-assoc-no-addresses = не удалось разрешить адреса сокета для { $name } на { $host }:{ $port }
error-assoc-receive = приём association
error-assoc-resolving = разрешение { $name } на { $host }:{ $port }: { $err }
error-assoc-timeout = тайм-аут ожидания ответа DIMSE; подсказка: проверьте сеть, AE title/хост/порт и отзывчивость узла
error-assoc-transport = сбой транспорта при ожидании ответа DIMSE; подсказка: узел закрыл соединение или сетевое устройство сбросило его
error-assoc-unreachable = не удалось достучаться до { $name } [{ $ae }] на { $host }:{ $port } за { $seconds }с: { $err }. Проверьте хост/IP, порт и сетевую доступность
error-cancel-sigint = Запрошена отмена (SIGINT). Ожидание корректного завершения...
error-config-must-be-positive = неверная конфигурация: { $name } должен быть > 0 (или null, чтобы отключить)
error-config-duplicate-bind-port = неверная конфигурация: повторяющийся порт bind локального AE { $port }
error-config-local-ae-max-assoc = неверная конфигурация: локальный AE { $title } max_concurrent_associations должен быть > 0
error-config-local-ae-no-services = неверная конфигурация: локальный AE { $title } должен включить хотя бы одну службу
error-config-must-be-positive-required = неверная конфигурация: { $name } должен быть > 0
error-dicom-meta-incomplete = file meta DICOM неполный
error-dicom-patient-move-unsupported = C-MOVE на уровне пациента не поддерживается этим клиентом
error-dicom-required-attribute = отсутствует обязательный атрибут DICOM: ({ $group },{ $element })
error-dicom-series-uid-required-image = для retrieve на уровне изображения требуется series_instance_uid
error-dicom-series-uid-required-series = для retrieve на уровне серии требуется series_instance_uid
error-dicom-sop-uid-required-image = для retrieve на уровне изображения требуется sop_instance_uid
error-dicom-study-uid-required = требуется study_instance_uid
error-dicom-validating-move = проверка запроса move
error-export-creating-file = создание файла экспорта { $path }: { $err }
error-export-flushing-series-csv = сброс CSV серий: { $err }
error-export-flushing-studies-csv = сброс CSV исследований: { $err }
error-export-serializing-series-json = сериализация JSON серий: { $err }
error-export-serializing-studies-json = сериализация JSON исследований: { $err }
error-export-writing-series-csv-header = запись заголовка CSV серий: { $err }
error-export-writing-series-csv-row = запись строки CSV серий: { $err }
error-export-writing-studies-csv-header = запись заголовка CSV исследований: { $err }
error-export-writing-studies-csv-row = запись строки CSV исследований: { $err }
error-import-cleanup-failed = { $source }: очистка не удалась: { $reason }
error-import-corrupt-zip = Повреждённый ZIP: { $details }
error-import-dicom-parse-failed = разбор DICOM не удался: { $err }
error-import-dicom-validation-failed = проверка DICOM не удалась: { $err }
error-import-duplicate-zip-path = ZIP содержит несколько записей, указывающих на '{ $path }'
error-import-file-too-large = файл слишком большой: { $details }
error-import-invalid-dicom = Недействительный DICOM: { $details }
error-import-limit-exceeded = { $limit } превышен: { $details }
error-import-not-regular-file = не обычный файл
error-import-opening-file = открытие файла: { $err }
error-import-opening-kind = открытие { $kind } { $path }
error-import-opening-staged-file = открытие файла в staging: { $err }
error-import-opening-zip-archive = открытие ZIP-архива { $path }
error-import-opening-zip-entry = открытие записи ZIP: { $err }
error-import-opening-zip-file = открытие ZIP-файла импорта { $path }
error-import-path-does-not-exist = Путь импорта не существует: { $path }
error-import-reading-directory = чтение каталога импорта { $path }
error-import-reading-file = чтение файла: { $err }
error-import-reading-file-metadata = чтение метаданных файла { $path }
error-import-reading-metadata = чтение метаданных { $kind } { $path }
error-import-reading-zip-entry = чтение записи ZIP: { $err }
error-import-removing-staged-after-cancel = удаление файла staging после отмены { $path }
error-import-skipped = { $source }: пропущено: { $reason }
error-import-unreadable = Нечитаемый файл: { $details }
error-import-unsafe-zip-path = путь записи выходит за пределы архива
error-import-zip-entry-count-exceeded = превышен лимит числа записей ZIP: в архиве { $count } записей, лимит { $limit }
error-import-zip-entry-size-exceeded = размер записи ZIP { $size } превышает лимит { $limit }
error-import-zip-total-bytes-exceeded = превышен лимит извлечённых байт ZIP: текущая сумма { $current } плюс размер записи { $entry } превышает лимит { $limit }
error-net-binding-storage-scp = привязка Storage SCP на { $addr } для AE { $ae }. Другой локальный DICOM-приёмник, возможно, уже занимает этот порт. Обновите storage_scp_port/local_aes в { $config } или остановите конфликтующий слушатель
error-net-building-file-meta = построение таблицы file meta
error-net-cannot-send-transfer-syntax = нельзя отправить исходный transfer syntax { $source } с согласованным { $negotiated }
error-net-cget-dataset-empty = закодированный набор данных C-GET C-STORE пуст
error-net-cget-dataset-odd-length = закодированный набор C-GET C-STORE завершился фрагментом нечётной длины
error-net-cget-peer-released = узел освободил ассоциацию во время C-GET
error-net-cget-store-unexpected-dataset = неожиданный dataset fragment in C-GET C-STORE response
error-net-cget-unexpected-command = неожиданный command 0x{ $command } while waiting for C-STORE-RSP
error-net-cget-unexpected-pdu = неожиданный PDU during C-GET C-STORE suboperation: { $pdu }
error-net-creating-incoming-dir = создание каталога .incoming Storage SCP
error-net-creating-path = создание { $path }
error-net-dataset-empty = закодированный набор пуст, но COMMAND_DATA_SET_TYPE требует набор данных
error-net-dataset-odd-length = закодированный набор завершился фрагментом нечётной длины
error-net-dimse-failed = { $operation } завершилось со статусом 0x{ $status } ({ $meaning }){ $hint }
error-net-establishing-assoc = установка ассоциации Storage SCP
error-net-file-meta-length = чтение File Meta Information length
error-net-file-meta-tag = чтение File Meta Information tag
error-net-file-meta-value = пропуск значения File Meta Information
error-net-file-meta-vr = чтение File Meta Information VR
error-net-file-position = чтение file position
error-net-flushing-path = сброс { $path }
error-net-flushing-temp-dataset = сброс временного файла набора данных
error-net-hint-suffix = ; подсказка: { $hint }
error-net-incomplete-command = неполный { $operation } command response
error-net-incomplete-identifier = неполный { $operation } response identifier
error-net-invalid-affected-sop = недействительный { $operation } affected SOP class UID
error-net-invalid-status = недействительный { $operation } status
error-net-listener-address = чтение storage SCP listener address
error-net-listener-nonblocking = включение неблокирующего режима слушателя
error-net-listener-port = чтение storage SCP listener port
error-net-local-aes-empty = local_aes должен содержать хотя бы один AE для запуска Storage SCP
error-net-locating-dataset = поиск набора данных в { $path }
error-net-malformed-dimse = malformed { $operation } DIMSE response: { $details }; подсказка: peer sent an недействительный or неожиданный DIMSE command set
error-net-missing-affected-sop = отсутствует { $operation } affected SOP class UID
error-net-missing-command-field = отсутствует command field
error-net-missing-cstore-rsp-command-field = отсутствует C-STORE response command field
error-net-missing-cstore-rsp-status = отсутствует C-STORE response status
error-net-missing-destination = отсутствует C-MOVE destination
error-net-missing-dicm = отсутствует Part 10 DICM marker
error-net-missing-message-id = отсутствует { $operation } message id
error-net-missing-qr-level = { $operation } identifier is отсутствует QueryRetrieveLevel
error-net-missing-required-command-field = отсутствует required command field { $name } ({ $tag })
error-net-missing-status = отсутствует { $operation } status
error-net-move-destination-unresolved = move_destination не был разрешён
error-net-no-cget-store-context = нет согласованного presentation context хранения C-GET для SOP Class { $sop } и transfer syntax { $syntax }
error-net-no-compatible-context = { $path }: нет совместимого согласованного presentation context для исходного transfer syntax { $syntax }
error-net-no-dimse-provider = нет зарегистрированного поставщика DIMSE для команды 0x{ $command } и abstract syntax { $syntax }
error-net-no-presentation-context = нет согласованного presentation context
error-net-no-presentation-context-for-file = { $path }: нет согласованного presentation context
error-net-no-presentation-context-id = отсутствует negotiated presentation context { $id }
error-net-opening-path = открытие { $path }
error-net-part10-preamble = чтение Part 10 preamble
error-net-path-error = { $path }: { $err }
error-net-pdata-feed-complete = cannot feed P-DATA fragment into a complete accumulator (отсутствует take())
error-net-peer-aborted = узел прервал ассоциацию во время подоперации C-GET C-STORE: { $source }
error-net-peer-socket = чтение storage SCP peer socket address
error-net-reading-command-dataset = чтение command dataset
error-net-reading-identifier = чтение { $operation } identifier
error-net-reading-incoming-dataset = чтение incoming C-STORE dataset
error-net-reading-response-dataset = чтение { $operation } response dataset
error-net-remote-aborted = удалённая сторона прервала ассоциацию: { $source }
error-net-restoring-read-timeout = восстановление тайм-аута чтения association
error-net-restoring-write-timeout = восстановление тайм-аута записи association
error-net-rewinding-dataset = перемотка к первому элементу набора данных
error-net-scp-thread-panicked = поток Storage SCP аварийно завершился
error-net-seeking-temp-dataset = позиционирование во временном файле набора
error-net-serializing-cget-dataset = сериализация набора подоперации C-GET для { $path }
error-net-serializing-dataset = сериализация набора для { $path } с transfer syntax { $syntax }
error-net-setting-socket-blocking = перевод принятого сокета хранения в блокирующий режим
error-net-sending-buffered-dataset = отправка буферизованного набора для { $path }
error-net-store-status = удалённая сторона вернула статус C-STORE 0x{ $status } ({ $meaning }){ $hint }
error-net-streaming-dataset = потоковая передача набора C-STORE
error-net-unexpected-command-field = неожиданный CommandField 0x{ $actual } (expected 0x{ $expected } for { $rsp })
error-net-unexpected-dataset-fragment = неожиданный dataset fragment in C-STORE response
error-net-unexpected-pdu = неожиданный PDU during { $operation }: { $pdu }
error-net-unknown-status = недействительный { $operation } status 0x{ $status }
error-net-unsupported-model-sop = не поддерживается { $operation } model SOP class UID: { $uid }
error-net-unsupported-qr-level = не поддерживается QueryRetrieveLevel: { $level }
error-net-unsupported-transfer-syntax = не поддерживается negotiated transfer syntax
error-net-writing-command-dataset = запись command dataset
error-net-writing-identifier = запись { $operation } identifier
error-net-writing-path = запись { $path }
error-net-writing-response-dataset = запись { $operation } response dataset
error-net-writing-temp-dataset = запись dataset bytes to temp file
error-node-host-empty = хост узла не может быть пустым
error-node-name-empty = имя узла не может быть пустым
error-node-not-found = удалённый узел не найден: { $id }
error-operation-cancelled = операция отменена
error-port-invalid = недопустимый порт: { $value }
error-port-range = порт должен быть от 1 до 65535
error-query-no-study-uid = У совпадения нет StudyInstanceUID; получить нельзя.
error-query-unsupported-level = неподдерживаемый уровень запроса: { $value }
error-query-unsupported-model = неподдерживаемая модель запроса: { $value }
error-retrieve-canceled = retrieve отменён удалённым узлом (status=0x{ $status }, completed={ $completed }, failed={ $failed }, warning={ $warning }, remaining={ $remaining }, { $scp })
error-retrieve-failed = retrieve завершился с ошибкой status=0x{ $status } (completed={ $completed }, failed={ $failed }, warning={ $warning }, remaining={ $remaining }, { $scp })
error-retrieve-nothing-arrived = retrieve для назначения { $destination } завершился с completed={ $completed }, но на локальный Storage SCP ничего не поступило ({ $scp }). Проверьте сопоставление AE или порт: убедитесь, что { $listener } свободен и что удалённый узел сопоставляет AE { $destination } с этим приложением
error-send-no-files-series = нет локальных проиндексированных файлов для серии { $uid }
error-send-no-files-study = нет локальных проиндексированных файлов для исследования { $uid }
error-task-cancelled = Задача отменена
error-task-none-to-cancel = Нет активной задачи для отмены (ничего не выполняется)
error-tracing-init = инициализация tracing subscriber: { $err }
error-uid-component-numeric = компонент UID '{ $part }' должен быть числовым
error-uid-component-too-long = компонент UID '{ $part }' слишком длинный
error-uid-dot-ends = UID не может начинаться или заканчиваться точкой
error-uid-empty = UID не может быть пустым
error-uid-empty-component = UID не может содержать пустые компоненты
error-uid-leading-zeros = компонент UID '{ $part }' не может начинаться с нулей
error-uid-too-long = UID не длиннее 64 символов

## TUI
tui-bool-no = нет
tui-bool-off = выкл
tui-bool-on = вкл
tui-bool-yes = да
tui-command-placeholder = Введите команду или используйте сочетания панели.
tui-config-ae-title = AE title: { $value }
tui-config-edit-hint = Нажмите Tab, чтобы сфокусировать панель, затем 'c' для правки.
tui-config-hint = Нажмите Tab, чтобы сфокусировать панель, затем 'c' для правки.
tui-config-listener = Слушатель: { $value }
tui-config-max-pdu = max_pdu_length: { $value }
tui-config-promiscuous = allow_promiscuous_storage: { $value }
tui-config-strict-pdu = strict_pdu: { $value }
tui-config-ts-pref = Предп. TS: { $value }
tui-controls-hint = Tab поля · Enter подтверждает · Esc отменяет
tui-detail-ae-title = AE Title
tui-detail-instance = Сведения об экземпляре
tui-detail-name = Имя
tui-detail-node = Сведения об узле
tui-detail-placeholder-followup = Переведите фокус на панель списка и измените выбор, чтобы обновить это представление.
tui-detail-query = Сведения о результате запроса
tui-detail-select-node = Выберите удалённый узел, чтобы просмотреть его метаданные.
tui-detail-series = Сведения о серии
tui-detail-study = Сведения об исследовании
tui-empty-command-placeholder = Введите команду или используйте сочетания панели.
tui-empty-detail-instance = Выберите инстанс для просмотра или вернитесь к сериям клавишей Esc.
tui-empty-detail-node = Выберите удалённый узел, чтобы просмотреть его метаданные.
tui-empty-detail-query = Выберите результат запроса, чтобы просмотреть метаданные и контекст retrieve.
tui-empty-detail-series = Выберите серию для просмотра или вернитесь к исследованиям клавишей Esc.
tui-empty-detail-study = Выберите локальное исследование, чтобы просмотреть метаданные пациента и серий.
tui-empty-instances = Для этой серии нет проиндексированных экземпляров.
tui-empty-instances-hint = Нажмите Esc, чтобы вернуться к сериям.
tui-empty-local-instances = Для этой серии нет проиндексированных экземпляров.
tui-empty-local-instances-hint = Нажмите Esc, чтобы вернуться к сериям.
tui-empty-local-series = Для этого исследования нет проиндексированных серий.
tui-empty-local-series-hint = Нажмите Esc, чтобы вернуться к локальным исследованиям.
tui-empty-local-studies = Проиндексированных исследований пока нет.
tui-empty-local-studies-cmd = Пример: import path=/data/inbox
tui-empty-local-studies-hint = Сначала импортируйте локальные файлы DICOM.
tui-empty-no-name = <без имени>
tui-empty-query = Запрос ещё не выполнялся.
tui-empty-query-body =
    Выберите удалённый узел и нажмите 'f' для запроса.
    Или: query node=pacs
        patient_name="DOE^JOHN"
    Нажмите 'm' на выбранном результате, чтобы открыть retrieve.
tui-empty-query-cmd = Или: query node=pacs
tui-empty-query-hint = Выберите удалённый узел и нажмите 'f' для запроса.
tui-empty-query-last-target = Последняя цель запроса: { $name }
tui-empty-query-none = Запрос ещё не выполнялся.
tui-empty-query-retrieve-hint = Нажмите 'm' на выбранном результате, чтобы открыть retrieve.
tui-empty-remote-nodes = Сохранённых удалённых узлов пока нет.
tui-empty-remote-nodes-cmd = Или: node add name=pacs
tui-empty-remote-nodes-hint = Нажмите 'a' в этой панели, чтобы добавить узел.
tui-empty-series = Для этого исследования нет проиндексированных серий.
tui-empty-series-hint = Нажмите Esc, чтобы вернуться к локальным исследованиям.
tui-empty-studies = Проиндексированных исследований пока нет.
tui-empty-studies-hint = Сначала импортируйте локальные файлы DICOM.
tui-empty-tasks-history = История задач пуста.
tui-empty-tasks-queued = В очереди нет задач.
tui-fallback-no-name = <без имени>
tui-field-accession = Номер accession
tui-field-ae-title = AE title
tui-field-bind-addr = Адрес bind
tui-field-date-from = Дата с
tui-field-date-to = Дата по
tui-field-destination-node = Узел назначения
tui-field-host = Хост
tui-field-instance-uid = Instance UID
tui-field-kind = Тип
tui-field-level = Уровень
tui-field-local-ae = Локальный AE
tui-field-max-pdu = Макс. PDU
tui-field-modality = Модальность
tui-field-model = Модель
tui-field-move-destination = Назначение Move
tui-field-name = Имя
tui-field-notes = Заметки
tui-field-path = Путь
tui-field-patient-id = ID пациента
tui-field-patient-name = Имя пациента
tui-field-port = Порт
tui-field-promiscuous = Неразборчивый
tui-field-series-uid = Series UID
tui-field-sop-uid = SOP Instance UID
tui-field-strict-pdu = Строгий PDU
tui-field-study-description = Описание исследования
tui-field-study-uid = Study UID
tui-footer-back-series = Esc к сериям
tui-footer-back-studies = Esc к исследованиям
tui-footer-cancel-task = c отмена
tui-footer-edit-config = c изменить конфиг
tui-footer-enter-series = Enter серии
tui-footer-esc-series = Esc к сериям
tui-footer-esc-studies = Esc к исследованиям
tui-footer-help = F1/? справка
tui-footer-inspect = Enter сведения
tui-footer-next = Далее: { $text }
tui-footer-nodes = a/e/d/f узлы
tui-footer-panes = Tab панели
tui-footer-queued =
    { $n ->
        [one] { $n } в очереди
        [few] { $n } в очереди
        [many] { $n } в очереди
       *[other] { $n } в очереди
    }
tui-footer-quit = q выход
tui-footer-refresh = r обновить
tui-footer-retrieve = m извлечь
tui-footer-run-command = Enter выполнить команду
tui-footer-task-scope = t очередь/история
tui-form-add-node = Добавить удалённый узел
tui-form-add-remote-node = Добавить удалённый узел
tui-form-delete-confirm = Удалить удалённый узел { $name } [{ $ae }] по адресу { $host }:{ $port }?
tui-form-delete-node = Удалить удалённый узел
tui-form-delete-remote-node = Удалить удалённый узел
tui-form-edit-node = Изменить удалённый узел
tui-form-edit-remote-node = Изменить удалённый узел
tui-form-err-ae-required = ! AE title обязателен
tui-form-err-bind-required = ! адрес привязки обязателен
tui-form-err-host-required = ! узел обязателен
tui-form-err-local-ae-invalid = ! некорректный локальный AE title: { $err }
tui-form-err-local-ae-required = ! локальный AE title обязателен
tui-form-err-modality-empty = modality не может быть пустым
tui-form-err-move-dest-invalid = ! некорректный AE title назначения перемещения: { $err }
tui-form-err-name-required = ! узел name is required
tui-form-err-port-required = ! порт обязателен
tui-form-err-uid-empty = UID не может быть пустым
tui-form-err-uid-empty-component = UID не может содержать пустые компоненты
tui-form-error-line = Ошибка: { $error }
tui-form-field-accession = Номер accession
tui-form-field-ae-title = AE title
tui-form-field-bind-addr = Адрес привязки
tui-form-field-date-from = Дата с
tui-form-field-date-to = Дата по
tui-form-field-dest-node = Узел назначения
tui-form-field-destination = Целевой AE
tui-form-field-host = Хост
tui-form-field-instance-uid = SOP Instance UID
tui-form-field-kind = Тип
tui-form-field-level = Уровень
tui-form-field-local-ae = Локальный AE
tui-form-field-modality = Модальность
tui-form-field-model = Модель
tui-form-field-move-dest = Назначение Move
tui-form-field-name = Имя
tui-form-field-notes = Заметки
tui-form-field-path = Путь
tui-form-field-patient-id = ID пациента
tui-form-field-patient-name = Имя пациента
tui-form-field-port = Порт
tui-form-field-series-uid = Series Instance UID
tui-form-field-sop-uid = SOP Instance UID
tui-form-field-study-desc = Описание исследования
tui-form-field-study-uid = Study Instance UID
tui-form-field-uid = UID
tui-form-hint-bind = подсказка: обычно 0.0.0.0 (все интерфейсы) или 127.0.0.1
tui-form-hint-local-ae = подсказка: до 16 символов (A-Z, 0-9, пробел), напр. ARCHIVE_AE
tui-form-hint-move-dest = подсказка: необязательно; переопределяет целевой AE title C-MOVE
tui-form-hint-name = подсказка: короткое имя (напр. PACS)
tui-form-import = Импортировать локальные файлы
tui-form-import-local = Импортировать локальные файлы
tui-form-import-local-files = Импортировать локальные файлы
tui-form-mode-add = create a new удалённый узел
tui-form-mode-edit = update the selected удалённый узел
tui-form-query-node = Запросить удалённый узел
tui-form-query-remote-node = Запросить удалённый узел
tui-form-remote-node-line = Удалённый узел: { $name } [{ $ae }] { $host }:{ $port }
tui-form-retrieve = Получить совпадения
tui-form-retrieve-matches = Получить совпадения
tui-form-send-series = Отправить серию
tui-form-send-study = Отправить исследование
tui-form-storage-intro = Изменить локальные параметры Storage SCP (сохраняются в config.json).
tui-form-storage-scp = Параметры Storage SCP
tui-form-storage-scp-settings = Параметры Storage SCP
tui-help-ae-title = AE title: { $value }
tui-help-aedf = a/e/d/f     Add, edit, delete, or query from the selected узел
tui-help-c = c           Изменить параметры Storage SCP (фокус на панели конфигурации)
tui-help-canonical-names = Канонические имена соответствуют флагам CLI без '--' и используют подчёркивания.
tui-help-close = Закройте справку клавишами Esc, F1 или ?.
tui-help-common-commands = Типовые команды
tui-help-config = c           Изменить параметры Storage SCP (фокус на панели конфигурации)
tui-help-config-path = Путь конфигурации: { $value }
tui-help-current-config = Текущая конфигурация
tui-help-data-dir = Каталог данных: { $value }
tui-help-enter-default = Enter       Run the command input, submit the active modal, or open series from Локальные исследования
tui-help-enter-instance = Enter       Нет действия локальной панели в виде экземпляра
tui-help-enter-local-instance = Enter       Нет действия локальной панели в виде экземпляра
tui-help-enter-local-series = Enter       Открыть экземпляры выбранной локальной серии или выполнить ввод команды / отправить активное модальное окно
tui-help-enter-local-study = Enter       Открыть серии выбранного локального исследования или выполнить ввод команды / отправить активное модальное окно
tui-help-enter-series = Enter       Открыть экземпляры выбранной локальной серии или выполнить ввод команды / отправить активное модальное окно
tui-help-enter-study = Enter       Открыть серии выбранного локального исследования или выполнить ввод команды / отправить активное модальное окно
tui-help-esc-default = Esc         Закрыть справку/модальное окно, вернуться из локальных серий или вернуть фокус в поле команды
tui-help-esc-instance = Esc         Вернуться из локальных экземпляров к сериям, закрыть справку/модальное окно или вернуть фокус в поле команды
tui-help-esc-instances = Esc         Вернуться из локальных экземпляров к сериям, закрыть справку/модальное окно или вернуть фокус в поле команды
tui-help-esc-series = Esc         Вернуться из локальных серий к исследованиям, закрыть справку/модальное окно или вернуть фокус в поле команды
tui-help-f1 = F1 или ?     Открыть справку
tui-help-import-send = i/s         Импорт local files or send selected study/series
tui-help-is = i/s         Импорт local files or send selected study/series
tui-help-listener = Слушатель: { $value }
tui-help-log-dir = Каталог журналов: { $value }
tui-help-m = m           Извлечь из выбранного результата запроса
tui-help-max-pdu = max_pdu_length: { $value }
tui-help-move = Вверх/вниз или j/k   Перемещение выбора в списках
tui-help-nodes = a/e/d/f     Add, edit, delete, or query from the selected узел
tui-help-open = F1 или ?     Открыть справку
tui-help-promiscuous = allow_promiscuous_storage: { $value }
tui-help-q = q           Выход, если нет активного модального окна и фокус не в поле команды
tui-help-quit = q           Выход, если нет активного модального окна и фокус не в поле команды
tui-help-r = r           Обновить panes when focus is нетt in command input
tui-help-receiver-mode = Режим приёмника: { $value }
tui-receiver-mode-on-demand = по запросу для локального retrieve
tui-receiver-mode-standalone = автономно через storage-scp
tui-help-refresh = r           Обновить panes when focus is нетt in command input
tui-help-retrieve = m           Извлечь из выбранного результата запроса
tui-help-strict-pdu = strict_pdu: { $value }
tui-help-tab = Tab / Shift-Tab  Сменить активную панель
tui-help-title = Сочетания клавиш
tui-help-ts-pref = preferred_store_transfer_syntax: { $value }
tui-help-updown = Вверх/вниз или j/k   Перемещение выбора в списках
tui-input-placeholder = Введите команду или используйте сочетания панели.
tui-log-command = > { $command }
tui-log-error = ошибка: { $error }
tui-log-refreshed = обновлено
tui-logs-capped-suffix = ограничено
tui-logs-label = Журналы:
tui-pane-command = Команда
tui-pane-config = Конфигурация
tui-pane-detail = Подробности
tui-pane-detail-hint = { $title } (PgUp/PgDn когда нет ввода)
tui-pane-help = Справка
tui-pane-instance-detail = Сведения об экземпляре
tui-pane-instances-for = Экземпляры: { $uid }
tui-pane-local-studies = Локальные исследования
tui-pane-logs = Журнал ({ $shown }/{ $total }{ $capped })
tui-pane-logs-capped = Журналы ({ $shown }/{ $total } capped)
tui-pane-logs-uncapped = Журналы ({ $shown }/{ $total })
tui-pane-node-detail = Сведения об узле
tui-pane-query-detail = Сведения о результате запроса
tui-pane-query-node = Запрос узла
tui-pane-query-result-detail = Сведения о результате запроса
tui-pane-query-results = Результаты запроса / получения
tui-pane-query-retrieve-results = Результаты запроса / получения
tui-pane-remote-nodes = Удалённые узлы
tui-pane-series-detail = Сведения о серии
tui-pane-series-for = Серии: { $uid }
tui-pane-series-unknown = Серии: <неизвестное исследование>
tui-pane-study-detail = Сведения об исследовании
tui-pane-task-details = Сведения о задаче
tui-pane-tasks-history = Задачи (история)
tui-pane-tasks-queued = Задачи (очередь)
tui-pane-unknown-series = <неизвестная серия>
tui-pane-unknown-study = Серии: <неизвестное исследование>
tui-row-inst = inst
tui-status-cancel-requested = Отменаlation requested
tui-status-config = Конфигурация
tui-status-configured-listener = Настроенный слушатель { $addr } как AE { $ae } ({ $mode })
tui-status-data = данные
tui-status-failure = сбой: { $failure }
tui-status-listener = Слушатель
tui-status-local-ae = Локальный AE
tui-status-mode = Режим
tui-status-mode-on-demand = по запросу
tui-status-mode-standalone = автономный
tui-status-no-active-task = Нет активной задачи to cancel (nothing running)
tui-status-pdu = PDU
tui-status-promiscuous = Неразборчивый
tui-status-query-before-retrieve = Query a удалённый узел first so retrieve knows which узел to use
tui-status-query-failed = сбой запроса: { $error }
tui-status-queued-op = Операция в очереди: { $op }
tui-status-retrieve-failed = сбой извлечения: { $error }
tui-status-retrieve-open-failed = не удалось открыть retrieve stream: { $error }
tui-status-saved-node = saved узел { $name } ({ $id })
tui-status-saved-scp = Параметры Storage SCP сохранены (требуется перезапуск)
tui-status-select-node = сначала выберите удалённый узел
tui-status-select-query = сначала выберите результат запроса
tui-status-select-study = сначала выберите локальное исследование
tui-status-strict = Строгий
tui-status-task-cancelled = Задача отменена
tui-status-task-cancelled-detail = Задача отменена: { $other }
tui-status-ts-pref = Предп. TS
tui-status-updated-node = updated узел { $name } ({ $id })
tui-suggest-back-series = Esc — назад к сериям
tui-suggest-edit-config = c — изменить конфиг
tui-suggest-help = F1/? — справка
tui-suggest-inspect-task = Enter — просмотр задачи
tui-suggest-node-add = node add <ae-title> <host:port>
tui-suggest-query = f — query a узел
tui-suggest-query-node = f — query selected узел
tui-suggest-retrieve = m — извлечь выбранное
tui-suggest-run-command = Enter — выполнить команду
tui-suggest-send-series = s — отправить выбранную серию
tui-suggest-view-series = Enter — просмотр серий
tui-task-cancelled = Отменено
tui-task-cancelling = Отмена
tui-task-failed = Ошибка
tui-task-failed-generic = Сбой задачи: { $error }
tui-task-import-done = Импорт complete: { $report }
tui-task-import-failed = Импорт не выполнен: { $error }
tui-task-importing = Импорт { $path }...
tui-task-query-done =
    Запрос завершён: { $count ->
        [one] { $count } совпадение
        [few] { $count } совпадения
        [many] { $count } совпадений
       *[other] { $count } совпадений
    }
tui-task-query-failed = Запрос не выполнен: { $error }
tui-task-querying = Запрос к { $node }...
tui-task-queued = В очереди
tui-task-retrieve-done = Извлечение завершено: { $outcome }
tui-task-retrieve-failed = Получение не выполнено: { $error }
tui-task-retrieving = Получение с { $node }...
tui-task-running = Выполняется
tui-task-sending-series = Отправка серии { $uid } на { $node }...
tui-task-sending-study = Отправка исследования { $uid } на { $node }...
tui-task-send-done = Отправка завершена: { $outcome }
tui-task-status-cancelled = отменено
tui-task-status-cancelling = отмена
tui-task-status-failed = сбой
tui-task-status-ok = ok
tui-task-status-queued = в очереди
tui-task-status-running = выполняется
tui-task-succeeded = Успешно
tui-terminal-too-small = Терминал слишком мал, увеличьте окно

## Desktop
desktop-action-activity = Активность { $count }
desktop-action-activity-empty = Активность
desktop-action-import = Импорт
desktop-action-inspect-archive = Просмотреть локальный архив
desktop-action-inspect-archive-desc = Просмотрите исследования, серии и инстансы, затем отправьте или экспортируйте.
desktop-action-manage-peers = Управление узлами
desktop-action-manage-peers-desc = Добавляйте и изменяйте узлы PACS и рабочих станций для query, retrieve и store.
desktop-action-monitor-scp = Мониторинг Storage SCP
desktop-action-query = Запрос
desktop-action-refresh = Обновить состояние
desktop-action-refresh-status = Обновить состояние
desktop-action-reveal-log = Показать файл журнала
desktop-action-send = Отправить
desktop-action-start-scp = Запустить Storage SCP
desktop-activity-empty = Пока нет активности сеанса.
desktop-activity-title = Активность
desktop-app-title = DICOM Node
desktop-archive-csv = CSV
desktop-archive-details = Сведения
desktop-archive-empty = Локальный архив пуст.
desktop-archive-export-fail = Экспорт { $scope } не удался
desktop-archive-export-ok =
    { $rows ->
        [one] Экспортирована { $rows } строка { $scope } в { $path }.
       *[other] Экспортировано { $rows } строк { $scope } в { $path }.
    }
desktop-archive-export-studies = Экспорт исследований
desktop-archive-export-title = Экспорт { $scope }
desktop-archive-filter = Фильтр по пациенту, UID, описанию, модальности…
desktop-archive-filter-placeholder = Фильтр по пациенту, UID, описанию, модальности…
desktop-archive-inst-abbrev =
    { $count ->
        [one] { $count } экз.
        [few] { $count } экз.
        [many] { $count } экз.
       *[other] { $count } экз.
    }
desktop-archive-instance-meta = { $bytes } · TS { $ts } · импортировано { $imported }
desktop-archive-instances = Экземпляры
desktop-archive-instances-heading = Экземпляры
desktop-archive-json = JSON
desktop-archive-loading = Загрузка исследований…
desktop-archive-no-filter-match = Нет исследований по фильтру.
desktop-archive-no-instances = Экземпляры не найдены.
desktop-archive-no-match = Нет исследований по фильтру.
desktop-archive-no-nodes = Нет узлов
desktop-archive-no-series = Серии не найдены.
desktop-archive-reveal-file = Показать файл
desktop-archive-select-series = Выберите серию.
desktop-archive-select-study = Выберите исследование.
desktop-archive-send-fail = { $label }: { $sent }/{ $attempted } отправлено, { $failed } сбоев. { $failures }
desktop-archive-send-fail-title = { $label } не удалось
desktop-archive-send-ok = { $label }: отправлено { $sent }/{ $attempted } экземпляров.
desktop-archive-send-series = Отправить серию
desktop-archive-send-series-label = Серия → { $destination }
desktop-archive-send-study = Отправить исследование
desktop-archive-send-study-label = Исследование → { $destination }
desktop-archive-send-to = Отправить на
desktop-archive-series = Серии
desktop-archive-series-count =
    #{ $number } · { $count ->
        [one] { $count } экземпляр
       *[other] { $count } экземпляров
    }
desktop-archive-series-fallback = Серии
desktop-archive-studies = Исследования
desktop-archive-study-date = Дата исследования
desktop-archive-study-uid = Study UID
desktop-archive-subtitle = Инвентарь исследований, серий и экземпляров из локального архива SQLite.
desktop-archive-title = Локальный архив
desktop-brand-title = DICOM Node
desktop-col-description = Описание
desktop-col-instances = Экземпляры
desktop-col-modalities = Модальности
desktop-col-patient-id = ID пациента
desktop-common-cancel = Отмена
desktop-common-clear = Очистить
desktop-common-disabled = выключено
desktop-common-enabled = включено
desktop-common-loading = Загрузка…
desktop-common-no = нет
desktop-common-refresh = Обновить
desktop-common-yes = да
desktop-counter-assoc-accepted = Принятые ассоциации
desktop-counter-bytes-ingested = Принятые байты
desktop-counter-cfind-requests = Запросы C-FIND
desktop-counter-cmove-requests = Запросы C-MOVE
desktop-counter-cstore-failed = C-STORE сбой
desktop-counter-cstore-stored = C-STORE сохранено
desktop-dashboard-counter-assoc-accepted = Принятые ассоциации
desktop-dashboard-counter-bytes-ingested = Принятые байты
desktop-dashboard-counter-c-find-requests = Запросы C-FIND
desktop-dashboard-counter-c-move-requests = Запросы C-MOVE
desktop-dashboard-counter-c-store-failed = C-STORE сбой
desktop-dashboard-counter-c-store-stored = C-STORE сохранено
desktop-dashboard-empty-studies = Локальных исследований пока нет.
desktop-dashboard-inspect-archive-body = Просмотрите исследования, серии и экземпляры, затем отправьте или экспортируйте.
desktop-dashboard-inspect-archive-title = Просмотреть локальный архив
desktop-dashboard-kv-ae-title = Заголовок AE
desktop-dashboard-kv-data-dir = Каталог данных
desktop-dashboard-kv-listener = Слушатель
desktop-dashboard-kv-log-file = Файл журнала
desktop-dashboard-kv-max-pdu = Макс. PDU
desktop-dashboard-kv-promiscuous = Неограниченное хранение
desktop-dashboard-kv-server = Сервер
desktop-dashboard-kv-store-syntax = Синтаксис store
desktop-dashboard-kv-strict-pdu = Строгий PDU
desktop-dashboard-listener-missing = Listener ещё не загружен.
desktop-dashboard-live-counters = Живые счётчики
desktop-dashboard-loading-metrics = Загрузка метрик…
desktop-dashboard-loading-status = Загрузка локального состояния…
desktop-dashboard-loading-studies = Загрузка исследований…
desktop-dashboard-local-node = Локальный узел
desktop-dashboard-manage-peers-body = Добавляйте и правьте узлы PACS или станций для запроса, получения и store.
desktop-dashboard-manage-peers-title = Управление пирами
desktop-dashboard-metric-instances = Экземпляры
desktop-dashboard-metric-nodes = Удалённые узлы
desktop-dashboard-metric-series = Серии
desktop-dashboard-metric-studies = Исследования
desktop-dashboard-monitor-scp = Мониторинг Storage SCP
desktop-dashboard-recent-studies = Недавние исследования
desktop-dashboard-start-scp = Запустить Storage SCP
desktop-dashboard-subtitle = Локальный архив, сетевые пиры и активность SCP одним взглядом.
desktop-dashboard-title = Панель оператора
desktop-doc-title = DICOM Node
desktop-import-accepted = Принято
desktop-import-accepted-bytes = Принятые байты
desktop-import-activity-detail = { $accepted }/{ $scanned } принято, { $duplicates } дубликатов, { $bytes }
desktop-import-activity-fail = Импорт не удался
desktop-import-activity-ok = Импорт завершён
desktop-import-choose-archive = Выберите ZIP-архив для импорта
desktop-import-choose-dir = Выберите каталог для импорта
desktop-import-choose-folder = Папка
desktop-import-choose-zip = Выберите ZIP-архив для импорта
desktop-import-cleanup = Очистка
desktop-import-clear-path = Очистить путь
desktop-import-complete = Импорт завершён
desktop-import-dup-sha = SHA-256
desktop-import-dup-sop = SOP UID
desktop-import-dup-total = Всего
desktop-import-duplicates = Дубликаты
desktop-import-failed = Импорт не удался
desktop-import-failed-cleanup = Очистка не удалась
desktop-import-failures = Сбои
desktop-import-failures-heading =
    { $count ->
        [one] { $count } сбой:
       *[other] { $count } сбоев:
    }
desktop-import-failures-more = … и ещё { $count }
desktop-import-files-progress = { $label } файлов
desktop-import-folder = Папка
desktop-import-invalid-dicom = Некорректный DICOM
desktop-import-pick-dir = Выберите каталог для импорта
desktop-import-pick-zip = Выберите ZIP-архив для импорта
desktop-import-placeholder = /path/to/dicom-folder or /path/to/archive.zip
desktop-import-rejected = Отклонено
desktop-import-report = Отчёт об импорте
desktop-import-running = Импорт…
desktop-import-scanned = Просканировано
desktop-import-skipped = Пропущено
desktop-import-source = Источник
desktop-import-start = Начать импорт
desktop-import-stored = Сохранено
desktop-import-subtitle = Индексируйте файлы DICOM из рекурсивных папок или ZIP в управляемый локальный архив.
desktop-import-title = Импорт
desktop-import-unreadable = Нечитаемо
desktop-import-zip = ZIP
desktop-import-zip-filter = ZIP-архивы
desktop-lang-label = Язык
desktop-listener-not-loaded = Listener ещё не загружен.
desktop-live-counters = Живые счётчики
desktop-loading = Загрузка
desktop-loading-local-status = Загрузка локального состояния…
desktop-loading-metrics = Загрузка метрик…
desktop-loading-studies = Загрузка исследований…
desktop-local-node = Локальный узел
desktop-locale-label = Язык
desktop-logs-activity-detail =
    { $count ->
        [one] { $count } строка загружена
       *[other] { $count } строк загружено
    }
desktop-logs-activity-fail = Не удалось обновить журнал
desktop-logs-activity-ok = Журнал обновлён
desktop-logs-auto = АВТО
desktop-logs-auto-refresh = Автообновление
desktop-logs-empty = Файл журнала пуст.
desktop-logs-found = ФАЙЛ ЖУРНАЛА НАЙДЕН
desktop-logs-lines =
    { $count ->
        [one] { $count } строка
        [few] { $count } строки
        [many] { $count } строк
       *[other] { $count } строк
    }
desktop-logs-loading = Загрузка журнала…
desktop-logs-missing = Активный файл журнала ещё не создан.
desktop-logs-refresh-failed = Не удалось обновить журнал
desktop-logs-refreshed = Журнал обновлён
desktop-logs-reveal = Показать
desktop-logs-subtitle = Ограниченный хвост активного файла журнала рабочего стола.
desktop-logs-tail = Хвост
desktop-logs-title = Журналы
desktop-logs-truncated = ОБРЕЗАНО
desktop-logs-waiting = ОЖИДАНИЕ ФАЙЛА ЖУРНАЛА
desktop-metric-instances = Экземпляры
desktop-metric-remote-nodes = Удалённые узлы
desktop-metric-series = Серии
desktop-metric-studies = Исследования
desktop-nav-archive = Локальный архив
desktop-nav-dashboard = Панель
desktop-nav-import = Импорт
desktop-nav-logs = Журналы
desktop-nav-network = Сеть
desktop-nav-nodes = Удалённые узлы
desktop-nav-query = Запрос / получение
desktop-nav-server = Сервер хранения
desktop-no-local-studies = Локальных исследований пока нет.
desktop-nodes-add = Добавить узел
desktop-nodes-added = Добавлен узел «{ $name }».
desktop-nodes-ae-length = Заголовок AE — не более 16 символов.
desktop-nodes-ae-title = Заголовок AE
desktop-nodes-col-move = Назн. Move
desktop-nodes-configured = Настроенные узлы
desktop-nodes-confirm-delete = Удалить узел «{ $name }»?
desktop-nodes-default-port = Порт по умолчанию 104
desktop-nodes-delete = Удалить узел
desktop-nodes-delete-title = Удалить узел
desktop-nodes-deleted = Удалён узел «{ $name }».
desktop-nodes-edit = Изменить узел
desktop-nodes-edit-title = Изменить узел
desktop-nodes-empty = Удалённых узлов пока нет.
desktop-nodes-err-ae = Требуется AE title.
desktop-nodes-err-ae-len = AE title — не более 16 символов.
desktop-nodes-err-host = Требуется хост.
desktop-nodes-err-name = Требуется имя.
desktop-nodes-err-port = Порт должен быть от 1 до 65535.
desktop-nodes-host = Хост
desktop-nodes-move-dest = Назначение Move
desktop-nodes-move-placeholder = По умолчанию: локальный AE
desktop-nodes-name = Имя
desktop-nodes-need-ae = Заголовок AE обязателен.
desktop-nodes-need-host = Хост обязателен.
desktop-nodes-need-name = Имя обязательно.
desktop-nodes-notes = Заметки
desktop-nodes-notes-placeholder = PACS кабинета описания
desktop-nodes-placeholder-ae = PACS01
desktop-nodes-placeholder-host = 192.168.0.10
desktop-nodes-placeholder-move = По умолчанию: локальный AE
desktop-nodes-placeholder-name = main-pacs
desktop-nodes-placeholder-notes = PACS кабинета описания
desktop-nodes-port = Порт
desktop-nodes-port-104 = Порт по умолчанию 104
desktop-nodes-port-range = Порт должен быть от 1 до 65535.
desktop-nodes-save = Сохранить изменения
desktop-nodes-save-changes = Сохранить изменения
desktop-nodes-subtitle = Пиры PACS и станций для запроса, получения и store.
desktop-nodes-summary = Сводка узлов
desktop-nodes-title = Удалённые узлы
desktop-nodes-total = Всего узлов
desktop-nodes-updated = Обновлён узел «{ $name }».
desktop-nodes-with-move = С назначением Move
desktop-promiscuous = Неограниченное хранение
desktop-query-accession = Accession №
desktop-query-activity-detail = { $count } { $count ->
        [one] совпадение
       *[other] совпадений
    } на уровне { $level }
desktop-query-activity-fail = C-FIND { $node } не удалось
desktop-query-activity-ok = C-FIND { $node }
desktop-query-activity-title = C-FIND { $node }
desktop-query-clear = Очистить
desktop-query-col-accession = номер направления
desktop-query-criteria = Критерии поиска
desktop-query-date-from = Дата исследования с
desktop-query-date-to = Дата исследования по
desktop-query-kv-series-uid = Series UID
desktop-query-kv-sop-uid = SOP UID
desktop-query-kv-study-uid = Study UID
desktop-query-level = Уровень
desktop-query-matches =
    { $count ->
        [one] { $count } совпадение
       *[other] { $count } совпадений
    }
desktop-query-missing-study-uid = У совпадения нет StudyInstanceUID; получить нельзя.
desktop-query-modality = Модальность
desktop-query-no-matches = Нет совпадений.
desktop-query-no-nodes = Узлы не настроены
desktop-query-patient-id = ID пациента
desktop-query-patient-name = Имя пациента
desktop-query-placeholder-description = CHEST*
desktop-query-placeholder-modality = CT, MR, …
desktop-query-placeholder-name = DOE^JOHN or DOE*
desktop-query-placeholder-patient = DOE^JOHN or DOE*
desktop-query-querying = Запрос…
desktop-query-remote-node = Удалённый узел
desktop-query-results = Результаты
desktop-query-retrieve = Получить
desktop-query-retrieve-activity-detail = completed={ $completed }, warning={ $warning }, failed={ $failed }
desktop-query-retrieve-activity-fail = C-MOVE { $node } не удалось
desktop-query-retrieve-activity-ok = C-MOVE { $node }
desktop-query-retrieve-finished = Получение завершено: выполнено { $completed }, предупреждений { $warning }, сбоев { $failed }.
desktop-query-retrieve-selected = Получить выбранное
desktop-query-run = Выполнить C-FIND
desktop-query-run-select = Выполните запрос и выберите совпадение.
desktop-query-running = Запрос…
desktop-query-search-criteria = Критерии поиска
desktop-query-select-hint = Выполните запрос и выберите совпадение.
desktop-query-selected = Выбранное совпадение
desktop-query-selected-match = Выбранное совпадение
desktop-query-series-uid = Series Instance UID
desktop-query-sop-uid = SOP Instance UID
desktop-query-study-description = Описание исследования
desktop-query-study-uid = Study Instance UID
desktop-query-subtitle = C-FIND к удалённому узлу, просмотр совпадений, затем C-MOVE в локальный архив.
desktop-query-title = Запрос / получение
desktop-recent-studies = Недавние исследования
desktop-scp-listening = SCP слушает
desktop-scp-stopped = SCP остановлен
desktop-server-activity-fail = Ошибка управления Storage SCP
desktop-server-activity-started = Storage SCP запущен
desktop-server-activity-started-detail = Listener запущен.
desktop-server-activity-stopped = Storage SCP остановлен
desktop-server-activity-stopped-detail = received={ $received }, stored={ $stored }, failed={ $failed }
desktop-server-activity-stopped-empty = Нет активного сеанса.
desktop-server-addr-ae = { $addr } · AE { $ae }
desktop-server-assoc-accepted = Принятые ассоциации
desktop-server-assoc-rejected = Отклонённые ассоциации
desktop-server-cfind-req-matches = Запросы / совпадения C-FIND
desktop-server-cget-requests = Запросы C-GET
desktop-server-cmove-requests = Запросы C-MOVE
desktop-server-cmove-subops = Подоперации C-MOVE завершены / сбой
desktop-server-control-failed = Ошибка управления Storage SCP
desktop-server-counter-bytes = Принятые байты
desktop-server-counter-failed = C-STORE сбой
desktop-server-counter-find = Запросы / совпадения C-FIND
desktop-server-counter-get = Запросы C-GET
desktop-server-counter-move = Запросы C-MOVE
desktop-server-counter-move-sub = Подоперации C-MOVE завершены / сбой
desktop-server-counter-received = C-STORE получено
desktop-server-counter-stored = C-STORE сохранено
desktop-server-cstore-failed = C-STORE сбой
desktop-server-cstore-received = C-STORE получено
desktop-server-cstore-stored = C-STORE сохранено
desktop-server-dimse = Счётчики DIMSE
desktop-server-failed = Сбои
desktop-server-health-loading = Загрузка метрик
desktop-server-health-ready = Готов к входящему C-STORE
desktop-server-health-review = Проверить сбои
desktop-server-health-stopped = Остановлен
desktop-server-listener-started = Listener запущен.
desktop-server-listening = СЛУШАЕТ
desktop-server-loading-metrics = Загрузка метрик…
desktop-server-logs = Журналы
desktop-server-no-session = Нет активного сеанса.
desktop-server-rate = +{ $rate } / опрос
desktop-server-ready = Готов к входящему C-STORE
desktop-server-review-failures = Проверить сбои
desktop-server-session-ended = Сеанс завершён: получено { $received }, сохранено { $stored }, сбоев { $failed }.
desktop-server-start = Запустить сервер
desktop-server-started-title = Storage SCP запущен
desktop-server-stop = Остановить сервер
desktop-server-stopped = ОСТАНОВЛЕН
desktop-server-stopped-pill = ОСТАНОВЛЕН
desktop-server-stopped-status = Остановлен
desktop-server-stopped-title = Storage SCP остановлен
desktop-server-stored = Сохранено
desktop-server-subtitle = Автономный Storage SCP для входящего C-STORE и индексации локального архива.
desktop-server-title = Сервер хранения
desktop-status-listening = слушает
desktop-status-loading = Загрузка
desktop-status-scp-listening = SCP слушает
desktop-status-scp-stopped = SCP остановлен
desktop-status-stopped = остановлен
desktop-store-syntax = Синтаксис store
desktop-strict-pdu = Строгий PDU
desktop-strip-pdu = PDU { $value }
desktop-table-accession = Номер обращения
desktop-table-ae-title = AE title
desktop-table-date = Дата
desktop-table-description = Описание
desktop-table-endpoint = Конечная точка
desktop-table-instances = Экземпляры
desktop-table-modalities = Модальности
desktop-table-modality = Модальность
desktop-table-move-dest = Назн. Move
desktop-table-name = Имя
desktop-table-notes = Заметки
desktop-table-patient = Пациент
desktop-table-patient-id = ID пациента
desktop-table-series = Серии
desktop-table-updated = Обновлено
desktop-title-refresh-status = Обновить состояние
desktop-title-reveal-log = Показать файл журнала
ae = AE
patient-name =
    "DOE^JOHN"
    Нажмите 'm' на выбранном результате, чтобы открыть retrieve.
port = Порт

## Summary
summary-ae = AE
summary-counts = Счётчики
summary-criteria = Критерии
summary-duration = Длительность
summary-duration-ms = { $ms }ms
summary-failures = Сбои:
summary-kind = Тип
summary-logs = Журналы:
summary-peer = Узел
summary-status = Статус
summary-title = Сводка операции
tui-detail-created = Создано

tui-form-hint-port-range = подсказка: число от 1 до 65535, напр. 104
tui-form-hint-promiscuous = подсказка: разрешить хранение от любого вызывающего AE title
tui-form-hint-strict-pdu = подсказка: проверять размер PDU во время ассоциаций
tui-form-hint-max-pdu-bytes = подсказка: байты, напр. 16384
tui-form-limits-heading = Limits (bytes; blank/нет = unlimited):
tui-form-field-max-file-import = Макс. байт импорта файла
tui-form-field-max-zip-entry = Макс. байт записи ZIP
tui-form-field-max-zip-total = Макс. всего байт ZIP
tui-form-field-max-zip-count = Макс. число записей ZIP
tui-form-field-max-store-object = Макс. байт объекта store
tui-form-unlimited = без ограничений
tui-form-err-max-pdu-required = ! макс. длина PDU обязательна
tui-form-err-max-pdu-gt-zero = ! макс. длина PDU должна быть целым числом больше 0
tui-form-err-limit-gt-zero = ! { $label } должно быть целым числом больше 0
tui-form-controls-scp = Вводите для правки. Пробел переключает флажки. Tab/Shift-Tab или Вверх/Вниз — поля. Enter сохраняет. Esc отменяет.
tui-form-submit-uid-required = UID обязателен
tui-form-submit-dest-required = destination узел is required
tui-form-submit-nonneg-int = { $label } должно быть неотрицательным целым
tui-form-submit-gt-zero = { $label } должно быть больше 0
tui-form-submit-local-ae-required = локальный AE title обязателен
tui-form-submit-local-ae-invalid = локальный AE title некорректен: { $err }
tui-form-submit-bind-required = адрес привязки обязателен
tui-form-submit-port-required = порт обязателен
tui-form-submit-max-pdu-required = макс. длина PDU обязательна
tui-form-submit-max-pdu-int = макс. длина PDU должна быть целым числом
tui-form-submit-max-pdu-gt-zero = макс. длина PDU должна быть больше 0
tui-form-submit-patient-retrieve = извлечение на уровне пациента не поддерживается
tui-form-submit-no-study-uid = выбранный результат не содержит study UID
tui-form-submit-date-format = ожидается YYYYMMDD
tui-form-submit-modality-len = модальность — не более 16 символов
tui-form-submit-modality-chars = модальность должна быть A-Z или 0-9
tui-form-submit-name-required = имя узла обязательно
tui-form-submit-ae-required = AE title обязателен
tui-form-submit-host-required = узел обязателен
tui-form-submit-move-dest-invalid = AE title назначения перемещения некорректен: { $err }
tui-form-submit-dates-both = дата с и дата по должны быть заданы обе, либо ни одна
tui-form-submit-date-from-invalid = дата с некорректна: { $err }
tui-form-submit-date-to-invalid = дата по некорректна: { $err }
tui-form-submit-date-order = дата с должна быть не позже даты по
tui-form-submit-study-uid-series-query = study UID обязателен для запросов на уровне серии
tui-form-submit-study-uid-image-query = study UID обязателен для запросов на уровне изображения
tui-form-submit-series-uid-image-query = series UID обязателен для запросов на уровне изображения
tui-form-submit-study-uid-required = study UID обязателен
tui-form-submit-study-uid-invalid = study UID некорректен: { $err }
tui-form-submit-series-uid-series-retrieve = series UID обязателен для извлечения на уровне серии
tui-form-submit-series-uid-image-retrieve = series UID обязателен для извлечения на уровне изображения
tui-form-submit-instance-uid-image-retrieve = instance UID обязателен для извлечения на уровне изображения
tui-form-submit-series-uid-invalid = series UID некорректен: { $err }
tui-form-submit-instance-uid-invalid = instance UID некорректен: { $err }
tui-form-submit-import-path-required = путь импорта обязателен
tui-form-submit-import-path-type = путь импорта должен быть файлом или каталогом: { $path }
tui-form-submit-import-access = доступ к пути импорта { $path }
tui-form-submit-import-open = открытие файла импорта { $path }
tui-form-submit-import-read-dir = чтение каталога импорта { $path }
tui-log-welcome = Press F1 or ? for help. Focus Удалённый узелs and press 'a' to add one.
tui-log-logging-to = Журнал: { $path }
tui-command-help-heading = команды:
tui-command-help-next-1 = примечание: в подвале показаны контекстные подсказки 'Next:' в зависимости от активной панели и выбора.
tui-command-help-next-2 = Это только подсказки; вы всегда можете ввести любую команду.
tui-command-help-canonical = примечание: канонические имена совпадают с флагами CLI без '--', через подчёркивания.
tui-command-help-cancel = cancel (псевдоним: stop)
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
tui-command-help-refresh = обновить
tui-command-help-quit = выход
tui-inspect-task = Задача #{ $id }
tui-inspect-status = Состояние: { $status }
tui-inspect-description = Описание: { $description }
tui-inspect-progress = Прогресс: { $progress }
tui-inspect-summary = Сводка:
tui-inspect-no-logs = (нет журналов)
tui-field-sop-class-uid = SOP Class UID
tui-field-transfer-syntax-uid = Transfer Syntax UID
tui-field-sha256 = SHA-256
tui-status-removed-nodes =
    удалено { $count ->
        [one] { $count } узел
        [few] { $count } узла
        [many] { $count } узлов
       *[other] { $count } узлов
    }
tui-status-removed-nodes-target =
    удалено { $count ->
        [one] { $count } узел
        [few] { $count } узла
        [many] { $count } узлов
       *[other] { $count } узлов
    }; последняя цель { $name }
tui-status-more-failures =
    и { $n ->
        [one] { $n } пропущенный сбой
        [few] { $n } пропущенных сбоя
        [many] { $n } пропущенных сбоев
       *[other] { $n } пропущенных сбоев
    }
tui-status-retrieve-ok = retrieve status=0x{ $status } completed={ $completed } failed={ $failed } warning={ $warning } remaining={ $remaining }
tui-status-import-counts = scanned={ $scanned } accepted={ $accepted } duplicates={ $duplicates } unreadable={ $unreadable } invalid_dicom={ $invalid } rejected_total={ $rejected } stored_bytes={ $bytes }
tui-status-send-ok = send attempted={ $attempted } sent={ $sent } failed={ $failed }
tui-log-query-start = Запуск запроса к { $node }
tui-log-retrieve-start = Запуск извлечения из { $node }
tui-log-import-start = Запуск импорта { $path }
tui-log-send-study-start = Запуск отправки исследования { $uid } на { $node }
tui-log-send-series-start = Запуск отправки серии { $uid } на { $node }
tui-log-cancelled-before-start = отменено до запуска
tui-log-cancelled = отменено
error-unknown-command = неизвестная команда: { $command }
error-node-subcommand-required = требуется подкоманда node
error-local-subcommand-required = требуется подкоманда local
error-unsupported-node-subcommand = unsupported узел subcommand: { $command }
error-unsupported-local-subcommand = неподдерживаемая подкоманда local: { $command }
error-expected-kv = ожидался аргумент key=value, получено { $arg }
error-missing-required-arg = отсутствует обязательный аргумент: { $key }
error-missing-required-arg-one-of = отсутствует обязательный аргумент: один из { $keys }
error-parsing-command = разбор команды
error-edit-form-lost-target = edit form lost its target узел
error-task-already-running = фоновая задача уже выполняется
error-task-thread-launch = не удалось запустить поток фоновой задачи: { $error }
error-task-disconnected = поток фоновой задачи отключился до отправки результата
error-task-kind-missing = поток фоновой задачи отключился, но active_task_kind был None: неожиданное состояние
error-serve-exited = serve завершился с ошибкой: { $error }
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
summary-title = Сводка операции
summary-kind = Тип
summary-status = Статус
summary-duration = Длительность
summary-duration-ms = { $ms }ms
summary-peer = Узел
summary-ae = AE
summary-criteria = Критерии
summary-counts = Счётчики
summary-failures = Сбои:
summary-logs = Журналы:
summary-unserializable = <не сериализуется>
summary-log-lines = строки { $start }-{ $end }
