# Fluent catalog (zh-CN). Message IDs are hyphenated identifiers
# (cli-about, tui-pane-remote-nodes, desktop-nav-dashboard, error-import-file-too-large).
# Dotted names are Fluent attributes (message + .attr), not message IDs.
# Do not translate DICOM tokens (C-FIND, C-MOVE, C-STORE, SOP, AE, UID) or JSON/CSV machine keys.


## CLI
cli-about = 面向终端的 DICOM 节点客户端，基于 dicom-rs 构建
cli-arg-accession-number = 按检查号筛选（不区分大小写的子串）。
cli-arg-ae-title = Application Entity title
cli-arg-destination-node = 目标节点名称或 ID
cli-arg-duplicate = 按重复状态筛选。
cli-arg-export = 将结果导出为 JSON 或 CSV。
cli-arg-host = 主机名或 IP
cli-arg-imported-at =
    按导入时间筛选。支持 VALUE、START..END、..END、START..。
    按字典序比较（推荐格式：RFC3339）。
cli-arg-json = 将操作的最终摘要输出为 JSON（架构稳定）。
cli-arg-level = 查询/检索级别
cli-arg-metrics-json = 服务器退出时将内存中的指标快照打印为 JSON。
cli-arg-modality = 按模态筛选。逗号分隔列表（例如 CT,MR）。
cli-arg-model = 查询/检索信息模型
cli-arg-move-destination = 首选 C-MOVE 目标 AE Title
cli-arg-name = 节点的显示名称
cli-arg-node = 已保存节点的名称或 ID
cli-arg-notes = 自由格式备注
cli-arg-out = 输出文件路径。省略时写入标准输出。
cli-arg-path = 要导入的文件或目录
cli-arg-patient-id = 按患者 ID 筛选（不区分大小写的子串）。
cli-arg-patient-name = 按患者姓名筛选（不区分大小写的子串）。
cli-arg-port = 端口
cli-arg-series-description = 按序列描述筛选（不区分大小写的子串）。
cli-arg-series-instance-uid = Series Instance UID
cli-arg-sop-instance-uid = SOP Instance UID
cli-arg-source-path = 按源路径筛选（不区分大小写的子串）。
cli-arg-study-date =
    按检查日期筛选。支持 VALUE、START..END、..END、START..。
    日期按字典序比较（推荐格式：YYYYMMDD）。
cli-arg-study-date-from = 检查日期下限（YYYYMMDD）
cli-arg-study-date-to = 检查日期上限（YYYYMMDD）
cli-arg-study-description = 按检查描述筛选（不区分大小写的子串）。
cli-arg-study-instance-uid = Study Instance UID
cli-cmd-import-about = 从路径导入 DICOM 文件
cli-cmd-local-about = 查看本地归档
cli-cmd-local-series-about = 列出检查中已索引的序列
cli-cmd-local-studies-about = 列出已索引的本地检查
cli-cmd-node-about = 管理已保存的远程 DICOM 节点
cli-cmd-node-add-about = 添加远程节点
cli-cmd-node-delete-about = 删除已保存的节点
cli-cmd-node-edit-about = 编辑已保存的节点
cli-cmd-node-list-about = 列出已保存的节点
cli-cmd-query-about = 查询远程节点（C-FIND）
cli-cmd-retrieve-about = 从远程节点检索（C-MOVE）
cli-cmd-send-about = 发送本地检查或序列（C-STORE）
cli-cmd-send-series-about = 将序列发送到目标节点
cli-cmd-send-study-about = 将检查发送到目标节点
cli-cmd-serve-about = 运行 DICOM 服务器
cli-cmd-storage-scp-about = 运行 Storage SCP 侦听器
cli-cmd-tui-about = 打开交互式终端界面
cli-flag-help = 打印帮助
cli-flag-lang = 界面语言（BCP-47 标签）。覆盖 DICOM_NODE_LANG、已保存的区域设置和操作系统区域设置。
cli-flag-version = 打印版本
cli-heading-arguments = 参数：
cli-heading-commands = 命令：
cli-heading-options = 选项：
cli-heading-usage = 用法：
cli-import-accepted = accepted={ $n }
cli-import-complete = 导入完成
cli-import-duplicates = duplicates={ $n }
cli-import-scanned = scanned={ $n }
cli-msg-cancel-sigint = 已请求取消（SIGINT）。正在等待正常关闭...
cli-msg-failures = 失败：
cli-msg-import-failed = 导入失败：{ $error }
cli-msg-no-local-series = 检查 { $uid } 没有已索引的序列
cli-msg-no-local-studies = 没有已索引的本地检查
cli-msg-no-saved-nodes = 没有已保存的节点
cli-msg-query-failed = 查询失败：{ $error }
cli-msg-removed-nodes =
    已删除 { $count ->
        [one] { $count }个节点
       *[other] { $count }个节点
    }
cli-msg-results-count =
    结果: { $count ->
        [one] { $count }条匹配
       *[other] { $count }条匹配
    }
cli-msg-retrieve-failed = 检索失败：{ $error }
cli-msg-saved-node = 已保存节点 { $name } [{ $id }] => { $ae }@{ $host }:{ $port }
cli-msg-send-failed = 发送失败：{ $error }
cli-msg-showing-failures = （显示 { $total } 项失败中的前 { $shown } 项）
cli-msg-starting-server =
    正在以如下配置启动 DICOM 服务器： { $count ->
        [one] { $count }个本地 AE
       *[other] { $count }个本地 AE
    } { $aes }
cli-msg-starting-server-no-aes = 正在启动没有已配置本地 AE 的 DICOM 服务器
cli-msg-starting-storage-scp = 正在 { $addr } 启动 Storage SCP，AE Title 为 { $ae }
cli-msg-updated-node = 已更新节点 { $name } [{ $id }] => { $ae }@{ $host }:{ $port }
cli-send-attempted = attempted={ $n }
cli-send-failed-count = failed={ $n }
cli-send-sent = sent={ $n }
cli-value-name-file = FILE
cli-value-name-format = FORMAT
cli-value-name-locale = LOCALE
cli-value-name-path = PATH
tui-detail-more-series =
    ... { $n ->
        [one] { $n }个更多序列
       *[other] { $n }个更多序列
    }
tui-row-instance-count =
    { $n ->
        [one] { $n }例
       *[other] { $n }例
    }
tui-row-study-counts = { $series }s/{ $instances }i
count-nodes =
    { $n ->
        [one] { $n }个节点
       *[other] { $n }个节点
    }
count-instances =
    { $n ->
        [one] { $n }个实例
       *[other] { $n }个实例
    }
count-series =
    { $n ->
        [one] { $n }个序列
       *[other] { $n }个序列
    }
count-studies =
    { $n ->
        [one] { $n }项检查
       *[other] { $n }项检查
    }
format-datetime = { $date } { $time }
format-date = { $year }/{ $month }/{ $day }

## Common
common-accession = 检查号
common-add = 添加
common-back = 返回
common-bytes = 字节
common-cancel = 取消
common-clear = 清除
common-close = 关闭
common-date = 日期
common-delete = 删除节点
common-description = 描述
common-disabled = 已禁用
common-duplicates = 重复
common-edit = 编辑
common-enabled = 已启用
common-error = 错误
common-filter = 筛选
common-host = 主机
common-import = 导入
common-instance = 实例
common-language = 语言
common-loading = 正在加载
common-matches = 匹配
common-modality = 模态
common-name = 名称
common-network = 网络
common-no = 否
common-none = 无
common-notes = 备注
common-optional = 可选
common-path = 来源
common-patient = 患者
common-patient-id = 患者 ID
common-patient-name = 患者姓名
common-port = 端口
common-query = 查询
common-refresh = 刷新
common-required = 必填
common-retrieve = 检索
common-save = 保存
common-search = 搜索
common-send = 发送
common-series = 序列
common-start = 开始
common-status = 状态
common-stop = 停止
common-studies = 检查
common-study = 检查
common-unknown = 未知
common-unknown-series = <序列>
common-unknown-study = <检查>
common-yes = 是

## Errors
error-ae-empty = AE title 不能为空
error-ae-invalid-char = AE title 包含无效字符 '{ $character }'；允许：A-Z、0-9、空格
error-ae-required = 必须填写 AE Title
error-ae-too-long = AE title 最多 16 个字符
error-ae-whitespace = AE title 不能有前导或尾随空格
error-archive-patient-retrieve-out-of-scope = Patient 级别 retrieve 不在范围内
error-archive-retrieve-uid-required = 此 retrieve 级别需要 { $name }
error-archive-study-root-patient-query = Study Root 查询不支持 Patient 级别
error-archive-study-root-patient-retrieve = Study Root retrieve 不支持 Patient 级别
error-assoc-negotiation-failed = 与 { $name }（{ $addr }）的 association 协商失败；提示：检查 called AE title、presentation contexts/transfer syntaxes，以及对端是否接受 association
error-assoc-no-addresses = 未能为 { $name } 在 { $host }:{ $port } 解析套接字地址
error-assoc-receive = association 接收
error-assoc-resolving = 正在解析 { $name }（{ $host }:{ $port }）：{ $err }
error-assoc-timeout = 等待 DIMSE 响应超时；提示：检查网络、AE title/主机/端口以及对端响应
error-assoc-transport = 等待 DIMSE 响应时传输中断；提示：对端关闭了连接，或网络设备重置了连接
error-assoc-unreachable = 在 { $seconds }s 内无法到达 { $name } [{ $ae }]（{ $host }:{ $port }）：{ $err }。请检查主机/IP、端口和网络可达性
error-cancel-sigint = 已请求取消 (SIGINT)。正在等待正常关闭...
error-config-must-be-positive = 无效配置：{ $name } 必须大于 0（或为 null 以禁用）
error-config-duplicate-bind-port = 无效配置：本地 AE bind 端口 { $port } 重复
error-config-local-ae-max-assoc = 无效配置：本地 AE { $title } 的 max_concurrent_associations 必须大于 0
error-config-local-ae-no-services = 无效配置：本地 AE { $title } 必须启用至少一个服务
error-config-must-be-positive-required = 无效配置：{ $name } 必须大于 0
error-dicom-meta-incomplete = DICOM 文件元数据不完整
error-dicom-patient-move-unsupported = 此客户端不支持患者级 C-MOVE
error-dicom-required-attribute = 缺少必需的 DICOM 属性：（{ $group },{ $element }）
error-dicom-series-uid-required-image = 图像级 retrieve 需要 series_instance_uid
error-dicom-series-uid-required-series = 序列级 retrieve 需要 series_instance_uid
error-dicom-sop-uid-required-image = 图像级 retrieve 需要 sop_instance_uid
error-dicom-study-uid-required = 需要 study_instance_uid
error-dicom-validating-move = 正在验证 move 请求
error-export-creating-file = 正在创建导出文件 { $path }：{ $err }
error-export-flushing-series-csv = 正在刷新序列 CSV：{ $err }
error-export-flushing-studies-csv = 正在刷新研究 CSV：{ $err }
error-export-serializing-series-json = 正在序列化序列 JSON：{ $err }
error-export-serializing-studies-json = 正在序列化研究 JSON：{ $err }
error-export-writing-series-csv-header = 正在写入序列 CSV 表头：{ $err }
error-export-writing-series-csv-row = 正在写入序列 CSV 行：{ $err }
error-export-writing-studies-csv-header = 正在写入研究 CSV 表头：{ $err }
error-export-writing-studies-csv-row = 正在写入研究 CSV 行：{ $err }
error-import-cleanup-failed = { $source }：清理失败：{ $reason }
error-import-corrupt-zip = 损坏的 ZIP：{ $details }
error-import-dicom-parse-failed = DICOM 解析失败：{ $err }
error-import-dicom-validation-failed = DICOM 验证失败：{ $err }
error-import-duplicate-zip-path = ZIP 中有多个条目指向 '{ $path }'
error-import-file-too-large = 文件过大：{ $details }
error-import-invalid-dicom = 无效 DICOM：{ $details }
error-import-limit-exceeded = 超出 { $limit }：{ $details }
error-import-not-regular-file = 不是普通文件
error-import-opening-file = 正在打开文件：{ $err }
error-import-opening-kind = 正在打开 { $kind } { $path }
error-import-opening-staged-file = 正在打开暂存文件：{ $err }
error-import-opening-zip-archive = 正在打开 ZIP 归档 { $path }
error-import-opening-zip-entry = 正在打开 ZIP 条目：{ $err }
error-import-opening-zip-file = 正在打开 ZIP 导入文件 { $path }
error-import-path-does-not-exist = 导入路径不存在：{ $path }
error-import-reading-directory = 正在读取导入目录 { $path }
error-import-reading-file = 正在读取文件：{ $err }
error-import-reading-file-metadata = 正在读取 { $path } 的文件元数据
error-import-reading-metadata = 正在读取 { $kind } { $path } 的元数据
error-import-reading-zip-entry = 正在读取 ZIP 条目：{ $err }
error-import-removing-staged-after-cancel = 取消后正在删除暂存文件 { $path }
error-import-skipped = { $source }：已跳过：{ $reason }
error-import-unreadable = 无法读取的文件：{ $details }
error-import-unsafe-zip-path = 条目路径超出归档范围
error-import-zip-entry-count-exceeded = 超出 ZIP 条目数量限制：归档有 { $count } 个条目，限制为 { $limit }
error-import-zip-entry-size-exceeded = ZIP 条目大小 { $size } 超出限制 { $limit }
error-import-zip-total-bytes-exceeded = 超出 ZIP 解压总字节限制：当前合计 { $current } 加上条目大小 { $entry } 超出限制 { $limit }
error-net-binding-storage-scp = 正在将 Storage SCP 绑定到 { $addr }（AE { $ae }）。另一本地 DICOM 接收端可能已占用该端口。请更新 { $config } 中的 storage_scp_port/local_aes，或停止冲突的侦听器
error-net-building-file-meta = 正在构建 file meta 表
error-net-cannot-send-transfer-syntax = 无法以已协商的 transfer syntax { $negotiated } 发送源 { $source }
error-net-cget-dataset-empty = 已编码的 C-GET C-STORE 数据集为空
error-net-cget-dataset-odd-length = 已编码的 C-GET C-STORE 数据集以奇数长度尾片段结束
error-net-cget-peer-released = 对端在 C-GET 期间释放了关联
error-net-cget-store-unexpected-dataset = 意外 dataset fragment in C-GET C-STORE response
error-net-cget-unexpected-command = 意外 command 0x{ $command } while waiting for C-STORE-RSP
error-net-cget-unexpected-pdu = 意外 PDU during C-GET C-STORE suboperation: { $pdu }
error-net-creating-incoming-dir = 正在创建 Storage SCP 的 .incoming 目录
error-net-creating-path = 正在创建 { $path }
error-net-dataset-empty = 已编码数据集为空，但 COMMAND_DATA_SET_TYPE 表明需要数据集
error-net-dataset-odd-length = 已编码数据集以奇数长度尾片段结束
error-net-dimse-failed = { $operation } 失败，状态 0x{ $status }（{ $meaning }）{ $hint }
error-net-establishing-assoc = 正在建立 Storage SCP 关联
error-net-file-meta-length = 读取 File Meta Information length
error-net-file-meta-tag = 读取 File Meta Information tag
error-net-file-meta-value = 正在跳过 File Meta Information 值
error-net-file-meta-vr = 读取 File Meta Information VR
error-net-file-position = 读取 file position
error-net-flushing-path = 正在刷新 { $path }
error-net-flushing-temp-dataset = 正在刷新临时数据集文件
error-net-hint-suffix = ; 提示: { $hint }
error-net-incomplete-command = 不完整 { $operation } command response
error-net-incomplete-identifier = 不完整 { $operation } response identifier
error-net-invalid-affected-sop = 无效 { $operation } affected SOP class UID
error-net-invalid-status = 无效 { $operation } status
error-net-listener-address = 读取 storage SCP listener address
error-net-listener-nonblocking = 正在将侦听器设为非阻塞模式
error-net-listener-port = 读取 storage SCP listener port
error-net-local-aes-empty = local_aes 必须至少包含一个 AE 才能启动 Storage SCP
error-net-locating-dataset = 正在 { $path } 中定位数据集
error-net-malformed-dimse = malformed { $operation } DIMSE response: { $details }; 提示: peer sent an 无效 or 意外 DIMSE command set
error-net-missing-affected-sop = 缺失 { $operation } affected SOP class UID
error-net-missing-command-field = 缺失 command field
error-net-missing-cstore-rsp-command-field = 缺失 C-STORE response command field
error-net-missing-cstore-rsp-status = 缺失 C-STORE response status
error-net-missing-destination = 缺失 C-MOVE destination
error-net-missing-dicm = 缺失 Part 10 DICM marker
error-net-missing-message-id = 缺失 { $operation } message id
error-net-missing-qr-level = { $operation } identifier is 缺失 QueryRetrieveLevel
error-net-missing-required-command-field = 缺失 required command field { $name } ({ $tag })
error-net-missing-status = 缺失 { $operation } status
error-net-move-destination-unresolved = 未能解析 move_destination
error-net-no-cget-store-context = 没有为 SOP Class { $sop } 和 transfer syntax { $syntax } 协商的 C-GET 存储表示上下文
error-net-no-compatible-context = { $path }：没有与源 transfer syntax { $syntax } 兼容的已协商表示上下文
error-net-no-dimse-provider = 没有为命令 0x{ $command } 和抽象语法 { $syntax } 注册的 DIMSE 提供者
error-net-no-presentation-context = 没有已协商的表示上下文
error-net-no-presentation-context-for-file = { $path }：没有已协商的表示上下文
error-net-no-presentation-context-id = 缺失 negotiated presentation context { $id }
error-net-opening-path = 打开 { $path }
error-net-part10-preamble = 读取 Part 10 preamble
error-net-path-error = { $path }: { $err }
error-net-pdata-feed-complete = cannot feed P-DATA fragment into a complete accumulator (缺失 take())
error-net-peer-aborted = 对端在 C-GET C-STORE 子操作期间中止关联：{ $source }
error-net-peer-socket = 读取 storage SCP peer socket address
error-net-reading-command-dataset = 读取 command dataset
error-net-reading-identifier = 读取 { $operation } identifier
error-net-reading-incoming-dataset = 读取 incoming C-STORE dataset
error-net-reading-response-dataset = 读取 { $operation } response dataset
error-net-remote-aborted = 远端中止了关联：{ $source }
error-net-restoring-read-timeout = 正在恢复 association 读取超时
error-net-restoring-write-timeout = 正在恢复 association 写入超时
error-net-rewinding-dataset = 正在回退到数据集的第一个元素
error-net-scp-thread-panicked = Storage SCP 线程发生 panic
error-net-seeking-temp-dataset = 正在定位临时数据集文件
error-net-serializing-cget-dataset = 正在序列化 { $path } 的 C-GET 子操作数据集
error-net-serializing-dataset = 正在以 transfer syntax { $syntax } 序列化 { $path } 的数据集
error-net-setting-socket-blocking = 正在将已接受的存储套接字设为阻塞模式
error-net-sending-buffered-dataset = 正在发送 { $path } 的缓冲数据集
error-net-store-status = 远端返回 C-STORE 状态 0x{ $status }（{ $meaning }）{ $hint }
error-net-streaming-dataset = 正在流式传输 C-STORE 数据集
error-net-unexpected-command-field = 意外 CommandField 0x{ $actual } (expected 0x{ $expected } for { $rsp })
error-net-unexpected-dataset-fragment = 意外 dataset fragment in C-STORE response
error-net-unexpected-pdu = 意外 PDU during { $operation }: { $pdu }
error-net-unknown-status = 无效 { $operation } status 0x{ $status }
error-net-unsupported-model-sop = 不支持 { $operation } model SOP class UID: { $uid }
error-net-unsupported-qr-level = 不支持 QueryRetrieveLevel: { $level }
error-net-unsupported-transfer-syntax = 不支持 negotiated transfer syntax
error-net-writing-command-dataset = 写入 command dataset
error-net-writing-identifier = 写入 { $operation } identifier
error-net-writing-path = 写入 { $path }
error-net-writing-response-dataset = 写入 { $operation } response dataset
error-net-writing-temp-dataset = 写入 dataset bytes to temp file
error-node-host-empty = 节点主机不能为空
error-node-name-empty = 节点名称不能为空
error-node-not-found = 未找到远程节点：{ $id }
error-operation-cancelled = 操作已取消
error-port-invalid = 无效端口：{ $value }
error-port-range = 端口必须介于 1 和 65535 之间
error-query-no-study-uid = 匹配项没有 StudyInstanceUID，无法检索。
error-query-unsupported-level = 不支持的查询级别：{ $value }
error-query-unsupported-model = 不支持的查询模型：{ $value }
error-retrieve-canceled = 远程节点取消了 retrieve（status=0x{ $status }, completed={ $completed }, failed={ $failed }, warning={ $warning }, remaining={ $remaining }, { $scp }）
error-retrieve-failed = retrieve 失败，status=0x{ $status }（completed={ $completed }, failed={ $failed }, warning={ $warning }, remaining={ $remaining }, { $scp }）
error-retrieve-nothing-arrived = 目标 { $destination } 的 retrieve 以 completed={ $completed } 结束，但本地 Storage SCP（{ $scp }）未收到任何内容。请检查 AE 映射或端口：确保 { $listener } 空闲，且远程节点将 AE { $destination } 映射到本应用
error-send-no-files-series = 序列 { $uid } 没有已索引的本地文件
error-send-no-files-study = 研究 { $uid } 没有已索引的本地文件
error-task-cancelled = 任务已取消
error-task-none-to-cancel = 没有可取消的活动任务（当前没有运行中的任务）
error-tracing-init = 正在初始化 tracing subscriber：{ $err }
error-uid-component-numeric = UID 组件“{ $part }”必须为数字
error-uid-component-too-long = UID 组件“{ $part }”过长
error-uid-dot-ends = UID 不能以点开头或结尾
error-uid-empty = UID 不能为空
error-uid-empty-component = UID 不能包含空组件
error-uid-leading-zeros = UID 组件“{ $part }”不能有前导零
error-uid-too-long = UID 最多 64 个字符

## TUI
tui-bool-no = 否
tui-bool-off = 关
tui-bool-on = 开
tui-bool-yes = 是
tui-command-placeholder = 键入命令或使用窗格快捷键。
tui-config-ae-title = AE title: { $value }
tui-config-edit-hint = 按 Tab 将焦点移到此窗格，然后按 'c' 编辑。
tui-config-hint = 按 Tab 将焦点移到此窗格，然后按 'c' 编辑。
tui-config-listener = 侦听器：{ $value }
tui-config-max-pdu = max_pdu_length: { $value }
tui-config-promiscuous = allow_promiscuous_storage: { $value }
tui-config-strict-pdu = strict_pdu: { $value }
tui-config-ts-pref = TS 首选：{ $value }
tui-controls-hint = Tab 切换字段 · Enter 确认 · Esc 取消
tui-detail-ae-title = AE Title
tui-detail-instance = 实例详情
tui-detail-name = 名称
tui-detail-node = 节点详情
tui-detail-placeholder-followup = 将焦点移到列表窗格并更改选择以更新此视图。
tui-detail-query = 查询结果详情
tui-detail-select-node = 选择远程节点以查看其元数据。
tui-detail-series = 序列详情
tui-detail-study = 检查详情
tui-empty-command-placeholder = 键入命令或使用窗格快捷键。
tui-empty-detail-instance = 选择一个实例进行查看，或按 Esc 返回序列。
tui-empty-detail-node = 选择远程节点以查看其元数据。
tui-empty-detail-query = 选择查询结果以查看元数据和 retrieve 上下文。
tui-empty-detail-series = 选择一个序列进行查看，或按 Esc 返回检查。
tui-empty-detail-study = 选择本地检查以查看患者和序列元数据。
tui-empty-instances = 此序列没有已索引的实例。
tui-empty-instances-hint = 按 Esc 返回序列。
tui-empty-local-instances = 此序列没有已索引的实例。
tui-empty-local-instances-hint = 按 Esc 返回序列。
tui-empty-local-series = 此检查没有已索引的序列。
tui-empty-local-series-hint = 按 Esc 返回本地检查。
tui-empty-local-studies = 尚无已索引的检查。
tui-empty-local-studies-cmd = 示例：import path=/data/inbox
tui-empty-local-studies-hint = 请先导入本地 DICOM 文件。
tui-empty-no-name = <无名称>
tui-empty-query = 尚未运行查询。
tui-empty-query-body =
    选择远程节点并按 'f' 进行查询。
    或者：query node=pacs
        patient_name="DOE^JOHN"
    在所选结果上按 'm' 打开 retrieve。
tui-empty-query-cmd = 或者：query node=pacs
tui-empty-query-hint = 选择远程节点并按 'f' 进行查询。
tui-empty-query-last-target = 上次查询目标：{ $name }
tui-empty-query-none = 尚未运行查询。
tui-empty-query-retrieve-hint = 在所选结果上按 'm' 打开 retrieve。
tui-empty-remote-nodes =
    尚未保存远程节点。
    
    在此窗格按 a 添加。
    或者：node add name=pacs
        ae=PACSAE host=10.0.0.10
        port=104
tui-empty-remote-nodes-cmd = 或者：node add name=pacs
tui-empty-remote-nodes-hint = 在此窗格按 a 添加。
tui-empty-series = 此检查没有已索引的序列。
tui-empty-series-hint = 按 Esc 返回本地检查。
tui-empty-studies = 尚无已索引的检查。
tui-empty-studies-hint = 请先导入本地 DICOM 文件。
tui-empty-tasks-history = 没有任务历史。
tui-empty-tasks-queued = 没有排队的任务。
tui-fallback-no-name = <无名称>
tui-field-accession = 检查号
tui-field-ae-title = AE title
tui-field-bind-addr = 绑定地址
tui-field-date-from = 起始日期
tui-field-date-to = 结束日期
tui-field-destination-node = 目标节点
tui-field-host = 主机
tui-field-instance-uid = Instance UID
tui-field-kind = 类型
tui-field-level = 级别
tui-field-local-ae = 本地 AE
tui-field-max-pdu = 最大 PDU
tui-field-modality = 模态
tui-field-model = 模型
tui-field-move-destination = Move 目标
tui-field-name = 名称
tui-field-notes = 备注
tui-field-path = 路径
tui-field-patient-id = 患者 ID
tui-field-patient-name = 患者姓名
tui-field-port = 端口
tui-field-promiscuous = 混杂存储
tui-field-series-uid = Series UID
tui-field-sop-uid = SOP Instance UID
tui-field-strict-pdu = 严格 PDU
tui-field-study-description = 检查描述
tui-field-study-uid = Study UID
tui-footer-back-series = Esc 返回序列
tui-footer-back-studies = Esc 返回检查
tui-footer-cancel-task = c 取消
tui-footer-edit-config = c 编辑配置
tui-footer-enter-series = Enter 序列
tui-footer-esc-series = Esc 返回序列
tui-footer-esc-studies = Esc 返回检查
tui-footer-help = F1/? 帮助
tui-footer-inspect = Enter 查看
tui-footer-next = 下一步：{ $text }
tui-footer-nodes = a/e/d/f节点
tui-footer-panes = Tab 窗格
tui-footer-queued =
    { $n ->
        [one] { $n }个排队
       *[other] { $n }个排队
    }
tui-footer-quit = q 退出
tui-footer-refresh = r 刷新
tui-footer-retrieve = m 检索
tui-footer-run-command = Enter 运行命令
tui-footer-task-scope = t 队列/历史
tui-form-add-node = 添加远程节点
tui-form-add-remote-node = 添加远程节点
tui-form-delete-confirm = 删除远程节点 { $name } [{ $ae }]（{ $host }:{ $port }）？
tui-form-delete-node = 删除远程节点
tui-form-delete-remote-node = 删除远程节点
tui-form-edit-node = 编辑远程节点
tui-form-edit-remote-node = 编辑远程节点
tui-form-err-ae-required = ! AE title 为必填
tui-form-err-bind-required = ! 绑定地址为必填
tui-form-err-host-required = ! 主机为必填
tui-form-err-local-ae-invalid = ! 无效的本地 AE title：{ $err }
tui-form-err-local-ae-required = ! 本地 AE title 为必填
tui-form-err-modality-empty = modality 不能为空
tui-form-err-move-dest-invalid = ! 无效的移动目标 AE title：{ $err }
tui-form-err-name-required = !节点 name is required
tui-form-err-port-required = ! 端口为必填
tui-form-err-uid-empty = UID 不能为空
tui-form-err-uid-empty-component = UID 不能包含空组件
tui-form-error-line = 错误：{ $error }
tui-form-field-accession = 检查号
tui-form-field-ae-title = AE title
tui-form-field-bind-addr = 绑定地址
tui-form-field-date-from = 起始日期
tui-form-field-date-to = 结束日期
tui-form-field-dest-node = 目标节点
tui-form-field-destination = 目标 AE
tui-form-field-host = 主机
tui-form-field-instance-uid = SOP Instance UID
tui-form-field-kind = 类型
tui-form-field-level = 级别
tui-form-field-local-ae = 本地 AE
tui-form-field-modality = 模态
tui-form-field-model = 模型
tui-form-field-move-dest = Move 目标
tui-form-field-name = 名称
tui-form-field-notes = 备注
tui-form-field-path = 路径
tui-form-field-patient-id = 患者 ID
tui-form-field-patient-name = 患者姓名
tui-form-field-port = 端口
tui-form-field-series-uid = Series Instance UID
tui-form-field-sop-uid = SOP Instance UID
tui-form-field-study-desc = 检查描述
tui-form-field-study-uid = Study Instance UID
tui-form-field-uid = UID
tui-form-hint-bind = 提示：通常为 0.0.0.0（所有接口）或 127.0.0.1
tui-form-hint-local-ae = 提示：最多 16 个字符（A-Z、0-9、空格），例如 ARCHIVE_AE
tui-form-hint-move-dest = 提示：可选；覆盖 C-MOVE 目标 AE title
tui-form-hint-name = 提示：简短标签（例如 PACS）
tui-form-import = 导入本地文件
tui-form-import-local = 导入本地文件
tui-form-import-local-files = 导入本地文件
tui-form-mode-add = create a new 远程节点
tui-form-mode-edit = update the selected 远程节点
tui-form-query-node = 查询远程节点
tui-form-query-remote-node = 查询远程节点
tui-form-remote-node-line = 远程节点: { $name } [{ $ae }] { $host }:{ $port }
tui-form-retrieve = 检索匹配项
tui-form-retrieve-matches = 检索匹配项
tui-form-send-series = 发送序列
tui-form-send-study = 发送检查
tui-form-storage-intro = 编辑本地 Storage SCP 设置（保存到 config.json）。
tui-form-storage-scp = Storage SCP 设置
tui-form-storage-scp-settings = Storage SCP 设置
tui-help-ae-title = AE title: { $value }
tui-help-aedf = a/e/d/f     Add, edit, delete, or query from the selected节点
tui-help-c = c           编辑 Storage SCP 设置（焦点在配置窗格时）
tui-help-canonical-names = 规范名称对应不带 '--' 的 CLI 标志，并使用下划线。
tui-help-close = 用 Esc、F1 或 ? 关闭帮助。
tui-help-common-commands = 常用命令
tui-help-config = c           编辑 Storage SCP 设置（焦点在配置窗格时）
tui-help-config-path = 配置路径：{ $value }
tui-help-current-config = 当前配置
tui-help-data-dir = 数据目录：{ $value }
tui-help-enter-default = Enter       Run the command input, submit the active modal, or open series from 本地检查
tui-help-enter-instance = Enter       实例视图中无本地窗格操作
tui-help-enter-local-instance = Enter       实例视图中无本地窗格操作
tui-help-enter-local-series = Enter       打开所选本地序列的实例，或运行命令输入 / 提交活动模态
tui-help-enter-local-study = Enter       打开所选本地检查的序列，或运行命令输入 / 提交活动模态
tui-help-enter-series = Enter       打开所选本地序列的实例，或运行命令输入 / 提交活动模态
tui-help-enter-study = Enter       打开所选本地检查的序列，或运行命令输入 / 提交活动模态
tui-help-esc-default = Esc         关闭帮助/模态、从本地序列返回，或将焦点交回命令输入
tui-help-esc-instance = Esc         从本地实例返回序列、关闭帮助/模态，或将焦点交回命令输入
tui-help-esc-instances = Esc         从本地实例返回序列、关闭帮助/模态，或将焦点交回命令输入
tui-help-esc-series = Esc         从本地序列返回检查、关闭帮助/模态，或将焦点交回命令输入
tui-help-f1 = F1 或 ?     打开帮助
tui-help-import-send = i/s         导入 local files or send selected study/series
tui-help-is = i/s         导入 local files or send selected study/series
tui-help-listener = 侦听器：{ $value }
tui-help-log-dir = 日志目录：{ $value }
tui-help-m = m           从所选查询结果检索
tui-help-max-pdu = max_pdu_length: { $value }
tui-help-move = 上/下或 j/k   在列表窗格中移动选择
tui-help-nodes = a/e/d/f     Add, edit, delete, or query from the selected节点
tui-help-open = F1 或 ?     打开帮助
tui-help-promiscuous = allow_promiscuous_storage: { $value }
tui-help-q = q           无活动模态且焦点不在命令输入时退出
tui-help-quit = q           无活动模态且焦点不在命令输入时退出
tui-help-r = r           刷新 panes when focus is 否t in command input
tui-help-receiver-mode = 接收模式：{ $value }
tui-receiver-mode-on-demand = 本地 retrieve 按需
tui-receiver-mode-standalone = 通过 storage-scp 独立运行
tui-help-refresh = r           刷新 panes when focus is 否t in command input
tui-help-retrieve = m           从所选查询结果检索
tui-help-strict-pdu = strict_pdu: { $value }
tui-help-tab = Tab / Shift-Tab  切换焦点窗格
tui-help-title = 快捷键
tui-help-ts-pref = preferred_store_transfer_syntax: { $value }
tui-help-updown = 上/下或 j/k   在列表窗格中移动选择
tui-input-placeholder = 键入命令或使用窗格快捷键。
tui-log-command = > { $command }
tui-log-error = 错误：{ $error }
tui-log-refreshed = 已刷新
tui-logs-capped-suffix = 已截断
tui-logs-label = 日志:
tui-pane-command = 命令
tui-pane-config = 配置
tui-pane-detail = 详情
tui-pane-detail-hint = { $title } (PgUp/PgDn 未在输入时)
tui-pane-help = 帮助
tui-pane-instance-detail = 实例详情
tui-pane-instances-for = 实例：{ $uid }
tui-pane-local-studies = 本地检查
tui-pane-logs = 日志（{ $shown }/{ $total }{ $capped }）
tui-pane-logs-capped = 日志 ({ $shown }/{ $total } capped)
tui-pane-logs-uncapped = 日志 ({ $shown }/{ $total })
tui-pane-node-detail = 节点详情
tui-pane-query-detail = 查询结果详情
tui-pane-query-node = 查询节点
tui-pane-query-result-detail = 查询结果详情
tui-pane-query-results = 查询 / 检索结果
tui-pane-query-retrieve-results = 查询 / 检索结果
tui-pane-remote-nodes = 远程节点
tui-pane-series-detail = 序列详情
tui-pane-series-for = 序列：{ $uid }
tui-pane-series-unknown = 序列：<未知检查>
tui-pane-study-detail = 检查详情
tui-pane-task-details = 任务详情
tui-pane-tasks-history = 任务（历史）
tui-pane-tasks-queued = 任务（排队）
tui-pane-unknown-series = <未知序列>
tui-pane-unknown-study = 序列：<未知检查>
tui-row-inst = inst
tui-status-cancel-requested = 取消lation requested
tui-status-config = 配置
tui-status-configured-listener = 已将侦听器 { $addr } 配置为 AE { $ae }（{ $mode }）
tui-status-data = 数据
tui-status-failure = 失败：{ $failure }
tui-status-listener = 侦听器
tui-status-local-ae = 本地 AE
tui-status-mode = 模式
tui-status-mode-on-demand = 按需
tui-status-mode-standalone = 独立
tui-status-no-active-task = 没有活动任务 to cancel (nothing running)
tui-status-pdu = PDU
tui-status-promiscuous = 混杂存储
tui-status-query-before-retrieve = Query a 远程节点 first so retrieve knows which节点 to use
tui-status-query-failed = 查询失败：{ $error }
tui-status-queued-op = 排队操作：{ $op }
tui-status-retrieve-failed = 检索失败：{ $error }
tui-status-retrieve-open-failed = 无法打开 retrieve stream: { $error }
tui-status-saved-node = saved节点 { $name } ({ $id })
tui-status-saved-scp = 已保存 Storage SCP 设置（需要重启）
tui-status-select-node = 请先选择远程节点
tui-status-select-query = 请先选择查询结果
tui-status-select-study = 请先选择本地检查
tui-status-strict = 严格
tui-status-task-cancelled = 任务已取消
tui-status-task-cancelled-detail = 任务已取消：{ $other }
tui-status-ts-pref = TS 首选
tui-status-updated-node = updated节点 { $name } ({ $id })
tui-suggest-back-series = Esc — 返回序列
tui-suggest-edit-config = c — 编辑配置
tui-suggest-help = F1/? — 帮助
tui-suggest-inspect-task = Enter — 查看任务
tui-suggest-node-add = node add <ae-title> <host:port>
tui-suggest-query = f — query a节点
tui-suggest-query-node = f — query selected节点
tui-suggest-retrieve = m — 检索所选
tui-suggest-run-command = Enter — 运行命令
tui-suggest-send-series = s — 发送所选序列
tui-suggest-view-series = Enter — 查看序列
tui-task-cancelled = 已取消
tui-task-cancelling = 正在取消
tui-task-failed = 失败
tui-task-failed-generic = 任务失败：{ $error }
tui-task-import-done = 导入 complete: { $report }
tui-task-import-failed = 导入失败：{ $error }
tui-task-importing = 正在导入 { $path }...
tui-task-query-done =
    查询完成: { $count ->
        [one] { $count }条匹配
       *[other] { $count }条匹配
    }
tui-task-query-failed = 查询失败：{ $error }
tui-task-querying = 正在查询 { $node }...
tui-task-queued = 已排队
tui-task-retrieve-done = 检索完成：{ $outcome }
tui-task-retrieve-failed = 检索失败：{ $error }
tui-task-retrieving = 正在从 { $node } 检索...
tui-task-running = 运行中
tui-task-sending-series = 正在将序列 { $uid } 发送到 { $node }...
tui-task-sending-study = 正在将检查 { $uid } 发送到 { $node }...
tui-task-send-done = 发送完成：{ $outcome }
tui-task-status-cancelled = 已取消
tui-task-status-cancelling = 正在取消
tui-task-status-failed = 失败
tui-task-status-ok = ok
tui-task-status-queued = 排队中
tui-task-status-running = 运行中
tui-task-succeeded = 成功
tui-terminal-too-small = 终端太小 — 请调整窗口大小

## Desktop
desktop-action-activity = 活动 { $count }
desktop-action-activity-empty = 活动
desktop-action-import = 导入
desktop-action-inspect-archive = 检查本地归档
desktop-action-inspect-archive-desc = 查看检查、序列和实例，然后发送或导出。
desktop-action-manage-peers = 管理对端
desktop-action-manage-peers-desc = 添加并编辑用于 query、retrieve 和 store 的 PACS 或工作站节点。
desktop-action-monitor-scp = 监视 Storage SCP
desktop-action-query = 查询
desktop-action-refresh = 刷新状态
desktop-action-refresh-status = 刷新状态
desktop-action-reveal-log = 显示日志文件
desktop-action-send = 发送
desktop-action-start-scp = 启动 Storage SCP
desktop-activity-empty = 尚无会话活动。
desktop-activity-title = 活动
desktop-app-title = DICOM Node
desktop-archive-csv = CSV
desktop-archive-details = 详细信息
desktop-archive-empty = 本地归档为空。
desktop-archive-export-fail = 导出 { $scope } 失败
desktop-archive-export-ok =
    { $rows ->
        [one] 已将 { $rows } 行 { $scope } 导出到 { $path }。
       *[other] 已将 { $rows } 行 { $scope } 导出到 { $path }。
    }
desktop-archive-export-studies = 导出检查
desktop-archive-export-title = 导出 { $scope }
desktop-archive-filter = 按患者、UID、描述、模态筛选…
desktop-archive-filter-placeholder = 按患者、UID、描述、模态筛选…
desktop-archive-inst-abbrev =
    { $count ->
        [one] { $count }例
       *[other] { $count }例
    }
desktop-archive-instance-meta = { $bytes } · TS { $ts } · 导入于 { $imported }
desktop-archive-instances = 实例
desktop-archive-instances-heading = 实例
desktop-archive-json = JSON
desktop-archive-loading = 正在加载检查…
desktop-archive-no-filter-match = 没有检查符合筛选条件。
desktop-archive-no-instances = 未找到实例。
desktop-archive-no-match = 没有检查符合筛选条件。
desktop-archive-no-nodes = 无节点
desktop-archive-no-series = 未找到序列。
desktop-archive-reveal-file = 显示文件
desktop-archive-select-series = 请选择一个序列。
desktop-archive-select-study = 请选择一项检查。
desktop-archive-send-fail = { $label }：已发送 { $sent }/{ $attempted }，失败 { $failed }。 { $failures }
desktop-archive-send-fail-title = { $label } 失败
desktop-archive-send-ok = { $label }：已发送 { $sent }/{ $attempted } 个实例。
desktop-archive-send-series = 发送序列
desktop-archive-send-series-label = 序列 → { $destination }
desktop-archive-send-study = 发送检查
desktop-archive-send-study-label = 检查 → { $destination }
desktop-archive-send-to = 发送到
desktop-archive-series = 序列
desktop-archive-series-count =
    #{ $number } · { $count ->
        [one] { $count } 个实例
       *[other] { $count } 个实例
    }
desktop-archive-series-fallback = 序列
desktop-archive-studies = 检查
desktop-archive-study-date = 检查日期
desktop-archive-study-uid = Study UID
desktop-archive-subtitle = 来自本地 SQLite 归档的检查、序列和实例清单。
desktop-archive-title = 本地归档
desktop-brand-title = DICOM Node
desktop-col-description = 描述
desktop-col-instances = 实例
desktop-col-modalities = 模态
desktop-col-patient-id = 患者 ID
desktop-common-cancel = 取消
desktop-common-clear = 清除
desktop-common-disabled = 已禁用
desktop-common-enabled = 已启用
desktop-common-loading = 正在加载…
desktop-common-no = 否
desktop-common-refresh = 刷新
desktop-common-yes = 是
desktop-counter-assoc-accepted = 已接受关联
desktop-counter-bytes-ingested = 已摄入字节
desktop-counter-cfind-requests = C-FIND 请求
desktop-counter-cmove-requests = C-MOVE 请求
desktop-counter-cstore-failed = C-STORE 失败
desktop-counter-cstore-stored = C-STORE 已存储
desktop-dashboard-counter-assoc-accepted = 已接受关联
desktop-dashboard-counter-bytes-ingested = 已摄入字节
desktop-dashboard-counter-c-find-requests = C-FIND 请求
desktop-dashboard-counter-c-move-requests = C-MOVE 请求
desktop-dashboard-counter-c-store-failed = C-STORE 失败
desktop-dashboard-counter-c-store-stored = C-STORE 已存储
desktop-dashboard-empty-studies = 尚无本地检查。
desktop-dashboard-inspect-archive-body = 查看检查、深入序列和实例，然后发送或导出。
desktop-dashboard-inspect-archive-title = 查看本地归档
desktop-dashboard-kv-ae-title = AE Title
desktop-dashboard-kv-data-dir = 数据目录
desktop-dashboard-kv-listener = 监听器
desktop-dashboard-kv-log-file = 日志文件
desktop-dashboard-kv-max-pdu = 最大 PDU
desktop-dashboard-kv-promiscuous = 无限制存储
desktop-dashboard-kv-server = 服务器
desktop-dashboard-kv-store-syntax = Store 语法
desktop-dashboard-kv-strict-pdu = 严格 PDU
desktop-dashboard-listener-missing = 监听器尚未加载。
desktop-dashboard-live-counters = 实时计数器
desktop-dashboard-loading-metrics = 正在加载指标…
desktop-dashboard-loading-status = 正在加载本地状态…
desktop-dashboard-loading-studies = 正在加载检查…
desktop-dashboard-local-node = 本地节点
desktop-dashboard-manage-peers-body = 添加并编辑用于查询、检索和存储的 PACS 或工作站节点。
desktop-dashboard-manage-peers-title = 管理对等节点
desktop-dashboard-metric-instances = 实例
desktop-dashboard-metric-nodes = 远程节点
desktop-dashboard-metric-series = 序列
desktop-dashboard-metric-studies = 检查
desktop-dashboard-monitor-scp = 监视 Storage SCP
desktop-dashboard-recent-studies = 最近检查
desktop-dashboard-start-scp = 启动 Storage SCP
desktop-dashboard-subtitle = 一览本地归档、网络对等节点和 SCP 活动。
desktop-dashboard-title = 操作员仪表盘
desktop-doc-title = DICOM Node
desktop-import-accepted = 已接受
desktop-import-accepted-bytes = 已接受字节
desktop-import-activity-detail = { $accepted }/{ $scanned } 已接受，{ $duplicates } 重复，{ $bytes }
desktop-import-activity-fail = 导入失败
desktop-import-activity-ok = 导入完成
desktop-import-choose-archive = 选择要导入的 ZIP 归档
desktop-import-choose-dir = 选择要导入的目录
desktop-import-choose-folder = 文件夹
desktop-import-choose-zip = 选择要导入的 ZIP 归档
desktop-import-cleanup = 清理
desktop-import-clear-path = 清除路径
desktop-import-complete = 导入完成
desktop-import-dup-sha = SHA-256
desktop-import-dup-sop = SOP UID
desktop-import-dup-total = 总计
desktop-import-duplicates = 重复
desktop-import-failed = 导入失败
desktop-import-failed-cleanup = 清理失败
desktop-import-failures = 失败
desktop-import-failures-heading =
    { $count ->
        [one] { $count } 项失败：
       *[other] { $count } 项失败：
    }
desktop-import-failures-more = … 还有 { $count } 项
desktop-import-files-progress = { $label } 个文件
desktop-import-folder = 文件夹
desktop-import-invalid-dicom = 无效 DICOM
desktop-import-pick-dir = 选择要导入的目录
desktop-import-pick-zip = 选择要导入的 ZIP 归档
desktop-import-placeholder = /path/to/dicom-folder or /path/to/archive.zip
desktop-import-rejected = 已拒绝
desktop-import-report = 导入报告
desktop-import-running = 正在导入…
desktop-import-scanned = 已扫描
desktop-import-skipped = 已跳过
desktop-import-source = 来源
desktop-import-start = 开始导入
desktop-import-stored = 已存储
desktop-import-subtitle = 将递归文件夹或 ZIP 归档中的 DICOM 文件索引到受管本地归档。
desktop-import-title = 导入
desktop-import-unreadable = 不可读
desktop-import-zip = ZIP
desktop-import-zip-filter = ZIP 归档
desktop-lang-label = 语言
desktop-listener-not-loaded = 监听器尚未加载。
desktop-live-counters = 实时计数器
desktop-loading = 正在加载
desktop-loading-local-status = 正在加载本地状态…
desktop-loading-metrics = 正在加载指标…
desktop-loading-studies = 正在加载检查…
desktop-local-node = 本地节点
desktop-locale-label = 语言
desktop-logs-activity-detail =
    { $count ->
        [one] 已加载 { $count } 行
       *[other] 已加载 { $count } 行
    }
desktop-logs-activity-fail = 刷新日志失败
desktop-logs-activity-ok = 日志已刷新
desktop-logs-auto = 自动
desktop-logs-auto-refresh = 自动刷新
desktop-logs-empty = 日志文件为空。
desktop-logs-found = 已找到日志文件
desktop-logs-lines =
    { $count ->
        [one] { $count }行
       *[other] { $count }行
    }
desktop-logs-loading = 正在加载日志…
desktop-logs-missing = 活动日志文件尚未创建。
desktop-logs-refresh-failed = 刷新日志失败
desktop-logs-refreshed = 日志已刷新
desktop-logs-reveal = 显示
desktop-logs-subtitle = 活动桌面日志文件的有界尾部。
desktop-logs-tail = 尾部
desktop-logs-title = 日志
desktop-logs-truncated = 已截断
desktop-logs-waiting = 等待日志文件
desktop-metric-instances = 实例
desktop-metric-remote-nodes = 远程节点
desktop-metric-series = 序列
desktop-metric-studies = 检查
desktop-nav-archive = 本地归档
desktop-nav-dashboard = 仪表盘
desktop-nav-import = 导入
desktop-nav-logs = 日志
desktop-nav-network = 网络
desktop-nav-nodes = 远程节点
desktop-nav-query = 查询 / 检索
desktop-nav-server = 存储服务器
desktop-no-local-studies = 尚无本地检查。
desktop-nodes-add = 添加节点
desktop-nodes-added = 已添加节点“{ $name }”。
desktop-nodes-ae-length = AE Title 最多 16 个字符。
desktop-nodes-ae-title = AE Title
desktop-nodes-col-move = Move 目标
desktop-nodes-configured = 已配置节点
desktop-nodes-confirm-delete = 删除节点“{ $name }”？
desktop-nodes-default-port = 默认端口 104
desktop-nodes-delete = 删除节点
desktop-nodes-delete-title = 删除节点
desktop-nodes-deleted = 已删除节点“{ $name }”。
desktop-nodes-edit = 编辑节点
desktop-nodes-edit-title = 编辑节点
desktop-nodes-empty = 尚无远程节点。
desktop-nodes-err-ae = 必须填写 AE 标题。
desktop-nodes-err-ae-len = AE 标题最多 16 个字符。
desktop-nodes-err-host = 必须填写主机。
desktop-nodes-err-name = 必须填写名称。
desktop-nodes-err-port = 端口必须介于 1 和 65535 之间。
desktop-nodes-host = 主机
desktop-nodes-move-dest = Move 目标
desktop-nodes-move-placeholder = 默认为本地 AE
desktop-nodes-name = 名称
desktop-nodes-need-ae = AE Title 为必填。
desktop-nodes-need-host = 主机为必填。
desktop-nodes-need-name = 名称为必填。
desktop-nodes-notes = 备注
desktop-nodes-notes-placeholder = 阅片室 PACS
desktop-nodes-placeholder-ae = PACS01
desktop-nodes-placeholder-host = 192.168.0.10
desktop-nodes-placeholder-move = 默认为本地 AE
desktop-nodes-placeholder-name = main-pacs
desktop-nodes-placeholder-notes = 阅片室 PACS
desktop-nodes-port = 端口
desktop-nodes-port-104 = 默认端口 104
desktop-nodes-port-range = 端口必须介于 1 和 65535 之间。
desktop-nodes-save = 保存更改
desktop-nodes-save-changes = 保存更改
desktop-nodes-subtitle = 用于查询、检索和存储的 PACS 与工作站对等节点。
desktop-nodes-summary = 节点摘要
desktop-nodes-title = 远程节点
desktop-nodes-total = 节点总数
desktop-nodes-updated = 已更新节点“{ $name }”。
desktop-nodes-with-move = 有 Move 目标
desktop-promiscuous = 无限制存储
desktop-query-accession = Accession 号
desktop-query-activity-detail = { $count } { $count ->
        [one] 条匹配
       *[other] 条匹配
    } 级别 { $level }
desktop-query-activity-fail = C-FIND { $node } 失败
desktop-query-activity-ok = C-FIND { $node }
desktop-query-activity-title = C-FIND { $node }
desktop-query-clear = 清除
desktop-query-col-accession = 检查号
desktop-query-criteria = 搜索条件
desktop-query-date-from = 检查日期起
desktop-query-date-to = 检查日期止
desktop-query-kv-series-uid = Series UID
desktop-query-kv-sop-uid = SOP UID
desktop-query-kv-study-uid = Study UID
desktop-query-level = 级别
desktop-query-matches =
    { $count ->
        [one] { $count } 条匹配
       *[other] { $count } 条匹配
    }
desktop-query-missing-study-uid = 匹配项没有 StudyInstanceUID，无法检索。
desktop-query-modality = 模态
desktop-query-no-matches = 无匹配。
desktop-query-no-nodes = 未配置节点
desktop-query-patient-id = 患者 ID
desktop-query-patient-name = 患者姓名
desktop-query-placeholder-description = CHEST*
desktop-query-placeholder-modality = CT, MR, …
desktop-query-placeholder-name = DOE^JOHN or DOE*
desktop-query-placeholder-patient = DOE^JOHN or DOE*
desktop-query-querying = 正在查询…
desktop-query-remote-node = 远程节点
desktop-query-results = 结果
desktop-query-retrieve = 检索
desktop-query-retrieve-activity-detail = completed={ $completed }, warning={ $warning }, failed={ $failed }
desktop-query-retrieve-activity-fail = C-MOVE { $node } 失败
desktop-query-retrieve-activity-ok = C-MOVE { $node }
desktop-query-retrieve-finished = 检索完成：完成 { $completed }，警告 { $warning }，失败 { $failed }。
desktop-query-retrieve-selected = 检索所选
desktop-query-run = 运行 C-FIND
desktop-query-run-select = 运行查询并选择一条匹配。
desktop-query-running = 正在查询…
desktop-query-search-criteria = 搜索条件
desktop-query-select-hint = 运行查询并选择一条匹配。
desktop-query-selected = 所选匹配
desktop-query-selected-match = 所选匹配
desktop-query-series-uid = Series Instance UID
desktop-query-sop-uid = SOP Instance UID
desktop-query-study-description = 检查描述
desktop-query-study-uid = Study Instance UID
desktop-query-subtitle = 对远程节点执行 C-FIND，检查匹配项，然后 C-MOVE 到本地归档。
desktop-query-title = 查询 / 检索
desktop-recent-studies = 最近检查
desktop-scp-listening = SCP 正在监听
desktop-scp-stopped = SCP 已停止
desktop-server-activity-fail = Storage SCP 控制失败
desktop-server-activity-started = Storage SCP 已启动
desktop-server-activity-started-detail = 监听器已启动。
desktop-server-activity-stopped = Storage SCP 已停止
desktop-server-activity-stopped-detail = received={ $received }, stored={ $stored }, failed={ $failed }
desktop-server-activity-stopped-empty = 没有活动会话。
desktop-server-addr-ae = { $addr } · AE { $ae }
desktop-server-assoc-accepted = 已接受关联
desktop-server-assoc-rejected = 已拒绝关联
desktop-server-cfind-req-matches = C-FIND 请求 / 匹配
desktop-server-cget-requests = C-GET 请求
desktop-server-cmove-requests = C-MOVE 请求
desktop-server-cmove-subops = C-MOVE 子操作完成 / 失败
desktop-server-control-failed = Storage SCP 控制失败
desktop-server-counter-bytes = 已摄入字节
desktop-server-counter-failed = C-STORE 失败
desktop-server-counter-find = C-FIND 请求 / 匹配
desktop-server-counter-get = C-GET 请求
desktop-server-counter-move = C-MOVE 请求
desktop-server-counter-move-sub = C-MOVE 子操作完成 / 失败
desktop-server-counter-received = C-STORE 已接收
desktop-server-counter-stored = C-STORE 已存储
desktop-server-cstore-failed = C-STORE 失败
desktop-server-cstore-received = C-STORE 已接收
desktop-server-cstore-stored = C-STORE 已存储
desktop-server-dimse = DIMSE 计数器
desktop-server-failed = 失败
desktop-server-health-loading = 正在加载指标
desktop-server-health-ready = 可接收入站 C-STORE
desktop-server-health-review = 查看失败
desktop-server-health-stopped = 已停止
desktop-server-listener-started = 监听器已启动。
desktop-server-listening = 监听中
desktop-server-loading-metrics = 正在加载指标…
desktop-server-logs = 日志
desktop-server-no-session = 没有活动会话。
desktop-server-rate = +{ $rate } / 轮询
desktop-server-ready = 可接收入站 C-STORE
desktop-server-review-failures = 查看失败
desktop-server-session-ended = 会话结束：收到 { $received }，存储 { $stored }，失败 { $failed }。
desktop-server-start = 启动服务器
desktop-server-started-title = Storage SCP 已启动
desktop-server-stop = 停止服务器
desktop-server-stopped = 已停止
desktop-server-stopped-pill = 已停止
desktop-server-stopped-status = 已停止
desktop-server-stopped-title = Storage SCP 已停止
desktop-server-stored = 已存储
desktop-server-subtitle = 用于入站 C-STORE 和本地归档索引的独立 Storage SCP。
desktop-server-title = 存储服务器
desktop-status-listening = 正在监听
desktop-status-loading = 正在加载
desktop-status-scp-listening = SCP 正在监听
desktop-status-scp-stopped = SCP 已停止
desktop-status-stopped = 已停止
desktop-store-syntax = Store 语法
desktop-strict-pdu = 严格 PDU
desktop-strip-pdu = PDU { $value }
desktop-table-accession = 检查号
desktop-table-ae-title = AE 标题
desktop-table-date = 日期
desktop-table-description = 描述
desktop-table-endpoint = 端点
desktop-table-instances = 实例
desktop-table-modalities = 模态
desktop-table-modality = 模态
desktop-table-move-dest = Move 目标
desktop-table-name = 名称
desktop-table-notes = 备注
desktop-table-patient = 患者
desktop-table-patient-id = 患者 ID
desktop-table-series = 序列
desktop-table-updated = 已更新
desktop-title-refresh-status = 刷新状态
desktop-title-reveal-log = 显示日志文件
ae = AE
patient-name =
    "DOE^JOHN"
    在所选结果上按 'm' 打开 retrieve。
port = 端口

## Summary
summary-ae = AE
summary-counts = 计数
summary-criteria = 条件
summary-duration = 持续时间
summary-duration-ms = { $ms }ms
summary-failures = 失败：
summary-kind = 类型
summary-logs = 日志：
summary-peer = 对端
summary-status = 状态
summary-title = 操作摘要
tui-detail-created = 已创建

tui-form-hint-port-range = 提示：1 到 65535 的数字，例如 104
tui-form-hint-promiscuous = 提示：允许来自任何呼叫 AE title 的存储
tui-form-hint-strict-pdu = 提示：在关联期间强制 PDU 大小检查
tui-form-hint-max-pdu-bytes = 提示：字节，例如 16384
tui-form-limits-heading = Limits (bytes; blank/无 = unlimited):
tui-form-field-max-file-import = 文件导入最大字节
tui-form-field-max-zip-entry = ZIP 条目最大字节
tui-form-field-max-zip-total = ZIP 合计最大字节
tui-form-field-max-zip-count = ZIP 条目最大数量
tui-form-field-max-store-object = 存储对象最大字节
tui-form-unlimited = 无限制
tui-form-err-max-pdu-required = ! 最大 PDU 长度为必填
tui-form-err-max-pdu-gt-zero = ! 最大 PDU 长度必须为大于 0 的整数
tui-form-err-limit-gt-zero = ! { $label } 必须为大于 0 的整数
tui-form-controls-scp = 输入以编辑。空格切换复选框。Tab/Shift-Tab 或上/下移动字段。Enter 保存。Esc 取消。
tui-form-submit-uid-required = UID 为必填
tui-form-submit-dest-required = destination节点 is required
tui-form-submit-nonneg-int = { $label } 必须为非负整数
tui-form-submit-gt-zero = { $label } 必须大于 0
tui-form-submit-local-ae-required = 本地 AE title 为必填
tui-form-submit-local-ae-invalid = 本地 AE title 无效：{ $err }
tui-form-submit-bind-required = 绑定地址为必填
tui-form-submit-port-required = 端口为必填
tui-form-submit-max-pdu-required = 最大 PDU 长度为必填
tui-form-submit-max-pdu-int = 最大 PDU 长度必须为整数
tui-form-submit-max-pdu-gt-zero = 最大 PDU 长度必须大于 0
tui-form-submit-patient-retrieve = 不支持患者级检索
tui-form-submit-no-study-uid = 所选结果不含 study UID
tui-form-submit-date-format = 应为 YYYYMMDD
tui-form-submit-modality-len = 模态最多 16 个字符
tui-form-submit-modality-chars = 模态必须为 A-Z 或 0-9
tui-form-submit-name-required = 节点名称为必填
tui-form-submit-ae-required = AE title 为必填
tui-form-submit-host-required = 主机为必填
tui-form-submit-move-dest-invalid = 移动目标 AE title 无效：{ $err }
tui-form-submit-dates-both = 起始日期与结束日期必须同时设置，或同时留空
tui-form-submit-date-from-invalid = 起始日期无效：{ $err }
tui-form-submit-date-to-invalid = 结束日期无效：{ $err }
tui-form-submit-date-order = 起始日期必须不晚于结束日期
tui-form-submit-study-uid-series-query = 序列级查询需要 study UID
tui-form-submit-study-uid-image-query = 影像级查询需要 study UID
tui-form-submit-series-uid-image-query = 影像级查询需要 series UID
tui-form-submit-study-uid-required = study UID 为必填
tui-form-submit-study-uid-invalid = study UID 无效：{ $err }
tui-form-submit-series-uid-series-retrieve = 序列级检索需要 series UID
tui-form-submit-series-uid-image-retrieve = 影像级检索需要 series UID
tui-form-submit-instance-uid-image-retrieve = 影像级检索需要 instance UID
tui-form-submit-series-uid-invalid = series UID 无效：{ $err }
tui-form-submit-instance-uid-invalid = instance UID 无效：{ $err }
tui-form-submit-import-path-required = 导入路径为必填
tui-form-submit-import-path-type = 导入路径必须是文件或目录：{ $path }
tui-form-submit-import-access = 正在访问导入路径 { $path }
tui-form-submit-import-open = 正在打开导入文件 { $path }
tui-form-submit-import-read-dir = 正在读取导入目录 { $path }
tui-log-welcome = Press F1 or ? for help. Focus 远程节点s and press 'a' to add one.
tui-log-logging-to = 正在记录到 { $path }
tui-command-help-heading = 命令：
tui-command-help-next-1 = 说明：页脚会根据当前焦点窗格和选择显示上下文“Next:”建议。
tui-command-help-next-2 = 这些只是提示；你随时可以输入任何命令。
tui-command-help-canonical = 说明：规范名称与不含 '--' 的 CLI 标志一致，使用下划线。
tui-command-help-cancel = cancel（别名：stop）
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
tui-command-help-refresh = 刷新
tui-command-help-quit = 退出
tui-inspect-task = 任务 #{ $id }
tui-inspect-status = 状态：{ $status }
tui-inspect-description = 描述：{ $description }
tui-inspect-progress = 进度：{ $progress }
tui-inspect-summary = 摘要：
tui-inspect-no-logs = (无日志)
tui-field-sop-class-uid = SOP Class UID
tui-field-transfer-syntax-uid = Transfer Syntax UID
tui-field-sha256 = SHA-256
tui-status-removed-nodes =
    已删除 { $count ->
        [one] { $count }个节点
       *[other] { $count }个节点
    }
tui-status-removed-nodes-target =
    已删除 { $count ->
        [one] { $count }个节点
       *[other] { $count }个节点
    }; 上次目标为 { $name }
tui-status-more-failures =
    另有 { $n ->
        [one] { $n }条失败已省略
       *[other] { $n }条失败已省略
    }
tui-status-retrieve-ok = retrieve status=0x{ $status } completed={ $completed } failed={ $failed } warning={ $warning } remaining={ $remaining }
tui-status-import-counts = scanned={ $scanned } accepted={ $accepted } duplicates={ $duplicates } unreadable={ $unreadable } invalid_dicom={ $invalid } rejected_total={ $rejected } stored_bytes={ $bytes }
tui-status-send-ok = send attempted={ $attempted } sent={ $sent } failed={ $failed }
tui-log-query-start = 开始向 { $node } 查询
tui-log-retrieve-start = 开始从 { $node } 检索
tui-log-import-start = 开始导入 { $path }
tui-log-send-study-start = 开始将检查 { $uid } 发送到 { $node }
tui-log-send-series-start = 开始将序列 { $uid } 发送到 { $node }
tui-log-cancelled-before-start = 启动前已取消
tui-log-cancelled = 已取消
error-unknown-command = 未知命令：{ $command }
error-node-subcommand-required = 需要 node 子命令
error-local-subcommand-required = 需要 local 子命令
error-unsupported-node-subcommand = unsupported节点 subcommand: { $command }
error-unsupported-local-subcommand = 不支持的 local 子命令：{ $command }
error-expected-kv = 需要 key=value 参数，实际为 { $arg }
error-missing-required-arg = 缺少必填参数：{ $key }
error-missing-required-arg-one-of = 缺少必填参数（之一）：{ $keys }
error-parsing-command = 正在解析命令
error-edit-form-lost-target = edit form lost its target节点
error-task-already-running = 后台任务已在运行
error-task-thread-launch = 无法启动后台任务线程：{ $error }
error-task-disconnected = 后台任务线程在发送结果前断开
error-task-kind-missing = 后台任务线程已断开，但 active_task_kind 为 None：意外状态
error-serve-exited = serve 因错误退出：{ $error }
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
summary-title = 操作摘要
summary-kind = 类型
summary-status = 状态
summary-duration = 持续时间
summary-duration-ms = { $ms }ms
summary-peer = 对端
summary-ae = AE
summary-criteria = 条件
summary-counts = 计数
summary-failures = 失败：
summary-logs = 日志：
summary-unserializable = <无法序列化>
summary-log-lines = 行 { $start }-{ $end }
