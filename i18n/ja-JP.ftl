# Fluent catalog (ja-JP). Message IDs are hyphenated identifiers
# (cli-about, tui-pane-remote-nodes, desktop-nav-dashboard, error-import-file-too-large).
# Dotted names are Fluent attributes (message + .attr), not message IDs.
# Do not translate DICOM tokens (C-FIND, C-MOVE, C-STORE, SOP, AE, UID) or JSON/CSV machine keys.


## CLI
cli-about = dicom-rs で構築した、ターミナル優先の DICOM ノードクライアント
cli-arg-accession-number = 受付番号で絞り込みます（大文字小文字を区別しない部分一致）。
cli-arg-ae-title = Application Entity title
cli-arg-destination-node = 宛先ノードの名前または ID
cli-arg-duplicate = 重複ステータスで絞り込みます。
cli-arg-export = 結果を JSON または CSV でエクスポートします。
cli-arg-host = ホスト名または IP
cli-arg-imported-at =
    インポート時刻で絞り込みます。VALUE、START..END、..END、START.. に対応します。
    辞書順で比較します（推奨形式: RFC3339）。
cli-arg-json = 操作の最終サマリーを JSON で出力します（スキーマは固定）。
cli-arg-level = 照会/取得レベル
cli-arg-metrics-json = サーバー終了時にメモリ内メトリクスのスナップショットを JSON で出力します。
cli-arg-modality = モダリティで絞り込みます。カンマ区切り（例: CT,MR）。
cli-arg-model = 照会/取得の情報モデル
cli-arg-move-destination = 優先する C-MOVE 宛先 AE Title
cli-arg-name = ノードの表示名
cli-arg-node = 保存済みノードの名前または ID
cli-arg-notes = 自由記述のメモ
cli-arg-out = 出力ファイルのパス。省略時は標準出力へ書き込みます。
cli-arg-path = インポートするファイルまたはディレクトリ
cli-arg-patient-id = 患者 ID で絞り込みます（大文字小文字を区別しない部分一致）。
cli-arg-patient-name = 患者名で絞り込みます（大文字小文字を区別しない部分一致）。
cli-arg-port = ポート
cli-arg-series-description = シリーズ記述で絞り込みます（大文字小文字を区別しない部分一致）。
cli-arg-series-instance-uid = Series Instance UID
cli-arg-sop-instance-uid = SOP Instance UID
cli-arg-source-path = ソースパスで絞り込みます（大文字小文字を区別しない部分一致）。
cli-arg-study-date =
    検査日で絞り込みます。VALUE、START..END、..END、START.. に対応します。
    日付は辞書順で比較します（推奨形式: YYYYMMDD）。
cli-arg-study-date-from = 検査日の下限（YYYYMMDD）
cli-arg-study-date-to = 検査日の上限（YYYYMMDD）
cli-arg-study-description = 検査記述で絞り込みます（大文字小文字を区別しない部分一致）。
cli-arg-study-instance-uid = Study Instance UID
cli-cmd-import-about = パスから DICOM ファイルをインポートします
cli-cmd-local-about = ローカルアーカイブを確認します
cli-cmd-local-series-about = 検査内のインデックス済みシリーズを一覧表示します
cli-cmd-local-studies-about = インデックス済みローカル検査を一覧表示します
cli-cmd-node-about = 保存済みのリモート DICOM ノードを管理します
cli-cmd-node-add-about = リモートノードを追加します
cli-cmd-node-delete-about = 保存済みノードを削除します
cli-cmd-node-edit-about = 保存済みノードを編集します
cli-cmd-node-list-about = 保存済みノードを一覧表示します
cli-cmd-query-about = リモートノードを照会します（C-FIND）
cli-cmd-retrieve-about = リモートノードから取得します（C-MOVE）
cli-cmd-send-about = ローカル検査またはシリーズを送信します（C-STORE）
cli-cmd-send-series-about = シリーズを宛先ノードへ送信します
cli-cmd-send-study-about = 検査を宛先ノードへ送信します
cli-cmd-serve-about = DICOM サーバーを実行します
cli-cmd-storage-scp-about = Storage SCP リスナーを実行します
cli-cmd-tui-about = 対話型ターミナル UI を開きます
cli-flag-help = ヘルプを表示
cli-flag-lang = UI 言語（BCP-47 タグ）。DICOM_NODE_LANG、保存済みロケール、OS のロケールより優先します。
cli-flag-version = バージョンを表示
cli-heading-arguments = 引数:
cli-heading-commands = コマンド:
cli-heading-options = オプション:
cli-heading-usage = 使い方:
cli-import-accepted = accepted={ $n }
cli-import-complete = インポート完了
cli-import-duplicates = duplicates={ $n }
cli-import-scanned = scanned={ $n }
cli-msg-cancel-sigint = キャンセルが要求されました（SIGINT）。正常終了を待っています...
cli-msg-failures = 失敗:
cli-msg-import-failed = インポート失敗: { $error }
cli-msg-no-local-series = 検査 { $uid } にインデックス済みシリーズはありません
cli-msg-no-local-studies = インデックス済みローカル検査はありません
cli-msg-no-saved-nodes = 保存済みノードはありません
cli-msg-query-failed = 照会失敗: { $error }
cli-msg-removed-nodes =
    削除 { $count ->
        [one] { $count }件のノード
       *[other] { $count }件のノード
    }
cli-msg-results-count =
    結果: { $count ->
        [one] { $count }件一致
       *[other] { $count }件一致
    }
cli-msg-retrieve-failed = 取得失敗: { $error }
cli-msg-saved-node = ノード { $name } [{ $id }] を保存しました => { $ae }@{ $host }:{ $port }
cli-msg-send-failed = 送信失敗: { $error }
cli-msg-showing-failures = （失敗 { $total } 件中、先頭 { $shown } 件を表示）
cli-msg-starting-server =
    DICOM サーバーを開始: { $count ->
        [one] { $count }件のローカル AE
       *[other] { $count }件のローカル AE
    } { $aes }
cli-msg-starting-server-no-aes = 設定済みローカル AE なしで DICOM サーバーを起動します
cli-msg-starting-storage-scp = { $addr } で Storage SCP を起動します（AE Title { $ae }）
cli-msg-updated-node = ノード { $name } [{ $id }] を更新しました => { $ae }@{ $host }:{ $port }
cli-send-attempted = attempted={ $n }
cli-send-failed-count = failed={ $n }
cli-send-sent = sent={ $n }
cli-value-name-file = FILE
cli-value-name-format = FORMAT
cli-value-name-locale = LOCALE
cli-value-name-path = PATH
tui-detail-more-series =
    ... { $n ->
        [one] { $n }件の追加シリーズ
       *[other] { $n }件の追加シリーズ
    }
tui-row-instance-count =
    { $n ->
        [one] { $n }件
       *[other] { $n }件
    }
tui-row-study-counts = { $series }s/{ $instances }i
count-nodes =
    { $n ->
        [one] { $n }件のノード
       *[other] { $n }件のノード
    }
count-instances =
    { $n ->
        [one] { $n }件のインスタンス
       *[other] { $n }件のインスタンス
    }
count-series =
    { $n ->
        [one] { $n }件のシリーズ
       *[other] { $n }件のシリーズ
    }
count-studies =
    { $n ->
        [one] { $n }件の検査
       *[other] { $n }件の検査
    }
format-datetime = { $date } { $time }
format-date = { $year }/{ $month }/{ $day }

## Common
common-accession = 受付番号
common-add = 追加
common-back = 戻る
common-bytes = バイト
common-cancel = キャンセル
common-clear = クリア
common-close = 閉じる
common-date = 日付
common-delete = ノードを削除
common-description = 記述
common-disabled = 無効
common-duplicates = 重複
common-edit = 編集
common-enabled = 有効
common-error = エラー
common-filter = フィルター
common-host = ホスト
common-import = インポート
common-instance = インスタンス
common-language = 言語
common-loading = 読み込み中
common-matches = 一致
common-modality = モダリティ
common-name = 名前
common-network = ネットワーク
common-no = いいえ
common-none = なし
common-notes = メモ
common-optional = 任意
common-path = ソース
common-patient = 患者
common-patient-id = 患者 ID
common-patient-name = 患者名
common-port = ポート
common-query = 照会
common-refresh = 更新
common-required = 必須
common-retrieve = 取得
common-save = 保存
common-search = 検索
common-send = 送信
common-series = シリーズ
common-start = 開始
common-status = 状態
common-stop = 停止
common-studies = 検査
common-study = スタディ
common-unknown = 不明
common-unknown-series = <シリーズ>
common-unknown-study = <検査>
common-yes = はい

## Errors
error-ae-empty = AE title を空にできません
error-ae-invalid-char = AE title に無効な文字 '{ $character }' が含まれています。使用可能: A-Z、0-9、スペース
error-ae-required = AE Title は必須です
error-ae-too-long = AE title は最大 16 文字です
error-ae-whitespace = AE title の先頭または末尾に空白を含められません
error-archive-patient-retrieve-out-of-scope = Patient レベルの retrieve は対象外です
error-archive-retrieve-uid-required = この retrieve レベルには { $name } が必要です
error-archive-study-root-patient-query = Study Root クエリは Patient レベルをサポートしません
error-archive-study-root-patient-retrieve = Study Root retrieve は Patient レベルをサポートしません
error-assoc-negotiation-failed = { $name } ({ $addr }) との association ネゴシエーションに失敗しました。ヒント: called AE title、presentation contexts/transfer syntaxes、ピアが association を受け入れるかを確認してください
error-assoc-no-addresses = { $name } のソケットアドレスを { $host }:{ $port } で解決できませんでした
error-assoc-receive = association の受信
error-assoc-resolving = { $name } を { $host }:{ $port } で解決しています: { $err }
error-assoc-timeout = DIMSE 応答の待機がタイムアウトしました。ヒント: ネットワーク、AE title/ホスト/ポート、ピアの応答を確認してください
error-assoc-transport = DIMSE 応答の待機中にトランスポートが中断されました。ヒント: ピアが接続を閉じたか、ネットワーク機器がリセットした可能性があります
error-assoc-unreachable = { $seconds }s 以内に { $name } [{ $ae }] ({ $host }:{ $port }) へ到達できませんでした: { $err }。ホスト/IP、ポート、ネットワーク到達性を確認してください
error-cancel-sigint = キャンセルが要求されました (SIGINT)。正常終了を待っています...
error-config-must-be-positive = 無効な設定: { $name } は 0 より大きい必要があります（無効化する場合は null）
error-config-duplicate-bind-port = 無効な設定: ローカル AE の bind ポート { $port } が重複しています
error-config-local-ae-max-assoc = 無効な設定: ローカル AE { $title } の max_concurrent_associations は 0 より大きい必要があります
error-config-local-ae-no-services = 無効な設定: ローカル AE { $title } は少なくとも 1 つのサービスを有効にする必要があります
error-config-must-be-positive-required = 無効な設定: { $name } は 0 より大きい必要があります
error-dicom-meta-incomplete = DICOM ファイルメタが不完全です
error-dicom-patient-move-unsupported = このクライアントでは患者レベルの C-MOVE はサポートされていません
error-dicom-required-attribute = 必須の DICOM 属性がありません: ({ $group },{ $element })
error-dicom-series-uid-required-image = 画像レベルの retrieve には series_instance_uid が必要です
error-dicom-series-uid-required-series = シリーズレベルの retrieve には series_instance_uid が必要です
error-dicom-sop-uid-required-image = 画像レベルの retrieve には sop_instance_uid が必要です
error-dicom-study-uid-required = study_instance_uid が必要です
error-dicom-validating-move = move 要求を検証しています
error-export-creating-file = エクスポートファイルを作成しています { $path }: { $err }
error-export-flushing-series-csv = シリーズ CSV をフラッシュしています: { $err }
error-export-flushing-studies-csv = スタディ CSV をフラッシュしています: { $err }
error-export-serializing-series-json = シリーズ JSON をシリアライズしています: { $err }
error-export-serializing-studies-json = スタディ JSON をシリアライズしています: { $err }
error-export-writing-series-csv-header = シリーズ CSV ヘッダーを書き込んでいます: { $err }
error-export-writing-series-csv-row = シリーズ CSV 行を書き込んでいます: { $err }
error-export-writing-studies-csv-header = スタディ CSV ヘッダーを書き込んでいます: { $err }
error-export-writing-studies-csv-row = スタディ CSV 行を書き込んでいます: { $err }
error-import-cleanup-failed = { $source }: クリーンアップに失敗しました: { $reason }
error-import-corrupt-zip = 破損した ZIP: { $details }
error-import-dicom-parse-failed = DICOM の解析に失敗しました: { $err }
error-import-dicom-validation-failed = DICOM の検証に失敗しました: { $err }
error-import-duplicate-zip-path = ZIP に '{ $path }' を指すエントリが複数あります
error-import-file-too-large = ファイルが大きすぎます: { $details }
error-import-invalid-dicom = 無効な DICOM: { $details }
error-import-limit-exceeded = { $limit } を超えました: { $details }
error-import-not-regular-file = 通常のファイルではありません
error-import-opening-file = ファイルを開いています: { $err }
error-import-opening-kind = { $kind } { $path } を開いています
error-import-opening-staged-file = ステージ済みファイルを開いています: { $err }
error-import-opening-zip-archive = ZIP アーカイブを開いています { $path }
error-import-opening-zip-entry = ZIP エントリを開いています: { $err }
error-import-opening-zip-file = ZIP インポートファイルを開いています { $path }
error-import-path-does-not-exist = インポートパスが存在しません: { $path }
error-import-reading-directory = インポートディレクトリを読み取っています { $path }
error-import-reading-file = ファイルを読み取っています: { $err }
error-import-reading-file-metadata = { $path } のファイルメタデータを読み取っています
error-import-reading-metadata = { $kind } { $path } のメタデータを読み取っています
error-import-reading-zip-entry = ZIP エントリを読み取っています: { $err }
error-import-removing-staged-after-cancel = キャンセル後にステージ済みファイルを削除しています { $path }
error-import-skipped = { $source }: スキップしました: { $reason }
error-import-unreadable = 読み取れないファイル: { $details }
error-import-unsafe-zip-path = エントリのパスがアーカイブの外へ出ています
error-import-zip-entry-count-exceeded = ZIP エントリ数の上限を超えました: アーカイブは { $count } 件、上限は { $limit }
error-import-zip-entry-size-exceeded = ZIP エントリサイズ { $size } が上限 { $limit } を超えています
error-import-zip-total-bytes-exceeded = ZIP 展開バイト合計の上限を超えました: 現在の合計 { $current } にエントリサイズ { $entry } を足すと上限 { $limit } を超えます
error-net-binding-storage-scp = { $addr } で AE { $ae } の Storage SCP をバインド中。別のローカル DICOM 受信がそのポートを使用中の可能性があります。{ $config } の storage_scp_port/local_aes を更新するか、競合するリスナーを停止してください
error-net-building-file-meta = ファイルメタテーブルを構築中
error-net-cannot-send-transfer-syntax = ソース transfer syntax { $source } を交渉済み { $negotiated } で送信できません
error-net-cget-dataset-empty = 符号化された C-GET C-STORE データセットが空です
error-net-cget-dataset-odd-length = 符号化 C-GET C-STORE データセットが奇数長の末尾フラグメントで終わりました
error-net-cget-peer-released = C-GET 中にピアがアソシエーションを解放しました
error-net-cget-store-unexpected-dataset = 予期しない dataset fragment in C-GET C-STORE response
error-net-cget-unexpected-command = 予期しない command 0x{ $command } while waiting for C-STORE-RSP
error-net-cget-unexpected-pdu = 予期しない PDU during C-GET C-STORE suboperation: { $pdu }
error-net-creating-incoming-dir = Storage SCP の .incoming ディレクトリを作成中
error-net-creating-path = { $path } を作成中
error-net-dataset-empty = 符号化データセットは空ですが COMMAND_DATA_SET_TYPE はデータセット必須を示します
error-net-dataset-odd-length = 符号化データセットが奇数長の末尾フラグメントで終わりました
error-net-dimse-failed = { $operation } がステータス 0x{ $status } ({ $meaning }) で失敗{ $hint }
error-net-establishing-assoc = Storage SCP アソシエーションを確立中
error-net-file-meta-length = 読み取り File Meta Information length
error-net-file-meta-tag = 読み取り File Meta Information tag
error-net-file-meta-value = File Meta Information 値をスキップ中
error-net-file-meta-vr = 読み取り File Meta Information VR
error-net-file-position = 読み取り file position
error-net-flushing-path = { $path } をフラッシュ中
error-net-flushing-temp-dataset = 一時データセットファイルをフラッシュ中
error-net-hint-suffix = ; ヒント: { $hint }
error-net-incomplete-command = 不完全 { $operation } command response
error-net-incomplete-identifier = 不完全 { $operation } response identifier
error-net-invalid-affected-sop = 無効 { $operation } affected SOP class UID
error-net-invalid-status = 無効 { $operation } status
error-net-listener-address = 読み取り storage SCP listener address
error-net-listener-nonblocking = リスナーを非ブロッキングモードに設定中
error-net-listener-port = 読み取り storage SCP listener port
error-net-local-aes-empty = Storage SCP を開始するには local_aes に少なくとも 1 つの AE が必要です
error-net-locating-dataset = { $path } 内のデータセットを検索中
error-net-malformed-dimse = malformed { $operation } DIMSE response: { $details }; ヒント: peer sent an 無効 or 予期しない DIMSE command set
error-net-missing-affected-sop = 欠落 { $operation } affected SOP class UID
error-net-missing-command-field = 欠落 command field
error-net-missing-cstore-rsp-command-field = 欠落 C-STORE response command field
error-net-missing-cstore-rsp-status = 欠落 C-STORE response status
error-net-missing-destination = 欠落 C-MOVE destination
error-net-missing-dicm = 欠落 Part 10 DICM marker
error-net-missing-message-id = 欠落 { $operation } message id
error-net-missing-qr-level = { $operation } identifier is 欠落 QueryRetrieveLevel
error-net-missing-required-command-field = 欠落 required command field { $name } ({ $tag })
error-net-missing-status = 欠落 { $operation } status
error-net-move-destination-unresolved = move_destination を解決できませんでした
error-net-no-cget-store-context = SOP Class { $sop } / transfer syntax { $syntax } のネゴシエート済み C-GET ストレージプレゼンテーションコンテキストがありません
error-net-no-compatible-context = { $path }: ソース transfer syntax { $syntax } に互換するネゴシエート済みプレゼンテーションコンテキストがありません
error-net-no-dimse-provider = コマンド 0x{ $command } / abstract syntax { $syntax } の DIMSE プロバイダが登録されていません
error-net-no-presentation-context = ネゴシエート済みのプレゼンテーションコンテキストがありません
error-net-no-presentation-context-for-file = { $path }: ネゴシエート済みプレゼンテーションコンテキストがありません
error-net-no-presentation-context-id = 欠落 negotiated presentation context { $id }
error-net-opening-path = 開く { $path }
error-net-part10-preamble = 読み取り Part 10 preamble
error-net-path-error = { $path }: { $err }
error-net-pdata-feed-complete = cannot feed P-DATA fragment into a complete accumulator (欠落 take())
error-net-peer-aborted = C-GET C-STORE サブ操作中にピアがアソシエーションを中止: { $source }
error-net-peer-socket = 読み取り storage SCP peer socket address
error-net-reading-command-dataset = 読み取り command dataset
error-net-reading-identifier = 読み取り { $operation } identifier
error-net-reading-incoming-dataset = 読み取り incoming C-STORE dataset
error-net-reading-response-dataset = 読み取り { $operation } response dataset
error-net-remote-aborted = リモートがアソシエーションを中止しました: { $source }
error-net-restoring-read-timeout = association の読み取りタイムアウトを復元しています
error-net-restoring-write-timeout = association の書き込みタイムアウトを復元しています
error-net-rewinding-dataset = データセットの先頭要素へ巻き戻し中
error-net-scp-thread-panicked = Storage SCP スレッドがパニックしました
error-net-seeking-temp-dataset = 一時データセットファイルをシーク中
error-net-serializing-cget-dataset = { $path } の C-GET サブ操作データセットをシリアライズ中
error-net-serializing-dataset = { $path } のデータセットを transfer syntax { $syntax } でシリアライズ中
error-net-setting-socket-blocking = 受け入れたストレージソケットをブロッキングモードに設定中
error-net-sending-buffered-dataset = { $path } のバッファ済みデータセットを送信中
error-net-store-status = リモートが C-STORE ステータス 0x{ $status } ({ $meaning }) を返しました{ $hint }
error-net-streaming-dataset = C-STORE データセットをストリーミング中
error-net-unexpected-command-field = 予期しない CommandField 0x{ $actual } (expected 0x{ $expected } for { $rsp })
error-net-unexpected-dataset-fragment = 予期しない dataset fragment in C-STORE response
error-net-unexpected-pdu = 予期しない PDU during { $operation }: { $pdu }
error-net-unknown-status = 無効 { $operation } status 0x{ $status }
error-net-unsupported-model-sop = 未対応 { $operation } model SOP class UID: { $uid }
error-net-unsupported-qr-level = 未対応 QueryRetrieveLevel: { $level }
error-net-unsupported-transfer-syntax = 未対応 negotiated transfer syntax
error-net-writing-command-dataset = 書き込み command dataset
error-net-writing-identifier = 書き込み { $operation } identifier
error-net-writing-path = 書き込み { $path }
error-net-writing-response-dataset = 書き込み { $operation } response dataset
error-net-writing-temp-dataset = 書き込み dataset bytes to temp file
error-node-host-empty = ノードのホストを空にできません
error-node-name-empty = ノード名を空にできません
error-node-not-found = リモートノードが見つかりません: { $id }
error-operation-cancelled = 操作がキャンセルされました
error-port-invalid = 無効なポート: { $value }
error-port-range = ポートは 1 から 65535 の間である必要があります
error-query-no-study-uid = 一致に StudyInstanceUID がないため取得できません。
error-query-unsupported-level = 未対応のクエリレベル: { $value }
error-query-unsupported-model = 未対応のクエリモデル: { $value }
error-retrieve-canceled = リモートノードが retrieve をキャンセルしました (status=0x{ $status }, completed={ $completed }, failed={ $failed }, warning={ $warning }, remaining={ $remaining }, { $scp })
error-retrieve-failed = retrieve が status=0x{ $status } で失敗しました (completed={ $completed }, failed={ $failed }, warning={ $warning }, remaining={ $remaining }, { $scp })
error-retrieve-nothing-arrived = 宛先 { $destination } の retrieve は completed={ $completed } で終了しましたが、ローカル Storage SCP ({ $scp }) に何も到着しませんでした。AE マッピングまたはポートを確認してください: { $listener } が空いており、リモートノードが AE { $destination } をこのアプリにマップしていることを確認してください
error-send-no-files-series = シリーズ { $uid } にインデックス済みのローカルファイルがありません
error-send-no-files-study = スタディ { $uid } にインデックス済みのローカルファイルがありません
error-task-cancelled = タスクはキャンセルされました
error-task-none-to-cancel = キャンセルする実行中タスクはありません
error-tracing-init = tracing subscriber を初期化しています: { $err }
error-uid-component-numeric = UID コンポーネント '{ $part }' は数字である必要があります
error-uid-component-too-long = UID コンポーネント '{ $part }' が長すぎます
error-uid-dot-ends = UID はドットで開始または終了できません
error-uid-empty = UID は空にできません
error-uid-empty-component = UID に空のコンポーネントを含められません
error-uid-leading-zeros = UID コンポーネント '{ $part }' に先頭ゼロは使えません
error-uid-too-long = UID は 64 文字以内である必要があります

## TUI
tui-bool-no = いいえ
tui-bool-off = オフ
tui-bool-on = オン
tui-bool-yes = はい
tui-command-placeholder = コマンドを入力するか、ペインのショートカットを使います。
tui-config-ae-title = AE title: { $value }
tui-config-edit-hint = Tab でこのペインにフォーカスし、'c' で編集します。
tui-config-hint = Tab でこのペインにフォーカスし、'c' で編集します。
tui-config-listener = リスナー: { $value }
tui-config-max-pdu = max_pdu_length: { $value }
tui-config-promiscuous = allow_promiscuous_storage: { $value }
tui-config-strict-pdu = strict_pdu: { $value }
tui-config-ts-pref = TS 優先: { $value }
tui-controls-hint = Tab で項目移動 · Enter で確定 · Esc で取消
tui-detail-ae-title = AE Title
tui-detail-instance = インスタンス詳細
tui-detail-name = 名前
tui-detail-node = ノード詳細
tui-detail-placeholder-followup = リストペインにフォーカスし、選択を変えてこの表示を更新します。
tui-detail-query = 照会結果詳細
tui-detail-select-node = リモートノードを選んでメタデータを確認します。
tui-detail-series = シリーズ詳細
tui-detail-study = 検査詳細
tui-empty-command-placeholder = コマンドを入力するか、ペインのショートカットを使います。
tui-empty-detail-instance = インスタンスを選んで確認するか、Esc でシリーズに戻ります。
tui-empty-detail-node = リモートノードを選んでメタデータを確認します。
tui-empty-detail-query = クエリ結果を選んでメタデータと retrieve の文脈を確認します。
tui-empty-detail-series = シリーズを選んで確認するか、Esc でスタディに戻ります。
tui-empty-detail-study = ローカルスタディを選んで患者とシリーズのメタデータを確認します。
tui-empty-instances = このシリーズにインデックス済みインスタンスはありません。
tui-empty-instances-hint = Esc でシリーズ一覧に戻ります。
tui-empty-local-instances = このシリーズにインデックス済みインスタンスはありません。
tui-empty-local-instances-hint = Esc でシリーズ一覧に戻ります。
tui-empty-local-series = この検査にインデックス済みシリーズはありません。
tui-empty-local-series-hint = Esc でローカル検査一覧に戻ります。
tui-empty-local-studies = インデックス済みの検査はまだありません。
tui-empty-local-studies-cmd = 例: import path=/data/inbox
tui-empty-local-studies-hint = 先にローカル DICOM ファイルをインポートしてください。
tui-empty-no-name = <名前なし>
tui-empty-query = 照会はまだ実行されていません。
tui-empty-query-body =
    リモートノードを選び、'f' で照会します。
    または: query node=pacs
        patient_name="DOE^JOHN"
    選択した結果で 'm' を押すと retrieve を開きます。
tui-empty-query-cmd = または: query node=pacs
tui-empty-query-hint = リモートノードを選び、'f' で照会します。
tui-empty-query-last-target = 前回の照会先: { $name }
tui-empty-query-none = 照会はまだ実行されていません。
tui-empty-query-retrieve-hint = 選択した結果で 'm' を押すと retrieve を開きます。
tui-empty-remote-nodes =
    保存済みのリモートノードはまだありません。
    
    このペインで a を押して追加します。
    または: node add name=pacs
        ae=PACSAE host=10.0.0.10
        port=104
tui-empty-remote-nodes-cmd = または: node add name=pacs
tui-empty-remote-nodes-hint = このペインで a を押して追加します。
tui-empty-series = この検査にインデックス済みシリーズはありません。
tui-empty-series-hint = Esc でローカル検査一覧に戻ります。
tui-empty-studies = インデックス済みの検査はまだありません。
tui-empty-studies-hint = 先にローカル DICOM ファイルをインポートしてください。
tui-empty-tasks-history = タスク履歴はありません。
tui-empty-tasks-queued = 待機中のタスクはありません。
tui-fallback-no-name = <名前なし>
tui-field-accession = 受付番号
tui-field-ae-title = AE title
tui-field-bind-addr = バインドアドレス
tui-field-date-from = 開始日
tui-field-date-to = 終了日
tui-field-destination-node = 送信先ノード
tui-field-host = ホスト
tui-field-instance-uid = Instance UID
tui-field-kind = 種類
tui-field-level = レベル
tui-field-local-ae = ローカル AE
tui-field-max-pdu = 最大 PDU
tui-field-modality = モダリティ
tui-field-model = モデル
tui-field-move-destination = Move 宛先
tui-field-name = 名前
tui-field-notes = メモ
tui-field-path = パス
tui-field-patient-id = 患者 ID
tui-field-patient-name = 患者名
tui-field-port = ポート
tui-field-promiscuous = 無制限受信
tui-field-series-uid = Series UID
tui-field-sop-uid = SOP Instance UID
tui-field-strict-pdu = 厳密 PDU
tui-field-study-description = 検査記述
tui-field-study-uid = Study UID
tui-footer-back-series = Esc シリーズへ
tui-footer-back-studies = Esc 検査へ
tui-footer-cancel-task = c キャンセル
tui-footer-edit-config = c 設定を編集
tui-footer-enter-series = Enter シリーズ
tui-footer-esc-series = Esc シリーズへ
tui-footer-esc-studies = Esc 検査へ
tui-footer-help = F1/? ヘルプ
tui-footer-inspect = Enter 詳細
tui-footer-next = 次: { $text }
tui-footer-nodes = a/e/d/fノード
tui-footer-panes = Tab ペイン
tui-footer-queued =
    { $n ->
        [one] { $n }件待機
       *[other] { $n }件待機
    }
tui-footer-quit = q 終了
tui-footer-refresh = r 再読み込み
tui-footer-retrieve = m 取得
tui-footer-run-command = Enter コマンド実行
tui-footer-task-scope = t 待機/履歴
tui-form-add-node = リモートノードの追加
tui-form-add-remote-node = リモートノードの追加
tui-form-delete-confirm = リモートノード { $name } [{ $ae }]（{ $host }:{ $port }）を削除しますか？
tui-form-delete-node = リモートノードの削除
tui-form-delete-remote-node = リモートノードの削除
tui-form-edit-node = リモートノードの編集
tui-form-edit-remote-node = リモートノードの編集
tui-form-err-ae-required = ! AE title は必須です
tui-form-err-bind-required = ! バインドアドレスは必須です
tui-form-err-host-required = ! ホストは必須です
tui-form-err-local-ae-invalid = ! 無効なローカル AE title: { $err }
tui-form-err-local-ae-required = ! ローカル AE title は必須です
tui-form-err-modality-empty = modality 空にできません
tui-form-err-move-dest-invalid = ! 無効な移動先 AE title: { $err }
tui-form-err-name-required = !ノード name is required
tui-form-err-port-required = ! ポートは必須です
tui-form-err-uid-empty = UID は空にできません
tui-form-err-uid-empty-component = UID に空のコンポーネントを含められません
tui-form-error-line = エラー: { $error }
tui-form-field-accession = 受付番号
tui-form-field-ae-title = AE title
tui-form-field-bind-addr = バインドアドレス
tui-form-field-date-from = 開始日
tui-form-field-date-to = 終了日
tui-form-field-dest-node = 送信先ノード
tui-form-field-destination = 宛先 AE
tui-form-field-host = ホスト
tui-form-field-instance-uid = SOP Instance UID
tui-form-field-kind = 種類
tui-form-field-level = レベル
tui-form-field-local-ae = ローカル AE
tui-form-field-modality = モダリティ
tui-form-field-model = モデル
tui-form-field-move-dest = Move 宛先
tui-form-field-name = 名前
tui-form-field-notes = メモ
tui-form-field-path = パス
tui-form-field-patient-id = 患者 ID
tui-form-field-patient-name = 患者名
tui-form-field-port = ポート
tui-form-field-series-uid = Series Instance UID
tui-form-field-sop-uid = SOP Instance UID
tui-form-field-study-desc = 検査記述
tui-form-field-study-uid = Study Instance UID
tui-form-field-uid = UID
tui-form-hint-bind = ヒント: 通常は 0.0.0.0（全インターフェース）または 127.0.0.1
tui-form-hint-local-ae = ヒント: 最大 16 文字（A-Z、0-9、空白）、例 ARCHIVE_AE
tui-form-hint-move-dest = ヒント: 任意。C-MOVE 宛先 AE title を上書き
tui-form-hint-name = ヒント: 短いラベル（例: PACS）
tui-form-import = ローカルファイルのインポート
tui-form-import-local = ローカルファイルのインポート
tui-form-import-local-files = ローカルファイルのインポート
tui-form-mode-add = create a new リモートノード
tui-form-mode-edit = update the selected リモートノード
tui-form-query-node = リモートノードの照会
tui-form-query-remote-node = リモートノードの照会
tui-form-remote-node-line = リモートノード: { $name } [{ $ae }] { $host }:{ $port }
tui-form-retrieve = 一致項目の取得
tui-form-retrieve-matches = 一致項目の取得
tui-form-send-series = シリーズの送信
tui-form-send-study = 検査の送信
tui-form-storage-intro = ローカル Storage SCP 設定を編集（config.json に保存）。
tui-form-storage-scp = Storage SCP 設定
tui-form-storage-scp-settings = Storage SCP 設定
tui-help-ae-title = AE title: { $value }
tui-help-aedf = a/e/d/f     Add, edit, delete, or query from the selectedノード
tui-help-c = c           Storage SCP 設定を編集（設定ペインにフォーカス時）
tui-help-canonical-names = 正規名は '--' なしの CLI フラグに一致し、アンダースコアを使います。
tui-help-close = Esc、F1、または ? でヘルプを閉じます。
tui-help-common-commands = よく使うコマンド
tui-help-config = c           Storage SCP 設定を編集（設定ペインにフォーカス時）
tui-help-config-path = 設定パス: { $value }
tui-help-current-config = 現在の設定
tui-help-data-dir = データディレクトリ: { $value }
tui-help-enter-default = Enter       Run the command input, submit the active modal, or open series from ローカル検査
tui-help-enter-instance = Enter       インスタンス表示ではローカルペイン操作なし
tui-help-enter-local-instance = Enter       インスタンス表示ではローカルペイン操作なし
tui-help-enter-local-series = Enter       選択したローカルシリーズのインスタンスを開く、またはコマンド入力実行 / アクティブなモーダル送信
tui-help-enter-local-study = Enter       選択したローカル検査のシリーズを開く、またはコマンド入力実行 / アクティブなモーダル送信
tui-help-enter-series = Enter       選択したローカルシリーズのインスタンスを開く、またはコマンド入力実行 / アクティブなモーダル送信
tui-help-enter-study = Enter       選択したローカル検査のシリーズを開く、またはコマンド入力実行 / アクティブなモーダル送信
tui-help-esc-default = Esc         ヘルプ/モーダルを閉じる、ローカルシリーズから戻る、またはコマンド入力へフォーカス
tui-help-esc-instance = Esc         ローカルインスタンスからシリーズへ戻る、ヘルプ/モーダルを閉じる、またはコマンド入力へフォーカス
tui-help-esc-instances = Esc         ローカルインスタンスからシリーズへ戻る、ヘルプ/モーダルを閉じる、またはコマンド入力へフォーカス
tui-help-esc-series = Esc         ローカルシリーズから検査へ戻る、ヘルプ/モーダルを閉じる、またはコマンド入力へフォーカス
tui-help-f1 = F1 または ?     ヘルプを開く
tui-help-import-send = i/s         インポート local files or send selected study/series
tui-help-is = i/s         インポート local files or send selected study/series
tui-help-listener = リスナー: { $value }
tui-help-log-dir = ログディレクトリ: { $value }
tui-help-m = m           選択したクエリ結果から取得
tui-help-max-pdu = max_pdu_length: { $value }
tui-help-move = 上下または j/k   リストペインの選択を移動
tui-help-nodes = a/e/d/f     Add, edit, delete, or query from the selectedノード
tui-help-open = F1 または ?     ヘルプを開く
tui-help-promiscuous = allow_promiscuous_storage: { $value }
tui-help-q = q           モーダルがなく、フォーカスがコマンド入力にないとき終了
tui-help-quit = q           モーダルがなく、フォーカスがコマンド入力にないとき終了
tui-help-r = r           更新 panes when focus is いいえt in command input
tui-help-receiver-mode = 受信モード: { $value }
tui-receiver-mode-on-demand = ローカル retrieve のオンデマンド
tui-receiver-mode-standalone = storage-scp によるスタンドアロン
tui-help-refresh = r           更新 panes when focus is いいえt in command input
tui-help-retrieve = m           選択したクエリ結果から取得
tui-help-strict-pdu = strict_pdu: { $value }
tui-help-tab = Tab / Shift-Tab  フォーカスペインを切替
tui-help-title = キー割り当て
tui-help-ts-pref = preferred_store_transfer_syntax: { $value }
tui-help-updown = 上下または j/k   リストペインの選択を移動
tui-input-placeholder = コマンドを入力するか、ペインのショートカットを使います。
tui-log-command = > { $command }
tui-log-error = エラー: { $error }
tui-log-refreshed = 更新済み
tui-logs-capped-suffix = 上限あり
tui-logs-label = ログ:
tui-pane-command = コマンド
tui-pane-config = 設定
tui-pane-detail = 詳細
tui-pane-detail-hint = { $title } (PgUp/PgDn 入力していないとき)
tui-pane-help = ヘルプ
tui-pane-instance-detail = インスタンス詳細
tui-pane-instances-for = インスタンス: { $uid }
tui-pane-local-studies = ローカル検査
tui-pane-logs = ログ（{ $shown }/{ $total }{ $capped }）
tui-pane-logs-capped = ログ ({ $shown }/{ $total } capped)
tui-pane-logs-uncapped = ログ ({ $shown }/{ $total })
tui-pane-node-detail = ノード詳細
tui-pane-query-detail = 照会結果詳細
tui-pane-query-node = ノードを照会
tui-pane-query-result-detail = 照会結果詳細
tui-pane-query-results = 照会 / 取得結果
tui-pane-query-retrieve-results = 照会 / 取得結果
tui-pane-remote-nodes = リモートノード
tui-pane-series-detail = シリーズ詳細
tui-pane-series-for = シリーズ: { $uid }
tui-pane-series-unknown = シリーズ: <不明な検査>
tui-pane-study-detail = 検査詳細
tui-pane-task-details = タスク詳細
tui-pane-tasks-history = タスク（履歴）
tui-pane-tasks-queued = タスク（待機）
tui-pane-unknown-series = <不明なシリーズ>
tui-pane-unknown-study = シリーズ: <不明な検査>
tui-row-inst = inst
tui-status-cancel-requested = キャンセルlation requested
tui-status-config = 設定
tui-status-configured-listener = リスナー { $addr } を AE { $ae }（{ $mode }）として設定
tui-status-data = データ
tui-status-failure = 失敗: { $failure }
tui-status-listener = リスナー
tui-status-local-ae = ローカル AE
tui-status-mode = モード
tui-status-mode-on-demand = オンデマンド
tui-status-mode-standalone = スタンドアロン
tui-status-no-active-task = 実行中のタスクはありません to cancel (nothing running)
tui-status-pdu = PDU
tui-status-promiscuous = 無制限受信
tui-status-query-before-retrieve = Query a リモートノード first so retrieve knows whichノード to use
tui-status-query-failed = クエリ失敗: { $error }
tui-status-queued-op = 待機中の操作: { $op }
tui-status-retrieve-failed = 取得失敗: { $error }
tui-status-retrieve-open-failed = 開けませんでした retrieve stream: { $error }
tui-status-saved-node = savedノード { $name } ({ $id })
tui-status-saved-scp = Storage SCP 設定を保存しました（再起動が必要）
tui-status-select-node = 先にリモートノードを選択してください
tui-status-select-query = 先にクエリ結果を選択してください
tui-status-select-study = 先にローカル検査を選択してください
tui-status-strict = 厳密
tui-status-task-cancelled = タスクはキャンセルされました
tui-status-task-cancelled-detail = タスクキャンセル: { $other }
tui-status-ts-pref = TS 優先
tui-status-updated-node = updatedノード { $name } ({ $id })
tui-suggest-back-series = Esc — シリーズに戻る
tui-suggest-edit-config = c — 設定を編集
tui-suggest-help = F1/? — ヘルプ
tui-suggest-inspect-task = Enter — タスクを検査
tui-suggest-node-add = node add <ae-title> <host:port>
tui-suggest-query = f — query aノード
tui-suggest-query-node = f — query selectedノード
tui-suggest-retrieve = m — 選択を取得
tui-suggest-run-command = Enter — コマンド実行
tui-suggest-send-series = s — 選択シリーズを送信
tui-suggest-view-series = Enter — シリーズを表示
tui-task-cancelled = キャンセル済み
tui-task-cancelling = キャンセル中
tui-task-failed = 失敗
tui-task-failed-generic = タスク失敗: { $error }
tui-task-import-done = インポート complete: { $report }
tui-task-import-failed = インポート失敗: { $error }
tui-task-importing = { $path } をインポート中...
tui-task-query-done =
    クエリ完了: { $count ->
        [one] { $count }件一致
       *[other] { $count }件一致
    }
tui-task-query-failed = 照会失敗: { $error }
tui-task-querying = { $node } を照会中...
tui-task-queued = 待機中
tui-task-retrieve-done = 取得完了: { $outcome }
tui-task-retrieve-failed = 取得失敗: { $error }
tui-task-retrieving = { $node } から取得中...
tui-task-running = 実行中
tui-task-sending-series = シリーズ { $uid } を { $node } へ送信中...
tui-task-sending-study = 検査 { $uid } を { $node } へ送信中...
tui-task-send-done = 送信完了: { $outcome }
tui-task-status-cancelled = キャンセル済み
tui-task-status-cancelling = キャンセル中
tui-task-status-failed = 失敗
tui-task-status-ok = ok
tui-task-status-queued = 待機中
tui-task-status-running = 実行中
tui-task-succeeded = 成功
tui-terminal-too-small = 端末が小さすぎます。ウィンドウを大きくしてください

## Desktop
desktop-action-activity = アクティビティ { $count }
desktop-action-activity-empty = アクティビティ
desktop-action-import = インポート
desktop-action-inspect-archive = ローカルアーカイブを確認
desktop-action-inspect-archive-desc = スタディ・シリーズ・インスタンスを確認し、送信またはエクスポートします。
desktop-action-manage-peers = ピアを管理
desktop-action-manage-peers-desc = query / retrieve / store で使う PACS やワークステーションノードを追加・編集します。
desktop-action-monitor-scp = Storage SCP を監視
desktop-action-query = 照会
desktop-action-refresh = 状態を更新
desktop-action-refresh-status = 状態を更新
desktop-action-reveal-log = ログファイルを表示
desktop-action-send = 送信
desktop-action-start-scp = Storage SCP を開始
desktop-activity-empty = このセッションのアクティビティはまだありません。
desktop-activity-title = アクティビティ
desktop-app-title = DICOM Node
desktop-archive-csv = CSV
desktop-archive-details = 詳細
desktop-archive-empty = ローカルアーカイブは空です。
desktop-archive-export-fail = { $scope } のエクスポートに失敗
desktop-archive-export-ok =
    { $rows ->
        [one] { $rows } 行の { $scope } を { $path } にエクスポートしました。
       *[other] { $rows } 行の { $scope } を { $path } にエクスポートしました。
    }
desktop-archive-export-studies = 検査をエクスポート
desktop-archive-export-title = { $scope } をエクスポート
desktop-archive-filter = 患者、UID、記述、モダリティで絞り込み…
desktop-archive-filter-placeholder = 患者、UID、記述、モダリティで絞り込み…
desktop-archive-inst-abbrev =
    { $count ->
        [one] { $count }件
       *[other] { $count }件
    }
desktop-archive-instance-meta = { $bytes } · TS { $ts } · 取り込み { $imported }
desktop-archive-instances = インスタンス
desktop-archive-instances-heading = インスタンス
desktop-archive-json = JSON
desktop-archive-loading = 検査を読み込み中…
desktop-archive-no-filter-match = フィルタに一致する検査はありません。
desktop-archive-no-instances = インスタンスがありません。
desktop-archive-no-match = フィルタに一致する検査はありません。
desktop-archive-no-nodes = ノードなし
desktop-archive-no-series = シリーズがありません。
desktop-archive-reveal-file = ファイルを表示
desktop-archive-select-series = シリーズを選択してください。
desktop-archive-select-study = 検査を選択してください。
desktop-archive-send-fail = { $label }: { $sent }/{ $attempted } 送信、{ $failed } 失敗。 { $failures }
desktop-archive-send-fail-title = { $label } 失敗
desktop-archive-send-ok = { $label }: { $sent }/{ $attempted } インスタンスを送信。
desktop-archive-send-series = シリーズを送信
desktop-archive-send-series-label = シリーズ → { $destination }
desktop-archive-send-study = 検査を送信
desktop-archive-send-study-label = 検査 → { $destination }
desktop-archive-send-to = 送信先
desktop-archive-series = シリーズ
desktop-archive-series-count =
    #{ $number } · { $count ->
        [one] { $count } インスタンス
       *[other] { $count } インスタンス
    }
desktop-archive-series-fallback = シリーズ
desktop-archive-studies = 検査
desktop-archive-study-date = 検査日
desktop-archive-study-uid = Study UID
desktop-archive-subtitle = ローカル SQLite アーカイブの検査・シリーズ・インスタンス一覧。
desktop-archive-title = ローカルアーカイブ
desktop-brand-title = DICOM Node
desktop-col-description = 記述
desktop-col-instances = インスタンス
desktop-col-modalities = モダリティ
desktop-col-patient-id = 患者 ID
desktop-common-cancel = キャンセル
desktop-common-clear = クリア
desktop-common-disabled = 無効
desktop-common-enabled = 有効
desktop-common-loading = 読み込み中…
desktop-common-no = いいえ
desktop-common-refresh = 更新
desktop-common-yes = はい
desktop-counter-assoc-accepted = 受理したアソシエーション
desktop-counter-bytes-ingested = 取り込みバイト
desktop-counter-cfind-requests = C-FIND 要求
desktop-counter-cmove-requests = C-MOVE 要求
desktop-counter-cstore-failed = C-STORE 失敗
desktop-counter-cstore-stored = C-STORE 格納
desktop-dashboard-counter-assoc-accepted = 受理したアソシエーション
desktop-dashboard-counter-bytes-ingested = 取り込みバイト
desktop-dashboard-counter-c-find-requests = C-FIND 要求
desktop-dashboard-counter-c-move-requests = C-MOVE 要求
desktop-dashboard-counter-c-store-failed = C-STORE 失敗
desktop-dashboard-counter-c-store-stored = C-STORE 格納
desktop-dashboard-empty-studies = ローカル検査はまだありません。
desktop-dashboard-inspect-archive-body = 検査、シリーズ、インスタンスを確認し、送信またはエクスポートします。
desktop-dashboard-inspect-archive-title = ローカルアーカイブを確認
desktop-dashboard-kv-ae-title = AE Title
desktop-dashboard-kv-data-dir = データディレクトリ
desktop-dashboard-kv-listener = リスナー
desktop-dashboard-kv-log-file = ログファイル
desktop-dashboard-kv-max-pdu = 最大 PDU
desktop-dashboard-kv-promiscuous = 無制限ストレージ
desktop-dashboard-kv-server = サーバー
desktop-dashboard-kv-store-syntax = Store シンタックス
desktop-dashboard-kv-strict-pdu = 厳密 PDU
desktop-dashboard-listener-missing = リスナーはまだ読み込まれていません。
desktop-dashboard-live-counters = ライブカウンタ
desktop-dashboard-loading-metrics = メトリクスを読み込み中…
desktop-dashboard-loading-status = ローカル状態を読み込み中…
desktop-dashboard-loading-studies = 検査を読み込み中…
desktop-dashboard-local-node = ローカルノード
desktop-dashboard-manage-peers-body = 照会、取得、ストアに使う PACS / ワークステーションノードを追加・編集します。
desktop-dashboard-manage-peers-title = ピアを管理
desktop-dashboard-metric-instances = インスタンス
desktop-dashboard-metric-nodes = リモートノード
desktop-dashboard-metric-series = シリーズ
desktop-dashboard-metric-studies = 検査
desktop-dashboard-monitor-scp = Storage SCP を監視
desktop-dashboard-recent-studies = 最近の検査
desktop-dashboard-start-scp = Storage SCP を開始
desktop-dashboard-subtitle = ローカルアーカイブ、ネットワークピア、SCP 状況を一覧します。
desktop-dashboard-title = オペレーターダッシュボード
desktop-doc-title = DICOM Node
desktop-import-accepted = 受理
desktop-import-accepted-bytes = 受理バイト
desktop-import-activity-detail = { $accepted }/{ $scanned } 受理、重複 { $duplicates }、{ $bytes }
desktop-import-activity-fail = インポート失敗
desktop-import-activity-ok = インポート完了
desktop-import-choose-archive = インポートする ZIP を選択
desktop-import-choose-dir = インポートするディレクトリを選択
desktop-import-choose-folder = フォルダ
desktop-import-choose-zip = インポートする ZIP を選択
desktop-import-cleanup = クリーンアップ
desktop-import-clear-path = パスをクリア
desktop-import-complete = インポート完了
desktop-import-dup-sha = SHA-256
desktop-import-dup-sop = SOP UID
desktop-import-dup-total = 合計
desktop-import-duplicates = 重複
desktop-import-failed = インポート失敗
desktop-import-failed-cleanup = クリーンアップ失敗
desktop-import-failures = 失敗
desktop-import-failures-heading =
    { $count ->
        [one] { $count } 件の失敗:
       *[other] { $count } 件の失敗:
    }
desktop-import-failures-more = … 他 { $count } 件
desktop-import-files-progress = { $label } ファイル
desktop-import-folder = フォルダ
desktop-import-invalid-dicom = 無効な DICOM
desktop-import-pick-dir = インポートするディレクトリを選択
desktop-import-pick-zip = インポートする ZIP を選択
desktop-import-placeholder = /path/to/dicom-folder or /path/to/archive.zip
desktop-import-rejected = 拒否
desktop-import-report = インポート報告
desktop-import-running = インポート中…
desktop-import-scanned = 走査
desktop-import-skipped = スキップ
desktop-import-source = ソース
desktop-import-start = インポート開始
desktop-import-stored = 格納
desktop-import-subtitle = 再帰フォルダまたは ZIP アーカイブから DICOM ファイルを管理ローカルアーカイブへ索引します。
desktop-import-title = インポート
desktop-import-unreadable = 読み取り不可
desktop-import-zip = ZIP
desktop-import-zip-filter = ZIP アーカイブ
desktop-lang-label = 言語
desktop-listener-not-loaded = リスナーはまだ読み込まれていません。
desktop-live-counters = ライブカウンタ
desktop-loading = 読み込み中
desktop-loading-local-status = ローカル状態を読み込み中…
desktop-loading-metrics = メトリクスを読み込み中…
desktop-loading-studies = 検査を読み込み中…
desktop-local-node = ローカルノード
desktop-locale-label = 言語
desktop-logs-activity-detail =
    { $count ->
        [one] { $count } 行を読み込み
       *[other] { $count } 行を読み込み
    }
desktop-logs-activity-fail = ログ更新に失敗
desktop-logs-activity-ok = ログを更新しました
desktop-logs-auto = 自動
desktop-logs-auto-refresh = 自動更新
desktop-logs-empty = ログファイルは空です。
desktop-logs-found = ログファイルあり
desktop-logs-lines =
    { $count ->
        [one] { $count }行
       *[other] { $count }行
    }
desktop-logs-loading = ログ読み込み中…
desktop-logs-missing = アクティブなログファイルはまだ作成されていません。
desktop-logs-refresh-failed = ログ更新に失敗
desktop-logs-refreshed = ログを更新しました
desktop-logs-reveal = 表示
desktop-logs-subtitle = アクティブなデスクトップログの有限テール。
desktop-logs-tail = テール
desktop-logs-title = ログ
desktop-logs-truncated = 切り詰め
desktop-logs-waiting = ログファイル待ち
desktop-metric-instances = インスタンス
desktop-metric-remote-nodes = リモートノード
desktop-metric-series = シリーズ
desktop-metric-studies = 検査
desktop-nav-archive = ローカルアーカイブ
desktop-nav-dashboard = ダッシュボード
desktop-nav-import = インポート
desktop-nav-logs = ログ
desktop-nav-network = ネットワーク
desktop-nav-nodes = リモートノード
desktop-nav-query = 照会 / 取得
desktop-nav-server = Storage サーバー
desktop-no-local-studies = ローカル検査はまだありません。
desktop-nodes-add = ノードを追加
desktop-nodes-added = ノード "{ $name }" を追加しました。
desktop-nodes-ae-length = AE Title は 16 文字以下である必要があります。
desktop-nodes-ae-title = AE Title
desktop-nodes-col-move = Move 宛先
desktop-nodes-configured = 設定済みノード
desktop-nodes-confirm-delete = ノード "{ $name }" を削除しますか？
desktop-nodes-default-port = 既定ポート 104
desktop-nodes-delete = ノードを削除
desktop-nodes-delete-title = ノードを削除
desktop-nodes-deleted = ノード "{ $name }" を削除しました。
desktop-nodes-edit = ノードを編集
desktop-nodes-edit-title = ノードを編集
desktop-nodes-empty = リモートノードはまだありません。
desktop-nodes-err-ae = AE タイトルは必須です。
desktop-nodes-err-ae-len = AE タイトルは 16 文字以内です。
desktop-nodes-err-host = ホストは必須です。
desktop-nodes-err-name = 名前は必須です。
desktop-nodes-err-port = ポートは 1～65535 です。
desktop-nodes-host = ホスト
desktop-nodes-move-dest = Move 宛先
desktop-nodes-move-placeholder = 既定はローカル AE
desktop-nodes-name = 名前
desktop-nodes-need-ae = AE Title は必須です。
desktop-nodes-need-host = ホストは必須です。
desktop-nodes-need-name = 名前は必須です。
desktop-nodes-notes = メモ
desktop-nodes-notes-placeholder = 読影室 PACS
desktop-nodes-placeholder-ae = PACS01
desktop-nodes-placeholder-host = 192.168.0.10
desktop-nodes-placeholder-move = 既定はローカル AE
desktop-nodes-placeholder-name = main-pacs
desktop-nodes-placeholder-notes = 読影室 PACS
desktop-nodes-port = ポート
desktop-nodes-port-104 = 既定ポート 104
desktop-nodes-port-range = ポートは 1〜65535 である必要があります。
desktop-nodes-save = 変更を保存
desktop-nodes-save-changes = 変更を保存
desktop-nodes-subtitle = 照会・取得・ストア用の PACS / ワークステーションピア。
desktop-nodes-summary = ノード概要
desktop-nodes-title = リモートノード
desktop-nodes-total = ノード総数
desktop-nodes-updated = ノード "{ $name }" を更新しました。
desktop-nodes-with-move = Move 宛先あり
desktop-promiscuous = 無制限ストレージ
desktop-query-accession = 受付番号
desktop-query-activity-detail = { $count } { $count ->
        [one] 件
       *[other] 件
    } レベル { $level }
desktop-query-activity-fail = C-FIND { $node } 失敗
desktop-query-activity-ok = C-FIND { $node }
desktop-query-activity-title = C-FIND { $node }
desktop-query-clear = クリア
desktop-query-col-accession = 受付番号
desktop-query-criteria = 検索条件
desktop-query-date-from = 検査日（開始）
desktop-query-date-to = 検査日（終了）
desktop-query-kv-series-uid = Series UID
desktop-query-kv-sop-uid = SOP UID
desktop-query-kv-study-uid = Study UID
desktop-query-level = レベル
desktop-query-matches =
    { $count ->
        [one] { $count } 件一致
       *[other] { $count } 件一致
    }
desktop-query-missing-study-uid = 一致に StudyInstanceUID がないため取得できません。
desktop-query-modality = モダリティ
desktop-query-no-matches = 一致なし。
desktop-query-no-nodes = ノードが設定されていません
desktop-query-patient-id = 患者 ID
desktop-query-patient-name = 患者名
desktop-query-placeholder-description = CHEST*
desktop-query-placeholder-modality = CT, MR, …
desktop-query-placeholder-name = DOE^JOHN or DOE*
desktop-query-placeholder-patient = DOE^JOHN or DOE*
desktop-query-querying = 照会中…
desktop-query-remote-node = リモートノード
desktop-query-results = 結果
desktop-query-retrieve = 取得
desktop-query-retrieve-activity-detail = completed={ $completed }, warning={ $warning }, failed={ $failed }
desktop-query-retrieve-activity-fail = C-MOVE { $node } 失敗
desktop-query-retrieve-activity-ok = C-MOVE { $node }
desktop-query-retrieve-finished = 取得完了: 完了 { $completed }、警告 { $warning }、失敗 { $failed }。
desktop-query-retrieve-selected = 選択を取得
desktop-query-run = C-FIND 実行
desktop-query-run-select = 照会を実行し、一致を選択してください。
desktop-query-running = 照会中…
desktop-query-search-criteria = 検索条件
desktop-query-select-hint = 照会を実行し、一致を選択してください。
desktop-query-selected = 選択中の一致
desktop-query-selected-match = 選択中の一致
desktop-query-series-uid = Series Instance UID
desktop-query-sop-uid = SOP Instance UID
desktop-query-study-description = 検査記述
desktop-query-study-uid = Study Instance UID
desktop-query-subtitle = リモートノードへ C-FIND し、一致を確認してからローカルアーカイブへ C-MOVE します。
desktop-query-title = 照会 / 取得
desktop-recent-studies = 最近の検査
desktop-scp-listening = SCP 待ち受け中
desktop-scp-stopped = SCP 停止中
desktop-server-activity-fail = Storage SCP 制御に失敗
desktop-server-activity-started = Storage SCP 開始
desktop-server-activity-started-detail = リスナーを開始しました。
desktop-server-activity-stopped = Storage SCP 停止
desktop-server-activity-stopped-detail = received={ $received }, stored={ $stored }, failed={ $failed }
desktop-server-activity-stopped-empty = アクティブなセッションはありません。
desktop-server-addr-ae = { $addr } · AE { $ae }
desktop-server-assoc-accepted = 受理したアソシエーション
desktop-server-assoc-rejected = 拒否したアソシエーション
desktop-server-cfind-req-matches = C-FIND 要求 / 一致
desktop-server-cget-requests = C-GET 要求
desktop-server-cmove-requests = C-MOVE 要求
desktop-server-cmove-subops = C-MOVE サブ操作 完了 / 失敗
desktop-server-control-failed = Storage SCP 制御に失敗
desktop-server-counter-bytes = 取り込みバイト
desktop-server-counter-failed = C-STORE 失敗
desktop-server-counter-find = C-FIND 要求 / 一致
desktop-server-counter-get = C-GET 要求
desktop-server-counter-move = C-MOVE 要求
desktop-server-counter-move-sub = C-MOVE サブ操作 完了 / 失敗
desktop-server-counter-received = C-STORE 受信
desktop-server-counter-stored = C-STORE 格納
desktop-server-cstore-failed = C-STORE 失敗
desktop-server-cstore-received = C-STORE 受信
desktop-server-cstore-stored = C-STORE 格納
desktop-server-dimse = DIMSE カウンタ
desktop-server-failed = 失敗
desktop-server-health-loading = メトリクス読み込み中
desktop-server-health-ready = 着信 C-STORE の準備完了
desktop-server-health-review = 失敗を確認
desktop-server-health-stopped = 停止
desktop-server-listener-started = リスナーを開始しました。
desktop-server-listening = 待ち受け中
desktop-server-loading-metrics = メトリクスを読み込み中…
desktop-server-logs = ログ
desktop-server-no-session = アクティブなセッションはありません。
desktop-server-rate = +{ $rate } / ポーリング
desktop-server-ready = 着信 C-STORE の準備完了
desktop-server-review-failures = 失敗を確認
desktop-server-session-ended = セッション終了: 受信 { $received }、格納 { $stored }、失敗 { $failed }。
desktop-server-start = サーバー開始
desktop-server-started-title = Storage SCP 開始
desktop-server-stop = サーバー停止
desktop-server-stopped = 停止中
desktop-server-stopped-pill = 停止中
desktop-server-stopped-status = 停止
desktop-server-stopped-title = Storage SCP 停止
desktop-server-stored = 格納
desktop-server-subtitle = 着信 C-STORE とローカルアーカイブ索引のためのスタンドアロン Storage SCP。
desktop-server-title = Storage サーバー
desktop-status-listening = 待ち受け中
desktop-status-loading = 読み込み中
desktop-status-scp-listening = SCP 待ち受け中
desktop-status-scp-stopped = SCP 停止中
desktop-status-stopped = 停止中
desktop-store-syntax = Store シンタックス
desktop-strict-pdu = 厳密 PDU
desktop-strip-pdu = PDU { $value }
desktop-table-accession = 受付番号
desktop-table-ae-title = AE タイトル
desktop-table-date = 日付
desktop-table-description = 記述
desktop-table-endpoint = エンドポイント
desktop-table-instances = インスタンス
desktop-table-modalities = モダリティ
desktop-table-modality = モダリティ
desktop-table-move-dest = Move 先
desktop-table-name = 名前
desktop-table-notes = メモ
desktop-table-patient = 患者
desktop-table-patient-id = 患者 ID
desktop-table-series = シリーズ
desktop-table-updated = 更新日時
desktop-title-refresh-status = 状態を更新
desktop-title-reveal-log = ログファイルを表示
ae = AE
patient-name =
    "DOE^JOHN"
    選択した結果で 'm' を押すと retrieve を開きます。
port = ポート

## Summary
summary-ae = AE
summary-counts = 件数
summary-criteria = 条件
summary-duration = 所要時間
summary-duration-ms = { $ms }ms
summary-failures = 失敗:
summary-kind = 種類
summary-logs = ログ:
summary-peer = ピア
summary-status = 状態
summary-title = 操作の要約
tui-detail-created = 作成済み

tui-form-hint-port-range = ヒント: 1〜65535 の数値、例 104
tui-form-hint-promiscuous = ヒント: 任意の呼び出し元 AE title からの保存を許可
tui-form-hint-strict-pdu = ヒント: アソシエーション中に PDU サイズ検査を実施
tui-form-hint-max-pdu-bytes = ヒント: バイト、例 16384
tui-form-limits-heading = Limits (bytes; blank/なし = unlimited):
tui-form-field-max-file-import = ファイルインポート最大バイト
tui-form-field-max-zip-entry = ZIP エントリ最大バイト
tui-form-field-max-zip-total = ZIP 合計最大バイト
tui-form-field-max-zip-count = ZIP エントリ最大数
tui-form-field-max-store-object = ストアオブジェクト最大バイト
tui-form-unlimited = 無制限
tui-form-err-max-pdu-required = ! 最大 PDU 長は必須です
tui-form-err-max-pdu-gt-zero = ! 最大 PDU 長は 0 より大きい整数である必要があります
tui-form-err-limit-gt-zero = ! { $label } は 0 より大きい整数である必要があります
tui-form-controls-scp = 入力して編集。Space でチェック切替。Tab/Shift-Tab または上下で項目移動。Enter で保存。Esc で取消。
tui-form-submit-uid-required = UID は必須です
tui-form-submit-dest-required = destinationノード is required
tui-form-submit-nonneg-int = { $label } は負でない整数である必要があります
tui-form-submit-gt-zero = { $label } は 0 より大きくなければなりません
tui-form-submit-local-ae-required = ローカル AE title は必須です
tui-form-submit-local-ae-invalid = ローカル AE title が無効です: { $err }
tui-form-submit-bind-required = バインドアドレスは必須です
tui-form-submit-port-required = ポートは必須です
tui-form-submit-max-pdu-required = 最大 PDU 長は必須です
tui-form-submit-max-pdu-int = 最大 PDU 長は整数である必要があります
tui-form-submit-max-pdu-gt-zero = 最大 PDU 長は 0 より大きくなければなりません
tui-form-submit-patient-retrieve = 患者レベルの取得は未サポートです
tui-form-submit-no-study-uid = 選択結果に study UID がありません
tui-form-submit-date-format = YYYYMMDD 形式
tui-form-submit-modality-len = モダリティは最大 16 文字です
tui-form-submit-modality-chars = モダリティは A-Z または 0-9
tui-form-submit-name-required = ノード名は必須です
tui-form-submit-ae-required = AE title は必須です
tui-form-submit-host-required = ホストは必須です
tui-form-submit-move-dest-invalid = 移動先 AE title が無効です: { $err }
tui-form-submit-dates-both = 開始日と終了日は両方設定するか、どちらも未設定にしてください
tui-form-submit-date-from-invalid = 開始日が無効です: { $err }
tui-form-submit-date-to-invalid = 終了日が無効です: { $err }
tui-form-submit-date-order = 開始日は終了日以前である必要があります
tui-form-submit-study-uid-series-query = シリーズレベルクエリには study UID が必要です
tui-form-submit-study-uid-image-query = 画像レベルクエリには study UID が必要です
tui-form-submit-series-uid-image-query = 画像レベルクエリには series UID が必要です
tui-form-submit-study-uid-required = study UID は必須です
tui-form-submit-study-uid-invalid = study UID が無効です: { $err }
tui-form-submit-series-uid-series-retrieve = シリーズレベル取得には series UID が必要です
tui-form-submit-series-uid-image-retrieve = 画像レベル取得には series UID が必要です
tui-form-submit-instance-uid-image-retrieve = 画像レベル取得には instance UID が必要です
tui-form-submit-series-uid-invalid = series UID が無効です: { $err }
tui-form-submit-instance-uid-invalid = instance UID が無効です: { $err }
tui-form-submit-import-path-required = インポートパスは必須です
tui-form-submit-import-path-type = インポートパスはファイルまたはディレクトリである必要があります: { $path }
tui-form-submit-import-access = インポートパス { $path } にアクセス
tui-form-submit-import-open = インポートファイル { $path } を開いています
tui-form-submit-import-read-dir = インポートディレクトリ { $path } を読み取り中
tui-log-welcome = Press F1 or ? for help. Focus リモートノードs and press 'a' to add one.
tui-log-logging-to = { $path } に記録
tui-command-help-heading = コマンド:
tui-command-help-next-1 = 注: フッターはフォーカス中のペインと選択に応じた「Next:」提案を表示します。
tui-command-help-next-2 = ヒントのみです。いつでも任意のコマンドを入力できます。
tui-command-help-canonical = 注: 正規名は '--' なしの CLI フラグと一致し、アンダースコアを使います。
tui-command-help-cancel = cancel（別名: stop）
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
tui-command-help-refresh = 更新
tui-command-help-quit = 終了
tui-inspect-task = タスク #{ $id }
tui-inspect-status = 状態: { $status }
tui-inspect-description = 説明: { $description }
tui-inspect-progress = 進捗: { $progress }
tui-inspect-summary = 概要:
tui-inspect-no-logs = (ログなし)
tui-field-sop-class-uid = SOP Class UID
tui-field-transfer-syntax-uid = Transfer Syntax UID
tui-field-sha256 = SHA-256
tui-status-removed-nodes =
    削除 { $count ->
        [one] { $count }件のノード
       *[other] { $count }件のノード
    }
tui-status-removed-nodes-target =
    削除 { $count ->
        [one] { $count }件のノード
       *[other] { $count }件のノード
    }; 最後の対象は { $name }
tui-status-more-failures =
    さらに { $n ->
        [one] { $n }件の失敗を省略
       *[other] { $n }件の失敗を省略
    }
tui-status-retrieve-ok = retrieve status=0x{ $status } completed={ $completed } failed={ $failed } warning={ $warning } remaining={ $remaining }
tui-status-import-counts = scanned={ $scanned } accepted={ $accepted } duplicates={ $duplicates } unreadable={ $unreadable } invalid_dicom={ $invalid } rejected_total={ $rejected } stored_bytes={ $bytes }
tui-status-send-ok = send attempted={ $attempted } sent={ $sent } failed={ $failed }
tui-log-query-start = { $node } へのクエリを開始
tui-log-retrieve-start = { $node } からの取得を開始
tui-log-import-start = { $path } のインポートを開始
tui-log-send-study-start = 検査 { $uid } の { $node } への送信を開始
tui-log-send-series-start = シリーズ { $uid } の { $node } への送信を開始
tui-log-cancelled-before-start = 開始前にキャンセル
tui-log-cancelled = キャンセル済み
error-unknown-command = 不明なコマンド: { $command }
error-node-subcommand-required = node サブコマンドが必要です
error-local-subcommand-required = local サブコマンドが必要です
error-unsupported-node-subcommand = unsupportedノード subcommand: { $command }
error-unsupported-local-subcommand = 未対応の local サブコマンド: { $command }
error-expected-kv = key=value 引数が必要です。実際: { $arg }
error-missing-required-arg = 必須引数がありません: { $key }
error-missing-required-arg-one-of = 必須引数がありません（いずれか）: { $keys }
error-parsing-command = コマンドを解析中
error-edit-form-lost-target = edit form lost its targetノード
error-task-already-running = バックグラウンドタスクは既に実行中です
error-task-thread-launch = バックグラウンドタスクスレッドを起動できません: { $error }
error-task-disconnected = 結果送信前にバックグラウンドタスクスレッドが切断されました
error-task-kind-missing = バックグラウンドタスクスレッドが切断されましたが active_task_kind は None です（予期しない状態）
error-serve-exited = serve がエラーで終了: { $error }
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
summary-title = 操作の要約
summary-kind = 種類
summary-status = 状態
summary-duration = 所要時間
summary-duration-ms = { $ms }ms
summary-peer = ピア
summary-ae = AE
summary-criteria = 条件
summary-counts = 件数
summary-failures = 失敗:
summary-logs = ログ:
summary-unserializable = <シリアライズ不可>
summary-log-lines = 行 { $start }-{ $end }
