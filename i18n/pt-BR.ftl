# Fluent catalog (pt-BR). Message IDs are hyphenated identifiers
# (cli-about, tui-pane-remote-nodes, desktop-nav-dashboard, error-import-file-too-large).
# Dotted names are Fluent attributes (message + .attr), not message IDs.
# Do not translate DICOM tokens (C-FIND, C-MOVE, C-STORE, SOP, AE, UID) or JSON/CSV machine keys.


## CLI
cli-about = Cliente DICOM com foco em terminal, construído com dicom-rs
cli-arg-accession-number = Filtra pelo número de acesso (substring, sem diferenciar maiúsculas).
cli-arg-ae-title = Application Entity title
cli-arg-destination-node = Nome ou id do nó de destino
cli-arg-duplicate = Filtra pelo status de duplicata.
cli-arg-export = Exporta os resultados como JSON ou CSV.
cli-arg-host = Hostname ou IP
cli-arg-imported-at =
    Filtra pelo instante de importação. Aceita VALUE, START..END, ..END, START...
    Comparação lexicográfica (formato recomendado: RFC3339).
cli-arg-json = Emite o resumo final da operação em JSON (esquema estável).
cli-arg-level = Nível de consulta/recuperação
cli-arg-metrics-json = Imprime o snapshot final das métricas em memória do servidor em JSON ao sair.
cli-arg-modality = Filtra pela modalidade. Lista separada por vírgulas (ex.: CT,MR).
cli-arg-model = Modelo de informação de consulta/recuperação
cli-arg-move-destination = Título AE preferido de destino do C-MOVE
cli-arg-name = Nome de exibição do nó
cli-arg-node = Nome ou id do nó salvo
cli-arg-notes = Notas em texto livre
cli-arg-out = Caminho do arquivo de saída. Se omitido, escreve na saída padrão.
cli-arg-path = Arquivo ou diretório a importar
cli-arg-patient-id = Filtra pelo ID do paciente (substring, sem diferenciar maiúsculas).
cli-arg-patient-name = Filtra pelo nome do paciente (substring, sem diferenciar maiúsculas).
cli-arg-port = Porta
cli-arg-series-description = Filtra pela descrição da série (substring, sem diferenciar maiúsculas).
cli-arg-series-instance-uid = Series Instance UID
cli-arg-sop-instance-uid = SOP Instance UID
cli-arg-source-path = Filtra pelo caminho de origem (substring, sem diferenciar maiúsculas).
cli-arg-study-date =
    Filtra pela data do estudo. Aceita VALUE, START..END, ..END, START...
    As datas são comparadas lexicograficamente (formato recomendado: YYYYMMDD).
cli-arg-study-date-from = Limite inferior da data do estudo (YYYYMMDD)
cli-arg-study-date-to = Limite superior da data do estudo (YYYYMMDD)
cli-arg-study-description = Filtra pela descrição do estudo (substring, sem diferenciar maiúsculas).
cli-arg-study-instance-uid = Study Instance UID
cli-cmd-import-about = Importa arquivos DICOM a partir de um caminho
cli-cmd-local-about = Inspeciona o arquivo local
cli-cmd-local-series-about = Lista séries indexadas de um estudo
cli-cmd-local-studies-about = Lista estudos locais indexados
cli-cmd-node-about = Gerencia nós DICOM remotos salvos
cli-cmd-node-add-about = Adiciona um nó remoto
cli-cmd-node-delete-about = Exclui um nó salvo
cli-cmd-node-edit-about = Edita um nó salvo
cli-cmd-node-list-about = Lista os nós salvos
cli-cmd-query-about = Consulta um nó remoto (C-FIND)
cli-cmd-retrieve-about = Recupera de um nó remoto (C-MOVE)
cli-cmd-send-about = Envia estudos ou séries locais (C-STORE)
cli-cmd-send-series-about = Envia uma série para um nó de destino
cli-cmd-send-study-about = Envia um estudo para um nó de destino
cli-cmd-serve-about = Executa o servidor DICOM
cli-cmd-storage-scp-about = Executa um listener Storage SCP
cli-cmd-tui-about = Abre a interface interativa no terminal
cli-flag-help = Exibe a ajuda
cli-flag-lang = Idioma da interface (tag BCP-47). Sobrescreve DICOM_NODE_LANG e o locale do sistema.
cli-flag-version = Exibe a versão
cli-heading-arguments = Argumentos:
cli-heading-commands = Comandos:
cli-heading-options = Opções:
cli-heading-usage = Uso:
cli-import-accepted = accepted={ $n }
cli-import-complete = Importação concluída
cli-import-duplicates = duplicates={ $n }
cli-import-scanned = scanned={ $n }
cli-msg-cancel-sigint = Cancelamento solicitado (SIGINT). Aguardando encerramento gracioso...
cli-msg-failures = failures:
cli-msg-import-failed = Importação falhou: { $error }
cli-msg-no-local-series = Nenhum indexado series for study { $uid }
cli-msg-no-local-studies = Nenhum indexado local studies
cli-msg-no-saved-nodes = Nenhum nó salvo
cli-msg-query-failed = Consulta falhou: { $error }
cli-msg-removed-nodes =
    Removido { $count ->
        [one] { $count } nó
       *[other] { $count } nós
    }
cli-msg-results-count =
    Resultados: { $count ->
        [one] { $count } correspondência
       *[other] { $count } correspondências
    }
cli-msg-retrieve-failed = Recuperação falhou: { $error }
cli-msg-saved-node = Saved nó { $name } [{ $id }] => { $ae }@{ $host }:{ $port }
cli-msg-send-failed = Send falhou: { $error }
cli-msg-showing-failures = (exibindo as primeiras { $shown } de { $total } falhas)
cli-msg-starting-server =
    Iniciando servidor DICOM com { $count ->
        [one] { $count } AE local
       *[other] { $count } AEs locais
    }: { $aes }
cli-msg-starting-server-no-aes = Iniciando servidor DICOM sem AEs locais configurados
cli-msg-starting-storage-scp = Iniciando storage SCP em { $addr } com AE title { $ae }
cli-msg-updated-node = Updated nó { $name } [{ $id }] => { $ae }@{ $host }:{ $port }
cli-send-attempted = attempted={ $n }
cli-send-failed-count = failed={ $n }
cli-send-sent = sent={ $n }
cli-value-name-file = FILE
cli-value-name-format = FORMAT
cli-value-name-locale = LOCALE
cli-value-name-path = PATH
tui-detail-more-series =
    ... { $n ->
        [one] { $n } série a mais
       *[other] { $n } séries a mais
    }
tui-row-instance-count =
    { $n ->
        [one] { $n } instânc.
       *[other] { $n } instânc.
    }
tui-row-study-counts = { $series }s/{ $instances }i
count-nodes =
    { $n ->
        [one] { $n } nó
       *[other] { $n } nós
    }
count-instances =
    { $n ->
        [one] { $n } instância
       *[other] { $n } instâncias
    }
count-series =
    { $n ->
        [one] { $n } série
       *[other] { $n } séries
    }
count-studies =
    { $n ->
        [one] { $n } estudo
       *[other] { $n } estudos
    }
format-datetime = { $date } { $time }
format-date = { $day }/{ $month }/{ $year }

## Common
common-accession = Acesso
common-add = Adicionar
common-back = Voltar
common-bytes = bytes
common-cancel = Cancelar
common-clear = Limpar
common-close = Fechar
common-date = Data
common-delete = Excluir nó
common-description = Descrição
common-disabled = desabilitado
common-duplicates = Duplicatas
common-edit = Editar
common-enabled = habilitado
common-error = Erro
common-filter = Filtro
common-host = Endereço
common-import = Importar
common-instance = Instância
common-language = Idioma
common-loading = Carregando
common-matches = Correspondências
common-modality = Modalidade
common-name = Nome
common-network = Rede
common-no = não
common-none = nenhum
common-notes = Notas
common-optional = opcional
common-path = Origem
common-patient = Paciente
common-patient-id = ID do paciente
common-patient-name = Nome do paciente
common-port = Porta
common-query = Consultar
common-refresh = Atualizar
common-required = obrigatório
common-retrieve = Recuperar
common-save = Salvar
common-search = Pesquisar
common-send = Enviar
common-series = Séries
common-start = Iniciar
common-status = estado
common-stop = Parar
common-studies = Estudos
common-study = Estudo
common-unknown = desconhecido
common-unknown-series = <Séries>
common-unknown-study = <Estudos>
common-yes = sim

## Errors
error-ae-empty = o título AE não pode estar vazio
error-ae-invalid-char = o título AE contém o caractere inválido '{ $character }'; permitido: A-Z, 0-9, espaço
error-ae-required = o título AE é obrigatório
error-ae-too-long = o título AE deve ter no máximo 16 caracteres
error-ae-whitespace = o título AE não pode ter espaços no início ou no fim
error-archive-patient-retrieve-out-of-scope = retrieve no nível Patient está fora do escopo
error-archive-retrieve-uid-required = { $name } é obrigatório para este nível de retrieve
error-archive-study-root-patient-query = consultas Study Root não suportam o nível Patient
error-archive-study-root-patient-retrieve = retrieve Study Root não suporta o nível Patient
error-assoc-negotiation-failed = a negociação da associação falhou com { $name } ({ $addr }); dica: verifique o called AE title, os presentation contexts/transfer syntaxes e se o peer aceita associações
error-assoc-no-addresses = nenhum endereço de socket resolvido para { $name } em { $host }:{ $port }
error-assoc-receive = recebimento da associação
error-assoc-resolving = resolvendo { $name } em { $host }:{ $port }: { $err }
error-assoc-timeout = tempo esgotado aguardando resposta DIMSE; dica: verifique a rede, AE title/host/porta e a responsividade do peer
error-assoc-transport = interrupção de transporte ao aguardar resposta DIMSE; dica: o peer fechou a conexão ou um equipamento de rede a reiniciou
error-assoc-unreachable = não foi possível alcançar { $name } [{ $ae }] em { $host }:{ $port } em { $seconds }s: { $err }. Verifique host/IP, porta e alcance de rede
error-cancel-sigint = Cancelamento solicitado (SIGINT). Aguardando encerramento gracioso...
error-config-must-be-positive = configuração inválida: { $name } deve ser > 0 (ou null para desativar)
error-config-duplicate-bind-port = configuração inválida: porta de bind duplicada da AE local { $port }
error-config-local-ae-max-assoc = configuração inválida: AE local { $title } max_concurrent_associations deve ser > 0
error-config-local-ae-no-services = configuração inválida: AE local { $title } deve habilitar pelo menos um serviço
error-config-must-be-positive-required = configuração inválida: { $name } deve ser > 0
error-dicom-meta-incomplete = o file meta DICOM está incompleto
error-dicom-patient-move-unsupported = C-MOVE em nível de paciente não é suportado por este cliente
error-dicom-required-attribute = atributo DICOM obrigatório ausente: ({ $group },{ $element })
error-dicom-series-uid-required-image = series_instance_uid é obrigatório na recuperação em nível de imagem
error-dicom-series-uid-required-series = series_instance_uid é obrigatório na recuperação em nível de série
error-dicom-sop-uid-required-image = sop_instance_uid é obrigatório na recuperação em nível de imagem
error-dicom-study-uid-required = study_instance_uid é obrigatório
error-dicom-validating-move = validando a requisição de move
error-export-creating-file = criando arquivo de exportação { $path }: { $err }
error-export-flushing-series-csv = descarregando CSV de séries: { $err }
error-export-flushing-studies-csv = descarregando CSV de estudos: { $err }
error-export-serializing-series-json = serializando JSON de séries: { $err }
error-export-serializing-studies-json = serializando JSON de estudos: { $err }
error-export-writing-series-csv-header = escrevendo cabeçalho CSV de séries: { $err }
error-export-writing-series-csv-row = escrevendo linha CSV de séries: { $err }
error-export-writing-studies-csv-header = escrevendo cabeçalho CSV de estudos: { $err }
error-export-writing-studies-csv-row = escrevendo linha CSV de estudos: { $err }
error-import-cleanup-failed = { $source }: falha na limpeza: { $reason }
error-import-corrupt-zip = ZIP corrompido: { $details }
error-import-dicom-parse-failed = falha no parse DICOM: { $err }
error-import-dicom-validation-failed = falha na validação DICOM: { $err }
error-import-duplicate-zip-path = o ZIP contém várias entradas apontando para '{ $path }'
error-import-file-too-large = arquivo grande demais: { $details }
error-import-invalid-dicom = DICOM inválido: { $details }
error-import-limit-exceeded = { $limit } excedido: { $details }
error-import-not-regular-file = não é um arquivo regular
error-import-opening-file = abrindo arquivo: { $err }
error-import-opening-kind = abrindo { $kind } { $path }
error-import-opening-staged-file = abrindo arquivo em staging: { $err }
error-import-opening-zip-archive = abrindo arquivo ZIP { $path }
error-import-opening-zip-entry = abrindo entrada ZIP: { $err }
error-import-opening-zip-file = abrindo arquivo ZIP de importação { $path }
error-import-path-does-not-exist = O caminho de importação não existe: { $path }
error-import-reading-directory = lendo diretório de importação { $path }
error-import-reading-file = lendo arquivo: { $err }
error-import-reading-file-metadata = lendo metadados do arquivo { $path }
error-import-reading-metadata = lendo metadados de { $kind } { $path }
error-import-reading-zip-entry = lendo entrada ZIP: { $err }
error-import-removing-staged-after-cancel = removendo arquivo em staging após cancelamento { $path }
error-import-skipped = { $source }: ignorado: { $reason }
error-import-unreadable = Arquivo ilegível: { $details }
error-import-unsafe-zip-path = o caminho da entrada escapa do arquivo
error-import-zip-entry-count-exceeded = limite de entradas ZIP excedido: o arquivo tem { $count } entradas, o limite é { $limit }
error-import-zip-entry-size-exceeded = tamanho da entrada ZIP { $size } excede o limite { $limit }
error-import-zip-total-bytes-exceeded = limite de bytes extraídos do ZIP excedido: total atual { $current } mais o tamanho da entrada { $entry } excede o limite { $limit }
error-net-binding-storage-scp = vinculando o Storage SCP em { $addr } para o AE { $ae }. Outro receptor DICOM local já pode estar usando essa porta. Atualize storage_scp_port/local_aes em { $config } ou pare o listener em conflito
error-net-building-file-meta = montando a tabela de file meta
error-net-cannot-send-transfer-syntax = não é possível enviar a transfer syntax de origem { $source } com a transfer syntax negociada { $negotiated }
error-net-cget-dataset-empty = o dataset C-GET C-STORE codificado está vazio
error-net-cget-dataset-odd-length = o dataset C-GET C-STORE codificado terminou com um fragmento final de comprimento ímpar
error-net-cget-peer-released = o peer liberou a associação durante C-GET
error-net-cget-store-unexpected-dataset = fragmento de dataset inesperado na resposta C-GET C-STORE
error-net-cget-unexpected-command = comando inesperado 0x{ $command } ao aguardar C-STORE-RSP
error-net-cget-unexpected-pdu = PDU inesperado durante a suboperação C-GET C-STORE: { $pdu }
error-net-creating-incoming-dir = criando o diretório .incoming do Storage SCP
error-net-creating-path = criando { $path }
error-net-dataset-empty = o dataset codificado está vazio, mas COMMAND_DATA_SET_TYPE indica que um dataset é obrigatório
error-net-dataset-odd-length = o dataset codificado terminou com um fragmento final de comprimento ímpar
error-net-dimse-failed = { $operation } falhou com status 0x{ $status } ({ $meaning }){ $hint }
error-net-establishing-assoc = estabelecendo a associação do Storage SCP
error-net-file-meta-length = lendo o comprimento de File Meta Information
error-net-file-meta-tag = lendo a tag de File Meta Information
error-net-file-meta-value = ignorando o valor de File Meta Information
error-net-file-meta-vr = lendo o VR de File Meta Information
error-net-file-position = lendo a posição do arquivo
error-net-flushing-path = descarregando { $path }
error-net-flushing-temp-dataset = descarregando o arquivo temporário de dataset
error-net-hint-suffix = ; dica: { $hint }
error-net-incomplete-command = incompleto { $operation } resposta de comando
error-net-incomplete-identifier = incompleto { $operation } identificador de resposta
error-net-invalid-affected-sop = inválido { $operation } affected SOP class UID
error-net-invalid-status = inválido { $operation } status
error-net-listener-address = lendo o endereço do listener do Storage SCP
error-net-listener-nonblocking = definindo o listener em modo nonblocking
error-net-listener-port = lendo a porta do listener do Storage SCP
error-net-local-aes-empty = local_aes deve conter pelo menos um AE para iniciar o Storage SCP
error-net-locating-dataset = localizando o dataset em { $path }
error-net-malformed-dimse = malformada { $operation } resposta DIMSE: { $details }; dica: o peer enviou um command set DIMSE inválido ou inesperado
error-net-missing-affected-sop = ausente { $operation } affected SOP class UID
error-net-missing-command-field = campo de comando ausente
error-net-missing-cstore-rsp-command-field = campo de comando da resposta C-STORE ausente
error-net-missing-cstore-rsp-status = status da resposta C-STORE ausente
error-net-missing-destination = destino C-MOVE ausente
error-net-missing-dicm = marcador DICM Part 10 ausente
error-net-missing-message-id = ausente { $operation } message id
error-net-missing-qr-level = { $operation } identificador está sem QueryRetrieveLevel
error-net-missing-required-command-field = campo de comando obrigatório ausente { $name } ({ $tag })
error-net-missing-status = ausente { $operation } status
error-net-move-destination-unresolved = move_destination não foi resolvido
error-net-no-cget-store-context = nenhum presentation context de armazenamento C-GET negociado para SOP Class { $sop } e transfer syntax { $syntax }
error-net-no-compatible-context = { $path }: nenhum presentation context negociado compatível para a transfer syntax de origem { $syntax }
error-net-no-dimse-provider = nenhum provedor DIMSE registrado para o comando 0x{ $command } e abstract syntax { $syntax }
error-net-no-presentation-context = nenhum presentation context negociado
error-net-no-presentation-context-for-file = { $path }: nenhum presentation context negociado
error-net-no-presentation-context-id = presentation context negociado ausente { $id }
error-net-opening-path = abrindo { $path }
error-net-part10-preamble = lendo o preâmbulo Part 10
error-net-path-error = { $path }: { $err }
error-net-pdata-feed-complete = não é possível alimentar um fragmento P-DATA em um acumulador completo (take() ausente)
error-net-peer-aborted = o peer abortou a associação durante a suboperação C-GET C-STORE: { $source }
error-net-peer-socket = lendo o endereço de socket do peer do Storage SCP
error-net-reading-command-dataset = lendo o dataset de comando
error-net-reading-identifier = lendo { $operation } identificador
error-net-reading-incoming-dataset = lendo o dataset C-STORE de entrada
error-net-reading-response-dataset = lendo { $operation } dataset de resposta
error-net-remote-aborted = o remoto abortou a associação: { $source }
error-net-restoring-read-timeout = restaurando o timeout de leitura da associação
error-net-restoring-write-timeout = restaurando o timeout de escrita da associação
error-net-rewinding-dataset = voltando ao primeiro elemento do dataset
error-net-scp-thread-panicked = a thread do Storage SCP entrou em pânico
error-net-seeking-temp-dataset = posicionando o arquivo temporário de dataset
error-net-serializing-cget-dataset = serializando o dataset da suboperação C-GET para { $path }
error-net-serializing-dataset = serializando o dataset para { $path } com transfer syntax { $syntax }
error-net-setting-socket-blocking = definindo o socket de armazenamento aceito em modo blocking
error-net-sending-buffered-dataset = enviando o dataset em buffer para { $path }
error-net-store-status = o remoto devolveu status C-STORE 0x{ $status } ({ $meaning }){ $hint }
error-net-streaming-dataset = transmitindo o dataset C-STORE
error-net-unexpected-command-field = CommandField inesperado 0x{ $actual } (esperado 0x{ $expected } for { $rsp })
error-net-unexpected-dataset-fragment = fragmento de dataset inesperado na resposta C-STORE
error-net-unexpected-pdu = PDU inesperado durante { $operation }: { $pdu }
error-net-unknown-status = desconhecido ou inválido { $operation } status 0x{ $status }
error-net-unsupported-model-sop = não suportado { $operation } model SOP class UID: { $uid }
error-net-unsupported-qr-level = QueryRetrieveLevel não suportado: { $level }
error-net-unsupported-transfer-syntax = transfer syntax negociada não suportada
error-net-writing-command-dataset = escrevendo o dataset de comando
error-net-writing-identifier = escrevendo { $operation } identificador
error-net-writing-path = escrevendo { $path }
error-net-writing-response-dataset = escrevendo { $operation } dataset de resposta
error-net-writing-temp-dataset = escrevendo bytes do dataset no arquivo temporário
error-node-host-empty = o host do nó não pode estar vazio
error-node-name-empty = o nome do nó não pode estar vazio
error-node-not-found = nó remoto não encontrado: { $id }
error-operation-cancelled = operação cancelada
error-port-invalid = porta inválida: { $value }
error-port-range = a porta deve estar entre 1 e 65535
error-query-no-study-uid = O resultado não tem StudyInstanceUID; não é possível recuperar.
error-query-unsupported-level = nível de consulta não suportado: { $value }
error-query-unsupported-model = modelo de consulta não suportado: { $value }
error-retrieve-canceled = a recuperação foi cancelada pelo nó remoto (status=0x{ $status }, completed={ $completed }, failed={ $failed }, warning={ $warning }, remaining={ $remaining }, { $scp })
error-retrieve-failed = a recuperação falhou com status=0x{ $status } (completed={ $completed }, failed={ $failed }, warning={ $warning }, remaining={ $remaining }, { $scp })
error-retrieve-nothing-arrived = a recuperação terminou para o destino { $destination } com completed={ $completed }, mas nada chegou ao Storage SCP local ({ $scp }). Verifique o mapeamento de AE ou a porta: confirme que { $listener } está livre e que o nó remoto mapeia o AE { $destination } para este aplicativo
error-send-no-files-series = nenhum arquivo local indexado para a série { $uid }
error-send-no-files-study = nenhum arquivo local indexado para o estudo { $uid }
error-task-cancelled = Tarefa cancelada
error-task-none-to-cancel = Nenhuma tarefa ativa para cancelar (nada está em execução)
error-tracing-init = inicializando o subscriber de tracing: { $err }
error-uid-component-numeric = componente UID '{ $part }' deve ser numérico
error-uid-component-too-long = componente UID '{ $part }' é longo demais
error-uid-dot-ends = UID não pode começar ou terminar com ponto
error-uid-empty = UID não pode estar vazio
error-uid-empty-component = UID não pode conter componentes vazios
error-uid-leading-zeros = componente UID '{ $part }' não pode ter zeros à esquerda
error-uid-too-long = UID deve ter no máximo 64 caracteres

## TUI
tui-bool-no = não
tui-bool-off = desligado
tui-bool-on = ligado
tui-bool-yes = sim
tui-command-placeholder = Digite um comando ou use os atalhos do painel.
tui-config-ae-title = Título AE: { $value }
tui-config-edit-hint = Pressione Tab para focar este painel e depois 'c' para editar.
tui-config-hint = Pressione Tab para focar este painel e depois 'c' para editar.
tui-config-listener = Escutador: { $value }
tui-config-max-pdu = max_pdu_length: { $value }
tui-config-promiscuous = allow_promiscuous_storage: { $value }
tui-config-strict-pdu = strict_pdu: { $value }
tui-config-ts-pref = Preferência de TS: { $value }
tui-controls-hint = Tab campos · Enter confirma · Esc cancela
tui-detail-ae-title = Título AE
tui-detail-instance = Detalhe da instância
tui-detail-name = Nome
tui-detail-node = Detalhe do nó
tui-detail-placeholder-followup = Mude o foco para um painel de lista e mova a seleção para atualizar esta visão.
tui-detail-query = Detalhe do resultado da consulta
tui-detail-select-node = Selecione um nó remoto para inspecionar os metadados.
tui-detail-series = Detalhe da série
tui-detail-study = Detalhe do estudo
tui-empty-command-placeholder = Digite um comando ou use os atalhos do painel.
tui-empty-detail-instance = Selecione uma instância para inspecioná-la, ou volte às séries com Esc.
tui-empty-detail-node = Selecione um nó remoto para inspecionar os metadados.
tui-empty-detail-query = Selecione um resultado de consulta para inspecionar metadados e o contexto de retrieve.
tui-empty-detail-series = Selecione uma série para inspecioná-la, ou volte aos estudos com Esc.
tui-empty-detail-study = Selecione um estudo local para inspecionar metadados de paciente e séries.
tui-empty-instances =
    Não há instâncias indexadas para esta série.
    
    Pressione Esc para voltar às séries.
tui-empty-instances-hint = Pressione Esc para voltar às séries.
tui-empty-local-instances =
    Não há instâncias indexadas para esta série.
    
    Pressione Esc para voltar às séries.
tui-empty-local-instances-hint = Pressione Esc para voltar às séries.
tui-empty-local-series =
    Não há séries indexadas para este estudo.
    
    Pressione Esc para voltar aos estudos locais.
tui-empty-local-series-hint = Pressione Esc para voltar aos estudos locais.
tui-empty-local-studies =
    Ainda não há estudos indexados.
    
    Importe arquivos DICOM locais primeiro.
    Exemplo: import path=/data/inbox
tui-empty-local-studies-cmd = Exemplo: import path=/data/inbox
tui-empty-local-studies-hint = Importe arquivos DICOM locais primeiro.
tui-empty-no-name = <sem nome>
tui-empty-query = Nenhuma consulta foi executada ainda.
tui-empty-query-body =
    Selecione um nó remoto e pressione 'f' para consultar.
    Ou: query node=pacs
        patient_name="DOE^JOHN"
    Pressione 'm' em um resultado selecionado para abrir a recuperação.
tui-empty-query-cmd = Ou: query node=pacs
tui-empty-query-hint = Selecione um nó remoto e pressione 'f' para consultar.
tui-empty-query-last-target = Último alvo da consulta: { $name }
tui-empty-query-none = Nenhuma consulta foi executada ainda.
tui-empty-query-retrieve-hint = Pressione 'm' em um resultado selecionado para abrir a recuperação.
tui-empty-remote-nodes =
    Nenhum nó remoto foi salvo ainda.
    
    Pressione 'a' neste painel para adicionar um.
    Ou: node add name=pacs
        ae=PACSAE host=10.0.0.10
        port=104
tui-empty-remote-nodes-cmd = Ou: node add name=pacs
tui-empty-remote-nodes-hint = Pressione 'a' neste painel para adicionar um.
tui-empty-series =
    Não há séries indexadas para este estudo.
    
    Pressione Esc para voltar aos estudos locais.
tui-empty-series-hint = Pressione Esc para voltar aos estudos locais.
tui-empty-studies =
    Ainda não há estudos indexados.
    
    Importe arquivos DICOM locais primeiro.
    Exemplo: import path=/data/inbox
tui-empty-studies-hint = Importe arquivos DICOM locais primeiro.
tui-empty-tasks-history = Sem histórico de tarefas.
tui-empty-tasks-queued = Nenhuma tarefa na fila.
tui-fallback-no-name = <sem nome>
tui-field-accession = Número de acesso
tui-field-ae-title = Título AE
tui-field-bind-addr = Endereço de bind
tui-field-date-from = Data inicial
tui-field-date-to = Data final
tui-field-destination-node = Nó de destino
tui-field-host = Endereço
tui-field-instance-uid = Instance UID
tui-field-kind = Tipo
tui-field-level = Nível
tui-field-local-ae = AE local
tui-field-max-pdu = PDU máx.
tui-field-modality = Modalidade
tui-field-model = Modelo
tui-field-move-destination = Destino do Move
tui-field-name = Nome
tui-field-notes = Notas
tui-field-path = Caminho
tui-field-patient-id = ID do paciente
tui-field-patient-name = Nome do paciente
tui-field-port = Porta
tui-field-promiscuous = Armazenamento promíscuo
tui-field-series-uid = Series UID
tui-field-sop-uid = SOP Instance UID
tui-field-strict-pdu = PDU estrito
tui-field-study-description = Descrição do estudo
tui-field-study-uid = Study UID
tui-footer-back-series = Esc voltar às séries
tui-footer-back-studies = Esc voltar aos estudos
tui-footer-cancel-task = c cancelar
tui-footer-edit-config = c editar config
tui-footer-enter-series = Enter séries
tui-footer-esc-series = Esc voltar às séries
tui-footer-esc-studies = Esc voltar aos estudos
tui-footer-help = F1/? ajuda
tui-footer-inspect = Enter inspecionar
tui-footer-next = Próximo: { $text }
tui-footer-nodes = a/e/d/f nós
tui-footer-panes = Tab painéis
tui-footer-queued =
    { $n ->
        [one] { $n } na fila
       *[other] { $n } na fila
    }
tui-footer-quit = q sair
tui-footer-refresh = r atualizar
tui-footer-retrieve = m recuperar
tui-footer-run-command = Enter executar comando
tui-footer-task-scope = t fila/histórico
tui-form-add-node = Adicionar nó remoto
tui-form-add-remote-node = Adicionar nó remoto
tui-form-delete-confirm = Excluir o nó remoto { $name } [{ $ae }] em { $host }:{ $port }?
tui-form-delete-node = Excluir nó remoto
tui-form-delete-remote-node = Excluir nó remoto
tui-form-edit-node = Editar nó remoto
tui-form-edit-remote-node = Editar nó remoto
tui-form-err-ae-required = ! o título AE é obrigatório
tui-form-err-bind-required = ! o endereço de bind é obrigatório
tui-form-err-host-required = ! o host é obrigatório
tui-form-err-local-ae-invalid = ! título AE local inválido: { $err }
tui-form-err-local-ae-required = ! o título AE local é obrigatório
tui-form-err-modality-empty = a modalidade não pode estar vazia
tui-form-err-move-dest-invalid = ! título AE de destino do Move inválido: { $err }
tui-form-err-name-required = ! o nome do nó é obrigatório
tui-form-err-port-required = ! a porta é obrigatória
tui-form-err-uid-empty = o UID não pode estar vazio
tui-form-err-uid-empty-component = o UID não pode conter componentes vazios
tui-form-error-line = Erro: { $error }
tui-form-field-accession = Número de acesso
tui-form-field-ae-title = Título AE
tui-form-field-bind-addr = Endereço de bind
tui-form-field-date-from = Data inicial
tui-form-field-date-to = Data final
tui-form-field-dest-node = Nó de destino
tui-form-field-destination = AE de destino
tui-form-field-host = Endereço
tui-form-field-instance-uid = SOP Instance UID
tui-form-field-kind = Tipo
tui-form-field-level = Nível
tui-form-field-local-ae = AE local
tui-form-field-modality = Modalidade
tui-form-field-model = Modelo
tui-form-field-move-dest = Destino do Move
tui-form-field-name = Nome
tui-form-field-notes = Notas
tui-form-field-path = Caminho
tui-form-field-patient-id = ID do paciente
tui-form-field-patient-name = Nome do paciente
tui-form-field-port = Porta
tui-form-field-series-uid = Series Instance UID
tui-form-field-sop-uid = SOP Instance UID
tui-form-field-study-desc = Descrição do estudo
tui-form-field-study-uid = Study Instance UID
tui-form-field-uid = UID
tui-form-hint-bind = dica: em geral 0.0.0.0 (todas as interfaces) ou 127.0.0.1
tui-form-hint-local-ae = dica: até 16 caracteres (A-Z, 0-9, espaço), ex. ARCHIVE_AE
tui-form-hint-move-dest = dica: opcional; sobrescreve o título AE de destino do C-MOVE
tui-form-hint-name = dica: um rótulo curto (ex.: PACS)
tui-form-import = Importar arquivos locais
tui-form-import-local = Importar arquivos locais
tui-form-import-local-files = Importar arquivos locais
tui-form-mode-add = Modo: criar um novo nó remoto
tui-form-mode-edit = Modo: atualizar o nó remoto selecionado
tui-form-query-node = Consultar nó remoto
tui-form-query-remote-node = Consultar nó remoto
tui-form-remote-node-line = Nó remoto: { $name } [{ $ae }] { $host }:{ $port }
tui-form-retrieve = Recuperar correspondências
tui-form-retrieve-matches = Recuperar correspondências
tui-form-send-series = Enviar série
tui-form-send-study = Enviar estudo
tui-form-storage-intro = Edite as configurações locais do Storage SCP (salvas em config.json).
tui-form-storage-scp = Configurações do Storage SCP
tui-form-storage-scp-settings = Configurações do Storage SCP
tui-help-ae-title = Título AE: { $value }
tui-help-aedf = a/e/d/f     Adicionar, editar, excluir ou consultar a partir do nó selecionado
tui-help-c = c           Editar Storage SCP (quando o foco está em Configuração)
tui-help-canonical-names = Os nomes canônicos coincidem com as flags da CLI sem '--', usando underscores.
tui-help-close = Feche a ajuda com Esc, F1 ou ?.
tui-help-common-commands = Comandos comuns
tui-help-config = c           Editar Storage SCP (quando o foco está em Configuração)
tui-help-config-path = Caminho da config: { $value }
tui-help-current-config = Configuração atual
tui-help-data-dir = Diretório de dados: { $value }
tui-help-enter-default = Enter       Executar o comando, confirmar o modal ou abrir séries dos Estudos locais
tui-help-enter-instance = Enter       Nenhuma ação do painel Local na visão de instâncias
tui-help-enter-local-instance = Enter       Nenhuma ação do painel Local na visão de instâncias
tui-help-enter-local-series = Enter       Abrir instâncias da série local selecionada, ou executar o comando / confirmar o modal
tui-help-enter-local-study = Enter       Abrir séries do estudo local selecionado, ou executar o comando / confirmar o modal
tui-help-enter-series = Enter       Abrir instâncias da série local selecionada, ou executar o comando / confirmar o modal
tui-help-enter-study = Enter       Abrir séries do estudo local selecionado, ou executar o comando / confirmar o modal
tui-help-esc-default = Esc         Fechar ajuda/modal, voltar das séries locais ou focar o comando
tui-help-esc-instance = Esc         Voltar das instâncias locais às séries, fechar ajuda/modal ou focar o comando
tui-help-esc-instances = Esc         Voltar das instâncias locais às séries, fechar ajuda/modal ou focar o comando
tui-help-esc-series = Esc         Voltar das séries locais aos estudos, fechar ajuda/modal ou focar o comando
tui-help-f1 = F1 ou ?     Abrir ajuda
tui-help-import-send = i/s         Importar arquivos locais ou enviar estudo/série selecionado
tui-help-is = i/s         Importar arquivos locais ou enviar estudo/série selecionado
tui-help-listener = Escutador: { $value }
tui-help-log-dir = Diretório de logs: { $value }
tui-help-m = m           Recuperar a partir do resultado de consulta selecionado
tui-help-max-pdu = max_pdu_length: { $value }
tui-help-move = Up/Down ou j/k   Mover seleção nos painéis de lista
tui-help-nodes = a/e/d/f     Adicionar, editar, excluir ou consultar a partir do nó selecionado
tui-help-open = F1 ou ?     Abrir ajuda
tui-help-promiscuous = allow_promiscuous_storage: { $value }
tui-help-q = q           Sair quando não houver modal e o foco não estiver no comando
tui-help-quit = q           Sair quando não houver modal e o foco não estiver no comando
tui-help-r = r           Atualizar painéis quando o foco não está no comando
tui-help-receiver-mode = Modo do receptor: { $value }
tui-receiver-mode-on-demand = sob demanda para retrieve local
tui-receiver-mode-standalone = autônomo via storage-scp
tui-help-refresh = r           Atualizar painéis quando o foco não está no comando
tui-help-retrieve = m           Recuperar a partir do resultado de consulta selecionado
tui-help-strict-pdu = strict_pdu: { $value }
tui-help-tab = Tab / Shift-Tab  Mudar painel em foco
tui-help-title = Atalhos
tui-help-ts-pref = preferred_store_transfer_syntax: { $value }
tui-help-updown = Up/Down ou j/k   Mover seleção nos painéis de lista
tui-input-placeholder = Digite um comando ou use os atalhos do painel.
tui-log-command = > { $command }
tui-log-error = erro: { $error }
tui-log-refreshed = atualizado
tui-logs-capped-suffix = limitado
tui-logs-label = Registros:
tui-pane-command = Comando
tui-pane-config = Configuração
tui-pane-detail = Detalhe
tui-pane-detail-hint = { $title } (PgUp/PgDn quando não estiver digitando)
tui-pane-help = Ajuda
tui-pane-instance-detail = Detalhe da instância
tui-pane-instances-for = Instâncias de: { $uid }
tui-pane-local-studies = Estudos locais
tui-pane-logs = Logs
tui-pane-logs-capped = Logs ({ $shown }/{ $total } limitado)
tui-pane-logs-uncapped = Registros ({ $shown }/{ $total })
tui-pane-node-detail = Detalhe do nó
tui-pane-query-detail = Detalhe do resultado da consulta
tui-pane-query-node = Consultar nó
tui-pane-query-result-detail = Detalhe do resultado da consulta
tui-pane-query-results = Resultados de consulta / recuperação
tui-pane-query-retrieve-results = Resultados de consulta / recuperação
tui-pane-remote-nodes = Nós remotos
tui-pane-series-detail = Detalhe da série
tui-pane-series-for = Séries de: { $uid }
tui-pane-series-unknown = Séries de: <estudo desconhecido>
tui-pane-study-detail = Detalhe do estudo
tui-pane-task-details = Detalhe da tarefa
tui-pane-tasks-history = Tarefas (histórico)
tui-pane-tasks-queued = Tarefas (fila)
tui-pane-unknown-series = <série desconhecida>
tui-pane-unknown-study = Séries de: <estudo desconhecido>
tui-row-inst = inst
tui-status-cancel-requested = Cancelamento solicitado
tui-status-config = Configuração
tui-status-configured-listener = Listener configurado { $addr } como AE { $ae } ({ $mode })
tui-status-data = dados
tui-status-failure = falha: { $failure }
tui-status-listener = escutador
tui-status-local-ae = AE local
tui-status-mode = Modo
tui-status-mode-on-demand = sob demanda
tui-status-mode-standalone = autônomo
tui-status-no-active-task = Nenhuma tarefa ativa para cancelar (nada em execução)
tui-status-pdu = PDU
tui-status-promiscuous = Armazenamento promíscuo
tui-status-query-before-retrieve = consulte um nó remoto primeiro para a recuperação saber qual nó usar
tui-status-query-failed = a consulta falhou: { $error }
tui-status-queued-op = Operação na fila: { $op }
tui-status-retrieve-failed = a recuperação falhou: { $error }
tui-status-retrieve-open-failed = não foi possível abrir o fluxo de recuperação: { $error }
tui-status-saved-node = nó { $name } ({ $id }) salvo
tui-status-saved-scp = configurações do Storage SCP salvas (é necessário reiniciar)
tui-status-select-node = selecione um nó remoto primeiro
tui-status-select-query = selecione um resultado de consulta primeiro
tui-status-select-study = selecione um estudo local primeiro
tui-status-strict = Rigoroso
tui-status-task-cancelled = Tarefa cancelada
tui-status-task-cancelled-detail = Tarefa cancelada: { $other }
tui-status-ts-pref = Pref. TS
tui-status-updated-node = nó { $name } ({ $id }) atualizado
tui-suggest-back-series = Esc — voltar às séries
tui-suggest-edit-config = c — editar configuração
tui-suggest-help = F1/? — ajuda
tui-suggest-inspect-task = Enter — inspecionar tarefa
tui-suggest-node-add = node add <ae-title> <host:port>
tui-suggest-query = f — consultar um nó
tui-suggest-query-node = f — consultar nó selecionado
tui-suggest-retrieve = m — recuperar selecionado
tui-suggest-run-command = Enter — executar comando
tui-suggest-send-series = s — enviar série selecionada
tui-suggest-view-series = Enter — ver séries
tui-task-cancelled = cancelada
tui-task-cancelling = Cancelando
tui-task-failed = falhou
tui-task-failed-generic = Tarefa falhou: { $error }
tui-task-import-done = Importação concluída: { $report }
tui-task-import-failed = Importação falhou: { $error }
tui-task-importing = Importando { $path }...
tui-task-query-done =
    Consulta concluída: { $count ->
        [one] { $count } correspondência
       *[other] { $count } correspondências
    }
tui-task-query-failed = Consulta falhou: { $error }
tui-task-querying = Consultando { $node }...
tui-task-queued = Na fila
tui-task-retrieve-done = Recuperação concluída: { $outcome }
tui-task-retrieve-failed = Recuperação falhou: { $error }
tui-task-retrieving = Recuperando de { $node }...
tui-task-running = Em execução
tui-task-sending-series = Enviando série { $uid } para { $node }...
tui-task-sending-study = Enviando estudo { $uid } para { $node }...
tui-task-send-done = Envio concluído: { $outcome }
tui-task-status-cancelled = cancelado
tui-task-status-cancelling = cancelando
tui-task-status-failed = falhou
tui-task-status-ok = ok
tui-task-status-queued = na fila
tui-task-status-running = em execução
tui-task-succeeded = ok
tui-terminal-too-small = Terminal pequeno demais — redimensione a janela

## Desktop
desktop-action-activity = Atividade { $count }
desktop-action-activity-empty = Atividade
desktop-action-import = Importar
desktop-action-inspect-archive = Inspecionar arquivo local
desktop-action-inspect-archive-desc = Revise estudos, séries e instâncias; depois envie ou exporte.
desktop-action-manage-peers = Gerenciar peers
desktop-action-manage-peers-desc = Adicione e edite nós PACS ou estações usados em query, retrieve e store.
desktop-action-monitor-scp = Monitorar Storage SCP
desktop-action-query = Consultar
desktop-action-refresh = Atualizar status
desktop-action-refresh-status = Atualizar status
desktop-action-reveal-log = Mostrar arquivo de log
desktop-action-send = Enviar
desktop-action-start-scp = Iniciar Storage SCP
desktop-activity-empty = Nenhuma atividade nesta sessão ainda.
desktop-activity-title = Atividade
desktop-app-title = DICOM Node
desktop-archive-csv = CSV
desktop-archive-details = Detalhes
desktop-archive-empty = O arquivo local está vazio.
desktop-archive-export-fail = Exportação de { $scope } falhou
desktop-archive-export-ok =
    { $rows ->
        [one] Exportada { $rows } linha de { $scope } para { $path }.
       *[other] Exportadas { $rows } linhas de { $scope } para { $path }.
    }
desktop-archive-export-studies = Exportar estudos
desktop-archive-export-title = Exportar { $scope }
desktop-archive-filter = Filtrar por paciente, UID, descrição, modalidade…
desktop-archive-filter-placeholder = Filtrar por paciente, UID, descrição, modalidade…
desktop-archive-inst-abbrev = { $count } instânc.
desktop-archive-instance-meta = { $bytes } · TS { $ts } · importado { $imported }
desktop-archive-instances = Instâncias
desktop-archive-instances-heading = Instâncias
desktop-archive-json = JSON
desktop-archive-loading = Carregando estudos…
desktop-archive-no-filter-match = Nenhum estudo corresponde ao filtro.
desktop-archive-no-instances = Nenhuma instância encontrada.
desktop-archive-no-match = Nenhum estudo corresponde ao filtro.
desktop-archive-no-nodes = Nenhum nó
desktop-archive-no-series = Nenhuma série encontrada.
desktop-archive-reveal-file = Mostrar arquivo
desktop-archive-select-series = Selecione uma série.
desktop-archive-select-study = Selecione um estudo.
desktop-archive-send-fail = { $label }: { $sent }/{ $attempted } enviadas, { $failed } falharam. { $failures }
desktop-archive-send-fail-title = { $label } falhou
desktop-archive-send-ok = { $label }: enviadas { $sent }/{ $attempted } instâncias.
desktop-archive-send-series = Enviar série
desktop-archive-send-series-label = Série → { $destination }
desktop-archive-send-study = Enviar estudo
desktop-archive-send-study-label = Estudo → { $destination }
desktop-archive-send-to = Enviar para
desktop-archive-series = Séries
desktop-archive-series-count =
    #{ $number } · { $count ->
        [one] { $count } instância
       *[other] { $count } instâncias
    }
desktop-archive-series-fallback = Séries
desktop-archive-studies = Estudos
desktop-archive-study-date = Data do estudo
desktop-archive-study-uid = Study UID
desktop-archive-subtitle = Inventário de estudos, séries e instâncias do arquivo SQLite local.
desktop-archive-title = Arquivo local
desktop-brand-title = DICOM Node
desktop-col-description = Descrição
desktop-col-instances = Instâncias
desktop-col-modalities = Modalidades
desktop-col-patient-id = ID do paciente
desktop-common-cancel = Cancelar
desktop-common-clear = Limpar
desktop-common-disabled = desabilitado
desktop-common-enabled = habilitado
desktop-common-loading = Carregando…
desktop-common-no = não
desktop-common-refresh = Atualizar
desktop-common-yes = sim
desktop-counter-assoc-accepted = Associações aceitas
desktop-counter-bytes-ingested = Bytes ingeridos
desktop-counter-cfind-requests = Requisições C-FIND
desktop-counter-cmove-requests = Requisições C-MOVE
desktop-counter-cstore-failed = C-STORE com falha
desktop-counter-cstore-stored = C-STORE armazenados
desktop-dashboard-counter-assoc-accepted = Associações aceitas
desktop-dashboard-counter-bytes-ingested = Bytes ingeridos
desktop-dashboard-counter-c-find-requests = Requisições C-FIND
desktop-dashboard-counter-c-move-requests = Requisições C-MOVE
desktop-dashboard-counter-c-store-failed = C-STORE com falha
desktop-dashboard-counter-c-store-stored = C-STORE armazenados
desktop-dashboard-empty-studies = Ainda não há estudos locais.
desktop-dashboard-inspect-archive-body = Revise estudos, entre em séries e instâncias e depois envie ou exporte.
desktop-dashboard-inspect-archive-title = Inspecionar arquivo local
desktop-dashboard-kv-ae-title = Título AE
desktop-dashboard-kv-data-dir = Dir. de dados
desktop-dashboard-kv-listener = escutador
desktop-dashboard-kv-log-file = Arquivo de log
desktop-dashboard-kv-max-pdu = PDU máx.
desktop-dashboard-kv-promiscuous = Armazenamento promíscuo
desktop-dashboard-kv-server = Servidor
desktop-dashboard-kv-store-syntax = Sintaxe de store
desktop-dashboard-kv-strict-pdu = PDU estrito
desktop-dashboard-listener-missing = Listener ainda não carregado.
desktop-dashboard-live-counters = Contadores ao vivo
desktop-dashboard-loading-metrics = Carregando métricas…
desktop-dashboard-loading-status = Carregando status local…
desktop-dashboard-loading-studies = Carregando estudos…
desktop-dashboard-local-node = Nó local
desktop-dashboard-manage-peers-body = Adicione e edite nós PACS ou estações usados em consulta, recuperação e store.
desktop-dashboard-manage-peers-title = Gerenciar peers
desktop-dashboard-metric-instances = Instâncias
desktop-dashboard-metric-nodes = Nós remotos
desktop-dashboard-metric-series = Séries
desktop-dashboard-metric-studies = Estudos
desktop-dashboard-monitor-scp = Monitorar Storage SCP
desktop-dashboard-recent-studies = Estudos recentes
desktop-dashboard-start-scp = Iniciar Storage SCP
desktop-dashboard-subtitle = Arquivo local, peers de rede e atividade do SCP em um relance.
desktop-dashboard-title = Painel do operador
desktop-doc-title = DICOM Node
desktop-import-accepted = Aceitos
desktop-import-accepted-bytes = Bytes aceitos
desktop-import-activity-detail = { $accepted }/{ $scanned } aceitos, { $duplicates } duplicatas, { $bytes }
desktop-import-activity-fail = Importação falhou
desktop-import-activity-ok = Importação concluída
desktop-import-choose-archive = Escolha um arquivo ZIP para importar
desktop-import-choose-dir = Escolha um diretório para importar
desktop-import-choose-folder = Pasta
desktop-import-choose-zip = Escolha um arquivo ZIP para importar
desktop-import-cleanup = Limpeza
desktop-import-clear-path = Limpar caminho
desktop-import-complete = Importação concluída
desktop-import-dup-sha = SHA-256
desktop-import-dup-sop = SOP UID
desktop-import-dup-total = total
desktop-import-duplicates = Duplicatas
desktop-import-failed = Importação falhou
desktop-import-failed-cleanup = Limpeza com falha
desktop-import-failures = Falhas
desktop-import-failures-heading =
    { $count ->
        [one] { $count } falha:
       *[other] { $count } falhas:
    }
desktop-import-failures-more = … e mais { $count }
desktop-import-files-progress = { $label } arquivos
desktop-import-folder = Pasta
desktop-import-invalid-dicom = DICOM inválido
desktop-import-pick-dir = Escolha um diretório para importar
desktop-import-pick-zip = Escolha um arquivo ZIP para importar
desktop-import-placeholder = /path/to/dicom-folder or /path/to/archive.zip
desktop-import-rejected = Rejeitados
desktop-import-report = Relatório de importação
desktop-import-running = Importando…
desktop-import-scanned = Varridos
desktop-import-skipped = Ignorados
desktop-import-source = Origem
desktop-import-start = Iniciar importação
desktop-import-stored = Armazenados
desktop-import-subtitle = Indexe arquivos DICOM de pastas recursivas ou arquivos ZIP no arquivo local gerenciado.
desktop-import-title = Importar
desktop-import-unreadable = Ilegível
desktop-import-zip = ZIP
desktop-import-zip-filter = Arquivos ZIP
desktop-lang-label = Idioma
desktop-listener-not-loaded = Listener ainda não carregado.
desktop-live-counters = Contadores ao vivo
desktop-loading = Carregando
desktop-loading-local-status = Carregando status local…
desktop-loading-metrics = Carregando métricas…
desktop-loading-studies = Carregando estudos…
desktop-local-node = Nó local
desktop-locale-label = Idioma
desktop-logs-activity-detail =
    { $count ->
        [one] { $count } linha carregada
       *[other] { $count } linhas carregadas
    }
desktop-logs-activity-fail = Falha ao atualizar o log
desktop-logs-activity-ok = Log atualizado
desktop-logs-auto = AUTOMÁTICO
desktop-logs-auto-refresh = Atualização automática
desktop-logs-empty = O arquivo de log está vazio.
desktop-logs-found = ARQUIVO DE LOG ENCONTRADO
desktop-logs-lines =
    { $count ->
        [one] { $count } linha
       *[other] { $count } linhas
    }
desktop-logs-loading = Carregando log…
desktop-logs-missing = O arquivo de log ativo ainda não foi criado.
desktop-logs-refresh-failed = Falha ao atualizar o log
desktop-logs-refreshed = Log atualizado
desktop-logs-reveal = Mostrar
desktop-logs-subtitle = Cauda limitada do arquivo de log ativo da área de trabalho.
desktop-logs-tail = Cauda
desktop-logs-title = registros
desktop-logs-truncated = TRUNCADO
desktop-logs-waiting = AGUARDANDO ARQUIVO DE LOG
desktop-metric-instances = Instâncias
desktop-metric-remote-nodes = Nós remotos
desktop-metric-series = Séries
desktop-metric-studies = Estudos
desktop-nav-archive = Arquivo local
desktop-nav-dashboard = Painel
desktop-nav-import = Importar
desktop-nav-logs = registros
desktop-nav-network = Rede
desktop-nav-nodes = Nós remotos
desktop-nav-query = Consulta / Recuperação
desktop-nav-server = Servidor de armazenamento
desktop-no-local-studies = Ainda não há estudos locais.
desktop-nodes-add = Adicionar nó
desktop-nodes-added = Nó "{ $name }" adicionado.
desktop-nodes-ae-length = O título AE deve ter 16 caracteres ou menos.
desktop-nodes-ae-title = Título AE
desktop-nodes-col-move = Dest. Move
desktop-nodes-configured = Nós configurados
desktop-nodes-confirm-delete = Excluir o nó "{ $name }"?
desktop-nodes-default-port = Porta padrão 104
desktop-nodes-delete = Excluir nó
desktop-nodes-delete-title = Excluir nó
desktop-nodes-deleted = Nó "{ $name }" excluído.
desktop-nodes-edit = Editar nó
desktop-nodes-edit-title = Editar nó
desktop-nodes-empty = Ainda não há nós remotos.
desktop-nodes-err-ae = O título AE é obrigatório.
desktop-nodes-err-ae-len = O título AE deve ter 16 caracteres ou menos.
desktop-nodes-err-host = O host é obrigatório.
desktop-nodes-err-name = O nome é obrigatório.
desktop-nodes-err-port = A porta deve estar entre 1 e 65535.
desktop-nodes-host = Endereço
desktop-nodes-move-dest = Destino do Move
desktop-nodes-move-placeholder = Padrão: AE local
desktop-nodes-name = Nome
desktop-nodes-need-ae = O título AE é obrigatório.
desktop-nodes-need-host = O host é obrigatório.
desktop-nodes-need-name = O nome é obrigatório.
desktop-nodes-notes = Notas
desktop-nodes-notes-placeholder = PACS da sala de laudo
desktop-nodes-placeholder-ae = PACS01
desktop-nodes-placeholder-host = 192.168.0.10
desktop-nodes-placeholder-move = Padrão: AE local
desktop-nodes-placeholder-name = main-pacs
desktop-nodes-placeholder-notes = PACS da sala de laudo
desktop-nodes-port = Porta
desktop-nodes-port-104 = Porta padrão 104
desktop-nodes-port-range = A porta deve estar entre 1 e 65535.
desktop-nodes-save = Salvar alterações
desktop-nodes-save-changes = Salvar alterações
desktop-nodes-subtitle = Peers PACS e estações para consulta, recuperação e store.
desktop-nodes-summary = Resumo dos nós
desktop-nodes-title = Nós remotos
desktop-nodes-total = Total de nós
desktop-nodes-updated = Nó "{ $name }" atualizado.
desktop-nodes-with-move = Com destino de Move
desktop-promiscuous = Armazenamento promíscuo
desktop-query-accession = Acesso nº
desktop-query-activity-detail = { $count } { $count ->
        [one] correspondência
       *[other] correspondências
    } no nível { $level }
desktop-query-activity-fail = C-FIND { $node } falhou
desktop-query-activity-ok = C-FIND { $node }
desktop-query-activity-title = C-FIND { $node }
desktop-query-clear = Limpar
desktop-query-col-accession = Acesso
desktop-query-criteria = Critérios de busca
desktop-query-date-from = Data do estudo (de)
desktop-query-date-to = Data do estudo (até)
desktop-query-kv-series-uid = Series UID
desktop-query-kv-sop-uid = SOP UID
desktop-query-kv-study-uid = Study UID
desktop-query-level = Nível
desktop-query-matches =
    { $count ->
        [one] { $count } correspondência
       *[other] { $count } correspondências
    }
desktop-query-missing-study-uid = A correspondência não tem StudyInstanceUID; não é possível recuperar.
desktop-query-modality = Modalidade
desktop-query-no-matches = Nenhuma correspondência.
desktop-query-no-nodes = Nenhum nó configurado
desktop-query-patient-id = ID do paciente
desktop-query-patient-name = Nome do paciente
desktop-query-placeholder-description = CHEST*
desktop-query-placeholder-modality = CT, MR, …
desktop-query-placeholder-name = DOE^JOHN or DOE*
desktop-query-placeholder-patient = DOE^JOHN or DOE*
desktop-query-querying = Consultando…
desktop-query-remote-node = Nó remoto
desktop-query-results = Resultados
desktop-query-retrieve = Recuperar
desktop-query-retrieve-activity-detail = completed={ $completed }, warning={ $warning }, failed={ $failed }
desktop-query-retrieve-activity-fail = C-MOVE { $node } falhou
desktop-query-retrieve-activity-ok = C-MOVE { $node }
desktop-query-retrieve-finished = Recuperação concluída: completadas { $completed }, avisos { $warning }, falhas { $failed }.
desktop-query-retrieve-selected = Recuperar selecionada
desktop-query-run = Executar C-FIND
desktop-query-run-select = Execute uma consulta e selecione uma correspondência.
desktop-query-running = Consultando…
desktop-query-search-criteria = Critérios de busca
desktop-query-select-hint = Execute uma consulta e selecione uma correspondência.
desktop-query-selected = Correspondência selecionada
desktop-query-selected-match = Correspondência selecionada
desktop-query-series-uid = Series Instance UID
desktop-query-sop-uid = SOP Instance UID
desktop-query-study-description = Descrição do estudo
desktop-query-study-uid = Study Instance UID
desktop-query-subtitle = Execute C-FIND em um nó remoto, inspecione as correspondências e faça C-MOVE para o arquivo local.
desktop-query-title = Consulta / Recuperação
desktop-recent-studies = Estudos recentes
desktop-scp-listening = SCP em escuta
desktop-scp-stopped = SCP parado
desktop-server-activity-fail = Falha no controle do Storage SCP
desktop-server-activity-started = Storage SCP iniciado
desktop-server-activity-started-detail = Listener iniciado.
desktop-server-activity-stopped = Storage SCP parado
desktop-server-activity-stopped-detail = received={ $received }, stored={ $stored }, failed={ $failed }
desktop-server-activity-stopped-empty = Nenhuma sessão ativa.
desktop-server-addr-ae = { $addr } · AE { $ae }
desktop-server-assoc-accepted = Associações aceitas
desktop-server-assoc-rejected = Associações rejeitadas
desktop-server-cfind-req-matches = Requisições / correspondências C-FIND
desktop-server-cget-requests = Requisições C-GET
desktop-server-cmove-requests = Requisições C-MOVE
desktop-server-cmove-subops = Suboperações C-MOVE concluídas / falhas
desktop-server-control-failed = Falha no controle do Storage SCP
desktop-server-counter-bytes = Bytes ingeridos
desktop-server-counter-failed = C-STORE com falha
desktop-server-counter-find = Requisições / correspondências C-FIND
desktop-server-counter-get = Requisições C-GET
desktop-server-counter-move = Requisições C-MOVE
desktop-server-counter-move-sub = Suboperações C-MOVE concluídas / falhas
desktop-server-counter-received = C-STORE recebidos
desktop-server-counter-stored = C-STORE armazenados
desktop-server-cstore-failed = C-STORE com falha
desktop-server-cstore-received = C-STORE recebidos
desktop-server-cstore-stored = C-STORE armazenados
desktop-server-dimse = Contadores DIMSE
desktop-server-failed = Falhas
desktop-server-health-loading = Carregando métricas
desktop-server-health-ready = Pronto para C-STORE de entrada
desktop-server-health-review = Revisar falhas
desktop-server-health-stopped = Parado
desktop-server-listener-started = Listener iniciado.
desktop-server-listening = EM ESCUTA
desktop-server-loading-metrics = Carregando métricas…
desktop-server-logs = registros
desktop-server-no-session = Nenhuma sessão ativa.
desktop-server-rate = +{ $rate } / consulta
desktop-server-ready = Pronto para C-STORE de entrada
desktop-server-review-failures = Revisar falhas
desktop-server-session-ended = Sessão encerrada: recebidos { $received }, armazenados { $stored }, falhas { $failed }.
desktop-server-start = Iniciar servidor
desktop-server-started-title = Storage SCP iniciado
desktop-server-stop = Parar servidor
desktop-server-stopped = PARADO
desktop-server-stopped-pill = PARADO
desktop-server-stopped-status = Parado
desktop-server-stopped-title = Storage SCP parado
desktop-server-stored = Armazenados
desktop-server-subtitle = Storage SCP autônomo para C-STORE de entrada e indexação no arquivo local.
desktop-server-title = Servidor de armazenamento
desktop-status-listening = em escuta
desktop-status-loading = Carregando
desktop-status-scp-listening = SCP em escuta
desktop-status-scp-stopped = SCP parado
desktop-status-stopped = parado
desktop-store-syntax = Sintaxe de store
desktop-strict-pdu = PDU estrito
desktop-strip-pdu = PDU { $value }
desktop-table-accession = Acesso
desktop-table-ae-title = Título AE
desktop-table-date = Data
desktop-table-description = Descrição
desktop-table-endpoint = extremidade
desktop-table-instances = Instâncias
desktop-table-modalities = Modalidades
desktop-table-modality = Modalidade
desktop-table-move-dest = Dest. Move
desktop-table-name = Nome
desktop-table-notes = Notas
desktop-table-patient = Paciente
desktop-table-patient-id = ID do paciente
desktop-table-series = Séries
desktop-table-updated = Atualizado
desktop-title-refresh-status = Atualizar status
desktop-title-reveal-log = Mostrar arquivo de log
ae = AE
patient-name =
    "DOE^JOHN"
    Pressione 'm' em um resultado selecionado para abrir a recuperação.
port = Porta

## Summary
summary-ae = AE
summary-counts = Contagens
summary-criteria = Critérios
summary-duration = Duração
summary-duration-ms = { $ms }ms
summary-failures = Falhas:
summary-kind = Tipo
summary-logs = Registros:
summary-peer = Par
summary-status = estado
summary-title = Resumo da operação
tui-detail-created = Criado

tui-form-hint-port-range = dica: um número de 1 a 65535, p.ex. 104
tui-form-hint-promiscuous = dica: permitir armazenamento de qualquer AE title de origem
tui-form-hint-strict-pdu = dica: aplicar verificações de tamanho de PDU nas associações
tui-form-hint-max-pdu-bytes = dica: bytes, p.ex. 16384
tui-form-limits-heading = Limites (bytes; vazio/none = ilimitado):
tui-form-field-max-file-import = Máx. bytes de importação de arquivo
tui-form-field-max-zip-entry = Máx. bytes por entrada ZIP
tui-form-field-max-zip-total = Máx. bytes totais do ZIP
tui-form-field-max-zip-count = Máx. entradas ZIP
tui-form-field-max-store-object = Máx. bytes de objeto C-STORE
tui-form-unlimited = ilimitado
tui-form-err-max-pdu-required = ! o comprimento máximo de PDU é obrigatório
tui-form-err-max-pdu-gt-zero = ! o comprimento máximo de PDU deve ser um inteiro maior que 0
tui-form-err-limit-gt-zero = ! { $label } deve ser um inteiro maior que 0
tui-form-controls-scp = Digite para editar. Espaço alterna caixas. Tab/Shift-Tab ou Cima/Baixo mudam campos. Enter salva. Esc cancela.
tui-form-submit-uid-required = UID é obrigatório
tui-form-submit-dest-required = o nó de destino é obrigatório
tui-form-submit-nonneg-int = { $label } deve ser um inteiro não negativo
tui-form-submit-gt-zero = { $label } deve ser maior que 0
tui-form-submit-local-ae-required = o título AE local é obrigatório
tui-form-submit-local-ae-invalid = título AE local inválido: { $err }
tui-form-submit-bind-required = o endereço de bind é obrigatório
tui-form-submit-port-required = a porta é obrigatória
tui-form-submit-max-pdu-required = o comprimento máximo de PDU é obrigatório
tui-form-submit-max-pdu-int = o comprimento máximo de PDU deve ser um inteiro
tui-form-submit-max-pdu-gt-zero = o comprimento máximo de PDU deve ser maior que 0
tui-form-submit-patient-retrieve = recuperação em nível de paciente não é suportada
tui-form-submit-no-study-uid = o resultado selecionado não inclui um study UID
tui-form-submit-date-format = esperado YYYYMMDD
tui-form-submit-modality-len = a modalidade deve ter no máximo 16 caracteres
tui-form-submit-modality-chars = a modalidade deve ser A-Z ou 0-9
tui-form-submit-name-required = o nome do nó é obrigatório
tui-form-submit-ae-required = o título AE é obrigatório
tui-form-submit-host-required = o host é obrigatório
tui-form-submit-move-dest-invalid = título AE de destino do C-MOVE inválido: { $err }
tui-form-submit-dates-both = data inicial e final devem ser ambas preenchidas, ou nenhuma
tui-form-submit-date-from-invalid = data inicial inválida: { $err }
tui-form-submit-date-to-invalid = data final inválida: { $err }
tui-form-submit-date-order = a data inicial deve ser anterior ou igual à data final
tui-form-submit-study-uid-series-query = study UID é obrigatório em consultas de série
tui-form-submit-study-uid-image-query = study UID é obrigatório em consultas de imagem
tui-form-submit-series-uid-image-query = series UID é obrigatório em consultas de imagem
tui-form-submit-study-uid-required = study UID é obrigatório
tui-form-submit-study-uid-invalid = study UID inválido: { $err }
tui-form-submit-series-uid-series-retrieve = series UID é obrigatório na recuperação em nível de série
tui-form-submit-series-uid-image-retrieve = series UID é obrigatório na recuperação em nível de imagem
tui-form-submit-instance-uid-image-retrieve = instance UID é obrigatório na recuperação em nível de imagem
tui-form-submit-series-uid-invalid = series UID inválido: { $err }
tui-form-submit-instance-uid-invalid = instance UID inválido: { $err }
tui-form-submit-import-path-required = o caminho de importação é obrigatório
tui-form-submit-import-path-type = o caminho de importação deve ser um arquivo ou diretório: { $path }
tui-form-submit-import-access = acessando o caminho de importação { $path }
tui-form-submit-import-open = abrindo o arquivo de importação { $path }
tui-form-submit-import-read-dir = lendo o diretório de importação { $path }
tui-log-welcome = Pressione F1 ou ? para ajuda. Foque Nós remotos e pressione 'a' para adicionar um.
tui-log-logging-to = Registrando em { $path }
tui-command-help-heading = comandos:
tui-command-help-next-1 = nota: o rodapé mostra sugestões contextuais 'Next:' com base no painel focado e na seleção.
tui-command-help-next-2 = São apenas dicas; você sempre pode digitar qualquer comando.
tui-command-help-canonical = nota: os nomes canônicos coincidem com as flags da CLI sem '--', usando underscores.
tui-command-help-cancel = cancel (apelido: stop)
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
tui-command-help-refresh = atualizar
tui-command-help-quit = sair
tui-inspect-task = Tarefa #{ $id }
tui-inspect-status = Estado: { $status }
tui-inspect-description = Descrição: { $description }
tui-inspect-progress = Progresso: { $progress }
tui-inspect-summary = Resumo:
tui-inspect-no-logs = (sem logs)
tui-field-sop-class-uid = SOP Class UID
tui-field-transfer-syntax-uid = Transfer Syntax UID
tui-field-sha256 = SHA-256
tui-status-removed-nodes =
    removido { $count ->
        [one] { $count } nó
       *[other] { $count } nós
    }
tui-status-removed-nodes-target =
    removido { $count ->
        [one] { $count } nó
       *[other] { $count } nós
    }; último alvo foi { $name }
tui-status-more-failures =
    e { $n ->
        [one] { $n } falha omitida
       *[other] { $n } falhas omitidas
    }
tui-status-retrieve-ok = retrieve status=0x{ $status } completed={ $completed } failed={ $failed } warning={ $warning } remaining={ $remaining }
tui-status-import-counts = scanned={ $scanned } accepted={ $accepted } duplicates={ $duplicates } unreadable={ $unreadable } invalid_dicom={ $invalid } rejected_total={ $rejected } stored_bytes={ $bytes }
tui-status-send-ok = send attempted={ $attempted } sent={ $sent } failed={ $failed }
tui-log-query-start = Iniciando consulta a { $node }
tui-log-retrieve-start = Iniciando recuperação de { $node }
tui-log-import-start = Iniciando importação de { $path }
tui-log-send-study-start = Iniciando envio do estudo { $uid } para { $node }
tui-log-send-series-start = Iniciando envio da série { $uid } para { $node }
tui-log-cancelled-before-start = cancelado antes de iniciar
tui-log-cancelled = cancelado
error-unknown-command = comando desconhecido: { $command }
error-node-subcommand-required = node subcommand obrigatório
error-local-subcommand-required = local subcommand obrigatório
error-unsupported-node-subcommand = unsupported nó subcommand: { $command }
error-unsupported-local-subcommand = subcomando local não suportado: { $command }
error-expected-kv = esperado argumento key=value, obtido { $arg }
error-missing-required-arg = missing obrigatório argument: { $key }
error-missing-required-arg-one-of = missing obrigatório argument: one of { $keys }
error-parsing-command = analisando o comando
error-edit-form-lost-target = edit form lost its target nó
error-task-already-running = já há uma tarefa em segundo plano
error-task-thread-launch = falhou to launch background task thread: { $error }
error-task-disconnected = o fio da tarefa em segundo plano desconectou antes de enviar um resultado
error-task-kind-missing = o fio em segundo plano desconectou, mas active_task_kind era None: estado inesperado
error-serve-exited = serve saiu com erro: { $error }
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
summary-title = Resumo da operação
summary-kind = Tipo
summary-status = estado
summary-duration = Duração
summary-duration-ms = { $ms }ms
summary-peer = Par
summary-ae = AE
summary-criteria = Critérios
summary-counts = Contagens
summary-failures = Falhas:
summary-logs = Registros:
summary-unserializable = <não serializável>
summary-log-lines = linhas { $start }-{ $end }
