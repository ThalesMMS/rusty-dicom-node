# Fluent catalog (tr-TR). Message IDs are hyphenated identifiers
# (cli-about, tui-pane-remote-nodes, desktop-nav-dashboard, error-import-file-too-large).
# Dotted names are Fluent attributes (message + .attr), not message IDs.
# Do not translate DICOM tokens (C-FIND, C-MOVE, C-STORE, SOP, AE, UID) or JSON/CSV machine keys.


## CLI
cli-about = dicom-rs ile yapılmış, önceliği terminal olan DICOM düğüm istemcisi
cli-arg-accession-number = Accession numarasına göre süz (büyük/küçük harf duyarsız alt dize).
cli-arg-ae-title = Application Entity title
cli-arg-destination-node = Hedef düğüm adı veya id
cli-arg-duplicate = Çift kayıt durumuna göre süz.
cli-arg-export = Sonuçları JSON veya CSV olarak dışa aktar.
cli-arg-host = Ana makine adı veya IP
cli-arg-imported-at =
    İçe aktarma zamanına göre süz. VALUE, START..END, ..END, START... desteklenir.
    Sözlüksel karşılaştırma (önerilen biçim: RFC3339).
cli-arg-json = İşlemin nihai özetini JSON olarak yaz (kararlı şema).
cli-arg-level = Sorgulama/geri getirme düzeyi
cli-arg-metrics-json = Sunucu çıkarken bellek içi metrik anlık görüntüsünü JSON olarak yazdır.
cli-arg-modality = Modaliteye göre süz. Virgülle ayrılmış liste (ör. CT,MR).
cli-arg-model = Sorgulama/geri getirme bilgi modeli
cli-arg-move-destination = Tercih edilen C-MOVE hedef AE title
cli-arg-name = Düğümün görünen adı
cli-arg-node = Kayıtlı düğüm adı veya id
cli-arg-notes = Serbest notlar
cli-arg-out = Çıktı dosyası yolu. Belirtilmezse stdout'a yazar.
cli-arg-path = İçe aktarılacak dosya veya dizin
cli-arg-patient-id = Hasta kimliğine göre süz (büyük/küçük harf duyarsız alt dize).
cli-arg-patient-name = Hasta adına göre süz (büyük/küçük harf duyarsız alt dize).
cli-arg-port = port numarası
cli-arg-series-description = Seri açıklamasına göre süz (büyük/küçük harf duyarsız alt dize).
cli-arg-series-instance-uid = Series Instance UID
cli-arg-sop-instance-uid = SOP Instance UID
cli-arg-source-path = Kaynak yoluna göre süz (büyük/küçük harf duyarsız alt dize).
cli-arg-study-date =
    Çalışma tarihine göre süz. VALUE, START..END, ..END, START... desteklenir.
    Tarihler sözlüksel karşılaştırılır (önerilen biçim: YYYYMMDD).
cli-arg-study-date-from = Çalışma tarihi alt sınırı (YYYYMMDD)
cli-arg-study-date-to = Çalışma tarihi üst sınırı (YYYYMMDD)
cli-arg-study-description = Çalışma açıklamasına göre süz (büyük/küçük harf duyarsız alt dize).
cli-arg-study-instance-uid = Study Instance UID
cli-cmd-import-about = Bir yoldan DICOM dosyalarını içe aktar
cli-cmd-local-about = Yerel arşivi incele
cli-cmd-local-series-about = Bir çalışmanın dizine alınmış serilerini listele
cli-cmd-local-studies-about = Dizine alınmış yerel çalışmaları listele
cli-cmd-node-about = Kayıtlı uzak DICOM düğümlerini yönet
cli-cmd-node-add-about = Uzak düğüm ekle
cli-cmd-node-delete-about = Kayıtlı düğümü sil
cli-cmd-node-edit-about = Kayıtlı düğümü düzenle
cli-cmd-node-list-about = Kayıtlı düğümleri listele
cli-cmd-query-about = Uzak düğümü sorgula (C-FIND)
cli-cmd-retrieve-about = Uzak düğümden geri getir (C-MOVE)
cli-cmd-send-about = Yerel çalışmaları veya serileri gönder (C-STORE)
cli-cmd-send-series-about = Bir seriyi hedef düğüme gönder
cli-cmd-send-study-about = Bir çalışmayı hedef düğüme gönder
cli-cmd-serve-about = DICOM sunucusunu çalıştır
cli-cmd-storage-scp-about = Storage SCP dinleyicisini çalıştır
cli-cmd-tui-about = Etkileşimli terminal arayüzünü aç
cli-flag-help = Yardımı göster
cli-flag-lang = Arayüz dili (BCP-47 etiketi). DICOM_NODE_LANG, kayıtlı yerel ayar ve işletim sistemi yerel ayarını geçersiz kılar.
cli-flag-version = Sürümü göster
cli-heading-arguments = Argümanlar:
cli-heading-commands = Komutlar:
cli-heading-options = Seçenekler:
cli-heading-usage = Kullanım:
cli-import-accepted = accepted={ $n }
cli-import-complete = İçe aktarma tamam
cli-import-duplicates = duplicates={ $n }
cli-import-scanned = scanned={ $n }
cli-msg-cancel-sigint = İptal istendi (SIGINT). Düzgün kapanma bekleniyor...
cli-msg-failures = hatalar:
cli-msg-import-failed = İçe aktarma başarısız: { $error }
cli-msg-no-local-series = { $uid } çalışması için dizine alınmış seri yok
cli-msg-no-local-studies = Dizine alınmış yerel çalışma yok
cli-msg-no-saved-nodes = Kayıtlı düğüm yok
cli-msg-query-failed = Sorgu başarısız: { $error }
cli-msg-removed-nodes =
    Silindi { $count ->
        [one] { $count } düğüm
       *[other] { $count } düğüm
    }
cli-msg-results-count =
    Sonuçlar: { $count ->
        [one] { $count } eşleşme
       *[other] { $count } eşleşme
    }
cli-msg-retrieve-failed = Geri getirme başarısız: { $error }
cli-msg-saved-node = Düğüm kaydedildi { $name } [{ $id }] => { $ae }@{ $host }:{ $port }
cli-msg-send-failed = Gönderme başarısız: { $error }
cli-msg-showing-failures = ({ $total } hatanın ilk { $shown } tanesi gösteriliyor)
cli-msg-starting-server =
    DICOM sunucusu başlatılıyor: { $count ->
        [one] { $count } yerel AE
       *[other] { $count } yerel AE
    }: { $aes }
cli-msg-starting-server-no-aes = Yapılandırılmış yerel AE olmadan DICOM sunucusu başlatılıyor
cli-msg-starting-storage-scp = { $addr } üzerinde AE title { $ae } ile Storage SCP başlatılıyor
cli-msg-updated-node = Düğüm güncellendi { $name } [{ $id }] => { $ae }@{ $host }:{ $port }
cli-send-attempted = attempted={ $n }
cli-send-failed-count = failed={ $n }
cli-send-sent = sent={ $n }
cli-value-name-file = FILE
cli-value-name-format = FORMAT
cli-value-name-locale = LOCALE
cli-value-name-path = PATH
tui-detail-more-series =
    ... { $n ->
        [one] { $n } seri daha
       *[other] { $n } seri daha
    }
tui-row-instance-count =
    { $n ->
        [one] { $n } örn.
       *[other] { $n } örn.
    }
tui-row-study-counts = { $series }s/{ $instances }i
count-nodes =
    { $n ->
        [one] { $n } düğüm
       *[other] { $n } düğüm
    }
count-instances =
    { $n ->
        [one] { $n } örnek
       *[other] { $n } örnek
    }
count-series =
    { $n ->
        [one] { $n } seri
       *[other] { $n } seri
    }
count-studies =
    { $n ->
        [one] { $n } çalışma
       *[other] { $n } çalışma
    }
format-datetime = { $date } { $time }
format-date = { $day }.{ $month }.{ $year }

## Common
common-accession = Kabul no.
common-add = Ekle
common-back = Geri
common-bytes = Bayt
common-cancel = İptal
common-clear = Temizle
common-close = Kapat
common-date = Tarih
common-delete = Düğümü sil
common-description = Açıklama
common-disabled = devre dışı
common-duplicates = Yinelenenler
common-edit = Düzenle
common-enabled = etkin
common-error = Hata
common-filter = Filtre
common-host = ana makine
common-import = İçe aktar
common-instance = Örnek
common-language = Dil
common-loading = Yükleniyor
common-matches = Eşleşmeler
common-modality = Modalite
common-name = Ad
common-network = Ağ
common-no = hayır
common-none = yok
common-notes = Notlar
common-optional = isteğe bağlı
common-path = Kaynak
common-patient = Hasta
common-patient-id = Hasta kimliği
common-patient-name = Hasta adı
common-port = port numarası
common-query = Sorgula
common-refresh = Yenile
common-required = zorunlu
common-retrieve = Getir
common-save = Kaydet
common-search = Ara
common-send = Gönder
common-series = Seriler
common-start = Başlat
common-status = Durum
common-stop = Durdur
common-studies = Çalışmalar
common-study = Çalışma
common-unknown = bilinmiyor
common-unknown-series = <Seriler>
common-unknown-study = <Çalışmalar>
common-yes = evet

## Errors
error-ae-empty = AE title boş olamaz
error-ae-invalid-char = AE title geçersiz karakter içeriyor '{ $character }'; izin verilen: A-Z, 0-9, boşluk
error-ae-required = AE title zorunlu
error-ae-too-long = AE title en fazla 16 karakter olmalıdır
error-ae-whitespace = AE title başında veya sonunda boşluk olamaz
error-archive-patient-retrieve-out-of-scope = Patient düzeyi retrieve kapsam dışıdır
error-archive-retrieve-uid-required = bu retrieve düzeyi için { $name } gerekli
error-archive-study-root-patient-query = Study Root sorguları Patient düzeyini desteklemez
error-archive-study-root-patient-retrieve = Study Root retrieve Patient düzeyini desteklemez
error-assoc-negotiation-failed = { $name } ({ $addr }) ile association müzakeresi başarısız; ipucu: called AE title, presentation contexts/transfer syntaxes ve karşı tarafın association kabul ettiğini doğrulayın
error-assoc-no-addresses = { $name } için { $host }:{ $port } üzerinde yuva adresi çözümlenemedi
error-assoc-receive = association alma
error-assoc-resolving = { $name } { $host }:{ $port } üzerinde çözümleniyor: { $err }
error-assoc-timeout = DIMSE yanıtı beklerken zaman aşımı; ipucu: ağı, AE title/host/port ve karşı tarafın yanıtını kontrol edin
error-assoc-transport = DIMSE yanıtı beklerken aktarım kesildi; ipucu: karşı taraf bağlantıyı kapattı veya bir ağ cihazı sıfırladı
error-assoc-unreachable = { $seconds }s içinde { $name } [{ $ae }] { $host }:{ $port } adresine ulaşılamadı: { $err }. Host/IP, port ve ağ erişimini kontrol edin
error-cancel-sigint = İptal istendi (SIGINT). Düzgün kapanma bekleniyor...
error-config-must-be-positive = geçersiz yapılandırma: { $name } > 0 olmalı (veya kapatmak için null)
error-config-duplicate-bind-port = geçersiz yapılandırma: yinelenen yerel AE bind bağlantı noktası { $port }
error-config-local-ae-max-assoc = geçersiz yapılandırma: yerel AE { $title } max_concurrent_associations > 0 olmalı
error-config-local-ae-no-services = geçersiz yapılandırma: yerel AE { $title } en az bir hizmeti etkinleştirmeli
error-config-must-be-positive-required = geçersiz yapılandırma: { $name } > 0 olmalı
error-dicom-meta-incomplete = DICOM file meta eksik
error-dicom-patient-move-unsupported = bu istemci hasta düzeyinde C-MOVE desteklemiyor
error-dicom-required-attribute = zorunlu DICOM özniteliği eksik: ({ $group },{ $element })
error-dicom-series-uid-required-image = görüntü düzeyi retrieve için series_instance_uid gerekli
error-dicom-series-uid-required-series = seri düzeyi retrieve için series_instance_uid gerekli
error-dicom-sop-uid-required-image = görüntü düzeyi retrieve için sop_instance_uid gerekli
error-dicom-study-uid-required = study_instance_uid gerekli
error-dicom-validating-move = move isteği doğrulanıyor
error-export-creating-file = dışa aktarma dosyası oluşturuluyor { $path }: { $err }
error-export-flushing-series-csv = seriler CSV boşaltılıyor: { $err }
error-export-flushing-studies-csv = çalışmalar CSV boşaltılıyor: { $err }
error-export-serializing-series-json = seriler JSON serileştiriliyor: { $err }
error-export-serializing-studies-json = çalışmalar JSON serileştiriliyor: { $err }
error-export-writing-series-csv-header = seriler CSV başlığı yazılıyor: { $err }
error-export-writing-series-csv-row = seriler CSV satırı yazılıyor: { $err }
error-export-writing-studies-csv-header = çalışmalar CSV başlığı yazılıyor: { $err }
error-export-writing-studies-csv-row = çalışmalar CSV satırı yazılıyor: { $err }
error-import-cleanup-failed = { $source }: temizlik başarısız: { $reason }
error-import-corrupt-zip = Bozuk ZIP: { $details }
error-import-dicom-parse-failed = DICOM ayrıştırması başarısız: { $err }
error-import-dicom-validation-failed = DICOM doğrulaması başarısız: { $err }
error-import-duplicate-zip-path = ZIP, '{ $path }' yolunu hedefleyen birden fazla girdi içeriyor
error-import-file-too-large = dosya çok büyük: { $details }
error-import-invalid-dicom = Geçersiz DICOM: { $details }
error-import-limit-exceeded = { $limit } aşıldı: { $details }
error-import-not-regular-file = düzenli bir dosya değil
error-import-opening-file = dosya açılıyor: { $err }
error-import-opening-kind = { $kind } { $path } açılıyor
error-import-opening-staged-file = hazırlanan dosya açılıyor: { $err }
error-import-opening-zip-archive = ZIP arşivi açılıyor { $path }
error-import-opening-zip-entry = ZIP girdisi açılıyor: { $err }
error-import-opening-zip-file = ZIP içe aktarma dosyası açılıyor { $path }
error-import-path-does-not-exist = İçe aktarma yolu yok: { $path }
error-import-reading-directory = içe aktarma dizini okunuyor { $path }
error-import-reading-file = dosya okunuyor: { $err }
error-import-reading-file-metadata = { $path } için dosya üst verisi okunuyor
error-import-reading-metadata = { $kind } { $path } için üst veri okunuyor
error-import-reading-zip-entry = ZIP girdisi okunuyor: { $err }
error-import-removing-staged-after-cancel = iptalden sonra hazırlanan dosya kaldırılıyor { $path }
error-import-skipped = { $source }: atlandı: { $reason }
error-import-unreadable = Okunamayan dosya: { $details }
error-import-unsafe-zip-path = girdi yolu arşivden çıkıyor
error-import-zip-entry-count-exceeded = ZIP girdi sayısı sınırı aşıldı: arşivde { $count } girdi var, sınır { $limit }
error-import-zip-entry-size-exceeded = ZIP girdi boyutu { $size } sınırı { $limit } aşıyor
error-import-zip-total-bytes-exceeded = ZIP çıkarılan toplam bayt sınırı aşıldı: mevcut toplam { $current } artı girdi boyutu { $entry } sınırı { $limit } aşıyor
error-net-binding-storage-scp = { $addr } üzerinde AE { $ae } için Storage SCP bağlanıyor. Başka bir yerel DICOM alıcısı bu portu kullanıyor olabilir. { $config } içinde storage_scp_port/local_aes değerlerini güncelleyin veya çakışan dinleyiciyi durdurun
error-net-building-file-meta = file meta tablosu oluşturuluyor
error-net-cannot-send-transfer-syntax = kaynak transfer syntax { $source }, anlaşılan { $negotiated } ile gönderilemez
error-net-cget-dataset-empty = kodlanmış C-GET C-STORE veri kümesi boş
error-net-cget-dataset-odd-length = kodlanmış C-GET C-STORE veri kümesi tek uzunlukta bir parçayla bitti
error-net-cget-peer-released = eş C-GET sırasında birlikteliği serbest bıraktı
error-net-cget-store-unexpected-dataset = beklenmeyen dataset fragment in C-GET C-STORE response
error-net-cget-unexpected-command = beklenmeyen command 0x{ $command } while waiting for C-STORE-RSP
error-net-cget-unexpected-pdu = beklenmeyen PDU during C-GET C-STORE suboperation: { $pdu }
error-net-creating-incoming-dir = Storage SCP .incoming dizini oluşturuluyor
error-net-creating-path = { $path } oluşturuluyor
error-net-dataset-empty = kodlanmış veri kümesi boş ancak COMMAND_DATA_SET_TYPE veri kümesi gerektiğini belirtiyor
error-net-dataset-odd-length = kodlanmış veri kümesi tek uzunlukta bir parçayla bitti
error-net-dimse-failed = { $operation } 0x{ $status } ({ $meaning }) durumuyla başarısız{ $hint }
error-net-establishing-assoc = Storage SCP birlikteliği kuruluyor
error-net-file-meta-length = okuma File Meta Information length
error-net-file-meta-tag = okuma File Meta Information tag
error-net-file-meta-value = File Meta Information değeri atlanıyor
error-net-file-meta-vr = okuma File Meta Information VR
error-net-file-position = okuma file position
error-net-flushing-path = { $path } boşaltılıyor
error-net-flushing-temp-dataset = geçici veri kümesi dosyası boşaltılıyor
error-net-hint-suffix = ; ipucu: { $hint }
error-net-incomplete-command = eksik { $operation } command response
error-net-incomplete-identifier = eksik { $operation } response identifier
error-net-invalid-affected-sop = geçersiz { $operation } affected SOP class UID
error-net-invalid-status = geçersiz { $operation } status
error-net-listener-address = okuma storage SCP listener address
error-net-listener-nonblocking = dinleyici engellemesiz kipe ayarlanıyor
error-net-listener-port = okuma storage SCP listener port
error-net-local-aes-empty = Storage SCP başlatmak için local_aes en az bir AE içermelidir
error-net-locating-dataset = { $path } içinde veri kümesi aranıyor
error-net-malformed-dimse = malformed { $operation } DIMSE response: { $details }; ipucu: peer sent an geçersiz or beklenmeyen DIMSE command set
error-net-missing-affected-sop = eksik { $operation } affected SOP class UID
error-net-missing-command-field = eksik command field
error-net-missing-cstore-rsp-command-field = eksik C-STORE response command field
error-net-missing-cstore-rsp-status = eksik C-STORE response status
error-net-missing-destination = eksik C-MOVE destination
error-net-missing-dicm = eksik Part 10 DICM marker
error-net-missing-message-id = eksik { $operation } message id
error-net-missing-qr-level = { $operation } identifier is eksik QueryRetrieveLevel
error-net-missing-required-command-field = eksik required command field { $name } ({ $tag })
error-net-missing-status = eksik { $operation } status
error-net-move-destination-unresolved = move_destination çözümlenemedi
error-net-no-cget-store-context = SOP Class { $sop } ve transfer syntax { $syntax } için anlaşılan C-GET depolama presentation context yok
error-net-no-compatible-context = { $path }: kaynak transfer syntax { $syntax } için uyumlu anlaşılan presentation context yok
error-net-no-dimse-provider = 0x{ $command } komutu ve abstract syntax { $syntax } için kayıtlı DIMSE sağlayıcısı yok
error-net-no-presentation-context = anlaşılan presentation context yok
error-net-no-presentation-context-for-file = { $path }: anlaşılan presentation context yok
error-net-no-presentation-context-id = eksik negotiated presentation context { $id }
error-net-opening-path = açma { $path }
error-net-part10-preamble = okuma Part 10 preamble
error-net-path-error = { $path }: { $err }
error-net-pdata-feed-complete = cannot feed P-DATA fragment into a complete accumulator (eksik take())
error-net-peer-aborted = eş C-GET C-STORE alt işlemi sırasında birlikteliği kesti: { $source }
error-net-peer-socket = okuma storage SCP peer socket address
error-net-reading-command-dataset = okuma command dataset
error-net-reading-identifier = okuma { $operation } identifier
error-net-reading-incoming-dataset = okuma incoming C-STORE dataset
error-net-reading-response-dataset = okuma { $operation } response dataset
error-net-remote-aborted = uzak taraf birlikteliği kesti: { $source }
error-net-restoring-read-timeout = association okuma zaman aşımı geri yükleniyor
error-net-restoring-write-timeout = association yazma zaman aşımı geri yükleniyor
error-net-rewinding-dataset = veri kümesinin ilk öğesine sarılıyor
error-net-scp-thread-panicked = Storage SCP iş parçacığı panikledi
error-net-seeking-temp-dataset = geçici veri kümesi dosyasında konumlanıyor
error-net-serializing-cget-dataset = { $path } için C-GET alt işlem veri kümesi serileştiriliyor
error-net-serializing-dataset = { $path } veri kümesi transfer syntax { $syntax } ile serileştiriliyor
error-net-setting-socket-blocking = kabul edilen depolama yuvası engelleyici kipe ayarlanıyor
error-net-sending-buffered-dataset = { $path } için tamponlanmış veri kümesi gönderiliyor
error-net-store-status = uzak taraf C-STORE durumu 0x{ $status } ({ $meaning }) döndürdü{ $hint }
error-net-streaming-dataset = C-STORE veri kümesi aktarılıyor
error-net-unexpected-command-field = beklenmeyen CommandField 0x{ $actual } (expected 0x{ $expected } for { $rsp })
error-net-unexpected-dataset-fragment = beklenmeyen dataset fragment in C-STORE response
error-net-unexpected-pdu = beklenmeyen PDU during { $operation }: { $pdu }
error-net-unknown-status = geçersiz { $operation } status 0x{ $status }
error-net-unsupported-model-sop = desteklenmiyor { $operation } model SOP class UID: { $uid }
error-net-unsupported-qr-level = desteklenmiyor QueryRetrieveLevel: { $level }
error-net-unsupported-transfer-syntax = desteklenmiyor negotiated transfer syntax
error-net-writing-command-dataset = yazma command dataset
error-net-writing-identifier = yazma { $operation } identifier
error-net-writing-path = yazma { $path }
error-net-writing-response-dataset = yazma { $operation } response dataset
error-net-writing-temp-dataset = yazma dataset bytes to temp file
error-node-host-empty = düğüm host değeri boş olamaz
error-node-name-empty = düğüm adı boş olamaz
error-node-not-found = uzak düğüm bulunamadı: { $id }
error-operation-cancelled = işlem iptal edildi
error-port-invalid = geçersiz port: { $value }
error-port-range = port 1 ile 65535 arasında olmalıdır
error-query-no-study-uid = Eşleşmede StudyInstanceUID yok; geri getirilemez.
error-query-unsupported-level = desteklenmeyen sorgu düzeyi: { $value }
error-query-unsupported-model = desteklenmeyen sorgu modeli: { $value }
error-retrieve-canceled = retrieve uzak düğüm tarafından iptal edildi (status=0x{ $status }, completed={ $completed }, failed={ $failed }, warning={ $warning }, remaining={ $remaining }, { $scp })
error-retrieve-failed = retrieve status=0x{ $status } ile başarısız oldu (completed={ $completed }, failed={ $failed }, warning={ $warning }, remaining={ $remaining }, { $scp })
error-retrieve-nothing-arrived = { $destination } hedefi için retrieve completed={ $completed } ile bitti ancak yerel Storage SCP ({ $scp }) hiçbir şey almadı. AE eşlemesini veya portu kontrol edin: { $listener } boş olmalı ve uzak düğüm AE { $destination } değerini bu uygulamaya eşlemeli
error-send-no-files-series = seri { $uid } için dizine alınmış yerel dosya yok
error-send-no-files-study = çalışma { $uid } için dizine alınmış yerel dosya yok
error-task-cancelled = Görev iptal edildi
error-task-none-to-cancel = İptal edilecek etkin görev yok (çalışan yok)
error-tracing-init = tracing subscriber başlatılıyor: { $err }
error-uid-component-numeric = UID bileşeni '{ $part }' sayısal olmalı
error-uid-component-too-long = UID bileşeni '{ $part }' çok uzun
error-uid-dot-ends = UID nokta ile başlayamaz veya bitemez
error-uid-empty = UID boş olamaz
error-uid-empty-component = UID boş bileşen içeremez
error-uid-leading-zeros = UID bileşeni '{ $part }' başında sıfır bulunduramaz
error-uid-too-long = UID en fazla 64 karakter olabilir

## TUI
tui-bool-no = hayır
tui-bool-off = kapalı
tui-bool-on = açık
tui-bool-yes = evet
tui-command-placeholder = Bir komut yazın veya panel kısayollarını kullanın.
tui-config-ae-title = AE title: { $value }
tui-config-edit-hint = Bu bölmeye odaklanmak için Tab’a, düzenlemek için 'c'ye basın.
tui-config-hint = Bu bölmeye odaklanmak için Tab’a, düzenlemek için 'c'ye basın.
tui-config-listener = Dinleyici: { $value }
tui-config-max-pdu = max_pdu_length: { $value }
tui-config-promiscuous = allow_promiscuous_storage: { $value }
tui-config-strict-pdu = strict_pdu: { $value }
tui-config-ts-pref = TS tercihi: { $value }
tui-controls-hint = Tab alanlar · Enter onaylar · Esc iptal
tui-detail-ae-title = AE Title
tui-detail-instance = Örnek ayrıntısı
tui-detail-name = Ad
tui-detail-node = Düğüm ayrıntısı
tui-detail-placeholder-followup = Odağı bir liste bölmesine taşıyın ve bu görünümü güncellemek için seçimi değiştirin.
tui-detail-query = Sorgu sonucu ayrıntısı
tui-detail-select-node = Metaverilerini incelemek için uzak bir düğüm seçin.
tui-detail-series = Seri ayrıntısı
tui-detail-study = Çalışma ayrıntısı
tui-empty-command-placeholder = Bir komut yazın veya panel kısayollarını kullanın.
tui-empty-detail-instance = İncelemek için bir örnek seçin veya Esc ile serilere dönün.
tui-empty-detail-node = Metaverilerini incelemek için uzak bir düğüm seçin.
tui-empty-detail-query = Retrieve bağlamını ve üst veriyi incelemek için bir sorgu sonucu seçin.
tui-empty-detail-series = İncelemek için bir seri seçin veya Esc ile çalışmalara dönün.
tui-empty-detail-study = Hasta ve seri üst verisini görmek için yerel bir çalışma seçin.
tui-empty-instances = Bu seri için dizine alınmış örnek yok.
tui-empty-instances-hint = Serilere dönmek için Esc'e basın.
tui-empty-local-instances = Bu seri için dizine alınmış örnek yok.
tui-empty-local-instances-hint = Serilere dönmek için Esc'e basın.
tui-empty-local-series = Bu çalışma için dizine alınmış seri yok.
tui-empty-local-series-hint = Yerel çalışmalara dönmek için Esc'e basın.
tui-empty-local-studies = Dizine alınmış çalışma yok.
tui-empty-local-studies-cmd = Örnek: import path=/data/inbox
tui-empty-local-studies-hint = Önce yerel DICOM dosyalarını içe aktarın.
tui-empty-no-name = <ad yok>
tui-empty-query = Henüz sorgu çalıştırılmadı.
tui-empty-query-body =
    Uzak bir düğüm seçin ve sorgulamak için 'f' tuşuna basın.
    Veya: query node=pacs
        patient_name="DOE^JOHN"
    Seçili sonuçta retrieve açmak için 'm' tuşuna basın.
tui-empty-query-cmd = Veya: query node=pacs
tui-empty-query-hint = Uzak bir düğüm seçin ve sorgulamak için 'f' tuşuna basın.
tui-empty-query-last-target = Son sorgu hedefi: { $name }
tui-empty-query-none = Henüz sorgu çalıştırılmadı.
tui-empty-query-retrieve-hint = Seçili sonuçta retrieve açmak için 'm' tuşuna basın.
tui-empty-remote-nodes = Kayıtlı uzak düğüm yok.
tui-empty-remote-nodes-cmd = Veya: node add name=pacs
tui-empty-remote-nodes-hint = Eklemek için bu panelde 'a'ya basın.
tui-empty-series = Bu çalışma için dizine alınmış seri yok.
tui-empty-series-hint = Yerel çalışmalara dönmek için Esc'e basın.
tui-empty-studies = Dizine alınmış çalışma yok.
tui-empty-studies-hint = Önce yerel DICOM dosyalarını içe aktarın.
tui-empty-tasks-history = Görev geçmişi yok.
tui-empty-tasks-queued = Kuyrukta görev yok.
tui-fallback-no-name = <ad yok>
tui-field-accession = Accession numarası
tui-field-ae-title = AE title
tui-field-bind-addr = Bind adresi
tui-field-date-from = Başlangıç tarihi
tui-field-date-to = Bitiş tarihi
tui-field-destination-node = Hedef düğüm
tui-field-host = ana makine
tui-field-instance-uid = Instance UID
tui-field-kind = Tür
tui-field-level = Düzey
tui-field-local-ae = Yerel AE
tui-field-max-pdu = Maks. PDU
tui-field-modality = Modalite
tui-field-model = model
tui-field-move-destination = Move hedefi
tui-field-name = Ad
tui-field-notes = Notlar
tui-field-path = Yol
tui-field-patient-id = Hasta kimliği
tui-field-patient-name = Hasta adı
tui-field-port = port numarası
tui-field-promiscuous = Ayrımsız
tui-field-series-uid = Series UID
tui-field-sop-uid = SOP Instance UID
tui-field-strict-pdu = Katı PDU
tui-field-study-description = Çalışma açıklaması
tui-field-study-uid = Study UID
tui-footer-back-series = Esc serilere
tui-footer-back-studies = Esc çalışmalara
tui-footer-cancel-task = c iptal
tui-footer-edit-config = c yapılandırmayı düzenle
tui-footer-enter-series = Enter seriler
tui-footer-esc-series = Esc serilere
tui-footer-esc-studies = Esc çalışmalara
tui-footer-help = F1/? yardım
tui-footer-inspect = Enter incele
tui-footer-next = Sonraki: { $text }
tui-footer-nodes = a/e/d/f düğüm
tui-footer-panes = Tab paneller
tui-footer-queued =
    { $n ->
        [one] { $n } kuyrukta
       *[other] { $n } kuyrukta
    }
tui-footer-quit = q çık
tui-footer-refresh = r yenile
tui-footer-retrieve = m getir
tui-footer-run-command = Enter komutu çalıştır
tui-footer-task-scope = t kuyruk/geçmiş
tui-form-add-node = Uzak düğüm ekle
tui-form-add-remote-node = Uzak düğüm ekle
tui-form-delete-confirm = Uzak düğüm { $name } [{ $ae }] ({ $host }:{ $port }) silinsin mi?
tui-form-delete-node = Uzak düğümü sil
tui-form-delete-remote-node = Uzak düğümü sil
tui-form-edit-node = Uzak düğümü düzenle
tui-form-edit-remote-node = Uzak düğümü düzenle
tui-form-err-ae-required = ! AE title zorunlu
tui-form-err-bind-required = ! bind adresi zorunlu
tui-form-err-host-required = ! host zorunlu
tui-form-err-local-ae-invalid = ! geçersiz yerel AE title: { $err }
tui-form-err-local-ae-required = ! yerel AE title zorunlu
tui-form-err-modality-empty = modality boş olamaz
tui-form-err-move-dest-invalid = ! geçersiz move hedefi AE title: { $err }
tui-form-err-name-required = ! düğüm name is required
tui-form-err-port-required = ! port zorunlu
tui-form-err-uid-empty = UID boş olamaz
tui-form-err-uid-empty-component = UID boş bileşen içeremez
tui-form-error-line = Hata: { $error }
tui-form-field-accession = Accession numarası
tui-form-field-ae-title = AE title
tui-form-field-bind-addr = Bind adresi
tui-form-field-date-from = Başlangıç tarihi
tui-form-field-date-to = Bitiş tarihi
tui-form-field-dest-node = Hedef düğüm
tui-form-field-destination = Hedef AE
tui-form-field-host = ana makine
tui-form-field-instance-uid = SOP Instance UID
tui-form-field-kind = Tür
tui-form-field-level = Düzey
tui-form-field-local-ae = Yerel AE
tui-form-field-modality = Modalite
tui-form-field-model = model
tui-form-field-move-dest = Move hedefi
tui-form-field-name = Ad
tui-form-field-notes = Notlar
tui-form-field-path = Yol
tui-form-field-patient-id = Hasta kimliği
tui-form-field-patient-name = Hasta adı
tui-form-field-port = port numarası
tui-form-field-series-uid = Series Instance UID
tui-form-field-sop-uid = SOP Instance UID
tui-form-field-study-desc = Çalışma açıklaması
tui-form-field-study-uid = Study Instance UID
tui-form-field-uid = UID
tui-form-hint-bind = ipucu: genellikle 0.0.0.0 (tüm arabirimler) veya 127.0.0.1
tui-form-hint-local-ae = ipucu: en fazla 16 karakter (A-Z, 0-9, boşluk), örn. ARCHIVE_AE
tui-form-hint-move-dest = ipucu: isteğe bağlı; C-MOVE hedef AE title’ını geçersiz kılar
tui-form-hint-name = ipucu: kısa bir etiket (örn. PACS)
tui-form-import = Yerel dosyaları içe aktar
tui-form-import-local = Yerel dosyaları içe aktar
tui-form-import-local-files = Yerel dosyaları içe aktar
tui-form-mode-add = create a new uzak düğüm
tui-form-mode-edit = update the selected uzak düğüm
tui-form-query-node = Uzak düğümü sorgula
tui-form-query-remote-node = Uzak düğümü sorgula
tui-form-remote-node-line = Uzak düğüm: { $name } [{ $ae }] { $host }:{ $port }
tui-form-retrieve = Eşleşmeleri geri getir
tui-form-retrieve-matches = Eşleşmeleri geri getir
tui-form-send-series = Seriyi gönder
tui-form-send-study = Çalışmayı gönder
tui-form-storage-intro = Yerel Storage SCP ayarlarını düzenle (config.json dosyasına kaydedilir).
tui-form-storage-scp = Storage SCP ayarları
tui-form-storage-scp-settings = Storage SCP ayarları
tui-help-ae-title = AE title: { $value }
tui-help-aedf = a/e/d/f     Add, edit, delete, or query from the selected düğüm
tui-help-c = c           Storage SCP ayarlarını düzenle (odak Yapılandırma bölmesindeyken)
tui-help-canonical-names = Kanonik adlar '--' olmadan CLI bayraklarıyla eşleşir ve alt çizgi kullanır.
tui-help-close = Yardımı Esc, F1 veya ? ile kapatın.
tui-help-common-commands = Sık komutlar
tui-help-config = c           Storage SCP ayarlarını düzenle (odak Yapılandırma bölmesindeyken)
tui-help-config-path = Yapılandırma yolu: { $value }
tui-help-current-config = Geçerli yapılandırma
tui-help-data-dir = Veri dizini: { $value }
tui-help-enter-default = Enter       Run the command input, submit the active modal, or open series from Yerel çalışmalar
tui-help-enter-instance = Enter       Instance görünümünde yerel bölme eylemi yok
tui-help-enter-local-instance = Enter       Instance görünümünde yerel bölme eylemi yok
tui-help-enter-local-series = Enter       Seçili yerel serinin instancelarını aç, veya komut girişini çalıştır / etkin modalı gönder
tui-help-enter-local-study = Enter       Seçili yerel çalışmanın serilerini aç, veya komut girişini çalıştır / etkin modalı gönder
tui-help-enter-series = Enter       Seçili yerel serinin instancelarını aç, veya komut girişini çalıştır / etkin modalı gönder
tui-help-enter-study = Enter       Seçili yerel çalışmanın serilerini aç, veya komut girişini çalıştır / etkin modalı gönder
tui-help-esc-default = Esc         Yardımı/modalı kapat, yerel serilerden dön veya odağı komut girişine getir
tui-help-esc-instance = Esc         Yerel instancelardan serilere dön, yardımı/modalı kapat veya odağı komut girişine getir
tui-help-esc-instances = Esc         Yerel instancelardan serilere dön, yardımı/modalı kapat veya odağı komut girişine getir
tui-help-esc-series = Esc         Yerel serilerden çalışmalara dön, yardımı/modalı kapat veya odağı komut girişine getir
tui-help-f1 = F1 veya ?     Yardımı aç
tui-help-import-send = i/s         İçe aktar local files or send selected study/series
tui-help-is = i/s         İçe aktar local files or send selected study/series
tui-help-listener = Dinleyici: { $value }
tui-help-log-dir = Günlük dizini: { $value }
tui-help-m = m           Seçili sorgu sonucundan getir
tui-help-max-pdu = max_pdu_length: { $value }
tui-help-move = Yukarı/Aşağı veya j/k   Liste bölmelerinde seçimi taşı
tui-help-nodes = a/e/d/f     Add, edit, delete, or query from the selected düğüm
tui-help-open = F1 veya ?     Yardımı aç
tui-help-promiscuous = allow_promiscuous_storage: { $value }
tui-help-q = q           Modal yokken ve odak komut girişinde değilken çık
tui-help-quit = q           Modal yokken ve odak komut girişinde değilken çık
tui-help-r = r           Yenile panes when focus is hayırt in command input
tui-help-receiver-mode = Alıcı modu: { $value }
tui-receiver-mode-on-demand = yerel retrieve için isteğe bağlı
tui-receiver-mode-standalone = storage-scp ile bağımsız
tui-help-refresh = r           Yenile panes when focus is hayırt in command input
tui-help-retrieve = m           Seçili sorgu sonucundan getir
tui-help-strict-pdu = strict_pdu: { $value }
tui-help-tab = Tab / Shift-Tab  Odak bölmesini değiştir
tui-help-title = Kısayollar
tui-help-ts-pref = preferred_store_transfer_syntax: { $value }
tui-help-updown = Yukarı/Aşağı veya j/k   Liste bölmelerinde seçimi taşı
tui-input-placeholder = Bir komut yazın veya panel kısayollarını kullanın.
tui-log-command = > { $command }
tui-log-error = hata: { $error }
tui-log-refreshed = yenilendi
tui-logs-capped-suffix = sınırlı
tui-logs-label = Günlükler:
tui-pane-command = Komut
tui-pane-config = Yapılandırma
tui-pane-detail = Ayrıntı
tui-pane-detail-hint = { $title } (PgUp/PgDn yazılmıyorken)
tui-pane-help = Yardım
tui-pane-instance-detail = Örnek ayrıntısı
tui-pane-instances-for = Örnekler: { $uid }
tui-pane-local-studies = Yerel çalışmalar
tui-pane-logs = Günlük ({ $shown }/{ $total }{ $capped })
tui-pane-logs-capped = Günlükler ({ $shown }/{ $total } capped)
tui-pane-logs-uncapped = Günlükler ({ $shown }/{ $total })
tui-pane-node-detail = Düğüm ayrıntısı
tui-pane-query-detail = Sorgu sonucu ayrıntısı
tui-pane-query-node = Düğümü sorgula
tui-pane-query-result-detail = Sorgu sonucu ayrıntısı
tui-pane-query-results = Sorgulama / geri getirme sonuçları
tui-pane-query-retrieve-results = Sorgulama / geri getirme sonuçları
tui-pane-remote-nodes = Uzak düğümler
tui-pane-series-detail = Seri ayrıntısı
tui-pane-series-for = Seriler: { $uid }
tui-pane-series-unknown = Seriler: <bilinmeyen çalışma>
tui-pane-study-detail = Çalışma ayrıntısı
tui-pane-task-details = Görev ayrıntısı
tui-pane-tasks-history = Görevler (geçmiş)
tui-pane-tasks-queued = Görevler (kuyruk)
tui-pane-unknown-series = <bilinmeyen seri>
tui-pane-unknown-study = Seriler: <bilinmeyen çalışma>
tui-row-inst = inst
tui-status-cancel-requested = İptallation requested
tui-status-config = Yapılandırma
tui-status-configured-listener = Yapılandırılmış dinleyici { $addr } AE { $ae } ({ $mode }) olarak
tui-status-data = veri
tui-status-failure = hata: { $failure }
tui-status-listener = Dinleyici
tui-status-local-ae = Yerel AE
tui-status-mode = Mod
tui-status-mode-on-demand = isteğe bağlı
tui-status-mode-standalone = bağımsız
tui-status-no-active-task = Etkin görev yok to cancel (nothing running)
tui-status-pdu = PDU
tui-status-promiscuous = Ayrımsız
tui-status-query-before-retrieve = Query a uzak düğüm first so retrieve knows which düğüm to use
tui-status-query-failed = sorgu başarısız: { $error }
tui-status-queued-op = Kuyruktaki işlem: { $op }
tui-status-retrieve-failed = getirme başarısız: { $error }
tui-status-retrieve-open-failed = açılamadı retrieve stream: { $error }
tui-status-saved-node = saved düğüm { $name } ({ $id })
tui-status-saved-scp = Storage SCP ayarları kaydedildi (yeniden başlatma gerekli)
tui-status-select-node = önce uzak bir düğüm seçin
tui-status-select-query = önce bir sorgu sonucu seçin
tui-status-select-study = önce bir yerel çalışma seçin
tui-status-strict = Katı
tui-status-task-cancelled = Görev iptal edildi
tui-status-task-cancelled-detail = Görev iptal: { $other }
tui-status-ts-pref = TS tercihi
tui-status-updated-node = updated düğüm { $name } ({ $id })
tui-suggest-back-series = Esc — serilere dön
tui-suggest-edit-config = c — yapılandırmayı düzenle
tui-suggest-help = F1/? — yardım
tui-suggest-inspect-task = Enter — görevi incele
tui-suggest-node-add = node add <ae-title> <host:port>
tui-suggest-query = f — query a düğüm
tui-suggest-query-node = f — query selected düğüm
tui-suggest-retrieve = m — seçileni getir
tui-suggest-run-command = Enter — komutu çalıştır
tui-suggest-send-series = s — seçilen seriyi gönder
tui-suggest-view-series = Enter — serileri gör
tui-task-cancelled = İptal edildi
tui-task-cancelling = İptal ediliyor
tui-task-failed = Başarısız
tui-task-failed-generic = Görev başarısız: { $error }
tui-task-import-done = İçe aktar complete: { $report }
tui-task-import-failed = İçe aktarma başarısız: { $error }
tui-task-importing = { $path } içe aktarılıyor...
tui-task-query-done =
    Sorgu tamam: { $count ->
        [one] { $count } eşleşme
       *[other] { $count } eşleşme
    }
tui-task-query-failed = Sorgu başarısız: { $error }
tui-task-querying = { $node } sorgulanıyor...
tui-task-queued = Kuyrukta
tui-task-retrieve-done = Getirme tamam: { $outcome }
tui-task-retrieve-failed = Geri getirme başarısız: { $error }
tui-task-retrieving = { $node } üzerinden geri getiriliyor...
tui-task-running = Çalışıyor
tui-task-sending-series = { $uid } serisi { $node } düğümüne gönderiliyor...
tui-task-sending-study = { $uid } çalışması { $node } düğümüne gönderiliyor...
tui-task-send-done = Gönderme tamam: { $outcome }
tui-task-status-cancelled = iptal
tui-task-status-cancelling = iptal ediliyor
tui-task-status-failed = başarısız
tui-task-status-ok = ok
tui-task-status-queued = kuyrukta
tui-task-status-running = çalışıyor
tui-task-succeeded = Başarılı
tui-terminal-too-small = Terminal çok küçük, pencereyi büyütün

## Desktop
desktop-action-activity = Etkinlik { $count }
desktop-action-activity-empty = Etkinlik
desktop-action-import = İçe aktar
desktop-action-inspect-archive = Yerel arşivi incele
desktop-action-inspect-archive-desc = Çalışma, seri ve örnekleri inceleyin; ardından gönderin veya dışa aktarın.
desktop-action-manage-peers = Eşleri yönet
desktop-action-manage-peers-desc = Query, retrieve ve store için PACS veya iş istasyonu düğümlerini ekleyin ve düzenleyin.
desktop-action-monitor-scp = Storage SCP’yi izle
desktop-action-query = Sorgula
desktop-action-refresh = Durumu yenile
desktop-action-refresh-status = Durumu yenile
desktop-action-reveal-log = Günlük dosyasını göster
desktop-action-send = Gönder
desktop-action-start-scp = Storage SCP’yi başlat
desktop-activity-empty = Henüz oturum etkinliği yok.
desktop-activity-title = Etkinlik
desktop-app-title = DICOM Node
desktop-archive-csv = CSV
desktop-archive-details = Ayrıntılar
desktop-archive-empty = Yerel arşiv boş.
desktop-archive-export-fail = { $scope } dışa aktarma başarısız
desktop-archive-export-ok =
    { $rows ->
        [one] { $rows } { $scope } satırı { $path } konumuna aktarıldı.
       *[other] { $rows } { $scope } satırı { $path } konumuna aktarıldı.
    }
desktop-archive-export-studies = Çalışmaları dışa aktar
desktop-archive-export-title = { $scope } dışa aktar
desktop-archive-filter = Hasta, UID, açıklama, modaliteye göre süz…
desktop-archive-filter-placeholder = Hasta, UID, açıklama, modaliteye göre süz…
desktop-archive-inst-abbrev =
    { $count ->
        [one] { $count } örn.
       *[other] { $count } örn.
    }
desktop-archive-instance-meta = { $bytes } · TS { $ts } · içe aktarıldı { $imported }
desktop-archive-instances = Örnekler
desktop-archive-instances-heading = Örnekler
desktop-archive-json = JSON
desktop-archive-loading = Çalışmalar yükleniyor…
desktop-archive-no-filter-match = Süzgeçle eşleşen çalışma yok.
desktop-archive-no-instances = Örnek bulunamadı.
desktop-archive-no-match = Süzgeçle eşleşen çalışma yok.
desktop-archive-no-nodes = Düğüm yok
desktop-archive-no-series = Seri bulunamadı.
desktop-archive-reveal-file = Dosyayı göster
desktop-archive-select-series = Bir seri seçin.
desktop-archive-select-study = Bir çalışma seçin.
desktop-archive-send-fail = { $label }: { $sent }/{ $attempted } gönderildi, { $failed } başarısız. { $failures }
desktop-archive-send-fail-title = { $label } başarısız
desktop-archive-send-ok = { $label }: { $sent }/{ $attempted } örnek gönderildi.
desktop-archive-send-series = Seriyi gönder
desktop-archive-send-series-label = Seri → { $destination }
desktop-archive-send-study = Çalışmayı gönder
desktop-archive-send-study-label = Çalışma → { $destination }
desktop-archive-send-to = Gönder
desktop-archive-series = Seriler
desktop-archive-series-count =
    #{ $number } · { $count ->
        [one] { $count } örnek
       *[other] { $count } örnek
    }
desktop-archive-series-fallback = Seriler
desktop-archive-studies = Çalışmalar
desktop-archive-study-date = Çalışma tarihi
desktop-archive-study-uid = Study UID
desktop-archive-subtitle = Yerel SQLite arşivinden çalışma, seri ve örnek envanteri.
desktop-archive-title = Yerel arşiv
desktop-brand-title = DICOM Node
desktop-col-description = Açıklama
desktop-col-instances = Örnekler
desktop-col-modalities = Modaliteler
desktop-col-patient-id = Hasta kimliği
desktop-common-cancel = İptal
desktop-common-clear = Temizle
desktop-common-disabled = devre dışı
desktop-common-enabled = etkin
desktop-common-loading = Yükleniyor…
desktop-common-no = hayır
desktop-common-refresh = Yenile
desktop-common-yes = evet
desktop-counter-assoc-accepted = Kabul edilen birleşimler
desktop-counter-bytes-ingested = Alınan bayt
desktop-counter-cfind-requests = C-FIND istekleri
desktop-counter-cmove-requests = C-MOVE istekleri
desktop-counter-cstore-failed = C-STORE başarısız
desktop-counter-cstore-stored = C-STORE saklandı
desktop-dashboard-counter-assoc-accepted = Kabul edilen birleşimler
desktop-dashboard-counter-bytes-ingested = Alınan bayt
desktop-dashboard-counter-c-find-requests = C-FIND istekleri
desktop-dashboard-counter-c-move-requests = C-MOVE istekleri
desktop-dashboard-counter-c-store-failed = C-STORE başarısız
desktop-dashboard-counter-c-store-stored = C-STORE saklandı
desktop-dashboard-empty-studies = Henüz yerel çalışma yok.
desktop-dashboard-inspect-archive-body = Çalışmaları, serileri ve örnekleri gözden geçirin, sonra gönderin veya dışa aktarın.
desktop-dashboard-inspect-archive-title = Yerel arşivi incele
desktop-dashboard-kv-ae-title = AE başlığı
desktop-dashboard-kv-data-dir = Veri dizini
desktop-dashboard-kv-listener = Dinleyici
desktop-dashboard-kv-log-file = Günlük dosyası
desktop-dashboard-kv-max-pdu = Maks. PDU
desktop-dashboard-kv-promiscuous = Sınırsız depolama
desktop-dashboard-kv-server = Sunucu
desktop-dashboard-kv-store-syntax = Store sözdizimi
desktop-dashboard-kv-strict-pdu = Katı PDU
desktop-dashboard-listener-missing = Listener henüz yüklenmedi.
desktop-dashboard-live-counters = Canlı sayaçlar
desktop-dashboard-loading-metrics = Ölçümler yükleniyor…
desktop-dashboard-loading-status = Yerel durum yükleniyor…
desktop-dashboard-loading-studies = Çalışmalar yükleniyor…
desktop-dashboard-local-node = Yerel düğüm
desktop-dashboard-manage-peers-body = Sorgu, alma ve store için PACS veya iş istasyonu düğümleri ekleyin ve düzenleyin.
desktop-dashboard-manage-peers-title = Eşleri yönet
desktop-dashboard-metric-instances = Örnekler
desktop-dashboard-metric-nodes = Uzak düğümler
desktop-dashboard-metric-series = Seriler
desktop-dashboard-metric-studies = Çalışmalar
desktop-dashboard-monitor-scp = Storage SCP’yi izle
desktop-dashboard-recent-studies = Son çalışmalar
desktop-dashboard-start-scp = Storage SCP’yi başlat
desktop-dashboard-subtitle = Yerel arşiv, ağ eşleri ve SCP etkinliği bir bakışta.
desktop-dashboard-title = Operatör paneli
desktop-doc-title = DICOM Node
desktop-import-accepted = Kabul edilen
desktop-import-accepted-bytes = Kabul edilen bayt
desktop-import-activity-detail = { $accepted }/{ $scanned } kabul, { $duplicates } yinelenen, { $bytes }
desktop-import-activity-fail = İçe aktarma başarısız
desktop-import-activity-ok = İçe aktarma tamamlandı
desktop-import-choose-archive = İçe aktarılacak bir ZIP arşivi seçin
desktop-import-choose-dir = İçe aktarılacak bir dizin seçin
desktop-import-choose-folder = Klasör
desktop-import-choose-zip = İçe aktarılacak bir ZIP arşivi seçin
desktop-import-cleanup = Temizlik
desktop-import-clear-path = Yolu temizle
desktop-import-complete = İçe aktarma tamamlandı
desktop-import-dup-sha = SHA-256
desktop-import-dup-sop = SOP UID
desktop-import-dup-total = Toplam
desktop-import-duplicates = Yinelenenler
desktop-import-failed = İçe aktarma başarısız
desktop-import-failed-cleanup = Temizlik başarısız
desktop-import-failures = Hatalar
desktop-import-failures-heading =
    { $count ->
        [one] { $count } hata:
       *[other] { $count } hata:
    }
desktop-import-failures-more = … ve { $count } tane daha
desktop-import-files-progress = { $label } dosya
desktop-import-folder = Klasör
desktop-import-invalid-dicom = Geçersiz DICOM
desktop-import-pick-dir = İçe aktarılacak bir dizin seçin
desktop-import-pick-zip = İçe aktarılacak bir ZIP arşivi seçin
desktop-import-placeholder = /path/to/dicom-folder or /path/to/archive.zip
desktop-import-rejected = Reddedilen
desktop-import-report = İçe aktarma raporu
desktop-import-running = İçe aktarılıyor…
desktop-import-scanned = Taranan
desktop-import-skipped = Atlanan
desktop-import-source = Kaynak
desktop-import-start = İçe aktarmayı başlat
desktop-import-stored = Saklanan
desktop-import-subtitle = Özyinelemeli klasörlerden veya ZIP arşivlerinden DICOM dosyalarını yönetilen yerel arşive dizinleyin.
desktop-import-title = İçe aktar
desktop-import-unreadable = Okunamıyor
desktop-import-zip = ZIP
desktop-import-zip-filter = ZIP arşivleri
desktop-lang-label = Dil
desktop-listener-not-loaded = Listener henüz yüklenmedi.
desktop-live-counters = Canlı sayaçlar
desktop-loading = Yükleniyor
desktop-loading-local-status = Yerel durum yükleniyor…
desktop-loading-metrics = Ölçümler yükleniyor…
desktop-loading-studies = Çalışmalar yükleniyor…
desktop-local-node = Yerel düğüm
desktop-locale-label = Dil
desktop-logs-activity-detail =
    { $count ->
        [one] { $count } satır yüklendi
       *[other] { $count } satır yüklendi
    }
desktop-logs-activity-fail = Günlük yenileme başarısız
desktop-logs-activity-ok = Günlük yenilendi
desktop-logs-auto = OTO
desktop-logs-auto-refresh = Otomatik yenile
desktop-logs-empty = Günlük dosyası boş.
desktop-logs-found = GÜNLÜK DOSYASI BULUNDU
desktop-logs-lines =
    { $count ->
        [one] { $count } satır
       *[other] { $count } satır
    }
desktop-logs-loading = Günlük yükleniyor…
desktop-logs-missing = Etkin günlük dosyası henüz oluşturulmadı.
desktop-logs-refresh-failed = Günlük yenileme başarısız
desktop-logs-refreshed = Günlük yenilendi
desktop-logs-reveal = Göster
desktop-logs-subtitle = Etkin masaüstü günlük dosyasının sınırlı kuyruğu.
desktop-logs-tail = Kuyruk
desktop-logs-title = Günlükler
desktop-logs-truncated = KESİLDİ
desktop-logs-waiting = GÜNLÜK DOSYASI BEKLENİYOR
desktop-metric-instances = Örnekler
desktop-metric-remote-nodes = Uzak düğümler
desktop-metric-series = Seriler
desktop-metric-studies = Çalışmalar
desktop-nav-archive = Yerel arşiv
desktop-nav-dashboard = Panel
desktop-nav-import = İçe aktar
desktop-nav-logs = Günlükler
desktop-nav-network = Ağ
desktop-nav-nodes = Uzak düğümler
desktop-nav-query = Sorgu / alma
desktop-nav-server = Depolama sunucusu
desktop-no-local-studies = Henüz yerel çalışma yok.
desktop-nodes-add = Düğüm ekle
desktop-nodes-added = "{ $name }" düğümü eklendi.
desktop-nodes-ae-length = AE başlığı en fazla 16 karakter olmalıdır.
desktop-nodes-ae-title = AE başlığı
desktop-nodes-col-move = Move hedefi
desktop-nodes-configured = Yapılandırılmış düğümler
desktop-nodes-confirm-delete = "{ $name }" düğümü silinsin mi?
desktop-nodes-default-port = Varsayılan bağlantı noktası 104
desktop-nodes-delete = Düğümü sil
desktop-nodes-delete-title = Düğümü sil
desktop-nodes-deleted = "{ $name }" düğümü silindi.
desktop-nodes-edit = Düğümü düzenle
desktop-nodes-edit-title = Düğümü düzenle
desktop-nodes-empty = Henüz uzak düğüm yok.
desktop-nodes-err-ae = AE title gerekli.
desktop-nodes-err-ae-len = AE title en fazla 16 karakter olmalıdır.
desktop-nodes-err-host = Host gerekli.
desktop-nodes-err-name = Ad gerekli.
desktop-nodes-err-port = Port 1 ile 65535 arasında olmalıdır.
desktop-nodes-host = ana makine
desktop-nodes-move-dest = Move hedefi
desktop-nodes-move-placeholder = Varsayılan: yerel AE
desktop-nodes-name = Ad
desktop-nodes-need-ae = AE başlığı gerekli.
desktop-nodes-need-host = Ana bilgisayar gerekli.
desktop-nodes-need-name = Ad gerekli.
desktop-nodes-notes = Notlar
desktop-nodes-notes-placeholder = Rapor odası PACS
desktop-nodes-placeholder-ae = PACS01
desktop-nodes-placeholder-host = 192.168.0.10
desktop-nodes-placeholder-move = Varsayılan: yerel AE
desktop-nodes-placeholder-name = main-pacs
desktop-nodes-placeholder-notes = Rapor odası PACS
desktop-nodes-port = port numarası
desktop-nodes-port-104 = Varsayılan bağlantı noktası 104
desktop-nodes-port-range = Bağlantı noktası 1–65535 arasında olmalıdır.
desktop-nodes-save = Değişiklikleri kaydet
desktop-nodes-save-changes = Değişiklikleri kaydet
desktop-nodes-subtitle = Sorgu, alma ve store için PACS ve iş istasyonu eşleri.
desktop-nodes-summary = Düğüm özeti
desktop-nodes-title = Uzak düğümler
desktop-nodes-total = Toplam düğüm
desktop-nodes-updated = "{ $name }" düğümü güncellendi.
desktop-nodes-with-move = Move hedefi olan
desktop-promiscuous = Sınırsız depolama
desktop-query-accession = Accession no
desktop-query-activity-detail = { $count } { $count ->
        [one] eşleşme
       *[other] eşleşme
    } { $level } düzeyinde
desktop-query-activity-fail = C-FIND { $node } başarısız
desktop-query-activity-ok = C-FIND { $node }
desktop-query-activity-title = C-FIND { $node }
desktop-query-clear = Temizle
desktop-query-col-accession = kabul no
desktop-query-criteria = Arama ölçütleri
desktop-query-date-from = Çalışma tarihi başlangıç
desktop-query-date-to = Çalışma tarihi bitiş
desktop-query-kv-series-uid = Series UID
desktop-query-kv-sop-uid = SOP UID
desktop-query-kv-study-uid = Study UID
desktop-query-level = Düzey
desktop-query-matches =
    { $count ->
        [one] { $count } eşleşme
       *[other] { $count } eşleşme
    }
desktop-query-missing-study-uid = Eşleşmenin StudyInstanceUID’si yok; alınamaz.
desktop-query-modality = Modalite
desktop-query-no-matches = Eşleşme yok.
desktop-query-no-nodes = Yapılandırılmış düğüm yok
desktop-query-patient-id = Hasta kimliği
desktop-query-patient-name = Hasta adı
desktop-query-placeholder-description = CHEST*
desktop-query-placeholder-modality = CT, MR, …
desktop-query-placeholder-name = DOE^JOHN or DOE*
desktop-query-placeholder-patient = DOE^JOHN or DOE*
desktop-query-querying = Sorgulanıyor…
desktop-query-remote-node = Uzak düğüm
desktop-query-results = Sonuçlar
desktop-query-retrieve = Al
desktop-query-retrieve-activity-detail = completed={ $completed }, warning={ $warning }, failed={ $failed }
desktop-query-retrieve-activity-fail = C-MOVE { $node } başarısız
desktop-query-retrieve-activity-ok = C-MOVE { $node }
desktop-query-retrieve-finished = Alma bitti: tamamlanan { $completed }, uyarı { $warning }, başarısız { $failed }.
desktop-query-retrieve-selected = Seçileni al
desktop-query-run = C-FIND çalıştır
desktop-query-run-select = Bir sorgu çalıştırın ve bir eşleşme seçin.
desktop-query-running = Sorgulanıyor…
desktop-query-search-criteria = Arama ölçütleri
desktop-query-select-hint = Bir sorgu çalıştırın ve bir eşleşme seçin.
desktop-query-selected = Seçilen eşleşme
desktop-query-selected-match = Seçilen eşleşme
desktop-query-series-uid = Series Instance UID
desktop-query-sop-uid = SOP Instance UID
desktop-query-study-description = Çalışma açıklaması
desktop-query-study-uid = Study Instance UID
desktop-query-subtitle = Uzak düğüme C-FIND, eşleşmeleri inceleyin, sonra yerel arşive C-MOVE.
desktop-query-title = Sorgu / alma
desktop-recent-studies = Son çalışmalar
desktop-scp-listening = SCP dinliyor
desktop-scp-stopped = SCP durduruldu
desktop-server-activity-fail = Storage SCP denetimi başarısız
desktop-server-activity-started = Storage SCP başlatıldı
desktop-server-activity-started-detail = Listener başlatıldı.
desktop-server-activity-stopped = Storage SCP durduruldu
desktop-server-activity-stopped-detail = received={ $received }, stored={ $stored }, failed={ $failed }
desktop-server-activity-stopped-empty = Etkin oturum yok.
desktop-server-addr-ae = { $addr } · AE { $ae }
desktop-server-assoc-accepted = Kabul edilen birleşimler
desktop-server-assoc-rejected = Reddedilen birleşimler
desktop-server-cfind-req-matches = C-FIND istekleri / eşleşmeler
desktop-server-cget-requests = C-GET istekleri
desktop-server-cmove-requests = C-MOVE istekleri
desktop-server-cmove-subops = C-MOVE alt işlemleri tamamlandı / başarısız
desktop-server-control-failed = Storage SCP denetimi başarısız
desktop-server-counter-bytes = Alınan bayt
desktop-server-counter-failed = C-STORE başarısız
desktop-server-counter-find = C-FIND istekleri / eşleşmeler
desktop-server-counter-get = C-GET istekleri
desktop-server-counter-move = C-MOVE istekleri
desktop-server-counter-move-sub = C-MOVE alt işlemleri tamamlandı / başarısız
desktop-server-counter-received = C-STORE alındı
desktop-server-counter-stored = C-STORE saklandı
desktop-server-cstore-failed = C-STORE başarısız
desktop-server-cstore-received = C-STORE alındı
desktop-server-cstore-stored = C-STORE saklandı
desktop-server-dimse = DIMSE sayaçları
desktop-server-failed = Başarısız
desktop-server-health-loading = Ölçümler yükleniyor
desktop-server-health-ready = Gelen C-STORE için hazır
desktop-server-health-review = Hataları incele
desktop-server-health-stopped = Durduruldu
desktop-server-listener-started = Listener başlatıldı.
desktop-server-listening = DİNLİYOR
desktop-server-loading-metrics = Ölçümler yükleniyor…
desktop-server-logs = Günlükler
desktop-server-no-session = Etkin oturum yok.
desktop-server-rate = +{ $rate } / yoklama
desktop-server-ready = Gelen C-STORE için hazır
desktop-server-review-failures = Hataları incele
desktop-server-session-ended = Oturum bitti: alınan { $received }, saklanan { $stored }, başarısız { $failed }.
desktop-server-start = Sunucuyu başlat
desktop-server-started-title = Storage SCP başlatıldı
desktop-server-stop = Sunucuyu durdur
desktop-server-stopped = DURDURULDU
desktop-server-stopped-pill = DURDURULDU
desktop-server-stopped-status = Durduruldu
desktop-server-stopped-title = Storage SCP durduruldu
desktop-server-stored = Saklanan
desktop-server-subtitle = Gelen C-STORE ve yerel arşiv dizinleme için bağımsız Storage SCP.
desktop-server-title = Depolama sunucusu
desktop-status-listening = dinliyor
desktop-status-loading = Yükleniyor
desktop-status-scp-listening = SCP dinliyor
desktop-status-scp-stopped = SCP durduruldu
desktop-status-stopped = durduruldu
desktop-store-syntax = Store sözdizimi
desktop-strict-pdu = Katı PDU
desktop-strip-pdu = PDU { $value }
desktop-table-accession = Kabul no.
desktop-table-ae-title = AE title
desktop-table-date = Tarih
desktop-table-description = Açıklama
desktop-table-endpoint = Uç nokta
desktop-table-instances = Örnekler
desktop-table-modalities = Modaliteler
desktop-table-modality = Modalite
desktop-table-move-dest = Move hedefi
desktop-table-name = Ad
desktop-table-notes = Notlar
desktop-table-patient = Hasta
desktop-table-patient-id = Hasta kimliği
desktop-table-series = Seriler
desktop-table-updated = Güncellendi
desktop-title-refresh-status = Durumu yenile
desktop-title-reveal-log = Günlük dosyasını göster
ae = AE
patient-name =
    "DOE^JOHN"
    Seçili sonuçta retrieve açmak için 'm' tuşuna basın.
port = port numarası

## Summary
summary-ae = AE
summary-counts = Sayımlar
summary-criteria = Kriterler
summary-duration = Süre
summary-duration-ms = { $ms }ms
summary-failures = Hatalar:
summary-kind = Tür
summary-logs = Günlükler:
summary-peer = Eş
summary-status = Durum
summary-title = İşlem özeti
tui-detail-created = Oluşturuldu

tui-form-hint-port-range = ipucu: 1 ile 65535 arası bir sayı, örn. 104
tui-form-hint-promiscuous = ipucu: herhangi bir çağıran AE title’dan depolamaya izin ver
tui-form-hint-strict-pdu = ipucu: birliktelikler sırasında PDU boyutu denetimlerini zorunlu kıl
tui-form-hint-max-pdu-bytes = ipucu: bayt, örn. 16384
tui-form-limits-heading = Limits (bytes; blank/yok = unlimited):
tui-form-field-max-file-import = Maks. dosya içe aktarma baytı
tui-form-field-max-zip-entry = Maks. ZIP giriş baytı
tui-form-field-max-zip-total = Maks. toplam ZIP baytı
tui-form-field-max-zip-count = Maks. ZIP giriş sayısı
tui-form-field-max-store-object = Maks. store nesne baytı
tui-form-unlimited = sınırsız
tui-form-err-max-pdu-required = ! maks. PDU uzunluğu zorunlu
tui-form-err-max-pdu-gt-zero = ! maks. PDU uzunluğu 0’dan büyük tam sayı olmalı
tui-form-err-limit-gt-zero = ! { $label } 0’dan büyük tam sayı olmalı
tui-form-controls-scp = Düzenlemek için yazın. Boşluk onay kutularını değiştirir. Tab/Shift-Tab veya Yukarı/Aşağı alan değiştirir. Enter kaydeder. Esc iptal eder.
tui-form-submit-uid-required = UID zorunlu
tui-form-submit-dest-required = destination düğüm is required
tui-form-submit-nonneg-int = { $label } negatif olmayan tam sayı olmalı
tui-form-submit-gt-zero = { $label } 0’dan büyük olmalı
tui-form-submit-local-ae-required = yerel AE title zorunlu
tui-form-submit-local-ae-invalid = yerel AE title geçersiz: { $err }
tui-form-submit-bind-required = bind adresi zorunlu
tui-form-submit-port-required = port zorunlu
tui-form-submit-max-pdu-required = maks. PDU uzunluğu zorunlu
tui-form-submit-max-pdu-int = maks. PDU uzunluğu tam sayı olmalı
tui-form-submit-max-pdu-gt-zero = maks. PDU uzunluğu 0’dan büyük olmalı
tui-form-submit-patient-retrieve = hasta düzeyinde getirme desteklenmiyor
tui-form-submit-no-study-uid = seçilen sonuçta study UID yok
tui-form-submit-date-format = YYYYMMDD bekleniyor
tui-form-submit-modality-len = modalite en fazla 16 karakter olmalı
tui-form-submit-modality-chars = modalite A-Z veya 0-9 olmalı
tui-form-submit-name-required = düğüm adı zorunlu
tui-form-submit-ae-required = AE title zorunlu
tui-form-submit-host-required = host zorunlu
tui-form-submit-move-dest-invalid = move hedefi AE title geçersiz: { $err }
tui-form-submit-dates-both = başlangıç ve bitiş tarihleri birlikte ayarlanmalı ya da ikisi de boş olmalı
tui-form-submit-date-from-invalid = başlangıç tarihi geçersiz: { $err }
tui-form-submit-date-to-invalid = bitiş tarihi geçersiz: { $err }
tui-form-submit-date-order = başlangıç tarihi bitiş tarihinden sonra olmamalı
tui-form-submit-study-uid-series-query = seri düzeyi sorguları için study UID zorunlu
tui-form-submit-study-uid-image-query = görüntü düzeyi sorguları için study UID zorunlu
tui-form-submit-series-uid-image-query = görüntü düzeyi sorguları için series UID zorunlu
tui-form-submit-study-uid-required = study UID zorunlu
tui-form-submit-study-uid-invalid = study UID geçersiz: { $err }
tui-form-submit-series-uid-series-retrieve = seri düzeyi getirme için series UID zorunlu
tui-form-submit-series-uid-image-retrieve = görüntü düzeyi getirme için series UID zorunlu
tui-form-submit-instance-uid-image-retrieve = görüntü düzeyi getirme için instance UID zorunlu
tui-form-submit-series-uid-invalid = series UID geçersiz: { $err }
tui-form-submit-instance-uid-invalid = instance UID geçersiz: { $err }
tui-form-submit-import-path-required = içe aktarma yolu zorunlu
tui-form-submit-import-path-type = içe aktarma yolu bir dosya veya dizin olmalı: { $path }
tui-form-submit-import-access = içe aktarma yolu { $path } erişiliyor
tui-form-submit-import-open = içe aktarma dosyası { $path } açılıyor
tui-form-submit-import-read-dir = içe aktarma dizini { $path } okunuyor
tui-log-welcome = Press F1 or ? for help. Focus Uzak düğüms and press 'a' to add one.
tui-log-logging-to = { $path } konumuna günlük
tui-command-help-heading = komutlar:
tui-command-help-next-1 = not: alt bilgi, odaktaki bölmeye ve seçime göre bağlamsal 'Next:' önerileri gösterir.
tui-command-help-next-2 = Bunlar yalnızca ipuçlarıdır; her zaman herhangi bir komut yazabilirsiniz.
tui-command-help-canonical = not: kanonik adlar '--' olmadan CLI bayraklarıyla eşleşir ve alt çizgi kullanır.
tui-command-help-cancel = cancel (takma ad: stop)
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
tui-command-help-refresh = yenile
tui-command-help-quit = çık
tui-inspect-task = Görev #{ $id }
tui-inspect-status = Durum: { $status }
tui-inspect-description = Açıklama: { $description }
tui-inspect-progress = İlerleme: { $progress }
tui-inspect-summary = Özet:
tui-inspect-no-logs = (günlük yok)
tui-field-sop-class-uid = SOP Class UID
tui-field-transfer-syntax-uid = Transfer Syntax UID
tui-field-sha256 = SHA-256
tui-status-removed-nodes =
    silindi { $count ->
        [one] { $count } düğüm
       *[other] { $count } düğüm
    }
tui-status-removed-nodes-target =
    silindi { $count ->
        [one] { $count } düğüm
       *[other] { $count } düğüm
    }; son hedef { $name }
tui-status-more-failures =
    ve { $n ->
        [one] { $n } hata atlandı
       *[other] { $n } hata atlandı
    }
tui-status-retrieve-ok = retrieve status=0x{ $status } completed={ $completed } failed={ $failed } warning={ $warning } remaining={ $remaining }
tui-status-import-counts = scanned={ $scanned } accepted={ $accepted } duplicates={ $duplicates } unreadable={ $unreadable } invalid_dicom={ $invalid } rejected_total={ $rejected } stored_bytes={ $bytes }
tui-status-send-ok = send attempted={ $attempted } sent={ $sent } failed={ $failed }
tui-log-query-start = { $node } sorgusu başlıyor
tui-log-retrieve-start = { $node } üzerinden getirme başlıyor
tui-log-import-start = { $path } içe aktarma başlıyor
tui-log-send-study-start = { $uid } çalışması { $node } düğümüne gönderilmeye başlanıyor
tui-log-send-series-start = { $uid } serisi { $node } düğümüne gönderilmeye başlanıyor
tui-log-cancelled-before-start = başlamadan iptal
tui-log-cancelled = iptal
error-unknown-command = bilinmeyen komut: { $command }
error-node-subcommand-required = node alt komutu zorunlu
error-local-subcommand-required = local alt komutu zorunlu
error-unsupported-node-subcommand = unsupported düğüm subcommand: { $command }
error-unsupported-local-subcommand = desteklenmeyen local alt komutu: { $command }
error-expected-kv = key=value bağımsız değişkeni bekleniyordu, alınan { $arg }
error-missing-required-arg = zorunlu bağımsız değişken eksik: { $key }
error-missing-required-arg-one-of = zorunlu bağımsız değişken eksik: { $keys } içinden biri
error-parsing-command = komut ayrıştırılıyor
error-edit-form-lost-target = edit form lost its target düğüm
error-task-already-running = arka plan görevi zaten çalışıyor
error-task-thread-launch = arka plan görev iş parçacığı başlatılamadı: { $error }
error-task-disconnected = sonuç göndermeden önce arka plan görev iş parçacığı koptu
error-task-kind-missing = arka plan iş parçacığı koptu ancak active_task_kind None idi: beklenmeyen durum
error-serve-exited = serve hata ile çıktı: { $error }
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
summary-title = İşlem özeti
summary-kind = Tür
summary-status = Durum
summary-duration = Süre
summary-duration-ms = { $ms }ms
summary-peer = Eş
summary-ae = AE
summary-criteria = Kriterler
summary-counts = Sayımlar
summary-failures = Hatalar:
summary-logs = Günlükler:
summary-unserializable = <serileştirilemez>
summary-log-lines = satırlar { $start }-{ $end }
