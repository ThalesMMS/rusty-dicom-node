# Fluent catalog (ar). Message IDs are hyphenated identifiers
# (cli-about, tui-pane-remote-nodes, desktop-nav-dashboard, error-import-file-too-large).
# Dotted names are Fluent attributes (message + .attr), not message IDs.
# Do not translate DICOM tokens (C-FIND, C-MOVE, C-STORE, SOP, AE, UID) or JSON/CSV machine keys.


## CLI
cli-about = عميل عقدة DICOM يُفضّل الطرفية، مبني بـ dicom-rs
cli-arg-accession-number = التصفية حسب رقم accession (سلسلة فرعية دون تمييز حالة الأحرف).
cli-arg-ae-title = Application Entity title
cli-arg-destination-node = اسم أو id عقدة الوجهة
cli-arg-duplicate = التصفية حسب حالة التكرار.
cli-arg-export = تصدير النتائج كـ JSON أو CSV.
cli-arg-host = اسم المضيف أو IP
cli-arg-imported-at =
    التصفية حسب وقت الاستيراد. يُدعم VALUE وSTART..END و..END وSTART...
    المقارنة معجمية (الصيغة الموصى بها: RFC3339).
cli-arg-json = إخراج ملخص العملية النهائي بصيغة JSON (مخطط ثابت).
cli-arg-level = مستوى الاستعلام/الاسترجاع
cli-arg-metrics-json = عند خروج الخادم اطبع لقطة المقاييس في الذاكرة بصيغة JSON.
cli-arg-modality = التصفية حسب النمط. قائمة مفصولة بفواصل (مثل CT,MR).
cli-arg-model = نموذج معلومات الاستعلام/الاسترجاع
cli-arg-move-destination = AE title الوجهة المفضّل لـ C-MOVE
cli-arg-name = الاسم الظاهر للعقدة
cli-arg-node = اسم أو id العقدة المحفوظة
cli-arg-notes = ملاحظات حرّة
cli-arg-out = مسار ملف الإخراج. إن حُذف يُكتب إلى stdout.
cli-arg-path = ملف أو مجلد للاستيراد
cli-arg-patient-id = التصفية حسب معرّف المريض (سلسلة فرعية دون تمييز حالة الأحرف).
cli-arg-patient-name = التصفية حسب اسم المريض (سلسلة فرعية دون تمييز حالة الأحرف).
cli-arg-port = المنفذ
cli-arg-series-description = التصفية حسب وصف السلسلة (سلسلة فرعية دون تمييز حالة الأحرف).
cli-arg-series-instance-uid = Series Instance UID
cli-arg-sop-instance-uid = SOP Instance UID
cli-arg-source-path = التصفية حسب مسار المصدر (سلسلة فرعية دون تمييز حالة الأحرف).
cli-arg-study-date =
    التصفية حسب تاريخ الدراسة. يُدعم VALUE وSTART..END و..END وSTART...
    تُقارن التواريخ معجمياً (الصيغة الموصى بها: YYYYMMDD).
cli-arg-study-date-from = الحد الأدنى لتاريخ الدراسة (YYYYMMDD)
cli-arg-study-date-to = الحد الأعلى لتاريخ الدراسة (YYYYMMDD)
cli-arg-study-description = التصفية حسب وصف الدراسة (سلسلة فرعية دون تمييز حالة الأحرف).
cli-arg-study-instance-uid = Study Instance UID
cli-cmd-import-about = استيراد ملفات DICOM من مسار
cli-cmd-local-about = استعراض الأرشيف المحلي
cli-cmd-local-series-about = سرد السلاسل المفهرسة لدراسة
cli-cmd-local-studies-about = سرد الدراسات المحلية المفهرسة
cli-cmd-node-about = إدارة عقد DICOM البعيدة المحفوظة
cli-cmd-node-add-about = إضافة عقدة بعيدة
cli-cmd-node-delete-about = حذف عقدة محفوظة
cli-cmd-node-edit-about = تحرير عقدة محفوظة
cli-cmd-node-list-about = سرد العقد المحفوظة
cli-cmd-query-about = استعلام عقدة بعيدة (C-FIND)
cli-cmd-retrieve-about = استرجاع من عقدة بعيدة (C-MOVE)
cli-cmd-send-about = إرسال دراسات أو سلاسل محلية (C-STORE)
cli-cmd-send-series-about = إرسال سلسلة إلى عقدة الوجهة
cli-cmd-send-study-about = إرسال دراسة إلى عقدة الوجهة
cli-cmd-serve-about = تشغيل خادم DICOM
cli-cmd-storage-scp-about = تشغيل مستمع Storage SCP
cli-cmd-tui-about = فتح واجهة الطرفية التفاعلية
cli-flag-help = عرض المساعدة
cli-flag-lang = لغة الواجهة (وسم BCP-47). يتجاوز DICOM_NODE_LANG واللغة المحفوظة وlocale النظام.
cli-flag-version = عرض الإصدار
cli-heading-arguments = الوسائط:
cli-heading-commands = الأوامر:
cli-heading-options = الخيارات:
cli-heading-usage = الاستخدام:
cli-import-accepted = accepted={ $n }
cli-import-complete = اكتمل الاستيراد
cli-import-duplicates = duplicates={ $n }
cli-import-scanned = scanned={ $n }
cli-msg-cancel-sigint = طُلب الإلغاء (SIGINT). انتظار الإيقاف الآمن...
cli-msg-failures = إخفاقات:
cli-msg-import-failed = فشل الاستيراد: { $error }
cli-msg-no-local-series = لا سلاسل مفهرسة للدراسة { $uid }
cli-msg-no-local-studies = لا دراسات محلية مفهرسة
cli-msg-no-saved-nodes = لا عقد محفوظة
cli-msg-query-failed = فشل الاستعلام: { $error }
cli-msg-removed-nodes =
    أُزيلت { $count ->
        [one] { $count } عقدة
       *[other] { $count } عقد
    }
cli-msg-results-count =
    النتائج: { $count ->
        [one] { $count } تطابق
       *[other] { $count } تطابقات
    }
cli-msg-retrieve-failed = فشل الاسترجاع: { $error }
cli-msg-saved-node = حُفظت العقدة { $name } [{ $id }] => { $ae }@{ $host }:{ $port }
cli-msg-send-failed = فشل الإرسال: { $error }
cli-msg-showing-failures = (عرض أول { $shown } من { $total } إخفاقات)
cli-msg-starting-server =
    بدء خادم DICOM مع { $count ->
        [one] { $count } AE محلي
       *[other] { $count } AE محلية
    }: { $aes }
cli-msg-starting-server-no-aes = بدء خادم DICOM دون AE محلية مضبوطة
cli-msg-starting-storage-scp = بدء Storage SCP عند { $addr } بـ AE title { $ae }
cli-msg-updated-node = حُدّثت العقدة { $name } [{ $id }] => { $ae }@{ $host }:{ $port }
cli-send-attempted = attempted={ $n }
cli-send-failed-count = failed={ $n }
cli-send-sent = sent={ $n }
cli-value-name-file = FILE
cli-value-name-format = FORMAT
cli-value-name-locale = LOCALE
cli-value-name-path = PATH
tui-detail-more-series =
    ... { $n ->
        [one] { $n } سلسلة إضافية
       *[other] { $n } سلاسل إضافية
    }
tui-row-instance-count =
    { $n ->
        [one] { $n } نسخة
       *[other] { $n } نسخ
    }
tui-row-study-counts = { $series }s/{ $instances }i
count-nodes =
    { $n ->
        [one] { $n } عقدة
       *[other] { $n } عقد
    }
count-instances =
    { $n ->
        [one] { $n } نسخة
       *[other] { $n } نسخ
    }
count-series =
    { $n ->
        [one] { $n } سلسلة
       *[other] { $n } سلاسل
    }
count-studies =
    { $n ->
        [one] { $n } دراسة
       *[other] { $n } دراسات
    }
format-datetime = { $date } { $time }
format-date = { $day }/{ $month }/{ $year }

## Common
common-accession = رقم القبول
common-add = إضافة
common-back = رجوع
common-bytes = بايت
common-cancel = إلغاء
common-clear = مسح
common-close = إغلاق
common-date = التاريخ
common-delete = حذف العقدة
common-description = الوصف
common-disabled = معطّل
common-duplicates = تكرارات
common-edit = تحرير
common-enabled = مفعّل
common-error = خطأ
common-filter = تصفية
common-host = المضيف
common-import = استيراد
common-instance = مثيل
common-language = اللغة
common-loading = جارٍ التحميل
common-matches = تطابقات
common-modality = الوسط
common-name = الاسم
common-network = الشبكة
common-no = لا
common-none = لا شيء
common-notes = ملاحظات
common-optional = اختياري
common-path = المصدر
common-patient = المريض
common-patient-id = معرّف المريض
common-patient-name = اسم المريض
common-port = المنفذ
common-query = استعلام
common-refresh = تحديث
common-required = مطلوب
common-retrieve = استرداد
common-save = حفظ
common-search = بحث
common-send = إرسال
common-series = السلاسل
common-start = بدء
common-status = الحالة
common-stop = إيقاف
common-studies = الدراسات
common-study = دراسة
common-unknown = غير معروف
common-unknown-series = <السلاسل>
common-unknown-study = <الدراسات>
common-yes = نعم

## Errors
error-ae-empty = لا يمكن أن يكون AE title فارغاً
error-ae-invalid-char = AE title يحتوي على محرف غير صالح '{ $character }'؛ المسموح: A-Z، 0-9، مسافة
error-ae-required = AE title مطلوب
error-ae-too-long = يجب ألا يتجاوز AE title 16 محرفاً
error-ae-whitespace = لا يمكن أن يبدأ AE title أو ينتهي بمسافات
error-archive-patient-retrieve-out-of-scope = استرداد مستوى Patient خارج النطاق
error-archive-retrieve-uid-required = { $name } مطلوب لمستوى الاسترداد هذا
error-archive-study-root-patient-query = استعلامات Study Root لا تدعم مستوى Patient
error-archive-study-root-patient-retrieve = استرداد Study Root لا يدعم مستوى Patient
error-assoc-negotiation-failed = فشل تفاوض association مع { $name } ({ $addr })؛ تلميح: تحقق من called AE title وpresentation contexts/transfer syntaxes ومن أن النظير يقبل association
error-assoc-no-addresses = لا عناوين مقبس لـ { $name } على { $host }:{ $port }
error-assoc-receive = استقبال association
error-assoc-resolving = تحليل { $name } على { $host }:{ $port }: { $err }
error-assoc-timeout = انتهت مهلة انتظار استجابة DIMSE؛ تلميح: تحقق من الشبكة وAE title/المضيف/المنفذ واستجابة النظير
error-assoc-transport = انقطاع النقل أثناء انتظار استجابة DIMSE؛ تلميح: أغلق النظير الاتصال أو أعادت معدات الشبكة ضبطه
error-assoc-unreachable = تعذر الوصول إلى { $name } [{ $ae }] على { $host }:{ $port } خلال { $seconds }ث: { $err }. تحقق من المضيف/IP والمنفذ وإمكانية الوصول الشبكي
error-cancel-sigint = طُلب الإلغاء (SIGINT). انتظار إيقاف منظم...
error-config-must-be-positive = إعداد غير صالح: { $name } يجب أن يكون > 0 (أو null للتعطيل)
error-config-duplicate-bind-port = إعداد غير صالح: منفذ ربط AE المحلي مكرر { $port }
error-config-local-ae-max-assoc = إعداد غير صالح: AE المحلي { $title } يجب أن يكون max_concurrent_associations > 0
error-config-local-ae-no-services = إعداد غير صالح: يجب أن يفعّل AE المحلي { $title } خدمة واحدة على الأقل
error-config-must-be-positive-required = إعداد غير صالح: { $name } يجب أن يكون > 0
error-dicom-meta-incomplete = file meta في DICOM غير مكتمل
error-dicom-patient-move-unsupported = C-MOVE على مستوى المريض غير مدعوم في هذا العميل
error-dicom-required-attribute = سمة DICOM إلزامية مفقودة: ({ $group },{ $element })
error-dicom-series-uid-required-image = series_instance_uid مطلوب لـ retrieve على مستوى الصورة
error-dicom-series-uid-required-series = series_instance_uid مطلوب لـ retrieve على مستوى السلسلة
error-dicom-sop-uid-required-image = sop_instance_uid مطلوب لـ retrieve على مستوى الصورة
error-dicom-study-uid-required = study_instance_uid مطلوب
error-dicom-validating-move = التحقق من طلب move
error-export-creating-file = إنشاء ملف التصدير { $path }: { $err }
error-export-flushing-series-csv = تفريغ CSV للسلاسل: { $err }
error-export-flushing-studies-csv = تفريغ CSV للدراسات: { $err }
error-export-serializing-series-json = تسلسل JSON للسلاسل: { $err }
error-export-serializing-studies-json = تسلسل JSON للدراسات: { $err }
error-export-writing-series-csv-header = كتابة ترويسة CSV للسلاسل: { $err }
error-export-writing-series-csv-row = كتابة صف CSV للسلاسل: { $err }
error-export-writing-studies-csv-header = كتابة ترويسة CSV للدراسات: { $err }
error-export-writing-studies-csv-row = كتابة صف CSV للدراسات: { $err }
error-import-cleanup-failed = { $source }: فشل التنظيف: { $reason }
error-import-corrupt-zip = ZIP تالف: { $details }
error-import-dicom-parse-failed = فشل تحليل DICOM: { $err }
error-import-dicom-validation-failed = فشل التحقق من DICOM: { $err }
error-import-duplicate-zip-path = مسار ZIP مكرر: { $details }
error-import-file-too-large = الملف كبير جداً: { $details }
error-import-invalid-dicom = DICOM غير صالح: { $details }
error-import-limit-exceeded = تم تجاوز { $limit }: { $details }
error-import-not-regular-file = ليس ملفًا عاديًا
error-import-opening-file = فتح الملف: { $err }
error-import-opening-kind = فتح { $kind } { $path }
error-import-opening-staged-file = فتح الملف المرحلي: { $err }
error-import-opening-zip-archive = فتح أرشيف ZIP { $path }
error-import-opening-zip-entry = فتح إدخال ZIP: { $err }
error-import-opening-zip-file = فتح ملف ZIP للاستيراد { $path }
error-import-path-does-not-exist = مسار الاستيراد غير موجود: { $path }
error-import-reading-directory = قراءة مجلد الاستيراد { $path }
error-import-reading-file = قراءة الملف: { $err }
error-import-reading-file-metadata = قراءة بيانات الملف لـ { $path }
error-import-reading-metadata = قراءة بيانات { $kind } { $path }
error-import-reading-zip-entry = قراءة إدخال ZIP: { $err }
error-import-removing-staged-after-cancel = إزالة الملف المرحلي بعد الإلغاء { $path }
error-import-skipped = متجاوز: { $details }
error-import-unreadable = ملف غير قابل للقراءة: { $details }
error-import-unsafe-zip-path = مسار ZIP غير آمن: { $details }
error-import-zip-entry-count-exceeded = تجاوز حد عدد إدخالات ZIP: الأرشيف فيه { $count } إدخالًا، الحد { $limit }
error-import-zip-entry-size-exceeded = حجم إدخال ZIP { $size } يتجاوز الحد { $limit }
error-import-zip-total-bytes-exceeded = تجاوز حد بايتات ZIP المستخرجة: المجموع الحالي { $current } زائد حجم الإدخال { $entry } يتجاوز الحد { $limit }
error-net-binding-storage-scp = ربط Storage SCP على { $addr } لـ AE { $ae }. قد يستخدم مستقبل DICOM محلي آخر هذا المنفذ. حدّث storage_scp_port/local_aes في { $config } أو أوقف المستمع المتعارض
error-net-building-file-meta = بناء جدول بيانات الملف الوصفية
error-net-cannot-send-transfer-syntax = لا يمكن إرسال صيغة النقل المصدر { $source } مع صيغة النقل المتفاوض عليها { $negotiated }
error-net-cget-dataset-empty = مجموعة بيانات C-GET C-STORE المرمّزة فارغة
error-net-cget-dataset-odd-length = انتهت مجموعة بيانات C-GET C-STORE المرمّزة بجزء ذي طول فردي
error-net-cget-peer-released = حرر النظير الارتباط أثناء C-GET
error-net-cget-store-unexpected-dataset = غير متوقع dataset fragment in C-GET C-STORE response
error-net-cget-unexpected-command = غير متوقع command 0x{ $command } while waiting for C-STORE-RSP
error-net-cget-unexpected-pdu = غير متوقع PDU during C-GET C-STORE suboperation: { $pdu }
error-net-creating-incoming-dir = جارٍ إنشاء مجلد ‎.incoming الخاص بـ Storage SCP
error-net-creating-path = جارٍ إنشاء { $path }
error-net-dataset-empty = مجموعة البيانات المرمّزة فارغة لكن COMMAND_DATA_SET_TYPE يشير إلى أنها مطلوبة
error-net-dataset-odd-length = انتهت مجموعة البيانات المرمّزة بجزء ذي طول فردي
error-net-dimse-failed = فشل { $operation } بالحالة 0x{ $status } ({ $meaning }){ $hint }
error-net-establishing-assoc = جارٍ إنشاء ارتباط Storage SCP
error-net-file-meta-length = قراءة File Meta Information length
error-net-file-meta-tag = قراءة File Meta Information tag
error-net-file-meta-value = تخطي قيمة File Meta Information
error-net-file-meta-vr = قراءة File Meta Information VR
error-net-file-position = قراءة file position
error-net-flushing-path = جارٍ تفريغ { $path }
error-net-flushing-temp-dataset = تفريغ ملف مجموعة البيانات المؤقت
error-net-hint-suffix = ; تلميح: { $hint }
error-net-incomplete-command = غير مكتمل { $operation } command response
error-net-incomplete-identifier = غير مكتمل { $operation } response identifier
error-net-invalid-affected-sop = غير صالح { $operation } affected SOP class UID
error-net-invalid-status = غير صالح { $operation } status
error-net-listener-address = قراءة storage SCP listener address
error-net-listener-nonblocking = ضبط وضع المستمع غير الحاجز
error-net-listener-port = قراءة storage SCP listener port
error-net-local-aes-empty = يجب أن يحتوي local_aes على AE واحد على الأقل لبدء Storage SCP
error-net-locating-dataset = تحديد موقع مجموعة البيانات في { $path }
error-net-malformed-dimse = malformed { $operation } DIMSE response: { $details }; تلميح: peer sent an غير صالح or غير متوقع DIMSE command set
error-net-missing-affected-sop = مفقود { $operation } affected SOP class UID
error-net-missing-command-field = مفقود command field
error-net-missing-cstore-rsp-command-field = مفقود C-STORE response command field
error-net-missing-cstore-rsp-status = مفقود C-STORE response status
error-net-missing-destination = مفقود C-MOVE destination
error-net-missing-dicm = مفقود Part 10 DICM marker
error-net-missing-message-id = مفقود { $operation } message id
error-net-missing-qr-level = { $operation } identifier is مفقود QueryRetrieveLevel
error-net-missing-required-command-field = مفقود required command field { $name } ({ $tag })
error-net-missing-status = مفقود { $operation } status
error-net-move-destination-unresolved = لم يُحلّ move_destination
error-net-no-cget-store-context = لا سياق تقديم تخزين C-GET متفاوض عليه لـ SOP Class { $sop } وصيغة النقل { $syntax }
error-net-no-compatible-context = { $path }: لا سياق تقديم متوافق متفاوض عليه لصيغة النقل المصدر { $syntax }
error-net-no-dimse-provider = لا مزوّد DIMSE مسجّل للأمر 0x{ $command } والصيغة المجردة { $syntax }
error-net-no-presentation-context = لا سياق تقديم متفاوض عليه
error-net-no-presentation-context-for-file = { $path }: لا سياق تقديم متفاوض عليه
error-net-no-presentation-context-id = مفقود negotiated presentation context { $id }
error-net-opening-path = فتح { $path }
error-net-part10-preamble = قراءة Part 10 preamble
error-net-path-error = { $path }: { $err }
error-net-pdata-feed-complete = cannot feed P-DATA fragment into a complete accumulator (مفقود take())
error-net-peer-aborted = أجهض النظير الارتباط أثناء العملية الفرعية C-GET C-STORE: { $source }
error-net-peer-socket = قراءة storage SCP peer socket address
error-net-reading-command-dataset = قراءة command dataset
error-net-reading-identifier = قراءة { $operation } identifier
error-net-reading-incoming-dataset = قراءة incoming C-STORE dataset
error-net-reading-response-dataset = قراءة { $operation } response dataset
error-net-remote-aborted = أجهض الطرف البعيد الارتباط: { $source }
error-net-restoring-read-timeout = استعادة مهلة قراءة association
error-net-restoring-write-timeout = استعادة مهلة كتابة association
error-net-rewinding-dataset = الرجوع إلى أول عنصر في مجموعة البيانات
error-net-scp-thread-panicked = انهار خيط Storage SCP
error-net-seeking-temp-dataset = البحث في ملف مجموعة البيانات المؤقت
error-net-serializing-cget-dataset = تسلسل مجموعة بيانات العملية الفرعية C-GET لـ { $path }
error-net-serializing-dataset = تسلسل مجموعة البيانات لـ { $path } بصيغة النقل { $syntax }
error-net-setting-socket-blocking = ضبط مقبس التخزين المقبول على الوضع الحاجز
error-net-sending-buffered-dataset = إرسال مجموعة البيانات المخزّنة لـ { $path }
error-net-store-status = أعاد الطرف البعيد حالة C-STORE 0x{ $status } ({ $meaning }){ $hint }
error-net-streaming-dataset = بث مجموعة بيانات C-STORE
error-net-unexpected-command-field = غير متوقع CommandField 0x{ $actual } (expected 0x{ $expected } for { $rsp })
error-net-unexpected-dataset-fragment = غير متوقع dataset fragment in C-STORE response
error-net-unexpected-pdu = غير متوقع PDU during { $operation }: { $pdu }
error-net-unknown-status = غير صالح { $operation } status 0x{ $status }
error-net-unsupported-model-sop = غير مدعوم { $operation } model SOP class UID: { $uid }
error-net-unsupported-qr-level = غير مدعوم QueryRetrieveLevel: { $level }
error-net-unsupported-transfer-syntax = غير مدعوم negotiated transfer syntax
error-net-writing-command-dataset = كتابة command dataset
error-net-writing-identifier = كتابة { $operation } identifier
error-net-writing-path = كتابة { $path }
error-net-writing-response-dataset = كتابة { $operation } response dataset
error-net-writing-temp-dataset = كتابة dataset bytes to temp file
error-node-host-empty = لا يمكن أن يكون مضيف العقدة فارغًا
error-node-name-empty = لا يمكن أن يكون اسم العقدة فارغًا
error-node-not-found = العقدة البعيدة غير موجودة: { $id }
error-operation-cancelled = أُلغيت العملية
error-port-invalid = منفذ غير صالح: { $value }
error-port-range = يجب أن يكون المنفذ بين 1 و 65535
error-query-no-study-uid = المطابقة بلا StudyInstanceUID؛ يتعذّر الاسترجاع.
error-query-unsupported-level = مستوى استعلام غير مدعوم: { $value }
error-query-unsupported-model = نموذج استعلام غير مدعوم: { $value }
error-retrieve-canceled = أُلغي retrieve من العقدة البعيدة (status=0x{ $status }, completed={ $completed }, failed={ $failed }, warning={ $warning }, remaining={ $remaining }, { $scp })
error-retrieve-failed = فشل retrieve بالحالة status=0x{ $status } (completed={ $completed }, failed={ $failed }, warning={ $warning }, remaining={ $remaining }, { $scp })
error-retrieve-nothing-arrived = انتهى retrieve للوجهة { $destination } مع completed={ $completed } لكن لم يصل شيء إلى Storage SCP المحلي ({ $scp }). تحقق من تعيين AE أو المنفذ: يجب أن يكون { $listener } حرًا وأن تعيّن العقدة البعيدة AE { $destination } إلى هذا التطبيق
error-send-no-files-series = لا ملفات محلية مفهرسة للسلسلة { $uid }
error-send-no-files-study = لا ملفات محلية مفهرسة للدراسة { $uid }
error-task-cancelled = أُلغيت المهمة
error-task-none-to-cancel = لا مهمة نشطة للإلغاء (لا شيء يعمل)
error-tracing-init = تهيئة tracing subscriber: { $err }
error-uid-component-numeric = مكوّن UID '{ $part }' يجب أن يكون رقمياً
error-uid-component-too-long = مكوّن UID '{ $part }' طويل جداً
error-uid-dot-ends = لا يمكن أن يبدأ UID أو ينتهي بنقطة
error-uid-empty = لا يمكن أن يكون UID فارغاً
error-uid-empty-component = لا يمكن أن يحتوي UID على مكوّنات فارغة
error-uid-leading-zeros = مكوّن UID '{ $part }' لا يجوز أن يبدأ بأصفار
error-uid-too-long = يجب ألا يتجاوز UID 64 محرفاً

## TUI
tui-bool-no = لا
tui-bool-off = إيقاف
tui-bool-on = تشغيل
tui-bool-yes = نعم
tui-command-placeholder = اكتب أمراً أو استخدم اختصارات اللوحة.
tui-config-ae-title = AE title: { $value }
tui-config-edit-hint = اضغط Tab لتركيز هذا الجزء، ثم اضغط 'c' للتعديل.
tui-config-hint = اضغط Tab لتركيز هذا الجزء، ثم اضغط 'c' للتعديل.
tui-config-listener = المستمع: { $value }
tui-config-max-pdu = max_pdu_length: { $value }
tui-config-promiscuous = allow_promiscuous_storage: { $value }
tui-config-strict-pdu = strict_pdu: { $value }
tui-config-ts-pref = تفضيل TS: { $value }
tui-controls-hint = حقول Tab · Enter يؤكد · Esc يلغي
tui-detail-ae-title = AE Title
tui-detail-instance = تفاصيل المثيل
tui-detail-name = الاسم
tui-detail-node = تفاصيل العقدة
tui-detail-placeholder-followup = انقل التركيز إلى جزء قائمة وغيّر التحديد لتحديث هذا العرض.
tui-detail-query = تفاصيل نتيجة الاستعلام
tui-detail-select-node = حدد عقدة بعيدة لفحص بياناتها الوصفية.
tui-detail-series = تفاصيل السلسلة
tui-detail-study = تفاصيل الدراسة
tui-empty-command-placeholder = اكتب أمراً أو استخدم اختصارات اللوحة.
tui-empty-detail-instance = حدد مثيلًا لفحصه، أو ارجع إلى السلاسل بمفتاح Esc.
tui-empty-detail-node = حدد عقدة بعيدة لفحص بياناتها الوصفية.
tui-empty-detail-query = حدد نتيجة استعلام لفحص البيانات الوصفية وسياق retrieve.
tui-empty-detail-series = حدد سلسلة لفحصها، أو ارجع إلى الدراسات بمفتاح Esc.
tui-empty-detail-study = حدد دراسة محلية لفحص بيانات المريض والسلاسل.
tui-empty-instances = لا توجد مثيلات مفهرسة لهذه السلسلة.
tui-empty-instances-hint = اضغط Esc للرجوع إلى السلاسل.
tui-empty-local-instances = لا توجد مثيلات مفهرسة لهذه السلسلة.
tui-empty-local-instances-hint = اضغط Esc للرجوع إلى السلاسل.
tui-empty-local-series = لا توجد سلاسل مفهرسة لهذه الدراسة.
tui-empty-local-series-hint = اضغط Esc للرجوع إلى الدراسات المحلية.
tui-empty-local-studies = لا توجد دراسات مفهرسة بعد.
tui-empty-local-studies-cmd = مثال: import path=/data/inbox
tui-empty-local-studies-hint = استورد ملفات DICOM المحلية أولاً.
tui-empty-no-name = <بدون اسم>
tui-empty-query = لم يُنفَّذ استعلام بعد.
tui-empty-query-body =
    حدد عقدة بعيدة واضغط 'f' للاستعلام.
    أو: query node=pacs
        patient_name="DOE^JOHN"
    اضغط 'm' على نتيجة محددة لفتح retrieve.
tui-empty-query-cmd = أو: query node=pacs
tui-empty-query-hint = حدد عقدة بعيدة واضغط 'f' للاستعلام.
tui-empty-query-last-target = آخر هدف استعلام: { $name }
tui-empty-query-none = لم يُنفَّذ استعلام بعد.
tui-empty-query-retrieve-hint = اضغط 'm' على نتيجة محددة لفتح retrieve.
tui-empty-remote-nodes = لا توجد عقد بعيدة محفوظة بعد.
tui-empty-remote-nodes-cmd = أو: node add name=pacs
tui-empty-remote-nodes-hint = اضغط 'a' في هذه اللوحة لإضافة واحدة.
tui-empty-series = لا توجد سلاسل مفهرسة لهذه الدراسة.
tui-empty-series-hint = اضغط Esc للرجوع إلى الدراسات المحلية.
tui-empty-studies = لا توجد دراسات مفهرسة بعد.
tui-empty-studies-hint = استورد ملفات DICOM المحلية أولاً.
tui-empty-tasks-history = لا سجل مهام.
tui-empty-tasks-queued = لا مهام في الانتظار.
tui-fallback-no-name = <بدون اسم>
tui-field-accession = رقم accession
tui-field-ae-title = AE title
tui-field-bind-addr = عنوان الربط
tui-field-date-from = من تاريخ
tui-field-date-to = إلى تاريخ
tui-field-destination-node = عقدة الوجهة
tui-field-host = المضيف
tui-field-instance-uid = Instance UID
tui-field-kind = النوع
tui-field-level = المستوى
tui-field-local-ae = AE المحلي
tui-field-max-pdu = أقصى PDU
tui-field-modality = النمط
tui-field-model = النموذج
tui-field-move-destination = وجهة Move
tui-field-name = الاسم
tui-field-notes = ملاحظات
tui-field-path = المسار
tui-field-patient-id = معرّف المريض
tui-field-patient-name = اسم المريض
tui-field-port = المنفذ
tui-field-promiscuous = غير انتقائي
tui-field-series-uid = Series UID
tui-field-sop-uid = SOP Instance UID
tui-field-strict-pdu = PDU صارم
tui-field-study-description = وصف الدراسة
tui-field-study-uid = Study UID
tui-footer-back-series = Esc إلى السلاسل
tui-footer-back-studies = Esc إلى الدراسات
tui-footer-cancel-task = c إلغاء
tui-footer-edit-config = c تعديل الإعدادات
tui-footer-enter-series = Enter السلاسل
tui-footer-esc-series = Esc إلى السلاسل
tui-footer-esc-studies = Esc إلى الدراسات
tui-footer-help = F1/? مساعدة
tui-footer-inspect = Enter فحص
tui-footer-next = التالي: { $text }
tui-footer-nodes = a/e/d/f عقد
tui-footer-panes = Tab اللوحات
tui-footer-queued =
    { $n ->
        [one] { $n } في الانتظار
       *[other] { $n } في الانتظار
    }
tui-footer-quit = q خروج
tui-footer-refresh = r تحديث
tui-footer-retrieve = m استرجاع
tui-footer-run-command = Enter تنفيذ الأمر
tui-footer-task-scope = t الانتظار/السجل
tui-form-add-node = إضافة عقدة بعيدة
tui-form-add-remote-node = إضافة عقدة بعيدة
tui-form-delete-confirm = حذف العقدة البعيدة { $name } [{ $ae }] عند { $host }:{ $port }؟
tui-form-delete-node = حذف عقدة بعيدة
tui-form-delete-remote-node = حذف عقدة بعيدة
tui-form-edit-node = تحرير عقدة بعيدة
tui-form-edit-remote-node = تحرير عقدة بعيدة
tui-form-err-ae-required = ! عنوان AE مطلوب
tui-form-err-bind-required = ! عنوان الربط مطلوب
tui-form-err-host-required = ! المضيف مطلوب
tui-form-err-local-ae-invalid = ! عنوان AE المحلي غير صالح: { $err }
tui-form-err-local-ae-required = ! عنوان AE المحلي مطلوب
tui-form-err-modality-empty = modality لا يمكن أن يكون فارغًا
tui-form-err-move-dest-invalid = ! عنوان AE لوجهة النقل غير صالح: { $err }
tui-form-err-name-required = ! عقدة name is required
tui-form-err-port-required = ! المنفذ مطلوب
tui-form-err-uid-empty = لا يمكن أن يكون UID فارغاً
tui-form-err-uid-empty-component = لا يمكن أن يحتوي UID على مكوّنات فارغة
tui-form-error-line = خطأ: { $error }
tui-form-field-accession = رقم accession
tui-form-field-ae-title = AE title
tui-form-field-bind-addr = عنوان الربط
tui-form-field-date-from = من تاريخ
tui-form-field-date-to = إلى تاريخ
tui-form-field-dest-node = عقدة الوجهة
tui-form-field-destination = AE الوجهة
tui-form-field-host = المضيف
tui-form-field-instance-uid = SOP Instance UID
tui-form-field-kind = النوع
tui-form-field-level = المستوى
tui-form-field-local-ae = AE المحلي
tui-form-field-modality = النمط
tui-form-field-model = النموذج
tui-form-field-move-dest = وجهة Move
tui-form-field-name = الاسم
tui-form-field-notes = ملاحظات
tui-form-field-path = المسار
tui-form-field-patient-id = معرّف المريض
tui-form-field-patient-name = اسم المريض
tui-form-field-port = المنفذ
tui-form-field-series-uid = Series Instance UID
tui-form-field-sop-uid = SOP Instance UID
tui-form-field-study-desc = وصف الدراسة
tui-form-field-study-uid = Study Instance UID
tui-form-field-uid = UID
tui-form-hint-bind = تلميح: عادةً 0.0.0.0 (كل الواجهات) أو 127.0.0.1
tui-form-hint-local-ae = تلميح: حتى 16 حرفًا (A-Z، 0-9، مسافة)، مثل ARCHIVE_AE
tui-form-hint-move-dest = تلميح: اختياري؛ يتجاوز عنوان AE لوجهة C-MOVE
tui-form-hint-name = تلميح: تسمية قصيرة (مثل PACS)
tui-form-import = استيراد ملفات محلية
tui-form-import-local = استيراد ملفات محلية
tui-form-import-local-files = استيراد ملفات محلية
tui-form-mode-add = create a new عقدة بعيدة
tui-form-mode-edit = update the selected عقدة بعيدة
tui-form-query-node = استعلام عقدة بعيدة
tui-form-query-remote-node = استعلام عقدة بعيدة
tui-form-remote-node-line = عقدة بعيدة: { $name } [{ $ae }] { $host }:{ $port }
tui-form-retrieve = استرجاع المطابقات
tui-form-retrieve-matches = استرجاع المطابقات
tui-form-send-series = إرسال سلسلة
tui-form-send-study = إرسال دراسة
tui-form-storage-intro = عدّل إعدادات Storage SCP المحلية (تُحفظ في config.json).
tui-form-storage-scp = إعدادات Storage SCP
tui-form-storage-scp-settings = إعدادات Storage SCP
tui-help-ae-title = AE title: { $value }
tui-help-aedf = a/e/d/f     Add, edit, delete, or query from the selected عقدة
tui-help-c = c           تعديل إعدادات Storage SCP (عند التركيز على جزء الإعدادات)
tui-help-canonical-names = الأسماء القانونية تطابق أعلام CLI دون '--' وتستخدم الشرطات السفلية.
tui-help-close = أغلق المساعدة بـ Esc أو F1 أو ?.
tui-help-common-commands = أوامر شائعة
tui-help-config = c           تعديل إعدادات Storage SCP (عند التركيز على جزء الإعدادات)
tui-help-config-path = مسار الإعدادات: { $value }
tui-help-current-config = الإعداد الحالي
tui-help-data-dir = مجلد البيانات: { $value }
tui-help-enter-default = Enter       Run the command input, submit the active modal, or open series from الدراسات المحلية
tui-help-enter-instance = Enter       لا إجراء للجزء المحلي في عرض النسخة
tui-help-enter-local-instance = Enter       لا إجراء للجزء المحلي في عرض النسخة
tui-help-enter-local-series = Enter       فتح نسخ السلسلة المحلية المحددة، أو تشغيل إدخال الأمر / تأكيد النافذة النشطة
tui-help-enter-local-study = Enter       فتح سلاسل الدراسة المحلية المحددة، أو تشغيل إدخال الأمر / تأكيد النافذة النشطة
tui-help-enter-series = Enter       فتح نسخ السلسلة المحلية المحددة، أو تشغيل إدخال الأمر / تأكيد النافذة النشطة
tui-help-enter-study = Enter       فتح سلاسل الدراسة المحلية المحددة، أو تشغيل إدخال الأمر / تأكيد النافذة النشطة
tui-help-esc-default = Esc         إغلاق المساعدة/النافذة، أو العودة من السلسلة المحلية، أو إعادة التركيز إلى إدخال الأمر
tui-help-esc-instance = Esc         العودة من النسخ المحلية إلى السلسلة، أو إغلاق المساعدة/النافذة، أو إعادة التركيز إلى إدخال الأمر
tui-help-esc-instances = Esc         العودة من النسخ المحلية إلى السلسلة، أو إغلاق المساعدة/النافذة، أو إعادة التركيز إلى إدخال الأمر
tui-help-esc-series = Esc         العودة من السلسلة المحلية إلى الدراسات، أو إغلاق المساعدة/النافذة، أو إعادة التركيز إلى إدخال الأمر
tui-help-f1 = F1 أو ؟     فتح المساعدة
tui-help-import-send = i/s         استيراد local files or send selected study/series
tui-help-is = i/s         استيراد local files or send selected study/series
tui-help-listener = المستمع: { $value }
tui-help-log-dir = مجلد السجل: { $value }
tui-help-m = m           استرجاع من نتيجة الاستعلام المحددة
tui-help-max-pdu = max_pdu_length: { $value }
tui-help-move = أعلى/أسفل أو j/k   تحريك التحديد في أجزاء القائمة
tui-help-nodes = a/e/d/f     Add, edit, delete, or query from the selected عقدة
tui-help-open = F1 أو ؟     فتح المساعدة
tui-help-promiscuous = allow_promiscuous_storage: { $value }
tui-help-q = q           خروج عندما لا يكون هناك نافذة ولا يكون التركيز في إدخال الأمر
tui-help-quit = q           خروج عندما لا يكون هناك نافذة ولا يكون التركيز في إدخال الأمر
tui-help-r = r           تحديث panes when focus is لاt in command input
tui-help-receiver-mode = وضع المستقبل: { $value }
tui-receiver-mode-on-demand = عند الطلب للـ retrieve المحلي
tui-receiver-mode-standalone = مستقل عبر storage-scp
tui-help-refresh = r           تحديث panes when focus is لاt in command input
tui-help-retrieve = m           استرجاع من نتيجة الاستعلام المحددة
tui-help-strict-pdu = strict_pdu: { $value }
tui-help-tab = Tab / Shift-Tab  تغيير الجزء المركّز
tui-help-title = الاختصارات
tui-help-ts-pref = preferred_store_transfer_syntax: { $value }
tui-help-updown = أعلى/أسفل أو j/k   تحريك التحديد في أجزاء القائمة
tui-input-placeholder = اكتب أمراً أو استخدم اختصارات اللوحة.
tui-log-command = > { $command }
tui-log-error = خطأ: { $error }
tui-log-refreshed = تم التحديث
tui-logs-capped-suffix = محدود
tui-logs-label = السجلات:
tui-pane-command = أمر
tui-pane-config = الإعداد
tui-pane-detail = التفاصيل
tui-pane-detail-hint = { $title } (PgUp/PgDn عند عدم الكتابة)
tui-pane-help = مساعدة
tui-pane-instance-detail = تفاصيل المثيل
tui-pane-instances-for = المثيلات: { $uid }
tui-pane-local-studies = الدراسات المحلية
tui-pane-logs = السجل ({ $shown }/{ $total }{ $capped })
tui-pane-logs-capped = السجلات ({ $shown }/{ $total } capped)
tui-pane-logs-uncapped = السجلات ({ $shown }/{ $total })
tui-pane-node-detail = تفاصيل العقدة
tui-pane-query-detail = تفاصيل نتيجة الاستعلام
tui-pane-query-node = استعلام العقدة
tui-pane-query-result-detail = تفاصيل نتيجة الاستعلام
tui-pane-query-results = نتائج الاستعلام / الاسترجاع
tui-pane-query-retrieve-results = نتائج الاستعلام / الاسترجاع
tui-pane-remote-nodes = العقد البعيدة
tui-pane-series-detail = تفاصيل السلسلة
tui-pane-series-for = السلاسل: { $uid }
tui-pane-series-unknown = السلاسل: <دراسة غير معروفة>
tui-pane-study-detail = تفاصيل الدراسة
tui-pane-task-details = تفاصيل المهمة
tui-pane-tasks-history = المهام (السجل)
tui-pane-tasks-queued = المهام (الانتظار)
tui-pane-unknown-series = <سلسلة غير معروفة>
tui-pane-unknown-study = السلاسل: <دراسة غير معروفة>
tui-row-inst = inst
tui-status-cancel-requested = إلغاءlation requested
tui-status-config = الإعداد
tui-status-configured-listener = المستمع المهيأ { $addr } كـ AE { $ae } ({ $mode })
tui-status-data = البيانات
tui-status-failure = فشل: { $failure }
tui-status-listener = المستمع
tui-status-local-ae = AE المحلي
tui-status-mode = الوضع
tui-status-mode-on-demand = عند الطلب
tui-status-mode-standalone = مستقل
tui-status-no-active-task = لا توجد مهمة نشطة to cancel (nothing running)
tui-status-pdu = PDU
tui-status-promiscuous = غير انتقائي
tui-status-query-before-retrieve = Query a عقدة بعيدة first so retrieve knows which عقدة to use
tui-status-query-failed = فشل الاستعلام: { $error }
tui-status-queued-op = عملية في الانتظار: { $op }
tui-status-retrieve-failed = فشل الاسترجاع: { $error }
tui-status-retrieve-open-failed = تعذر الفتح retrieve stream: { $error }
tui-status-saved-node = saved عقدة { $name } ({ $id })
tui-status-saved-scp = تم حفظ إعدادات Storage SCP (يلزم إعادة التشغيل)
tui-status-select-node = حدد عقدة بعيدة أولاً
tui-status-select-query = اختر نتيجة استعلام أولاً
tui-status-select-study = اختر دراسة محلية أولاً
tui-status-strict = صارم
tui-status-task-cancelled = أُلغيت المهمة
tui-status-task-cancelled-detail = أُلغيت المهمة: { $other }
tui-status-ts-pref = تفضيل TS
tui-status-updated-node = updated عقدة { $name } ({ $id })
tui-suggest-back-series = Esc — العودة إلى السلسلة
tui-suggest-edit-config = c — تعديل الإعدادات
tui-suggest-help = F1/? — مساعدة
tui-suggest-inspect-task = Enter — فحص المهمة
tui-suggest-node-add = node add <ae-title> <host:port>
tui-suggest-query = f — query a عقدة
tui-suggest-query-node = f — query selected عقدة
tui-suggest-retrieve = m — استرجاع المحدد
tui-suggest-run-command = Enter — تنفيذ الأمر
tui-suggest-send-series = s — إرسال السلسلة المحددة
tui-suggest-view-series = Enter — عرض السلسلة
tui-task-cancelled = أُلغي
tui-task-cancelling = جارٍ الإلغاء
tui-task-failed = فشل
tui-task-failed-generic = فشلت المهمة: { $error }
tui-task-import-done = استيراد complete: { $report }
tui-task-import-failed = فشل الاستيراد: { $error }
tui-task-importing = استيراد { $path }...
tui-task-query-done =
    اكتمل الاستعلام: { $count ->
        [one] { $count } تطابق
       *[other] { $count } تطابقات
    }
tui-task-query-failed = فشل الاستعلام: { $error }
tui-task-querying = استعلام { $node }...
tui-task-queued = في الانتظار
tui-task-retrieve-done = اكتمل الاسترجاع: { $outcome }
tui-task-retrieve-failed = فشل الاسترجاع: { $error }
tui-task-retrieving = استرجاع من { $node }...
tui-task-running = جارٍ
tui-task-sending-series = إرسال السلسلة { $uid } إلى { $node }...
tui-task-sending-study = إرسال الدراسة { $uid } إلى { $node }...
tui-task-send-done = اكتمل الإرسال: { $outcome }
tui-task-status-cancelled = أُلغي
tui-task-status-cancelling = جارٍ الإلغاء
tui-task-status-failed = فشل
tui-task-status-ok = ok
tui-task-status-queued = في الانتظار
tui-task-status-running = جارٍ
tui-task-succeeded = نجح
tui-terminal-too-small = الطرفية صغيرة جداً، كبّر النافذة

## Desktop
desktop-action-activity = النشاط { $count }
desktop-action-activity-empty = النشاط
desktop-action-import = استيراد
desktop-action-inspect-archive = فحص الأرشيف المحلي
desktop-action-inspect-archive-desc = راجع الدراسات والسلاسل والمثيلات ثم أرسل أو صدّر.
desktop-action-manage-peers = إدارة النظراء
desktop-action-manage-peers-desc = أضف وعدّل عقد PACS أو محطات العمل المستخدمة في query و retrieve و store.
desktop-action-monitor-scp = مراقبة Storage SCP
desktop-action-query = استعلام
desktop-action-refresh = تحديث الحالة
desktop-action-refresh-status = تحديث الحالة
desktop-action-reveal-log = إظهار ملف السجل
desktop-action-send = إرسال
desktop-action-start-scp = بدء Storage SCP
desktop-activity-empty = لا يوجد نشاط للجلسة بعد.
desktop-activity-title = النشاط
desktop-app-title = DICOM Node
desktop-archive-csv = CSV
desktop-archive-details = التفاصيل
desktop-archive-empty = الأرشيف المحلي فارغ.
desktop-archive-export-fail = فشل تصدير { $scope }
desktop-archive-export-ok =
    { $rows ->
        [one] صُدِّر صف { $rows } من { $scope } إلى { $path }.
       *[other] صُدِّرت { $rows } صفوف من { $scope } إلى { $path }.
    }
desktop-archive-export-studies = تصدير الدراسات
desktop-archive-export-title = تصدير { $scope }
desktop-archive-filter = تصفية حسب المريض أو UID أو الوصف أو الوسط…
desktop-archive-filter-placeholder = تصفية حسب المريض أو UID أو الوصف أو الوسط…
desktop-archive-inst-abbrev =
    { $count ->
        [one] { $count } نسخة
       *[other] { $count } نسخ
    }
desktop-archive-instance-meta = { $bytes } · TS { $ts } · مستورد { $imported }
desktop-archive-instances = النسخ
desktop-archive-instances-heading = النسخ
desktop-archive-json = JSON
desktop-archive-loading = جارٍ تحميل الدراسات…
desktop-archive-no-filter-match = لا دراسات تطابق التصفية.
desktop-archive-no-instances = لم تُوجد نسخ.
desktop-archive-no-match = لا دراسات تطابق التصفية.
desktop-archive-no-nodes = لا عقد
desktop-archive-no-series = لم تُوجد سلاسل.
desktop-archive-reveal-file = إظهار الملف
desktop-archive-select-series = اختر سلسلة.
desktop-archive-select-study = اختر دراسة.
desktop-archive-send-fail = { $label }: أُرسل { $sent }/{ $attempted }، فشل { $failed }. { $failures }
desktop-archive-send-fail-title = فشل { $label }
desktop-archive-send-ok = { $label }: أُرسلت { $sent }/{ $attempted } نسخ.
desktop-archive-send-series = إرسال السلسلة
desktop-archive-send-series-label = سلسلة → { $destination }
desktop-archive-send-study = إرسال الدراسة
desktop-archive-send-study-label = دراسة → { $destination }
desktop-archive-send-to = إرسال إلى
desktop-archive-series = السلاسل
desktop-archive-series-count =
    #{ $number } · { $count ->
        [one] { $count } نسخة
       *[other] { $count } نسخ
    }
desktop-archive-series-fallback = السلاسل
desktop-archive-studies = الدراسات
desktop-archive-study-date = تاريخ الدراسة
desktop-archive-study-uid = Study UID
desktop-archive-subtitle = جرد الدراسات والسلاسل والنسخ من أرشيف SQLite المحلي.
desktop-archive-title = الأرشيف المحلي
desktop-brand-title = DICOM Node
desktop-col-description = الوصف
desktop-col-instances = النسخ
desktop-col-modalities = الطرائق
desktop-col-patient-id = معرّف المريض
desktop-common-cancel = إلغاء
desktop-common-clear = مسح
desktop-common-disabled = معطّل
desktop-common-enabled = مفعّل
desktop-common-loading = جارٍ التحميل…
desktop-common-no = لا
desktop-common-refresh = تحديث
desktop-common-yes = نعم
desktop-counter-assoc-accepted = ارتباطات مقبولة
desktop-counter-bytes-ingested = البايتات المستوعَبة
desktop-counter-cfind-requests = طلبات C-FIND
desktop-counter-cmove-requests = طلبات C-MOVE
desktop-counter-cstore-failed = C-STORE فشل
desktop-counter-cstore-stored = C-STORE مخزَّن
desktop-dashboard-counter-assoc-accepted = ارتباطات مقبولة
desktop-dashboard-counter-bytes-ingested = البايتات المستوعَبة
desktop-dashboard-counter-c-find-requests = طلبات C-FIND
desktop-dashboard-counter-c-move-requests = طلبات C-MOVE
desktop-dashboard-counter-c-store-failed = C-STORE فشل
desktop-dashboard-counter-c-store-stored = C-STORE مخزَّن
desktop-dashboard-empty-studies = لا توجد دراسات محلية بعد.
desktop-dashboard-inspect-archive-body = راجع الدراسات ثم السلاسل والنسخ ثم أرسل أو صدّر.
desktop-dashboard-inspect-archive-title = فحص الأرشيف المحلي
desktop-dashboard-kv-ae-title = AE Title
desktop-dashboard-kv-data-dir = مجلد البيانات
desktop-dashboard-kv-listener = المستمع
desktop-dashboard-kv-log-file = ملف السجل
desktop-dashboard-kv-max-pdu = أقصى PDU
desktop-dashboard-kv-promiscuous = تخزين غير مقيّد
desktop-dashboard-kv-server = الخادم
desktop-dashboard-kv-store-syntax = صيغة store
desktop-dashboard-kv-strict-pdu = PDU صارم
desktop-dashboard-listener-missing = لم يُحمَّل المستمع بعد.
desktop-dashboard-live-counters = عدادات مباشرة
desktop-dashboard-loading-metrics = جارٍ تحميل المقاييس…
desktop-dashboard-loading-status = جارٍ تحميل الحالة المحلية…
desktop-dashboard-loading-studies = جارٍ تحميل الدراسات…
desktop-dashboard-local-node = العقدة المحلية
desktop-dashboard-manage-peers-body = أضف وعدّل عقد PACS أو محطات العمل للاستعلام والاسترجاع والتخزين.
desktop-dashboard-manage-peers-title = إدارة الأقران
desktop-dashboard-metric-instances = النسخ
desktop-dashboard-metric-nodes = العقد البعيدة
desktop-dashboard-metric-series = السلاسل
desktop-dashboard-metric-studies = الدراسات
desktop-dashboard-monitor-scp = مراقبة Storage SCP
desktop-dashboard-recent-studies = دراسات حديثة
desktop-dashboard-start-scp = بدء Storage SCP
desktop-dashboard-subtitle = الأرشيف المحلي وأقران الشبكة ونشاط SCP في نظرة واحدة.
desktop-dashboard-title = لوحة المشغّل
desktop-doc-title = DICOM Node
desktop-import-accepted = مقبول
desktop-import-accepted-bytes = بايتات مقبولة
desktop-import-activity-detail = { $accepted }/{ $scanned } مقبول، { $duplicates } مكررات، { $bytes }
desktop-import-activity-fail = فشل الاستيراد
desktop-import-activity-ok = اكتمل الاستيراد
desktop-import-choose-archive = اختر أرشيف ZIP للاستيراد
desktop-import-choose-dir = اختر مجلداً للاستيراد
desktop-import-choose-folder = مجلد
desktop-import-choose-zip = اختر أرشيف ZIP للاستيراد
desktop-import-cleanup = تنظيف
desktop-import-clear-path = مسح المسار
desktop-import-complete = اكتمل الاستيراد
desktop-import-dup-sha = SHA-256
desktop-import-dup-sop = SOP UID
desktop-import-dup-total = المجموع
desktop-import-duplicates = مكررات
desktop-import-failed = فشل الاستيراد
desktop-import-failed-cleanup = فشل التنظيف
desktop-import-failures = إخفاقات
desktop-import-failures-heading =
    { $count ->
        [one] فشل { $count }:
       *[other] إخفاقات { $count }:
    }
desktop-import-failures-more = … و { $count } أخرى
desktop-import-files-progress = { $label } ملفات
desktop-import-folder = مجلد
desktop-import-invalid-dicom = DICOM غير صالح
desktop-import-pick-dir = اختر مجلداً للاستيراد
desktop-import-pick-zip = اختر أرشيف ZIP للاستيراد
desktop-import-placeholder = /path/to/dicom-folder or /path/to/archive.zip
desktop-import-rejected = مرفوض
desktop-import-report = تقرير الاستيراد
desktop-import-running = جارٍ الاستيراد…
desktop-import-scanned = ممسوح
desktop-import-skipped = متجاوَز
desktop-import-source = المصدر
desktop-import-start = بدء الاستيراد
desktop-import-stored = مخزَّن
desktop-import-subtitle = فهرسة ملفات DICOM من مجلدات متداخلة أو أرشيفات ZIP إلى الأرشيف المحلي المُدار.
desktop-import-title = استيراد
desktop-import-unreadable = غير قابل للقراءة
desktop-import-zip = ZIP
desktop-import-zip-filter = أرشيفات ZIP
desktop-lang-label = اللغة
desktop-listener-not-loaded = لم يُحمَّل المستمع بعد.
desktop-live-counters = عدادات مباشرة
desktop-loading = جارٍ التحميل
desktop-loading-local-status = جارٍ تحميل الحالة المحلية…
desktop-loading-metrics = جارٍ تحميل المقاييس…
desktop-loading-studies = جارٍ تحميل الدراسات…
desktop-local-node = العقدة المحلية
desktop-locale-label = اللغة
desktop-logs-activity-detail =
    { $count ->
        [one] حُمِّل سطر { $count }
       *[other] حُمِّلت { $count } أسطر
    }
desktop-logs-activity-fail = فشل تحديث السجل
desktop-logs-activity-ok = تم تحديث السجل
desktop-logs-auto = تلقائي
desktop-logs-auto-refresh = تحديث تلقائي
desktop-logs-empty = ملف السجل فارغ.
desktop-logs-found = تم العثور على ملف السجل
desktop-logs-lines =
    { $count ->
        [one] { $count } سطر
       *[other] { $count } أسطر
    }
desktop-logs-loading = جارٍ تحميل السجل…
desktop-logs-missing = لم يُنشأ ملف السجل النشط بعد.
desktop-logs-refresh-failed = فشل تحديث السجل
desktop-logs-refreshed = تم تحديث السجل
desktop-logs-reveal = إظهار
desktop-logs-subtitle = ذيل محدود لملف سجل سطح المكتب النشط.
desktop-logs-tail = الذيل
desktop-logs-title = السجلات
desktop-logs-truncated = مقصوص
desktop-logs-waiting = في انتظار ملف السجل
desktop-metric-instances = النسخ
desktop-metric-remote-nodes = العقد البعيدة
desktop-metric-series = السلاسل
desktop-metric-studies = الدراسات
desktop-nav-archive = الأرشيف المحلي
desktop-nav-dashboard = لوحة التحكم
desktop-nav-import = استيراد
desktop-nav-logs = السجلات
desktop-nav-network = الشبكة
desktop-nav-nodes = العقد البعيدة
desktop-nav-query = استعلام / استرجاع
desktop-nav-server = خادم التخزين
desktop-no-local-studies = لا توجد دراسات محلية بعد.
desktop-nodes-add = إضافة عقدة
desktop-nodes-added = أُضيفت العقدة "{ $name }".
desktop-nodes-ae-length = يجب ألا يتجاوز AE Title 16 حرفاً.
desktop-nodes-ae-title = AE Title
desktop-nodes-col-move = وجهة Move
desktop-nodes-configured = عقد مُعدَّة
desktop-nodes-confirm-delete = حذف العقدة "{ $name }"؟
desktop-nodes-default-port = المنفذ الافتراضي 104
desktop-nodes-delete = حذف العقدة
desktop-nodes-delete-title = حذف العقدة
desktop-nodes-deleted = حُذفت العقدة "{ $name }".
desktop-nodes-edit = تحرير العقدة
desktop-nodes-edit-title = تحرير العقدة
desktop-nodes-empty = لا عقد بعيدة بعد.
desktop-nodes-err-ae = عنوان AE مطلوب.
desktop-nodes-err-ae-len = يجب ألا يتجاوز عنوان AE 16 حرفًا.
desktop-nodes-err-host = المضيف مطلوب.
desktop-nodes-err-name = الاسم مطلوب.
desktop-nodes-err-port = يجب أن يكون المنفذ بين 1 و 65535.
desktop-nodes-host = المضيف
desktop-nodes-move-dest = وجهة Move
desktop-nodes-move-placeholder = الافتراضي: AE المحلي
desktop-nodes-name = الاسم
desktop-nodes-need-ae = AE Title مطلوب.
desktop-nodes-need-host = المضيف مطلوب.
desktop-nodes-need-name = الاسم مطلوب.
desktop-nodes-notes = ملاحظات
desktop-nodes-notes-placeholder = PACS غرفة القراءة
desktop-nodes-placeholder-ae = PACS01
desktop-nodes-placeholder-host = 192.168.0.10
desktop-nodes-placeholder-move = الافتراضي: AE المحلي
desktop-nodes-placeholder-name = main-pacs
desktop-nodes-placeholder-notes = PACS غرفة القراءة
desktop-nodes-port = المنفذ
desktop-nodes-port-104 = المنفذ الافتراضي 104
desktop-nodes-port-range = يجب أن يكون المنفذ بين 1 و 65535.
desktop-nodes-save = حفظ التغييرات
desktop-nodes-save-changes = حفظ التغييرات
desktop-nodes-subtitle = أقران PACS ومحطات العمل للاستعلام والاسترجاع والتخزين.
desktop-nodes-summary = ملخص العقد
desktop-nodes-title = العقد البعيدة
desktop-nodes-total = إجمالي العقد
desktop-nodes-updated = حُدِّثت العقدة "{ $name }".
desktop-nodes-with-move = مع وجهة Move
desktop-promiscuous = تخزين غير مقيّد
desktop-query-accession = Accession رقم
desktop-query-activity-detail = { $count } { $count ->
        [one] تطابق
       *[other] تطابقات
    } عند المستوى { $level }
desktop-query-activity-fail = فشل C-FIND { $node }
desktop-query-activity-ok = C-FIND { $node }
desktop-query-activity-title = C-FIND { $node }
desktop-query-clear = مسح
desktop-query-col-accession = رقم الوصول
desktop-query-criteria = معايير البحث
desktop-query-date-from = تاريخ الدراسة من
desktop-query-date-to = تاريخ الدراسة إلى
desktop-query-kv-series-uid = Series UID
desktop-query-kv-sop-uid = SOP UID
desktop-query-kv-study-uid = Study UID
desktop-query-level = المستوى
desktop-query-matches =
    { $count ->
        [one] تطابق { $count }
       *[other] تطابقات { $count }
    }
desktop-query-missing-study-uid = التطابق بلا StudyInstanceUID؛ تعذر الاسترجاع.
desktop-query-modality = الوسط
desktop-query-no-matches = لا تطابقات.
desktop-query-no-nodes = لا عقد مُعدَّة
desktop-query-patient-id = معرّف المريض
desktop-query-patient-name = اسم المريض
desktop-query-placeholder-description = CHEST*
desktop-query-placeholder-modality = CT, MR, …
desktop-query-placeholder-name = DOE^JOHN or DOE*
desktop-query-placeholder-patient = DOE^JOHN or DOE*
desktop-query-querying = جارٍ الاستعلام…
desktop-query-remote-node = عقدة بعيدة
desktop-query-results = النتائج
desktop-query-retrieve = استرجاع
desktop-query-retrieve-activity-detail = completed={ $completed }, warning={ $warning }, failed={ $failed }
desktop-query-retrieve-activity-fail = فشل C-MOVE { $node }
desktop-query-retrieve-activity-ok = C-MOVE { $node }
desktop-query-retrieve-finished = انتهى الاسترجاع: مكتمل { $completed }، تحذيرات { $warning }، فشل { $failed }.
desktop-query-retrieve-selected = استرجاع المحدد
desktop-query-run = تشغيل C-FIND
desktop-query-run-select = شغّل استعلاماً واختر تطابقاً.
desktop-query-running = جارٍ الاستعلام…
desktop-query-search-criteria = معايير البحث
desktop-query-select-hint = شغّل استعلاماً واختر تطابقاً.
desktop-query-selected = التطابق المحدد
desktop-query-selected-match = التطابق المحدد
desktop-query-series-uid = Series Instance UID
desktop-query-sop-uid = SOP Instance UID
desktop-query-study-description = وصف الدراسة
desktop-query-study-uid = Study Instance UID
desktop-query-subtitle = C-FIND إلى عقدة بعيدة، افحص التطابقات، ثم C-MOVE إلى الأرشيف المحلي.
desktop-query-title = استعلام / استرجاع
desktop-recent-studies = دراسات حديثة
desktop-scp-listening = SCP يستمع
desktop-scp-stopped = SCP متوقف
desktop-server-activity-fail = فشل التحكم في Storage SCP
desktop-server-activity-started = بدأ Storage SCP
desktop-server-activity-started-detail = بدأ المستمع.
desktop-server-activity-stopped = توقف Storage SCP
desktop-server-activity-stopped-detail = received={ $received }, stored={ $stored }, failed={ $failed }
desktop-server-activity-stopped-empty = لا جلسة نشطة.
desktop-server-addr-ae = { $addr } · AE { $ae }
desktop-server-assoc-accepted = ارتباطات مقبولة
desktop-server-assoc-rejected = ارتباطات مرفوضة
desktop-server-cfind-req-matches = طلبات / تطابقات C-FIND
desktop-server-cget-requests = طلبات C-GET
desktop-server-cmove-requests = طلبات C-MOVE
desktop-server-cmove-subops = عمليات C-MOVE الفرعية مكتملة / فاشلة
desktop-server-control-failed = فشل التحكم في Storage SCP
desktop-server-counter-bytes = البايتات المستوعَبة
desktop-server-counter-failed = C-STORE فشل
desktop-server-counter-find = طلبات / تطابقات C-FIND
desktop-server-counter-get = طلبات C-GET
desktop-server-counter-move = طلبات C-MOVE
desktop-server-counter-move-sub = عمليات C-MOVE الفرعية مكتملة / فاشلة
desktop-server-counter-received = C-STORE مستلم
desktop-server-counter-stored = C-STORE مخزَّن
desktop-server-cstore-failed = C-STORE فشل
desktop-server-cstore-received = C-STORE مستلم
desktop-server-cstore-stored = C-STORE مخزَّن
desktop-server-dimse = عدادات DIMSE
desktop-server-failed = فشل
desktop-server-health-loading = جارٍ تحميل المقاييس
desktop-server-health-ready = جاهز لـ C-STORE الوارد
desktop-server-health-review = مراجعة الإخفاقات
desktop-server-health-stopped = متوقف
desktop-server-listener-started = بدأ المستمع.
desktop-server-listening = يستمع
desktop-server-loading-metrics = جارٍ تحميل المقاييس…
desktop-server-logs = السجلات
desktop-server-no-session = لا جلسة نشطة.
desktop-server-rate = +{ $rate } / استطلاع
desktop-server-ready = جاهز لـ C-STORE الوارد
desktop-server-review-failures = مراجعة الإخفاقات
desktop-server-session-ended = انتهت الجلسة: مستلم { $received }، مخزَّن { $stored }، فشل { $failed }.
desktop-server-start = بدء الخادم
desktop-server-started-title = بدأ Storage SCP
desktop-server-stop = إيقاف الخادم
desktop-server-stopped = متوقف
desktop-server-stopped-pill = متوقف
desktop-server-stopped-status = متوقف
desktop-server-stopped-title = توقف Storage SCP
desktop-server-stored = مخزَّن
desktop-server-subtitle = Storage SCP مستقل لـ C-STORE الوارد وفهرسة الأرشيف المحلي.
desktop-server-title = خادم التخزين
desktop-status-listening = يستمع
desktop-status-loading = جارٍ التحميل
desktop-status-scp-listening = SCP يستمع
desktop-status-scp-stopped = SCP متوقف
desktop-status-stopped = متوقف
desktop-store-syntax = صيغة store
desktop-strict-pdu = PDU صارم
desktop-strip-pdu = PDU { $value }
desktop-table-accession = رقم القبول
desktop-table-ae-title = عنوان AE
desktop-table-date = التاريخ
desktop-table-description = الوصف
desktop-table-endpoint = نقطة النهاية
desktop-table-instances = النسخ
desktop-table-modalities = الطرائق
desktop-table-modality = الوسط
desktop-table-move-dest = وجهة Move
desktop-table-name = الاسم
desktop-table-notes = ملاحظات
desktop-table-patient = المريض
desktop-table-patient-id = معرّف المريض
desktop-table-series = السلاسل
desktop-table-updated = محدَّث
desktop-title-refresh-status = تحديث الحالة
desktop-title-reveal-log = إظهار ملف السجل
ae = AE
patient-name =
    "DOE^JOHN"
    اضغط 'm' على نتيجة محددة لفتح retrieve.
port = المنفذ

## Summary
summary-ae = AE
summary-counts = العدادات
summary-criteria = المعايير
summary-duration = المدة
summary-duration-ms = { $ms }ms
summary-failures = إخفاقات:
summary-kind = النوع
summary-logs = السجلات:
summary-peer = النظير
summary-status = الحالة
summary-title = ملخص العملية
tui-detail-created = أُنشئ

tui-form-hint-port-range = تلميح: رقم من 1 إلى 65535، مثل 104
tui-form-hint-promiscuous = تلميح: اسمح بالتخزين من أي عنوان AE متصل
tui-form-hint-strict-pdu = تلميح: فرض فحوصات حجم PDU أثناء الارتباطات
tui-form-hint-max-pdu-bytes = تلميح: بايت، مثل 16384
tui-form-limits-heading = Limits (bytes; blank/لا شيء = unlimited):
tui-form-field-max-file-import = الحد الأقصى لبايتات استيراد الملف
tui-form-field-max-zip-entry = الحد الأقصى لبايتات إدخال ZIP
tui-form-field-max-zip-total = الحد الأقصى لإجمالي بايتات ZIP
tui-form-field-max-zip-count = الحد الأقصى لعدد إدخالات ZIP
tui-form-field-max-store-object = الحد الأقصى لبايتات كائن التخزين
tui-form-unlimited = غير محدود
tui-form-err-max-pdu-required = ! الحد الأقصى لطول PDU مطلوب
tui-form-err-max-pdu-gt-zero = ! يجب أن يكون الحد الأقصى لطول PDU عددًا صحيحًا أكبر من 0
tui-form-err-limit-gt-zero = ! يجب أن يكون { $label } عددًا صحيحًا أكبر من 0
tui-form-controls-scp = اكتب للتعديل. المسافة تبدّل خانات الاختيار. Tab/Shift-Tab أو أعلى/أسفل للتنقل بين الحقول. Enter يحفظ. Esc يلغي.
tui-form-submit-uid-required = UID مطلوب
tui-form-submit-dest-required = destination عقدة is required
tui-form-submit-nonneg-int = يجب أن يكون { $label } عددًا صحيحًا غير سالب
tui-form-submit-gt-zero = يجب أن يكون { $label } أكبر من 0
tui-form-submit-local-ae-required = عنوان AE المحلي مطلوب
tui-form-submit-local-ae-invalid = عنوان AE المحلي غير صالح: { $err }
tui-form-submit-bind-required = عنوان الربط مطلوب
tui-form-submit-port-required = المنفذ مطلوب
tui-form-submit-max-pdu-required = الحد الأقصى لطول PDU مطلوب
tui-form-submit-max-pdu-int = يجب أن يكون الحد الأقصى لطول PDU عددًا صحيحًا
tui-form-submit-max-pdu-gt-zero = يجب أن يكون الحد الأقصى لطول PDU أكبر من 0
tui-form-submit-patient-retrieve = استرجاع مستوى المريض غير مدعوم
tui-form-submit-no-study-uid = النتيجة المحددة لا تتضمن study UID
tui-form-submit-date-format = المتوقع YYYYMMDD
tui-form-submit-modality-len = يجب ألا تتجاوز الوسيلة 16 حرفًا
tui-form-submit-modality-chars = يجب أن تكون الوسيلة A-Z أو 0-9
tui-form-submit-name-required = اسم العقدة مطلوب
tui-form-submit-ae-required = عنوان AE مطلوب
tui-form-submit-host-required = المضيف مطلوب
tui-form-submit-move-dest-invalid = عنوان AE لوجهة النقل غير صالح: { $err }
tui-form-submit-dates-both = يجب تعيين تاريخ البداية والنهاية معًا، أو عدم تعيين أي منهما
tui-form-submit-date-from-invalid = تاريخ البداية غير صالح: { $err }
tui-form-submit-date-to-invalid = تاريخ الانتهاء غير صالح: { $err }
tui-form-submit-date-order = يجب أن يكون تاريخ البداية في أو قبل تاريخ الانتهاء
tui-form-submit-study-uid-series-query = study UID مطلوب لاستعلامات مستوى السلسلة
tui-form-submit-study-uid-image-query = study UID مطلوب لاستعلامات مستوى الصورة
tui-form-submit-series-uid-image-query = series UID مطلوب لاستعلامات مستوى الصورة
tui-form-submit-study-uid-required = study UID مطلوب
tui-form-submit-study-uid-invalid = study UID غير صالح: { $err }
tui-form-submit-series-uid-series-retrieve = series UID مطلوب لاسترجاع مستوى السلسلة
tui-form-submit-series-uid-image-retrieve = series UID مطلوب لاسترجاع مستوى الصورة
tui-form-submit-instance-uid-image-retrieve = instance UID مطلوب لاسترجاع مستوى الصورة
tui-form-submit-series-uid-invalid = series UID غير صالح: { $err }
tui-form-submit-instance-uid-invalid = instance UID غير صالح: { $err }
tui-form-submit-import-path-required = مسار الاستيراد مطلوب
tui-form-submit-import-path-type = يجب أن يكون مسار الاستيراد ملفًا أو مجلدًا: { $path }
tui-form-submit-import-access = الوصول إلى مسار الاستيراد { $path }
tui-form-submit-import-open = فتح ملف الاستيراد { $path }
tui-form-submit-import-read-dir = قراءة مجلد الاستيراد { $path }
tui-log-welcome = Press F1 or ? for help. Focus عقدة بعيدةs and press 'a' to add one.
tui-log-logging-to = التسجيل إلى { $path }
tui-command-help-heading = أوامر:
tui-command-help-next-1 = ملاحظة: يعرض التذييل اقتراحات 'Next:' حسب اللوحة المحددة والاختيار.
tui-command-help-next-2 = هذه تلميحات فقط؛ يمكنك دائماً كتابة أي أمر.
tui-command-help-canonical = ملاحظة: الأسماء القانونية تطابق أعلام CLI بدون '--' باستخدام الشرطات السفلية.
tui-command-help-cancel = cancel (اسم بديل: stop)
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
tui-command-help-refresh = تحديث
tui-command-help-quit = خروج
tui-inspect-task = المهمة #{ $id }
tui-inspect-status = الحالة: { $status }
tui-inspect-description = الوصف: { $description }
tui-inspect-progress = التقدم: { $progress }
tui-inspect-summary = الملخص:
tui-inspect-no-logs = (لا توجد سجلات)
tui-field-sop-class-uid = SOP Class UID
tui-field-transfer-syntax-uid = Transfer Syntax UID
tui-field-sha256 = SHA-256
tui-status-removed-nodes =
    أُزيلت { $count ->
        [one] { $count } عقدة
       *[other] { $count } عقد
    }
tui-status-removed-nodes-target =
    أُزيلت { $count ->
        [one] { $count } عقدة
       *[other] { $count } عقد
    }; آخر هدف كان { $name }
tui-status-more-failures =
    و { $n ->
        [one] { $n } فشل محذوف
       *[other] { $n } إخفاقات محذوفة
    }
tui-status-retrieve-ok = retrieve status=0x{ $status } completed={ $completed } failed={ $failed } warning={ $warning } remaining={ $remaining }
tui-status-import-counts = scanned={ $scanned } accepted={ $accepted } duplicates={ $duplicates } unreadable={ $unreadable } invalid_dicom={ $invalid } rejected_total={ $rejected } stored_bytes={ $bytes }
tui-status-send-ok = send attempted={ $attempted } sent={ $sent } failed={ $failed }
tui-log-query-start = بدء الاستعلام على { $node }
tui-log-retrieve-start = بدء الاسترجاع من { $node }
tui-log-import-start = بدء استيراد { $path }
tui-log-send-study-start = بدء إرسال الدراسة { $uid } إلى { $node }
tui-log-send-series-start = بدء إرسال السلسلة { $uid } إلى { $node }
tui-log-cancelled-before-start = أُلغي قبل البدء
tui-log-cancelled = أُلغي
error-unknown-command = أمر غير معروف: { $command }
error-node-subcommand-required = يلزم أمر فرعي node
error-local-subcommand-required = يلزم أمر فرعي local
error-unsupported-node-subcommand = unsupported عقدة subcommand: { $command }
error-unsupported-local-subcommand = أمر فرعي local غير مدعوم: { $command }
error-expected-kv = المتوقع وسيطة key=value، تم الحصول على { $arg }
error-missing-required-arg = وسيطة مطلوبة مفقودة: { $key }
error-missing-required-arg-one-of = وسيطة مطلوبة مفقودة: واحدة من { $keys }
error-parsing-command = تحليل الأمر
error-edit-form-lost-target = edit form lost its target عقدة
error-task-already-running = مهمة خلفية قيد التشغيل بالفعل
error-task-thread-launch = تعذر تشغيل خيط المهمة الخلفية: { $error }
error-task-disconnected = انقطع خيط المهمة الخلفية قبل إرسال نتيجة
error-task-kind-missing = انقطع خيط المهمة الخلفية لكن active_task_kind كان None: حالة غير متوقعة
error-serve-exited = خرج serve مع خطأ: { $error }
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
summary-title = ملخص العملية
summary-kind = النوع
summary-status = الحالة
summary-duration = المدة
summary-duration-ms = { $ms }ms
summary-peer = النظير
summary-ae = AE
summary-criteria = المعايير
summary-counts = العدادات
summary-failures = إخفاقات:
summary-logs = السجلات:
summary-unserializable = <غير قابل للتسلسل>
summary-log-lines = الأسطر { $start }-{ $end }
