# Fluent catalog (es-ES). Message IDs are hyphenated identifiers
# (cli-about, tui-pane-remote-nodes, desktop-nav-dashboard, error-import-file-too-large).
# Dotted names are Fluent attributes (message + .attr), not message IDs.
# Do not translate DICOM tokens (C-FIND, C-MOVE, C-STORE, SOP, AE, UID) or JSON/CSV machine keys.


## CLI
cli-about = Cliente DICOM de terminal construido con dicom-rs
cli-arg-accession-number = Filtrar por número de acceso (subcadena, sin distinguir mayúsculas).
cli-arg-ae-title = Application Entity title
cli-arg-destination-node = Nombre o id del nodo de destino
cli-arg-duplicate = Filtrar por estado de duplicado.
cli-arg-export = Exportar resultados como JSON o CSV.
cli-arg-host = Nombre de host o IP
cli-arg-imported-at =
    Filtrar por marca de importación. Admite VALUE, START..END, ..END, START...
        Comparación lexicográfica (formato recomendado: RFC3339).
cli-arg-json = Emitir un resumen final de la operación en JSON (esquema estable).
cli-arg-level = Nivel de consulta/recuperación
cli-arg-metrics-json = Al salir, imprimir la instantánea de métricas en memoria como JSON.
cli-arg-modality = Filtrar por modalidad. Lista separada por comas (p. ej. CT,MR).
cli-arg-model = Modelo de información de consulta/recuperación
cli-arg-move-destination = Título AE de destino C-MOVE preferido
cli-arg-name = Nombre visible del nodo
cli-arg-node = Nombre o id del nodo guardado
cli-arg-notes = Notas de texto libre
cli-arg-out = Ruta del fichero de salida. Si se omite, escribe en stdout.
cli-arg-path = Fichero o directorio a importar
cli-arg-patient-id = Filtrar por ID de paciente (subcadena, sin distinguir mayúsculas).
cli-arg-patient-name = Filtrar por nombre de paciente (subcadena, sin distinguir mayúsculas).
cli-arg-port = Puerto
cli-arg-series-description = Filtrar por descripción de la serie (subcadena, sin distinguir mayúsculas).
cli-arg-series-instance-uid = Series Instance UID
cli-arg-sop-instance-uid = SOP Instance UID
cli-arg-source-path = Filtrar por ruta de origen (subcadena, sin distinguir mayúsculas).
cli-arg-study-date =
    Filtrar por fecha de estudio. Admite VALUE, START..END, ..END, START...
        Las fechas se comparan lexicográficamente (formato recomendado: YYYYMMDD).
cli-arg-study-date-from = Límite inferior de fecha de estudio (YYYYMMDD)
cli-arg-study-date-to = Límite superior de fecha de estudio (YYYYMMDD)
cli-arg-study-description = Filtrar por descripción del estudio (subcadena, sin distinguir mayúsculas).
cli-arg-study-instance-uid = Study Instance UID
cli-cmd-import-about = Importar ficheros DICOM desde una ruta
cli-cmd-local-about = Inspeccionar el archivo local
cli-cmd-local-series-about = Listar series indexadas de un estudio
cli-cmd-local-studies-about = Listar estudios locales indexados
cli-cmd-node-about = Gestionar nodos DICOM remotos guardados
cli-cmd-node-add-about = Añadir un nodo remoto
cli-cmd-node-delete-about = Eliminar un nodo guardado
cli-cmd-node-edit-about = Editar un nodo guardado
cli-cmd-node-list-about = Listar nodos guardados
cli-cmd-query-about = Consultar un nodo remoto (C-FIND)
cli-cmd-retrieve-about = Recuperar desde un nodo remoto (C-MOVE)
cli-cmd-send-about = Enviar estudios o series locales (C-STORE)
cli-cmd-send-series-about = Enviar una serie a un nodo de destino
cli-cmd-send-study-about = Enviar un estudio a un nodo de destino
cli-cmd-serve-about = Ejecutar el servidor DICOM
cli-cmd-storage-scp-about = Ejecutar un listener Storage SCP
cli-cmd-tui-about = Abrir la interfaz de terminal interactiva
cli-flag-help = Mostrar ayuda
cli-flag-lang = Idioma de la interfaz (etiqueta BCP-47). Anula DICOM_NODE_LANG, el locale persistido y el locale del sistema.
cli-flag-version = Mostrar versión
cli-heading-arguments = Argumentos:
cli-heading-commands = Comandos:
cli-heading-options = Opciones:
cli-heading-usage = Uso:
cli-import-accepted = accepted={ $n }
cli-import-complete = Importación completada
cli-import-duplicates = duplicates={ $n }
cli-import-scanned = scanned={ $n }
cli-msg-cancel-sigint = Cancelación solicitada (SIGINT). Esperando un apagado ordenado...
cli-msg-failures = fallos:
cli-msg-import-failed = Importación fallida: { $error }
cli-msg-no-local-series = No hay series indexadas para el estudio { $uid }
cli-msg-no-local-studies = No hay estudios locales indexados
cli-msg-no-saved-nodes = No hay nodos guardados
cli-msg-query-failed = Consulta fallida: { $error }
cli-msg-removed-nodes =
    Eliminado { $count ->
        [one] { $count } nodo
       *[other] { $count } nodos
    }
cli-msg-results-count =
    Resultados: { $count ->
        [one] { $count } coincidencia
       *[other] { $count } coincidencias
    }
cli-msg-retrieve-failed = Recuperación fallida: { $error }
cli-msg-saved-node = Nodo guardado { $name } [{ $id }] => { $ae }@{ $host }:{ $port }
cli-msg-send-failed = Envío fallido: { $error }
cli-msg-showing-failures = (mostrando los { $shown } primeros de { $total } fallos)
cli-msg-starting-server =
    Iniciando servidor DICOM con { $count ->
        [one] { $count } AE local
       *[other] { $count } AE locales
    }: { $aes }
cli-msg-starting-server-no-aes = Iniciando el servidor DICOM sin AEs locales configurados
cli-msg-starting-storage-scp = Iniciando Storage SCP en { $addr } con título AE { $ae }
cli-msg-updated-node = Nodo actualizado { $name } [{ $id }] => { $ae }@{ $host }:{ $port }
cli-send-attempted = attempted={ $n }
cli-send-failed-count = failed={ $n }
cli-send-sent = sent={ $n }
cli-value-name-file = FILE
cli-value-name-format = FORMAT
cli-value-name-locale = LOCALE
cli-value-name-path = PATH
tui-detail-more-series =
    ... { $n ->
        [one] { $n } serie más
       *[other] { $n } series más
    }
tui-row-instance-count =
    { $n ->
        [one] { $n } instancia
       *[other] { $n } instancias
    }
tui-row-study-counts = { $series }s/{ $instances }i
count-nodes =
    { $n ->
        [one] { $n } nodo
       *[other] { $n } nodos
    }
count-instances =
    { $n ->
        [one] { $n } instancia
       *[other] { $n } instancias
    }
count-series =
    { $n ->
        [one] { $n } serie
       *[other] { $n } series
    }
count-studies =
    { $n ->
        [one] { $n } estudio
       *[other] { $n } estudios
    }
format-datetime = { $date } { $time }
format-date = { $day }/{ $month }/{ $year }

## Common
common-accession = Acceso
common-add = Añadir
common-back = Atrás
common-bytes = bytes
common-cancel = Cancelar
common-clear = Borrar
common-close = Cerrar
common-date = Fecha
common-delete = Eliminar nodo
common-description = Descripción
common-disabled = deshabilitado
common-duplicates = Duplicados
common-edit = Editar
common-enabled = habilitado
common-error = error
common-filter = Filtro
common-host = host
common-import = Importar
common-instance = Instancia
common-language = Idioma
common-loading = Cargando
common-matches = Coincidencias
common-modality = Modalidad
common-name = Nombre
common-network = Red
common-no = No
common-none = ninguno
common-notes = Notas
common-optional = opcional
common-path = Origen
common-patient = Paciente
common-patient-id = ID de paciente
common-patient-name = Nombre del paciente
common-port = Puerto
common-query = Consultar
common-refresh = Actualizar
common-required = obligatorio
common-retrieve = Recuperar
common-save = Guardar
common-search = Buscar
common-send = Enviar
common-series = series
common-start = Iniciar
common-status = Estado
common-stop = Detener
common-studies = Estudios
common-study = Estudio
common-unknown = desconocido
common-unknown-series = <Series>
common-unknown-study = <Estudios>
common-yes = sí

## Errors
error-ae-empty = el AE title no puede estar vacío
error-ae-invalid-char = el AE title contiene el carácter no válido '{ $character }'; permitidos: A-Z, 0-9, espacio
error-ae-required = El título AE es obligatorio
error-ae-too-long = el AE title debe tener como máximo 16 caracteres
error-ae-whitespace = el AE title no puede tener espacios al inicio o al final
error-archive-patient-retrieve-out-of-scope = el retrieve de nivel Patient está fuera de alcance
error-archive-retrieve-uid-required = { $name } es obligatorio para este nivel de retrieve
error-archive-study-root-patient-query = las consultas Study Root no admiten el nivel Patient
error-archive-study-root-patient-retrieve = el retrieve Study Root no admite el nivel Patient
error-assoc-negotiation-failed = falló la negociación de association con { $name } ({ $addr }); pista: compruebe called AE title, presentation contexts/transfer syntaxes y que el peer acepta associations
error-assoc-no-addresses = no se resolvieron direcciones de socket para { $name } en { $host }:{ $port }
error-assoc-receive = recepción de association
error-assoc-resolving = resolviendo { $name } en { $host }:{ $port }: { $err }
error-assoc-timeout = tiempo de espera agotado esperando la respuesta DIMSE; pista: compruebe la red, AE title/host/puerto y la respuesta del peer
error-assoc-transport = interrupción de transporte al esperar la respuesta DIMSE; pista: el peer cerró la conexión o un equipo de red la reinició
error-assoc-unreachable = no se pudo alcanzar { $name } [{ $ae }] en { $host }:{ $port } en { $seconds }s: { $err }. Compruebe host/IP, puerto y alcance de red
error-cancel-sigint = Cancelación solicitada (SIGINT). Esperando un apagado ordenado...
error-config-must-be-positive = configuración no válida: { $name } debe ser > 0 (o null para desactivar)
error-config-duplicate-bind-port = configuración no válida: puerto de bind duplicado de AE local { $port }
error-config-local-ae-max-assoc = configuración no válida: AE local { $title } max_concurrent_associations debe ser > 0
error-config-local-ae-no-services = configuración no válida: AE local { $title } debe habilitar al menos un servicio
error-config-must-be-positive-required = configuración no válida: { $name } debe ser > 0
error-dicom-meta-incomplete = el file meta DICOM está incompleto
error-dicom-patient-move-unsupported = C-MOVE a nivel de paciente no está admitido por este andamiaje de cliente
error-dicom-required-attribute = falta el atributo DICOM obligatorio: ({ $group },{ $element })
error-dicom-series-uid-required-image = series_instance_uid es obligatorio para retrieve a nivel de imagen
error-dicom-series-uid-required-series = series_instance_uid es obligatorio para retrieve a nivel de serie
error-dicom-sop-uid-required-image = sop_instance_uid es obligatorio para retrieve a nivel de imagen
error-dicom-study-uid-required = study_instance_uid es obligatorio
error-dicom-validating-move = validando la solicitud de move
error-export-creating-file = creando el fichero de exportación { $path }: { $err }
error-export-flushing-series-csv = volcando el CSV de series: { $err }
error-export-flushing-studies-csv = volcando el CSV de estudios: { $err }
error-export-serializing-series-json = serializando JSON de series: { $err }
error-export-serializing-studies-json = serializando JSON de estudios: { $err }
error-export-writing-series-csv-header = escribiendo la cabecera CSV de series: { $err }
error-export-writing-series-csv-row = escribiendo la fila CSV de series: { $err }
error-export-writing-studies-csv-header = escribiendo la cabecera CSV de estudios: { $err }
error-export-writing-studies-csv-row = escribiendo la fila CSV de estudios: { $err }
error-import-cleanup-failed = { $source }: fallo al limpiar: { $reason }
error-import-corrupt-zip = ZIP corrupto: { $details }
error-import-dicom-parse-failed = fallo al analizar DICOM: { $err }
error-import-dicom-validation-failed = fallo en la validación DICOM: { $err }
error-import-duplicate-zip-path = el ZIP contiene varias entradas que apuntan a '{ $path }'
error-import-file-too-large = fichero demasiado grande: { $details }
error-import-invalid-dicom = DICOM no válido: { $details }
error-import-limit-exceeded = { $limit } superado: { $details }
error-import-not-regular-file = no es un fichero regular
error-import-opening-file = abriendo el fichero: { $err }
error-import-opening-kind = abriendo { $kind } { $path }
error-import-opening-staged-file = abriendo el fichero en staging: { $err }
error-import-opening-zip-archive = abriendo el archivo ZIP { $path }
error-import-opening-zip-entry = abriendo la entrada ZIP: { $err }
error-import-opening-zip-file = abriendo el fichero ZIP de importación { $path }
error-import-path-does-not-exist = La ruta de importación no existe: { $path }
error-import-reading-directory = leyendo el directorio de importación { $path }
error-import-reading-file = leyendo el fichero: { $err }
error-import-reading-file-metadata = leyendo metadatos del fichero { $path }
error-import-reading-metadata = leyendo metadatos de { $kind } { $path }
error-import-reading-zip-entry = leyendo la entrada ZIP: { $err }
error-import-removing-staged-after-cancel = eliminando el fichero en staging tras la cancelación { $path }
error-import-skipped = { $source }: omitido: { $reason }
error-import-unreadable = Fichero ilegible: { $details }
error-import-unsafe-zip-path = la ruta de la entrada sale del archivo
error-import-zip-entry-count-exceeded = límite de entradas ZIP superado: el archivo tiene { $count } entradas, el límite es { $limit }
error-import-zip-entry-size-exceeded = el tamaño de la entrada ZIP { $size } supera el límite { $limit }
error-import-zip-total-bytes-exceeded = límite de bytes extraídos del ZIP superado: el total actual { $current } más el tamaño de la entrada { $entry } supera el límite { $limit }
error-net-binding-storage-scp = enlazando el Storage SCP en { $addr } para el AE { $ae }. Es posible que otro receptor DICOM local ya use ese puerto. Actualice storage_scp_port/local_aes en { $config } o detenga el listener en conflicto
error-net-building-file-meta = construyendo la tabla de file meta
error-net-cannot-send-transfer-syntax = no se puede enviar la transfer syntax de origen { $source } con la transfer syntax negociada { $negotiated }
error-net-cget-dataset-empty = el dataset C-GET C-STORE codificado está vacío
error-net-cget-dataset-odd-length = el dataset C-GET C-STORE codificado terminó con un fragmento final de longitud impar
error-net-cget-peer-released = el peer liberó la association durante C-GET
error-net-cget-store-unexpected-dataset = fragmento de dataset inesperado en la respuesta C-GET C-STORE
error-net-cget-unexpected-command = comando inesperado 0x{ $command } mientras se espera C-STORE-RSP
error-net-cget-unexpected-pdu = PDU inesperado durante la suboperación C-GET C-STORE: { $pdu }
error-net-creating-incoming-dir = creando el directorio .incoming del Storage SCP
error-net-creating-path = creando { $path }
error-net-dataset-empty = el dataset codificado está vacío, pero COMMAND_DATA_SET_TYPE indica que se requiere un dataset
error-net-dataset-odd-length = el dataset codificado terminó con un fragmento final de longitud impar
error-net-dimse-failed = { $operation } falló con status 0x{ $status } ({ $meaning }){ $hint }
error-net-establishing-assoc = estableciendo la association del Storage SCP
error-net-file-meta-length = leyendo la longitud de File Meta Information
error-net-file-meta-tag = leyendo la etiqueta de File Meta Information
error-net-file-meta-value = omitendo el valor de File Meta Information
error-net-file-meta-vr = leyendo el VR de File Meta Information
error-net-file-position = leyendo la posición del archivo
error-net-flushing-path = volcando { $path }
error-net-flushing-temp-dataset = volcando el archivo temporal de dataset
error-net-hint-suffix = ; pista: { $hint }
error-net-incomplete-command = incompleto { $operation } respuesta de comando
error-net-incomplete-identifier = incompleto { $operation } identificador de respuesta
error-net-invalid-affected-sop = inválido { $operation } affected SOP class UID
error-net-invalid-status = inválido { $operation } status
error-net-listener-address = leyendo la dirección del listener del Storage SCP
error-net-listener-nonblocking = poniendo el listener en modo nonblocking
error-net-listener-port = leyendo el puerto del listener del Storage SCP
error-net-local-aes-empty = local_aes debe contener al menos un AE para iniciar el Storage SCP
error-net-locating-dataset = localizando el dataset en { $path }
error-net-malformed-dimse = malformada { $operation } respuesta DIMSE: { $details }; pista: el peer envió un command set DIMSE inválido o inesperado
error-net-missing-affected-sop = falta { $operation } affected SOP class UID
error-net-missing-command-field = falta el campo de comando
error-net-missing-cstore-rsp-command-field = falta el campo de comando de la respuesta C-STORE
error-net-missing-cstore-rsp-status = falta el status de la respuesta C-STORE
error-net-missing-destination = falta el destino C-MOVE
error-net-missing-dicm = falta el marcador DICM Part 10
error-net-missing-message-id = falta { $operation } message id
error-net-missing-qr-level = { $operation } identificador no tiene QueryRetrieveLevel
error-net-missing-required-command-field = falta el campo de comando obligatorio { $name } ({ $tag })
error-net-missing-status = falta { $operation } status
error-net-move-destination-unresolved = move_destination no se resolvió
error-net-no-cget-store-context = no hay presentation context de almacenamiento C-GET negociado para SOP Class { $sop } y transfer syntax { $syntax }
error-net-no-compatible-context = { $path }: no hay presentation context negociado compatible para la transfer syntax de origen { $syntax }
error-net-no-dimse-provider = no hay proveedor DIMSE registrado para el comando 0x{ $command } y abstract syntax { $syntax }
error-net-no-presentation-context = no hay presentation context negociado
error-net-no-presentation-context-for-file = { $path }: no hay presentation context negociado
error-net-no-presentation-context-id = falta el presentation context negociado { $id }
error-net-opening-path = abriendo { $path }
error-net-part10-preamble = leyendo el preámbulo Part 10
error-net-path-error = { $path }: { $err }
error-net-pdata-feed-complete = no se puede alimentar un fragmento P-DATA a un acumulador completo (falta take())
error-net-peer-aborted = el peer abortó la association durante la suboperación C-GET C-STORE: { $source }
error-net-peer-socket = leyendo la dirección de socket del peer del Storage SCP
error-net-reading-command-dataset = leyendo el dataset de comando
error-net-reading-identifier = leyendo { $operation } identifier
error-net-reading-incoming-dataset = leyendo el dataset C-STORE de entrada
error-net-reading-response-dataset = leyendo { $operation } response dataset
error-net-remote-aborted = el remoto abortó la association: { $source }
error-net-restoring-read-timeout = restaurando el timeout de lectura de la association
error-net-restoring-write-timeout = restaurando el timeout de escritura de la association
error-net-rewinding-dataset = retrocediendo al primer elemento del dataset
error-net-scp-thread-panicked = el hilo del Storage SCP entró en pánico
error-net-seeking-temp-dataset = posicionando el archivo temporal de dataset
error-net-serializing-cget-dataset = serializando el dataset de la suboperación C-GET para { $path }
error-net-serializing-dataset = serializando el dataset para { $path } con transfer syntax { $syntax }
error-net-setting-socket-blocking = poniendo el socket de almacenamiento aceptado en modo blocking
error-net-sending-buffered-dataset = enviando el dataset en búfer para { $path }
error-net-store-status = el remoto devolvió status C-STORE 0x{ $status } ({ $meaning }){ $hint }
error-net-streaming-dataset = transmitiendo el dataset C-STORE
error-net-unexpected-command-field = CommandField inesperado 0x{ $actual } (se esperaba 0x{ $expected } for { $rsp })
error-net-unexpected-dataset-fragment = fragmento de dataset inesperado en la respuesta C-STORE
error-net-unexpected-pdu = PDU inesperado durante { $operation }: { $pdu }
error-net-unknown-status = desconocido o inválido { $operation } status 0x{ $status }
error-net-unsupported-model-sop = no admitido { $operation } model SOP class UID: { $uid }
error-net-unsupported-qr-level = QueryRetrieveLevel no admitido: { $level }
error-net-unsupported-transfer-syntax = transfer syntax negociada no admitida
error-net-writing-command-dataset = escribiendo el dataset de comando
error-net-writing-identifier = escribiendo { $operation } identifier
error-net-writing-path = escribiendo { $path }
error-net-writing-response-dataset = escribiendo { $operation } response dataset
error-net-writing-temp-dataset = escribiendo bytes del dataset en el archivo temporal
error-node-host-empty = el host del nodo no puede estar vacío
error-node-name-empty = el nombre del nodo no puede estar vacío
error-node-not-found = nodo remoto no encontrado: { $id }
error-operation-cancelled = operación cancelada
error-port-invalid = puerto no válido: { $value }
error-port-range = el puerto debe estar entre 1 y 65535
error-query-no-study-uid = La coincidencia no tiene StudyInstanceUID; no se puede recuperar.
error-query-unsupported-level = nivel de consulta no admitido: { $value }
error-query-unsupported-model = modelo de consulta no admitido: { $value }
error-retrieve-canceled = el retrieve fue cancelado por el nodo remoto (status=0x{ $status }, completed={ $completed }, failed={ $failed }, warning={ $warning }, remaining={ $remaining }, { $scp })
error-retrieve-failed = el retrieve falló con status=0x{ $status } (completed={ $completed }, failed={ $failed }, warning={ $warning }, remaining={ $remaining }, { $scp })
error-retrieve-nothing-arrived = el retrieve terminó para el destino { $destination } con completed={ $completed } pero no llegó nada al Storage SCP local ({ $scp }). Compruebe el mapeo de AE o el puerto: asegúrese de que { $listener } está libre y de que el nodo remoto asigna el AE { $destination } a esta aplicación
error-send-no-files-series = no hay ficheros locales indexados para la serie { $uid }
error-send-no-files-study = no hay ficheros locales indexados para el estudio { $uid }
error-task-cancelled = Tarea cancelada
error-task-none-to-cancel = No hay ninguna tarea activa que cancelar (nada está en curso)
error-tracing-init = inicializando el subscriber de tracing: { $err }
error-uid-component-numeric = El componente de UID «{ $part }» debe ser numérico
error-uid-component-too-long = El componente de UID «{ $part }» es demasiado largo
error-uid-dot-ends = El UID no puede empezar ni terminar con un punto
error-uid-empty = El UID no puede estar vacío
error-uid-empty-component = El UID no puede contener componentes vacíos
error-uid-leading-zeros = El componente de UID «{ $part }» no puede tener ceros a la izquierda
error-uid-too-long = El UID debe tener como máximo 64 caracteres

## TUI
tui-bool-no = No
tui-bool-off = no
tui-bool-on = sí
tui-bool-yes = sí
tui-command-placeholder = Escriba un comando o use los atajos del panel.
tui-config-ae-title = AE title: { $value }
tui-config-edit-hint = Pulse Tab para enfocar este panel y luego 'c' para editar.
tui-config-hint = Pulse Tab para enfocar este panel y luego 'c' para editar.
tui-config-listener = Escucha: { $value }
tui-config-max-pdu = max_pdu_length: { $value }
tui-config-promiscuous = allow_promiscuous_storage: { $value }
tui-config-strict-pdu = strict_pdu: { $value }
tui-config-ts-pref = Preferencia TS: { $value }
tui-controls-hint = Tab campos · Enter confirma · Esc cancela
tui-detail-ae-title = AE Title
tui-detail-instance = Detalle de la instancia
tui-detail-name = Nombre
tui-detail-node = Detalle del nodo
tui-detail-placeholder-followup = Mueva el foco a un panel de lista y cambie la selección para actualizar esta vista.
tui-detail-query = Detalle del resultado de consulta
tui-detail-select-node = Seleccione un nodo remoto para inspeccionar sus metadatos.
tui-detail-series = Detalle de la serie
tui-detail-study = Detalle del estudio
tui-empty-command-placeholder = Escriba un comando o use los atajos del panel.
tui-empty-detail-instance = Seleccione una instancia para inspeccionarla, o vuelva a las series con Esc.
tui-empty-detail-node = Seleccione un nodo remoto para inspeccionar sus metadatos.
tui-empty-detail-query = Seleccione un resultado de consulta para inspeccionar metadatos y el contexto de retrieve.
tui-empty-detail-series = Seleccione una serie para inspeccionarla, o vuelva a los estudios con Esc.
tui-empty-detail-study = Seleccione un estudio local para inspeccionar metadatos de paciente y series.
tui-empty-instances = No hay instancias indexadas para esta serie.
tui-empty-instances-hint = Pulse Esc para volver a las series.
tui-empty-local-instances = No hay instancias indexadas para esta serie.
tui-empty-local-instances-hint = Pulse Esc para volver a las series.
tui-empty-local-series = No hay series indexadas para este estudio.
tui-empty-local-series-hint = Pulse Esc para volver a los estudios locales.
tui-empty-local-studies = Aún no hay estudios indexados.
tui-empty-local-studies-cmd = Ejemplo: import path=/data/inbox
tui-empty-local-studies-hint = Importe primero ficheros DICOM locales.
tui-empty-no-name = <sin nombre>
tui-empty-query = Aún no se ha ejecutado ninguna consulta.
tui-empty-query-body =
    Seleccione un nodo remoto y pulse 'f' para consultar.
    O: query node=pacs
        patient_name="DOE^JOHN"
    Pulse 'm' en un resultado seleccionado para abrir retrieve.
tui-empty-query-cmd = O: query node=pacs
tui-empty-query-hint = Seleccione un nodo remoto y pulse 'f' para consultar.
tui-empty-query-last-target = Último destino de consulta: { $name }
tui-empty-query-none = Aún no se ha ejecutado ninguna consulta.
tui-empty-query-retrieve-hint = Pulse 'm' en un resultado seleccionado para abrir retrieve.
tui-empty-remote-nodes =
    Aún no hay nodos remotos guardados.
    
    Pulse «a» en este panel para añadir uno.
    O: node add name=pacs
        ae=PACSAE host=10.0.0.10
        port=104
tui-empty-remote-nodes-cmd = O: node add name=pacs
tui-empty-remote-nodes-hint = Pulse «a» en este panel para añadir uno.
tui-empty-series = No hay series indexadas para este estudio.
tui-empty-series-hint = Pulse Esc para volver a los estudios locales.
tui-empty-studies = Aún no hay estudios indexados.
tui-empty-studies-hint = Importe primero ficheros DICOM locales.
tui-empty-tasks-history = No hay historial de tareas.
tui-empty-tasks-queued = No hay tareas en cola.
tui-fallback-no-name = <sin nombre>
tui-field-accession = Número de acceso
tui-field-ae-title = Título AE
tui-field-bind-addr = Dirección de enlace
tui-field-date-from = Fecha desde
tui-field-date-to = Fecha hasta
tui-field-destination-node = Nodo de destino
tui-field-host = host
tui-field-instance-uid = Instance UID
tui-field-kind = Tipo
tui-field-level = Nivel
tui-field-local-ae = AE local
tui-field-max-pdu = PDU máximo
tui-field-modality = Modalidad
tui-field-model = Modelo
tui-field-move-destination = Destino C-MOVE
tui-field-name = Nombre
tui-field-notes = Notas
tui-field-path = Ruta
tui-field-patient-id = ID de paciente
tui-field-patient-name = Nombre del paciente
tui-field-port = Puerto
tui-field-promiscuous = Promiscuo
tui-field-series-uid = Series UID
tui-field-sop-uid = SOP Instance UID
tui-field-strict-pdu = PDU estricto
tui-field-study-description = Descripción del estudio
tui-field-study-uid = Study UID
tui-footer-back-series = Esc volver a series
tui-footer-back-studies = Esc volver a estudios
tui-footer-cancel-task = c cancelar
tui-footer-edit-config = c editar config
tui-footer-enter-series = Intro series
tui-footer-esc-series = Esc volver a series
tui-footer-esc-studies = Esc volver a estudios
tui-footer-help = F1/? ayuda
tui-footer-inspect = Intro inspeccionar
tui-footer-next = Siguiente: { $text }
tui-footer-nodes = a/e/d/f nodos
tui-footer-panes = Tab paneles
tui-footer-queued =
    { $n ->
        [one] { $n } en cola
       *[other] { $n } en cola
    }
tui-footer-quit = q salir
tui-footer-refresh = r actualizar
tui-footer-retrieve = m recuperar
tui-footer-run-command = Intro ejecutar comando
tui-footer-task-scope = t cola/historial
tui-form-add-node = Añadir nodo remoto
tui-form-add-remote-node = Añadir nodo remoto
tui-form-delete-confirm = ¿Eliminar el nodo remoto { $name } [{ $ae }] en { $host }:{ $port }?
tui-form-delete-node = Eliminar nodo remoto
tui-form-delete-remote-node = Eliminar nodo remoto
tui-form-edit-node = Editar nodo remoto
tui-form-edit-remote-node = Editar nodo remoto
tui-form-err-ae-required = ! AE title is obligatorio
tui-form-err-bind-required = ! bind address is obligatorio
tui-form-err-host-required = ! host is obligatorio
tui-form-err-local-ae-invalid = ! AE title local no válido: { $err }
tui-form-err-local-ae-required = ! local AE title is obligatorio
tui-form-err-modality-empty = modality no puede estar vacío
tui-form-err-move-dest-invalid = ! AE title de destino de movimiento no válido: { $err }
tui-form-err-name-required = ! nombre del nodo is obligatorio
tui-form-err-port-required = ! port is obligatorio
tui-form-err-uid-empty = El UID no puede estar vacío
tui-form-err-uid-empty-component = El UID no puede contener componentes vacíos
tui-form-error-line = Fallo: { $error }
tui-form-field-accession = Número de acceso
tui-form-field-ae-title = Título AE
tui-form-field-bind-addr = Dirección de enlace
tui-form-field-date-from = Fecha desde
tui-form-field-date-to = Fecha hasta
tui-form-field-dest-node = Nodo de destino
tui-form-field-destination = AE de destino
tui-form-field-host = host
tui-form-field-instance-uid = SOP Instance UID
tui-form-field-kind = Tipo
tui-form-field-level = Nivel
tui-form-field-local-ae = AE local
tui-form-field-modality = Modalidad
tui-form-field-model = Modelo
tui-form-field-move-dest = Destino C-MOVE
tui-form-field-name = Nombre
tui-form-field-notes = Notas
tui-form-field-path = Ruta
tui-form-field-patient-id = ID de paciente
tui-form-field-patient-name = Nombre del paciente
tui-form-field-port = Puerto
tui-form-field-series-uid = Series Instance UID
tui-form-field-sop-uid = SOP Instance UID
tui-form-field-study-desc = Descripción del estudio
tui-form-field-study-uid = Study Instance UID
tui-form-field-uid = UID
tui-form-hint-bind = pista: normalmente 0.0.0.0 (todas las interfaces) o 127.0.0.1
tui-form-hint-local-ae = pista: hasta 16 caracteres (A-Z, 0-9, espacio), p. ej. ARCHIVE_AE
tui-form-hint-move-dest = hint: opcional; overrides the C-MOVE destination AE title
tui-form-hint-name = pista: una etiqueta corta (p. ej. PACS)
tui-form-import = Importar ficheros locales
tui-form-import-local = Importar ficheros locales
tui-form-import-local-files = Importar ficheros locales
tui-form-mode-add = create a new nodo remoto
tui-form-mode-edit = update the selected nodo remoto
tui-form-query-node = Consultar nodo remoto
tui-form-query-remote-node = Consultar nodo remoto
tui-form-remote-node-line = Nodo remoto: { $name } [{ $ae }] { $host }:{ $port }
tui-form-retrieve = Recuperar coincidencias
tui-form-retrieve-matches = Recuperar coincidencias
tui-form-send-series = Enviar serie
tui-form-send-study = Enviar estudio
tui-form-storage-intro = Editar ajustes locales de Storage SCP (guardados en config.json).
tui-form-storage-scp = Ajustes del Storage SCP
tui-form-storage-scp-settings = Ajustes del Storage SCP
tui-help-ae-title = AE title: { $value }
tui-help-aedf = a/e/d/f     Add, edit, delete, or query from the selected nodo
tui-help-c = c           Editar ajustes de Storage SCP (cuando el foco está en el panel Config)
tui-help-canonical-names = Los nombres canónicos coinciden con flags CLI sin '--' y usan guiones bajos.
tui-help-close = Cierre la ayuda con Esc, F1 o ?.
tui-help-common-commands = Comandos habituales
tui-help-config = c           Editar ajustes de Storage SCP (cuando el foco está en el panel Config)
tui-help-config-path = Ruta de configuración: { $value }
tui-help-current-config = Configuración actual
tui-help-data-dir = Dir. de datos: { $value }
tui-help-enter-default = Enter       Run the command input, submit the active modal, or open series from Estudios locales
tui-help-enter-instance = Enter       Sin acción del panel local en la vista de instancia
tui-help-enter-local-instance = Enter       Sin acción del panel local en la vista de instancia
tui-help-enter-local-series = Enter       Abrir instancias de la serie local seleccionada, o ejecutar la entrada de comando / enviar el modal activo
tui-help-enter-local-study = Enter       Abrir series del estudio local seleccionado, o ejecutar la entrada de comando / enviar el modal activo
tui-help-enter-series = Enter       Abrir instancias de la serie local seleccionada, o ejecutar la entrada de comando / enviar el modal activo
tui-help-enter-study = Enter       Abrir series del estudio local seleccionado, o ejecutar la entrada de comando / enviar el modal activo
tui-help-esc-default = Esc         Cerrar ayuda/modal, volver desde series locales o devolver el foco a la entrada de comandos
tui-help-esc-instance = Esc         Volver de instancias locales a series, cerrar ayuda/modal o devolver el foco a la entrada de comandos
tui-help-esc-instances = Esc         Volver de instancias locales a series, cerrar ayuda/modal o devolver el foco a la entrada de comandos
tui-help-esc-series = Esc         Volver de series locales a estudios, cerrar ayuda/modal o devolver el foco a la entrada de comandos
tui-help-f1 = F1 or ?     Abrir ayuda
tui-help-import-send = i/s         Importar local files or send selected study/series
tui-help-is = i/s         Importar local files or send selected study/series
tui-help-listener = Escucha: { $value }
tui-help-log-dir = Dir. de log: { $value }
tui-help-m = m           Recuperar del resultado de consulta seleccionado
tui-help-max-pdu = max_pdu_length: { $value }
tui-help-move = Arriba/abajo o j/k   Mover selección en paneles de lista
tui-help-nodes = a/e/d/f     Add, edit, delete, or query from the selected nodo
tui-help-open = F1 or ?     Abrir ayuda
tui-help-promiscuous = allow_promiscuous_storage: { $value }
tui-help-q = q           Salir cuando no hay modal activo y el foco no está en la entrada de comandos
tui-help-quit = q           Salir cuando no hay modal activo y el foco no está en la entrada de comandos
tui-help-r = r           Actualizar panes when focus is not in command input
tui-help-receiver-mode = Modo receptor: { $value }
tui-receiver-mode-on-demand = bajo demanda para retrieve local
tui-receiver-mode-standalone = independiente vía storage-scp
tui-help-refresh = r           Actualizar panes when focus is not in command input
tui-help-retrieve = m           Recuperar del resultado de consulta seleccionado
tui-help-strict-pdu = strict_pdu: { $value }
tui-help-tab = Tab / Shift-Tab  Cambiar panel enfocado
tui-help-title = Atajos de teclado
tui-help-ts-pref = preferred_store_transfer_syntax: { $value }
tui-help-updown = Arriba/abajo o j/k   Mover selección en paneles de lista
tui-input-placeholder = Escriba un comando o use los atajos del panel.
tui-log-command = > { $command }
tui-log-error = fallo: { $error }
tui-log-refreshed = actualizado
tui-logs-capped-suffix = limitado
tui-logs-label = Registros:
tui-pane-command = Comando
tui-pane-config = Configuración
tui-pane-detail = Detalle
tui-pane-detail-hint = { $title } (PgUp/PgDn cuando no se está escribiendo)
tui-pane-help = Ayuda
tui-pane-instance-detail = Detalle de la instancia
tui-pane-instances-for = Instancias de: { $uid }
tui-pane-local-studies = Estudios locales
tui-pane-logs = Registros ({ $shown }/{ $total }{ $capped })
tui-pane-logs-capped = Registros ({ $shown }/{ $total } capped)
tui-pane-logs-uncapped = Registros ({ $shown }/{ $total })
tui-pane-node-detail = Detalle del nodo
tui-pane-query-detail = Detalle del resultado de consulta
tui-pane-query-node = Consultar nodo
tui-pane-query-result-detail = Detalle del resultado de consulta
tui-pane-query-results = Resultados de consulta / recuperación
tui-pane-query-retrieve-results = Resultados de consulta / recuperación
tui-pane-remote-nodes = Nodos remotos
tui-pane-series-detail = Detalle de la serie
tui-pane-series-for = Series de: { $uid }
tui-pane-series-unknown = Series de: <estudio desconocido>
tui-pane-study-detail = Detalle del estudio
tui-pane-task-details = Detalle de tarea
tui-pane-tasks-history = Tareas (historial)
tui-pane-tasks-queued = Tareas (cola)
tui-pane-unknown-series = <serie desconocida>
tui-pane-unknown-study = Series de: <estudio desconocido>
tui-row-inst = inst
tui-status-cancel-requested = Cancelarlation requested
tui-status-config = Configuración
tui-status-configured-listener = Listener configurado { $addr } como AE { $ae } ({ $mode })
tui-status-data = datos
tui-status-failure = fallo: { $failure }
tui-status-listener = escucha
tui-status-local-ae = AE local
tui-status-mode = Modo
tui-status-mode-on-demand = bajo demanda
tui-status-mode-standalone = independiente
tui-status-no-active-task = Ninguna tarea activa to cancel (nada en ejecución)
tui-status-pdu = PDU
tui-status-promiscuous = Promiscuo
tui-status-query-before-retrieve = Query a nodo remoto first so retrieve knows which nodo to use
tui-status-query-failed = la consulta falló: { $error }
tui-status-queued-op = Operación en cola: { $op }
tui-status-retrieve-failed = la recuperación falló: { $error }
tui-status-retrieve-open-failed = no se pudo abrir retrieve stream: { $error }
tui-status-saved-node = saved nodo { $name } ({ $id })
tui-status-saved-scp = Storage SCP settings saved (restart obligatorio)
tui-status-select-node = seleccione un nodo remoto primero
tui-status-select-query = seleccione primero un resultado de consulta
tui-status-select-study = seleccione primero un estudio local
tui-status-strict = Estricto
tui-status-task-cancelled = Tarea cancelada
tui-status-task-cancelled-detail = Tarea cancelada: { $other }
tui-status-ts-pref = Pref. TS
tui-status-updated-node = updated nodo { $name } ({ $id })
tui-suggest-back-series = Esc — volver a series
tui-suggest-edit-config = c — editar config
tui-suggest-help = F1/? — ayuda
tui-suggest-inspect-task = Enter — inspeccionar tarea
tui-suggest-node-add = node add <ae-title> <host:port>
tui-suggest-query = f — query a nodo
tui-suggest-query-node = f — query selected nodo
tui-suggest-retrieve = m — recuperar seleccionados
tui-suggest-run-command = Enter — ejecutar comando
tui-suggest-send-series = s — enviar serie seleccionada
tui-suggest-view-series = Enter — ver series
tui-task-cancelled = Cancelada
tui-task-cancelling = Cancelando
tui-task-failed = Fallida
tui-task-failed-generic = La tarea falló: { $error }
tui-task-import-done = Importar complete: { $report }
tui-task-import-failed = Importación fallida: { $error }
tui-task-importing = Importando { $path }...
tui-task-query-done =
    Consulta completa: { $count ->
        [one] { $count } coincidencia
       *[other] { $count } coincidencias
    }
tui-task-query-failed = Consulta fallida: { $error }
tui-task-querying = Consultando { $node }...
tui-task-queued = En cola
tui-task-retrieve-done = Recuperación completa: { $outcome }
tui-task-retrieve-failed = Recuperación fallida: { $error }
tui-task-retrieving = Recuperando desde { $node }...
tui-task-running = En curso
tui-task-sending-series = Enviando serie { $uid } a { $node }...
tui-task-sending-study = Enviando estudio { $uid } a { $node }...
tui-task-send-done = Envío completo: { $outcome }
tui-task-status-cancelled = cancelado
tui-task-status-cancelling = cancelando
tui-task-status-failed = fallido
tui-task-status-ok = ok
tui-task-status-queued = en cola
tui-task-status-running = en curso
tui-task-succeeded = Correcto
tui-terminal-too-small = Terminal demasiado pequeño: redimensione

## Desktop
desktop-action-activity = Actividad { $count }
desktop-action-activity-empty = Actividad
desktop-action-import = Importar
desktop-action-inspect-archive = Inspeccionar archivo local
desktop-action-inspect-archive-desc = Revise estudios, series e instancias; luego envíe o exporte.
desktop-action-manage-peers = Gestionar peers
desktop-action-manage-peers-desc = Añada y edite nodos PACS o estaciones usados en query, retrieve y store.
desktop-action-monitor-scp = Supervisar Storage SCP
desktop-action-query = Consultar
desktop-action-refresh = Actualizar estado
desktop-action-refresh-status = Actualizar estado
desktop-action-reveal-log = Mostrar fichero de registro
desktop-action-send = Enviar
desktop-action-start-scp = Iniciar Storage SCP
desktop-activity-empty = Aún no hay actividad de sesión.
desktop-activity-title = Actividad
desktop-app-title = DICOM Node
desktop-archive-csv = CSV
desktop-archive-details = Detalles
desktop-archive-empty = El archivo local está vacío.
desktop-archive-export-fail = Exportación de { $scope } fallida
desktop-archive-export-ok =
    { $rows ->
        [one] Exportada { $rows } fila de { $scope } a { $path }.
       *[other] Exportadas { $rows } filas de { $scope } a { $path }.
    }
desktop-archive-export-studies = Exportar estudios
desktop-archive-export-title = Exportar { $scope }
desktop-archive-filter = Filtrar por paciente, UID, descripción, modalidad…
desktop-archive-filter-placeholder = Filtrar por paciente, UID, descripción, modalidad…
desktop-archive-inst-abbrev = { $count } inst.
desktop-archive-instance-meta = { $bytes } · TS { $ts } · importado { $imported }
desktop-archive-instances = Instancias
desktop-archive-instances-heading = Instancias
desktop-archive-json = JSON
desktop-archive-loading = Cargando estudios…
desktop-archive-no-filter-match = Ningún estudio coincide con el filtro.
desktop-archive-no-instances = No se encontraron instancias.
desktop-archive-no-match = Ningún estudio coincide con el filtro.
desktop-archive-no-nodes = Sin nodos
desktop-archive-no-series = No se encontraron series.
desktop-archive-reveal-file = Mostrar fichero
desktop-archive-select-series = Seleccione una serie.
desktop-archive-select-study = Seleccione un estudio.
desktop-archive-send-fail = { $label }: { $sent }/{ $attempted } enviadas, { $failed } fallidas. { $failures }
desktop-archive-send-fail-title = { $label } falló
desktop-archive-send-ok = { $label }: enviadas { $sent }/{ $attempted } instancias.
desktop-archive-send-series = Enviar serie
desktop-archive-send-series-label = Serie → { $destination }
desktop-archive-send-study = Enviar estudio
desktop-archive-send-study-label = Estudio → { $destination }
desktop-archive-send-to = Enviar a
desktop-archive-series = series
desktop-archive-series-count =
    #{ $number } · { $count ->
        [one] { $count } instancia
       *[other] { $count } instancias
    }
desktop-archive-series-fallback = series
desktop-archive-studies = Estudios
desktop-archive-study-date = Fecha del estudio
desktop-archive-study-uid = Study UID
desktop-archive-subtitle = Inventario de estudios, series e instancias del archivo SQLite local.
desktop-archive-title = Archivo local
desktop-brand-title = DICOM Node
desktop-col-description = Descripción
desktop-col-instances = Instancias
desktop-col-modalities = Modalidades
desktop-col-patient-id = ID de paciente
desktop-common-cancel = Cancelar
desktop-common-clear = Borrar
desktop-common-disabled = deshabilitado
desktop-common-enabled = habilitado
desktop-common-loading = Cargando…
desktop-common-no = No
desktop-common-refresh = Actualizar
desktop-common-yes = sí
desktop-counter-assoc-accepted = Asociaciones aceptadas
desktop-counter-bytes-ingested = Bytes ingeridos
desktop-counter-cfind-requests = Peticiones C-FIND
desktop-counter-cmove-requests = Peticiones C-MOVE
desktop-counter-cstore-failed = C-STORE fallidos
desktop-counter-cstore-stored = C-STORE almacenados
desktop-dashboard-counter-assoc-accepted = Asociaciones aceptadas
desktop-dashboard-counter-bytes-ingested = Bytes ingeridos
desktop-dashboard-counter-c-find-requests = Peticiones C-FIND
desktop-dashboard-counter-c-move-requests = Peticiones C-MOVE
desktop-dashboard-counter-c-store-failed = C-STORE fallidos
desktop-dashboard-counter-c-store-stored = C-STORE almacenados
desktop-dashboard-empty-studies = Aún no hay estudios locales.
desktop-dashboard-inspect-archive-body = Revise estudios, entre en series e instancias y luego envíe o exporte.
desktop-dashboard-inspect-archive-title = Inspeccionar archivo local
desktop-dashboard-kv-ae-title = Título AE
desktop-dashboard-kv-data-dir = Directorio de datos
desktop-dashboard-kv-listener = escucha
desktop-dashboard-kv-log-file = Fichero de registro
desktop-dashboard-kv-max-pdu = PDU máximo
desktop-dashboard-kv-promiscuous = Almacenamiento promiscuo
desktop-dashboard-kv-server = Servidor
desktop-dashboard-kv-store-syntax = Sintaxis de store
desktop-dashboard-kv-strict-pdu = PDU estricto
desktop-dashboard-listener-missing = Listener aún no cargado.
desktop-dashboard-live-counters = Contadores en vivo
desktop-dashboard-loading-metrics = Cargando métricas…
desktop-dashboard-loading-status = Cargando estado local…
desktop-dashboard-loading-studies = Cargando estudios…
desktop-dashboard-local-node = Nodo local
desktop-dashboard-manage-peers-body = Añada y edite nodos PACS o de estación usados en consulta, recuperación y almacenamiento.
desktop-dashboard-manage-peers-title = Gestionar pares
desktop-dashboard-metric-instances = Instancias
desktop-dashboard-metric-nodes = Nodos remotos
desktop-dashboard-metric-series = series
desktop-dashboard-metric-studies = Estudios
desktop-dashboard-monitor-scp = Supervisar Storage SCP
desktop-dashboard-recent-studies = Estudios recientes
desktop-dashboard-start-scp = Iniciar Storage SCP
desktop-dashboard-subtitle = Archivo local, pares de red y actividad SCP de un vistazo.
desktop-dashboard-title = Panel del operador
desktop-doc-title = DICOM Node
desktop-import-accepted = Aceptados
desktop-import-accepted-bytes = Bytes aceptados
desktop-import-activity-detail = { $accepted }/{ $scanned } aceptados, { $duplicates } duplicados, { $bytes }
desktop-import-activity-fail = Importación fallida
desktop-import-activity-ok = Importación completada
desktop-import-choose-archive = Elija un archivo ZIP para importar
desktop-import-choose-dir = Elija un directorio para importar
desktop-import-choose-folder = Carpeta
desktop-import-choose-zip = Elija un archivo ZIP para importar
desktop-import-cleanup = Limpieza
desktop-import-clear-path = Borrar ruta
desktop-import-complete = Importación completada
desktop-import-dup-sha = SHA-256
desktop-import-dup-sop = SOP UID
desktop-import-dup-total = total
desktop-import-duplicates = Duplicados
desktop-import-failed = Importación fallida
desktop-import-failed-cleanup = Limpieza fallida
desktop-import-failures = Fallos
desktop-import-failures-heading =
    { $count ->
        [one] { $count } fallo:
       *[other] { $count } fallos:
    }
desktop-import-failures-more = … y { $count } más
desktop-import-files-progress = { $label } ficheros
desktop-import-folder = Carpeta
desktop-import-invalid-dicom = DICOM no válido
desktop-import-pick-dir = Elija un directorio para importar
desktop-import-pick-zip = Elija un archivo ZIP para importar
desktop-import-placeholder = /path/to/dicom-folder or /path/to/archive.zip
desktop-import-rejected = Rechazados
desktop-import-report = Informe de importación
desktop-import-running = Importando…
desktop-import-scanned = Explorados
desktop-import-skipped = Omitidos
desktop-import-source = Origen
desktop-import-start = Iniciar importación
desktop-import-stored = Almacenados
desktop-import-subtitle = Indexar ficheros DICOM desde carpetas recursivas o archivos ZIP en el archivo local gestionado.
desktop-import-title = Importar
desktop-import-unreadable = Ilegible
desktop-import-zip = ZIP
desktop-import-zip-filter = Archivos ZIP
desktop-lang-label = Idioma
desktop-listener-not-loaded = Listener aún no cargado.
desktop-live-counters = Contadores en vivo
desktop-loading = Cargando
desktop-loading-local-status = Cargando estado local…
desktop-loading-metrics = Cargando métricas…
desktop-loading-studies = Cargando estudios…
desktop-local-node = Nodo local
desktop-locale-label = Idioma
desktop-logs-activity-detail =
    { $count ->
        [one] { $count } línea cargada
       *[other] { $count } líneas cargadas
    }
desktop-logs-activity-fail = Fallo al actualizar el registro
desktop-logs-activity-ok = Registro actualizado
desktop-logs-auto = AUTOMÁTICO
desktop-logs-auto-refresh = Actualización automática
desktop-logs-empty = El fichero de registro está vacío.
desktop-logs-found = FICHERO DE REGISTRO ENCONTRADO
desktop-logs-lines =
    { $count ->
        [one] { $count } línea
       *[other] { $count } líneas
    }
desktop-logs-loading = Cargando registro…
desktop-logs-missing = El fichero de registro activo aún no se ha creado.
desktop-logs-refresh-failed = Fallo al actualizar el registro
desktop-logs-refreshed = Registro actualizado
desktop-logs-reveal = Mostrar
desktop-logs-subtitle = Cola acotada del fichero de registro activo del escritorio.
desktop-logs-tail = Cola
desktop-logs-title = Registros
desktop-logs-truncated = TRUNCADO
desktop-logs-waiting = ESPERANDO FICHERO DE REGISTRO
desktop-metric-instances = Instancias
desktop-metric-remote-nodes = Nodos remotos
desktop-metric-series = series
desktop-metric-studies = Estudios
desktop-nav-archive = Archivo local
desktop-nav-dashboard = Panel
desktop-nav-import = Importar
desktop-nav-logs = Registros
desktop-nav-network = Red
desktop-nav-nodes = Nodos remotos
desktop-nav-query = Consulta / recuperación
desktop-nav-server = Servidor de almacenamiento
desktop-no-local-studies = Aún no hay estudios locales.
desktop-nodes-add = Añadir nodo
desktop-nodes-added = Nodo "{ $name }" añadido.
desktop-nodes-ae-length = El título AE debe tener 16 caracteres o menos.
desktop-nodes-ae-title = Título AE
desktop-nodes-col-move = Dest. Move
desktop-nodes-configured = Nodos configurados
desktop-nodes-confirm-delete = ¿Eliminar el nodo "{ $name }"?
desktop-nodes-default-port = Puerto por defecto 104
desktop-nodes-delete = Eliminar nodo
desktop-nodes-delete-title = Eliminar nodo
desktop-nodes-deleted = Nodo "{ $name }" eliminado.
desktop-nodes-edit = Editar nodo
desktop-nodes-edit-title = Editar nodo
desktop-nodes-empty = Aún no hay nodos remotos.
desktop-nodes-err-ae = El título AE es obligatorio.
desktop-nodes-err-ae-len = El título AE debe tener 16 caracteres o menos.
desktop-nodes-err-host = El host es obligatorio.
desktop-nodes-err-name = El nombre es obligatorio.
desktop-nodes-err-port = El puerto debe estar entre 1 y 65535.
desktop-nodes-host = host
desktop-nodes-move-dest = Destino de Move
desktop-nodes-move-placeholder = Por defecto, el AE local
desktop-nodes-name = Nombre
desktop-nodes-need-ae = El título AE es obligatorio.
desktop-nodes-need-host = El host es obligatorio.
desktop-nodes-need-name = El nombre es obligatorio.
desktop-nodes-notes = Notas
desktop-nodes-notes-placeholder = PACS de sala de lectura
desktop-nodes-placeholder-ae = PACS01
desktop-nodes-placeholder-host = 192.168.0.10
desktop-nodes-placeholder-move = Por defecto, el AE local
desktop-nodes-placeholder-name = main-pacs
desktop-nodes-placeholder-notes = PACS de sala de lectura
desktop-nodes-port = Puerto
desktop-nodes-port-104 = Puerto por defecto 104
desktop-nodes-port-range = El puerto debe estar entre 1 y 65535.
desktop-nodes-save = Guardar cambios
desktop-nodes-save-changes = Guardar cambios
desktop-nodes-subtitle = Pares PACS y de estación para consulta, recuperación y almacenamiento.
desktop-nodes-summary = Resumen de nodos
desktop-nodes-title = Nodos remotos
desktop-nodes-total = Nodos totales
desktop-nodes-updated = Nodo "{ $name }" actualizado.
desktop-nodes-with-move = Con destino de Move
desktop-promiscuous = Almacenamiento promiscuo
desktop-query-accession = Acceso nº
desktop-query-activity-detail = { $count } { $count ->
        [one] coincidencia
       *[other] coincidencias
    } en el nivel { $level }
desktop-query-activity-fail = C-FIND { $node } falló
desktop-query-activity-ok = C-FIND { $node }
desktop-query-activity-title = C-FIND { $node }
desktop-query-clear = Borrar
desktop-query-col-accession = Acceso
desktop-query-criteria = Criterios de búsqueda
desktop-query-date-from = Fecha del estudio (desde)
desktop-query-date-to = Fecha del estudio (hasta)
desktop-query-kv-series-uid = Series UID
desktop-query-kv-sop-uid = SOP UID
desktop-query-kv-study-uid = Study UID
desktop-query-level = Nivel
desktop-query-matches =
    { $count ->
        [one] { $count } coincidencia
       *[other] { $count } coincidencias
    }
desktop-query-missing-study-uid = La coincidencia no tiene StudyInstanceUID; no se puede recuperar.
desktop-query-modality = Modalidad
desktop-query-no-matches = Sin coincidencias.
desktop-query-no-nodes = No hay nodos configurados
desktop-query-patient-id = ID de paciente
desktop-query-patient-name = Nombre del paciente
desktop-query-placeholder-description = CHEST*
desktop-query-placeholder-modality = CT, MR, …
desktop-query-placeholder-name = DOE^JOHN or DOE*
desktop-query-placeholder-patient = DOE^JOHN or DOE*
desktop-query-querying = Consultando…
desktop-query-remote-node = Nodo remoto
desktop-query-results = Resultados
desktop-query-retrieve = Recuperar
desktop-query-retrieve-activity-detail = completed={ $completed }, warning={ $warning }, failed={ $failed }
desktop-query-retrieve-activity-fail = C-MOVE { $node } falló
desktop-query-retrieve-activity-ok = C-MOVE { $node }
desktop-query-retrieve-finished = Recuperación terminada: completadas { $completed }, avisos { $warning }, fallos { $failed }.
desktop-query-retrieve-selected = Recuperar seleccionado
desktop-query-run = Ejecutar C-FIND
desktop-query-run-select = Ejecute una consulta y seleccione una coincidencia.
desktop-query-running = Consultando…
desktop-query-search-criteria = Criterios de búsqueda
desktop-query-select-hint = Ejecute una consulta y seleccione una coincidencia.
desktop-query-selected = Coincidencia seleccionada
desktop-query-selected-match = Coincidencia seleccionada
desktop-query-series-uid = Series Instance UID
desktop-query-sop-uid = SOP Instance UID
desktop-query-study-description = Descripción del estudio
desktop-query-study-uid = Study Instance UID
desktop-query-subtitle = C-FIND a un nodo remoto, inspeccione coincidencias y luego C-MOVE al archivo local.
desktop-query-title = Consulta / recuperación
desktop-recent-studies = Estudios recientes
desktop-scp-listening = SCP en escucha
desktop-scp-stopped = SCP detenido
desktop-server-activity-fail = Fallo del control Storage SCP
desktop-server-activity-started = Storage SCP iniciado
desktop-server-activity-started-detail = Listener iniciado.
desktop-server-activity-stopped = Storage SCP detenido
desktop-server-activity-stopped-detail = received={ $received }, stored={ $stored }, failed={ $failed }
desktop-server-activity-stopped-empty = No hay sesión activa.
desktop-server-addr-ae = { $addr } · AE { $ae }
desktop-server-assoc-accepted = Asociaciones aceptadas
desktop-server-assoc-rejected = Asociaciones rechazadas
desktop-server-cfind-req-matches = Peticiones / coincidencias C-FIND
desktop-server-cget-requests = Peticiones C-GET
desktop-server-cmove-requests = Peticiones C-MOVE
desktop-server-cmove-subops = Suboperaciones C-MOVE completadas / fallidas
desktop-server-control-failed = Fallo del control Storage SCP
desktop-server-counter-bytes = Bytes ingeridos
desktop-server-counter-failed = C-STORE fallidos
desktop-server-counter-find = Peticiones / coincidencias C-FIND
desktop-server-counter-get = Peticiones C-GET
desktop-server-counter-move = Peticiones C-MOVE
desktop-server-counter-move-sub = Suboperaciones C-MOVE completadas / fallidas
desktop-server-counter-received = C-STORE recibidos
desktop-server-counter-stored = C-STORE almacenados
desktop-server-cstore-failed = C-STORE fallidos
desktop-server-cstore-received = C-STORE recibidos
desktop-server-cstore-stored = C-STORE almacenados
desktop-server-dimse = Contadores DIMSE
desktop-server-failed = Fallidos
desktop-server-health-loading = Cargando métricas
desktop-server-health-ready = Listo para C-STORE de entrada
desktop-server-health-review = Revisar fallos
desktop-server-health-stopped = Detenido
desktop-server-listener-started = Listener iniciado.
desktop-server-listening = EN ESCUCHA
desktop-server-loading-metrics = Cargando métricas…
desktop-server-logs = Registros
desktop-server-no-session = No hay sesión activa.
desktop-server-rate = +{ $rate } / sondeo
desktop-server-ready = Listo para C-STORE de entrada
desktop-server-review-failures = Revisar fallos
desktop-server-session-ended = Sesión terminada: recibidos { $received }, almacenados { $stored }, fallos { $failed }.
desktop-server-start = Iniciar servidor
desktop-server-started-title = Storage SCP iniciado
desktop-server-stop = Detener servidor
desktop-server-stopped = DETENIDO
desktop-server-stopped-pill = DETENIDO
desktop-server-stopped-status = Detenido
desktop-server-stopped-title = Storage SCP detenido
desktop-server-stored = Almacenados
desktop-server-subtitle = Storage SCP autónomo para C-STORE de entrada e indexación del archivo local.
desktop-server-title = Servidor de almacenamiento
desktop-status-listening = en escucha
desktop-status-loading = Cargando
desktop-status-scp-listening = SCP en escucha
desktop-status-scp-stopped = SCP detenido
desktop-status-stopped = detenido
desktop-store-syntax = Sintaxis de store
desktop-strict-pdu = PDU estricto
desktop-strip-pdu = PDU { $value }
desktop-table-accession = Acceso
desktop-table-ae-title = Título AE
desktop-table-date = Fecha
desktop-table-description = Descripción
desktop-table-endpoint = Extremo
desktop-table-instances = Instancias
desktop-table-modalities = Modalidades
desktop-table-modality = Modalidad
desktop-table-move-dest = Dest. Move
desktop-table-name = Nombre
desktop-table-notes = Notas
desktop-table-patient = Paciente
desktop-table-patient-id = ID de paciente
desktop-table-series = series
desktop-table-updated = Actualizado
desktop-title-refresh-status = Actualizar estado
desktop-title-reveal-log = Mostrar fichero de registro
ae = AE
patient-name =
    "DOE^JOHN"
    Pulse 'm' en un resultado seleccionado para abrir retrieve.
port = Puerto

## Summary
summary-ae = AE
summary-counts = Recuentos
summary-criteria = Criterios
summary-duration = Duración
summary-duration-ms = { $ms }ms
summary-failures = Fallos:
summary-kind = Tipo
summary-logs = Registros:
summary-peer = Par
summary-status = Estado
summary-title = Resumen de la operación
tui-detail-created = Creado

tui-form-hint-port-range = pista: un número de 1 a 65535, p. ej. 104
tui-form-hint-promiscuous = pista: permitir almacenamiento desde cualquier AE title llamante
tui-form-hint-strict-pdu = pista: aplicar comprobaciones de tamaño de PDU durante las asociaciones
tui-form-hint-max-pdu-bytes = pista: bytes, p. ej. 16384
tui-form-limits-heading = Limits (bytes; blank/ninguno = unlimited):
tui-form-field-max-file-import = Máx. bytes de importación
tui-form-field-max-zip-entry = Máx. bytes de entrada ZIP
tui-form-field-max-zip-total = Máx. bytes totales ZIP
tui-form-field-max-zip-count = Máx. de entradas ZIP
tui-form-field-max-store-object = Máx. bytes de objeto almacenado
tui-form-unlimited = ilimitado
tui-form-err-max-pdu-required = ! max PDU length is obligatorio
tui-form-err-max-pdu-gt-zero = ! la longitud máx. de PDU debe ser un entero mayor que 0
tui-form-err-limit-gt-zero = ! { $label } debe ser un entero mayor que 0
tui-form-controls-scp = Escriba para editar. Espacio alterna casillas. Tab/Mayús-Tab o Arriba/Abajo cambian campos. Enter guarda. Esc cancela.
tui-form-submit-uid-required = UID is obligatorio
tui-form-submit-dest-required = destination nodo is obligatorio
tui-form-submit-nonneg-int = { $label } debe ser un entero no negativo
tui-form-submit-gt-zero = { $label } debe ser mayor que 0
tui-form-submit-local-ae-required = local AE title is obligatorio
tui-form-submit-local-ae-invalid = el AE title local no es válido: { $err }
tui-form-submit-bind-required = bind address is obligatorio
tui-form-submit-port-required = port is obligatorio
tui-form-submit-max-pdu-required = max PDU length is obligatorio
tui-form-submit-max-pdu-int = la longitud máx. de PDU debe ser un entero
tui-form-submit-max-pdu-gt-zero = la longitud máx. de PDU debe ser mayor que 0
tui-form-submit-patient-retrieve = la recuperación a nivel de paciente no es compatible
tui-form-submit-no-study-uid = el resultado seleccionado no incluye un study UID
tui-form-submit-date-format = se espera YYYYMMDD
tui-form-submit-modality-len = la modalidad debe tener 16 caracteres como máximo
tui-form-submit-modality-chars = la modalidad debe ser A-Z o 0-9
tui-form-submit-name-required = nombre del nodo is obligatorio
tui-form-submit-ae-required = AE title is obligatorio
tui-form-submit-host-required = host is obligatorio
tui-form-submit-move-dest-invalid = el AE title de destino de movimiento no es válido: { $err }
tui-form-submit-dates-both = hay que definir fecha desde y fecha hasta, o ninguna
tui-form-submit-date-from-invalid = la fecha desde no es válida: { $err }
tui-form-submit-date-to-invalid = la fecha hasta no es válida: { $err }
tui-form-submit-date-order = la fecha desde debe ser anterior o igual a la fecha hasta
tui-form-submit-study-uid-series-query = study UID is obligatorio for series-level queries
tui-form-submit-study-uid-image-query = study UID is obligatorio for image-level queries
tui-form-submit-series-uid-image-query = series UID is obligatorio for image-level queries
tui-form-submit-study-uid-required = study UID is obligatorio
tui-form-submit-study-uid-invalid = el study UID no es válido: { $err }
tui-form-submit-series-uid-series-retrieve = series UID is obligatorio for series-level retrieve
tui-form-submit-series-uid-image-retrieve = series UID is obligatorio for image-level retrieve
tui-form-submit-instance-uid-image-retrieve = instance UID is obligatorio for image-level retrieve
tui-form-submit-series-uid-invalid = el series UID no es válido: { $err }
tui-form-submit-instance-uid-invalid = el instance UID no es válido: { $err }
tui-form-submit-import-path-required = import path is obligatorio
tui-form-submit-import-path-type = la ruta de importación debe ser un archivo o directorio: { $path }
tui-form-submit-import-access = accediendo a la ruta de importación { $path }
tui-form-submit-import-open = abriendo archivo de importación { $path }
tui-form-submit-import-read-dir = leyendo directorio de importación { $path }
tui-log-welcome = Press F1 or ? for help. Focus Nodo remotos and press 'a' to add one.
tui-log-logging-to = Registrando en { $path }
tui-command-help-heading = comandos:
tui-command-help-next-1 = nota: el pie muestra sugerencias contextuales 'Next:' según el panel enfocado y la selección.
tui-command-help-next-2 = Solo son pistas; siempre puedes escribir cualquier comando.
tui-command-help-canonical = nota: los nombres canónicos coinciden con las flags de la CLI sin '--', usando underscores.
tui-command-help-cancel = cancelar (alias: stop)
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
tui-command-help-refresh = actualizar
tui-command-help-quit = salir
tui-inspect-task = Tarea #{ $id }
tui-inspect-status = Estado: { $status }
tui-inspect-description = Descripción: { $description }
tui-inspect-progress = Progreso: { $progress }
tui-inspect-summary = Resumen:
tui-inspect-no-logs = (sin registros)
tui-field-sop-class-uid = SOP Class UID
tui-field-transfer-syntax-uid = Transfer Syntax UID
tui-field-sha256 = SHA-256
tui-status-removed-nodes =
    eliminado { $count ->
        [one] { $count } nodo
       *[other] { $count } nodos
    }
tui-status-removed-nodes-target =
    eliminado { $count ->
        [one] { $count } nodo
       *[other] { $count } nodos
    }; el último objetivo fue { $name }
tui-status-more-failures =
    y { $n ->
        [one] { $n } fallo omitido
       *[other] { $n } fallos omitidos
    }
tui-status-retrieve-ok = retrieve status=0x{ $status } completed={ $completed } failed={ $failed } warning={ $warning } remaining={ $remaining }
tui-status-import-counts = scanned={ $scanned } accepted={ $accepted } duplicates={ $duplicates } unreadable={ $unreadable } invalid_dicom={ $invalid } rejected_total={ $rejected } stored_bytes={ $bytes }
tui-status-send-ok = send attempted={ $attempted } sent={ $sent } failed={ $failed }
tui-log-query-start = Iniciando consulta a { $node }
tui-log-retrieve-start = Iniciando recuperación desde { $node }
tui-log-import-start = Iniciando importación de { $path }
tui-log-send-study-start = Iniciando envío del estudio { $uid } a { $node }
tui-log-send-series-start = Iniciando envío de la serie { $uid } a { $node }
tui-log-cancelled-before-start = cancelado antes de iniciar
tui-log-cancelled = cancelado
error-unknown-command = comando desconocido: { $command }
error-node-subcommand-required = node subcommand obligatorio
error-local-subcommand-required = local subcommand obligatorio
error-unsupported-node-subcommand = unsupported nodo subcommand: { $command }
error-unsupported-local-subcommand = subcomando local no compatible: { $command }
error-expected-kv = se esperaba un argumento key=value, se obtuvo { $arg }
error-missing-required-arg = missing obligatorio argument: { $key }
error-missing-required-arg-one-of = missing obligatorio argument: one of { $keys }
error-parsing-command = analizando el comando
error-edit-form-lost-target = edit form lost its target nodo
error-task-already-running = ya hay una tarea en segundo plano
error-task-thread-launch = no se pudo iniciar el hilo de la tarea en segundo plano: { $error }
error-task-disconnected = el hilo de la tarea en segundo plano se desconectó antes de enviar un resultado
error-task-kind-missing = el hilo de la tarea en segundo plano se desconectó pero active_task_kind era None: estado inesperado
error-serve-exited = serve terminó con error: { $error }
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
summary-title = Resumen de la operación
summary-kind = Tipo
summary-status = Estado
summary-duration = Duración
summary-duration-ms = { $ms }ms
summary-peer = Par
summary-ae = AE
summary-criteria = Criterios
summary-counts = Recuentos
summary-failures = Fallos:
summary-logs = Registros:
summary-unserializable = <no serializable>
summary-log-lines = líneas { $start }-{ $end }
