# Fluent catalog (vi-VN). Message IDs are hyphenated identifiers
# (cli-about, tui-pane-remote-nodes, desktop-nav-dashboard, error-import-file-too-large).
# Dotted names are Fluent attributes (message + .attr), not message IDs.
# Do not translate DICOM tokens (C-FIND, C-MOVE, C-STORE, SOP, AE, UID) or JSON/CSV machine keys.


## CLI
cli-about = Ứng dụng nút DICOM ưu tiên terminal, xây dựng bằng dicom-rs
cli-arg-accession-number = Lọc theo số accession (chuỗi con không phân biệt hoa thường).
cli-arg-ae-title = Application Entity title
cli-arg-destination-node = Tên hoặc id nút đích
cli-arg-duplicate = Lọc theo trạng thái trùng.
cli-arg-export = Xuất kết quả dưới dạng JSON hoặc CSV.
cli-arg-host = Tên máy chủ hoặc IP
cli-arg-imported-at =
    Lọc theo dấu thời gian nhập. Hỗ trợ VALUE, START..END, ..END, START..
    So sánh theo thứ tự từ điển (định dạng khuyến nghị: RFC3339).
cli-arg-json = Xuất tóm tắt thao tác cuối dưới dạng JSON (lược đồ ổn định).
cli-arg-level = Mức truy vấn/truy xuất
cli-arg-metrics-json = In snapshot số liệu trong bộ nhớ dưới dạng JSON khi máy chủ thoát.
cli-arg-modality = Lọc theo modalitas. Danh sách phân tách bằng dấu phẩy (ví dụ CT,MR).
cli-arg-model = Mô hình thông tin truy vấn/truy xuất
cli-arg-move-destination = AE title đích C-MOVE ưu tiên
cli-arg-name = Tên hiển thị của nút
cli-arg-node = Tên hoặc id nút đã lưu
cli-arg-notes = Ghi chú tự do
cli-arg-out = Đường dẫn tệp xuất. Nếu bỏ qua, ghi ra stdout.
cli-arg-path = Tệp hoặc thư mục cần nhập
cli-arg-patient-id = Lọc theo mã bệnh nhân (chuỗi con không phân biệt hoa thường).
cli-arg-patient-name = Lọc theo tên bệnh nhân (chuỗi con không phân biệt hoa thường).
cli-arg-port = Cổng
cli-arg-series-description = Lọc theo mô tả chuỗi (chuỗi con không phân biệt hoa thường).
cli-arg-series-instance-uid = Series Instance UID
cli-arg-sop-instance-uid = SOP Instance UID
cli-arg-source-path = Lọc theo đường dẫn nguồn (chuỗi con không phân biệt hoa thường).
cli-arg-study-date =
    Lọc theo ngày nghiên cứu. Hỗ trợ VALUE, START..END, ..END, START..
    Ngày được so sánh theo thứ tự từ điển (định dạng khuyến nghị: YYYYMMDD).
cli-arg-study-date-from = Giới hạn dưới ngày nghiên cứu (YYYYMMDD)
cli-arg-study-date-to = Giới hạn trên ngày nghiên cứu (YYYYMMDD)
cli-arg-study-description = Lọc theo mô tả nghiên cứu (chuỗi con không phân biệt hoa thường).
cli-arg-study-instance-uid = Study Instance UID
cli-cmd-import-about = Nhập tệp DICOM từ một đường dẫn
cli-cmd-local-about = Kiểm tra kho lưu trữ cục bộ
cli-cmd-local-series-about = Liệt kê chuỗi đã lập chỉ mục của một nghiên cứu
cli-cmd-local-studies-about = Liệt kê nghiên cứu cục bộ đã lập chỉ mục
cli-cmd-node-about = Quản lý nút DICOM từ xa đã lưu
cli-cmd-node-add-about = Thêm nút từ xa
cli-cmd-node-delete-about = Xóa nút đã lưu
cli-cmd-node-edit-about = Sửa nút đã lưu
cli-cmd-node-list-about = Liệt kê nút đã lưu
cli-cmd-query-about = Truy vấn nút từ xa (C-FIND)
cli-cmd-retrieve-about = Truy xuất từ nút từ xa (C-MOVE)
cli-cmd-send-about = Gửi nghiên cứu hoặc chuỗi cục bộ (C-STORE)
cli-cmd-send-series-about = Gửi một chuỗi tới nút đích
cli-cmd-send-study-about = Gửi một nghiên cứu tới nút đích
cli-cmd-serve-about = Chạy máy chủ DICOM
cli-cmd-storage-scp-about = Chạy listener Storage SCP
cli-cmd-tui-about = Mở giao diện terminal tương tác
cli-flag-help = In trợ giúp
cli-flag-lang = Ngôn ngữ giao diện (thẻ BCP-47). Ghi đè DICOM_NODE_LANG và locale hệ điều hành.
cli-flag-version = In phiên bản
cli-heading-arguments = Đối số:
cli-heading-commands = Lệnh:
cli-heading-options = Tùy chọn:
cli-heading-usage = Cách dùng:
cli-import-accepted = accepted={ $n }
cli-import-complete = Nhập complete
cli-import-duplicates = duplicates={ $n }
cli-import-scanned = scanned={ $n }
cli-msg-cancel-sigint = Đã yêu cầu hủy (SIGINT). Đang chờ tắt an toàn...
cli-msg-failures = failures:
cli-msg-import-failed = Nhập thất bại: { $error }
cli-msg-no-local-series = Không có chuỗi đã lập chỉ mục cho ca khám { $uid }
cli-msg-no-local-studies = Không có ca khám cục bộ đã lập chỉ mục
cli-msg-no-saved-nodes = Không có nút đã lưu
cli-msg-query-failed = Truy vấn thất bại: { $error }
cli-msg-removed-nodes =
    Đã xóa { $count ->
        [one] { $count } nút
       *[other] { $count } nút
    }
cli-msg-results-count =
    Kết quả: { $count ->
        [one] { $count } kết quả khớp
       *[other] { $count } kết quả khớp
    }
cli-msg-retrieve-failed = Truy xuất thất bại: { $error }
cli-msg-saved-node = Saved nút { $name } [{ $id }] => { $ae }@{ $host }:{ $port }
cli-msg-send-failed = Gửi thất bại: { $error }
cli-msg-showing-failures = (hiển thị { $shown } thất bại đầu trong { $total })
cli-msg-starting-server =
    Đang khởi động máy chủ DICOM với { $count ->
        [one] { $count } AE cục bộ
       *[other] { $count } AE cục bộ
    }: { $aes }
cli-msg-starting-server-no-aes = Đang khởi động máy chủ DICOM không có AE cục bộ đã cấu hình
cli-msg-starting-storage-scp = Đang khởi động storage SCP tại { $addr } với AE title { $ae }
cli-msg-updated-node = Updated nút { $name } [{ $id }] => { $ae }@{ $host }:{ $port }
cli-send-attempted = attempted={ $n }
cli-send-failed-count = failed={ $n }
cli-send-sent = sent={ $n }
cli-value-name-file = FILE
cli-value-name-format = FORMAT
cli-value-name-locale = LOCALE
cli-value-name-path = PATH
tui-detail-more-series =
    ... { $n ->
        [one] { $n } series nữa
       *[other] { $n } series nữa
    }
tui-row-instance-count =
    { $n ->
        *[other] { $n } phiên bản
    }
tui-row-study-counts = { $series }s/{ $instances }i
count-nodes =
    { $n ->
        [one] { $n } nút
       *[other] { $n } nút
    }
count-instances =
    { $n ->
        [one] { $n } instance
       *[other] { $n } instance
    }
count-series =
    { $n ->
        *[other] { $n } chuỗi
    }
count-studies =
    { $n ->
        [one] { $n } ca khám
       *[other] { $n } ca khám
    }
format-datetime = { $date } { $time }
format-date = { $day }/{ $month }/{ $year }

## Common
common-accession = Số accession
common-add = Thêm
common-back = Quay lại
common-bytes = Byte
common-cancel = Hủy
common-clear = Xóa
common-close = Đóng
common-date = Ngày
common-delete = Xóa nút
common-description = Mô tả
common-disabled = tắt
common-duplicates = Trùng lặp
common-edit = Sửa
common-enabled = bật
common-error = Lỗi
common-filter = Bộ lọc
common-host = Máy chủ
common-import = Nhập
common-instance = Phiên bản
common-language = Ngôn ngữ
common-loading = Đang tải
common-matches = Khớp
common-modality = bộ phận
common-name = Tên
common-network = Mạng
common-no = không
common-none = không
common-notes = Ghi chú
common-optional = tùy chọn
common-path = Nguồn
common-patient = Bệnh nhân
common-patient-id = ID bệnh nhân
common-patient-name = Tên bệnh nhân
common-port = Cổng
common-query = Truy vấn
common-refresh = Làm mới
common-required = bắt buộc
common-retrieve = Truy xuất
common-save = Lưu
common-search = Tìm
common-send = Gửi
common-series = Chuỗi
common-start = Bắt đầu
common-status = Trạng thái
common-stop = Dừng
common-studies = Ca khám
common-study = Ca khám
common-unknown = không rõ
common-unknown-series = <Series>
common-unknown-study = <Ca khám>
common-yes = có

## Errors
error-ae-empty = AE title không được để trống
error-ae-invalid-char = AE title chứa ký tự không hợp lệ '{ $character }'; cho phép: A-Z, 0-9, khoảng trắng
error-ae-required = AE title là bắt buộc
error-ae-too-long = AE title tối đa 16 ký tự
error-ae-whitespace = AE title không được có khoảng trắng đầu hoặc cuối
error-archive-patient-retrieve-out-of-scope = retrieve cấp Patient nằm ngoài phạm vi
error-archive-retrieve-uid-required = { $name } là bắt buộc cho cấp retrieve này
error-archive-study-root-patient-query = truy vấn Study Root không hỗ trợ cấp Patient
error-archive-study-root-patient-retrieve = retrieve Study Root không hỗ trợ cấp Patient
error-assoc-negotiation-failed = đàm phán association thất bại với { $name } ({ $addr }); gợi ý: kiểm tra called AE title, presentation contexts/transfer syntaxes, và nút đối tác có chấp nhận association
error-assoc-no-addresses = không phân giải được địa chỉ socket cho { $name } tại { $host }:{ $port }
error-assoc-receive = nhận association
error-assoc-resolving = đang phân giải { $name } tại { $host }:{ $port }: { $err }
error-assoc-timeout = hết thời gian chờ phản hồi DIMSE; gợi ý: kiểm tra kết nối mạng, AE title/máy chủ/cổng, và phản hồi của nút đối tác
error-assoc-transport = gián đoạn vận chuyển khi chờ phản hồi DIMSE; gợi ý: nút đối tác đóng kết nối hoặc thiết bị mạng đã đặt lại
error-assoc-unreachable = không tới được { $name } [{ $ae }] tại { $host }:{ $port } trong { $seconds }s: { $err }. Kiểm tra máy chủ/IP, cổng và khả năng tới mạng
error-cancel-sigint = Đã yêu cầu hủy (SIGINT). Đang chờ tắt an toàn...
error-config-must-be-positive = cấu hình không hợp lệ: { $name } phải > 0 (hoặc null để tắt)
error-config-duplicate-bind-port = cấu hình không hợp lệ: cổng bind AE cục bộ trùng { $port }
error-config-local-ae-max-assoc = cấu hình không hợp lệ: AE cục bộ { $title } max_concurrent_associations phải > 0
error-config-local-ae-no-services = cấu hình không hợp lệ: AE cục bộ { $title } phải bật ít nhất một dịch vụ
error-config-must-be-positive-required = cấu hình không hợp lệ: { $name } phải > 0
error-dicom-meta-incomplete = meta tệp DICOM chưa đầy đủ
error-dicom-patient-move-unsupported = C-MOVE mức bệnh nhân không được ứng dụng khách này hỗ trợ
error-dicom-required-attribute = thiếu thuộc tính DICOM bắt buộc: ({ $group },{ $element })
error-dicom-series-uid-required-image = cần series_instance_uid cho truy xuất mức ảnh
error-dicom-series-uid-required-series = cần series_instance_uid cho truy xuất mức chuỗi
error-dicom-sop-uid-required-image = cần sop_instance_uid cho truy xuất mức ảnh
error-dicom-study-uid-required = cần study_instance_uid
error-dicom-validating-move = đang xác thực yêu cầu move
error-export-creating-file = đang tạo tệp xuất { $path }: { $err }
error-export-flushing-series-csv = đang đẩy CSV chuỗi: { $err }
error-export-flushing-studies-csv = đang đẩy CSV nghiên cứu: { $err }
error-export-serializing-series-json = tuần tự hóa JSON của chuỗi: { $err }
error-export-serializing-studies-json = tuần tự hóa JSON của nghiên cứu: { $err }
error-export-writing-series-csv-header = đang ghi tiêu đề CSV chuỗi: { $err }
error-export-writing-series-csv-row = đang ghi hàng CSV chuỗi: { $err }
error-export-writing-studies-csv-header = đang ghi tiêu đề CSV nghiên cứu: { $err }
error-export-writing-studies-csv-row = đang ghi hàng CSV nghiên cứu: { $err }
error-import-cleanup-failed = { $source }: dọn dẹp thất bại: { $reason }
error-import-corrupt-zip = ZIP hỏng: { $details }
error-import-dicom-parse-failed = phân tích DICOM thất bại: { $err }
error-import-dicom-validation-failed = xác thực DICOM thất bại: { $err }
error-import-duplicate-zip-path = ZIP chứa nhiều mục nhắm tới '{ $path }'
error-import-file-too-large = tệp quá lớn: { $details }
error-import-invalid-dicom = DICOM không hợp lệ: { $details }
error-import-limit-exceeded = { $limit } vượt giới hạn: { $details }
error-import-not-regular-file = không phải tệp thông thường
error-import-opening-file = đang mở tệp: { $err }
error-import-opening-kind = đang mở { $kind } { $path }
error-import-opening-staged-file = đang mở tệp tạm: { $err }
error-import-opening-zip-archive = đang mở kho ZIP { $path }
error-import-opening-zip-entry = đang mở mục ZIP: { $err }
error-import-opening-zip-file = đang mở tệp ZIP nhập { $path }
error-import-path-does-not-exist = Đường dẫn nhập không tồn tại: { $path }
error-import-reading-directory = đang đọc thư mục nhập { $path }
error-import-reading-file = đang đọc tệp: { $err }
error-import-reading-file-metadata = đang đọc siêu dữ liệu tệp của { $path }
error-import-reading-metadata = đang đọc siêu dữ liệu của { $kind } { $path }
error-import-reading-zip-entry = đang đọc mục ZIP: { $err }
error-import-removing-staged-after-cancel = đang xóa tệp tạm sau khi hủy { $path }
error-import-skipped = { $source }: đã bỏ qua: { $reason }
error-import-unreadable = Tệp không đọc được: { $details }
error-import-unsafe-zip-path = đường dẫn mục thoát khỏi kho lưu trữ
error-import-zip-entry-count-exceeded = vượt giới hạn số mục ZIP: kho có { $count } mục, giới hạn { $limit }
error-import-zip-entry-size-exceeded = kích thước mục ZIP { $size } vượt giới hạn { $limit }
error-import-zip-total-bytes-exceeded = vượt giới hạn tổng byte giải nén ZIP: tổng hiện tại { $current } cộng kích thước mục { $entry } vượt { $limit }
error-net-binding-storage-scp = đang bind Storage SCP tại { $addr } cho AE { $ae }. Bộ nhận DICOM cục bộ khác có thể đang dùng cổng đó. Cập nhật storage_scp_port/local_aes trong { $config } hoặc dừng listener xung đột
error-net-building-file-meta = đang dựng bảng file meta
error-net-cannot-send-transfer-syntax = không gửi được transfer syntax nguồn { $source } với { $negotiated } đã thương lượng
error-net-cget-dataset-empty = dataset C-GET C-STORE đã mã hóa trống
error-net-cget-dataset-odd-length = dataset C-GET C-STORE đã mã hóa kết thúc bằng mảnh độ dài lẻ
error-net-cget-peer-released = nút đối tác giải phóng association trong C-GET
error-net-cget-store-unexpected-dataset = bất ngờ dataset fragment in C-GET C-STORE response
error-net-cget-unexpected-command = bất ngờ command 0x{ $command } while waiting for C-STORE-RSP
error-net-cget-unexpected-pdu = bất ngờ PDU during C-GET C-STORE suboperation: { $pdu }
error-net-creating-incoming-dir = đang tạo thư mục .incoming của Storage SCP
error-net-creating-path = đang tạo { $path }
error-net-dataset-empty = dataset đã mã hóa trống nhưng COMMAND_DATA_SET_TYPE cho biết cần dataset
error-net-dataset-odd-length = dataset đã mã hóa kết thúc bằng mảnh độ dài lẻ
error-net-dimse-failed = { $operation } thất bại với trạng thái 0x{ $status } ({ $meaning }){ $hint }
error-net-establishing-assoc = đang thiết lập association Storage SCP
error-net-file-meta-length = đọc File Meta Information length
error-net-file-meta-tag = đọc File Meta Information tag
error-net-file-meta-value = đang bỏ qua giá trị File Meta Information
error-net-file-meta-vr = đọc File Meta Information VR
error-net-file-position = đọc file position
error-net-flushing-path = đang xả { $path }
error-net-flushing-temp-dataset = đang xả tệp dataset tạm
error-net-hint-suffix = ; gợi ý: { $hint }
error-net-incomplete-command = không đầy đủ { $operation } command response
error-net-incomplete-identifier = không đầy đủ { $operation } response identifier
error-net-invalid-affected-sop = không hợp lệ { $operation } affected SOP class UID
error-net-invalid-status = không hợp lệ { $operation } status
error-net-listener-address = đọc storage SCP listener address
error-net-listener-nonblocking = đang đặt listener sang chế độ không chặn
error-net-listener-port = đọc storage SCP listener port
error-net-local-aes-empty = local_aes phải chứa ít nhất một AE để khởi động Storage SCP
error-net-locating-dataset = đang định vị dataset trong { $path }
error-net-malformed-dimse = malformed { $operation } DIMSE response: { $details }; gợi ý: peer sent an không hợp lệ or bất ngờ DIMSE command set
error-net-missing-affected-sop = thiếu { $operation } affected SOP class UID
error-net-missing-command-field = thiếu command field
error-net-missing-cstore-rsp-command-field = thiếu C-STORE response command field
error-net-missing-cstore-rsp-status = thiếu C-STORE response status
error-net-missing-destination = thiếu C-MOVE destination
error-net-missing-dicm = thiếu Part 10 DICM marker
error-net-missing-message-id = thiếu { $operation } message id
error-net-missing-qr-level = { $operation } identifier is thiếu QueryRetrieveLevel
error-net-missing-required-command-field = thiếu required command field { $name } ({ $tag })
error-net-missing-status = thiếu { $operation } status
error-net-move-destination-unresolved = move_destination chưa được phân giải
error-net-no-cget-store-context = không có presentation context lưu trữ C-GET đã thương lượng cho SOP Class { $sop } và transfer syntax { $syntax }
error-net-no-compatible-context = { $path }: không có presentation context tương thích đã thương lượng cho transfer syntax nguồn { $syntax }
error-net-no-dimse-provider = không có nhà cung cấp DIMSE đăng ký cho lệnh 0x{ $command } và abstract syntax { $syntax }
error-net-no-presentation-context = không có presentation context đã thương lượng
error-net-no-presentation-context-for-file = { $path }: không có presentation context đã thương lượng
error-net-no-presentation-context-id = thiếu negotiated presentation context { $id }
error-net-opening-path = mở { $path }
error-net-part10-preamble = đọc Part 10 preamble
error-net-path-error = { $path }: { $err }
error-net-pdata-feed-complete = cannot feed P-DATA fragment into a complete accumulator (thiếu take())
error-net-peer-aborted = nút đối tác hủy association trong thao tác phụ C-GET C-STORE: { $source }
error-net-peer-socket = đọc storage SCP peer socket address
error-net-reading-command-dataset = đọc command dataset
error-net-reading-identifier = đọc { $operation } identifier
error-net-reading-incoming-dataset = đọc incoming C-STORE dataset
error-net-reading-response-dataset = đọc { $operation } response dataset
error-net-remote-aborted = phía xa đã hủy association: { $source }
error-net-restoring-read-timeout = khôi phục thời gian chờ đọc association
error-net-restoring-write-timeout = khôi phục thời gian chờ ghi association
error-net-rewinding-dataset = đang tua về phần tử dataset đầu tiên
error-net-scp-thread-panicked = luồng Storage SCP bị panic
error-net-seeking-temp-dataset = đang seek tệp dataset tạm
error-net-serializing-cget-dataset = đang tuần tự hóa dataset thao tác phụ C-GET cho { $path }
error-net-serializing-dataset = đang tuần tự hóa dataset của { $path } với transfer syntax { $syntax }
error-net-setting-socket-blocking = đang đặt socket lưu trữ đã chấp nhận sang chế độ chặn
error-net-sending-buffered-dataset = đang gửi dataset đã đệm của { $path }
error-net-store-status = phía xa trả về trạng thái C-STORE 0x{ $status } ({ $meaning }){ $hint }
error-net-streaming-dataset = đang truyền luồng dataset C-STORE
error-net-unexpected-command-field = bất ngờ CommandField 0x{ $actual } (expected 0x{ $expected } for { $rsp })
error-net-unexpected-dataset-fragment = bất ngờ dataset fragment in C-STORE response
error-net-unexpected-pdu = bất ngờ PDU during { $operation }: { $pdu }
error-net-unknown-status = không hợp lệ { $operation } status 0x{ $status }
error-net-unsupported-model-sop = không hỗ trợ { $operation } model SOP class UID: { $uid }
error-net-unsupported-qr-level = không hỗ trợ QueryRetrieveLevel: { $level }
error-net-unsupported-transfer-syntax = không hỗ trợ negotiated transfer syntax
error-net-writing-command-dataset = ghi command dataset
error-net-writing-identifier = ghi { $operation } identifier
error-net-writing-path = ghi { $path }
error-net-writing-response-dataset = ghi { $operation } response dataset
error-net-writing-temp-dataset = ghi dataset bytes to temp file
error-node-host-empty = máy chủ của nút không được để trống
error-node-name-empty = tên nút không được để trống
error-node-not-found = không tìm thấy nút từ xa: { $id }
error-operation-cancelled = thao tác đã bị hủy
error-port-invalid = cổng không hợp lệ: { $value }
error-port-range = cổng phải từ 1 đến 65535
error-query-no-study-uid = Kết quả không có StudyInstanceUID; không thể retrieve.
error-query-unsupported-level = mức truy vấn không được hỗ trợ: { $value }
error-query-unsupported-model = mô hình truy vấn không được hỗ trợ: { $value }
error-retrieve-canceled = truy xuất bị nút từ xa hủy (status=0x{ $status }, completed={ $completed }, failed={ $failed }, warning={ $warning }, remaining={ $remaining }, { $scp })
error-retrieve-failed = truy xuất thất bại với status=0x{ $status } (completed={ $completed }, failed={ $failed }, warning={ $warning }, remaining={ $remaining }, { $scp })
error-retrieve-nothing-arrived = truy xuất kết thúc cho đích { $destination } với completed={ $completed } nhưng không có gì tới Storage SCP cục bộ ({ $scp }). Kiểm tra ánh xạ AE hoặc sai cổng: đảm bảo { $listener } trống và nút từ xa ánh xạ AE { $destination } tới ứng dụng này
error-send-no-files-series = không có tệp cục bộ đã lập chỉ mục cho chuỗi { $uid }
error-send-no-files-study = không có tệp cục bộ đã lập chỉ mục cho nghiên cứu { $uid }
error-task-cancelled = Tác vụ đã bị hủy
error-task-none-to-cancel = Không có tác vụ đang chạy để hủy
error-tracing-init = khởi tạo tracing subscriber: { $err }
error-uid-component-numeric = thành phần UID '{ $part }' phải là số
error-uid-component-too-long = thành phần UID '{ $part }' quá dài
error-uid-dot-ends = UID không được bắt đầu hoặc kết thúc bằng dấu chấm
error-uid-empty = UID không được để trống
error-uid-empty-component = UID không được chứa thành phần rỗng
error-uid-leading-zeros = thành phần UID '{ $part }' không được có số 0 đứng đầu
error-uid-too-long = UID tối đa 64 ký tự

## TUI
tui-bool-no = không
tui-bool-off = tắt
tui-bool-on = bật
tui-bool-yes = có
tui-command-placeholder = Nhập lệnh hoặc dùng phím tắt khung.
tui-config-ae-title = AE title: { $value }
tui-config-edit-hint = Nhấn Tab để chọn khung này, rồi nhấn 'c' để sửa.
tui-config-hint = Nhấn Tab để chọn khung này, rồi nhấn 'c' để sửa.
tui-config-listener = Bộ lắng nghe: { $value }
tui-config-max-pdu = max_pdu_length: { $value }
tui-config-promiscuous = allow_promiscuous_storage: { $value }
tui-config-strict-pdu = strict_pdu: { $value }
tui-config-ts-pref = Ưu tiên TS: { $value }
tui-controls-hint = Tab trường · Enter xác nhận · Esc hủy
tui-detail-ae-title = AE Title
tui-detail-instance = Chi tiết instance
tui-detail-name = Tên
tui-detail-node = Chi tiết nút
tui-detail-placeholder-followup = Chuyển tiêu điểm sang khung danh sách và đổi lựa chọn để cập nhật khung này.
tui-detail-query = Chi tiết kết quả truy vấn
tui-detail-select-node = Chọn nút từ xa để xem siêu dữ liệu.
tui-detail-series = Chuỗi Detail
tui-detail-study = Chi tiết ca khám
tui-empty-command-placeholder = Nhập lệnh hoặc dùng phím tắt khung.
tui-empty-detail-instance = Chọn một phiên bản để xem, hoặc nhấn Esc để về chuỗi.
tui-empty-detail-node = Chọn nút từ xa để xem siêu dữ liệu.
tui-empty-detail-query = Chọn kết quả truy vấn để xem siêu dữ liệu và ngữ cảnh retrieve.
tui-empty-detail-series = Chọn một chuỗi để xem, hoặc nhấn Esc để về các ca khám.
tui-empty-detail-study = Chọn một ca khám cục bộ để xem siêu dữ liệu bệnh nhân và chuỗi.
tui-empty-instances = Không có instance đã lập chỉ mục cho chuỗi này.
tui-empty-instances-hint = Nhấn Esc để quay lại chuỗi.
tui-empty-local-instances = Không có instance đã lập chỉ mục cho chuỗi này.
tui-empty-local-instances-hint = Nhấn Esc để quay lại chuỗi.
tui-empty-local-series = Không có chuỗi đã lập chỉ mục cho ca khám này.
tui-empty-local-series-hint = Nhấn Esc để quay lại ca khám cục bộ.
tui-empty-local-studies = Chưa có ca khám đã lập chỉ mục.
tui-empty-local-studies-cmd = Ví dụ: import path=/data/inbox
tui-empty-local-studies-hint = Nhập local DICOM files first.
tui-empty-no-name = <không tên>
tui-empty-query = Chưa chạy truy vấn nào.
tui-empty-query-body =
    Chọn nút từ xa và nhấn 'f' để truy vấn.
    Hoặc: query node=pacs
        patient_name="DOE^JOHN"
    Nhấn 'm' trên kết quả đã chọn để mở retrieve.
tui-empty-query-cmd = Hoặc: query node=pacs
tui-empty-query-hint = Chọn nút từ xa và nhấn 'f' để truy vấn.
tui-empty-query-last-target = Đích truy vấn gần nhất: { $name }
tui-empty-query-none = Chưa chạy truy vấn nào.
tui-empty-query-retrieve-hint = Nhấn 'm' trên kết quả đã chọn để mở retrieve.
tui-empty-remote-nodes = No nút từ xas are saved yet.
tui-empty-remote-nodes-cmd = Hoặc: node add name=pacs
tui-empty-remote-nodes-hint = Nhấn 'a' trong khung này để thêm một nút.
tui-empty-series = Không có chuỗi đã lập chỉ mục cho ca khám này.
tui-empty-series-hint = Nhấn Esc để quay lại ca khám cục bộ.
tui-empty-studies = Chưa có ca khám đã lập chỉ mục.
tui-empty-studies-hint = Nhập local DICOM files first.
tui-empty-tasks-history = Không có lịch sử tác vụ.
tui-empty-tasks-queued = Không có tác vụ trong hàng đợi.
tui-fallback-no-name = <không tên>
tui-field-accession = Số accession
tui-field-ae-title = AE title
tui-field-bind-addr = Địa chỉ bind
tui-field-date-from = Từ ngày
tui-field-date-to = Đến ngày
tui-field-destination-node = Destination nút
tui-field-host = Máy chủ
tui-field-instance-uid = Instance UID
tui-field-kind = Loại
tui-field-level = Mức
tui-field-local-ae = AE cục bộ
tui-field-max-pdu = Max PDU
tui-field-modality = bộ phận
tui-field-model = Mô hình
tui-field-move-destination = Đích chuyển
tui-field-name = Tên
tui-field-notes = Ghi chú
tui-field-path = Đường dẫn
tui-field-patient-id = ID bệnh nhân
tui-field-patient-name = Tên bệnh nhân
tui-field-port = Cổng
tui-field-promiscuous = Không hạn chế AE
tui-field-series-uid = Series UID
tui-field-sop-uid = SOP Instance UID
tui-field-strict-pdu = PDU nghiêm
tui-field-study-description = Mô tả ca khám
tui-field-study-uid = Study UID
tui-footer-back-series = Esc về chuỗi
tui-footer-back-studies = Esc về ca khám
tui-footer-cancel-task = c hủy
tui-footer-edit-config = c sửa cấu hình
tui-footer-enter-series = Enter chuỗi
tui-footer-esc-series = Esc về chuỗi
tui-footer-esc-studies = Esc về ca khám
tui-footer-help = F1/? trợ giúp
tui-footer-inspect = Enter kiểm tra
tui-footer-next = Tiếp: { $text }
tui-footer-nodes = a/e/d/f nút
tui-footer-panes = Tab khung
tui-footer-queued =
    { $n ->
        [one] { $n } đang chờ
       *[other] { $n } đang chờ
    }
tui-footer-quit = q thoát
tui-footer-refresh = r làm mới
tui-footer-retrieve = m truy xuất
tui-footer-run-command = Enter chạy lệnh
tui-footer-task-scope = t hàng đợi/lịch sử
tui-form-add-node = Thêm nút từ xa
tui-form-add-remote-node = Thêm nút từ xa
tui-form-delete-confirm = Xóa nút từ xa { $name } [{ $ae }] tại { $host }:{ $port }?
tui-form-delete-node = Xóa Remote Node
tui-form-delete-remote-node = Xóa Remote Node
tui-form-edit-node = Sửa nút từ xa
tui-form-edit-remote-node = Sửa nút từ xa
tui-form-err-ae-required = ! AE title là bắt buộc
tui-form-err-bind-required = ! địa chỉ bind là bắt buộc
tui-form-err-host-required = ! máy chủ là bắt buộc
tui-form-err-local-ae-invalid = ! AE title cục bộ không hợp lệ: { $err }
tui-form-err-local-ae-required = ! AE title cục bộ là bắt buộc
tui-form-err-modality-empty = modality không được để trống
tui-form-err-move-dest-invalid = ! AE title đích chuyển không hợp lệ: { $err }
tui-form-err-name-required = ! nút name is required
tui-form-err-port-required = ! cổng là bắt buộc
tui-form-err-uid-empty = UID không được để trống
tui-form-err-uid-empty-component = UID không được chứa thành phần trống
tui-form-error-line = Lỗi: { $error }
tui-form-field-accession = Số accession
tui-form-field-ae-title = AE title
tui-form-field-bind-addr = Địa chỉ bind
tui-form-field-date-from = Từ ngày
tui-form-field-date-to = Đến ngày
tui-form-field-dest-node = Destination nút
tui-form-field-destination = AE đích
tui-form-field-host = Máy chủ
tui-form-field-instance-uid = SOP Instance UID
tui-form-field-kind = Loại
tui-form-field-level = Mức
tui-form-field-local-ae = AE cục bộ
tui-form-field-modality = bộ phận
tui-form-field-model = Mô hình
tui-form-field-move-dest = Đích chuyển
tui-form-field-name = Tên
tui-form-field-notes = Ghi chú
tui-form-field-path = Đường dẫn
tui-form-field-patient-id = ID bệnh nhân
tui-form-field-patient-name = Tên bệnh nhân
tui-form-field-port = Cổng
tui-form-field-series-uid = Series Instance UID
tui-form-field-sop-uid = SOP Instance UID
tui-form-field-study-desc = Mô tả ca khám
tui-form-field-study-uid = Study Instance UID
tui-form-field-uid = UID
tui-form-hint-bind = gợi ý: thường là 0.0.0.0 (mọi giao diện) hoặc 127.0.0.1
tui-form-hint-local-ae = gợi ý: tối đa 16 ký tự (A-Z, 0-9, khoảng trắng), vd. ARCHIVE_AE
tui-form-hint-move-dest = gợi ý: tùy chọn; ghi đè AE title đích C-MOVE
tui-form-hint-name = gợi ý: nhãn ngắn (vd. PACS)
tui-form-import = Nhập Local Files
tui-form-import-local = Nhập Local Files
tui-form-import-local-files = Nhập Local Files
tui-form-mode-add = create a new nút từ xa
tui-form-mode-edit = update the selected nút từ xa
tui-form-query-node = Truy vấn nút từ xa
tui-form-query-remote-node = Truy vấn nút từ xa
tui-form-remote-node-line = Nút từ xa: { $name } [{ $ae }] { $host }:{ $port }
tui-form-retrieve = Truy xuất kết quả khớp
tui-form-retrieve-matches = Truy xuất kết quả khớp
tui-form-send-series = Send Chuỗi
tui-form-send-study = Gửi ca khám
tui-form-storage-intro = Sửa cài đặt Storage SCP cục bộ (lưu vào config.json).
tui-form-storage-scp = Cài đặt Storage SCP
tui-form-storage-scp-settings = Cài đặt Storage SCP
tui-help-ae-title = AE title: { $value }
tui-help-aedf = a/e/d/f     Add, edit, delete, or query from the selected nút
tui-help-c = c           Sửa cài đặt Storage SCP (khi tiêu điểm ở khung Config)
tui-help-canonical-names = Tên chuẩn khớp cờ CLI không có '--', dùng gạch dưới.
tui-help-close = Đóng trợ giúp bằng Esc, F1 hoặc ?.
tui-help-common-commands = Lệnh thường dùng
tui-help-config = c           Sửa cài đặt Storage SCP (khi tiêu điểm ở khung Config)
tui-help-config-path = Đường dẫn cấu hình: { $value }
tui-help-current-config = Cấu hình hiện tại
tui-help-data-dir = Thư mục dữ liệu: { $value }
tui-help-enter-default = Enter       Run the command input, submit the active modal, or open series from Ca chụp cục bộ
tui-help-enter-instance = Enter       Không có thao tác khung cục bộ trong chế độ xem instance
tui-help-enter-local-instance = Enter       Không có thao tác khung cục bộ trong chế độ xem instance
tui-help-enter-local-series = Enter       Mở instance của chuỗi cục bộ đã chọn, hoặc chạy ô lệnh / gửi modal đang mở
tui-help-enter-local-study = Enter       Mở chuỗi của ca khám cục bộ đã chọn, hoặc chạy ô lệnh / gửi modal đang mở
tui-help-enter-series = Enter       Mở instance của chuỗi cục bộ đã chọn, hoặc chạy ô lệnh / gửi modal đang mở
tui-help-enter-study = Enter       Mở chuỗi của ca khám cục bộ đã chọn, hoặc chạy ô lệnh / gửi modal đang mở
tui-help-esc-default = Esc         Đóng trợ giúp/modal, quay lại từ chuỗi cục bộ, hoặc trả tiêu điểm về ô lệnh
tui-help-esc-instance = Esc         Quay lại chuỗi từ instance cục bộ, đóng trợ giúp/modal, hoặc trả tiêu điểm về ô lệnh
tui-help-esc-instances = Esc         Quay lại chuỗi từ instance cục bộ, đóng trợ giúp/modal, hoặc trả tiêu điểm về ô lệnh
tui-help-esc-series = Esc         Quay lại ca khám từ chuỗi cục bộ, đóng trợ giúp/modal, hoặc trả tiêu điểm về ô lệnh
tui-help-f1 = F1 hoặc ?     Mở trợ giúp
tui-help-import-send = i/s         Nhập local files or send selected study/series
tui-help-is = i/s         Nhập local files or send selected study/series
tui-help-listener = Bộ lắng nghe: { $value }
tui-help-log-dir = Thư mục nhật ký: { $value }
tui-help-m = m           Truy xuất từ kết quả truy vấn đã chọn
tui-help-max-pdu = max_pdu_length: { $value }
tui-help-move = Lên/Xuống hoặc j/k   Di chuyển lựa chọn trong khung danh sách
tui-help-nodes = a/e/d/f     Add, edit, delete, or query from the selected nút
tui-help-open = F1 hoặc ?     Mở trợ giúp
tui-help-promiscuous = allow_promiscuous_storage: { $value }
tui-help-q = q           Thoát khi không có modal và tiêu điểm không ở ô lệnh
tui-help-quit = q           Thoát khi không có modal và tiêu điểm không ở ô lệnh
tui-help-r = r           Làm mới panes when focus is khôngt in command input
tui-help-receiver-mode = Chế độ nhận: { $value }
tui-receiver-mode-on-demand = theo yêu cầu cho retrieve cục bộ
tui-receiver-mode-standalone = độc lập qua storage-scp
tui-help-refresh = r           Làm mới panes when focus is khôngt in command input
tui-help-retrieve = m           Truy xuất từ kết quả truy vấn đã chọn
tui-help-strict-pdu = strict_pdu: { $value }
tui-help-tab = Tab / Shift-Tab  Đổi khung đang chọn
tui-help-title = Phím tắt
tui-help-ts-pref = preferred_store_transfer_syntax: { $value }
tui-help-updown = Lên/Xuống hoặc j/k   Di chuyển lựa chọn trong khung danh sách
tui-input-placeholder = Nhập lệnh hoặc dùng phím tắt khung.
tui-log-command = > { $command }
tui-log-error = lỗi: { $error }
tui-log-refreshed = đã làm mới
tui-logs-capped-suffix = đã cắt
tui-logs-label = Nhật ký:
tui-pane-command = Lệnh
tui-pane-config = Cấu hình
tui-pane-detail = Chi tiết
tui-pane-detail-hint = { $title } (PgUp/PgDn khi không gõ)
tui-pane-help = Trợ giúp
tui-pane-instance-detail = Chi tiết instance
tui-pane-instances-for = Thực thể for: { $uid }
tui-pane-local-studies = Ca chụp cục bộ
tui-pane-logs = Nhật ký ({ $shown }/{ $total }{ $capped })
tui-pane-logs-capped = Nhật ký ({ $shown }/{ $total } capped)
tui-pane-logs-uncapped = Nhật ký ({ $shown }/{ $total })
tui-pane-node-detail = Chi tiết nút
tui-pane-query-detail = Chi tiết kết quả truy vấn
tui-pane-query-node = Truy vấn nút
tui-pane-query-result-detail = Chi tiết kết quả truy vấn
tui-pane-query-results = Truy vấn / lấy về Kết quả
tui-pane-query-retrieve-results = Truy vấn / lấy về Kết quả
tui-pane-remote-nodes = Nút từ xa
tui-pane-series-detail = Chuỗi Detail
tui-pane-series-for = Chuỗi for: { $uid }
tui-pane-series-unknown = Chuỗi for: <ca chụp không rõ>
tui-pane-study-detail = Chi tiết ca khám
tui-pane-task-details = Chi tiết tác vụ
tui-pane-tasks-history = Tác vụ (lịch sử)
tui-pane-tasks-queued = Tác vụ (hàng đợi)
tui-pane-unknown-series = <chuỗi không rõ>
tui-pane-unknown-study = Chuỗi for: <ca chụp không rõ>
tui-row-inst = inst
tui-status-cancel-requested = Hủylation requested
tui-status-config = Cấu hình
tui-status-configured-listener = Listener đã cấu hình { $addr } thành AE { $ae } ({ $mode })
tui-status-data = dữ liệu
tui-status-failure = thất bại: { $failure }
tui-status-listener = bộ lắng nghe
tui-status-local-ae = AE cục bộ
tui-status-mode = Chế độ
tui-status-mode-on-demand = theo yêu cầu
tui-status-mode-standalone = độc lập
tui-status-no-active-task = Không có tác vụ đang chạy to cancel (nothing running)
tui-status-pdu = PDU
tui-status-promiscuous = Không hạn chế AE
tui-status-query-before-retrieve = Query a nút từ xa first so retrieve knows which nút to use
tui-status-query-failed = truy vấn thất bại: { $error }
tui-status-queued-op = Thao tác trong hàng đợi: { $op }
tui-status-retrieve-failed = truy xuất thất bại: { $error }
tui-status-retrieve-open-failed = không thể mở retrieve stream: { $error }
tui-status-saved-node = saved nút { $name } ({ $id })
tui-status-saved-scp = Đã lưu cài đặt Storage SCP (cần khởi động lại)
tui-status-select-node = hãy chọn một nút từ xa trước
tui-status-select-query = hãy chọn một kết quả truy vấn trước
tui-status-select-study = hãy chọn một ca khám cục bộ trước
tui-status-strict = Nghiêm ngặt
tui-status-task-cancelled = Tác vụ đã hủy
tui-status-task-cancelled-detail = Tác vụ đã hủy: { $other }
tui-status-ts-pref = Ưu tiên TS
tui-status-updated-node = updated nút { $name } ({ $id })
tui-suggest-back-series = Esc — về chuỗi
tui-suggest-edit-config = c — sửa cấu hình
tui-suggest-help = F1/? — trợ giúp
tui-suggest-inspect-task = Enter — kiểm tra tác vụ
tui-suggest-node-add = node add <ae-title> <host:port>
tui-suggest-query = f — query a nút
tui-suggest-query-node = f — query selected nút
tui-suggest-retrieve = m — truy xuất mục đã chọn
tui-suggest-run-command = Enter — chạy lệnh
tui-suggest-send-series = s — gửi chuỗi đã chọn
tui-suggest-view-series = Enter — xem chuỗi
tui-task-cancelled = Hủyled
tui-task-cancelling = Hủyling
tui-task-failed = Thất bại
tui-task-failed-generic = Tác vụ thất bại: { $error }
tui-task-import-done = Nhập complete: { $report }
tui-task-import-failed = Nhập thất bại: { $error }
tui-task-importing = Nhậping { $path }...
tui-task-query-done =
    Truy vấn xong: { $count ->
        [one] { $count } kết quả khớp
       *[other] { $count } kết quả khớp
    }
tui-task-query-failed = Truy vấn thất bại: { $error }
tui-task-querying = Đang truy vấn { $node }...
tui-task-queued = Trong hàng đợi
tui-task-retrieve-done = Truy xuất xong: { $outcome }
tui-task-retrieve-failed = Truy xuất thất bại: { $error }
tui-task-retrieving = Đang truy xuất từ { $node }...
tui-task-running = Đang chạy
tui-task-sending-series = Đang gửi chuỗi { $uid } tới { $node }...
tui-task-sending-study = Đang gửi ca khám { $uid } tới { $node }...
tui-task-send-done = Gửi xong: { $outcome }
tui-task-status-cancelled = đã hủy
tui-task-status-cancelling = đang hủy
tui-task-status-failed = thất bại
tui-task-status-ok = ok
tui-task-status-queued = đang chờ
tui-task-status-running = đang chạy
tui-task-succeeded = Thành công
tui-terminal-too-small = Thiết bị đầu cuối quá nhỏ — hãy đổi kích thước

## Desktop
desktop-action-activity = Hoạt động { $count }
desktop-action-activity-empty = Hoạt động
desktop-action-import = Nhập
desktop-action-inspect-archive = Kiểm tra kho lưu trữ cục bộ
desktop-action-inspect-archive-desc = Xem ca khám, chuỗi và phiên bản; rồi gửi hoặc xuất.
desktop-action-manage-peers = Quản lý peer
desktop-action-manage-peers-desc = Thêm và sửa nút PACS hoặc trạm làm việc dùng cho query, retrieve và store.
desktop-action-monitor-scp = Giám sát Storage SCP
desktop-action-query = Truy vấn
desktop-action-refresh = Làm mới trạng thái
desktop-action-refresh-status = Làm mới trạng thái
desktop-action-reveal-log = Hiện tệp nhật ký
desktop-action-send = Gửi
desktop-action-start-scp = Khởi động Storage SCP
desktop-activity-empty = Chưa có hoạt động phiên.
desktop-activity-title = Hoạt động
desktop-app-title = DICOM Node
desktop-archive-csv = CSV
desktop-archive-details = Chi tiết
desktop-archive-empty = Lưu trữ cục bộ trống.
desktop-archive-export-fail = Xuất { $scope } thất bại
desktop-archive-export-ok =
    { $rows ->
        [one] Đã xuất { $rows } hàng { $scope } tới { $path }.
       *[other] Đã xuất { $rows } hàng { $scope } tới { $path }.
    }
desktop-archive-export-studies = Xuất ca khám
desktop-archive-export-title = Xuất { $scope }
desktop-archive-filter = Lọc theo bệnh nhân, UID, mô tả, modality…
desktop-archive-filter-placeholder = Lọc theo bệnh nhân, UID, mô tả, modality…
desktop-archive-inst-abbrev = { $count } inst.
desktop-archive-instance-meta = { $bytes } · TS { $ts } · nhập { $imported }
desktop-archive-instances = Instance
desktop-archive-instances-heading = Instance
desktop-archive-json = JSON
desktop-archive-loading = Đang tải ca khám…
desktop-archive-no-filter-match = Không ca khám nào khớp bộ lọc.
desktop-archive-no-instances = Không tìm thấy instance.
desktop-archive-no-match = Không ca khám nào khớp bộ lọc.
desktop-archive-no-nodes = Không có nút
desktop-archive-no-series = Không tìm thấy series.
desktop-archive-reveal-file = Hiện tệp
desktop-archive-select-series = Chọn một series.
desktop-archive-select-study = Chọn một ca khám.
desktop-archive-send-fail = { $label }: { $sent }/{ $attempted } đã gửi, { $failed } thất bại. { $failures }
desktop-archive-send-fail-title = { $label } thất bại
desktop-archive-send-ok = { $label }: đã gửi { $sent }/{ $attempted } instance.
desktop-archive-send-series = Gửi series
desktop-archive-send-series-label = Chuỗi → { $destination }
desktop-archive-send-study = Gửi ca khám
desktop-archive-send-study-label = Ca khám → { $destination }
desktop-archive-send-to = Gửi tới
desktop-archive-series = Chuỗi
desktop-archive-series-count =
    #{ $number } · { $count ->
        [one] { $count } instance
       *[other] { $count } instance
    }
desktop-archive-series-fallback = Chuỗi
desktop-archive-studies = Ca khám
desktop-archive-study-date = Ngày khám
desktop-archive-study-uid = Study UID
desktop-archive-subtitle = Danh mục ca khám, series và instance từ lưu trữ SQLite cục bộ.
desktop-archive-title = Lưu trữ cục bộ
desktop-brand-title = DICOM Node
desktop-col-description = Mô tả
desktop-col-instances = Instance
desktop-col-modalities = Mô thức
desktop-col-patient-id = ID bệnh nhân
desktop-common-cancel = Hủy
desktop-common-clear = Xóa
desktop-common-disabled = tắt
desktop-common-enabled = bật
desktop-common-loading = Đang tải…
desktop-common-no = không
desktop-common-refresh = Làm mới
desktop-common-yes = có
desktop-counter-assoc-accepted = Liên kết đã chấp nhận
desktop-counter-bytes-ingested = Byte đã nhận
desktop-counter-cfind-requests = Yêu cầu C-FIND
desktop-counter-cmove-requests = Yêu cầu C-MOVE
desktop-counter-cstore-failed = C-STORE thất bại
desktop-counter-cstore-stored = C-STORE đã lưu
desktop-dashboard-counter-assoc-accepted = Liên kết đã chấp nhận
desktop-dashboard-counter-bytes-ingested = Byte đã nhận
desktop-dashboard-counter-c-find-requests = Yêu cầu C-FIND
desktop-dashboard-counter-c-move-requests = Yêu cầu C-MOVE
desktop-dashboard-counter-c-store-failed = C-STORE thất bại
desktop-dashboard-counter-c-store-stored = C-STORE đã lưu
desktop-dashboard-empty-studies = Chưa có ca khám cục bộ.
desktop-dashboard-inspect-archive-body = Xem ca khám, đi vào series và instance, rồi gửi hoặc xuất.
desktop-dashboard-inspect-archive-title = Xem lưu trữ cục bộ
desktop-dashboard-kv-ae-title = AE Title
desktop-dashboard-kv-data-dir = Thư mục dữ liệu
desktop-dashboard-kv-listener = bộ lắng nghe
desktop-dashboard-kv-log-file = Tệp nhật ký
desktop-dashboard-kv-max-pdu = PDU tối đa
desktop-dashboard-kv-promiscuous = Lưu trữ không hạn chế
desktop-dashboard-kv-server = Máy chủ
desktop-dashboard-kv-store-syntax = Cú pháp store
desktop-dashboard-kv-strict-pdu = PDU nghiêm ngặt
desktop-dashboard-listener-missing = Listener chưa được tải.
desktop-dashboard-live-counters = Bộ đếm trực tiếp
desktop-dashboard-loading-metrics = Đang tải số liệu…
desktop-dashboard-loading-status = Đang tải trạng thái cục bộ…
desktop-dashboard-loading-studies = Đang tải ca khám…
desktop-dashboard-local-node = Nút cục bộ
desktop-dashboard-manage-peers-body = Thêm và sửa nút PACS hoặc trạm dùng cho truy vấn, lấy và store.
desktop-dashboard-manage-peers-title = Quản lý nút ngang hàng
desktop-dashboard-metric-instances = Instance
desktop-dashboard-metric-nodes = Nút từ xa
desktop-dashboard-metric-series = Chuỗi
desktop-dashboard-metric-studies = Ca khám
desktop-dashboard-monitor-scp = Giám sát Storage SCP
desktop-dashboard-recent-studies = Ca khám gần đây
desktop-dashboard-start-scp = Khởi động Storage SCP
desktop-dashboard-subtitle = Lưu trữ cục bộ, nút mạng và hoạt động SCP trong một nhìn.
desktop-dashboard-title = Bảng điều khiển vận hành
desktop-doc-title = DICOM Node
desktop-import-accepted = Đã chấp nhận
desktop-import-accepted-bytes = Byte đã chấp nhận
desktop-import-activity-detail = { $accepted }/{ $scanned } chấp nhận, { $duplicates } trùng, { $bytes }
desktop-import-activity-fail = Nhập thất bại
desktop-import-activity-ok = Nhập xong
desktop-import-choose-archive = Chọn tệp ZIP để nhập
desktop-import-choose-dir = Chọn thư mục để nhập
desktop-import-choose-folder = Thư mục
desktop-import-choose-zip = Chọn tệp ZIP để nhập
desktop-import-cleanup = Dọn dẹp
desktop-import-clear-path = Xóa đường dẫn
desktop-import-complete = Nhập xong
desktop-import-dup-sha = SHA-256
desktop-import-dup-sop = SOP UID
desktop-import-dup-total = Tổng
desktop-import-duplicates = Trùng
desktop-import-failed = Nhập thất bại
desktop-import-failed-cleanup = Dọn dẹp thất bại
desktop-import-failures = Thất bại
desktop-import-failures-heading =
    { $count ->
        [one] { $count } lỗi:
       *[other] { $count } lỗi:
    }
desktop-import-failures-more = … và thêm { $count }
desktop-import-files-progress = { $label } tệp
desktop-import-folder = Thư mục
desktop-import-invalid-dicom = DICOM không hợp lệ
desktop-import-pick-dir = Chọn thư mục để nhập
desktop-import-pick-zip = Chọn tệp ZIP để nhập
desktop-import-placeholder = /path/to/dicom-folder or /path/to/archive.zip
desktop-import-rejected = Từ chối
desktop-import-report = Báo cáo nhập
desktop-import-running = Đang nhập…
desktop-import-scanned = Đã quét
desktop-import-skipped = Bỏ qua
desktop-import-source = Nguồn
desktop-import-start = Bắt đầu nhập
desktop-import-stored = Đã lưu
desktop-import-subtitle = Lập chỉ mục tệp DICOM từ thư mục đệ quy hoặc ZIP vào lưu trữ cục bộ được quản lý.
desktop-import-title = Nhập
desktop-import-unreadable = Không đọc được
desktop-import-zip = ZIP
desktop-import-zip-filter = Tệp ZIP
desktop-lang-label = Ngôn ngữ
desktop-listener-not-loaded = Listener chưa được tải.
desktop-live-counters = Bộ đếm trực tiếp
desktop-loading = Đang tải
desktop-loading-local-status = Đang tải trạng thái cục bộ…
desktop-loading-metrics = Đang tải số liệu…
desktop-loading-studies = Đang tải ca khám…
desktop-local-node = Nút cục bộ
desktop-locale-label = Ngôn ngữ
desktop-logs-activity-detail =
    { $count ->
        [one] Đã tải { $count } dòng
       *[other] Đã tải { $count } dòng
    }
desktop-logs-activity-fail = Làm mới nhật ký thất bại
desktop-logs-activity-ok = Đã làm mới nhật ký
desktop-logs-auto = TỰ ĐỘNG
desktop-logs-auto-refresh = Tự làm mới
desktop-logs-empty = Tệp nhật ký trống.
desktop-logs-found = ĐÃ TÌM THẤY TỆP NHẬT KÝ
desktop-logs-lines =
    { $count ->
        [one] { $count } dòng
       *[other] { $count } dòng
    }
desktop-logs-loading = Đang tải nhật ký…
desktop-logs-missing = Tệp nhật ký hiện tại chưa được tạo.
desktop-logs-refresh-failed = Làm mới nhật ký thất bại
desktop-logs-refreshed = Đã làm mới nhật ký
desktop-logs-reveal = Hiện
desktop-logs-subtitle = Phần đuôi giới hạn của tệp nhật ký máy tính.
desktop-logs-tail = Đuôi
desktop-logs-title = Nhật ký
desktop-logs-truncated = CẮT
desktop-logs-waiting = ĐANG CHỜ TỆP NHẬT KÝ
desktop-metric-instances = Instance
desktop-metric-remote-nodes = Nút từ xa
desktop-metric-series = Chuỗi
desktop-metric-studies = Ca khám
desktop-nav-archive = Lưu trữ cục bộ
desktop-nav-dashboard = Bảng điều khiển
desktop-nav-import = Nhập
desktop-nav-logs = Nhật ký
desktop-nav-network = Mạng
desktop-nav-nodes = Nút từ xa
desktop-nav-query = Truy vấn / lấy
desktop-nav-server = Máy chủ lưu trữ
desktop-no-local-studies = Chưa có ca khám cục bộ.
desktop-nodes-add = Thêm nút
desktop-nodes-added = Đã thêm nút "{ $name }".
desktop-nodes-ae-length = AE Title tối đa 16 ký tự.
desktop-nodes-ae-title = AE Title
desktop-nodes-col-move = Đích Move
desktop-nodes-configured = Nút đã cấu hình
desktop-nodes-confirm-delete = Xóa nút "{ $name }"?
desktop-nodes-default-port = Cổng mặc định 104
desktop-nodes-delete = Xóa nút
desktop-nodes-delete-title = Xóa nút
desktop-nodes-deleted = Đã xóa nút "{ $name }".
desktop-nodes-edit = Sửa nút
desktop-nodes-edit-title = Sửa nút
desktop-nodes-empty = Chưa có nút từ xa.
desktop-nodes-err-ae = AE title là bắt buộc.
desktop-nodes-err-ae-len = AE title tối đa 16 ký tự.
desktop-nodes-err-host = Host là bắt buộc.
desktop-nodes-err-name = Tên là bắt buộc.
desktop-nodes-err-port = Cổng phải từ 1 đến 65535.
desktop-nodes-host = Máy chủ
desktop-nodes-move-dest = Đích Move
desktop-nodes-move-placeholder = Mặc định: AE cục bộ
desktop-nodes-name = Tên
desktop-nodes-need-ae = AE Title là bắt buộc.
desktop-nodes-need-host = Máy chủ là bắt buộc.
desktop-nodes-need-name = Tên là bắt buộc.
desktop-nodes-notes = Ghi chú
desktop-nodes-notes-placeholder = PACS phòng đọc
desktop-nodes-placeholder-ae = PACS01
desktop-nodes-placeholder-host = 192.168.0.10
desktop-nodes-placeholder-move = Mặc định: AE cục bộ
desktop-nodes-placeholder-name = main-pacs
desktop-nodes-placeholder-notes = PACS phòng đọc
desktop-nodes-port = Cổng
desktop-nodes-port-104 = Cổng mặc định 104
desktop-nodes-port-range = Cổng phải từ 1 đến 65535.
desktop-nodes-save = Lưu thay đổi
desktop-nodes-save-changes = Lưu thay đổi
desktop-nodes-subtitle = Nút PACS và trạm cho truy vấn, lấy và store.
desktop-nodes-summary = Tóm tắt nút
desktop-nodes-title = Nút từ xa
desktop-nodes-total = Tổng số nút
desktop-nodes-updated = Đã cập nhật nút "{ $name }".
desktop-nodes-with-move = Có đích Move
desktop-promiscuous = Lưu trữ không hạn chế
desktop-query-accession = Accession số
desktop-query-activity-detail = { $count } { $count ->
        [one] khớp
       *[other] khớp
    } ở mức { $level }
desktop-query-activity-fail = C-FIND { $node } thất bại
desktop-query-activity-ok = C-FIND { $node }
desktop-query-activity-title = C-FIND { $node }
desktop-query-clear = Xóa
desktop-query-col-accession = số tiếp nhận
desktop-query-criteria = Tiêu chí tìm
desktop-query-date-from = Ngày khám từ
desktop-query-date-to = Ngày khám đến
desktop-query-kv-series-uid = Series UID
desktop-query-kv-sop-uid = SOP UID
desktop-query-kv-study-uid = Study UID
desktop-query-level = Mức
desktop-query-matches =
    { $count ->
        [one] { $count } khớp
       *[other] { $count } khớp
    }
desktop-query-missing-study-uid = Khớp không có StudyInstanceUID; không thể lấy.
desktop-query-modality = bộ phận
desktop-query-no-matches = Không khớp.
desktop-query-no-nodes = Chưa cấu hình nút
desktop-query-patient-id = ID bệnh nhân
desktop-query-patient-name = Tên bệnh nhân
desktop-query-placeholder-description = CHEST*
desktop-query-placeholder-modality = CT, MR, …
desktop-query-placeholder-name = DOE^JOHN or DOE*
desktop-query-placeholder-patient = DOE^JOHN or DOE*
desktop-query-querying = Đang truy vấn…
desktop-query-remote-node = Nút từ xa
desktop-query-results = Kết quả
desktop-query-retrieve = Lấy
desktop-query-retrieve-activity-detail = completed={ $completed }, warning={ $warning }, failed={ $failed }
desktop-query-retrieve-activity-fail = C-MOVE { $node } thất bại
desktop-query-retrieve-activity-ok = C-MOVE { $node }
desktop-query-retrieve-finished = Lấy xong: hoàn tất { $completed }, cảnh báo { $warning }, thất bại { $failed }.
desktop-query-retrieve-selected = Lấy mục đã chọn
desktop-query-run = Chạy C-FIND
desktop-query-run-select = Chạy truy vấn và chọn một khớp.
desktop-query-running = Đang truy vấn…
desktop-query-search-criteria = Tiêu chí tìm
desktop-query-select-hint = Chạy truy vấn và chọn một khớp.
desktop-query-selected = Khớp đã chọn
desktop-query-selected-match = Khớp đã chọn
desktop-query-series-uid = Series Instance UID
desktop-query-sop-uid = SOP Instance UID
desktop-query-study-description = Mô tả ca khám
desktop-query-study-uid = Study Instance UID
desktop-query-subtitle = C-FIND tới nút từ xa, kiểm tra khớp, rồi C-MOVE vào lưu trữ cục bộ.
desktop-query-title = Truy vấn / lấy
desktop-recent-studies = Ca khám gần đây
desktop-scp-listening = SCP đang nghe
desktop-scp-stopped = SCP đã dừng
desktop-server-activity-fail = Điều khiển Storage SCP thất bại
desktop-server-activity-started = Storage SCP đã khởi động
desktop-server-activity-started-detail = Listener đã khởi động.
desktop-server-activity-stopped = Storage SCP đã dừng
desktop-server-activity-stopped-detail = received={ $received }, stored={ $stored }, failed={ $failed }
desktop-server-activity-stopped-empty = Không có phiên hoạt động.
desktop-server-addr-ae = { $addr } · AE { $ae }
desktop-server-assoc-accepted = Liên kết đã chấp nhận
desktop-server-assoc-rejected = Liên kết bị từ chối
desktop-server-cfind-req-matches = Yêu cầu / khớp C-FIND
desktop-server-cget-requests = Yêu cầu C-GET
desktop-server-cmove-requests = Yêu cầu C-MOVE
desktop-server-cmove-subops = Thao tác con C-MOVE hoàn tất / thất bại
desktop-server-control-failed = Điều khiển Storage SCP thất bại
desktop-server-counter-bytes = Byte đã nhận
desktop-server-counter-failed = C-STORE thất bại
desktop-server-counter-find = Yêu cầu / khớp C-FIND
desktop-server-counter-get = Yêu cầu C-GET
desktop-server-counter-move = Yêu cầu C-MOVE
desktop-server-counter-move-sub = Thao tác con C-MOVE hoàn tất / thất bại
desktop-server-counter-received = C-STORE đã nhận
desktop-server-counter-stored = C-STORE đã lưu
desktop-server-cstore-failed = C-STORE thất bại
desktop-server-cstore-received = C-STORE đã nhận
desktop-server-cstore-stored = C-STORE đã lưu
desktop-server-dimse = Bộ đếm DIMSE
desktop-server-failed = Thất bại
desktop-server-health-loading = Đang tải số liệu
desktop-server-health-ready = Sẵn sàng nhận C-STORE
desktop-server-health-review = Xem thất bại
desktop-server-health-stopped = Đã dừng
desktop-server-listener-started = Listener đã khởi động.
desktop-server-listening = ĐANG NGHE
desktop-server-loading-metrics = Đang tải số liệu…
desktop-server-logs = Nhật ký
desktop-server-no-session = Không có phiên hoạt động.
desktop-server-rate = +{ $rate } / thăm dò
desktop-server-ready = Sẵn sàng nhận C-STORE
desktop-server-review-failures = Xem thất bại
desktop-server-session-ended = Phiên kết thúc: nhận { $received }, lưu { $stored }, thất bại { $failed }.
desktop-server-start = Khởi động máy chủ
desktop-server-started-title = Storage SCP đã khởi động
desktop-server-stop = Dừng máy chủ
desktop-server-stopped = ĐÃ DỪNG
desktop-server-stopped-pill = ĐÃ DỪNG
desktop-server-stopped-status = Đã dừng
desktop-server-stopped-title = Storage SCP đã dừng
desktop-server-stored = Đã lưu
desktop-server-subtitle = Storage SCP độc lập cho C-STORE đến và lập chỉ mục lưu trữ cục bộ.
desktop-server-title = Máy chủ lưu trữ
desktop-status-listening = đang nghe
desktop-status-loading = Đang tải
desktop-status-scp-listening = SCP đang nghe
desktop-status-scp-stopped = SCP đã dừng
desktop-status-stopped = đã dừng
desktop-store-syntax = Cú pháp store
desktop-strict-pdu = PDU nghiêm ngặt
desktop-strip-pdu = PDU { $value }
desktop-table-accession = Số accession
desktop-table-ae-title = Tiêu đề AE
desktop-table-date = Ngày
desktop-table-description = Mô tả
desktop-table-endpoint = Điểm cuối
desktop-table-instances = Instance
desktop-table-modalities = Mô thức
desktop-table-modality = bộ phận
desktop-table-move-dest = Đích Move
desktop-table-name = Tên
desktop-table-notes = Ghi chú
desktop-table-patient = Bệnh nhân
desktop-table-patient-id = ID bệnh nhân
desktop-table-series = Chuỗi
desktop-table-updated = Đã cập nhật
desktop-title-refresh-status = Làm mới trạng thái
desktop-title-reveal-log = Hiện tệp nhật ký
ae = AE
patient-name =
    "DOE^JOHN"
    Nhấn 'm' trên kết quả đã chọn để mở retrieve.
port = Cổng

## Summary
summary-ae = AE
summary-counts = Số liệu
summary-criteria = Tiêu chí
summary-duration = Thời lượng
summary-duration-ms = { $ms }ms
summary-failures = Thất bại:
summary-kind = Loại
summary-logs = Nhật ký:
summary-peer = Nút đối tác
summary-status = Trạng thái
summary-title = Tóm tắt thao tác
tui-detail-created = Đã tạo

tui-form-hint-port-range = gợi ý: số từ 1 đến 65535, vd. 104
tui-form-hint-promiscuous = gợi ý: cho phép lưu từ mọi AE title gọi đến
tui-form-hint-strict-pdu = gợi ý: bắt buộc kiểm tra kích thước PDU trong association
tui-form-hint-max-pdu-bytes = gợi ý: byte, vd. 16384
tui-form-limits-heading = Limits (bytes; blank/không = unlimited):
tui-form-field-max-file-import = Tối đa byte nhập tệp
tui-form-field-max-zip-entry = Tối đa byte mục ZIP
tui-form-field-max-zip-total = Tối đa tổng byte ZIP
tui-form-field-max-zip-count = Tối đa số mục ZIP
tui-form-field-max-store-object = Tối đa byte đối tượng store
tui-form-unlimited = không giới hạn
tui-form-err-max-pdu-required = ! độ dài PDU tối đa là bắt buộc
tui-form-err-max-pdu-gt-zero = ! độ dài PDU tối đa phải là số nguyên lớn hơn 0
tui-form-err-limit-gt-zero = ! { $label } phải là số nguyên lớn hơn 0
tui-form-controls-scp = Gõ để sửa. Space bật/tắt hộp kiểm. Tab/Shift-Tab hoặc Lên/Xuống chuyển trường. Enter lưu. Esc hủy.
tui-form-submit-uid-required = UID là bắt buộc
tui-form-submit-dest-required = destination nút is required
tui-form-submit-nonneg-int = { $label } phải là số nguyên không âm
tui-form-submit-gt-zero = { $label } phải lớn hơn 0
tui-form-submit-local-ae-required = AE title cục bộ là bắt buộc
tui-form-submit-local-ae-invalid = AE title cục bộ không hợp lệ: { $err }
tui-form-submit-bind-required = địa chỉ bind là bắt buộc
tui-form-submit-port-required = cổng là bắt buộc
tui-form-submit-max-pdu-required = độ dài PDU tối đa là bắt buộc
tui-form-submit-max-pdu-int = độ dài PDU tối đa phải là số nguyên
tui-form-submit-max-pdu-gt-zero = độ dài PDU tối đa phải lớn hơn 0
tui-form-submit-patient-retrieve = truy xuất cấp bệnh nhân không được hỗ trợ
tui-form-submit-no-study-uid = kết quả đã chọn không có study UID
tui-form-submit-date-format = cần YYYYMMDD
tui-form-submit-modality-len = modality tối đa 16 ký tự
tui-form-submit-modality-chars = modality phải là A-Z hoặc 0-9
tui-form-submit-name-required = tên nút là bắt buộc
tui-form-submit-ae-required = AE title là bắt buộc
tui-form-submit-host-required = máy chủ là bắt buộc
tui-form-submit-move-dest-invalid = AE title đích chuyển không hợp lệ: { $err }
tui-form-submit-dates-both = phải đặt cả từ ngày và đến ngày, hoặc không đặt cái nào
tui-form-submit-date-from-invalid = từ ngày không hợp lệ: { $err }
tui-form-submit-date-to-invalid = đến ngày không hợp lệ: { $err }
tui-form-submit-date-order = từ ngày phải trước hoặc bằng đến ngày
tui-form-submit-study-uid-series-query = study UID là bắt buộc cho truy vấn cấp chuỗi
tui-form-submit-study-uid-image-query = study UID là bắt buộc cho truy vấn cấp ảnh
tui-form-submit-series-uid-image-query = series UID là bắt buộc cho truy vấn cấp ảnh
tui-form-submit-study-uid-required = study UID là bắt buộc
tui-form-submit-study-uid-invalid = study UID không hợp lệ: { $err }
tui-form-submit-series-uid-series-retrieve = series UID là bắt buộc cho truy xuất cấp chuỗi
tui-form-submit-series-uid-image-retrieve = series UID là bắt buộc cho truy xuất cấp ảnh
tui-form-submit-instance-uid-image-retrieve = instance UID là bắt buộc cho truy xuất cấp ảnh
tui-form-submit-series-uid-invalid = series UID không hợp lệ: { $err }
tui-form-submit-instance-uid-invalid = instance UID không hợp lệ: { $err }
tui-form-submit-import-path-required = đường dẫn nhập là bắt buộc
tui-form-submit-import-path-type = đường dẫn nhập phải là tệp hoặc thư mục: { $path }
tui-form-submit-import-access = đang truy cập đường dẫn nhập { $path }
tui-form-submit-import-open = đang mở tệp nhập { $path }
tui-form-submit-import-read-dir = đang đọc thư mục nhập { $path }
tui-log-welcome = Press F1 or ? for help. Focus Nút từ xas and press 'a' to add one.
tui-log-logging-to = Ghi nhật ký tới { $path }
tui-command-help-heading = lệnh:
tui-command-help-next-1 = ghi chú: chân trang hiện gợi ý 'Next:' theo khung đang chọn và lựa chọn.
tui-command-help-next-2 = Đây chỉ là gợi ý; bạn luôn có thể gõ bất kỳ lệnh nào.
tui-command-help-canonical = ghi chú: tên chuẩn khớp cờ CLI không có '--', dùng gạch dưới.
tui-command-help-cancel = cancel (bí danh: stop)
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
tui-command-help-refresh = làm mới
tui-command-help-quit = thoát
tui-inspect-task = Tác vụ #{ $id }
tui-inspect-status = Trạng thái: { $status }
tui-inspect-description = Mô tả: { $description }
tui-inspect-progress = Tiến độ: { $progress }
tui-inspect-summary = Tóm tắt:
tui-inspect-no-logs = (không có nhật ký)
tui-field-sop-class-uid = SOP Class UID
tui-field-transfer-syntax-uid = Transfer Syntax UID
tui-field-sha256 = SHA-256
tui-status-removed-nodes =
    đã xóa { $count ->
        [one] { $count } nút
       *[other] { $count } nút
    }
tui-status-removed-nodes-target =
    đã xóa { $count ->
        [one] { $count } nút
       *[other] { $count } nút
    }; đích cuối là { $name }
tui-status-more-failures =
    và { $n ->
        [one] { $n } lỗi đã bỏ
       *[other] { $n } lỗi đã bỏ
    }
tui-status-retrieve-ok = retrieve status=0x{ $status } completed={ $completed } failed={ $failed } warning={ $warning } remaining={ $remaining }
tui-status-import-counts = scanned={ $scanned } accepted={ $accepted } duplicates={ $duplicates } unreadable={ $unreadable } invalid_dicom={ $invalid } rejected_total={ $rejected } stored_bytes={ $bytes }
tui-status-send-ok = send attempted={ $attempted } sent={ $sent } failed={ $failed }
tui-log-query-start = Bắt đầu truy vấn tới { $node }
tui-log-retrieve-start = Bắt đầu truy xuất từ { $node }
tui-log-import-start = Bắt đầu nhập { $path }
tui-log-send-study-start = Bắt đầu gửi ca khám { $uid } tới { $node }
tui-log-send-series-start = Bắt đầu gửi chuỗi { $uid } tới { $node }
tui-log-cancelled-before-start = đã hủy trước khi bắt đầu
tui-log-cancelled = đã hủy
error-unknown-command = lệnh không rõ: { $command }
error-node-subcommand-required = cần lệnh con node
error-local-subcommand-required = cần lệnh con local
error-unsupported-node-subcommand = unsupported nút subcommand: { $command }
error-unsupported-local-subcommand = lệnh con local không hỗ trợ: { $command }
error-expected-kv = cần đối số key=value, nhận được { $arg }
error-missing-required-arg = thiếu đối số bắt buộc: { $key }
error-missing-required-arg-one-of = thiếu đối số bắt buộc: một trong { $keys }
error-parsing-command = đang phân tích lệnh
error-edit-form-lost-target = edit form lost its target nút
error-task-already-running = tác vụ nền đã đang chạy
error-task-thread-launch = không khởi động được luồng tác vụ nền: { $error }
error-task-disconnected = luồng tác vụ nền mất kết nối trước khi gửi kết quả
error-task-kind-missing = luồng tác vụ nền mất kết nối nhưng active_task_kind là None: trạng thái bất ngờ
error-serve-exited = serve thoát với lỗi: { $error }
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
summary-title = Tóm tắt thao tác
summary-kind = Loại
summary-status = Trạng thái
summary-duration = Thời lượng
summary-duration-ms = { $ms }ms
summary-peer = Nút đối tác
summary-ae = AE
summary-criteria = Tiêu chí
summary-counts = Số liệu
summary-failures = Thất bại:
summary-logs = Nhật ký:
summary-unserializable = <không tuần tự hóa được>
summary-log-lines = dòng { $start }-{ $end }
