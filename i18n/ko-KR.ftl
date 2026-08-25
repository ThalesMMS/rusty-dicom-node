# Fluent catalog (ko-KR). Message IDs are hyphenated identifiers
# (cli-about, tui-pane-remote-nodes, desktop-nav-dashboard, error-import-file-too-large).
# Dotted names are Fluent attributes (message + .attr), not message IDs.
# Do not translate DICOM tokens (C-FIND, C-MOVE, C-STORE, SOP, AE, UID) or JSON/CSV machine keys.


## CLI
cli-about = dicom-rs로 만든 터미널 우선 DICOM 노드 클라이언트
cli-arg-accession-number = 접수번호로 필터링합니다(대소문자 무시 부분 일치).
cli-arg-ae-title = Application Entity title
cli-arg-destination-node = 대상 노드 이름 또는 ID
cli-arg-duplicate = 중복 상태로 필터링합니다.
cli-arg-export = 결과를 JSON 또는 CSV로 내보냅니다.
cli-arg-host = 호스트 이름 또는 IP
cli-arg-imported-at =
    가져오기 시각으로 필터링합니다. VALUE, START..END, ..END, START..를 지원합니다.
    사전순으로 비교합니다(권장 형식: RFC3339).
cli-arg-json = 작업의 최종 요약을 JSON으로 출력합니다(스키마 고정).
cli-arg-level = 조회/가져오기 레벨
cli-arg-metrics-json = 서버 종료 시 메모리 내 메트릭 스냅샷을 JSON으로 출력합니다.
cli-arg-modality = 모달리티로 필터링합니다. 쉼표로 구분(예: CT,MR).
cli-arg-model = 조회/가져오기 정보 모델
cli-arg-move-destination = 기본 C-MOVE 대상 AE Title
cli-arg-name = 노드 표시 이름
cli-arg-node = 저장된 노드 이름 또는 ID
cli-arg-notes = 자유 형식 메모
cli-arg-out = 출력 파일 경로. 생략하면 표준 출력으로 씁니다.
cli-arg-path = 가져올 파일 또는 디렉터리
cli-arg-patient-id = 환자 ID로 필터링합니다(대소문자 무시 부분 일치).
cli-arg-patient-name = 환자 이름으로 필터링합니다(대소문자 무시 부분 일치).
cli-arg-port = 포트
cli-arg-series-description = 시리즈 설명으로 필터링합니다(대소문자 무시 부분 일치).
cli-arg-series-instance-uid = Series Instance UID
cli-arg-sop-instance-uid = SOP Instance UID
cli-arg-source-path = 소스 경로로 필터링합니다(대소문자 무시 부분 일치).
cli-arg-study-date =
    검사 날짜로 필터링합니다. VALUE, START..END, ..END, START..를 지원합니다.
    날짜는 사전순으로 비교합니다(권장 형식: YYYYMMDD).
cli-arg-study-date-from = 검사일 하한(YYYYMMDD)
cli-arg-study-date-to = 검사일 상한(YYYYMMDD)
cli-arg-study-description = 검사 설명으로 필터링합니다(대소문자 무시 부분 일치).
cli-arg-study-instance-uid = Study Instance UID
cli-cmd-import-about = 경로에서 DICOM 파일을 가져옵니다
cli-cmd-local-about = 로컬 아카이브를 확인합니다
cli-cmd-local-series-about = 검사의 인덱싱된 시리즈를 나열합니다
cli-cmd-local-studies-about = 인덱싱된 로컬 검사를 나열합니다
cli-cmd-node-about = 저장된 원격 DICOM 노드를 관리합니다
cli-cmd-node-add-about = 원격 노드를 추가합니다
cli-cmd-node-delete-about = 저장된 노드를 삭제합니다
cli-cmd-node-edit-about = 저장된 노드를 편집합니다
cli-cmd-node-list-about = 저장된 노드를 나열합니다
cli-cmd-query-about = 원격 노드를 조회합니다(C-FIND)
cli-cmd-retrieve-about = 원격 노드에서 가져옵니다(C-MOVE)
cli-cmd-send-about = 로컬 검사 또는 시리즈를 전송합니다(C-STORE)
cli-cmd-send-series-about = 시리즈를 대상 노드로 전송합니다
cli-cmd-send-study-about = 검사를 대상 노드로 전송합니다
cli-cmd-serve-about = DICOM 서버를 실행합니다
cli-cmd-storage-scp-about = Storage SCP 리스너를 실행합니다
cli-cmd-tui-about = 대화형 터미널 UI를 엽니다
cli-flag-help = 도움말 출력
cli-flag-lang = UI 언어(BCP-47 태그). DICOM_NODE_LANG, 저장된 로케일, OS 로케일보다 우선합니다.
cli-flag-version = 버전 출력
cli-heading-arguments = 인수:
cli-heading-commands = 명령:
cli-heading-options = 옵션:
cli-heading-usage = 사용법:
cli-import-accepted = accepted={ $n }
cli-import-complete = 가져오기 완료
cli-import-duplicates = duplicates={ $n }
cli-import-scanned = scanned={ $n }
cli-msg-cancel-sigint = 취소가 요청되었습니다(SIGINT). 정상 종료를 기다리는 중...
cli-msg-failures = 실패:
cli-msg-import-failed = 가져오기 실패: { $error }
cli-msg-no-local-series = 검사 { $uid }에 인덱싱된 시리즈가 없습니다
cli-msg-no-local-studies = 인덱싱된 로컬 검사가 없습니다
cli-msg-no-saved-nodes = 저장된 노드가 없습니다
cli-msg-query-failed = 조회 실패: { $error }
cli-msg-removed-nodes =
    삭제됨 { $count ->
        [one] { $count }개 노드
       *[other] { $count }개 노드
    }
cli-msg-results-count =
    결과: { $count ->
        [one] { $count }건 일치
       *[other] { $count }건 일치
    }
cli-msg-retrieve-failed = 가져오기 실패: { $error }
cli-msg-saved-node = 노드 { $name } [{ $id }]을(를) 저장했습니다 => { $ae }@{ $host }:{ $port }
cli-msg-send-failed = 전송 실패: { $error }
cli-msg-showing-failures = (실패 { $total }건 중 처음 { $shown }건 표시)
cli-msg-starting-server =
    DICOM 서버 시작: { $count ->
        [one] { $count }개 로컬 AE
       *[other] { $count }개 로컬 AE
    } { $aes }
cli-msg-starting-server-no-aes = 구성된 로컬 AE 없이 DICOM 서버를 시작합니다
cli-msg-starting-storage-scp = { $addr }에서 Storage SCP를 시작합니다(AE Title { $ae })
cli-msg-updated-node = 노드 { $name } [{ $id }]을(를) 업데이트했습니다 => { $ae }@{ $host }:{ $port }
cli-send-attempted = attempted={ $n }
cli-send-failed-count = failed={ $n }
cli-send-sent = sent={ $n }
cli-value-name-file = FILE
cli-value-name-format = FORMAT
cli-value-name-locale = LOCALE
cli-value-name-path = PATH
tui-detail-more-series =
    ... { $n ->
        [one] { $n }개 추가 시리즈
       *[other] { $n }개 추가 시리즈
    }
tui-row-instance-count =
    { $n ->
        [one] { $n }건
       *[other] { $n }건
    }
tui-row-study-counts = { $series }s/{ $instances }i
count-nodes =
    { $n ->
        [one] { $n }개 노드
       *[other] { $n }개 노드
    }
count-instances =
    { $n ->
        [one] { $n }개 인스턴스
       *[other] { $n }개 인스턴스
    }
count-series =
    { $n ->
        [one] { $n }개 시리즈
       *[other] { $n }개 시리즈
    }
count-studies =
    { $n ->
        [one] { $n }건 검사
       *[other] { $n }건 검사
    }
format-datetime = { $date } { $time }
format-date = { $year }.{ $month }.{ $day }

## Common
common-accession = 접수번호
common-add = 추가
common-back = 뒤로
common-bytes = 바이트
common-cancel = 취소
common-clear = 지우기
common-close = 닫기
common-date = 날짜
common-delete = 노드 삭제
common-description = 설명
common-disabled = 사용 안 함
common-duplicates = 중복
common-edit = 편집
common-enabled = 사용
common-error = 오류
common-filter = 필터
common-host = 호스트
common-import = 가져오기
common-instance = 인스턴스
common-language = 언어
common-loading = 불러오는 중
common-matches = 일치
common-modality = 모달리티
common-name = 이름
common-network = 네트워크
common-no = 아니요
common-none = 없음
common-notes = 메모
common-optional = 선택
common-path = 원본
common-patient = 환자
common-patient-id = 환자 ID
common-patient-name = 환자 이름
common-port = 포트
common-query = 조회
common-refresh = 새로고침
common-required = 필수
common-retrieve = 검색
common-save = 저장
common-search = 검색
common-send = 전송
common-series = 시리즈
common-start = 시작
common-status = 상태
common-stop = 중지
common-studies = 검사
common-study = 스터디
common-unknown = 알 수 없음
common-unknown-series = <시리즈>
common-unknown-study = <검사>
common-yes = 예

## Errors
error-ae-empty = AE title은 비워 둘 수 없습니다
error-ae-invalid-char = AE title에 잘못된 문자 '{ $character }'가 있습니다. 허용: A-Z, 0-9, 공백
error-ae-required = AE Title은 필수입니다
error-ae-too-long = AE title은 최대 16자여야 합니다
error-ae-whitespace = AE title 앞뒤에 공백을 둘 수 없습니다
error-archive-patient-retrieve-out-of-scope = Patient 레벨 retrieve는 범위 밖입니다
error-archive-retrieve-uid-required = 이 retrieve 레벨에는 { $name }이(가) 필요합니다
error-archive-study-root-patient-query = Study Root 쿼리는 Patient 레벨을 지원하지 않습니다
error-archive-study-root-patient-retrieve = Study Root retrieve는 Patient 레벨을 지원하지 않습니다
error-assoc-negotiation-failed = { $name }({ $addr })와(과)의 association 협상에 실패했습니다. 힌트: called AE title, presentation contexts/transfer syntaxes, 피어가 association을 수락하는지 확인하세요
error-assoc-no-addresses = { $name }의 소켓 주소를 { $host }:{ $port }에서 확인할 수 없습니다
error-assoc-receive = association 수신
error-assoc-resolving = { $name }을(를) { $host }:{ $port }에서 확인하는 중: { $err }
error-assoc-timeout = DIMSE 응답 대기 시간이 초과되었습니다. 힌트: 네트워크, AE title/호스트/포트, 피어 응답을 확인하세요
error-assoc-transport = DIMSE 응답을 기다리는 동안 전송이 중단되었습니다. 힌트: 피어가 연결을 닫았거나 네트워크 장비가 재설정했을 수 있습니다
error-assoc-unreachable = { $seconds }s 안에 { $name } [{ $ae }] ({ $host }:{ $port })에 연결할 수 없습니다: { $err }. 호스트/IP, 포트, 네트워크 도달 가능성을 확인하세요
error-cancel-sigint = 취소가 요청되었습니다(SIGINT). 정상 종료를 기다리는 중...
error-config-must-be-positive = 잘못된 구성: { $name }은(는) 0보다 커야 합니다(끄려면 null)
error-config-duplicate-bind-port = 잘못된 구성: 로컬 AE bind 포트 { $port }이(가) 중복됨
error-config-local-ae-max-assoc = 잘못된 구성: 로컬 AE { $title }의 max_concurrent_associations는 0보다 커야 합니다
error-config-local-ae-no-services = 잘못된 구성: 로컬 AE { $title }은(는) 서비스를 하나 이상 활성화해야 합니다
error-config-must-be-positive-required = 잘못된 구성: { $name }은(는) 0보다 커야 합니다
error-dicom-meta-incomplete = DICOM 파일 메타가 불완전합니다
error-dicom-patient-move-unsupported = 이 클라이언트는 환자 수준 C-MOVE를 지원하지 않습니다
error-dicom-required-attribute = 필수 DICOM 속성이 없습니다: ({ $group },{ $element })
error-dicom-series-uid-required-image = 이미지 수준 retrieve에는 series_instance_uid가 필요합니다
error-dicom-series-uid-required-series = 시리즈 수준 retrieve에는 series_instance_uid가 필요합니다
error-dicom-sop-uid-required-image = 이미지 수준 retrieve에는 sop_instance_uid가 필요합니다
error-dicom-study-uid-required = study_instance_uid가 필요합니다
error-dicom-validating-move = move 요청을 검증하는 중
error-export-creating-file = 내보내기 파일을 만드는 중 { $path }: { $err }
error-export-flushing-series-csv = 시리즈 CSV를 플러시하는 중: { $err }
error-export-flushing-studies-csv = 스터디 CSV를 플러시하는 중: { $err }
error-export-serializing-series-json = 시리즈 JSON을 직렬화하는 중: { $err }
error-export-serializing-studies-json = 스터디 JSON을 직렬화하는 중: { $err }
error-export-writing-series-csv-header = 시리즈 CSV 헤더를 쓰는 중: { $err }
error-export-writing-series-csv-row = 시리즈 CSV 행을 쓰는 중: { $err }
error-export-writing-studies-csv-header = 스터디 CSV 헤더를 쓰는 중: { $err }
error-export-writing-studies-csv-row = 스터디 CSV 행을 쓰는 중: { $err }
error-import-cleanup-failed = { $source }: 정리 실패: { $reason }
error-import-corrupt-zip = 손상된 ZIP: { $details }
error-import-dicom-parse-failed = DICOM 구문 분석 실패: { $err }
error-import-dicom-validation-failed = DICOM 검증 실패: { $err }
error-import-duplicate-zip-path = ZIP에 '{ $path }'을(를) 가리키는 항목이 여러 개 있습니다
error-import-file-too-large = 파일이 너무 큽니다: { $details }
error-import-invalid-dicom = 잘못된 DICOM: { $details }
error-import-limit-exceeded = { $limit }을(를) 초과했습니다: { $details }
error-import-not-regular-file = 일반 파일이 아닙니다
error-import-opening-file = 파일을 여는 중: { $err }
error-import-opening-kind = { $kind } { $path }을(를) 여는 중
error-import-opening-staged-file = 스테이징된 파일을 여는 중: { $err }
error-import-opening-zip-archive = ZIP 아카이브를 여는 중 { $path }
error-import-opening-zip-entry = ZIP 항목을 여는 중: { $err }
error-import-opening-zip-file = ZIP 가져오기 파일을 여는 중 { $path }
error-import-path-does-not-exist = 가져오기 경로가 없습니다: { $path }
error-import-reading-directory = 가져오기 디렉터리를 읽는 중 { $path }
error-import-reading-file = 파일을 읽는 중: { $err }
error-import-reading-file-metadata = { $path }의 파일 메타데이터를 읽는 중
error-import-reading-metadata = { $kind } { $path }의 메타데이터를 읽는 중
error-import-reading-zip-entry = ZIP 항목을 읽는 중: { $err }
error-import-removing-staged-after-cancel = 취소 후 스테이징된 파일을 제거하는 중 { $path }
error-import-skipped = { $source }: 건너뜀: { $reason }
error-import-unreadable = 읽을 수 없는 파일: { $details }
error-import-unsafe-zip-path = 항목 경로가 아카이브를 벗어납니다
error-import-zip-entry-count-exceeded = ZIP 항목 수 한도 초과: 아카이브에 { $count }개, 한도는 { $limit }
error-import-zip-entry-size-exceeded = ZIP 항목 크기 { $size }이(가) 한도 { $limit }을(를) 초과합니다
error-import-zip-total-bytes-exceeded = ZIP 추출 바이트 합계 한도 초과: 현재 합계 { $current }에 항목 크기 { $entry }을(를) 더하면 한도 { $limit }을(를) 초과합니다
error-net-binding-storage-scp = { $addr }에서 AE { $ae }용 Storage SCP를 바인드하는 중. 다른 로컬 DICOM 수신기가 이미 해당 포트를 사용 중일 수 있습니다. { $config }의 storage_scp_port/local_aes를 업데이트하거나 충돌하는 리스너를 중지하십시오
error-net-building-file-meta = 파일 메타 테이블 구축 중
error-net-cannot-send-transfer-syntax = 원본 transfer syntax { $source }을(를) 협상된 { $negotiated }(으)로 보낼 수 없습니다
error-net-cget-dataset-empty = 인코딩된 C-GET C-STORE 데이터셋이 비어 있습니다
error-net-cget-dataset-odd-length = 인코딩된 C-GET C-STORE 데이터셋이 홀수 길이 조각으로 끝났습니다
error-net-cget-peer-released = C-GET 중 피어가 어소시에이션을 해제했습니다
error-net-cget-store-unexpected-dataset = 예기치 않음 dataset fragment in C-GET C-STORE response
error-net-cget-unexpected-command = 예기치 않음 command 0x{ $command } while waiting for C-STORE-RSP
error-net-cget-unexpected-pdu = 예기치 않음 PDU during C-GET C-STORE suboperation: { $pdu }
error-net-creating-incoming-dir = Storage SCP .incoming 디렉터리 생성 중
error-net-creating-path = { $path } 생성 중
error-net-dataset-empty = 인코딩된 데이터셋이 비어 있지만 COMMAND_DATA_SET_TYPE은 데이터셋이 필요하다고 표시합니다
error-net-dataset-odd-length = 인코딩된 데이터셋이 홀수 길이 조각으로 끝났습니다
error-net-dimse-failed = { $operation }이(가) 상태 0x{ $status } ({ $meaning })(으)로 실패{ $hint }
error-net-establishing-assoc = Storage SCP 어소시에이션 설정 중
error-net-file-meta-length = 읽기 File Meta Information length
error-net-file-meta-tag = 읽기 File Meta Information tag
error-net-file-meta-value = File Meta Information 값 건너뛰는 중
error-net-file-meta-vr = 읽기 File Meta Information VR
error-net-file-position = 읽기 file position
error-net-flushing-path = { $path } 플러시 중
error-net-flushing-temp-dataset = 임시 데이터셋 파일 플러시 중
error-net-hint-suffix = ; 힌트: { $hint }
error-net-incomplete-command = 불완전 { $operation } command response
error-net-incomplete-identifier = 불완전 { $operation } response identifier
error-net-invalid-affected-sop = 유효하지 않음 { $operation } affected SOP class UID
error-net-invalid-status = 유효하지 않음 { $operation } status
error-net-listener-address = 읽기 storage SCP listener address
error-net-listener-nonblocking = 리스너를 논블로킹 모드로 설정 중
error-net-listener-port = 읽기 storage SCP listener port
error-net-local-aes-empty = Storage SCP를 시작하려면 local_aes에 AE가 하나 이상 있어야 합니다
error-net-locating-dataset = { $path }에서 데이터셋 찾는 중
error-net-malformed-dimse = malformed { $operation } DIMSE response: { $details }; 힌트: peer sent an 유효하지 않음 or 예기치 않음 DIMSE command set
error-net-missing-affected-sop = 없음 { $operation } affected SOP class UID
error-net-missing-command-field = 없음 command field
error-net-missing-cstore-rsp-command-field = 없음 C-STORE response command field
error-net-missing-cstore-rsp-status = 없음 C-STORE response status
error-net-missing-destination = 없음 C-MOVE destination
error-net-missing-dicm = 없음 Part 10 DICM marker
error-net-missing-message-id = 없음 { $operation } message id
error-net-missing-qr-level = { $operation } identifier is 없음 QueryRetrieveLevel
error-net-missing-required-command-field = 없음 required command field { $name } ({ $tag })
error-net-missing-status = 없음 { $operation } status
error-net-move-destination-unresolved = move_destination이 확인되지 않았습니다
error-net-no-cget-store-context = SOP Class { $sop } 및 transfer syntax { $syntax }에 대한 협상된 C-GET 스토리지 프레젠테이션 컨텍스트가 없습니다
error-net-no-compatible-context = { $path }: 원본 transfer syntax { $syntax }에 호환되는 협상된 프레젠테이션 컨텍스트가 없습니다
error-net-no-dimse-provider = 명령 0x{ $command } 및 abstract syntax { $syntax }에 등록된 DIMSE 공급자가 없습니다
error-net-no-presentation-context = 협상된 프레젠테이션 컨텍스트가 없습니다
error-net-no-presentation-context-for-file = { $path }: 협상된 프레젠테이션 컨텍스트가 없습니다
error-net-no-presentation-context-id = 없음 negotiated presentation context { $id }
error-net-opening-path = 열기 { $path }
error-net-part10-preamble = 읽기 Part 10 preamble
error-net-path-error = { $path }: { $err }
error-net-pdata-feed-complete = cannot feed P-DATA fragment into a complete accumulator (없음 take())
error-net-peer-aborted = C-GET C-STORE 하위 작업 중 피어가 어소시에이션을 중단함: { $source }
error-net-peer-socket = 읽기 storage SCP peer socket address
error-net-reading-command-dataset = 읽기 command dataset
error-net-reading-identifier = 읽기 { $operation } identifier
error-net-reading-incoming-dataset = 읽기 incoming C-STORE dataset
error-net-reading-response-dataset = 읽기 { $operation } response dataset
error-net-remote-aborted = 원격이 어소시에이션을 중단했습니다: { $source }
error-net-restoring-read-timeout = association 읽기 제한 시간을 복원하는 중
error-net-restoring-write-timeout = association 쓰기 제한 시간을 복원하는 중
error-net-rewinding-dataset = 데이터셋 첫 요소로 되감는 중
error-net-scp-thread-panicked = Storage SCP 스레드가 패닉했습니다
error-net-seeking-temp-dataset = 임시 데이터셋 파일 탐색 중
error-net-serializing-cget-dataset = { $path }의 C-GET 하위 작업 데이터셋 직렬화 중
error-net-serializing-dataset = { $path } 데이터셋을 transfer syntax { $syntax }(으)로 직렬화 중
error-net-setting-socket-blocking = 수락된 스토리지 소켓을 블로킹 모드로 설정 중
error-net-sending-buffered-dataset = { $path }의 버퍼된 데이터셋 전송 중
error-net-store-status = 원격이 C-STORE 상태 0x{ $status } ({ $meaning })을(를) 반환했습니다{ $hint }
error-net-streaming-dataset = C-STORE 데이터셋 스트리밍 중
error-net-unexpected-command-field = 예기치 않음 CommandField 0x{ $actual } (expected 0x{ $expected } for { $rsp })
error-net-unexpected-dataset-fragment = 예기치 않음 dataset fragment in C-STORE response
error-net-unexpected-pdu = 예기치 않음 PDU during { $operation }: { $pdu }
error-net-unknown-status = 유효하지 않음 { $operation } status 0x{ $status }
error-net-unsupported-model-sop = 지원되지 않음 { $operation } model SOP class UID: { $uid }
error-net-unsupported-qr-level = 지원되지 않음 QueryRetrieveLevel: { $level }
error-net-unsupported-transfer-syntax = 지원되지 않음 negotiated transfer syntax
error-net-writing-command-dataset = 쓰기 command dataset
error-net-writing-identifier = 쓰기 { $operation } identifier
error-net-writing-path = 쓰기 { $path }
error-net-writing-response-dataset = 쓰기 { $operation } response dataset
error-net-writing-temp-dataset = 쓰기 dataset bytes to temp file
error-node-host-empty = 노드 호스트는 비워 둘 수 없습니다
error-node-name-empty = 노드 이름은 비워 둘 수 없습니다
error-node-not-found = 원격 노드를 찾을 수 없음: { $id }
error-operation-cancelled = 작업이 취소되었습니다
error-port-invalid = 잘못된 포트: { $value }
error-port-range = 포트는 1에서 65535 사이여야 합니다
error-query-no-study-uid = 일치에 StudyInstanceUID가 없어 가져올 수 없습니다.
error-query-unsupported-level = 지원하지 않는 쿼리 레벨: { $value }
error-query-unsupported-model = 지원하지 않는 쿼리 모델: { $value }
error-retrieve-canceled = 원격 노드가 retrieve를 취소했습니다 (status=0x{ $status }, completed={ $completed }, failed={ $failed }, warning={ $warning }, remaining={ $remaining }, { $scp })
error-retrieve-failed = retrieve가 status=0x{ $status }로 실패했습니다 (completed={ $completed }, failed={ $failed }, warning={ $warning }, remaining={ $remaining }, { $scp })
error-retrieve-nothing-arrived = 대상 { $destination }에 대한 retrieve가 completed={ $completed }로 끝났지만 로컬 Storage SCP({ $scp })에 아무것도 도착하지 않았습니다. AE 매핑 또는 포트를 확인하세요: { $listener }가 비어 있고 원격 노드가 AE { $destination }을(를) 이 앱에 매핑하는지 확인하세요
error-send-no-files-series = 시리즈 { $uid }에 대해 인덱싱된 로컬 파일이 없습니다
error-send-no-files-study = 스터디 { $uid }에 대해 인덱싱된 로컬 파일이 없습니다
error-task-cancelled = 작업이 취소되었습니다
error-task-none-to-cancel = 취소할 활성 작업이 없습니다(실행 중인 작업 없음)
error-tracing-init = tracing subscriber를 초기화하는 중: { $err }
error-uid-component-numeric = UID 구성 요소 '{ $part }'은(는) 숫자여야 합니다
error-uid-component-too-long = UID 구성 요소 '{ $part }'이(가) 너무 깁니다
error-uid-dot-ends = UID는 점으로 시작하거나 끝날 수 없습니다
error-uid-empty = UID는 비울 수 없습니다
error-uid-empty-component = UID에 빈 구성 요소를 넣을 수 없습니다
error-uid-leading-zeros = UID 구성 요소 '{ $part }'에 선행 0을 쓸 수 없습니다
error-uid-too-long = UID는 최대 64자여야 합니다

## TUI
tui-bool-no = 아니요
tui-bool-off = 꺼짐
tui-bool-on = 켜짐
tui-bool-yes = 예
tui-command-placeholder = 명령을 입력하거나 창 단축키를 사용하세요.
tui-config-ae-title = AE title: { $value }
tui-config-edit-hint = Tab을 눌러 이 창에 포커스한 다음 'c'를 눌러 편집하세요.
tui-config-hint = Tab을 눌러 이 창에 포커스한 다음 'c'를 눌러 편집하세요.
tui-config-listener = 리스너: { $value }
tui-config-max-pdu = max_pdu_length: { $value }
tui-config-promiscuous = allow_promiscuous_storage: { $value }
tui-config-strict-pdu = strict_pdu: { $value }
tui-config-ts-pref = TS 기본값: { $value }
tui-controls-hint = Tab 필드 · Enter 확인 · Esc 취소
tui-detail-ae-title = AE Title
tui-detail-instance = 인스턴스 상세
tui-detail-name = 이름
tui-detail-node = 노드 상세
tui-detail-placeholder-followup = 목록 창으로 포커스를 옮기고 선택을 바꿔 이 화면을 업데이트하세요.
tui-detail-query = 조회 결과 상세
tui-detail-select-node = 원격 노드를 선택하여 메타데이터를 확인하세요.
tui-detail-series = 시리즈 상세
tui-detail-study = 검사 상세
tui-empty-command-placeholder = 명령을 입력하거나 창 단축키를 사용하세요.
tui-empty-detail-instance = 인스턴스를 선택해 확인하거나 Esc로 시리즈로 돌아가세요.
tui-empty-detail-node = 원격 노드를 선택하여 메타데이터를 확인하세요.
tui-empty-detail-query = 조회 결과를 선택하여 메타데이터와 retrieve 맥락을 확인하세요.
tui-empty-detail-series = 시리즈를 선택해 확인하거나 Esc로 스터디로 돌아가세요.
tui-empty-detail-study = 로컬 스터디를 선택하여 환자와 시리즈 메타데이터를 확인하세요.
tui-empty-instances = 이 시리즈에 인덱싱된 인스턴스가 없습니다.
tui-empty-instances-hint = Esc로 시리즈 목록으로 돌아갑니다.
tui-empty-local-instances = 이 시리즈에 인덱싱된 인스턴스가 없습니다.
tui-empty-local-instances-hint = Esc로 시리즈 목록으로 돌아갑니다.
tui-empty-local-series = 이 검사에 인덱싱된 시리즈가 없습니다.
tui-empty-local-series-hint = Esc로 로컬 검사 목록으로 돌아갑니다.
tui-empty-local-studies = 인덱싱된 검사가 아직 없습니다.
tui-empty-local-studies-cmd = 예: import path=/data/inbox
tui-empty-local-studies-hint = 먼저 로컬 DICOM 파일을 가져오세요.
tui-empty-no-name = <이름 없음>
tui-empty-query = 조회가 아직 실행되지 않았습니다.
tui-empty-query-body =
    원격 노드를 선택한 다음 'f'를 눌러 조회합니다.
    또는: query node=pacs
        patient_name="DOE^JOHN"
    선택한 결과에서 'm'을 누르면 retrieve가 열립니다.
tui-empty-query-cmd = 또는: query node=pacs
tui-empty-query-hint = 원격 노드를 선택한 다음 'f'를 눌러 조회합니다.
tui-empty-query-last-target = 마지막 조회 대상: { $name }
tui-empty-query-none = 조회가 아직 실행되지 않았습니다.
tui-empty-query-retrieve-hint = 선택한 결과에서 'm'을 누르면 retrieve가 열립니다.
tui-empty-remote-nodes =
    저장된 원격 노드가 아직 없습니다.
    
    이 창에서 a를 눌러 추가합니다.
    또는: node add name=pacs
        ae=PACSAE host=10.0.0.10
        port=104
tui-empty-remote-nodes-cmd = 또는: node add name=pacs
tui-empty-remote-nodes-hint = 이 창에서 a를 눌러 추가합니다.
tui-empty-series = 이 검사에 인덱싱된 시리즈가 없습니다.
tui-empty-series-hint = Esc로 로컬 검사 목록으로 돌아갑니다.
tui-empty-studies = 인덱싱된 검사가 아직 없습니다.
tui-empty-studies-hint = 먼저 로컬 DICOM 파일을 가져오세요.
tui-empty-tasks-history = 작업 기록이 없습니다.
tui-empty-tasks-queued = 대기 중인 작업이 없습니다.
tui-fallback-no-name = <이름 없음>
tui-field-accession = 접수번호
tui-field-ae-title = AE title
tui-field-bind-addr = 바인드 주소
tui-field-date-from = 시작일
tui-field-date-to = 종료일
tui-field-destination-node = 대상 노드
tui-field-host = 호스트
tui-field-instance-uid = Instance UID
tui-field-kind = 종류
tui-field-level = 레벨
tui-field-local-ae = 로컬 AE
tui-field-max-pdu = 최대 PDU
tui-field-modality = 모달리티
tui-field-model = 모델
tui-field-move-destination = Move 대상
tui-field-name = 이름
tui-field-notes = 메모
tui-field-path = 경로
tui-field-patient-id = 환자 ID
tui-field-patient-name = 환자 이름
tui-field-port = 포트
tui-field-promiscuous = 무차별 수신
tui-field-series-uid = Series UID
tui-field-sop-uid = SOP Instance UID
tui-field-strict-pdu = 엄격 PDU
tui-field-study-description = 검사 설명
tui-field-study-uid = Study UID
tui-footer-back-series = Esc 시리즈로
tui-footer-back-studies = Esc 검사로
tui-footer-cancel-task = c 취소
tui-footer-edit-config = c 설정 편집
tui-footer-enter-series = Enter 시리즈
tui-footer-esc-series = Esc 시리즈로
tui-footer-esc-studies = Esc 검사로
tui-footer-help = F1/? 도움말
tui-footer-inspect = Enter 확인
tui-footer-next = 다음: { $text }
tui-footer-nodes = a/e/d/f 노드
tui-footer-panes = Tab 창
tui-footer-queued =
    { $n ->
        [one] { $n }개 대기
       *[other] { $n }개 대기
    }
tui-footer-quit = q 종료
tui-footer-refresh = r 새로고침
tui-footer-retrieve = m 가져오기
tui-footer-run-command = Enter 명령 실행
tui-footer-task-scope = t 대기/기록
tui-form-add-node = 원격 노드 추가
tui-form-add-remote-node = 원격 노드 추가
tui-form-delete-confirm = 원격 노드 { $name } [{ $ae }] ({ $host }:{ $port })을(를) 삭제할까요?
tui-form-delete-node = 원격 노드 삭제
tui-form-delete-remote-node = 원격 노드 삭제
tui-form-edit-node = 원격 노드 편집
tui-form-edit-remote-node = 원격 노드 편집
tui-form-err-ae-required = ! AE title은 필수입니다
tui-form-err-bind-required = ! 바인드 주소는 필수입니다
tui-form-err-host-required = ! 호스트는 필수입니다
tui-form-err-local-ae-invalid = ! 잘못된 로컬 AE title: { $err }
tui-form-err-local-ae-required = ! 로컬 AE title은 필수입니다
tui-form-err-modality-empty = modality 비울 수 없습니다
tui-form-err-move-dest-invalid = ! 잘못된 이동 대상 AE title: { $err }
tui-form-err-name-required = ! 노드 name is required
tui-form-err-port-required = ! 포트는 필수입니다
tui-form-err-uid-empty = UID는 비울 수 없습니다
tui-form-err-uid-empty-component = UID에 빈 구성 요소를 넣을 수 없습니다
tui-form-error-line = 오류: { $error }
tui-form-field-accession = 접수번호
tui-form-field-ae-title = AE title
tui-form-field-bind-addr = 바인드 주소
tui-form-field-date-from = 시작일
tui-form-field-date-to = 종료일
tui-form-field-dest-node = 대상 노드
tui-form-field-destination = 대상 AE
tui-form-field-host = 호스트
tui-form-field-instance-uid = SOP Instance UID
tui-form-field-kind = 종류
tui-form-field-level = 레벨
tui-form-field-local-ae = 로컬 AE
tui-form-field-modality = 모달리티
tui-form-field-model = 모델
tui-form-field-move-dest = Move 대상
tui-form-field-name = 이름
tui-form-field-notes = 메모
tui-form-field-path = 경로
tui-form-field-patient-id = 환자 ID
tui-form-field-patient-name = 환자 이름
tui-form-field-port = 포트
tui-form-field-series-uid = Series Instance UID
tui-form-field-sop-uid = SOP Instance UID
tui-form-field-study-desc = 검사 설명
tui-form-field-study-uid = Study Instance UID
tui-form-field-uid = UID
tui-form-hint-bind = 힌트: 보통 0.0.0.0(모든 인터페이스) 또는 127.0.0.1
tui-form-hint-local-ae = 힌트: 최대 16자(A-Z, 0-9, 공백), 예: ARCHIVE_AE
tui-form-hint-move-dest = 힌트: 선택 사항. C-MOVE 대상 AE title을 재정의
tui-form-hint-name = 힌트: 짧은 레이블(예: PACS)
tui-form-import = 로컬 파일 가져오기
tui-form-import-local = 로컬 파일 가져오기
tui-form-import-local-files = 로컬 파일 가져오기
tui-form-mode-add = create a new 원격 노드
tui-form-mode-edit = update the selected 원격 노드
tui-form-query-node = 원격 노드 조회
tui-form-query-remote-node = 원격 노드 조회
tui-form-remote-node-line = 원격 노드: { $name } [{ $ae }] { $host }:{ $port }
tui-form-retrieve = 일치 항목 가져오기
tui-form-retrieve-matches = 일치 항목 가져오기
tui-form-send-series = 시리즈 전송
tui-form-send-study = 검사 전송
tui-form-storage-intro = 로컬 Storage SCP 설정을 편집합니다(config.json에 저장).
tui-form-storage-scp = Storage SCP 설정
tui-form-storage-scp-settings = Storage SCP 설정
tui-help-ae-title = AE title: { $value }
tui-help-aedf = a/e/d/f     Add, edit, delete, or query from the selected 노드
tui-help-c = c           Storage SCP 설정 편집(설정 창에 포커스가 있을 때)
tui-help-canonical-names = 정규 이름은 '--' 없는 CLI 플래그와 일치하며 밑줄을 사용합니다.
tui-help-close = Esc, F1 또는 ?로 도움말을 닫습니다.
tui-help-common-commands = 자주 쓰는 명령
tui-help-config = c           Storage SCP 설정 편집(설정 창에 포커스가 있을 때)
tui-help-config-path = 구성 경로: { $value }
tui-help-current-config = 현재 구성
tui-help-data-dir = 데이터 디렉터리: { $value }
tui-help-enter-default = Enter       Run the command input, submit the active modal, or open series from 로컬 검사
tui-help-enter-instance = Enter       인스턴스 보기에서 로컬 창 동작 없음
tui-help-enter-local-instance = Enter       인스턴스 보기에서 로컬 창 동작 없음
tui-help-enter-local-series = Enter       선택한 로컬 시리즈의 인스턴스 열기, 또는 명령 입력 실행 / 활성 모달 제출
tui-help-enter-local-study = Enter       선택한 로컬 검사의 시리즈 열기, 또는 명령 입력 실행 / 활성 모달 제출
tui-help-enter-series = Enter       선택한 로컬 시리즈의 인스턴스 열기, 또는 명령 입력 실행 / 활성 모달 제출
tui-help-enter-study = Enter       선택한 로컬 검사의 시리즈 열기, 또는 명령 입력 실행 / 활성 모달 제출
tui-help-esc-default = Esc         도움말/모달 닫기, 로컬 시리즈에서 돌아가기, 또는 명령 입력으로 포커스
tui-help-esc-instance = Esc         로컬 인스턴스에서 시리즈로 돌아가기, 도움말/모달 닫기, 또는 명령 입력으로 포커스
tui-help-esc-instances = Esc         로컬 인스턴스에서 시리즈로 돌아가기, 도움말/모달 닫기, 또는 명령 입력으로 포커스
tui-help-esc-series = Esc         로컬 시리즈에서 검사로 돌아가기, 도움말/모달 닫기, 또는 명령 입력으로 포커스
tui-help-f1 = F1 또는 ?     도움말 열기
tui-help-import-send = i/s         가져오기 local files or send selected study/series
tui-help-is = i/s         가져오기 local files or send selected study/series
tui-help-listener = 리스너: { $value }
tui-help-log-dir = 로그 디렉터리: { $value }
tui-help-m = m           선택한 조회 결과에서 가져오기
tui-help-max-pdu = max_pdu_length: { $value }
tui-help-move = 위/아래 또는 j/k   목록 창에서 선택 이동
tui-help-nodes = a/e/d/f     Add, edit, delete, or query from the selected 노드
tui-help-open = F1 또는 ?     도움말 열기
tui-help-promiscuous = allow_promiscuous_storage: { $value }
tui-help-q = q           모달이 없고 포커스가 명령 입력이 아닐 때 종료
tui-help-quit = q           모달이 없고 포커스가 명령 입력이 아닐 때 종료
tui-help-r = r           새로 고침 panes when focus is 아니요t in command input
tui-help-receiver-mode = 수신 모드: { $value }
tui-receiver-mode-on-demand = 로컬 retrieve용 요청 시
tui-receiver-mode-standalone = storage-scp를 통한 독립형
tui-help-refresh = r           새로 고침 panes when focus is 아니요t in command input
tui-help-retrieve = m           선택한 조회 결과에서 가져오기
tui-help-strict-pdu = strict_pdu: { $value }
tui-help-tab = Tab / Shift-Tab  포커스 창 변경
tui-help-title = 키 바인딩
tui-help-ts-pref = preferred_store_transfer_syntax: { $value }
tui-help-updown = 위/아래 또는 j/k   목록 창에서 선택 이동
tui-input-placeholder = 명령을 입력하거나 창 단축키를 사용하세요.
tui-log-command = > { $command }
tui-log-error = 오류: { $error }
tui-log-refreshed = 새로고침됨
tui-logs-capped-suffix = 상한
tui-logs-label = 로그:
tui-pane-command = 명령
tui-pane-config = 설정
tui-pane-detail = 상세
tui-pane-detail-hint = { $title } (PgUp/PgDn 입력 중이 아닐 때)
tui-pane-help = 도움말
tui-pane-instance-detail = 인스턴스 상세
tui-pane-instances-for = 인스턴스: { $uid }
tui-pane-local-studies = 로컬 검사
tui-pane-logs = 로그({ $shown }/{ $total }{ $capped })
tui-pane-logs-capped = 로그 ({ $shown }/{ $total } capped)
tui-pane-logs-uncapped = 로그 ({ $shown }/{ $total })
tui-pane-node-detail = 노드 상세
tui-pane-query-detail = 조회 결과 상세
tui-pane-query-node = 노드 조회
tui-pane-query-result-detail = 조회 결과 상세
tui-pane-query-results = 조회 / 가져오기 결과
tui-pane-query-retrieve-results = 조회 / 가져오기 결과
tui-pane-remote-nodes = 원격 노드
tui-pane-series-detail = 시리즈 상세
tui-pane-series-for = 시리즈: { $uid }
tui-pane-series-unknown = 시리즈: <알 수 없는 검사>
tui-pane-study-detail = 검사 상세
tui-pane-task-details = 작업 상세
tui-pane-tasks-history = 작업(기록)
tui-pane-tasks-queued = 작업(대기)
tui-pane-unknown-series = <알 수 없는 시리즈>
tui-pane-unknown-study = 시리즈: <알 수 없는 검사>
tui-row-inst = inst
tui-status-cancel-requested = 취소lation requested
tui-status-config = 설정
tui-status-configured-listener = 리스너 { $addr }을(를) AE { $ae }({ $mode })(으)로 구성
tui-status-data = 데이터
tui-status-failure = 실패: { $failure }
tui-status-listener = 리스너
tui-status-local-ae = 로컬 AE
tui-status-mode = 모드
tui-status-mode-on-demand = 요청 시
tui-status-mode-standalone = 독립형
tui-status-no-active-task = 활성 작업 없음 to cancel (nothing running)
tui-status-pdu = PDU
tui-status-promiscuous = 무차별 수신
tui-status-query-before-retrieve = Query a 원격 노드 first so retrieve knows which 노드 to use
tui-status-query-failed = 조회 실패: { $error }
tui-status-queued-op = 대기 중인 작업: { $op }
tui-status-retrieve-failed = 가져오기 실패: { $error }
tui-status-retrieve-open-failed = 열 수 없음 retrieve stream: { $error }
tui-status-saved-node = saved 노드 { $name } ({ $id })
tui-status-saved-scp = Storage SCP 설정이 저장되었습니다(재시작 필요)
tui-status-select-node = 먼저 원격 노드를 선택하세요
tui-status-select-query = 먼저 조회 결과를 선택하세요
tui-status-select-study = 먼저 로컬 검사를 선택하세요
tui-status-strict = 엄격
tui-status-task-cancelled = 작업이 취소되었습니다
tui-status-task-cancelled-detail = 작업 취소됨: { $other }
tui-status-ts-pref = TS 기본값
tui-status-updated-node = updated 노드 { $name } ({ $id })
tui-suggest-back-series = Esc — 시리즈로 돌아가기
tui-suggest-edit-config = c — 설정 편집
tui-suggest-help = F1/? — 도움말
tui-suggest-inspect-task = Enter — 작업 검사
tui-suggest-node-add = node add <ae-title> <host:port>
tui-suggest-query = f — query a 노드
tui-suggest-query-node = f — query selected 노드
tui-suggest-retrieve = m — 선택 항목 가져오기
tui-suggest-run-command = Enter — 명령 실행
tui-suggest-send-series = s — 선택 시리즈 전송
tui-suggest-view-series = Enter — 시리즈 보기
tui-task-cancelled = 취소됨
tui-task-cancelling = 취소 중
tui-task-failed = 실패
tui-task-failed-generic = 작업 실패: { $error }
tui-task-import-done = 가져오기 complete: { $report }
tui-task-import-failed = 가져오기 실패: { $error }
tui-task-importing = { $path } 가져오는 중...
tui-task-query-done =
    조회 완료: { $count ->
        [one] { $count }건 일치
       *[other] { $count }건 일치
    }
tui-task-query-failed = 조회 실패: { $error }
tui-task-querying = { $node } 조회 중...
tui-task-queued = 대기 중
tui-task-retrieve-done = 가져오기 완료: { $outcome }
tui-task-retrieve-failed = 가져오기 실패: { $error }
tui-task-retrieving = { $node }에서 가져오는 중...
tui-task-running = 실행 중
tui-task-sending-series = 시리즈 { $uid }을(를) { $node }(으)로 전송 중...
tui-task-sending-study = 검사 { $uid }을(를) { $node }(으)로 전송 중...
tui-task-send-done = 전송 완료: { $outcome }
tui-task-status-cancelled = 취소됨
tui-task-status-cancelling = 취소 중
tui-task-status-failed = 실패
tui-task-status-ok = ok
tui-task-status-queued = 대기 중
tui-task-status-running = 실행 중
tui-task-succeeded = 성공
tui-terminal-too-small = 터미널이 너무 작습니다 — 창 크기를 늘리세요

## Desktop
desktop-action-activity = 활동 { $count }
desktop-action-activity-empty = 활동
desktop-action-import = 가져오기
desktop-action-inspect-archive = 로컬 아카이브 검사
desktop-action-inspect-archive-desc = 스터디·시리즈·인스턴스를 검토한 뒤 전송하거나 내보내세요.
desktop-action-manage-peers = 피어 관리
desktop-action-manage-peers-desc = query, retrieve, store에 쓰는 PACS/워크스테이션 노드를 추가·편집합니다.
desktop-action-monitor-scp = Storage SCP 모니터링
desktop-action-query = 조회
desktop-action-refresh = 상태 새로고침
desktop-action-refresh-status = 상태 새로고침
desktop-action-reveal-log = 로그 파일 표시
desktop-action-send = 전송
desktop-action-start-scp = Storage SCP 시작
desktop-activity-empty = 아직 세션 활동이 없습니다.
desktop-activity-title = 활동
desktop-app-title = DICOM Node
desktop-archive-csv = CSV
desktop-archive-details = 세부 정보
desktop-archive-empty = 로컬 아카이브가 비어 있습니다.
desktop-archive-export-fail = { $scope } 내보내기 실패
desktop-archive-export-ok =
    { $rows ->
        [one] { $scope } { $rows }행을 { $path }(으)로 내보냈습니다.
       *[other] { $scope } { $rows }행을 { $path }(으)로 내보냈습니다.
    }
desktop-archive-export-studies = 검사 내보내기
desktop-archive-export-title = { $scope } 내보내기
desktop-archive-filter = 환자, UID, 설명, 모달리티로 필터…
desktop-archive-filter-placeholder = 환자, UID, 설명, 모달리티로 필터…
desktop-archive-inst-abbrev =
    { $count ->
        [one] { $count }건
       *[other] { $count }건
    }
desktop-archive-instance-meta = { $bytes } · TS { $ts } · 가져옴 { $imported }
desktop-archive-instances = 인스턴스
desktop-archive-instances-heading = 인스턴스
desktop-archive-json = JSON
desktop-archive-loading = 검사 불러오는 중…
desktop-archive-no-filter-match = 필터와 일치하는 검사가 없습니다.
desktop-archive-no-instances = 인스턴스가 없습니다.
desktop-archive-no-match = 필터와 일치하는 검사가 없습니다.
desktop-archive-no-nodes = 노드 없음
desktop-archive-no-series = 시리즈가 없습니다.
desktop-archive-reveal-file = 파일 표시
desktop-archive-select-series = 시리즈를 선택하세요.
desktop-archive-select-study = 검사를 선택하세요.
desktop-archive-send-fail = { $label }: { $sent }/{ $attempted } 전송, { $failed } 실패. { $failures }
desktop-archive-send-fail-title = { $label } 실패
desktop-archive-send-ok = { $label }: { $sent }/{ $attempted }개 인스턴스 전송.
desktop-archive-send-series = 시리즈 전송
desktop-archive-send-series-label = 시리즈 → { $destination }
desktop-archive-send-study = 검사 전송
desktop-archive-send-study-label = 검사 → { $destination }
desktop-archive-send-to = 보내기
desktop-archive-series = 시리즈
desktop-archive-series-count =
    #{ $number } · { $count ->
        [one] { $count }개 인스턴스
       *[other] { $count }개 인스턴스
    }
desktop-archive-series-fallback = 시리즈
desktop-archive-studies = 검사
desktop-archive-study-date = 검사 날짜
desktop-archive-study-uid = Study UID
desktop-archive-subtitle = 로컬 SQLite 아카이브의 검사, 시리즈, 인스턴스 목록.
desktop-archive-title = 로컬 아카이브
desktop-brand-title = DICOM Node
desktop-col-description = 설명
desktop-col-instances = 인스턴스
desktop-col-modalities = 모달리티
desktop-col-patient-id = 환자 ID
desktop-common-cancel = 취소
desktop-common-clear = 지우기
desktop-common-disabled = 사용 안 함
desktop-common-enabled = 사용
desktop-common-loading = 불러오는 중…
desktop-common-no = 아니요
desktop-common-refresh = 새로고침
desktop-common-yes = 예
desktop-counter-assoc-accepted = 수락된 어소시에이션
desktop-counter-bytes-ingested = 수집된 바이트
desktop-counter-cfind-requests = C-FIND 요청
desktop-counter-cmove-requests = C-MOVE 요청
desktop-counter-cstore-failed = C-STORE 실패
desktop-counter-cstore-stored = C-STORE 저장됨
desktop-dashboard-counter-assoc-accepted = 수락된 어소시에이션
desktop-dashboard-counter-bytes-ingested = 수집된 바이트
desktop-dashboard-counter-c-find-requests = C-FIND 요청
desktop-dashboard-counter-c-move-requests = C-MOVE 요청
desktop-dashboard-counter-c-store-failed = C-STORE 실패
desktop-dashboard-counter-c-store-stored = C-STORE 저장됨
desktop-dashboard-empty-studies = 아직 로컬 검사가 없습니다.
desktop-dashboard-inspect-archive-body = 검사, 시리즈, 인스턴스를 검토한 뒤 전송하거나 내보냅니다.
desktop-dashboard-inspect-archive-title = 로컬 아카이브 확인
desktop-dashboard-kv-ae-title = AE Title
desktop-dashboard-kv-data-dir = 데이터 디렉터리
desktop-dashboard-kv-listener = 리스너
desktop-dashboard-kv-log-file = 로그 파일
desktop-dashboard-kv-max-pdu = 최대 PDU
desktop-dashboard-kv-promiscuous = 무제한 저장
desktop-dashboard-kv-server = 서버
desktop-dashboard-kv-store-syntax = Store 구문
desktop-dashboard-kv-strict-pdu = 엄격 PDU
desktop-dashboard-listener-missing = 리스너가 아직 로드되지 않았습니다.
desktop-dashboard-live-counters = 실시간 카운터
desktop-dashboard-loading-metrics = 메트릭 불러오는 중…
desktop-dashboard-loading-status = 로컬 상태 불러오는 중…
desktop-dashboard-loading-studies = 검사 불러오는 중…
desktop-dashboard-local-node = 로컬 노드
desktop-dashboard-manage-peers-body = 조회, 가져오기, 스토어에 쓰는 PACS/워크스테이션 노드를 추가하고 편집합니다.
desktop-dashboard-manage-peers-title = 피어 관리
desktop-dashboard-metric-instances = 인스턴스
desktop-dashboard-metric-nodes = 원격 노드
desktop-dashboard-metric-series = 시리즈
desktop-dashboard-metric-studies = 검사
desktop-dashboard-monitor-scp = Storage SCP 모니터링
desktop-dashboard-recent-studies = 최근 검사
desktop-dashboard-start-scp = Storage SCP 시작
desktop-dashboard-subtitle = 로컬 아카이브, 네트워크 피어, SCP 활동을 한눈에 봅니다.
desktop-dashboard-title = 운영자 대시보드
desktop-doc-title = DICOM Node
desktop-import-accepted = 수락됨
desktop-import-accepted-bytes = 수락된 바이트
desktop-import-activity-detail = { $accepted }/{ $scanned } 수락, 중복 { $duplicates }, { $bytes }
desktop-import-activity-fail = 가져오기 실패
desktop-import-activity-ok = 가져오기 완료
desktop-import-choose-archive = 가져올 ZIP 아카이브를 선택하세요
desktop-import-choose-dir = 가져올 디렉터리를 선택하세요
desktop-import-choose-folder = 폴더
desktop-import-choose-zip = 가져올 ZIP 아카이브를 선택하세요
desktop-import-cleanup = 정리
desktop-import-clear-path = 경로 지우기
desktop-import-complete = 가져오기 완료
desktop-import-dup-sha = SHA-256
desktop-import-dup-sop = SOP UID
desktop-import-dup-total = 합계
desktop-import-duplicates = 중복
desktop-import-failed = 가져오기 실패
desktop-import-failed-cleanup = 정리 실패
desktop-import-failures = 실패
desktop-import-failures-heading =
    { $count ->
        [one] 실패 { $count }건:
       *[other] 실패 { $count }건:
    }
desktop-import-failures-more = … 외 { $count }건
desktop-import-files-progress = { $label }개 파일
desktop-import-folder = 폴더
desktop-import-invalid-dicom = 잘못된 DICOM
desktop-import-pick-dir = 가져올 디렉터리를 선택하세요
desktop-import-pick-zip = 가져올 ZIP 아카이브를 선택하세요
desktop-import-placeholder = /path/to/dicom-folder or /path/to/archive.zip
desktop-import-rejected = 거부됨
desktop-import-report = 가져오기 보고서
desktop-import-running = 가져오는 중…
desktop-import-scanned = 스캔됨
desktop-import-skipped = 건너뜀
desktop-import-source = 원본
desktop-import-start = 가져오기 시작
desktop-import-stored = 저장됨
desktop-import-subtitle = 재귀 폴더 또는 ZIP 아카이브의 DICOM 파일을 관리되는 로컬 아카이브에 색인합니다.
desktop-import-title = 가져오기
desktop-import-unreadable = 읽을 수 없음
desktop-import-zip = ZIP
desktop-import-zip-filter = ZIP 아카이브
desktop-lang-label = 언어
desktop-listener-not-loaded = 리스너가 아직 로드되지 않았습니다.
desktop-live-counters = 실시간 카운터
desktop-loading = 불러오는 중
desktop-loading-local-status = 로컬 상태 불러오는 중…
desktop-loading-metrics = 메트릭 불러오는 중…
desktop-loading-studies = 검사 불러오는 중…
desktop-local-node = 로컬 노드
desktop-locale-label = 언어
desktop-logs-activity-detail =
    { $count ->
        [one] { $count }줄 로드됨
       *[other] { $count }줄 로드됨
    }
desktop-logs-activity-fail = 로그 새로고침 실패
desktop-logs-activity-ok = 로그가 새로고침됨
desktop-logs-auto = 자동
desktop-logs-auto-refresh = 자동 새로고침
desktop-logs-empty = 로그 파일이 비어 있습니다.
desktop-logs-found = 로그 파일 발견
desktop-logs-lines =
    { $count ->
        [one] { $count }줄
       *[other] { $count }줄
    }
desktop-logs-loading = 로그 불러오는 중…
desktop-logs-missing = 활성 로그 파일이 아직 만들어지지 않았습니다.
desktop-logs-refresh-failed = 로그 새로고침 실패
desktop-logs-refreshed = 로그가 새로고침됨
desktop-logs-reveal = 표시
desktop-logs-subtitle = 활성 데스크톱 로그 파일의 제한된 꼬리.
desktop-logs-tail = 꼬리
desktop-logs-title = 로그
desktop-logs-truncated = 잘림
desktop-logs-waiting = 로그 파일 대기 중
desktop-metric-instances = 인스턴스
desktop-metric-remote-nodes = 원격 노드
desktop-metric-series = 시리즈
desktop-metric-studies = 검사
desktop-nav-archive = 로컬 아카이브
desktop-nav-dashboard = 대시보드
desktop-nav-import = 가져오기
desktop-nav-logs = 로그
desktop-nav-network = 네트워크
desktop-nav-nodes = 원격 노드
desktop-nav-query = 조회 / 가져오기
desktop-nav-server = 저장 서버
desktop-no-local-studies = 아직 로컬 검사가 없습니다.
desktop-nodes-add = 노드 추가
desktop-nodes-added = 노드 "{ $name }"을(를) 추가했습니다.
desktop-nodes-ae-length = AE Title은 16자 이하여야 합니다.
desktop-nodes-ae-title = AE Title
desktop-nodes-col-move = Move 대상
desktop-nodes-configured = 구성된 노드
desktop-nodes-confirm-delete = 노드 "{ $name }"을(를) 삭제할까요?
desktop-nodes-default-port = 기본 포트 104
desktop-nodes-delete = 노드 삭제
desktop-nodes-delete-title = 노드 삭제
desktop-nodes-deleted = 노드 "{ $name }"을(를) 삭제했습니다.
desktop-nodes-edit = 노드 편집
desktop-nodes-edit-title = 노드 편집
desktop-nodes-empty = 아직 원격 노드가 없습니다.
desktop-nodes-err-ae = AE 타이틀은 필수입니다.
desktop-nodes-err-ae-len = AE 타이틀은 최대 16자입니다.
desktop-nodes-err-host = 호스트는 필수입니다.
desktop-nodes-err-name = 이름은 필수입니다.
desktop-nodes-err-port = 포트는 1–65535여야 합니다.
desktop-nodes-host = 호스트
desktop-nodes-move-dest = Move 대상
desktop-nodes-move-placeholder = 기본값: 로컬 AE
desktop-nodes-name = 이름
desktop-nodes-need-ae = AE Title은 필수입니다.
desktop-nodes-need-host = 호스트는 필수입니다.
desktop-nodes-need-name = 이름은 필수입니다.
desktop-nodes-notes = 메모
desktop-nodes-notes-placeholder = 판독실 PACS
desktop-nodes-placeholder-ae = PACS01
desktop-nodes-placeholder-host = 192.168.0.10
desktop-nodes-placeholder-move = 기본값: 로컬 AE
desktop-nodes-placeholder-name = main-pacs
desktop-nodes-placeholder-notes = 판독실 PACS
desktop-nodes-port = 포트
desktop-nodes-port-104 = 기본 포트 104
desktop-nodes-port-range = 포트는 1–65535여야 합니다.
desktop-nodes-save = 변경 저장
desktop-nodes-save-changes = 변경 저장
desktop-nodes-subtitle = 조회, 가져오기, 스토어용 PACS 및 워크스테이션 피어.
desktop-nodes-summary = 노드 요약
desktop-nodes-title = 원격 노드
desktop-nodes-total = 전체 노드
desktop-nodes-updated = 노드 "{ $name }"을(를) 업데이트했습니다.
desktop-nodes-with-move = Move 대상 있음
desktop-promiscuous = 무제한 저장
desktop-query-accession = Accession 번호
desktop-query-activity-detail = { $count } { $count ->
        [one] 건
       *[other] 건
    } { $level } 레벨
desktop-query-activity-fail = C-FIND { $node } 실패
desktop-query-activity-ok = C-FIND { $node }
desktop-query-activity-title = C-FIND { $node }
desktop-query-clear = 지우기
desktop-query-col-accession = 접수번호
desktop-query-criteria = 검색 조건
desktop-query-date-from = 검사일 시작
desktop-query-date-to = 검사일 종료
desktop-query-kv-series-uid = Series UID
desktop-query-kv-sop-uid = SOP UID
desktop-query-kv-study-uid = Study UID
desktop-query-level = 레벨
desktop-query-matches =
    { $count ->
        [one] { $count }건 일치
       *[other] { $count }건 일치
    }
desktop-query-missing-study-uid = 일치에 StudyInstanceUID가 없어 가져올 수 없습니다.
desktop-query-modality = 모달리티
desktop-query-no-matches = 일치 없음.
desktop-query-no-nodes = 구성된 노드 없음
desktop-query-patient-id = 환자 ID
desktop-query-patient-name = 환자 이름
desktop-query-placeholder-description = CHEST*
desktop-query-placeholder-modality = CT, MR, …
desktop-query-placeholder-name = DOE^JOHN or DOE*
desktop-query-placeholder-patient = DOE^JOHN or DOE*
desktop-query-querying = 조회 중…
desktop-query-remote-node = 원격 노드
desktop-query-results = 결과
desktop-query-retrieve = 가져오기
desktop-query-retrieve-activity-detail = completed={ $completed }, warning={ $warning }, failed={ $failed }
desktop-query-retrieve-activity-fail = C-MOVE { $node } 실패
desktop-query-retrieve-activity-ok = C-MOVE { $node }
desktop-query-retrieve-finished = 가져오기 완료: 완료 { $completed }, 경고 { $warning }, 실패 { $failed }.
desktop-query-retrieve-selected = 선택 항목 가져오기
desktop-query-run = C-FIND 실행
desktop-query-run-select = 조회를 실행하고 일치를 선택하세요.
desktop-query-running = 조회 중…
desktop-query-search-criteria = 검색 조건
desktop-query-select-hint = 조회를 실행하고 일치를 선택하세요.
desktop-query-selected = 선택한 일치
desktop-query-selected-match = 선택한 일치
desktop-query-series-uid = Series Instance UID
desktop-query-sop-uid = SOP Instance UID
desktop-query-study-description = 검사 설명
desktop-query-study-uid = Study Instance UID
desktop-query-subtitle = 원격 노드에 C-FIND 한 뒤 일치 항목을 확인하고 로컬 아카이브로 C-MOVE 합니다.
desktop-query-title = 조회 / 가져오기
desktop-recent-studies = 최근 검사
desktop-scp-listening = SCP 수신 대기 중
desktop-scp-stopped = SCP 중지됨
desktop-server-activity-fail = Storage SCP 제어 실패
desktop-server-activity-started = Storage SCP 시작됨
desktop-server-activity-started-detail = 리스너가 시작되었습니다.
desktop-server-activity-stopped = Storage SCP 중지됨
desktop-server-activity-stopped-detail = received={ $received }, stored={ $stored }, failed={ $failed }
desktop-server-activity-stopped-empty = 활성 세션이 없습니다.
desktop-server-addr-ae = { $addr } · AE { $ae }
desktop-server-assoc-accepted = 수락된 어소시에이션
desktop-server-assoc-rejected = 거부된 어소시에이션
desktop-server-cfind-req-matches = C-FIND 요청 / 일치
desktop-server-cget-requests = C-GET 요청
desktop-server-cmove-requests = C-MOVE 요청
desktop-server-cmove-subops = C-MOVE 하위 작업 완료 / 실패
desktop-server-control-failed = Storage SCP 제어 실패
desktop-server-counter-bytes = 수집된 바이트
desktop-server-counter-failed = C-STORE 실패
desktop-server-counter-find = C-FIND 요청 / 일치
desktop-server-counter-get = C-GET 요청
desktop-server-counter-move = C-MOVE 요청
desktop-server-counter-move-sub = C-MOVE 하위 작업 완료 / 실패
desktop-server-counter-received = C-STORE 수신
desktop-server-counter-stored = C-STORE 저장됨
desktop-server-cstore-failed = C-STORE 실패
desktop-server-cstore-received = C-STORE 수신
desktop-server-cstore-stored = C-STORE 저장됨
desktop-server-dimse = DIMSE 카운터
desktop-server-failed = 실패
desktop-server-health-loading = 메트릭 불러오는 중
desktop-server-health-ready = 인바운드 C-STORE 준비됨
desktop-server-health-review = 실패 검토
desktop-server-health-stopped = 중지됨
desktop-server-listener-started = 리스너가 시작되었습니다.
desktop-server-listening = 수신 대기
desktop-server-loading-metrics = 메트릭 불러오는 중…
desktop-server-logs = 로그
desktop-server-no-session = 활성 세션이 없습니다.
desktop-server-rate = +{ $rate } / 폴링
desktop-server-ready = 인바운드 C-STORE 준비됨
desktop-server-review-failures = 실패 검토
desktop-server-session-ended = 세션 종료: 수신 { $received }, 저장 { $stored }, 실패 { $failed }.
desktop-server-start = 서버 시작
desktop-server-started-title = Storage SCP 시작됨
desktop-server-stop = 서버 중지
desktop-server-stopped = 중지됨
desktop-server-stopped-pill = 중지됨
desktop-server-stopped-status = 중지됨
desktop-server-stopped-title = Storage SCP 중지됨
desktop-server-stored = 저장됨
desktop-server-subtitle = 인바운드 C-STORE와 로컬 아카이브 색인을 위한 독립 Storage SCP.
desktop-server-title = 저장 서버
desktop-status-listening = 수신 대기 중
desktop-status-loading = 불러오는 중
desktop-status-scp-listening = SCP 수신 대기 중
desktop-status-scp-stopped = SCP 중지됨
desktop-status-stopped = 중지됨
desktop-store-syntax = Store 구문
desktop-strict-pdu = 엄격 PDU
desktop-strip-pdu = PDU { $value }
desktop-table-accession = 접수번호
desktop-table-ae-title = AE 타이틀
desktop-table-date = 날짜
desktop-table-description = 설명
desktop-table-endpoint = 엔드포인트
desktop-table-instances = 인스턴스
desktop-table-modalities = 모달리티
desktop-table-modality = 모달리티
desktop-table-move-dest = Move 대상
desktop-table-name = 이름
desktop-table-notes = 메모
desktop-table-patient = 환자
desktop-table-patient-id = 환자 ID
desktop-table-series = 시리즈
desktop-table-updated = 업데이트됨
desktop-title-refresh-status = 상태 새로고침
desktop-title-reveal-log = 로그 파일 표시
ae = AE
patient-name =
    "DOE^JOHN"
    선택한 결과에서 'm'을 누르면 retrieve가 열립니다.
port = 포트

## Summary
summary-ae = AE
summary-counts = 건수
summary-criteria = 조건
summary-duration = 소요 시간
summary-duration-ms = { $ms }ms
summary-failures = 실패:
summary-kind = 종류
summary-logs = 로그:
summary-peer = 피어
summary-status = 상태
summary-title = 작업 요약
tui-detail-created = 생성됨

tui-form-hint-port-range = 힌트: 1–65535 숫자, 예: 104
tui-form-hint-promiscuous = 힌트: 모든 호출 AE title의 저장 허용
tui-form-hint-strict-pdu = 힌트: 어소시에이션 중 PDU 크기 검사 강제
tui-form-hint-max-pdu-bytes = 힌트: 바이트, 예: 16384
tui-form-limits-heading = Limits (bytes; blank/없음 = unlimited):
tui-form-field-max-file-import = 파일 가져오기 최대 바이트
tui-form-field-max-zip-entry = ZIP 항목 최대 바이트
tui-form-field-max-zip-total = ZIP 총 최대 바이트
tui-form-field-max-zip-count = ZIP 항목 최대 개수
tui-form-field-max-store-object = 스토어 객체 최대 바이트
tui-form-unlimited = 무제한
tui-form-err-max-pdu-required = ! 최대 PDU 길이는 필수입니다
tui-form-err-max-pdu-gt-zero = ! 최대 PDU 길이는 0보다 큰 정수여야 합니다
tui-form-err-limit-gt-zero = ! { $label }은(는) 0보다 큰 정수여야 합니다
tui-form-controls-scp = 입력하여 편집. Space로 확인란 전환. Tab/Shift-Tab 또는 위/아래로 필드 이동. Enter로 저장. Esc로 취소.
tui-form-submit-uid-required = UID는 필수입니다
tui-form-submit-dest-required = destination 노드 is required
tui-form-submit-nonneg-int = { $label }은(는) 음이 아닌 정수여야 합니다
tui-form-submit-gt-zero = { $label }은(는) 0보다 커야 합니다
tui-form-submit-local-ae-required = 로컬 AE title은 필수입니다
tui-form-submit-local-ae-invalid = 로컬 AE title이 잘못되었습니다: { $err }
tui-form-submit-bind-required = 바인드 주소는 필수입니다
tui-form-submit-port-required = 포트는 필수입니다
tui-form-submit-max-pdu-required = 최대 PDU 길이는 필수입니다
tui-form-submit-max-pdu-int = 최대 PDU 길이는 정수여야 합니다
tui-form-submit-max-pdu-gt-zero = 최대 PDU 길이는 0보다 커야 합니다
tui-form-submit-patient-retrieve = 환자 수준 가져오기는 지원되지 않습니다
tui-form-submit-no-study-uid = 선택한 결과에 study UID가 없습니다
tui-form-submit-date-format = YYYYMMDD 형식
tui-form-submit-modality-len = 모달리티는 최대 16자여야 합니다
tui-form-submit-modality-chars = 모달리티는 A-Z 또는 0-9여야 합니다
tui-form-submit-name-required = 노드 이름은 필수입니다
tui-form-submit-ae-required = AE title은 필수입니다
tui-form-submit-host-required = 호스트는 필수입니다
tui-form-submit-move-dest-invalid = 이동 대상 AE title이 잘못되었습니다: { $err }
tui-form-submit-dates-both = 시작일과 종료일을 모두 설정하거나 둘 다 비워야 합니다
tui-form-submit-date-from-invalid = 시작 날짜가 잘못되었습니다: { $err }
tui-form-submit-date-to-invalid = 종료 날짜가 잘못되었습니다: { $err }
tui-form-submit-date-order = 시작 날짜는 종료 날짜 이전이어야 합니다
tui-form-submit-study-uid-series-query = 시리즈 수준 조회에는 study UID가 필요합니다
tui-form-submit-study-uid-image-query = 이미지 수준 조회에는 study UID가 필요합니다
tui-form-submit-series-uid-image-query = 이미지 수준 조회에는 series UID가 필요합니다
tui-form-submit-study-uid-required = study UID는 필수입니다
tui-form-submit-study-uid-invalid = study UID가 잘못되었습니다: { $err }
tui-form-submit-series-uid-series-retrieve = 시리즈 수준 가져오기에는 series UID가 필요합니다
tui-form-submit-series-uid-image-retrieve = 이미지 수준 가져오기에는 series UID가 필요합니다
tui-form-submit-instance-uid-image-retrieve = 이미지 수준 가져오기에는 instance UID가 필요합니다
tui-form-submit-series-uid-invalid = series UID가 잘못되었습니다: { $err }
tui-form-submit-instance-uid-invalid = instance UID가 잘못되었습니다: { $err }
tui-form-submit-import-path-required = 가져오기 경로는 필수입니다
tui-form-submit-import-path-type = 가져오기 경로는 파일 또는 디렉터리여야 합니다: { $path }
tui-form-submit-import-access = 가져오기 경로 { $path } 접근 중
tui-form-submit-import-open = 가져오기 파일 { $path } 여는 중
tui-form-submit-import-read-dir = 가져오기 디렉터리 { $path } 읽는 중
tui-log-welcome = Press F1 or ? for help. Focus 원격 노드s and press 'a' to add one.
tui-log-logging-to = { $path }에 기록 중
tui-command-help-heading = 명령:
tui-command-help-next-1 = 참고: 바닥글은 포커스된 창과 선택에 따라 상황별 'Next:' 제안을 표시합니다.
tui-command-help-next-2 = 힌트일 뿐입니다. 언제든지 아무 명령이나 입력할 수 있습니다.
tui-command-help-canonical = 참고: 정규 이름은 '--' 없는 CLI 플래그와 같으며 밑줄을 사용합니다.
tui-command-help-cancel = cancel (별칭: stop)
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
tui-command-help-refresh = 새로고침
tui-command-help-quit = 종료
tui-inspect-task = 작업 #{ $id }
tui-inspect-status = 상태: { $status }
tui-inspect-description = 설명: { $description }
tui-inspect-progress = 진행: { $progress }
tui-inspect-summary = 요약:
tui-inspect-no-logs = (로그 없음)
tui-field-sop-class-uid = SOP Class UID
tui-field-transfer-syntax-uid = Transfer Syntax UID
tui-field-sha256 = SHA-256
tui-status-removed-nodes =
    삭제됨 { $count ->
        [one] { $count }개 노드
       *[other] { $count }개 노드
    }
tui-status-removed-nodes-target =
    삭제됨 { $count ->
        [one] { $count }개 노드
       *[other] { $count }개 노드
    }; 마지막 대상 { $name }
tui-status-more-failures =
    그리고 { $n ->
        [one] { $n }건 실패 생략
       *[other] { $n }건 실패 생략
    }
tui-status-retrieve-ok = retrieve status=0x{ $status } completed={ $completed } failed={ $failed } warning={ $warning } remaining={ $remaining }
tui-status-import-counts = scanned={ $scanned } accepted={ $accepted } duplicates={ $duplicates } unreadable={ $unreadable } invalid_dicom={ $invalid } rejected_total={ $rejected } stored_bytes={ $bytes }
tui-status-send-ok = send attempted={ $attempted } sent={ $sent } failed={ $failed }
tui-log-query-start = { $node }에 대한 조회 시작
tui-log-retrieve-start = { $node }에서 가져오기 시작
tui-log-import-start = { $path } 가져오기 시작
tui-log-send-study-start = 검사 { $uid }을(를) { $node }(으)로 전송 시작
tui-log-send-series-start = 시리즈 { $uid }을(를) { $node }(으)로 전송 시작
tui-log-cancelled-before-start = 시작 전 취소됨
tui-log-cancelled = 취소됨
error-unknown-command = 알 수 없는 명령: { $command }
error-node-subcommand-required = node 하위 명령이 필요합니다
error-local-subcommand-required = local 하위 명령이 필요합니다
error-unsupported-node-subcommand = unsupported 노드 subcommand: { $command }
error-unsupported-local-subcommand = 지원되지 않는 local 하위 명령: { $command }
error-expected-kv = key=value 인수가 필요한데 { $arg }을(를) 받았습니다
error-missing-required-arg = 필수 인수가 없습니다: { $key }
error-missing-required-arg-one-of = 필수 인수가 없습니다(다음 중 하나): { $keys }
error-parsing-command = 명령 구문 분석
error-edit-form-lost-target = edit form lost its target 노드
error-task-already-running = 백그라운드 작업이 이미 실행 중입니다
error-task-thread-launch = 백그라운드 작업 스레드를 시작하지 못함: { $error }
error-task-disconnected = 결과를 보내기 전에 백그라운드 작업 스레드가 끊겼습니다
error-task-kind-missing = 백그라운드 작업 스레드가 끊겼지만 active_task_kind가 None입니다: 예기치 않은 상태
error-serve-exited = serve가 오류로 종료됨: { $error }
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
summary-title = 작업 요약
summary-kind = 종류
summary-status = 상태
summary-duration = 소요 시간
summary-duration-ms = { $ms }ms
summary-peer = 피어
summary-ae = AE
summary-criteria = 조건
summary-counts = 건수
summary-failures = 실패:
summary-logs = 로그:
summary-unserializable = <직렬화 불가>
summary-log-lines = 줄 { $start }-{ $end }
