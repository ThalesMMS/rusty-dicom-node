# Fluent catalog (hi-IN). Message IDs are hyphenated identifiers
# (cli-about, tui-pane-remote-nodes, desktop-nav-dashboard, error-import-file-too-large).
# Dotted names are Fluent attributes (message + .attr), not message IDs.
# Do not translate DICOM tokens (C-FIND, C-MOVE, C-STORE, SOP, AE, UID) or JSON/CSV machine keys.


## CLI
cli-about = dicom-rs से बना टर्मिनल-प्रथम DICOM नोड क्लाइंट
cli-arg-accession-number = एक्सेशन नंबर से फ़िल्टर करें (केस-इग्नोर सबस्ट्रिंग)।
cli-arg-ae-title = Application Entity title
cli-arg-destination-node = गंतव्य नोड नाम या id
cli-arg-duplicate = डुप्लिकेट स्थिति से फ़िल्टर करें।
cli-arg-export = परिणाम JSON या CSV के रूप में निर्यात करें।
cli-arg-host = होस्टनाम या IP
cli-arg-imported-at =
    आयात टाइमस्टैम्प से फ़िल्टर करें। VALUE, START..END, ..END, START.. समर्थित।
    लेक्सिकोग्राफ़िक तुलना (अनुशंसित प्रारूप: RFC3339)।
cli-arg-json = अंतिम ऑपरेशन सारांश JSON में लिखें (स्थिर स्कीमा)।
cli-arg-level = क्वेरी/पुनर्प्राप्ति लेवल
cli-arg-metrics-json = सर्वर बंद होने पर अंतिम इन-मेमोरी मेट्रिक्स स्नैपशॉट JSON में छापें।
cli-arg-modality = मोडैलिटी से फ़िल्टर करें। अल्पविराम-पृथक सूची (जैसे CT,MR)।
cli-arg-model = क्वेरी/पुनर्प्राप्ति सूचना मॉडल
cli-arg-move-destination = वरीय C-MOVE गंतव्य AE title
cli-arg-name = नोड का प्रदर्शन नाम
cli-arg-node = सहेजा नोड नाम या id
cli-arg-notes = मुक्त-रूप नोट्स
cli-arg-out = आउटपुट फ़ाइल पथ। छोड़ा गया तो stdout पर लिखता है।
cli-arg-path = आयात करने वाली फ़ाइल या डिरेक्टरी
cli-arg-patient-id = रोगी आईडी से फ़िल्टर करें (केस-इग्नोर सबस्ट्रिंग)।
cli-arg-patient-name = रोगी नाम से फ़िल्टर करें (केस-इग्नोर सबस्ट्रिंग)।
cli-arg-port = पोर्ट
cli-arg-series-description = सीरीज़ विवरण से फ़िल्टर करें (केस-इग्नोर सबस्ट्रिंग)।
cli-arg-series-instance-uid = Series Instance UID
cli-arg-sop-instance-uid = SOP Instance UID
cli-arg-source-path = स्रोत पथ से फ़िल्टर करें (केस-इग्नोर सबस्ट्रिंग)।
cli-arg-study-date =
    अध्ययन तिथि से फ़िल्टर करें। VALUE, START..END, ..END, START.. समर्थित।
    तिथियों की तुलना लेक्सिकोग्राफ़िक है (अनुशंसित प्रारूप: YYYYMMDD)।
cli-arg-study-date-from = अध्ययन तिथि निचली सीमा (YYYYMMDD)
cli-arg-study-date-to = अध्ययन तिथि ऊपरी सीमा (YYYYMMDD)
cli-arg-study-description = अध्ययन विवरण से फ़िल्टर करें (केस-इग्नोर सबस्ट्रिंग)।
cli-arg-study-instance-uid = Study Instance UID
cli-cmd-import-about = पथ से DICOM फ़ाइलें आयात करें
cli-cmd-local-about = स्थानीय अभिलेख का निरीक्षण करें
cli-cmd-local-series-about = किसी अध्ययन की अनुक्रमित सीरीज़ सूचीबद्ध करें
cli-cmd-local-studies-about = अनुक्रमित स्थानीय अध्ययन सूचीबद्ध करें
cli-cmd-node-about = सहेजे गए दूरस्थ DICOM नोड प्रबंधित करें
cli-cmd-node-add-about = दूरस्थ नोड जोड़ें
cli-cmd-node-delete-about = सहेजा नोड हटाएँ
cli-cmd-node-edit-about = सहेजा नोड संपादित करें
cli-cmd-node-list-about = सहेजे नोड सूचीबद्ध करें
cli-cmd-query-about = दूरस्थ नोड क्वेरी करें (C-FIND)
cli-cmd-retrieve-about = दूरस्थ नोड से पुनर्प्राप्त करें (C-MOVE)
cli-cmd-send-about = स्थानीय अध्ययन या सीरीज़ भेजें (C-STORE)
cli-cmd-send-series-about = गंतव्य नोड को सीरीज़ भेजें
cli-cmd-send-study-about = गंतव्य नोड को अध्ययन भेजें
cli-cmd-serve-about = DICOM सर्वर चलाएँ
cli-cmd-storage-scp-about = Storage SCP लिस्नर चलाएँ
cli-cmd-tui-about = इंटरैक्टिव टर्मिनल UI खोलें
cli-flag-help = सहायता छापें
cli-flag-lang = UI भाषा (BCP-47 टैग)। DICOM_NODE_LANG और OS लोकेल को ओवरराइड करता है।
cli-flag-version = संस्करण छापें
cli-heading-arguments = आर्ग्युमेंट:
cli-heading-commands = कमांड:
cli-heading-options = विकल्प:
cli-heading-usage = उपयोग:
cli-import-accepted = accepted={ $n }
cli-import-complete = आयात complete
cli-import-duplicates = duplicates={ $n }
cli-import-scanned = scanned={ $n }
cli-msg-cancel-sigint = रद्दीकरण अनुरोध (SIGINT)। सुचारू शटडाउन की प्रतीक्षा…
cli-msg-failures = failures:
cli-msg-import-failed = आयात विफल: { $error }
cli-msg-no-local-series = अध्ययन { $uid } के लिए कोई अनुक्रमित सीरीज़ नहीं
cli-msg-no-local-studies = कोई अनुक्रमित स्थानीय अध्ययन नहीं
cli-msg-no-saved-nodes = कोई सहेजा नोड नहीं
cli-msg-query-failed = क्वेरी विफल: { $error }
cli-msg-removed-nodes =
    हटाया { $count ->
        [one] { $count } नोड
       *[other] { $count } नोड
    }
cli-msg-results-count =
    परिणाम: { $count ->
        [one] { $count } मिलान
       *[other] { $count } मिलान
    }
cli-msg-retrieve-failed = पुनः प्राप्ति विफल: { $error }
cli-msg-saved-node = Saved नोड { $name } [{ $id }] => { $ae }@{ $host }:{ $port }
cli-msg-send-failed = भेजना विफल: { $error }
cli-msg-showing-failures = ({ $total } में से पहले { $shown } विफलताएँ दिखाई जा रही हैं)
cli-msg-starting-server =
    DICOM सर्वर शुरू: { $count ->
        [one] { $count } स्थानीय AE
       *[other] { $count } स्थानीय AE
    }: { $aes }
cli-msg-starting-server-no-aes = बिना कॉन्फ़िगर स्थानीय AE के DICOM सर्वर शुरू
cli-msg-starting-storage-scp = { $addr } पर AE title { $ae } के साथ storage SCP शुरू हो रहा है
cli-msg-updated-node = Updated नोड { $name } [{ $id }] => { $ae }@{ $host }:{ $port }
cli-send-attempted = attempted={ $n }
cli-send-failed-count = failed={ $n }
cli-send-sent = sent={ $n }
cli-value-name-file = FILE
cli-value-name-format = FORMAT
cli-value-name-locale = LOCALE
cli-value-name-path = PATH
tui-detail-more-series =
    ... { $n ->
        [one] { $n } और सीरीज़
       *[other] { $n } और सीरीज़
    }
tui-row-instance-count =
    { $n ->
        [one] { $n } इंस्ट.
       *[other] { $n } इंस्ट.
    }
tui-row-study-counts = { $series }s/{ $instances }i
count-nodes =
    { $n ->
        [one] { $n } नोड
       *[other] { $n } नोड
    }
count-instances =
    { $n ->
        [one] { $n } इंस्टेंस
       *[other] { $n } इंस्टेंस
    }
count-series =
    { $n ->
        [one] { $n } सीरीज़
       *[other] { $n } सीरीज़
    }
count-studies =
    { $n ->
        [one] { $n } अध्ययन
       *[other] { $n } अध्ययन
    }
format-datetime = { $date } { $time }
format-date = { $day }/{ $month }/{ $year }

## Common
common-accession = एक्सेशन
common-add = जोड़ें
common-back = वापस
common-bytes = बाइट
common-cancel = रद्द
common-clear = साफ़ करें
common-close = बंद करें
common-date = तिथि
common-delete = नोड हटाएँ
common-description = विवरण
common-disabled = अक्षम
common-duplicates = डुप्लिकेट
common-edit = संपादित करें
common-enabled = सक्षम
common-error = त्रुटि
common-filter = फ़िल्टर
common-host = होस्ट
common-import = आयात
common-instance = इंस्टेंस
common-language = भाषा
common-loading = लोड हो रहा है
common-matches = मेल
common-modality = मोडैलिटी
common-name = नाम
common-network = नेटवर्क
common-no = नहीं
common-none = कोई नहीं
common-notes = नोट्स
common-optional = वैकल्पिक
common-path = स्रोत
common-patient = रोगी
common-patient-id = रोगी ID
common-patient-name = रोगी का नाम
common-port = पोर्ट
common-query = क्वेरी
common-refresh = ताज़ा करें
common-required = आवश्यक
common-retrieve = पुनर्प्राप्त करें
common-save = सहेजें
common-search = खोजें
common-send = भेजें
common-series = सीरीज़
common-start = शुरू करें
common-status = स्थिति
common-stop = रोकें
common-studies = अध्ययन
common-study = अध्ययन
common-unknown = अज्ञात
common-unknown-series = <सीरीज़>
common-unknown-study = <अध्ययन>
common-yes = हाँ

## Errors
error-ae-empty = AE title खाली नहीं हो सकता
error-ae-invalid-char = AE title में अमान्य वर्ण '{ $character }'; अनुमत: A-Z, 0-9, स्पेस
error-ae-required = AE title आवश्यक है
error-ae-too-long = AE title अधिकतम 16 अक्षर का होना चाहिए
error-ae-whitespace = AE title के आगे या पीछे स्पेस नहीं हो सकते
error-archive-patient-retrieve-out-of-scope = Patient स्तर retrieve दायरे से बाहर है
error-archive-retrieve-uid-required = इस retrieve स्तर के लिए { $name } आवश्यक है
error-archive-study-root-patient-query = Study Root क्वेरी Patient स्तर का समर्थन नहीं करतीं
error-archive-study-root-patient-retrieve = Study Root retrieve Patient स्तर का समर्थन नहीं करता
error-assoc-negotiation-failed = { $name } ({ $addr }) से एसोसिएशन नेगोशिएशन विफल; संकेत: called AE title, presentation contexts/transfer syntaxes, और पीयर की एसोसिएशन स्वीकृति जाँचें
error-assoc-no-addresses = { $name } के लिए { $host }:{ $port } पर कोई सॉकेट पता नहीं मिला
error-assoc-receive = एसोसिएशन प्राप्त
error-assoc-resolving = { $name } को { $host }:{ $port } पर रिज़ॉल्व: { $err }
error-assoc-timeout = DIMSE प्रतिक्रिया की प्रतीक्षा में टाइमआउट; संकेत: नेटवर्क कनेक्टिविटी, AE title/होस्ट/पोर्ट, और पीयर प्रतिक्रिया जाँचें
error-assoc-transport = DIMSE प्रतिक्रिया की प्रतीक्षा में ट्रांसपोर्ट बाधित; संकेत: पीयर ने कनेक्शन बंद किया या नेटवर्क मिडलबॉक्स ने रीसेट किया
error-assoc-unreachable = { $name } [{ $ae }] { $host }:{ $port } तक { $seconds }s में नहीं पहुँचे: { $err }। होस्ट/IP, पोर्ट और नेटवर्क पहुँच जाँचें
error-cancel-sigint = रद्दीकरण अनुरोध (SIGINT)। सुचारू शटडाउन की प्रतीक्षा…
error-config-must-be-positive = अमान्य कॉन्फ़िग: { $name } > 0 होना चाहिए (या बंद करने के लिए null)
error-config-duplicate-bind-port = अमान्य कॉन्फ़िग: स्थानीय AE bind पोर्ट { $port } दोहराया गया
error-config-local-ae-max-assoc = अमान्य कॉन्फ़िग: स्थानीय AE { $title } max_concurrent_associations > 0 होना चाहिए
error-config-local-ae-no-services = अमान्य कॉन्फ़िग: स्थानीय AE { $title } को कम से कम एक सेवा सक्षम करनी चाहिए
error-config-must-be-positive-required = अमान्य कॉन्फ़िग: { $name } > 0 होना चाहिए
error-dicom-meta-incomplete = DICOM फ़ाइल मेटा अधूरा है
error-dicom-patient-move-unsupported = इस क्लाइंट स्कैफोल्ड में रोगी-स्तरीय C-MOVE समर्थित नहीं है
error-dicom-required-attribute = आवश्यक DICOM विशेषता गायब: ({ $group },{ $element })
error-dicom-series-uid-required-image = इमेज-स्तरीय पुनर्प्राप्ति के लिए series_instance_uid आवश्यक है
error-dicom-series-uid-required-series = सीरीज़-स्तरीय पुनर्प्राप्ति के लिए series_instance_uid आवश्यक है
error-dicom-sop-uid-required-image = इमेज-स्तरीय पुनर्प्राप्ति के लिए sop_instance_uid आवश्यक है
error-dicom-study-uid-required = study_instance_uid आवश्यक है
error-dicom-validating-move = move अनुरोध सत्यापित हो रहा है
error-export-creating-file = निर्यात फ़ाइल बना रहे हैं { $path }: { $err }
error-export-flushing-series-csv = सीरीज़ CSV फ्लश: { $err }
error-export-flushing-studies-csv = अध्ययन CSV फ्लश: { $err }
error-export-serializing-series-json = सीरीज़ JSON सीरियलाइज़: { $err }
error-export-serializing-studies-json = अध्ययन JSON सीरियलाइज़: { $err }
error-export-writing-series-csv-header = सीरीज़ CSV हेडर लिख रहे हैं: { $err }
error-export-writing-series-csv-row = सीरीज़ CSV पंक्ति लिख रहे हैं: { $err }
error-export-writing-studies-csv-header = अध्ययन CSV हेडर लिख रहे हैं: { $err }
error-export-writing-studies-csv-row = अध्ययन CSV पंक्ति लिख रहे हैं: { $err }
error-import-cleanup-failed = { $source }: सफ़ाई विफल: { $reason }
error-import-corrupt-zip = क्षतिग्रस्त ZIP: { $details }
error-import-dicom-parse-failed = DICOM पार्स विफल: { $err }
error-import-dicom-validation-failed = DICOM सत्यापन विफल: { $err }
error-import-duplicate-zip-path = ZIP में कई प्रविष्टियाँ '{ $path }' को लक्ष्य करती हैं
error-import-file-too-large = फ़ाइल बहुत बड़ी: { $details }
error-import-invalid-dicom = अमान्य DICOM: { $details }
error-import-limit-exceeded = { $limit } पार: { $details }
error-import-not-regular-file = नियमित फ़ाइल नहीं है
error-import-opening-file = फ़ाइल खोल रहे हैं: { $err }
error-import-opening-kind = { $kind } { $path } खोल रहे हैं
error-import-opening-staged-file = स्टेज्ड फ़ाइल खोल रहे हैं: { $err }
error-import-opening-zip-archive = ZIP आर्काइव खोल रहे हैं { $path }
error-import-opening-zip-entry = ZIP प्रविष्टि खोल रहे हैं: { $err }
error-import-opening-zip-file = ZIP आयात फ़ाइल खोल रहे हैं { $path }
error-import-path-does-not-exist = आयात पथ मौजूद नहीं: { $path }
error-import-reading-directory = आयात डिरेक्टरी पढ़ रहे हैं { $path }
error-import-reading-file = फ़ाइल पढ़ रहे हैं: { $err }
error-import-reading-file-metadata = { $path } की फ़ाइल मेटाडेटा पढ़ रहे हैं
error-import-reading-metadata = { $kind } { $path } की मेटाडेटा पढ़ रहे हैं
error-import-reading-zip-entry = ZIP प्रविष्टि पढ़ रहे हैं: { $err }
error-import-removing-staged-after-cancel = रद्द करने के बाद स्टेज्ड फ़ाइल हटा रहे हैं { $path }
error-import-skipped = { $source }: छोड़ा गया: { $reason }
error-import-unreadable = अपठनीय फ़ाइल: { $details }
error-import-unsafe-zip-path = प्रविष्टि पथ आर्काइव से बाहर निकलता है
error-import-zip-entry-count-exceeded = ZIP प्रविष्टि संख्या सीमा पार: आर्काइव में { $count } प्रविष्टियाँ, सीमा { $limit }
error-import-zip-entry-size-exceeded = ZIP प्रविष्टि आकार { $size } सीमा { $limit } से अधिक
error-import-zip-total-bytes-exceeded = ZIP कुल निकाले गए बाइट्स की सीमा पार: वर्तमान कुल { $current } और प्रविष्टि आकार { $entry } सीमा { $limit } से अधिक
error-net-binding-storage-scp = { $addr } पर AE { $ae } के लिए Storage SCP बाइंड हो रहा है। कोई अन्य स्थानीय DICOM रिसीवर पहले से इस पोर्ट का उपयोग कर सकता है। { $config } में storage_scp_port/local_aes अपडेट करें या टकराने वाले लिसनर को रोकें
error-net-building-file-meta = फ़ाइल मेटा तालिका बन रही है
error-net-cannot-send-transfer-syntax = स्रोत transfer syntax { $source } को समझौता की गई { $negotiated } के साथ नहीं भेजा जा सकता
error-net-cget-dataset-empty = एन्कोडेड C-GET C-STORE डेटासेट खाली है
error-net-cget-dataset-odd-length = एन्कोडेड C-GET C-STORE डेटासेट विषम लंबाई के अंश पर समाप्त हुआ
error-net-cget-peer-released = C-GET के दौरान पीयर ने असोसिएशन छोड़ दी
error-net-cget-store-unexpected-dataset = अप्रत्याशित dataset fragment in C-GET C-STORE response
error-net-cget-unexpected-command = अप्रत्याशित command 0x{ $command } while waiting for C-STORE-RSP
error-net-cget-unexpected-pdu = अप्रत्याशित PDU during C-GET C-STORE suboperation: { $pdu }
error-net-creating-incoming-dir = Storage SCP .incoming डिरेक्टरी बनाई जा रही है
error-net-creating-path = { $path } बनाया जा रहा है
error-net-dataset-empty = एन्कोडेड डेटासेट खाली है पर COMMAND_DATA_SET_TYPE कहता है कि डेटासेट आवश्यक है
error-net-dataset-odd-length = एन्कोडेड डेटासेट विषम लंबाई के अंश पर समाप्त हुआ
error-net-dimse-failed = { $operation } स्थिति 0x{ $status } ({ $meaning }) के साथ विफल{ $hint }
error-net-establishing-assoc = Storage SCP असोसिएशन स्थापित हो रही है
error-net-file-meta-length = पढ़ना File Meta Information length
error-net-file-meta-tag = पढ़ना File Meta Information tag
error-net-file-meta-value = File Meta Information मान छोड़ा जा रहा है
error-net-file-meta-vr = पढ़ना File Meta Information VR
error-net-file-position = पढ़ना file position
error-net-flushing-path = { $path } फ्लश हो रहा है
error-net-flushing-temp-dataset = अस्थायी डेटासेट फ़ाइल फ्लश हो रही है
error-net-hint-suffix = ; संकेत: { $hint }
error-net-incomplete-command = अधूरा { $operation } command response
error-net-incomplete-identifier = अधूरा { $operation } response identifier
error-net-invalid-affected-sop = अमान्य { $operation } affected SOP class UID
error-net-invalid-status = अमान्य { $operation } status
error-net-listener-address = पढ़ना storage SCP listener address
error-net-listener-nonblocking = लिसनर नॉनब्लॉकिंग मोड सेट हो रहा है
error-net-listener-port = पढ़ना storage SCP listener port
error-net-local-aes-empty = Storage SCP शुरू करने के लिए local_aes में कम से कम एक AE होना चाहिए
error-net-locating-dataset = { $path } में डेटासेट खोजा जा रहा है
error-net-malformed-dimse = malformed { $operation } DIMSE response: { $details }; संकेत: peer sent an अमान्य or अप्रत्याशित DIMSE command set
error-net-missing-affected-sop = अनुपस्थित { $operation } affected SOP class UID
error-net-missing-command-field = अनुपस्थित command field
error-net-missing-cstore-rsp-command-field = अनुपस्थित C-STORE response command field
error-net-missing-cstore-rsp-status = अनुपस्थित C-STORE response status
error-net-missing-destination = अनुपस्थित C-MOVE destination
error-net-missing-dicm = अनुपस्थित Part 10 DICM marker
error-net-missing-message-id = अनुपस्थित { $operation } message id
error-net-missing-qr-level = { $operation } identifier is अनुपस्थित QueryRetrieveLevel
error-net-missing-required-command-field = अनुपस्थित required command field { $name } ({ $tag })
error-net-missing-status = अनुपस्थित { $operation } status
error-net-move-destination-unresolved = move_destination हल नहीं हुआ
error-net-no-cget-store-context = SOP Class { $sop } और transfer syntax { $syntax } के लिए कोई समझौता किया C-GET स्टोरेज प्रेजेंटेशन कॉन्टेक्स्ट नहीं
error-net-no-compatible-context = { $path }: स्रोत transfer syntax { $syntax } के लिए कोई संगत समझौता किया प्रेजेंटेशन कॉन्टेक्स्ट नहीं
error-net-no-dimse-provider = कमांड 0x{ $command } और abstract syntax { $syntax } के लिए कोई DIMSE प्रदाता पंजीकृत नहीं
error-net-no-presentation-context = कोई समझौता किया प्रेजेंटेशन कॉन्टेक्स्ट नहीं
error-net-no-presentation-context-for-file = { $path }: कोई समझौता किया प्रेजेंटेशन कॉन्टेक्स्ट नहीं
error-net-no-presentation-context-id = अनुपस्थित negotiated presentation context { $id }
error-net-opening-path = खोलना { $path }
error-net-part10-preamble = पढ़ना Part 10 preamble
error-net-path-error = { $path }: { $err }
error-net-pdata-feed-complete = cannot feed P-DATA fragment into a complete accumulator (अनुपस्थित take())
error-net-peer-aborted = C-GET C-STORE सब-ऑप के दौरान पीयर ने असोसिएशन निरस्त की: { $source }
error-net-peer-socket = पढ़ना storage SCP peer socket address
error-net-reading-command-dataset = पढ़ना command dataset
error-net-reading-identifier = पढ़ना { $operation } identifier
error-net-reading-incoming-dataset = पढ़ना incoming C-STORE dataset
error-net-reading-response-dataset = पढ़ना { $operation } response dataset
error-net-remote-aborted = दूरस्थ ने असोसिएशन निरस्त की: { $source }
error-net-restoring-read-timeout = association पढ़ने का टाइमआउट पुनर्स्थापित किया जा रहा है
error-net-restoring-write-timeout = association लिखने का टाइमआउट पुनर्स्थापित किया जा रहा है
error-net-rewinding-dataset = डेटासेट के पहले तत्व पर वापस जा रहे हैं
error-net-scp-thread-panicked = Storage SCP थ्रेड पैनिक हुआ
error-net-seeking-temp-dataset = अस्थायी डेटासेट फ़ाइल में सीक हो रहा है
error-net-serializing-cget-dataset = { $path } के लिए C-GET सब-ऑप डेटासेट सीरियलाइज़ हो रहा है
error-net-serializing-dataset = { $path } का डेटासेट transfer syntax { $syntax } के साथ सीरियलाइज़ हो रहा है
error-net-setting-socket-blocking = स्वीकृत स्टोरेज सॉकेट ब्लॉकिंग मोड में सेट हो रहा है
error-net-sending-buffered-dataset = { $path } का बफ़र्ड डेटासेट भेजा जा रहा है
error-net-store-status = दूरस्थ ने C-STORE स्थिति 0x{ $status } ({ $meaning }) लौटाई{ $hint }
error-net-streaming-dataset = C-STORE डेटासेट स्ट्रीम हो रहा है
error-net-unexpected-command-field = अप्रत्याशित CommandField 0x{ $actual } (expected 0x{ $expected } for { $rsp })
error-net-unexpected-dataset-fragment = अप्रत्याशित dataset fragment in C-STORE response
error-net-unexpected-pdu = अप्रत्याशित PDU during { $operation }: { $pdu }
error-net-unknown-status = अमान्य { $operation } status 0x{ $status }
error-net-unsupported-model-sop = असमर्थित { $operation } model SOP class UID: { $uid }
error-net-unsupported-qr-level = असमर्थित QueryRetrieveLevel: { $level }
error-net-unsupported-transfer-syntax = असमर्थित negotiated transfer syntax
error-net-writing-command-dataset = लिखना command dataset
error-net-writing-identifier = लिखना { $operation } identifier
error-net-writing-path = लिखना { $path }
error-net-writing-response-dataset = लिखना { $operation } response dataset
error-net-writing-temp-dataset = लिखना dataset bytes to temp file
error-node-host-empty = नोड होस्ट खाली नहीं हो सकता
error-node-name-empty = नोड नाम खाली नहीं हो सकता
error-node-not-found = दूरस्थ नोड नहीं मिला: { $id }
error-operation-cancelled = ऑपरेशन रद्द
error-port-invalid = अमान्य पोर्ट: { $value }
error-port-range = पोर्ट 1 से 65535 के बीच होना चाहिए
error-query-no-study-uid = मैच में StudyInstanceUID नहीं है; retrieve नहीं हो सकता।
error-query-unsupported-level = असमर्थित क्वेरी लेवल: { $value }
error-query-unsupported-model = असमर्थित क्वेरी मॉडल: { $value }
error-retrieve-canceled = दूरस्थ नोड ने पुनर्प्राप्ति रद्द की (status=0x{ $status }, completed={ $completed }, failed={ $failed }, warning={ $warning }, remaining={ $remaining }, { $scp })
error-retrieve-failed = पुनर्प्राप्ति विफल, status=0x{ $status } (completed={ $completed }, failed={ $failed }, warning={ $warning }, remaining={ $remaining }, { $scp })
error-retrieve-nothing-arrived = गंतव्य { $destination } के लिए पुनर्प्राप्ति पूर्ण हुई, completed={ $completed }, लेकिन स्थानीय Storage SCP ({ $scp }) पर कुछ नहीं आया। AE मैपिंग या पोर्ट जाँचें: सुनिश्चित करें कि { $listener } खाली है और दूरस्थ नोड AE { $destination } को इस ऐप से मैप करता है
error-send-no-files-series = सीरीज़ { $uid } के लिए कोई स्थानीय फ़ाइल अनुक्रमित नहीं
error-send-no-files-study = अध्ययन { $uid } के लिए कोई स्थानीय फ़ाइल अनुक्रमित नहीं
error-task-cancelled = कार्य रद्द
error-task-none-to-cancel = रद्द करने के लिए कोई सक्रिय कार्य नहीं (कुछ नहीं चल रहा)
error-tracing-init = tracing subscriber आरंभ: { $err }
error-uid-component-numeric = UID घटक '{ $part }' संख्यात्मक होना चाहिए
error-uid-component-too-long = UID घटक '{ $part }' बहुत लंबा है
error-uid-dot-ends = UID बिंदु से शुरू या समाप्त नहीं हो सकता
error-uid-empty = UID खाली नहीं हो सकता
error-uid-empty-component = UID में खाली घटक नहीं हो सकते
error-uid-leading-zeros = UID घटक '{ $part }' में आगे शून्य नहीं हो सकते
error-uid-too-long = UID अधिकतम 64 अक्षर का होना चाहिए

## TUI
tui-bool-no = नहीं
tui-bool-off = बंद
tui-bool-on = चालू
tui-bool-yes = हाँ
tui-command-placeholder = एक कमांड लिखें या फलक शॉर्टकट उपयोग करें।
tui-config-ae-title = AE title: { $value }
tui-config-edit-hint = इस फलक पर फ़ोकस करने के लिए Tab दबाएँ, फिर संपादित करने के लिए 'c'।
tui-config-hint = इस फलक पर फ़ोकस करने के लिए Tab दबाएँ, फिर संपादित करने के लिए 'c'।
tui-config-listener = लिसनर: { $value }
tui-config-max-pdu = max_pdu_length: { $value }
tui-config-promiscuous = allow_promiscuous_storage: { $value }
tui-config-strict-pdu = strict_pdu: { $value }
tui-config-ts-pref = TS वरीयता: { $value }
tui-controls-hint = Tab फ़ील्ड · Enter पुष्टि · Esc रद्द
tui-detail-ae-title = AE Title
tui-detail-instance = इंस्टेंस विवरण
tui-detail-name = नाम
tui-detail-node = नोड विवरण
tui-detail-placeholder-followup = इस दृश्य को अपडेट करने के लिए फ़ोकस सूची फलक पर ले जाएँ और चयन बदलें।
tui-detail-query = क्वेरी परिणाम विवरण
tui-detail-select-node = मेटाडेटा देखने के लिए रिमोट नोड चुनें।
tui-detail-series = सीरीज़ Detail
tui-detail-study = अध्ययन विवरण
tui-empty-command-placeholder = एक कमांड लिखें या फलक शॉर्टकट उपयोग करें।
tui-empty-detail-instance = इंस्टेंस चुनकर देखें, या Esc से सीरीज़ पर लौटें।
tui-empty-detail-node = मेटाडेटा देखने के लिए रिमोट नोड चुनें।
tui-empty-detail-query = retrieve संदर्भ और मेटाडेटा देखने के लिए क्वेरी परिणाम चुनें।
tui-empty-detail-series = सीरीज़ चुनकर देखें, या Esc से अध्ययन पर लौटें।
tui-empty-detail-study = रोगी और सीरीज़ मेटाडेटा देखने के लिए स्थानीय अध्ययन चुनें।
tui-empty-instances = इस सीरीज़ के लिए कोई अनुक्रमित इंस्टेंस उपलब्ध नहीं।
tui-empty-instances-hint = सीरीज़ पर वापस जाने के लिए Esc दबाएँ।
tui-empty-local-instances = इस सीरीज़ के लिए कोई अनुक्रमित इंस्टेंस उपलब्ध नहीं।
tui-empty-local-instances-hint = सीरीज़ पर वापस जाने के लिए Esc दबाएँ।
tui-empty-local-series = इस अध्ययन के लिए कोई अनुक्रमित सीरीज़ उपलब्ध नहीं।
tui-empty-local-series-hint = स्थानीय अध्ययन पर वापस जाने के लिए Esc दबाएँ।
tui-empty-local-studies = अभी कोई अनुक्रमित अध्ययन उपलब्ध नहीं।
tui-empty-local-studies-cmd = उदाहरण: import path=/data/inbox
tui-empty-local-studies-hint = आयात local DICOM files first.
tui-empty-no-name = <कोई नाम नहीं>
tui-empty-query = अभी कोई क्वेरी नहीं चलाई गई।
tui-empty-query-body =
    रिमोट नोड चुनें और क्वेरी के लिए 'f' दबाएँ।
    या: query node=pacs
        patient_name="DOE^JOHN"
    चयनित परिणाम पर retrieve खोलने के लिए 'm' दबाएँ।
tui-empty-query-cmd = या: query node=pacs
tui-empty-query-hint = रिमोट नोड चुनें और क्वेरी के लिए 'f' दबाएँ।
tui-empty-query-last-target = अंतिम क्वेरी लक्ष्य: { $name }
tui-empty-query-none = अभी कोई क्वेरी नहीं चलाई गई।
tui-empty-query-retrieve-hint = चयनित परिणाम पर retrieve खोलने के लिए 'm' दबाएँ।
tui-empty-remote-nodes = No रिमोट नोडs are saved yet.
tui-empty-remote-nodes-cmd = या: node add name=pacs
tui-empty-remote-nodes-hint = एक जोड़ने के लिए इस फलक में 'a' दबाएँ।
tui-empty-series = इस अध्ययन के लिए कोई अनुक्रमित सीरीज़ उपलब्ध नहीं।
tui-empty-series-hint = स्थानीय अध्ययन पर वापस जाने के लिए Esc दबाएँ।
tui-empty-studies = अभी कोई अनुक्रमित अध्ययन उपलब्ध नहीं।
tui-empty-studies-hint = आयात local DICOM files first.
tui-empty-tasks-history = कोई कार्य इतिहास नहीं।
tui-empty-tasks-queued = कोई कतारबद्ध कार्य नहीं।
tui-fallback-no-name = <कोई नाम नहीं>
tui-field-accession = एक्सेशन नंबर
tui-field-ae-title = AE title
tui-field-bind-addr = बाइंड पता
tui-field-date-from = तिथि से
tui-field-date-to = तिथि तक
tui-field-destination-node = Destination नोड
tui-field-host = होस्ट
tui-field-instance-uid = Instance UID
tui-field-kind = प्रकार
tui-field-level = स्तर
tui-field-local-ae = स्थानीय AE
tui-field-max-pdu = Max PDU
tui-field-modality = मोडैलिटी
tui-field-model = मॉडल
tui-field-move-destination = मूव गंतव्य
tui-field-name = नाम
tui-field-notes = नोट्स
tui-field-path = पथ
tui-field-patient-id = रोगी ID
tui-field-patient-name = रोगी का नाम
tui-field-port = पोर्ट
tui-field-promiscuous = प्रॉमिसक्युअस
tui-field-series-uid = Series UID
tui-field-sop-uid = SOP Instance UID
tui-field-strict-pdu = कठोर PDU
tui-field-study-description = अध्ययन विवरण
tui-field-study-uid = Study UID
tui-footer-back-series = Esc सीरीज़ पर वापस
tui-footer-back-studies = Esc अध्ययन पर वापस
tui-footer-cancel-task = c रद्द
tui-footer-edit-config = c कॉन्फ़िग संपादित
tui-footer-enter-series = Enter सीरीज़
tui-footer-esc-series = Esc सीरीज़ पर वापस
tui-footer-esc-studies = Esc अध्ययन पर वापस
tui-footer-help = F1/? सहायता
tui-footer-inspect = Enter निरीक्षण
tui-footer-next = अगला: { $text }
tui-footer-nodes = a/e/d/f नोड
tui-footer-panes = Tab फलक
tui-footer-queued =
    { $n ->
        [one] { $n } कतार में
       *[other] { $n } कतार में
    }
tui-footer-quit = q बाहर
tui-footer-refresh = r ताज़ा करें
tui-footer-retrieve = m पुनः प्राप्त
tui-footer-run-command = Enter कमांड चलाएँ
tui-footer-task-scope = t कतार/इतिहास
tui-form-add-node = दूरस्थ नोड जोड़ें
tui-form-add-remote-node = दूरस्थ नोड जोड़ें
tui-form-delete-confirm = रिमोट नोड { $name } [{ $ae }] को { $host }:{ $port } पर हटाएँ?
tui-form-delete-node = हटाएँ Remote Node
tui-form-delete-remote-node = हटाएँ Remote Node
tui-form-edit-node = दूरस्थ नोड संपादित करें
tui-form-edit-remote-node = दूरस्थ नोड संपादित करें
tui-form-err-ae-required = ! AE title आवश्यक है
tui-form-err-bind-required = ! बाइंड पता आवश्यक है
tui-form-err-host-required = ! होस्ट आवश्यक है
tui-form-err-local-ae-invalid = ! अमान्य स्थानीय AE title: { $err }
tui-form-err-local-ae-required = ! स्थानीय AE title आवश्यक है
tui-form-err-modality-empty = modality खाली नहीं हो सकता
tui-form-err-move-dest-invalid = ! अमान्य मूव गंतव्य AE title: { $err }
tui-form-err-name-required = ! नोड name is required
tui-form-err-port-required = ! पोर्ट आवश्यक है
tui-form-err-uid-empty = UID खाली नहीं हो सकता
tui-form-err-uid-empty-component = UID में खाली घटक नहीं हो सकते
tui-form-error-line = त्रुटि: { $error }
tui-form-field-accession = एक्सेशन नंबर
tui-form-field-ae-title = AE title
tui-form-field-bind-addr = बाइंड पता
tui-form-field-date-from = तिथि से
tui-form-field-date-to = तिथि तक
tui-form-field-dest-node = Destination नोड
tui-form-field-destination = गंतव्य AE
tui-form-field-host = होस्ट
tui-form-field-instance-uid = SOP Instance UID
tui-form-field-kind = प्रकार
tui-form-field-level = स्तर
tui-form-field-local-ae = स्थानीय AE
tui-form-field-modality = मोडैलिटी
tui-form-field-model = मॉडल
tui-form-field-move-dest = मूव गंतव्य
tui-form-field-name = नाम
tui-form-field-notes = नोट्स
tui-form-field-path = पथ
tui-form-field-patient-id = रोगी ID
tui-form-field-patient-name = रोगी का नाम
tui-form-field-port = पोर्ट
tui-form-field-series-uid = Series Instance UID
tui-form-field-sop-uid = SOP Instance UID
tui-form-field-study-desc = अध्ययन विवरण
tui-form-field-study-uid = Study Instance UID
tui-form-field-uid = UID
tui-form-hint-bind = संकेत: आमतौर पर 0.0.0.0 (सभी इंटरफ़ेस) या 127.0.0.1
tui-form-hint-local-ae = संकेत: अधिकतम 16 वर्ण (A-Z, 0-9, स्पेस), जैसे ARCHIVE_AE
tui-form-hint-move-dest = संकेत: वैकल्पिक; C-MOVE गंतव्य AE title को ओवरराइड करता है
tui-form-hint-name = संकेत: छोटा लेबल (जैसे PACS)
tui-form-import = आयात Local Files
tui-form-import-local = आयात Local Files
tui-form-import-local-files = आयात Local Files
tui-form-mode-add = create a new रिमोट नोड
tui-form-mode-edit = update the selected रिमोट नोड
tui-form-query-node = दूरस्थ नोड क्वेरी
tui-form-query-remote-node = दूरस्थ नोड क्वेरी
tui-form-remote-node-line = रिमोट नोड: { $name } [{ $ae }] { $host }:{ $port }
tui-form-retrieve = मिलान पुनः प्राप्त करें
tui-form-retrieve-matches = मिलान पुनः प्राप्त करें
tui-form-send-series = Send सीरीज़
tui-form-send-study = अध्ययन भेजें
tui-form-storage-intro = स्थानीय Storage SCP सेटिंग संपादित करें (config.json में सहेजी जाती हैं)।
tui-form-storage-scp = Storage SCP सेटिंग
tui-form-storage-scp-settings = Storage SCP सेटिंग
tui-help-ae-title = AE title: { $value }
tui-help-aedf = a/e/d/f     Add, edit, delete, or query from the selected नोड
tui-help-c = c           Storage SCP सेटिंग संपादित करें (फ़ोकस कॉन्फ़िग फलक पर हो)
tui-help-canonical-names = कैननिकल नाम CLI फ़्लैग से '--' के बिना मेल खाते हैं और अंडरस्कोर उपयोग करते हैं।
tui-help-close = Esc, F1 या ? से सहायता बंद करें।
tui-help-common-commands = सामान्य कमांड
tui-help-config = c           Storage SCP सेटिंग संपादित करें (फ़ोकस कॉन्फ़िग फलक पर हो)
tui-help-config-path = कॉन्फ़िग पथ: { $value }
tui-help-current-config = वर्तमान कॉन्फ़िगरेशन
tui-help-data-dir = डेटा डिरेक्टरी: { $value }
tui-help-enter-default = Enter       Run the command input, submit the active modal, or open series from स्थानीय अध्ययन
tui-help-enter-instance = Enter       इंस्टेंस दृश्य में कोई स्थानीय फलक क्रिया नहीं
tui-help-enter-local-instance = Enter       इंस्टेंस दृश्य में कोई स्थानीय फलक क्रिया नहीं
tui-help-enter-local-series = Enter       चयनित स्थानीय सीरीज़ के इंस्टेंस खोलें, या कमांड इनपुट चलाएँ / सक्रिय मोडल सबमिट करें
tui-help-enter-local-study = Enter       चयनित स्थानीय अध्ययन की सीरीज़ खोलें, या कमांड इनपुट चलाएँ / सक्रिय मोडल सबमिट करें
tui-help-enter-series = Enter       चयनित स्थानीय सीरीज़ के इंस्टेंस खोलें, या कमांड इनपुट चलाएँ / सक्रिय मोडल सबमिट करें
tui-help-enter-study = Enter       चयनित स्थानीय अध्ययन की सीरीज़ खोलें, या कमांड इनपुट चलाएँ / सक्रिय मोडल सबमिट करें
tui-help-esc-default = Esc         सहायता/मोडल बंद करें, स्थानीय सीरीज़ से लौटें, या फ़ोकस कमांड इनपुट पर वापस करें
tui-help-esc-instance = Esc         स्थानीय इंस्टेंस से सीरीज़ पर लौटें, सहायता/मोडल बंद करें, या फ़ोकस कमांड इनपुट पर वापस करें
tui-help-esc-instances = Esc         स्थानीय इंस्टेंस से सीरीज़ पर लौटें, सहायता/मोडल बंद करें, या फ़ोकस कमांड इनपुट पर वापस करें
tui-help-esc-series = Esc         स्थानीय सीरीज़ से अध्ययन पर लौटें, सहायता/मोडल बंद करें, या फ़ोकस कमांड इनपुट पर वापस करें
tui-help-f1 = F1 या ?     सहायता खोलें
tui-help-import-send = i/s         आयात local files or send selected study/series
tui-help-is = i/s         आयात local files or send selected study/series
tui-help-listener = लिसनर: { $value }
tui-help-log-dir = लॉग डिरेक्टरी: { $value }
tui-help-m = m           चयनित क्वेरी परिणाम से पुनः प्राप्त करें
tui-help-max-pdu = max_pdu_length: { $value }
tui-help-move = ऊपर/नीचे या j/k   सूची फलकों में चयन चलाएँ
tui-help-nodes = a/e/d/f     Add, edit, delete, or query from the selected नोड
tui-help-open = F1 या ?     सहायता खोलें
tui-help-promiscuous = allow_promiscuous_storage: { $value }
tui-help-q = q           मोडल सक्रिय न हो और फ़ोकस कमांड इनपुट में न हो तो बाहर निकलें
tui-help-quit = q           मोडल सक्रिय न हो और फ़ोकस कमांड इनपुट में न हो तो बाहर निकलें
tui-help-r = r           रीफ़्रेश panes when focus is नहींt in command input
tui-help-receiver-mode = रिसीवर मोड: { $value }
tui-receiver-mode-on-demand = स्थानीय retrieve के लिए मांग पर
tui-receiver-mode-standalone = storage-scp के माध्यम से स्टैंडअलोन
tui-help-refresh = r           रीफ़्रेश panes when focus is नहींt in command input
tui-help-retrieve = m           चयनित क्वेरी परिणाम से पुनः प्राप्त करें
tui-help-strict-pdu = strict_pdu: { $value }
tui-help-tab = Tab / Shift-Tab  फ़ोकस फलक बदलें
tui-help-title = कीबाइंडिंग
tui-help-ts-pref = preferred_store_transfer_syntax: { $value }
tui-help-updown = ऊपर/नीचे या j/k   सूची फलकों में चयन चलाएँ
tui-input-placeholder = एक कमांड लिखें या फलक शॉर्टकट उपयोग करें।
tui-log-command = > { $command }
tui-log-error = त्रुटि: { $error }
tui-log-refreshed = ताज़ा
tui-logs-capped-suffix = सीमित
tui-logs-label = लॉग:
tui-pane-command = कमांड
tui-pane-config = कॉन्फ़िग
tui-pane-detail = विवरण
tui-pane-detail-hint = { $title } (PgUp/PgDn टाइप न करते समय)
tui-pane-help = सहायता
tui-pane-instance-detail = इंस्टेंस विवरण
tui-pane-instances-for = इंस्टेंस for: { $uid }
tui-pane-local-studies = स्थानीय अध्ययन
tui-pane-logs = लॉग ({ $shown }/{ $total }{ $capped })
tui-pane-logs-capped = लॉग ({ $shown }/{ $total } capped)
tui-pane-logs-uncapped = लॉग ({ $shown }/{ $total })
tui-pane-node-detail = नोड विवरण
tui-pane-query-detail = क्वेरी परिणाम विवरण
tui-pane-query-node = नोड क्वेरी
tui-pane-query-result-detail = क्वेरी परिणाम विवरण
tui-pane-query-results = क्वेरी / पुनर्प्राप्ति परिणाम
tui-pane-query-retrieve-results = क्वेरी / पुनर्प्राप्ति परिणाम
tui-pane-remote-nodes = दूरस्थ नोड
tui-pane-series-detail = सीरीज़ Detail
tui-pane-series-for = सीरीज़ for: { $uid }
tui-pane-series-unknown = सीरीज़ for: <अज्ञात अध्ययन>
tui-pane-study-detail = अध्ययन विवरण
tui-pane-task-details = कार्य विवरण
tui-pane-tasks-history = कार्य (इतिहास)
tui-pane-tasks-queued = कार्य (कतार)
tui-pane-unknown-series = <अज्ञात सीरीज़>
tui-pane-unknown-study = सीरीज़ for: <अज्ञात अध्ययन>
tui-row-inst = inst
tui-status-cancel-requested = रद्द करेंlation requested
tui-status-config = कॉन्फ़िग
tui-status-configured-listener = कॉन्फ़िगर लिसनर { $addr } AE { $ae } ({ $mode }) के रूप में
tui-status-data = डेटा
tui-status-failure = विफलता: { $failure }
tui-status-listener = लिसनर
tui-status-local-ae = स्थानीय AE
tui-status-mode = मोड
tui-status-mode-on-demand = मांग पर
tui-status-mode-standalone = स्टैंडअलोन
tui-status-no-active-task = कोई सक्रिय कार्य नहीं to cancel (nothing running)
tui-status-pdu = PDU
tui-status-promiscuous = प्रॉमिसक्युअस
tui-status-query-before-retrieve = Query a रिमोट नोड first so retrieve knows which नोड to use
tui-status-query-failed = क्वेरी विफल: { $error }
tui-status-queued-op = कतारबद्ध संचालन: { $op }
tui-status-retrieve-failed = पुनः प्राप्ति विफल: { $error }
tui-status-retrieve-open-failed = खोल नहीं सके retrieve stream: { $error }
tui-status-saved-node = saved नोड { $name } ({ $id })
tui-status-saved-scp = Storage SCP सेटिंग सहेजी गई (पुनर्प्रारंभ आवश्यक)
tui-status-select-node = पहले एक रिमोट नोड चुनें
tui-status-select-query = पहले एक क्वेरी परिणाम चुनें
tui-status-select-study = पहले एक स्थानीय अध्ययन चुनें
tui-status-strict = कठोर
tui-status-task-cancelled = कार्य रद्द
tui-status-task-cancelled-detail = कार्य रद्द: { $other }
tui-status-ts-pref = TS वरीयता
tui-status-updated-node = updated नोड { $name } ({ $id })
tui-suggest-back-series = Esc — सीरीज़ पर वापस
tui-suggest-edit-config = c — कॉन्फ़िग संपादित
tui-suggest-help = F1/? — सहायता
tui-suggest-inspect-task = Enter — कार्य निरीक्षण
tui-suggest-node-add = node add <ae-title> <host:port>
tui-suggest-query = f — query a नोड
tui-suggest-query-node = f — query selected नोड
tui-suggest-retrieve = m — चयनित पुनः प्राप्त
tui-suggest-run-command = Enter — कमांड चलाएँ
tui-suggest-send-series = s — चयनित सीरीज़ भेजें
tui-suggest-view-series = Enter — सीरीज़ देखें
tui-task-cancelled = रद्द करेंled
tui-task-cancelling = रद्द करेंling
tui-task-failed = विफल
tui-task-failed-generic = कार्य विफल: { $error }
tui-task-import-done = आयात complete: { $report }
tui-task-import-failed = आयात विफल: { $error }
tui-task-importing = आयातing { $path }...
tui-task-query-done =
    क्वेरी पूर्ण: { $count ->
        [one] { $count } मिलान
       *[other] { $count } मिलान
    }
tui-task-query-failed = क्वेरी विफल: { $error }
tui-task-querying = { $node } की क्वेरी...
tui-task-queued = कतार में
tui-task-retrieve-done = पुनः प्राप्ति पूर्ण: { $outcome }
tui-task-retrieve-failed = पुनः प्राप्ति विफल: { $error }
tui-task-retrieving = { $node } से पुनः प्राप्ति...
tui-task-running = चल रहा है
tui-task-sending-series = सीरीज़ { $uid } को { $node } पर भेजा जा रहा है...
tui-task-sending-study = अध्ययन { $uid } को { $node } पर भेजा जा रहा है...
tui-task-send-done = भेजना पूर्ण: { $outcome }
tui-task-status-cancelled = रद्द
tui-task-status-cancelling = रद्द हो रहा है
tui-task-status-failed = विफल
tui-task-status-ok = ok
tui-task-status-queued = कतार में
tui-task-status-running = चल रहा है
tui-task-succeeded = सफल
tui-terminal-too-small = टर्मिनल बहुत छोटा है — आकार बदलें

## Desktop
desktop-action-activity = गतिविधि { $count }
desktop-action-activity-empty = गतिविधि
desktop-action-import = आयात
desktop-action-inspect-archive = स्थानीय संग्रह देखें
desktop-action-inspect-archive-desc = अध्ययन, सीरीज़ और इंस्टेंस देखें; फिर भेजें या निर्यात करें.
desktop-action-manage-peers = पीयर प्रबंधित करें
desktop-action-manage-peers-desc = query, retrieve और store के PACS/वर्कस्टेशन नोड जोड़ें और संपादित करें.
desktop-action-monitor-scp = Storage SCP मॉनिटर करें
desktop-action-query = क्वेरी
desktop-action-refresh = स्थिति ताज़ा करें
desktop-action-refresh-status = स्थिति ताज़ा करें
desktop-action-reveal-log = लॉग फ़ाइल दिखाएँ
desktop-action-send = भेजें
desktop-action-start-scp = Storage SCP शुरू करें
desktop-activity-empty = अभी कोई सत्र गतिविधि नहीं।
desktop-activity-title = गतिविधि
desktop-app-title = DICOM Node
desktop-archive-csv = CSV
desktop-archive-details = विवरण
desktop-archive-empty = स्थानीय संग्रह खाली है।
desktop-archive-export-fail = { $scope } निर्यात विफल
desktop-archive-export-ok =
    { $rows ->
        [one] { $rows } { $scope } पंक्ति { $path } पर निर्यात की गई।
       *[other] { $rows } { $scope } पंक्तियाँ { $path } पर निर्यात की गईं।
    }
desktop-archive-export-studies = अध्ययन निर्यात करें
desktop-archive-export-title = { $scope } निर्यात करें
desktop-archive-filter = रोगी, UID, विवरण, मोडैलिटी से फ़िल्टर…
desktop-archive-filter-placeholder = रोगी, UID, विवरण, मोडैलिटी से फ़िल्टर…
desktop-archive-inst-abbrev =
    { $count ->
        [one] { $count } इंस्ट.
       *[other] { $count } इंस्ट.
    }
desktop-archive-instance-meta = { $bytes } · TS { $ts } · आयात { $imported }
desktop-archive-instances = इंस्टेंस
desktop-archive-instances-heading = इंस्टेंस
desktop-archive-json = JSON
desktop-archive-loading = अध्ययन लोड हो रहे हैं…
desktop-archive-no-filter-match = फ़िल्टर से कोई अध्ययन मेल नहीं खाता।
desktop-archive-no-instances = कोई इंस्टेंस नहीं मिला।
desktop-archive-no-match = फ़िल्टर से कोई अध्ययन मेल नहीं खाता।
desktop-archive-no-nodes = कोई नोड नहीं
desktop-archive-no-series = कोई सीरीज़ नहीं मिली।
desktop-archive-reveal-file = फ़ाइल दिखाएँ
desktop-archive-select-series = एक सीरीज़ चुनें।
desktop-archive-select-study = एक अध्ययन चुनें।
desktop-archive-send-fail = { $label }: { $sent }/{ $attempted } भेजे, { $failed } विफल। { $failures }
desktop-archive-send-fail-title = { $label } विफल
desktop-archive-send-ok = { $label }: { $sent }/{ $attempted } इंस्टेंस भेजे।
desktop-archive-send-series = सीरीज़ भेजें
desktop-archive-send-series-label = सीरीज़ → { $destination }
desktop-archive-send-study = अध्ययन भेजें
desktop-archive-send-study-label = अध्ययन → { $destination }
desktop-archive-send-to = भेजें
desktop-archive-series = सीरीज़
desktop-archive-series-count =
    #{ $number } · { $count ->
        [one] { $count } इंस्टेंस
       *[other] { $count } इंस्टेंस
    }
desktop-archive-series-fallback = सीरीज़
desktop-archive-studies = अध्ययन
desktop-archive-study-date = अध्ययन तिथि
desktop-archive-study-uid = Study UID
desktop-archive-subtitle = स्थानीय SQLite संग्रह से अध्ययन, सीरीज़ और इंस्टेंस सूची।
desktop-archive-title = स्थानीय संग्रह
desktop-brand-title = DICOM Node
desktop-col-description = विवरण
desktop-col-instances = इंस्टेंस
desktop-col-modalities = मोडैलिटी
desktop-col-patient-id = रोगी ID
desktop-common-cancel = रद्द
desktop-common-clear = साफ़ करें
desktop-common-disabled = अक्षम
desktop-common-enabled = सक्षम
desktop-common-loading = लोड हो रहा है…
desktop-common-no = नहीं
desktop-common-refresh = ताज़ा करें
desktop-common-yes = हाँ
desktop-counter-assoc-accepted = स्वीकृत एसोसिएशन
desktop-counter-bytes-ingested = गृहीत बाइट
desktop-counter-cfind-requests = C-FIND अनुरोध
desktop-counter-cmove-requests = C-MOVE अनुरोध
desktop-counter-cstore-failed = C-STORE विफल
desktop-counter-cstore-stored = C-STORE संग्रहीत
desktop-dashboard-counter-assoc-accepted = स्वीकृत एसोसिएशन
desktop-dashboard-counter-bytes-ingested = गृहीत बाइट
desktop-dashboard-counter-c-find-requests = C-FIND अनुरोध
desktop-dashboard-counter-c-move-requests = C-MOVE अनुरोध
desktop-dashboard-counter-c-store-failed = C-STORE विफल
desktop-dashboard-counter-c-store-stored = C-STORE संग्रहीत
desktop-dashboard-empty-studies = अभी कोई स्थानीय अध्ययन नहीं।
desktop-dashboard-inspect-archive-body = अध्ययन देखें, सीरीज़ और इंस्टेंस में जाएँ, फिर भेजें या निर्यात करें।
desktop-dashboard-inspect-archive-title = स्थानीय संग्रह देखें
desktop-dashboard-kv-ae-title = AE Title
desktop-dashboard-kv-data-dir = डेटा डिरेक्टरी
desktop-dashboard-kv-listener = लिसनर
desktop-dashboard-kv-log-file = लॉग फ़ाइल
desktop-dashboard-kv-max-pdu = अधिकतम PDU
desktop-dashboard-kv-promiscuous = असीमित स्टोरेज
desktop-dashboard-kv-server = सर्वर
desktop-dashboard-kv-store-syntax = Store सिंटैक्स
desktop-dashboard-kv-strict-pdu = कठोर PDU
desktop-dashboard-listener-missing = Listener अभी लोड नहीं हुआ।
desktop-dashboard-live-counters = लाइव काउंटर
desktop-dashboard-loading-metrics = मेट्रिक्स लोड हो रहे हैं…
desktop-dashboard-loading-status = स्थानीय स्थिति लोड हो रही है…
desktop-dashboard-loading-studies = अध्ययन लोड हो रहे हैं…
desktop-dashboard-local-node = स्थानीय नोड
desktop-dashboard-manage-peers-body = क्वेरी, पुनर्प्राप्ति और store के लिए PACS या वर्कस्टेशन नोड जोड़ें और संपादित करें।
desktop-dashboard-manage-peers-title = पीयर प्रबंधित करें
desktop-dashboard-metric-instances = इंस्टेंस
desktop-dashboard-metric-nodes = दूरस्थ नोड
desktop-dashboard-metric-series = सीरीज़
desktop-dashboard-metric-studies = अध्ययन
desktop-dashboard-monitor-scp = Storage SCP मॉनिटर करें
desktop-dashboard-recent-studies = हाल के अध्ययन
desktop-dashboard-start-scp = Storage SCP शुरू करें
desktop-dashboard-subtitle = स्थानीय संग्रह, नेटवर्क पीयर और SCP गतिविधि एक नज़र में।
desktop-dashboard-title = ऑपरेटर डैशबोर्ड
desktop-doc-title = DICOM Node
desktop-import-accepted = स्वीकृत
desktop-import-accepted-bytes = स्वीकृत बाइट
desktop-import-activity-detail = { $accepted }/{ $scanned } स्वीकृत, { $duplicates } डुप्लिकेट, { $bytes }
desktop-import-activity-fail = आयात विफल
desktop-import-activity-ok = आयात पूर्ण
desktop-import-choose-archive = आयात के लिए ZIP चुनें
desktop-import-choose-dir = आयात के लिए डिरेक्टरी चुनें
desktop-import-choose-folder = फ़ोल्डर
desktop-import-choose-zip = आयात के लिए ZIP चुनें
desktop-import-cleanup = सफ़ाई
desktop-import-clear-path = पथ साफ़ करें
desktop-import-complete = आयात पूर्ण
desktop-import-dup-sha = SHA-256
desktop-import-dup-sop = SOP UID
desktop-import-dup-total = कुल
desktop-import-duplicates = डुप्लिकेट
desktop-import-failed = आयात विफल
desktop-import-failed-cleanup = सफ़ाई विफल
desktop-import-failures = विफलताएँ
desktop-import-failures-heading =
    { $count ->
        [one] { $count } विफलता:
       *[other] { $count } विफलताएँ:
    }
desktop-import-failures-more = … और { $count } और
desktop-import-files-progress = { $label } फ़ाइलें
desktop-import-folder = फ़ोल्डर
desktop-import-invalid-dicom = अमान्य DICOM
desktop-import-pick-dir = आयात के लिए डिरेक्टरी चुनें
desktop-import-pick-zip = आयात के लिए ZIP चुनें
desktop-import-placeholder = /path/to/dicom-folder or /path/to/archive.zip
desktop-import-rejected = अस्वीकृत
desktop-import-report = आयात रिपोर्ट
desktop-import-running = आयात हो रहा है…
desktop-import-scanned = स्कैन
desktop-import-skipped = छोड़ा गया
desktop-import-source = स्रोत
desktop-import-start = आयात शुरू करें
desktop-import-stored = संग्रहीत
desktop-import-subtitle = पुनरावर्ती फ़ोल्डर या ZIP से DICOM फ़ाइलें प्रबंधित स्थानीय संग्रह में अनुक्रमित करें।
desktop-import-title = आयात
desktop-import-unreadable = अपठनीय
desktop-import-zip = ZIP
desktop-import-zip-filter = ZIP संग्रह
desktop-lang-label = भाषा
desktop-listener-not-loaded = Listener अभी लोड नहीं हुआ।
desktop-live-counters = लाइव काउंटर
desktop-loading = लोड हो रहा है
desktop-loading-local-status = स्थानीय स्थिति लोड हो रही है…
desktop-loading-metrics = मेट्रिक्स लोड हो रहे हैं…
desktop-loading-studies = अध्ययन लोड हो रहे हैं…
desktop-local-node = स्थानीय नोड
desktop-locale-label = भाषा
desktop-logs-activity-detail =
    { $count ->
        [one] { $count } पंक्ति लोड हुई
       *[other] { $count } पंक्तियाँ लोड हुईं
    }
desktop-logs-activity-fail = लॉग ताज़ा करना विफल
desktop-logs-activity-ok = लॉग ताज़ा हुआ
desktop-logs-auto = स्वतः
desktop-logs-auto-refresh = स्वतः ताज़ा
desktop-logs-empty = लॉग फ़ाइल खाली है।
desktop-logs-found = लॉग फ़ाइल मिली
desktop-logs-lines =
    { $count ->
        [one] { $count } पंक्ति
       *[other] { $count } पंक्तियाँ
    }
desktop-logs-loading = लॉग लोड हो रहा है…
desktop-logs-missing = सक्रिय लॉग फ़ाइल अभी बनाई नहीं गई।
desktop-logs-refresh-failed = लॉग ताज़ा करना विफल
desktop-logs-refreshed = लॉग ताज़ा हुआ
desktop-logs-reveal = दिखाएँ
desktop-logs-subtitle = सक्रिय डेस्कटॉप लॉग फ़ाइल की सीमित पूँछ।
desktop-logs-tail = पूँछ
desktop-logs-title = लॉग
desktop-logs-truncated = काटा गया
desktop-logs-waiting = लॉग फ़ाइल की प्रतीक्षा
desktop-metric-instances = इंस्टेंस
desktop-metric-remote-nodes = दूरस्थ नोड
desktop-metric-series = सीरीज़
desktop-metric-studies = अध्ययन
desktop-nav-archive = स्थानीय संग्रह
desktop-nav-dashboard = डैशबोर्ड
desktop-nav-import = आयात
desktop-nav-logs = लॉग
desktop-nav-network = नेटवर्क
desktop-nav-nodes = दूरस्थ नोड
desktop-nav-query = क्वेरी / पुनर्प्राप्ति
desktop-nav-server = स्टोरेज सर्वर
desktop-no-local-studies = अभी कोई स्थानीय अध्ययन नहीं।
desktop-nodes-add = नोड जोड़ें
desktop-nodes-added = नोड "{ $name }" जोड़ा गया।
desktop-nodes-ae-length = AE Title अधिकतम 16 वर्ण का होना चाहिए।
desktop-nodes-ae-title = AE Title
desktop-nodes-col-move = Move गंतव्य
desktop-nodes-configured = कॉन्फ़िगर नोड
desktop-nodes-confirm-delete = नोड "{ $name }" हटाएँ?
desktop-nodes-default-port = डिफ़ॉल्ट पोर्ट 104
desktop-nodes-delete = नोड हटाएँ
desktop-nodes-delete-title = नोड हटाएँ
desktop-nodes-deleted = नोड "{ $name }" हटाया गया।
desktop-nodes-edit = नोड संपादित करें
desktop-nodes-edit-title = नोड संपादित करें
desktop-nodes-empty = अभी कोई दूरस्थ नोड नहीं।
desktop-nodes-err-ae = AE title आवश्यक है.
desktop-nodes-err-ae-len = AE title अधिकतम 16 वर्ण।
desktop-nodes-err-host = होस्ट आवश्यक है.
desktop-nodes-err-name = नाम आवश्यक है.
desktop-nodes-err-port = पोर्ट 1–65535 होना चाहिए.
desktop-nodes-host = होस्ट
desktop-nodes-move-dest = Move गंतव्य
desktop-nodes-move-placeholder = डिफ़ॉल्ट: स्थानीय AE
desktop-nodes-name = नाम
desktop-nodes-need-ae = AE Title आवश्यक है।
desktop-nodes-need-host = होस्ट आवश्यक है।
desktop-nodes-need-name = नाम आवश्यक है।
desktop-nodes-notes = नोट्स
desktop-nodes-notes-placeholder = रीडिंग रूम PACS
desktop-nodes-placeholder-ae = PACS01
desktop-nodes-placeholder-host = 192.168.0.10
desktop-nodes-placeholder-move = डिफ़ॉल्ट: स्थानीय AE
desktop-nodes-placeholder-name = main-pacs
desktop-nodes-placeholder-notes = रीडिंग रूम PACS
desktop-nodes-port = पोर्ट
desktop-nodes-port-104 = डिफ़ॉल्ट पोर्ट 104
desktop-nodes-port-range = पोर्ट 1–65535 होना चाहिए।
desktop-nodes-save = परिवर्तन सहेजें
desktop-nodes-save-changes = परिवर्तन सहेजें
desktop-nodes-subtitle = क्वेरी, पुनर्प्राप्ति और store के लिए PACS और वर्कस्टेशन पीयर।
desktop-nodes-summary = नोड सारांश
desktop-nodes-title = दूरस्थ नोड
desktop-nodes-total = कुल नोड
desktop-nodes-updated = नोड "{ $name }" अपडेट हुआ।
desktop-nodes-with-move = Move गंतव्य के साथ
desktop-promiscuous = असीमित स्टोरेज
desktop-query-accession = Accession संख्या
desktop-query-activity-detail = { $count } { $count ->
        [one] मिलान
       *[other] मिलान
    } स्तर { $level } पर
desktop-query-activity-fail = C-FIND { $node } विफल
desktop-query-activity-ok = C-FIND { $node }
desktop-query-activity-title = C-FIND { $node }
desktop-query-clear = साफ़ करें
desktop-query-col-accession = एक्सेशन
desktop-query-criteria = खोज मापदंड
desktop-query-date-from = अध्ययन तिथि से
desktop-query-date-to = अध्ययन तिथि तक
desktop-query-kv-series-uid = Series UID
desktop-query-kv-sop-uid = SOP UID
desktop-query-kv-study-uid = Study UID
desktop-query-level = स्तर
desktop-query-matches =
    { $count ->
        [one] { $count } मिलान
       *[other] { $count } मिलान
    }
desktop-query-missing-study-uid = मिलान में StudyInstanceUID नहीं; पुनर्प्राप्त नहीं कर सकते।
desktop-query-modality = मोडैलिटी
desktop-query-no-matches = कोई मिलान नहीं।
desktop-query-no-nodes = कोई नोड कॉन्फ़िगर नहीं
desktop-query-patient-id = रोगी ID
desktop-query-patient-name = रोगी का नाम
desktop-query-placeholder-description = CHEST*
desktop-query-placeholder-modality = CT, MR, …
desktop-query-placeholder-name = DOE^JOHN or DOE*
desktop-query-placeholder-patient = DOE^JOHN or DOE*
desktop-query-querying = क्वेरी हो रही है…
desktop-query-remote-node = दूरस्थ नोड
desktop-query-results = परिणाम
desktop-query-retrieve = पुनर्प्राप्त करें
desktop-query-retrieve-activity-detail = completed={ $completed }, warning={ $warning }, failed={ $failed }
desktop-query-retrieve-activity-fail = C-MOVE { $node } विफल
desktop-query-retrieve-activity-ok = C-MOVE { $node }
desktop-query-retrieve-finished = पुनर्प्राप्ति समाप्त: पूर्ण { $completed }, चेतावनी { $warning }, विफल { $failed }।
desktop-query-retrieve-selected = चयन पुनर्प्राप्त करें
desktop-query-run = C-FIND चलाएँ
desktop-query-run-select = क्वेरी चलाएँ और एक मिलान चुनें।
desktop-query-running = क्वेरी हो रही है…
desktop-query-search-criteria = खोज मापदंड
desktop-query-select-hint = क्वेरी चलाएँ और एक मिलान चुनें।
desktop-query-selected = चयनित मिलान
desktop-query-selected-match = चयनित मिलान
desktop-query-series-uid = Series Instance UID
desktop-query-sop-uid = SOP Instance UID
desktop-query-study-description = अध्ययन विवरण
desktop-query-study-uid = Study Instance UID
desktop-query-subtitle = दूरस्थ नोड पर C-FIND, मिलान जाँचें, फिर स्थानीय संग्रह में C-MOVE।
desktop-query-title = क्वेरी / पुनर्प्राप्ति
desktop-recent-studies = हाल के अध्ययन
desktop-scp-listening = SCP सुन रहा है
desktop-scp-stopped = SCP रुका
desktop-server-activity-fail = Storage SCP नियंत्रण विफल
desktop-server-activity-started = Storage SCP शुरू
desktop-server-activity-started-detail = Listener शुरू हुआ।
desktop-server-activity-stopped = Storage SCP रुका
desktop-server-activity-stopped-detail = received={ $received }, stored={ $stored }, failed={ $failed }
desktop-server-activity-stopped-empty = कोई सक्रिय सत्र नहीं।
desktop-server-addr-ae = { $addr } · AE { $ae }
desktop-server-assoc-accepted = स्वीकृत एसोसिएशन
desktop-server-assoc-rejected = अस्वीकृत एसोसिएशन
desktop-server-cfind-req-matches = C-FIND अनुरोध / मिलान
desktop-server-cget-requests = C-GET अनुरोध
desktop-server-cmove-requests = C-MOVE अनुरोध
desktop-server-cmove-subops = C-MOVE उप-संक्रिया पूर्ण / विफल
desktop-server-control-failed = Storage SCP नियंत्रण विफल
desktop-server-counter-bytes = गृहीत बाइट
desktop-server-counter-failed = C-STORE विफल
desktop-server-counter-find = C-FIND अनुरोध / मिलान
desktop-server-counter-get = C-GET अनुरोध
desktop-server-counter-move = C-MOVE अनुरोध
desktop-server-counter-move-sub = C-MOVE उप-संक्रिया पूर्ण / विफल
desktop-server-counter-received = C-STORE प्राप्त
desktop-server-counter-stored = C-STORE संग्रहीत
desktop-server-cstore-failed = C-STORE विफल
desktop-server-cstore-received = C-STORE प्राप्त
desktop-server-cstore-stored = C-STORE संग्रहीत
desktop-server-dimse = DIMSE काउंटर
desktop-server-failed = विफल
desktop-server-health-loading = मेट्रिक्स लोड हो रहे हैं
desktop-server-health-ready = इनबाउंड C-STORE के लिए तैयार
desktop-server-health-review = विफलताएँ देखें
desktop-server-health-stopped = रुका
desktop-server-listener-started = Listener शुरू हुआ।
desktop-server-listening = सुन रहा है
desktop-server-loading-metrics = मेट्रिक्स लोड हो रहे हैं…
desktop-server-logs = लॉग
desktop-server-no-session = कोई सक्रिय सत्र नहीं।
desktop-server-rate = +{ $rate } / पोल
desktop-server-ready = इनबाउंड C-STORE के लिए तैयार
desktop-server-review-failures = विफलताएँ देखें
desktop-server-session-ended = सत्र समाप्त: प्राप्त { $received }, संग्रहीत { $stored }, विफल { $failed }।
desktop-server-start = सर्वर शुरू करें
desktop-server-started-title = Storage SCP शुरू
desktop-server-stop = सर्वर रोकें
desktop-server-stopped = रुका
desktop-server-stopped-pill = रुका
desktop-server-stopped-status = रुका
desktop-server-stopped-title = Storage SCP रुका
desktop-server-stored = संग्रहीत
desktop-server-subtitle = इनबाउंड C-STORE और स्थानीय संग्रह अनुक्रमण के लिए स्वतंत्र Storage SCP।
desktop-server-title = स्टोरेज सर्वर
desktop-status-listening = सुन रहा है
desktop-status-loading = लोड हो रहा है
desktop-status-scp-listening = SCP सुन रहा है
desktop-status-scp-stopped = SCP रुका
desktop-status-stopped = रुका
desktop-store-syntax = Store सिंटैक्स
desktop-strict-pdu = कठोर PDU
desktop-strip-pdu = PDU { $value }
desktop-table-accession = एक्सेशन
desktop-table-ae-title = AE title
desktop-table-date = तिथि
desktop-table-description = विवरण
desktop-table-endpoint = एंडपॉइंट
desktop-table-instances = इंस्टेंस
desktop-table-modalities = मोडैलिटी
desktop-table-modality = मोडैलिटी
desktop-table-move-dest = Move गंतव्य
desktop-table-name = नाम
desktop-table-notes = नोट्स
desktop-table-patient = रोगी
desktop-table-patient-id = रोगी ID
desktop-table-series = सीरीज़
desktop-table-updated = अपडेटेड
desktop-title-refresh-status = स्थिति ताज़ा करें
desktop-title-reveal-log = लॉग फ़ाइल दिखाएँ
ae = AE
patient-name =
    "DOE^JOHN"
    चयनित परिणाम पर retrieve खोलने के लिए 'm' दबाएँ।
port = पोर्ट

## Summary
summary-ae = AE
summary-counts = गणना
summary-criteria = मानदंड
summary-duration = अवधि
summary-duration-ms = { $ms }ms
summary-failures = विफलताएँ:
summary-kind = प्रकार
summary-logs = लॉग:
summary-peer = पीयर
summary-status = स्थिति
summary-title = ऑपरेशन सारांश
tui-detail-created = बनाया गया

tui-form-hint-port-range = संकेत: 1 से 65535 तक की संख्या, जैसे 104
tui-form-hint-promiscuous = संकेत: किसी भी कॉलिंग AE title से स्टोरेज अनुमति दें
tui-form-hint-strict-pdu = संकेत: असोसिएशन के दौरान PDU आकार जाँच लागू करें
tui-form-hint-max-pdu-bytes = संकेत: बाइट, जैसे 16384
tui-form-limits-heading = Limits (bytes; blank/कोई नहीं = unlimited):
tui-form-field-max-file-import = अधिकतम फ़ाइल आयात बाइट
tui-form-field-max-zip-entry = अधिकतम ZIP प्रविष्टि बाइट
tui-form-field-max-zip-total = अधिकतम कुल ZIP बाइट
tui-form-field-max-zip-count = अधिकतम ZIP प्रविष्टि संख्या
tui-form-field-max-store-object = अधिकतम स्टोर ऑब्जेक्ट बाइट
tui-form-unlimited = असीमित
tui-form-err-max-pdu-required = ! अधिकतम PDU लंबाई आवश्यक है
tui-form-err-max-pdu-gt-zero = ! अधिकतम PDU लंबाई 0 से बड़ा पूर्णांक होनी चाहिए
tui-form-err-limit-gt-zero = ! { $label } 0 से बड़ा पूर्णांक होना चाहिए
tui-form-controls-scp = संपादित करने के लिए टाइप करें। Space चेकबॉक्स टॉगल करता है। Tab/Shift-Tab या ऊपर/नीचे फ़ील्ड बदलते हैं। Enter सहेजता है। Esc रद्द करता है।
tui-form-submit-uid-required = UID आवश्यक है
tui-form-submit-dest-required = destination नोड is required
tui-form-submit-nonneg-int = { $label } गैर-ऋणात्मक पूर्णांक होना चाहिए
tui-form-submit-gt-zero = { $label } 0 से बड़ा होना चाहिए
tui-form-submit-local-ae-required = स्थानीय AE title आवश्यक है
tui-form-submit-local-ae-invalid = स्थानीय AE title अमान्य है: { $err }
tui-form-submit-bind-required = बाइंड पता आवश्यक है
tui-form-submit-port-required = पोर्ट आवश्यक है
tui-form-submit-max-pdu-required = अधिकतम PDU लंबाई आवश्यक है
tui-form-submit-max-pdu-int = अधिकतम PDU लंबाई पूर्णांक होनी चाहिए
tui-form-submit-max-pdu-gt-zero = अधिकतम PDU लंबाई 0 से बड़ी होनी चाहिए
tui-form-submit-patient-retrieve = रोगी-स्तर पुनः प्राप्ति समर्थित नहीं है
tui-form-submit-no-study-uid = चयनित परिणाम में study UID नहीं है
tui-form-submit-date-format = अपेक्षित YYYYMMDD
tui-form-submit-modality-len = मोडैलिटी अधिकतम 16 वर्ण की होनी चाहिए
tui-form-submit-modality-chars = मोडैलिटी A-Z या 0-9 होनी चाहिए
tui-form-submit-name-required = नोड नाम आवश्यक है
tui-form-submit-ae-required = AE title आवश्यक है
tui-form-submit-host-required = होस्ट आवश्यक है
tui-form-submit-move-dest-invalid = मूव गंतव्य AE title अमान्य है: { $err }
tui-form-submit-dates-both = तिथि से और तिथि तक दोनों सेट हों, या कोई नहीं
tui-form-submit-date-from-invalid = तिथि से अमान्य है: { $err }
tui-form-submit-date-to-invalid = तिथि तक अमान्य है: { $err }
tui-form-submit-date-order = तिथि से, तिथि तक के समान या उससे पहले होनी चाहिए
tui-form-submit-study-uid-series-query = सीरीज़-स्तर क्वेरी के लिए study UID आवश्यक है
tui-form-submit-study-uid-image-query = छवि-स्तर क्वेरी के लिए study UID आवश्यक है
tui-form-submit-series-uid-image-query = छवि-स्तर क्वेरी के लिए series UID आवश्यक है
tui-form-submit-study-uid-required = study UID आवश्यक है
tui-form-submit-study-uid-invalid = study UID अमान्य है: { $err }
tui-form-submit-series-uid-series-retrieve = सीरीज़-स्तर पुनः प्राप्ति के लिए series UID आवश्यक है
tui-form-submit-series-uid-image-retrieve = छवि-स्तर पुनः प्राप्ति के लिए series UID आवश्यक है
tui-form-submit-instance-uid-image-retrieve = छवि-स्तर पुनः प्राप्ति के लिए instance UID आवश्यक है
tui-form-submit-series-uid-invalid = series UID अमान्य है: { $err }
tui-form-submit-instance-uid-invalid = instance UID अमान्य है: { $err }
tui-form-submit-import-path-required = आयात पथ आवश्यक है
tui-form-submit-import-path-type = आयात पथ फ़ाइल या निर्देशिका होना चाहिए: { $path }
tui-form-submit-import-access = आयात पथ तक पहुँच { $path }
tui-form-submit-import-open = आयात फ़ाइल खोल रहे हैं { $path }
tui-form-submit-import-read-dir = आयात निर्देशिका पढ़ रहे हैं { $path }
tui-log-welcome = Press F1 or ? for help. Focus रिमोट नोडs and press 'a' to add one.
tui-log-logging-to = लॉग हो रहा है { $path }
tui-command-help-heading = कमांड:
tui-command-help-next-1 = नोट: फ़ुटर चयनित फलक और चयन के आधार पर 'Next:' सुझाव दिखाता है।
tui-command-help-next-2 = ये केवल संकेत हैं; आप हमेशा कोई भी कमांड टाइप कर सकते हैं।
tui-command-help-canonical = नोट: कैनोनिकल नाम '--' के बिना CLI फ़्लैग से मेल खाते हैं और underscore इस्तेमाल करते हैं।
tui-command-help-cancel = cancel (उपनाम: stop)
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
tui-command-help-refresh = ताज़ा करें
tui-command-help-quit = बाहर
tui-inspect-task = कार्य #{ $id }
tui-inspect-status = स्थिति: { $status }
tui-inspect-description = विवरण: { $description }
tui-inspect-progress = प्रगति: { $progress }
tui-inspect-summary = सारांश:
tui-inspect-no-logs = (कोई लॉग नहीं)
tui-field-sop-class-uid = SOP Class UID
tui-field-transfer-syntax-uid = Transfer Syntax UID
tui-field-sha256 = SHA-256
tui-status-removed-nodes =
    हटाया { $count ->
        [one] { $count } नोड
       *[other] { $count } नोड
    }
tui-status-removed-nodes-target =
    हटाया { $count ->
        [one] { $count } नोड
       *[other] { $count } नोड
    }; अंतिम लक्ष्य { $name }
tui-status-more-failures =
    और { $n ->
        [one] { $n } विफलता छोड़ी गई
       *[other] { $n } विफलताएँ छोड़ी गईं
    }
tui-status-retrieve-ok = retrieve status=0x{ $status } completed={ $completed } failed={ $failed } warning={ $warning } remaining={ $remaining }
tui-status-import-counts = scanned={ $scanned } accepted={ $accepted } duplicates={ $duplicates } unreadable={ $unreadable } invalid_dicom={ $invalid } rejected_total={ $rejected } stored_bytes={ $bytes }
tui-status-send-ok = send attempted={ $attempted } sent={ $sent } failed={ $failed }
tui-log-query-start = { $node } के विरुद्ध क्वेरी शुरू
tui-log-retrieve-start = { $node } से पुनः प्राप्ति शुरू
tui-log-import-start = { $path } का आयात शुरू
tui-log-send-study-start = अध्ययन { $uid } को { $node } पर भेजना शुरू
tui-log-send-series-start = सीरीज़ { $uid } को { $node } पर भेजना शुरू
tui-log-cancelled-before-start = शुरू होने से पहले रद्द
tui-log-cancelled = रद्द
error-unknown-command = अज्ञात कमांड: { $command }
error-node-subcommand-required = node उपकमांड आवश्यक है
error-local-subcommand-required = local उपकमांड आवश्यक है
error-unsupported-node-subcommand = unsupported नोड subcommand: { $command }
error-unsupported-local-subcommand = असमर्थित local उपकमांड: { $command }
error-expected-kv = key=value तर्क अपेक्षित, मिला { $arg }
error-missing-required-arg = आवश्यक तर्क गुम: { $key }
error-missing-required-arg-one-of = आवश्यक तर्क गुम: इनमें से एक { $keys }
error-parsing-command = कमांड पार्स हो रही है
error-edit-form-lost-target = edit form lost its target नोड
error-task-already-running = पृष्ठभूमि कार्य पहले से चल रहा है
error-task-thread-launch = पृष्ठभूमि कार्य थ्रेड शुरू नहीं हो सका: { $error }
error-task-disconnected = परिणाम भेजने से पहले पृष्ठभूमि कार्य थ्रेड डिस्कनेक्ट हो गया
error-task-kind-missing = पृष्ठभूमि कार्य थ्रेड डिस्कनेक्ट हुआ पर active_task_kind None था: अप्रत्याशित स्थिति
error-serve-exited = serve त्रुटि के साथ बाहर हुआ: { $error }
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
summary-title = ऑपरेशन सारांश
summary-kind = प्रकार
summary-status = स्थिति
summary-duration = अवधि
summary-duration-ms = { $ms }ms
summary-peer = पीयर
summary-ae = AE
summary-criteria = मानदंड
summary-counts = गणना
summary-failures = विफलताएँ:
summary-logs = लॉग:
summary-unserializable = <क्रमबद्ध नहीं>
summary-log-lines = पंक्तियाँ { $start }-{ $end }
