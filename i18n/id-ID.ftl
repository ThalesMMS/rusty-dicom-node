# Fluent catalog (id-ID). Message IDs are hyphenated identifiers
# (cli-about, tui-pane-remote-nodes, desktop-nav-dashboard, error-import-file-too-large).
# Dotted names are Fluent attributes (message + .attr), not message IDs.
# Do not translate DICOM tokens (C-FIND, C-MOVE, C-STORE, SOP, AE, UID) or JSON/CSV machine keys.


## CLI
cli-about = Klien node DICOM berbasis terminal yang dibangun dengan dicom-rs
cli-arg-accession-number = Filter menurut nomor aksesi (substring tanpa membedakan huruf).
cli-arg-ae-title = Application Entity title
cli-arg-destination-node = Nama atau id node tujuan
cli-arg-duplicate = Filter menurut status duplikat.
cli-arg-export = Ekspor hasil sebagai JSON atau CSV.
cli-arg-host = Nama host atau IP
cli-arg-imported-at =
    Filter menurut stempel waktu impor. Mendukung VALUE, START..END, ..END, START..
    Perbandingan leksikografis (format disarankan: RFC3339).
cli-arg-json = Keluarkan ringkasan operasi akhir sebagai JSON (skema stabil).
cli-arg-level = Level kueri/pengambilan
cli-arg-metrics-json = Cetak snapshot metrik memori terakhir sebagai JSON saat server keluar.
cli-arg-modality = Filter menurut modalitas. Daftar dipisah koma (mis. CT,MR).
cli-arg-model = Model informasi kueri/pengambilan
cli-arg-move-destination = AE title tujuan C-MOVE yang diutamakan
cli-arg-name = Nama tampilan untuk node
cli-arg-node = Nama atau id node tersimpan
cli-arg-notes = Catatan bebas
cli-arg-out = Jalur berkas keluaran. Jika diabaikan, menulis ke stdout.
cli-arg-path = Berkas atau direktori yang akan diimpor
cli-arg-patient-id = Filter menurut ID pasien (substring tanpa membedakan huruf).
cli-arg-patient-name = Filter menurut nama pasien (substring tanpa membedakan huruf).
cli-arg-port = nomor port
cli-arg-series-description = Filter menurut deskripsi seri (substring tanpa membedakan huruf).
cli-arg-series-instance-uid = Series Instance UID
cli-arg-sop-instance-uid = SOP Instance UID
cli-arg-source-path = Filter menurut jalur sumber (substring tanpa membedakan huruf).
cli-arg-study-date =
    Filter menurut tanggal studi. Mendukung VALUE, START..END, ..END, START..
    Tanggal dibandingkan secara leksikografis (format disarankan: YYYYMMDD).
cli-arg-study-date-from = Batas bawah tanggal studi (YYYYMMDD)
cli-arg-study-date-to = Batas atas tanggal studi (YYYYMMDD)
cli-arg-study-description = Filter menurut deskripsi studi (substring tanpa membedakan huruf).
cli-arg-study-instance-uid = Study Instance UID
cli-cmd-import-about = Impor berkas DICOM dari sebuah jalur
cli-cmd-local-about = Periksa arsip lokal
cli-cmd-local-series-about = Daftar seri terindeks untuk sebuah studi
cli-cmd-local-studies-about = Daftar studi lokal terindeks
cli-cmd-node-about = Kelola node DICOM jarak jauh tersimpan
cli-cmd-node-add-about = Tambah node jarak jauh
cli-cmd-node-delete-about = Hapus node tersimpan
cli-cmd-node-edit-about = Edit node tersimpan
cli-cmd-node-list-about = Daftar node tersimpan
cli-cmd-query-about = Kueri node jarak jauh (C-FIND)
cli-cmd-retrieve-about = Ambil dari node jarak jauh (C-MOVE)
cli-cmd-send-about = Kirim studi atau seri lokal (C-STORE)
cli-cmd-send-series-about = Kirim sebuah seri ke node tujuan
cli-cmd-send-study-about = Kirim sebuah studi ke node tujuan
cli-cmd-serve-about = Jalankan server DICOM
cli-cmd-storage-scp-about = Jalankan listener Storage SCP
cli-cmd-tui-about = Buka UI terminal interaktif
cli-flag-help = Tampilkan bantuan
cli-flag-lang = Bahasa UI (tag BCP-47). Menggantikan DICOM_NODE_LANG dan locale OS.
cli-flag-version = Tampilkan versi
cli-heading-arguments = Argumen:
cli-heading-commands = Perintah:
cli-heading-options = Opsi:
cli-heading-usage = Penggunaan:
cli-import-accepted = accepted={ $n }
cli-import-complete = Impor complete
cli-import-duplicates = duplicates={ $n }
cli-import-scanned = scanned={ $n }
cli-msg-cancel-sigint = Pembatalan diminta (SIGINT). Menunggu penghentian yang rapi...
cli-msg-failures = failures:
cli-msg-import-failed = Impor gagal: { $error }
cli-msg-no-local-series = Tidak ada seri terindeks untuk studi { $uid }
cli-msg-no-local-studies = Tidak ada studi lokal terindeks
cli-msg-no-saved-nodes = Tidak ada node tersimpan
cli-msg-query-failed = Query gagal: { $error }
cli-msg-removed-nodes =
    Menghapus { $count ->
        [one] { $count } node
       *[other] { $count } node
    }
cli-msg-results-count =
    Hasil: { $count ->
        [one] { $count } cocokan
       *[other] { $count } cocokan
    }
cli-msg-retrieve-failed = Retrieve gagal: { $error }
cli-msg-saved-node = Node disimpan { $name } [{ $id }] => { $ae }@{ $host }:{ $port }
cli-msg-send-failed = Kirim gagal: { $error }
cli-msg-showing-failures = (menampilkan { $shown } pertama dari { $total } kegagalan)
cli-msg-starting-server =
    Memulai server DICOM dengan { $count ->
        [one] { $count } AE lokal
       *[other] { $count } AE lokal
    }: { $aes }
cli-msg-starting-server-no-aes = Memulai server DICOM tanpa AE lokal terkonfigurasi
cli-msg-starting-storage-scp = Memulai storage SCP di { $addr } dengan AE title { $ae }
cli-msg-updated-node = Node diperbarui { $name } [{ $id }] => { $ae }@{ $host }:{ $port }
cli-send-attempted = attempted={ $n }
cli-send-failed-count = failed={ $n }
cli-send-sent = sent={ $n }
cli-value-name-file = FILE
cli-value-name-format = FORMAT
cli-value-name-locale = LOCALE
cli-value-name-path = PATH
tui-detail-more-series =
    ... { $n ->
        [one] { $n } series lagi
       *[other] { $n } series lagi
    }
tui-row-instance-count =
    { $n ->
        *[other] { $n } instans
    }
tui-row-study-counts = { $series }s/{ $instances }i
count-nodes =
    { $n ->
        [one] { $n } node
       *[other] { $n } node
    }
count-instances =
    { $n ->
        [one] { $n } instans
       *[other] { $n } instans
    }
count-series =
    { $n ->
        *[other] { $n } seri
    }
count-studies =
    { $n ->
        [one] { $n } studi
       *[other] { $n } studi
    }
format-datetime = { $date } { $time }
format-date = { $day }/{ $month }/{ $year }

## Common
common-accession = Aksesi
common-add = Tambah
common-back = Kembali
common-bytes = Byte
common-cancel = Batal
common-clear = Hapus
common-close = Tutup
common-date = Tanggal
common-delete = Hapus node
common-description = Deskripsi
common-disabled = dinonaktifkan
common-duplicates = Duplikat
common-edit = ubah
common-enabled = diaktifkan
common-error = Kesalahan
common-filter = penyaring
common-host = nama host
common-import = Impor
common-instance = Instans
common-language = Bahasa
common-loading = Memuat
common-matches = Cocokan
common-modality = Modalitas
common-name = Nama
common-network = Jaringan
common-no = tidak
common-none = tidak ada
common-notes = Catatan
common-optional = opsional
common-path = Sumber
common-patient = Pasien
common-patient-id = ID pasien
common-patient-name = Nama pasien
common-port = nomor port
common-query = Kueri
common-refresh = Segarkan
common-required = wajib
common-retrieve = Ambil
common-save = Simpan
common-search = Cari
common-send = Kirim
common-series = Seri
common-start = Mulai
common-status = keadaan
common-stop = Berhenti
common-studies = Studi
common-study = Studi
common-unknown = tidak dikenal
common-unknown-series = <Series>
common-unknown-study = <Studi>
common-yes = ya

## Errors
error-ae-empty = AE title tidak boleh kosong
error-ae-invalid-char = AE title berisi karakter tidak valid '{ $character }'; diizinkan: A-Z, 0-9, spasi
error-ae-required = AE title wajib
error-ae-too-long = AE title paling banyak 16 karakter
error-ae-whitespace = AE title tidak boleh punya spasi di awal atau akhir
error-archive-patient-retrieve-out-of-scope = retrieve tingkat Patient di luar cakupan
error-archive-retrieve-uid-required = { $name } wajib untuk tingkat retrieve ini
error-archive-study-root-patient-query = kueri Study Root tidak mendukung tingkat Patient
error-archive-study-root-patient-retrieve = retrieve Study Root tidak mendukung tingkat Patient
error-assoc-negotiation-failed = negosiasi asosiasi gagal dengan { $name } ({ $addr }); petunjuk: verifikasi called AE title, presentation contexts/transfer syntaxes, dan bahwa peer menerima asosiasi
error-assoc-no-addresses = tidak ada alamat soket yang terurai untuk { $name } di { $host }:{ $port }
error-assoc-receive = penerimaan asosiasi
error-assoc-resolving = mengurai { $name } di { $host }:{ $port }: { $err }
error-assoc-timeout = timeout menunggu respons DIMSE; petunjuk: periksa konektivitas jaringan, AE title/host/port, dan responsivitas peer
error-assoc-transport = interupsi transport saat menunggu respons DIMSE; petunjuk: peer menutup koneksi atau middlebox jaringan meresetnya
error-assoc-unreachable = tidak dapat menjangkau { $name } [{ $ae }] di { $host }:{ $port } dalam { $seconds }s: { $err }. Periksa host/IP, port, dan jangkauan jaringan
error-cancel-sigint = Pembatalan diminta (SIGINT). Menunggu penghentian yang rapi...
error-config-must-be-positive = konfigurasi tidak valid: { $name } harus > 0 (atau null untuk menonaktifkan)
error-config-duplicate-bind-port = konfigurasi tidak valid: port bind AE lokal duplikat { $port }
error-config-local-ae-max-assoc = konfigurasi tidak valid: AE lokal { $title } max_concurrent_associations harus > 0
error-config-local-ae-no-services = konfigurasi tidak valid: AE lokal { $title } harus mengaktifkan setidaknya satu layanan
error-config-must-be-positive-required = konfigurasi tidak valid: { $name } harus > 0
error-dicom-meta-incomplete = meta berkas DICOM tidak lengkap
error-dicom-patient-move-unsupported = C-MOVE tingkat pasien tidak didukung oleh scaffold klien ini
error-dicom-required-attribute = atribut DICOM wajib hilang: ({ $group },{ $element })
error-dicom-series-uid-required-image = series_instance_uid wajib untuk pengambilan tingkat citra
error-dicom-series-uid-required-series = series_instance_uid wajib untuk pengambilan tingkat seri
error-dicom-sop-uid-required-image = sop_instance_uid wajib untuk pengambilan tingkat citra
error-dicom-study-uid-required = study_instance_uid wajib
error-dicom-validating-move = memvalidasi permintaan move
error-export-creating-file = membuat berkas ekspor { $path }: { $err }
error-export-flushing-series-csv = mengosongkan buffer CSV seri: { $err }
error-export-flushing-studies-csv = mengosongkan buffer CSV studi: { $err }
error-export-serializing-series-json = menserialisasi JSON seri: { $err }
error-export-serializing-studies-json = menserialisasi JSON studi: { $err }
error-export-writing-series-csv-header = menulis header CSV seri: { $err }
error-export-writing-series-csv-row = menulis baris CSV seri: { $err }
error-export-writing-studies-csv-header = menulis header CSV studi: { $err }
error-export-writing-studies-csv-row = menulis baris CSV studi: { $err }
error-import-cleanup-failed = { $source }: pembersihan gagal: { $reason }
error-import-corrupt-zip = ZIP rusak: { $details }
error-import-dicom-parse-failed = penguraian DICOM gagal: { $err }
error-import-dicom-validation-failed = validasi DICOM gagal: { $err }
error-import-duplicate-zip-path = ZIP berisi beberapa entri yang menarget '{ $path }'
error-import-file-too-large = berkas terlalu besar: { $details }
error-import-invalid-dicom = DICOM tidak valid: { $details }
error-import-limit-exceeded = { $limit } terlampaui: { $details }
error-import-not-regular-file = bukan berkas biasa
error-import-opening-file = membuka berkas: { $err }
error-import-opening-kind = membuka { $kind } { $path }
error-import-opening-staged-file = membuka berkas pementasan: { $err }
error-import-opening-zip-archive = membuka arsip ZIP { $path }
error-import-opening-zip-entry = membuka entri ZIP: { $err }
error-import-opening-zip-file = membuka berkas impor ZIP { $path }
error-import-path-does-not-exist = Jalur impor tidak ada: { $path }
error-import-reading-directory = membaca direktori impor { $path }
error-import-reading-file = membaca berkas: { $err }
error-import-reading-file-metadata = membaca metadata berkas untuk { $path }
error-import-reading-metadata = membaca metadata untuk { $kind } { $path }
error-import-reading-zip-entry = membaca entri ZIP: { $err }
error-import-removing-staged-after-cancel = menghapus berkas pementasan setelah pembatalan { $path }
error-import-skipped = { $source }: dilewati: { $reason }
error-import-unreadable = Berkas tidak dapat dibaca: { $details }
error-import-unsafe-zip-path = jalur entri keluar dari arsip
error-import-zip-entry-count-exceeded = batas jumlah entri ZIP terlampaui: arsip punya { $count } entri, batas { $limit }
error-import-zip-entry-size-exceeded = ukuran entri ZIP { $size } melebihi batas { $limit }
error-import-zip-total-bytes-exceeded = batas total byte ZIP yang diekstrak terlampaui: total saat ini { $current } ditambah ukuran entri { $entry } melebihi batas { $limit }
error-net-binding-storage-scp = mengikat Storage SCP di { $addr } untuk AE { $ae }. Penerima DICOM lokal lain mungkin sudah memakai port itu. Perbarui storage_scp_port/local_aes di { $config } atau hentikan listener yang bentrok
error-net-building-file-meta = membangun tabel file meta
error-net-cannot-send-transfer-syntax = tidak dapat mengirim transfer syntax sumber { $source } dengan yang dinegosiasikan { $negotiated }
error-net-cget-dataset-empty = dataset C-GET C-STORE terenkode kosong
error-net-cget-dataset-odd-length = dataset C-GET C-STORE terenkode berakhir dengan fragmen panjang ganjil
error-net-cget-peer-released = peer melepaskan asosiasi selama C-GET
error-net-cget-store-unexpected-dataset = tak terduga dataset fragment in C-GET C-STORE response
error-net-cget-unexpected-command = tak terduga command 0x{ $command } while waiting for C-STORE-RSP
error-net-cget-unexpected-pdu = tak terduga PDU during C-GET C-STORE suboperation: { $pdu }
error-net-creating-incoming-dir = membuat direktori .incoming Storage SCP
error-net-creating-path = membuat { $path }
error-net-dataset-empty = dataset terenkode kosong tetapi COMMAND_DATA_SET_TYPE menyatakan dataset wajib
error-net-dataset-odd-length = dataset terenkode berakhir dengan fragmen panjang ganjil
error-net-dimse-failed = { $operation } gagal dengan status 0x{ $status } ({ $meaning }){ $hint }
error-net-establishing-assoc = menjalin asosiasi Storage SCP
error-net-file-meta-length = membaca File Meta Information length
error-net-file-meta-tag = membaca File Meta Information tag
error-net-file-meta-value = melewati nilai File Meta Information
error-net-file-meta-vr = membaca File Meta Information VR
error-net-file-position = membaca file position
error-net-flushing-path = mengosongkan { $path }
error-net-flushing-temp-dataset = mengosongkan berkas dataset sementara
error-net-hint-suffix = ; petunjuk: { $hint }
error-net-incomplete-command = tidak lengkap { $operation } command response
error-net-incomplete-identifier = tidak lengkap { $operation } response identifier
error-net-invalid-affected-sop = tidak valid { $operation } affected SOP class UID
error-net-invalid-status = tidak valid { $operation } status
error-net-listener-address = membaca storage SCP listener address
error-net-listener-nonblocking = mengatur mode nonblocking listener
error-net-listener-port = membaca storage SCP listener port
error-net-local-aes-empty = local_aes harus berisi setidaknya satu AE untuk memulai Storage SCP
error-net-locating-dataset = mencari dataset di { $path }
error-net-malformed-dimse = malformed { $operation } DIMSE response: { $details }; petunjuk: peer sent an tidak valid or tak terduga DIMSE command set
error-net-missing-affected-sop = hilang { $operation } affected SOP class UID
error-net-missing-command-field = hilang command field
error-net-missing-cstore-rsp-command-field = hilang C-STORE response command field
error-net-missing-cstore-rsp-status = hilang C-STORE response status
error-net-missing-destination = hilang C-MOVE destination
error-net-missing-dicm = hilang Part 10 DICM marker
error-net-missing-message-id = hilang { $operation } message id
error-net-missing-qr-level = { $operation } identifier is hilang QueryRetrieveLevel
error-net-missing-required-command-field = hilang required command field { $name } ({ $tag })
error-net-missing-status = hilang { $operation } status
error-net-move-destination-unresolved = move_destination tidak terselesaikan
error-net-no-cget-store-context = tidak ada presentation context penyimpanan C-GET yang dinegosiasikan untuk SOP Class { $sop } dan transfer syntax { $syntax }
error-net-no-compatible-context = { $path }: tidak ada presentation context kompatibel yang dinegosiasikan untuk transfer syntax sumber { $syntax }
error-net-no-dimse-provider = tidak ada penyedia DIMSE terdaftar untuk perintah 0x{ $command } dan abstract syntax { $syntax }
error-net-no-presentation-context = tidak ada presentation context yang dinegosiasikan
error-net-no-presentation-context-for-file = { $path }: tidak ada presentation context yang dinegosiasikan
error-net-no-presentation-context-id = hilang negotiated presentation context { $id }
error-net-opening-path = membuka { $path }
error-net-part10-preamble = membaca Part 10 preamble
error-net-path-error = { $path }: { $err }
error-net-pdata-feed-complete = cannot feed P-DATA fragment into a complete accumulator (hilang take())
error-net-peer-aborted = peer membatalkan asosiasi selama suboperasi C-GET C-STORE: { $source }
error-net-peer-socket = membaca storage SCP peer socket address
error-net-reading-command-dataset = membaca command dataset
error-net-reading-identifier = membaca { $operation } identifier
error-net-reading-incoming-dataset = membaca incoming C-STORE dataset
error-net-reading-response-dataset = membaca { $operation } response dataset
error-net-remote-aborted = pihak jarak jauh membatalkan asosiasi: { $source }
error-net-restoring-read-timeout = memulihkan timeout baca association
error-net-restoring-write-timeout = memulihkan timeout tulis association
error-net-rewinding-dataset = menggulung ke elemen dataset pertama
error-net-scp-thread-panicked = utas Storage SCP mengalami panic
error-net-seeking-temp-dataset = seek berkas dataset sementara
error-net-serializing-cget-dataset = menserialkan dataset suboperasi C-GET untuk { $path }
error-net-serializing-dataset = menserialkan dataset { $path } dengan transfer syntax { $syntax }
error-net-setting-socket-blocking = mengatur soket penyimpanan yang diterima ke mode blocking
error-net-sending-buffered-dataset = mengirim dataset tertahan untuk { $path }
error-net-store-status = pihak jarak jauh mengembalikan status C-STORE 0x{ $status } ({ $meaning }){ $hint }
error-net-streaming-dataset = menyalurkan dataset C-STORE
error-net-unexpected-command-field = tak terduga CommandField 0x{ $actual } (expected 0x{ $expected } for { $rsp })
error-net-unexpected-dataset-fragment = tak terduga dataset fragment in C-STORE response
error-net-unexpected-pdu = tak terduga PDU during { $operation }: { $pdu }
error-net-unknown-status = tidak valid { $operation } status 0x{ $status }
error-net-unsupported-model-sop = tidak didukung { $operation } model SOP class UID: { $uid }
error-net-unsupported-qr-level = tidak didukung QueryRetrieveLevel: { $level }
error-net-unsupported-transfer-syntax = tidak didukung negotiated transfer syntax
error-net-writing-command-dataset = menulis command dataset
error-net-writing-identifier = menulis { $operation } identifier
error-net-writing-path = menulis { $path }
error-net-writing-response-dataset = menulis { $operation } response dataset
error-net-writing-temp-dataset = menulis dataset bytes to temp file
error-node-host-empty = host node tidak boleh kosong
error-node-name-empty = nama node tidak boleh kosong
error-node-not-found = node jarak jauh tidak ditemukan: { $id }
error-operation-cancelled = operasi dibatalkan
error-port-invalid = port tidak valid: { $value }
error-port-range = port harus antara 1 dan 65535
error-query-no-study-uid = Hasil tidak memiliki StudyInstanceUID; retrieve tidak dapat dilakukan.
error-query-unsupported-level = level kueri tidak didukung: { $value }
error-query-unsupported-model = model kueri tidak didukung: { $value }
error-retrieve-canceled = pengambilan dibatalkan oleh node jarak jauh (status=0x{ $status }, completed={ $completed }, failed={ $failed }, warning={ $warning }, remaining={ $remaining }, { $scp })
error-retrieve-failed = pengambilan gagal dengan status=0x{ $status } (completed={ $completed }, failed={ $failed }, warning={ $warning }, remaining={ $remaining }, { $scp })
error-retrieve-nothing-arrived = pengambilan selesai untuk tujuan { $destination } dengan completed={ $completed } tetapi tidak ada yang tiba di Storage SCP lokal ({ $scp }). Periksa pemetaan AE atau salah port: pastikan { $listener } bebas dan node jarak jauh memetakan AE { $destination } ke aplikasi ini
error-send-no-files-series = tidak ada berkas lokal terindeks untuk seri { $uid }
error-send-no-files-study = tidak ada berkas lokal terindeks untuk studi { $uid }
error-task-cancelled = Tugas dibatalkan
error-task-none-to-cancel = Tidak ada tugas aktif untuk dibatalkan (tidak ada yang berjalan)
error-tracing-init = menginisialisasi tracing subscriber: { $err }
error-uid-component-numeric = komponen UID '{ $part }' harus numerik
error-uid-component-too-long = komponen UID '{ $part }' terlalu panjang
error-uid-dot-ends = UID tidak boleh diawali atau diakhiri titik
error-uid-empty = UID tidak boleh kosong
error-uid-empty-component = UID tidak boleh berisi komponen kosong
error-uid-leading-zeros = komponen UID '{ $part }' tidak boleh berawalan nol
error-uid-too-long = UID maksimal 64 karakter

## TUI
tui-bool-no = tidak
tui-bool-off = mati
tui-bool-on = nyala
tui-bool-yes = ya
tui-command-placeholder = Ketik perintah atau gunakan pintasan panel.
tui-config-ae-title = AE title: { $value }
tui-config-edit-hint = Tekan Tab untuk fokus ke panel ini, lalu tekan 'c' untuk edit.
tui-config-hint = Tekan Tab untuk fokus ke panel ini, lalu tekan 'c' untuk edit.
tui-config-listener = Pendengar: { $value }
tui-config-max-pdu = max_pdu_length: { $value }
tui-config-promiscuous = allow_promiscuous_storage: { $value }
tui-config-strict-pdu = strict_pdu: { $value }
tui-config-ts-pref = Preferensi TS: { $value }
tui-controls-hint = Tab bidang · Enter konfirmasi · Esc batal
tui-detail-ae-title = AE Title
tui-detail-instance = Detail instans
tui-detail-name = Nama
tui-detail-node = Detail node
tui-detail-placeholder-followup = Pindahkan fokus ke panel daftar dan ubah pilihan untuk memperbarui tampilan ini.
tui-detail-query = Detail hasil query
tui-detail-select-node = Pilih node jarak jauh untuk memeriksa metadatanya.
tui-detail-series = Seri Detail
tui-detail-study = Detail studi
tui-empty-command-placeholder = Ketik perintah atau gunakan pintasan panel.
tui-empty-detail-instance = Pilih instans untuk memeriksanya, atau kembali ke seri dengan Esc.
tui-empty-detail-node = Pilih node jarak jauh untuk memeriksa metadatanya.
tui-empty-detail-query = Pilih hasil kueri untuk memeriksa metadata dan konteks retrieve.
tui-empty-detail-series = Pilih seri untuk memeriksanya, atau kembali ke studi dengan Esc.
tui-empty-detail-study = Pilih studi lokal untuk memeriksa metadata pasien dan seri.
tui-empty-instances = Tidak ada instans terindeks untuk seri ini.
tui-empty-instances-hint = Tekan Esc untuk kembali ke seri.
tui-empty-local-instances = Tidak ada instans terindeks untuk seri ini.
tui-empty-local-instances-hint = Tekan Esc untuk kembali ke seri.
tui-empty-local-series = Tidak ada seri terindeks untuk studi ini.
tui-empty-local-series-hint = Tekan Esc untuk kembali ke studi lokal.
tui-empty-local-studies = Belum ada studi terindeks.
tui-empty-local-studies-cmd = Contoh: import path=/data/inbox
tui-empty-local-studies-hint = Impor local DICOM files first.
tui-empty-no-name = <tanpa nama>
tui-empty-query = Belum ada query yang dijalankan.
tui-empty-query-body =
    Pilih node jarak jauh lalu tekan 'f' untuk kueri.
    Atau: query node=pacs
        patient_name="DOE^JOHN"
    Tekan 'm' pada hasil terpilih untuk membuka retrieve.
tui-empty-query-cmd = Atau: query node=pacs
tui-empty-query-hint = Pilih node jarak jauh lalu tekan 'f' untuk kueri.
tui-empty-query-last-target = Target query terakhir: { $name }
tui-empty-query-none = Belum ada query yang dijalankan.
tui-empty-query-retrieve-hint = Tekan 'm' pada hasil terpilih untuk membuka retrieve.
tui-empty-remote-nodes = No node jarak jauhs are saved yet.
tui-empty-remote-nodes-cmd = Atau: node add name=pacs
tui-empty-remote-nodes-hint = Tekan 'a' di panel ini untuk menambah.
tui-empty-series = Tidak ada seri terindeks untuk studi ini.
tui-empty-series-hint = Tekan Esc untuk kembali ke studi lokal.
tui-empty-studies = Belum ada studi terindeks.
tui-empty-studies-hint = Impor local DICOM files first.
tui-empty-tasks-history = Tidak ada riwayat tugas.
tui-empty-tasks-queued = Tidak ada tugas antrian.
tui-fallback-no-name = <tanpa nama>
tui-field-accession = Nomor accession
tui-field-ae-title = AE title
tui-field-bind-addr = Alamat bind
tui-field-date-from = Tanggal dari
tui-field-date-to = Tanggal sampai
tui-field-destination-node = node tujuan
tui-field-host = nama host
tui-field-instance-uid = Instance UID
tui-field-kind = Jenis
tui-field-level = tingkat
tui-field-local-ae = AE lokal
tui-field-max-pdu = Max PDU
tui-field-modality = Modalitas
tui-field-model = model
tui-field-move-destination = Tujuan move
tui-field-name = Nama
tui-field-notes = Catatan
tui-field-path = jalur
tui-field-patient-id = ID pasien
tui-field-patient-name = Nama pasien
tui-field-port = nomor port
tui-field-promiscuous = tanpa batas AE
tui-field-series-uid = Series UID
tui-field-sop-uid = SOP Instance UID
tui-field-strict-pdu = PDU ketat
tui-field-study-description = Deskripsi studi
tui-field-study-uid = Study UID
tui-footer-back-series = Esc kembali ke seri
tui-footer-back-studies = Esc kembali ke studi
tui-footer-cancel-task = c batal
tui-footer-edit-config = c edit konfigurasi
tui-footer-enter-series = Enter seri
tui-footer-esc-series = Esc kembali ke seri
tui-footer-esc-studies = Esc kembali ke studi
tui-footer-help = F1/? bantuan
tui-footer-inspect = Enter periksa
tui-footer-next = Berikutnya: { $text }
tui-footer-nodes = a/e/d/f node
tui-footer-panes = Tab panel
tui-footer-queued =
    { $n ->
        [one] { $n } antrian
       *[other] { $n } antrian
    }
tui-footer-quit = q keluar
tui-footer-refresh = r segarkan
tui-footer-retrieve = m ambil
tui-footer-run-command = Enter jalankan perintah
tui-footer-task-scope = t antrian/riwayat
tui-form-add-node = Tambah node jarak jauh
tui-form-add-remote-node = Tambah node jarak jauh
tui-form-delete-confirm = Hapus node jarak jauh { $name } [{ $ae }] di { $host }:{ $port }?
tui-form-delete-node = Hapus Remote Node
tui-form-delete-remote-node = Hapus Remote Node
tui-form-edit-node = Edit node jarak jauh
tui-form-edit-remote-node = Edit node jarak jauh
tui-form-err-ae-required = ! AE title wajib
tui-form-err-bind-required = ! alamat bind wajib
tui-form-err-host-required = ! host wajib
tui-form-err-local-ae-invalid = ! AE title lokal tidak valid: { $err }
tui-form-err-local-ae-required = ! AE title lokal wajib
tui-form-err-modality-empty = modality tidak boleh kosong
tui-form-err-move-dest-invalid = ! AE title tujuan move tidak valid: { $err }
tui-form-err-name-required = ! nama node wajib
tui-form-err-port-required = ! port wajib
tui-form-err-uid-empty = UID tidak boleh kosong
tui-form-err-uid-empty-component = UID tidak boleh berisi komponen kosong
tui-form-error-line = Kesalahan: { $error }
tui-form-field-accession = Nomor accession
tui-form-field-ae-title = AE title
tui-form-field-bind-addr = Alamat bind
tui-form-field-date-from = Tanggal dari
tui-form-field-date-to = Tanggal sampai
tui-form-field-dest-node = node tujuan
tui-form-field-destination = AE tujuan
tui-form-field-host = nama host
tui-form-field-instance-uid = SOP Instance UID
tui-form-field-kind = Jenis
tui-form-field-level = tingkat
tui-form-field-local-ae = AE lokal
tui-form-field-modality = Modalitas
tui-form-field-model = model
tui-form-field-move-dest = Tujuan move
tui-form-field-name = Nama
tui-form-field-notes = Catatan
tui-form-field-path = jalur
tui-form-field-patient-id = ID pasien
tui-form-field-patient-name = Nama pasien
tui-form-field-port = nomor port
tui-form-field-series-uid = Series Instance UID
tui-form-field-sop-uid = SOP Instance UID
tui-form-field-study-desc = Deskripsi studi
tui-form-field-study-uid = Study Instance UID
tui-form-field-uid = UID
tui-form-hint-bind = petunjuk: biasanya 0.0.0.0 (semua antarmuka) atau 127.0.0.1
tui-form-hint-local-ae = petunjuk: hingga 16 karakter (A-Z, 0-9, spasi), mis. ARCHIVE_AE
tui-form-hint-move-dest = petunjuk: opsional; menimpa AE title tujuan C-MOVE
tui-form-hint-name = petunjuk: label singkat (mis. PACS)
tui-form-import = Impor Local Files
tui-form-import-local = Impor Local Files
tui-form-import-local-files = Impor Local Files
tui-form-mode-add = create a new node jarak jauh
tui-form-mode-edit = update the selected node jarak jauh
tui-form-query-node = Query node jarak jauh
tui-form-query-remote-node = Query node jarak jauh
tui-form-remote-node-line = Node jarak jauh: { $name } [{ $ae }] { $host }:{ $port }
tui-form-retrieve = Retrieve cocokan
tui-form-retrieve-matches = Retrieve cocokan
tui-form-send-series = Send Seri
tui-form-send-study = Kirim studi
tui-form-storage-intro = Edit pengaturan Storage SCP lokal (disimpan ke config.json).
tui-form-storage-scp = Pengaturan Storage SCP
tui-form-storage-scp-settings = Pengaturan Storage SCP
tui-help-ae-title = AE title: { $value }
tui-help-aedf = a/e/d/f     Tambah, edit, hapus, atau query node terpilih
tui-help-c = c           Edit pengaturan Storage SCP (saat fokus di panel Config)
tui-help-canonical-names = Nama kanonis cocok dengan flag CLI tanpa '--', memakai underscore.
tui-help-close = Tutup bantuan dengan Esc, F1, atau ?.
tui-help-common-commands = Perintah umum
tui-help-config = c           Edit pengaturan Storage SCP (saat fokus di panel Config)
tui-help-config-path = Path konfigurasi: { $value }
tui-help-current-config = Konfigurasi saat ini
tui-help-data-dir = Direktori data: { $value }
tui-help-enter-default = Enter       Run the command input, submit the active modal, or open series from Studi lokal
tui-help-enter-instance = Enter       Tidak ada aksi panel lokal di tampilan instans
tui-help-enter-local-instance = Enter       Tidak ada aksi panel lokal di tampilan instans
tui-help-enter-local-series = Enter       Buka instans seri lokal terpilih, atau jalankan input perintah / kirim modal aktif
tui-help-enter-local-study = Enter       Buka seri studi lokal terpilih, atau jalankan input perintah / kirim modal aktif
tui-help-enter-series = Enter       Buka instans seri lokal terpilih, atau jalankan input perintah / kirim modal aktif
tui-help-enter-study = Enter       Buka seri studi lokal terpilih, atau jalankan input perintah / kirim modal aktif
tui-help-esc-default = Esc         Tutup bantuan/modal, kembali dari seri lokal, atau kembalikan fokus ke input perintah
tui-help-esc-instance = Esc         Kembali dari instans lokal ke seri, tutup bantuan/modal, atau kembalikan fokus ke input perintah
tui-help-esc-instances = Esc         Kembali dari instans lokal ke seri, tutup bantuan/modal, atau kembalikan fokus ke input perintah
tui-help-esc-series = Esc         Kembali dari seri lokal ke studi, tutup bantuan/modal, atau kembalikan fokus ke input perintah
tui-help-f1 = F1 atau ?     Buka bantuan
tui-help-import-send = i/s         Impor local files or send selected study/series
tui-help-is = i/s         Impor local files or send selected study/series
tui-help-listener = Pendengar: { $value }
tui-help-log-dir = Direktori log: { $value }
tui-help-m = m           Retrieve dari hasil query terpilih
tui-help-max-pdu = max_pdu_length: { $value }
tui-help-move = Atas/Bawah atau j/k   Geser pilihan di panel daftar
tui-help-nodes = a/e/d/f     Tambah, edit, hapus, atau query node terpilih
tui-help-open = F1 atau ?     Buka bantuan
tui-help-promiscuous = allow_promiscuous_storage: { $value }
tui-help-q = q           Keluar saat tidak ada modal aktif dan fokus tidak di input perintah
tui-help-quit = q           Keluar saat tidak ada modal aktif dan fokus tidak di input perintah
tui-help-r = r           Muat ulang panes when focus is tidakt in command input
tui-help-receiver-mode = Mode penerima: { $value }
tui-receiver-mode-on-demand = sesuai permintaan untuk retrieve lokal
tui-receiver-mode-standalone = mandiri via storage-scp
tui-help-refresh = r           Muat ulang panes when focus is tidakt in command input
tui-help-retrieve = m           Retrieve dari hasil query terpilih
tui-help-strict-pdu = strict_pdu: { $value }
tui-help-tab = Tab / Shift-Tab  Ubah panel terfokus
tui-help-title = Pintasan tombol
tui-help-ts-pref = preferred_store_transfer_syntax: { $value }
tui-help-updown = Atas/Bawah atau j/k   Geser pilihan di panel daftar
tui-input-placeholder = Ketik perintah atau gunakan pintasan panel.
tui-log-command = > { $command }
tui-log-error = kesalahan: { $error }
tui-log-refreshed = diperbarui
tui-logs-capped-suffix = dibatasi
tui-logs-label = Log:
tui-pane-command = Perintah
tui-pane-config = Konfigurasi
tui-pane-detail = detail
tui-pane-detail-hint = { $title } (PgUp/PgDn saat tidak mengetik)
tui-pane-help = Bantuan
tui-pane-instance-detail = Detail instans
tui-pane-instances-for = Instans for: { $uid }
tui-pane-local-studies = Studi lokal
tui-pane-logs = Log ({ $shown }/{ $total }{ $capped })
tui-pane-logs-capped = Log ({ $shown }/{ $total } capped)
tui-pane-logs-uncapped = Log ({ $shown }/{ $total })
tui-pane-node-detail = Detail node
tui-pane-query-detail = Detail hasil query
tui-pane-query-node = Kueri node
tui-pane-query-result-detail = Detail hasil query
tui-pane-query-results = Kueri / ambil Hasil
tui-pane-query-retrieve-results = Kueri / ambil Hasil
tui-pane-remote-nodes = Node jarak jauh
tui-pane-series-detail = Seri Detail
tui-pane-series-for = Seri for: { $uid }
tui-pane-series-unknown = Seri for: <studi tidak dikenal>
tui-pane-study-detail = Detail studi
tui-pane-task-details = Detail tugas
tui-pane-tasks-history = Tugas (riwayat)
tui-pane-tasks-queued = Tugas (antrian)
tui-pane-unknown-series = <seri tidak dikenal>
tui-pane-unknown-study = Seri for: <studi tidak dikenal>
tui-row-inst = inst
tui-status-cancel-requested = Batallation requested
tui-status-config = Konfigurasi
tui-status-configured-listener = Listener terkonfigurasi { $addr } sebagai AE { $ae } ({ $mode })
tui-status-data = data
tui-status-failure = kegagalan: { $failure }
tui-status-listener = pendengar
tui-status-local-ae = AE lokal
tui-status-mode = mode
tui-status-mode-on-demand = sesuai permintaan
tui-status-mode-standalone = mandiri
tui-status-no-active-task = Tidak ada tugas aktif to cancel (nothing running)
tui-status-pdu = PDU
tui-status-promiscuous = tanpa batas AE
tui-status-query-before-retrieve = Query a node jarak jauh first so retrieve knows which node to use
tui-status-query-failed = kueri gagal: { $error }
tui-status-queued-op = Operasi antrian: { $op }
tui-status-retrieve-failed = retrieve gagal: { $error }
tui-status-retrieve-open-failed = tidak dapat membuka retrieve stream: { $error }
tui-status-saved-node = node disimpan { $name } ({ $id })
tui-status-saved-scp = Pengaturan Storage SCP disimpan (perlu restart)
tui-status-select-node = pilih node jarak jauh terlebih dahulu
tui-status-select-query = pilih hasil query terlebih dahulu
tui-status-select-study = pilih studi lokal terlebih dahulu
tui-status-strict = Ketat
tui-status-task-cancelled = Tugas dibatalkan
tui-status-task-cancelled-detail = Tugas dibatalkan: { $other }
tui-status-ts-pref = Preferensi TS
tui-status-updated-node = node diperbarui { $name } ({ $id })
tui-suggest-back-series = Esc — kembali ke seri
tui-suggest-edit-config = c — edit konfigurasi
tui-suggest-help = F1/? — bantuan
tui-suggest-inspect-task = Enter — inspect tugas
tui-suggest-node-add = node add <ae-title> <host:port>
tui-suggest-query = f — query node
tui-suggest-query-node = f — query node terpilih
tui-suggest-retrieve = m — retrieve terpilih
tui-suggest-run-command = Enter — jalankan perintah
tui-suggest-send-series = s — kirim seri terpilih
tui-suggest-view-series = Enter — lihat seri
tui-task-cancelled = Batalled
tui-task-cancelling = Batalling
tui-task-failed = Gagal
tui-task-failed-generic = Tugas gagal: { $error }
tui-task-import-done = Impor complete: { $report }
tui-task-import-failed = Impor gagal: { $error }
tui-task-importing = Imporing { $path }...
tui-task-query-done =
    Query selesai: { $count ->
        [one] { $count } cocokan
       *[other] { $count } cocokan
    }
tui-task-query-failed = Query gagal: { $error }
tui-task-querying = Meng-query { $node }...
tui-task-queued = Antrian
tui-task-retrieve-done = Retrieve selesai: { $outcome }
tui-task-retrieve-failed = Retrieve gagal: { $error }
tui-task-retrieving = Retrieve dari { $node }...
tui-task-running = Berjalan
tui-task-sending-series = Mengirim seri { $uid } ke { $node }...
tui-task-sending-study = Mengirim studi { $uid } ke { $node }...
tui-task-send-done = Kirim selesai: { $outcome }
tui-task-status-cancelled = dibatalkan
tui-task-status-cancelling = membatalkan
tui-task-status-failed = gagal
tui-task-status-ok = ok
tui-task-status-queued = antrian
tui-task-status-running = berjalan
tui-task-succeeded = Berhasil
tui-terminal-too-small = Terminal terlalu kecil - ubah ukuran

## Desktop
desktop-action-activity = Aktivitas { $count }
desktop-action-activity-empty = Aktivitas
desktop-action-import = Impor
desktop-action-inspect-archive = Periksa arsip lokal
desktop-action-inspect-archive-desc = Tinjau studi, seri, dan instans; lalu kirim atau ekspor.
desktop-action-manage-peers = Kelola peer
desktop-action-manage-peers-desc = Tambah dan sunting node PACS atau workstation untuk query, retrieve, dan store.
desktop-action-monitor-scp = Pantau Storage SCP
desktop-action-query = Kueri
desktop-action-refresh = Segarkan status
desktop-action-refresh-status = Segarkan status
desktop-action-reveal-log = Tampilkan berkas log
desktop-action-send = Kirim
desktop-action-start-scp = Mulai Storage SCP
desktop-activity-empty = Belum ada aktivitas sesi.
desktop-activity-title = Aktivitas
desktop-app-title = DICOM Node
desktop-archive-csv = CSV
desktop-archive-details = Detail
desktop-archive-empty = Arsip lokal kosong.
desktop-archive-export-fail = Ekspor { $scope } gagal
desktop-archive-export-ok =
    { $rows ->
        [one] Diekspor { $rows } baris { $scope } ke { $path }.
       *[other] Diekspor { $rows } baris { $scope } ke { $path }.
    }
desktop-archive-export-studies = Ekspor studi
desktop-archive-export-title = Ekspor { $scope }
desktop-archive-filter = Saring menurut pasien, UID, deskripsi, modalitas…
desktop-archive-filter-placeholder = Saring menurut pasien, UID, deskripsi, modalitas…
desktop-archive-inst-abbrev = { $count } inst.
desktop-archive-instance-meta = { $bytes } · TS { $ts } · diimpor { $imported }
desktop-archive-instances = Instans
desktop-archive-instances-heading = Instans
desktop-archive-json = JSON
desktop-archive-loading = Memuat studi…
desktop-archive-no-filter-match = Tidak ada studi yang cocok dengan saringan.
desktop-archive-no-instances = Instans tidak ditemukan.
desktop-archive-no-match = Tidak ada studi yang cocok dengan saringan.
desktop-archive-no-nodes = Tidak ada node
desktop-archive-no-series = Series tidak ditemukan.
desktop-archive-reveal-file = Tampilkan berkas
desktop-archive-select-series = Pilih sebuah series.
desktop-archive-select-study = Pilih sebuah studi.
desktop-archive-send-fail = { $label }: { $sent }/{ $attempted } terkirim, { $failed } gagal. { $failures }
desktop-archive-send-fail-title = { $label } gagal
desktop-archive-send-ok = { $label }: terkirim { $sent }/{ $attempted } instans.
desktop-archive-send-series = Kirim series
desktop-archive-send-series-label = Seri → { $destination }
desktop-archive-send-study = Kirim studi
desktop-archive-send-study-label = Studi → { $destination }
desktop-archive-send-to = Kirim ke
desktop-archive-series = Seri
desktop-archive-series-count =
    #{ $number } · { $count ->
        [one] { $count } instans
       *[other] { $count } instans
    }
desktop-archive-series-fallback = Seri
desktop-archive-studies = Studi
desktop-archive-study-date = Tanggal studi
desktop-archive-study-uid = Study UID
desktop-archive-subtitle = Inventaris studi, series, dan instans dari arsip SQLite lokal.
desktop-archive-title = Arsip lokal
desktop-brand-title = DICOM Node
desktop-col-description = Deskripsi
desktop-col-instances = Instans
desktop-col-modalities = Modalitas
desktop-col-patient-id = ID pasien
desktop-common-cancel = Batal
desktop-common-clear = Hapus
desktop-common-disabled = dinonaktifkan
desktop-common-enabled = diaktifkan
desktop-common-loading = Memuat…
desktop-common-no = tidak
desktop-common-refresh = Segarkan
desktop-common-yes = ya
desktop-counter-assoc-accepted = Asosiasi diterima
desktop-counter-bytes-ingested = Byte masuk
desktop-counter-cfind-requests = Permintaan C-FIND
desktop-counter-cmove-requests = Permintaan C-MOVE
desktop-counter-cstore-failed = C-STORE gagal
desktop-counter-cstore-stored = C-STORE tersimpan
desktop-dashboard-counter-assoc-accepted = Asosiasi diterima
desktop-dashboard-counter-bytes-ingested = Byte masuk
desktop-dashboard-counter-c-find-requests = Permintaan C-FIND
desktop-dashboard-counter-c-move-requests = Permintaan C-MOVE
desktop-dashboard-counter-c-store-failed = C-STORE gagal
desktop-dashboard-counter-c-store-stored = C-STORE tersimpan
desktop-dashboard-empty-studies = Belum ada studi lokal.
desktop-dashboard-inspect-archive-body = Tinjau studi, masuk ke series dan instans, lalu kirim atau ekspor.
desktop-dashboard-inspect-archive-title = Periksa arsip lokal
desktop-dashboard-kv-ae-title = AE Title
desktop-dashboard-kv-data-dir = Direktori data
desktop-dashboard-kv-listener = pendengar
desktop-dashboard-kv-log-file = Berkas log
desktop-dashboard-kv-max-pdu = PDU maks.
desktop-dashboard-kv-promiscuous = Penyimpanan tanpa batas
desktop-dashboard-kv-server = peladen
desktop-dashboard-kv-store-syntax = Sintaksis store
desktop-dashboard-kv-strict-pdu = PDU ketat
desktop-dashboard-listener-missing = Listener belum dimuat.
desktop-dashboard-live-counters = Penghitung langsung
desktop-dashboard-loading-metrics = Memuat metrik…
desktop-dashboard-loading-status = Memuat status lokal…
desktop-dashboard-loading-studies = Memuat studi…
desktop-dashboard-local-node = Node lokal
desktop-dashboard-manage-peers-body = Tambah dan sunting node PACS atau stasiun untuk kueri, ambil, dan store.
desktop-dashboard-manage-peers-title = Kelola peer
desktop-dashboard-metric-instances = Instans
desktop-dashboard-metric-nodes = Node jarak jauh
desktop-dashboard-metric-series = Seri
desktop-dashboard-metric-studies = Studi
desktop-dashboard-monitor-scp = Pantau Storage SCP
desktop-dashboard-recent-studies = Studi terbaru
desktop-dashboard-start-scp = Mulai Storage SCP
desktop-dashboard-subtitle = Arsip lokal, peer jaringan, dan aktivitas SCP dalam satu pandangan.
desktop-dashboard-title = Dasbor operator
desktop-doc-title = DICOM Node
desktop-import-accepted = Diterima
desktop-import-accepted-bytes = Byte diterima
desktop-import-activity-detail = { $accepted }/{ $scanned } diterima, { $duplicates } duplikat, { $bytes }
desktop-import-activity-fail = Impor gagal
desktop-import-activity-ok = Impor selesai
desktop-import-choose-archive = Pilih arsip ZIP untuk diimpor
desktop-import-choose-dir = Pilih direktori untuk diimpor
desktop-import-choose-folder = Folder
desktop-import-choose-zip = Pilih arsip ZIP untuk diimpor
desktop-import-cleanup = Pembersihan
desktop-import-clear-path = Hapus jalur
desktop-import-complete = Impor selesai
desktop-import-dup-sha = SHA-256
desktop-import-dup-sop = SOP UID
desktop-import-dup-total = jumlah
desktop-import-duplicates = Duplikat
desktop-import-failed = Impor gagal
desktop-import-failed-cleanup = Pembersihan gagal
desktop-import-failures = Kegagalan
desktop-import-failures-heading =
    { $count ->
        [one] { $count } kegagalan:
       *[other] { $count } kegagalan:
    }
desktop-import-failures-more = … dan { $count } lagi
desktop-import-files-progress = { $label } berkas
desktop-import-folder = folder
desktop-import-invalid-dicom = DICOM tidak valid
desktop-import-pick-dir = Pilih direktori untuk diimpor
desktop-import-pick-zip = Pilih arsip ZIP untuk diimpor
desktop-import-placeholder = /path/to/dicom-folder or /path/to/archive.zip
desktop-import-rejected = Ditolak
desktop-import-report = Laporan impor
desktop-import-running = Mengimpor…
desktop-import-scanned = Dipindai
desktop-import-skipped = Dilewati
desktop-import-source = Sumber
desktop-import-start = Mulai impor
desktop-import-stored = Tersimpan
desktop-import-subtitle = Indeks berkas DICOM dari folder rekursif atau arsip ZIP ke arsip lokal terkelola.
desktop-import-title = Impor
desktop-import-unreadable = Tidak terbaca
desktop-import-zip = ZIP
desktop-import-zip-filter = Arsip ZIP
desktop-lang-label = Bahasa
desktop-listener-not-loaded = Listener belum dimuat.
desktop-live-counters = Penghitung langsung
desktop-loading = Memuat
desktop-loading-local-status = Memuat status lokal…
desktop-loading-metrics = Memuat metrik…
desktop-loading-studies = Memuat studi…
desktop-local-node = Node lokal
desktop-locale-label = Bahasa
desktop-logs-activity-detail =
    { $count ->
        [one] { $count } baris dimuat
       *[other] { $count } baris dimuat
    }
desktop-logs-activity-fail = Penyegaran log gagal
desktop-logs-activity-ok = Log disegarkan
desktop-logs-auto = OTOMATIS
desktop-logs-auto-refresh = Segarkan otomatis
desktop-logs-empty = Berkas log kosong.
desktop-logs-found = BERKAS LOG DITEMUKAN
desktop-logs-lines =
    { $count ->
        [one] { $count } baris
       *[other] { $count } baris
    }
desktop-logs-loading = Memuat log…
desktop-logs-missing = Berkas log aktif belum dibuat.
desktop-logs-refresh-failed = Penyegaran log gagal
desktop-logs-refreshed = Log disegarkan
desktop-logs-reveal = Tampilkan
desktop-logs-subtitle = Ekor terbatas dari berkas log desktop aktif.
desktop-logs-tail = Ekor
desktop-logs-title = Log
desktop-logs-truncated = TERPOTONG
desktop-logs-waiting = MENUNGGU BERKAS LOG
desktop-metric-instances = Instans
desktop-metric-remote-nodes = Node jarak jauh
desktop-metric-series = Seri
desktop-metric-studies = Studi
desktop-nav-archive = Arsip lokal
desktop-nav-dashboard = Dasbor
desktop-nav-import = Impor
desktop-nav-logs = Log
desktop-nav-network = Jaringan
desktop-nav-nodes = Node jarak jauh
desktop-nav-query = Kueri / ambil
desktop-nav-server = Server penyimpanan
desktop-no-local-studies = Belum ada studi lokal.
desktop-nodes-add = Tambah node
desktop-nodes-added = Node "{ $name }" ditambahkan.
desktop-nodes-ae-length = AE Title harus 16 karakter atau kurang.
desktop-nodes-ae-title = AE Title
desktop-nodes-col-move = Tujuan Move
desktop-nodes-configured = Node terkonfigurasi
desktop-nodes-confirm-delete = Hapus node "{ $name }"?
desktop-nodes-default-port = Port bawaan 104
desktop-nodes-delete = Hapus node
desktop-nodes-delete-title = Hapus node
desktop-nodes-deleted = Node "{ $name }" dihapus.
desktop-nodes-edit = Sunting node
desktop-nodes-edit-title = Sunting node
desktop-nodes-empty = Belum ada node jarak jauh.
desktop-nodes-err-ae = AE title wajib.
desktop-nodes-err-ae-len = AE title maksimal 16 karakter.
desktop-nodes-err-host = Host wajib.
desktop-nodes-err-name = Nama wajib.
desktop-nodes-err-port = Port harus 1–65535.
desktop-nodes-host = nama host
desktop-nodes-move-dest = Tujuan Move
desktop-nodes-move-placeholder = Bawaan: AE lokal
desktop-nodes-name = Nama
desktop-nodes-need-ae = AE Title wajib.
desktop-nodes-need-host = Host wajib.
desktop-nodes-need-name = Nama wajib.
desktop-nodes-notes = Catatan
desktop-nodes-notes-placeholder = PACS ruang baca
desktop-nodes-placeholder-ae = PACS01
desktop-nodes-placeholder-host = 192.168.0.10
desktop-nodes-placeholder-move = Bawaan: AE lokal
desktop-nodes-placeholder-name = main-pacs
desktop-nodes-placeholder-notes = PACS ruang baca
desktop-nodes-port = nomor port
desktop-nodes-port-104 = Port bawaan 104
desktop-nodes-port-range = Port harus 1–65535.
desktop-nodes-save = Simpan perubahan
desktop-nodes-save-changes = Simpan perubahan
desktop-nodes-subtitle = Peer PACS dan stasiun untuk kueri, ambil, dan store.
desktop-nodes-summary = Ringkasan node
desktop-nodes-title = Node jarak jauh
desktop-nodes-total = Total node
desktop-nodes-updated = Node "{ $name }" diperbarui.
desktop-nodes-with-move = Dengan tujuan Move
desktop-promiscuous = Penyimpanan tanpa batas
desktop-query-accession = Accession no.
desktop-query-activity-detail = { $count } { $count ->
        [one] kecocokan
       *[other] kecocokan
    } pada level { $level }
desktop-query-activity-fail = C-FIND { $node } gagal
desktop-query-activity-ok = C-FIND { $node }
desktop-query-activity-title = C-FIND { $node }
desktop-query-clear = Hapus
desktop-query-col-accession = nomor akses
desktop-query-criteria = Kriteria pencarian
desktop-query-date-from = Tanggal studi dari
desktop-query-date-to = Tanggal studi sampai
desktop-query-kv-series-uid = Series UID
desktop-query-kv-sop-uid = SOP UID
desktop-query-kv-study-uid = Study UID
desktop-query-level = tingkat
desktop-query-matches =
    { $count ->
        [one] { $count } kecocokan
       *[other] { $count } kecocokan
    }
desktop-query-missing-study-uid = Kecocokan tidak punya StudyInstanceUID; tidak dapat diambil.
desktop-query-modality = Modalitas
desktop-query-no-matches = Tidak ada kecocokan.
desktop-query-no-nodes = Tidak ada node yang dikonfigurasi
desktop-query-patient-id = ID pasien
desktop-query-patient-name = Nama pasien
desktop-query-placeholder-description = CHEST*
desktop-query-placeholder-modality = CT, MR, …
desktop-query-placeholder-name = DOE^JOHN or DOE*
desktop-query-placeholder-patient = DOE^JOHN or DOE*
desktop-query-querying = Mengueri…
desktop-query-remote-node = Node jarak jauh
desktop-query-results = Hasil
desktop-query-retrieve = Ambil
desktop-query-retrieve-activity-detail = completed={ $completed }, warning={ $warning }, failed={ $failed }
desktop-query-retrieve-activity-fail = C-MOVE { $node } gagal
desktop-query-retrieve-activity-ok = C-MOVE { $node }
desktop-query-retrieve-finished = Pengambilan selesai: selesai { $completed }, peringatan { $warning }, gagal { $failed }.
desktop-query-retrieve-selected = Ambil yang dipilih
desktop-query-run = Jalankan C-FIND
desktop-query-run-select = Jalankan kueri dan pilih kecocokan.
desktop-query-running = Mengueri…
desktop-query-search-criteria = Kriteria pencarian
desktop-query-select-hint = Jalankan kueri dan pilih kecocokan.
desktop-query-selected = Kecocokan terpilih
desktop-query-selected-match = Kecocokan terpilih
desktop-query-series-uid = Series Instance UID
desktop-query-sop-uid = SOP Instance UID
desktop-query-study-description = Deskripsi studi
desktop-query-study-uid = Study Instance UID
desktop-query-subtitle = C-FIND ke node jarak jauh, periksa kecocokan, lalu C-MOVE ke arsip lokal.
desktop-query-title = Kueri / ambil
desktop-recent-studies = Studi terbaru
desktop-scp-listening = SCP mendengarkan
desktop-scp-stopped = SCP berhenti
desktop-server-activity-fail = Kontrol Storage SCP gagal
desktop-server-activity-started = Storage SCP dimulai
desktop-server-activity-started-detail = Listener dimulai.
desktop-server-activity-stopped = Storage SCP berhenti
desktop-server-activity-stopped-detail = received={ $received }, stored={ $stored }, failed={ $failed }
desktop-server-activity-stopped-empty = Tidak ada sesi aktif.
desktop-server-addr-ae = { $addr } · AE { $ae }
desktop-server-assoc-accepted = Asosiasi diterima
desktop-server-assoc-rejected = Asosiasi ditolak
desktop-server-cfind-req-matches = Permintaan / kecocokan C-FIND
desktop-server-cget-requests = Permintaan C-GET
desktop-server-cmove-requests = Permintaan C-MOVE
desktop-server-cmove-subops = Suboperasi C-MOVE selesai / gagal
desktop-server-control-failed = Kontrol Storage SCP gagal
desktop-server-counter-bytes = Byte masuk
desktop-server-counter-failed = C-STORE gagal
desktop-server-counter-find = Permintaan / kecocokan C-FIND
desktop-server-counter-get = Permintaan C-GET
desktop-server-counter-move = Permintaan C-MOVE
desktop-server-counter-move-sub = Suboperasi C-MOVE selesai / gagal
desktop-server-counter-received = C-STORE diterima
desktop-server-counter-stored = C-STORE tersimpan
desktop-server-cstore-failed = C-STORE gagal
desktop-server-cstore-received = C-STORE diterima
desktop-server-cstore-stored = C-STORE tersimpan
desktop-server-dimse = Penghitung DIMSE
desktop-server-failed = Gagal
desktop-server-health-loading = Memuat metrik
desktop-server-health-ready = Siap untuk C-STORE masuk
desktop-server-health-review = Tinjau kegagalan
desktop-server-health-stopped = Berhenti
desktop-server-listener-started = Listener dimulai.
desktop-server-listening = MENDENGARKAN
desktop-server-loading-metrics = Memuat metrik…
desktop-server-logs = Log
desktop-server-no-session = Tidak ada sesi aktif.
desktop-server-rate = +{ $rate } / jajak
desktop-server-ready = Siap untuk C-STORE masuk
desktop-server-review-failures = Tinjau kegagalan
desktop-server-session-ended = Sesi berakhir: diterima { $received }, tersimpan { $stored }, gagal { $failed }.
desktop-server-start = Mulai server
desktop-server-started-title = Storage SCP dimulai
desktop-server-stop = Hentikan server
desktop-server-stopped = BERHENTI
desktop-server-stopped-pill = BERHENTI
desktop-server-stopped-status = Berhenti
desktop-server-stopped-title = Storage SCP berhenti
desktop-server-stored = Tersimpan
desktop-server-subtitle = Storage SCP mandiri untuk C-STORE masuk dan pengindeksan arsip lokal.
desktop-server-title = Server penyimpanan
desktop-status-listening = mendengarkan
desktop-status-loading = Memuat
desktop-status-scp-listening = SCP mendengarkan
desktop-status-scp-stopped = SCP berhenti
desktop-status-stopped = berhenti
desktop-store-syntax = Sintaksis store
desktop-strict-pdu = PDU ketat
desktop-strip-pdu = PDU { $value }
desktop-table-accession = Aksesi
desktop-table-ae-title = AE title
desktop-table-date = Tanggal
desktop-table-description = Deskripsi
desktop-table-endpoint = titik akhir
desktop-table-instances = Instans
desktop-table-modalities = Modalitas
desktop-table-modality = Modalitas
desktop-table-move-dest = Tujuan Move
desktop-table-name = Nama
desktop-table-notes = Catatan
desktop-table-patient = Pasien
desktop-table-patient-id = ID pasien
desktop-table-series = Seri
desktop-table-updated = Diperbarui
desktop-title-refresh-status = Segarkan status
desktop-title-reveal-log = Tampilkan berkas log
ae = AE
patient-name =
    "DOE^JOHN"
    Tekan 'm' pada hasil terpilih untuk membuka retrieve.
port = nomor port

## Summary
summary-ae = AE
summary-counts = Jumlah
summary-criteria = Kriteria
summary-duration = Durasi
summary-duration-ms = { $ms }ms
summary-failures = Kegagalan:
summary-kind = Jenis
summary-logs = Log:
summary-peer = rekan
summary-status = keadaan
summary-title = Ringkasan operasi
tui-detail-created = Dibuat

tui-form-hint-port-range = petunjuk: angka 1 sampai 65535, mis. 104
tui-form-hint-promiscuous = petunjuk: izinkan penyimpanan dari AE title pemanggil mana pun
tui-form-hint-strict-pdu = petunjuk: terapkan pemeriksaan ukuran PDU selama asosiasi
tui-form-hint-max-pdu-bytes = petunjuk: byte, mis. 16384
tui-form-limits-heading = Limits (bytes; blank/tidak ada = unlimited):
tui-form-field-max-file-import = Maks. byte impor berkas
tui-form-field-max-zip-entry = Maks. byte entri ZIP
tui-form-field-max-zip-total = Maks. total byte ZIP
tui-form-field-max-zip-count = Maks. jumlah entri ZIP
tui-form-field-max-store-object = Maks. byte objek store
tui-form-unlimited = tanpa batas
tui-form-err-max-pdu-required = ! panjang PDU maks. wajib
tui-form-err-max-pdu-gt-zero = ! panjang PDU maks. harus bilangan bulat lebih dari 0
tui-form-err-limit-gt-zero = ! { $label } harus bilangan bulat lebih dari 0
tui-form-controls-scp = Ketik untuk edit. Spasi mengubah kotak centang. Tab/Shift-Tab atau Atas/Bawah pindah bidang. Enter menyimpan. Esc batal.
tui-form-submit-uid-required = UID wajib
tui-form-submit-dest-required = node tujuan wajib
tui-form-submit-nonneg-int = { $label } harus bilangan bulat non-negatif
tui-form-submit-gt-zero = { $label } harus lebih dari 0
tui-form-submit-local-ae-required = AE title lokal wajib
tui-form-submit-local-ae-invalid = AE title lokal tidak valid: { $err }
tui-form-submit-bind-required = alamat bind wajib
tui-form-submit-port-required = port wajib
tui-form-submit-max-pdu-required = panjang PDU maks. wajib
tui-form-submit-max-pdu-int = panjang PDU maks. harus bilangan bulat
tui-form-submit-max-pdu-gt-zero = panjang PDU maks. harus lebih dari 0
tui-form-submit-patient-retrieve = retrieve tingkat pasien tidak didukung
tui-form-submit-no-study-uid = hasil terpilih tidak menyertakan study UID
tui-form-submit-date-format = diharapkan YYYYMMDD
tui-form-submit-modality-len = modalitas paling banyak 16 karakter
tui-form-submit-modality-chars = modalitas harus A-Z atau 0-9
tui-form-submit-name-required = nama node wajib
tui-form-submit-ae-required = AE title wajib
tui-form-submit-host-required = host wajib
tui-form-submit-move-dest-invalid = AE title tujuan move tidak valid: { $err }
tui-form-submit-dates-both = tanggal dari dan tanggal sampai harus keduanya diisi, atau tidak sama sekali
tui-form-submit-date-from-invalid = tanggal dari tidak valid: { $err }
tui-form-submit-date-to-invalid = tanggal sampai tidak valid: { $err }
tui-form-submit-date-order = tanggal dari harus pada atau sebelum tanggal sampai
tui-form-submit-study-uid-series-query = study UID wajib untuk query tingkat seri
tui-form-submit-study-uid-image-query = study UID wajib untuk query tingkat citra
tui-form-submit-series-uid-image-query = series UID wajib untuk query tingkat citra
tui-form-submit-study-uid-required = study UID wajib
tui-form-submit-study-uid-invalid = study UID tidak valid: { $err }
tui-form-submit-series-uid-series-retrieve = series UID wajib untuk retrieve tingkat seri
tui-form-submit-series-uid-image-retrieve = series UID wajib untuk retrieve tingkat citra
tui-form-submit-instance-uid-image-retrieve = instance UID wajib untuk retrieve tingkat citra
tui-form-submit-series-uid-invalid = series UID tidak valid: { $err }
tui-form-submit-instance-uid-invalid = instance UID tidak valid: { $err }
tui-form-submit-import-path-required = path impor wajib
tui-form-submit-import-path-type = path impor harus berkas atau direktori: { $path }
tui-form-submit-import-access = mengakses path impor { $path }
tui-form-submit-import-open = membuka berkas impor { $path }
tui-form-submit-import-read-dir = membaca direktori impor { $path }
tui-log-welcome = Press F1 or ? for help. Focus Node jarak jauhs and press 'a' to add one.
tui-log-logging-to = Mencatat ke { $path }
tui-command-help-heading = perintah:
tui-command-help-next-1 = catatan: footer menampilkan saran 'Next:' sesuai panel terfokus dan pilihan.
tui-command-help-next-2 = Ini hanya petunjuk; Anda selalu dapat mengetik perintah apa pun.
tui-command-help-canonical = catatan: nama kanonis cocok dengan flag CLI tanpa '--', memakai underscore.
tui-command-help-cancel = batal (alias: stop)
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
tui-command-help-refresh = segarkan
tui-command-help-quit = keluar
tui-inspect-task = Tugas #{ $id }
tui-inspect-status = Keadaan: { $status }
tui-inspect-description = Deskripsi: { $description }
tui-inspect-progress = Progres: { $progress }
tui-inspect-summary = Ringkasan:
tui-inspect-no-logs = (tidak ada log)
tui-field-sop-class-uid = SOP Class UID
tui-field-transfer-syntax-uid = Transfer Syntax UID
tui-field-sha256 = SHA-256
tui-status-removed-nodes =
    menghapus { $count ->
        [one] { $count } node
       *[other] { $count } node
    }
tui-status-removed-nodes-target =
    menghapus { $count ->
        [one] { $count } node
       *[other] { $count } node
    }; target terakhir { $name }
tui-status-more-failures =
    dan { $n ->
        [one] { $n } kegagalan diabaikan
       *[other] { $n } kegagalan diabaikan
    }
tui-status-retrieve-ok = retrieve status=0x{ $status } completed={ $completed } failed={ $failed } warning={ $warning } remaining={ $remaining }
tui-status-import-counts = scanned={ $scanned } accepted={ $accepted } duplicates={ $duplicates } unreadable={ $unreadable } invalid_dicom={ $invalid } rejected_total={ $rejected } stored_bytes={ $bytes }
tui-status-send-ok = send attempted={ $attempted } sent={ $sent } failed={ $failed }
tui-log-query-start = Memulai kueri ke { $node }
tui-log-retrieve-start = Memulai retrieve dari { $node }
tui-log-import-start = Memulai impor { $path }
tui-log-send-study-start = Mulai kirim studi { $uid } ke { $node }
tui-log-send-series-start = Mulai kirim seri { $uid } ke { $node }
tui-log-cancelled-before-start = dibatalkan sebelum mulai
tui-log-cancelled = dibatalkan
error-unknown-command = perintah tidak dikenal: { $command }
error-node-subcommand-required = subcommand node wajib
error-local-subcommand-required = subcommand local wajib
error-unsupported-node-subcommand = subcommand node tidak didukung: { $command }
error-unsupported-local-subcommand = subcommand local tidak didukung: { $command }
error-expected-kv = argumen key=value diharapkan, didapat { $arg }
error-missing-required-arg = argumen wajib hilang: { $key }
error-missing-required-arg-one-of = argumen wajib hilang: salah satu dari { $keys }
error-parsing-command = mengurai perintah
error-edit-form-lost-target = formulir edit kehilangan node tujuan
error-task-already-running = tugas latar sudah berjalan
error-task-thread-launch = gagal memulai utas tugas latar: { $error }
error-task-disconnected = utas tugas latar terputus sebelum mengirim hasil
error-task-kind-missing = utas tugas latar terputus tetapi active_task_kind adalah None: keadaan tak terduga
error-serve-exited = serve keluar dengan kesalahan: { $error }
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
summary-title = Ringkasan operasi
summary-kind = Jenis
summary-status = keadaan
summary-duration = Durasi
summary-duration-ms = { $ms }ms
summary-peer = rekan
summary-ae = AE
summary-criteria = Kriteria
summary-counts = Jumlah
summary-failures = Kegagalan:
summary-logs = Log:
summary-unserializable = <tidak dapat diserialkan>
summary-log-lines = baris { $start }-{ $end }
