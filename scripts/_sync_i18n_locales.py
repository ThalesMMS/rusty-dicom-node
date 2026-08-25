#!/usr/bin/env python3
"""Align i18n/*.ftl to en-US IDs; restore 'no' substring corruption; fill translations."""

from __future__ import annotations

import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1] / "i18n"
EN_PATH = ROOT / "en-US.ftl"

LOCALES = [
    "pt-BR",
    "es-ES",
    "fr-FR",
    "de-DE",
    "it-IT",
    "nl-NL",
    "pl-PL",
    "ja-JP",
    "zh-CN",
    "ko-KR",
    "ru-RU",
    "tr-TR",
    "ar",
    "sv-SE",
    "cs-CZ",
    "uk-UA",
    "hi-IN",
    "id-ID",
    "vi-VN",
]

MSG_START = re.compile(r"^([A-Za-z][A-Za-z0-9_-]*)\s*=\s*(.*)$")

# Keys whose English value is a machine token / CLI grammar / placeholder.
KEEP_ENGLISH = {
    "cli-arg-ae-title",
    "cli-arg-series-instance-uid",
    "cli-arg-sop-instance-uid",
    "cli-arg-study-instance-uid",
    "cli-import-accepted",
    "cli-import-duplicates",
    "cli-import-scanned",
    "cli-send-attempted",
    "cli-send-failed-count",
    "cli-send-sent",
    "cli-value-name-file",
    "cli-value-name-format",
    "cli-value-name-locale",
    "cli-value-name-path",
    "tui-config-max-pdu",
    "tui-config-promiscuous",
    "tui-config-strict-pdu",
    "tui-form-field-uid",
    "tui-form-field-instance-uid",
    "tui-form-field-series-uid",
    "tui-form-field-sop-uid",
    "tui-form-field-study-uid",
    "tui-field-instance-uid",
    "tui-field-series-uid",
    "tui-field-sop-uid",
    "tui-field-study-uid",
    "tui-help-max-pdu",
    "tui-help-promiscuous",
    "tui-help-strict-pdu",
    "tui-help-ts-pref",
    "tui-log-command",
    "tui-command-help-cmds",
    "desktop-import-dup-sha",
    "desktop-import-dup-sop",
    "desktop-import-placeholder",
    "desktop-import-zip",
    "desktop-logs-auto",
    "desktop-nodes-placeholder-ae",
    "desktop-nodes-placeholder-host",
    "desktop-nodes-placeholder-name",
    "desktop-query-placeholder-description",
    "desktop-query-placeholder-modality",
    "desktop-query-placeholder-name",
    "desktop-query-placeholder-patient",
    "desktop-query-kv-series-uid",
    "desktop-query-kv-sop-uid",
    "desktop-query-kv-study-uid",
    "desktop-query-series-uid",
    "desktop-query-sop-uid",
    "desktop-query-study-uid",
    "tui-command-help-refresh",
    "tui-command-help-quit",
    "tui-field-sop-class-uid",
    "tui-field-transfer-syntax-uid",
    "tui-field-sha256",
    "cli-msg-node-list-row",
    "cli-msg-local-study-row",
    "cli-import-unreadable",
    "cli-import-invalid-dicom",
    "cli-import-rejected-total",
    "cli-import-skipped",
    "cli-import-failed-cleanup",
    "cli-import-total",
    "cli-import-stored-bytes",
    "cli-import-dup-detail",
    "tui-status-retrieve-ok",
    "tui-status-import-counts",
    "tui-status-send-ok",
    "summary-unserializable",
    "desktop-query-retrieve-activity-detail",
    "desktop-query-activity-ok",
    "desktop-query-retrieve-activity-ok",
    "desktop-server-activity-stopped-detail",
    "desktop-archive-study-uid",
    "ae",
}


def parse_ftl(source: str) -> dict[str, str]:
    messages: dict[str, str] = {}
    current: str | None = None
    buf: list[str] = []

    def flush() -> None:
        nonlocal current, buf
        if current is not None:
            messages[current] = "\n".join(buf)
        current, buf = None, []

    for line in source.splitlines():
        if line.startswith((" ", "\t")):
            if current is not None:
                buf.append(line)
            continue
        stripped = line.strip()
        if not stripped or stripped.startswith("#"):
            continue
        m = MSG_START.match(line)
        if m:
            flush()
            current = m.group(1)
            rest = m.group(2)
            buf = [rest] if rest != "" else [""]
            continue
    flush()
    return messages


def parse_en_structure(source: str) -> list[tuple[str, str]]:
    """Return sequence of ('raw', text) or ('msg', key)."""
    events: list[tuple[str, str]] = []
    pending_raw: list[str] = []
    current: str | None = None

    def flush_raw() -> None:
        if pending_raw:
            events.append(("raw", "\n".join(pending_raw)))
            pending_raw.clear()

    for line in source.splitlines():
        if current is not None and line.startswith((" ", "\t")):
            continue
        m = MSG_START.match(line) if not line.startswith((" ", "\t")) else None
        if m:
            flush_raw()
            current = m.group(1)
            events.append(("msg", current))
            continue
        current = None
        pending_raw.append(line)
    flush_raw()
    return events


def format_message(key: str, value: str) -> str:
    if "\n" in value:
        body = value if value.startswith("\n") else "\n" + value
        # values stored without leading newline have first line inline
        if value.startswith("\n"):
            return f"{key} ={body}"
        first, _, rest = value.partition("\n")
        if first == "":
            return f"{key} =\n{rest}"
        return f"{key} = {first}\n{rest}"
    return f"{key} = {value}"


def restore_no_corruption(loc_val: str, en_val: str, no_word: str) -> str:
    if loc_val.strip() == en_val.strip():
        return en_val
    if not no_word or no_word == "no":
        return loc_val
    if no_word not in loc_val:
        return loc_val
    undone = loc_val.replace(no_word, "no")
    if undone.strip() == en_val.strip() and en_val.strip().lower() != "no":
        return en_val
    return loc_val


def unsplice_no(val: str, no_word: str) -> str:
    if not no_word or no_word == "no":
        return val
    val = val.replace(no_word + "des", "nodes")
    val = val.replace(no_word + "de", "node")
    return val


def looks_like_stub(val: str, no_word: str = "") -> bool:
    v = val.strip()
    if no_word and no_word != "no" and (no_word + "de") in v:
        return True
    return (
        v.startswith("Action ")
        or v.startswith("Summary ")
        or v.startswith("Desktop nodes ")
        or v.startswith("Desktop neindes ")
        or v.startswith("Counter ")
        or v.startswith("Server ")
        or "Select a " in v
        or v.startswith("Delete ")
        or " remote node " in v
        or " remote node{" in v
        or "neinde" in v
        or "nonde" in v
        or "tidakde" in v
        or "khôngde" in v
    )


# locale index in pipe tables
LI = {loc: i for i, loc in enumerate(LOCALES)}


def split19(row: str) -> list[str]:
    parts = row.split("|")
    if len(parts) != 19:
        raise SystemExit(f"expected 19 parts, got {len(parts)}: {row[:80]!r}")
    return parts


def table(row: str) -> dict[str, str]:
    parts = split19(row)
    return {loc: parts[i] for i, loc in enumerate(LOCALES)}


# Short / sentence translations: 19 locales, pipe-separated, LOCALES order.
T: dict[str, dict[str, str]] = {}


def put(key: str, row: str) -> None:
    T[key] = table(row)


put("common-accession", "Acesso|Acceso|Numéro d’accès|Accession|Accesso|Accessie|Numer dostępu|受付番号|检查号|접수번호|Номер обращения|Kabul no.|رقم القبول|Accession|Accession|Номер звернення|एक्सेशन|Aksesi|Số accession")
put("common-add", "Adicionar|Añadir|Ajouter|Hinzufügen|Aggiungi|Toevoegen|Dodaj|追加|添加|추가|Добавить|Ekle|إضافة|Lägg till|Přidat|Додати|जोड़ें|Tambah|Thêm")
put("common-back", "Voltar|Atrás|Retour|Zurück|Indietro|Terug|Wstecz|戻る|返回|뒤로|Назад|Geri|رجوع|Tillbaka|Zpět|Назад|वापस|Kembali|Quay lại")
put("common-bytes", "Bytes|Bytes|Octets|Bytes|Byte|Bytes|Bajty|バイト|字节|바이트|Байты|Bayt|بايت|Byte|Bajty|Байти|बाइट|Byte|Byte")
put("common-clear", "Limpar|Borrar|Effacer|Leeren|Cancella|Wissen|Wyczyść|クリア|清除|지우기|Очистить|Temizle|مسح|Rensa|Vymazat|Очистити|साफ़ करें|Hapus|Xóa")
put("common-close", "Fechar|Cerrar|Fermer|Schließen|Chiudi|Sluiten|Zamknij|閉じる|关闭|닫기|Закрыть|Kapat|إغلاق|Stäng|Zavřít|Закрити|बंद करें|Tutup|Đóng")
put("common-date", "Data|Fecha|Date|Datum|Data|Datum|Data|日付|日期|날짜|Дата|Tarih|التاريخ|Datum|Datum|Дата|तिथि|Tanggal|Ngày")
put("common-duplicates", "Duplicatas|Duplicados|Doublons|Duplikate|Duplicati|Duplicaten|Duplikaty|重複|重复|중복|Дубликаты|Yinelenenler|تكرارات|Dubbletter|Duplikáty|Дублікати|डुप्लिकेट|Duplikat|Trùng lặp")
put("common-edit", "Editar|Editar|Modifier|Bearbeiten|Modifica|Bewerken|Edytuj|編集|编辑|편집|Изменить|Düzenle|تحرير|Redigera|Upravit|Редагувати|संपादित करें|Edit|Sửa")
put("common-error", "Erro|Error|Erreur|Fehler|Errore|Fout|Błąd|エラー|错误|오류|Ошибка|Hata|خطأ|Fel|Chyba|Помилка|त्रुटि|Kesalahan|Lỗi")
put("common-filter", "Filtro|Filtro|Filtre|Filter|Filtro|Filter|Filtr|フィルター|筛选|필터|Фильтр|Filtre|تصفية|Filter|Filtr|Фільтр|फ़िल्टर|Filter|Bộ lọc")
put("common-host", "Host|Host|Hôte|Host|Host|Host|Host|ホスト|主机|호스트|Хост|Host|المضيف|Värd|Host|Хост|होस्ट|Host|Host")
put("common-instance", "Instância|Instancia|Instance|Instanz|Istanza|Instantie|Instancja|インスタンス|实例|인스턴스|Инстанс|Örnek|مثيل|Instans|Instance|Примірник|इंस्टेंस|Instans|Phiên bản")
put("common-matches", "Correspondências|Coincidencias|Correspondances|Treffer|Corrispondenze|Overeenkomsten|Dopasowania|一致|匹配|일치|Совпадения|Eşleşmeler|تطابقات|Träffar|Shody|Збіги|मेल|Cocokan|Khớp")
put("common-name", "Nome|Nombre|Nom|Name|Nome|Naam|Nazwa|名前|名称|이름|Имя|Ad|الاسم|Namn|Název|Ім’я|नाम|Nama|Tên")
put("common-none", "nenhum|ninguno|aucun|keine|nessuno|geen|brak|なし|无|없음|нет|yok|لا شيء|ingen|žádné|немає|कोई नहीं|tidak ada|không")
put("common-optional", "opcional|opcional|facultatif|optional|facoltativo|optioneel|opcjonalne|任意|可选|선택|необязательно|isteğe bağlı|اختياري|valfritt|volitelné|необов’язково|वैकल्पिक|opsional|tùy chọn")
put("common-patient", "Paciente|Paciente|Patient|Patient|Paziente|Patiënt|Pacjent|患者|患者|환자|Пациент|Hasta|المريض|Patient|Pacient|Пацієнт|रोगी|Pasien|Bệnh nhân")
put("common-port", "Porta|Puerto|Port|Port|Porta|Poort|Port|ポート|端口|포트|Порт|Port|المنفذ|Port|Port|Порт|पोर्ट|Port|Cổng")
put("common-required", "obrigatório|obligatorio|obligatoire|erforderlich|obbligatorio|vereist|wymagane|必須|必填|필수|обязательно|zorunlu|مطلوب|obligatoriskt|povinné|обов’язково|आवश्यक|wajib|bắt buộc")
put("common-retrieve", "Recuperar|Recuperar|Récupérer|Abrufen|Recupera|Ophalen|Pobierz|取得|检索|검색|Извлечь|Getir|استرداد|Hämta|Načíst|Отримати|पुनर्प्राप्त करें|Ambil|Truy xuất")
put("common-save", "Salvar|Guardar|Enregistrer|Speichern|Salva|Opslaan|Zapisz|保存|保存|저장|Сохранить|Kaydet|حفظ|Spara|Uložit|Зберегти|सहेजें|Simpan|Lưu")
put("common-search", "Pesquisar|Buscar|Rechercher|Suchen|Cerca|Zoeken|Szukaj|検索|搜索|검색|Поиск|Ara|بحث|Sök|Hledat|Пошук|खोजें|Cari|Tìm")
put("common-start", "Iniciar|Iniciar|Démarrer|Starten|Avvia|Starten|Uruchom|開始|开始|시작|Запуск|Başlat|بدء|Starta|Spustit|Запустити|शुरू करें|Mulai|Bắt đầu")
put("common-status", "Status|Estado|État|Status|Stato|Status|Status|状態|状态|상태|Статус|Durum|الحالة|Status|Stav|Статус|स्थिति|Status|Trạng thái")
put("common-stop", "Parar|Detener|Arrêter|Stoppen|Arresta|Stoppen|Zatrzymaj|停止|停止|중지|Стоп|Durdur|إيقاف|Stoppa|Zastavit|Зупинити|रोकें|Berhenti|Dừng")
put("common-study", "Estudo|Estudio|Étude|Studie|Studio|Onderzoek|Badanie|スタディ|检查|스터디|Исследование|Çalışma|دراسة|Undersökning|Vyšetření|Дослідження|अध्ययन|Studi|Ca khám")
put("common-unknown", "desconhecido|desconocido|inconnu|unbekannt|sconosciuto|onbekend|nieznany|不明|未知|알 수 없음|неизвестно|bilinmiyor|غير معروف|okänd|neznámý|невідомо|अज्ञात|tidak dikenal|không rõ")
put("common-no", "não|no|non|nein|no|nee|nie|いいえ|否|아니요|нет|hayır|لا|nej|ne|ні|नहीं|tidak|không")
put("tui-bool-no", "não|no|non|nein|no|nee|nie|いいえ|否|아니요|нет|hayır|لا|nej|ne|ні|नहीं|tidak|không")
put("desktop-common-no", "não|no|non|nein|no|nee|nie|いいえ|否|아니요|нет|hayır|لا|nej|ne|ні|नहीं|tidak|không")
put("cli-arg-port", "Porta|Puerto|Port|Port|Porta|Poort|Port|ポート|端口|포트|Порт|Port|المنفذ|Port|Port|Порт|पोर्ट|Port|Cổng")
put("tui-inspect-summary", "Resumo:|Resumen:|Résumé :|Zusammenfassung:|Riepilogo:|Samenvatting:|Podsumowanie:|概要:|摘要：|요약:|Сводка:|Özet:|الملخص:|Sammanfattning:|Shrnutí:|Підсумок:|सारांश:|Ringkasan:|Tóm tắt:")
put("summary-title", "Resumo da operação|Resumen de la operación|Résumé de l’opération|Operationszusammenfassung|Riepilogo operazione|Bewerkingssamenvatting|Podsumowanie operacji|操作の要約|操作摘要|작업 요약|Сводка операции|İşlem özeti|ملخص العملية|Åtgärdssammanfattning|Souhrn operace|Підсумок операції|ऑपरेशन सारांश|Ringkasan operasi|Tóm tắt thao tác")
put("summary-kind", "Tipo|Tipo|Type|Art|Tipo|Soort|Rodzaj|種類|类型|종류|Тип|Tür|النوع|Typ|Druh|Тип|प्रकार|Jenis|Loại")
put("summary-status", "Status|Estado|État|Status|Stato|Status|Status|状態|状态|상태|Статус|Durum|الحالة|Status|Stav|Статус|स्थिति|Status|Trạng thái")
put("summary-duration", "Duração|Duración|Durée|Dauer|Durata|Duur|Czas|所要時間|时长|소요 시간|Длительность|Süre|المدة|Varaktighet|Trvání|Тривалість|अवधि|Durasi|Thời lượng")
put("summary-peer", "Peer|Peer|Pair|Peer|Peer|Peer|Peer|ピア|对端|피어|Узел|Eş|النظير|Peer|Peer|Вузол|पीयर|Peer|Peer")
put("summary-criteria", "Critérios|Criterios|Critères|Kriterien|Criteri|Criteria|Kryteria|条件|条件|조건|Критерии|Kriterler|المعايير|Kriterier|Kritéria|Критерії|मानदंड|Kriteria|Tiêu chí")
put("summary-counts", "Contagens|Recuentos|Compteurs|Zähler|Conteggi|Aantallen|Liczniki|件数|计数|개수|Счётчики|Sayaçlar|العدادات|Antal|Počty|Лічильники|गणना|Jumlah|Đếm")
put("summary-failures", "Falhas:|Fallos:|Échecs :|Fehler:|Errori:|Fouten:|Błędy:|失敗:|失败：|실패:|Сбои:|Hatalar:|الإخفاقات:|Fel:|Selhání:|Збої:|विफलताएँ:|Kegagalan:|Thất bại:")
put("summary-logs", "Logs:|Registros:|Journaux :|Protokolle:|Log:|Logboeken:|Dzienniki:|ログ:|日志：|로그:|Журналы:|Günlükler:|السجلات:|Loggar:|Protokoly:|Журнали:|लॉग:|Log:|Nhật ký:")
put("tui-inspect-no-logs", "(sem logs)|(sin registros)|(aucun journal)|(keine Protokolle)|(nessun log)|(geen logboeken)|(brak dzienników)|(ログなし)|(无日志)|(로그 없음)|(нет журналов)|(günlük yok)|(لا توجد سجلات)|(inga loggar)|(žádné protokoly)|(немає журналів)|(कोई लॉग नहीं)|(tidak ada log)|(không có nhật ký)")
put("error-unknown-command", "comando desconhecido: { $command }|comando desconocido: { $command }|commande inconnue : { $command }|unbekannter Befehl: { $command }|comando sconosciuto: { $command }|onbekende opdracht: { $command }|nieznane polecenie: { $command }|不明なコマンド: { $command }|未知命令：{ $command }|알 수 없는 명령: { $command }|неизвестная команда: { $command }|bilinmeyen komut: { $command }|أمر غير معروف: { $command }|okänt kommando: { $command }|neznámý příkaz: { $command }|невідома команда: { $command }|अज्ञात कमांड: { $command }|perintah tidak dikenal: { $command }|lệnh không rõ: { $command }")
put("tui-status-select-node", "selecione um nó remoto primeiro|seleccione un nodo remoto primero|sélectionnez d’abord un nœud distant|wählen Sie zuerst einen entfernten Knoten|seleziona prima un nodo remoto|selecteer eerst een extern knooppunt|najpierw wybierz zdalny węzeł|先にリモートノードを選択してください|请先选择远程节点|먼저 원격 노드를 선택하세요|сначала выберите удалённый узел|önce uzak bir düğüm seçin|حدد عقدة بعيدة أولاً|välj en fjärrnod först|nejprve vyberte vzdálený uzel|спочатку виберіть віддалений вузол|पहले एक रिमोट नोड चुनें|pilih node jarak jauh terlebih dahulu|hãy chọn một nút từ xa trước")


# Query empty body (CLI tokens kept).
QUERY_SELECT = table(
    "Selecione um nó remoto e pressione 'f' para consultar.|"
    "Seleccione un nodo remoto y pulse 'f' para consultar.|"
    "Sélectionnez un nœud distant et appuyez sur 'f' pour interroger.|"
    "Wählen Sie einen entfernten Knoten und drücken Sie 'f' für eine Abfrage.|"
    "Seleziona un nodo remoto e premi 'f' per interrogare.|"
    "Selecteer een extern knooppunt en druk op 'f' om te zoeken.|"
    "Wybierz zdalny węzeł i naciśnij 'f', aby wykonać zapytanie.|"
    "リモートノードを選び、'f' で照会します。|"
    "选择远程节点并按 'f' 进行查询。|"
    "원격 노드를 선택한 다음 'f'를 눌러 조회합니다.|"
    "Выберите удалённый узел и нажмите 'f' для запроса.|"
    "Uzak bir düğüm seçin ve sorgulamak için 'f' tuşuna basın.|"
    "حدد عقدة بعيدة واضغط 'f' للاستعلام.|"
    "Välj en fjärrnod och tryck på 'f' för att fråga.|"
    "Vyberte vzdálený uzel a stiskněte 'f' pro dotaz.|"
    "Виберіть віддалений вузол і натисніть 'f' для запиту.|"
    "रिमोट नोड चुनें और क्वेरी के लिए 'f' दबाएँ।|"
    "Pilih node jarak jauh lalu tekan 'f' untuk kueri.|"
    "Chọn nút từ xa và nhấn 'f' để truy vấn."
)
QUERY_MOVE = table(
    "Pressione 'm' em um resultado selecionado para abrir a recuperação.|"
    "Pulse 'm' en un resultado seleccionado para abrir retrieve.|"
    "Appuyez sur 'm' sur un résultat sélectionné pour ouvrir retrieve.|"
    "Drücken Sie 'm' auf einem ausgewählten Ergebnis, um retrieve zu öffnen.|"
    "Premi 'm' su un risultato selezionato per aprire retrieve.|"
    "Druk op 'm' op een geselecteerd resultaat om retrieve te openen.|"
    "Naciśnij 'm' na wybranym wyniku, aby otworzyć retrieve.|"
    "選択した結果で 'm' を押すと retrieve を開きます。|"
    "在所选结果上按 'm' 打开 retrieve。|"
    "선택한 결과에서 'm'을 누르면 retrieve가 열립니다.|"
    "Нажмите 'm' на выбранном результате, чтобы открыть retrieve.|"
    "Seçili sonuçta retrieve açmak için 'm' tuşuna basın.|"
    "اضغط 'm' على نتيجة محددة لفتح retrieve.|"
    "Tryck på 'm' på ett valt resultat för att öppna retrieve.|"
    "Stiskněte 'm' na vybraném výsledku pro otevření retrieve.|"
    "Натисніть 'm' на вибраному результаті, щоб відкрити retrieve.|"
    "चयनित परिणाम पर retrieve खोलने के लिए 'm' दबाएँ।|"
    "Tekan 'm' pada hasil terpilih untuk membuka retrieve.|"
    "Nhấn 'm' trên kết quả đã chọn để mở retrieve."
)
QUERY_OR = table(
    "Ou: query node=pacs|O: query node=pacs|Ou : query node=pacs|Oder: query node=pacs|"
    "Oppure: query node=pacs|Of: query node=pacs|Lub: query node=pacs|または: query node=pacs|"
    "或者：query node=pacs|또는: query node=pacs|Или: query node=pacs|Veya: query node=pacs|"
    "أو: query node=pacs|Eller: query node=pacs|Nebo: query node=pacs|Або: query node=pacs|"
    "या: query node=pacs|Atau: query node=pacs|Hoặc: query node=pacs"
)


def query_body(loc: str) -> str:
    return (
        f"\n    {QUERY_SELECT[loc]}\n"
        f"    {QUERY_OR[loc]}\n"
        '        patient_name="DOE^JOHN"\n'
        f"    {QUERY_MOVE[loc]}"
    )


T["tui-empty-query-hint"] = QUERY_SELECT
T["tui-empty-query-retrieve-hint"] = QUERY_MOVE

put(
    "tui-detail-select-node",
    "Selecione um nó remoto para inspecionar os metadados.|"
    "Seleccione un nodo remoto para inspeccionar sus metadatos.|"
    "Sélectionnez un nœud distant pour inspecter ses métadonnées.|"
    "Wählen Sie einen entfernten Knoten, um dessen Metadaten zu prüfen.|"
    "Seleziona un nodo remoto per ispezionarne i metadati.|"
    "Selecteer een extern knooppunt om de metadata te bekijken.|"
    "Wybierz zdalny węzeł, aby sprawdzić jego metadane.|"
    "リモートノードを選んでメタデータを確認します。|"
    "选择远程节点以查看其元数据。|"
    "원격 노드를 선택하여 메타데이터를 확인하세요.|"
    "Выберите удалённый узел, чтобы просмотреть его метаданные.|"
    "Metaverilerini incelemek için uzak bir düğüm seçin.|"
    "حدد عقدة بعيدة لفحص بياناتها الوصفية.|"
    "Välj en fjärrnod för att granska dess metadata.|"
    "Vyberte vzdálený uzel pro kontrolu metadat.|"
    "Виберіть віддалений вузол, щоб переглянути його метадані.|"
    "मेटाडेटा देखने के लिए रिमोट नोड चुनें।|"
    "Pilih node jarak jauh untuk memeriksa metadatanya.|"
    "Chọn nút từ xa để xem siêu dữ liệu.",
)
T["tui-empty-detail-node"] = T["tui-detail-select-node"]

put(
    "tui-empty-detail-query",
    "Selecione um resultado de consulta para inspecionar metadados e o contexto de retrieve.|"
    "Seleccione un resultado de consulta para inspeccionar metadatos y el contexto de retrieve.|"
    "Sélectionnez un résultat de requête pour inspecter les métadonnées et le contexte retrieve.|"
    "Wählen Sie ein Abfrageergebnis, um Metadaten und den Retrieve-Kontext zu prüfen.|"
    "Seleziona un risultato di query per ispezionare metadati e contesto retrieve.|"
    "Selecteer een queryresultaat om metadata en retrieve-context te bekijken.|"
    "Wybierz wynik zapytania, aby sprawdzić metadane i kontekst retrieve.|"
    "クエリ結果を選んでメタデータと retrieve の文脈を確認します。|"
    "选择查询结果以查看元数据和 retrieve 上下文。|"
    "조회 결과를 선택하여 메타데이터와 retrieve 맥락을 확인하세요.|"
    "Выберите результат запроса, чтобы просмотреть метаданные и контекст retrieve.|"
    "Retrieve bağlamını ve üst veriyi incelemek için bir sorgu sonucu seçin.|"
    "حدد نتيجة استعلام لفحص البيانات الوصفية وسياق retrieve.|"
    "Välj ett frågeresultat för att granska metadata och retrieve-kontext.|"
    "Vyberte výsledek dotazu pro kontrolu metadat a kontextu retrieve.|"
    "Виберіть результат запиту, щоб переглянути метадані та контекст retrieve.|"
    "retrieve संदर्भ और मेटाडेटा देखने के लिए क्वेरी परिणाम चुनें।|"
    "Pilih hasil kueri untuk memeriksa metadata dan konteks retrieve.|"
    "Chọn kết quả truy vấn để xem siêu dữ liệu và ngữ cảnh retrieve.",
)
put(
    "tui-empty-detail-series",
    "Selecione uma série para inspecioná-la, ou volte aos estudos com Esc.|"
    "Seleccione una serie para inspeccionarla, o vuelva a los estudios con Esc.|"
    "Sélectionnez une série pour l’inspecter, ou revenez aux études avec Échap.|"
    "Wählen Sie eine Serie zur Prüfung, oder kehren Sie mit Esc zu den Studien zurück.|"
    "Seleziona una serie per ispezionarla, oppure torna agli studi con Esc.|"
    "Selecteer een serie om te bekijken, of ga met Esc terug naar studies.|"
    "Wybierz serię, aby ją sprawdzić, albo wróć do badań klawiszem Esc.|"
    "シリーズを選んで確認するか、Esc でスタディに戻ります。|"
    "选择一个序列进行查看，或按 Esc 返回检查。|"
    "시리즈를 선택해 확인하거나 Esc로 스터디로 돌아가세요.|"
    "Выберите серию для просмотра или вернитесь к исследованиям клавишей Esc.|"
    "İncelemek için bir seri seçin veya Esc ile çalışmalara dönün.|"
    "حدد سلسلة لفحصها، أو ارجع إلى الدراسات بمفتاح Esc.|"
    "Välj en serie för att granska den, eller gå tillbaka till undersökningar med Esc.|"
    "Vyberte sérii ke kontrole, nebo se klávesou Esc vraťte k vyšetřením.|"
    "Виберіть серію для перегляду або поверніться до досліджень клавішею Esc.|"
    "सीरीज़ चुनकर देखें, या Esc से अध्ययन पर लौटें।|"
    "Pilih seri untuk memeriksanya, atau kembali ke studi dengan Esc.|"
    "Chọn một chuỗi để xem, hoặc nhấn Esc để về các ca khám.",
)
put(
    "tui-empty-detail-study",
    "Selecione um estudo local para inspecionar metadados de paciente e séries.|"
    "Seleccione un estudio local para inspeccionar metadatos de paciente y series.|"
    "Sélectionnez une étude locale pour inspecter les métadonnées patient et séries.|"
    "Wählen Sie eine lokale Studie, um Patienten- und Serienmetadaten zu prüfen.|"
    "Seleziona uno studio locale per ispezionare metadati di paziente e serie.|"
    "Selecteer een lokale studie om patiënt- en seriemetadata te bekijken.|"
    "Wybierz lokalne badanie, aby sprawdzić metadane pacjenta i serii.|"
    "ローカルスタディを選んで患者とシリーズのメタデータを確認します。|"
    "选择本地检查以查看患者和序列元数据。|"
    "로컬 스터디를 선택하여 환자와 시리즈 메타데이터를 확인하세요.|"
    "Выберите локальное исследование, чтобы просмотреть метаданные пациента и серий.|"
    "Hasta ve seri üst verisini görmek için yerel bir çalışma seçin.|"
    "حدد دراسة محلية لفحص بيانات المريض والسلاسل.|"
    "Välj en lokal undersökning för att granska patient- och seriemetadata.|"
    "Vyberte místní vyšetření pro kontrolu metadat pacienta a sérií.|"
    "Виберіть локальне дослідження, щоб переглянути метадані пацієнта та серій.|"
    "रोगी और सीरीज़ मेटाडेटा देखने के लिए स्थानीय अध्ययन चुनें।|"
    "Pilih studi lokal untuk memeriksa metadata pasien dan seri.|"
    "Chọn một ca khám cục bộ để xem siêu dữ liệu bệnh nhân và chuỗi.",
)
put(
    "tui-empty-detail-instance",
    "Selecione uma instância para inspecioná-la, ou volte às séries com Esc.|"
    "Seleccione una instancia para inspeccionarla, o vuelva a las series con Esc.|"
    "Sélectionnez une instance pour l’inspecter, ou revenez aux séries avec Échap.|"
    "Wählen Sie eine Instanz zur Prüfung, oder kehren Sie mit Esc zu den Serien zurück.|"
    "Seleziona un'istanza per ispezionarla, oppure torna alle serie con Esc.|"
    "Selecteer een instantie om te bekijken, of ga met Esc terug naar series.|"
    "Wybierz instancję, aby ją sprawdzić, albo wróć do serii klawiszem Esc.|"
    "インスタンスを選んで確認するか、Esc でシリーズに戻ります。|"
    "选择一个实例进行查看，或按 Esc 返回序列。|"
    "인스턴스를 선택해 확인하거나 Esc로 시리즈로 돌아가세요.|"
    "Выберите инстанс для просмотра или вернитесь к сериям клавишей Esc.|"
    "İncelemek için bir örnek seçin veya Esc ile serilere dönün.|"
    "حدد مثيلًا لفحصه، أو ارجع إلى السلاسل بمفتاح Esc.|"
    "Välj en instans för att granska den, eller gå tillbaka till serier med Esc.|"
    "Vyberte instanci ke kontrole, nebo se klávesou Esc vraťte k sériím.|"
    "Виберіть примірник для перегляду або поверніться до серій клавішею Esc.|"
    "इंस्टेंस चुनकर देखें, या Esc से सीरीज़ पर लौटें।|"
    "Pilih instans untuk memeriksanya, atau kembali ke seri dengan Esc.|"
    "Chọn một phiên bản để xem, hoặc nhấn Esc để về chuỗi.",
)

put(
    "tui-form-delete-confirm",
    "Excluir o nó remoto { $name } [{ $ae }] em { $host }:{ $port }?|"
    "¿Eliminar el nodo remoto { $name } [{ $ae }] en { $host }:{ $port }?|"
    "Supprimer le nœud distant { $name } [{ $ae }] à { $host }:{ $port } ?|"
    "Entfernten Knoten { $name } [{ $ae }] unter { $host }:{ $port } löschen?|"
    "Eliminare il nodo remoto { $name } [{ $ae }] in { $host }:{ $port }?|"
    "Extern knooppunt { $name } [{ $ae }] op { $host }:{ $port } verwijderen?|"
    "Usunąć zdalny węzeł { $name } [{ $ae }] pod { $host }:{ $port }?|"
    "リモートノード { $name } [{ $ae }]（{ $host }:{ $port }）を削除しますか？|"
    "删除远程节点 { $name } [{ $ae }]（{ $host }:{ $port }）？|"
    "원격 노드 { $name } [{ $ae }] ({ $host }:{ $port })을(를) 삭제할까요?|"
    "Удалить удалённый узел { $name } [{ $ae }] по адресу { $host }:{ $port }?|"
    "Uzak düğüm { $name } [{ $ae }] ({ $host }:{ $port }) silinsin mi?|"
    "حذف العقدة البعيدة { $name } [{ $ae }] عند { $host }:{ $port }؟|"
    "Ta bort fjärrnoden { $name } [{ $ae }] på { $host }:{ $port }?|"
    "Smazat vzdálený uzel { $name } [{ $ae }] na { $host }:{ $port }?|"
    "Видалити віддалений вузол { $name } [{ $ae }] на { $host }:{ $port }?|"
    "रिमोट नोड { $name } [{ $ae }] को { $host }:{ $port } पर हटाएँ?|"
    "Hapus node jarak jauh { $name } [{ $ae }] di { $host }:{ $port }?|"
    "Xóa nút từ xa { $name } [{ $ae }] tại { $host }:{ $port }?",
)

put(
    "tui-empty-query-cmd",
    "Ou: query node=pacs|O: query node=pacs|Ou : query node=pacs|Oder: query node=pacs|"
    "Oppure: query node=pacs|Of: query node=pacs|Lub: query node=pacs|または: query node=pacs|"
    "或者：query node=pacs|또는: query node=pacs|Или: query node=pacs|Veya: query node=pacs|"
    "أو: query node=pacs|Eller: query node=pacs|Nebo: query node=pacs|Або: query node=pacs|"
    "या: query node=pacs|Atau: query node=pacs|Hoặc: query node=pacs",
)
put(
    "tui-empty-remote-nodes-cmd",
    "Ou: node add name=pacs|O: node add name=pacs|Ou : node add name=pacs|Oder: node add name=pacs|"
    "Oppure: node add name=pacs|Of: node add name=pacs|Lub: node add name=pacs|または: node add name=pacs|"
    "或者：node add name=pacs|또는: node add name=pacs|Или: node add name=pacs|Veya: node add name=pacs|"
    "أو: node add name=pacs|Eller: node add name=pacs|Nebo: node add name=pacs|Або: node add name=pacs|"
    "या: node add name=pacs|Atau: node add name=pacs|Hoặc: node add name=pacs",
)
put(
    "tui-empty-local-studies-cmd",
    "Exemplo: import path=/data/inbox|Ejemplo: import path=/data/inbox|Exemple : import path=/data/inbox|"
    "Beispiel: import path=/data/inbox|Esempio: import path=/data/inbox|Voorbeeld: import path=/data/inbox|"
    "Przykład: import path=/data/inbox|例: import path=/data/inbox|示例：import path=/data/inbox|예: import path=/data/inbox|"
    "Пример: import path=/data/inbox|Örnek: import path=/data/inbox|مثال: import path=/data/inbox|"
    "Exempel: import path=/data/inbox|Příklad: import path=/data/inbox|Приклад: import path=/data/inbox|"
    "उदाहरण: import path=/data/inbox|Contoh: import path=/data/inbox|Ví dụ: import path=/data/inbox",
)

# Longer leftovers — one compact batch of high-traffic UI strings.
put("tui-empty-no-name", "<sem nome>|<sin nombre>|<sans nom>|<kein Name>|<nessun nome>|<geen naam>|<brak nazwy>|<名前なし>|<无名称>|<이름 없음>|<без имени>|<ad yok>|<بدون اسم>|<inget namn>|<bez názvu>|<без назви>|<कोई नाम नहीं>|<tanpa nama>|<không tên>")
put("tui-fallback-no-name", "<sem nome>|<sin nombre>|<sans nom>|<kein Name>|<nessun nome>|<geen naam>|<brak nazwy>|<名前なし>|<无名称>|<이름 없음>|<без имени>|<ad yok>|<بدون اسم>|<inget namn>|<bez názvu>|<без назви>|<कोई नाम नहीं>|<tanpa nama>|<không tên>")
put("tui-pane-query-node", "Consultar nó|Consultar nodo|Interroger le nœud|Knoten abfragen|Interroga nodo|Knooppunt bevragen|Zapytaj węzeł|ノードを照会|查询节点|노드 조회|Запрос узла|Düğümü sorgula|استعلام العقدة|Fråga nod|Dotaz na uzel|Запит вузла|नोड क्वेरी|Kueri node|Truy vấn nút")
put("tui-pane-detail", "Detalhe|Detalle|Détail|Detail|Dettaglio|Detail|Szczegóły|詳細|详情|상세|Подробности|Ayrıntı|التفاصيل|Detalj|Detail|Деталі|विवरण|Detail|Chi tiết")
put("tui-detail-name", "Nome|Nombre|Nom|Name|Nome|Naam|Nazwa|名前|名称|이름|Имя|Ad|الاسم|Namn|Název|Ім’я|नाम|Nama|Tên")
put("tui-field-name", "Nome|Nombre|Nom|Name|Nome|Naam|Nazwa|名前|名称|이름|Имя|Ad|الاسم|Namn|Název|Ім’я|नाम|Nama|Tên")
put("tui-form-field-name", "Nome|Nombre|Nom|Name|Nome|Naam|Nazwa|名前|名称|이름|Имя|Ad|الاسم|Namn|Název|Ім’я|नाम|Nama|Tên")
put("tui-field-host", "Host|Host|Hôte|Host|Host|Host|Host|ホスト|主机|호스트|Хост|Host|المضيف|Värd|Host|Хост|होस्ट|Host|Host")
put("tui-form-field-host", "Host|Host|Hôte|Host|Host|Host|Host|ホスト|主机|호스트|Хост|Host|المضيف|Värd|Host|Хост|होस्ट|Host|Host")
put("tui-field-port", "Porta|Puerto|Port|Port|Porta|Poort|Port|ポート|端口|포트|Порт|Port|المنفذ|Port|Port|Порт|पोर्ट|Port|Cổng")
put("tui-form-field-port", "Porta|Puerto|Port|Port|Porta|Poort|Port|ポート|端口|포트|Порт|Port|المنفذ|Port|Port|Порт|पोर्ट|Port|Cổng")
put("desktop-nodes-host", "Host|Host|Hôte|Host|Host|Host|Host|ホスト|主机|호스트|Хост|Host|المضيف|Värd|Host|Хост|होस्ट|Host|Host")
put("desktop-nodes-name", "Nome|Nombre|Nom|Name|Nome|Naam|Nazwa|名前|名称|이름|Имя|Ad|الاسم|Namn|Název|Ім’я|नाम|Nama|Tên")
put("desktop-nodes-port", "Porta|Puerto|Port|Port|Porta|Poort|Port|ポート|端口|포트|Порт|Port|المنفذ|Port|Port|Порт|पोर्ट|Port|Cổng")
put("desktop-table-name", "Nome|Nombre|Nom|Name|Nome|Naam|Nazwa|名前|名称|이름|Имя|Ad|الاسم|Namn|Název|Ім’я|नाम|Nama|Tên")
put("desktop-table-date", "Data|Fecha|Date|Datum|Data|Datum|Data|日付|日期|날짜|Дата|Tarih|التاريخ|Datum|Datum|Дата|तिथि|Tanggal|Ngày")
put("desktop-table-patient", "Paciente|Paciente|Patient|Patient|Paziente|Patiënt|Pacjent|患者|患者|환자|Пациент|Hasta|المريض|Patient|Pacient|Пацієнт|रोगी|Pasien|Bệnh nhân")
put("desktop-table-accession", "Acesso|Acceso|Numéro d’accès|Accession|Accesso|Accessie|Numer dostępu|受付番号|检查号|접수번호|Номер обращения|Kabul no.|رقم القبول|Accession|Accession|Номер звернення|एक्सेशन|Aksesi|Số accession")
put("desktop-col-modalities", "Modalidades|Modalidades|Modalités|Modalitäten|Modalità|Modaliteiten|Modalności|モダリティ|模态|모달리티|Модальности|Modaliteler|الطرائق|Modaliteter|Modality|Модальності|मोडैलिटी|Modalitas|Mô thức")
put("desktop-table-modalities", "Modalidades|Modalidades|Modalités|Modalitäten|Modalità|Modaliteiten|Modalności|モダリティ|模态|모달리티|Модальности|Modaliteler|الطرائق|Modaliteter|Modality|Модальності|मोडैलिटी|Modalitas|Mô thức")
put("desktop-table-updated", "Atualizado|Actualizado|Mis à jour|Aktualisiert|Aggiornato|Bijgewerkt|Zaktualizowano|更新日時|已更新|업데이트됨|Обновлено|Güncellendi|محدَّث|Uppdaterad|Aktualizováno|Оновлено|अपडेटेड|Diperbarui|Đã cập nhật")
put("desktop-table-endpoint", "Endpoint|Endpoint|Point de terminaison|Endpunkt|Endpoint|Eindpunt|Endpoint|エンドポイント|端点|엔드포인트|Конечная точка|Uç nokta|نقطة النهاية|Slutpunkt|Koncový bod|Кінцева точка|एंडपॉइंट|Endpoint|Điểm cuối")
put("desktop-table-move-dest", "Dest. Move|Dest. Move|Dest. Move|Move-Ziel|Dest. Move|Move-best.|Cel Move|Move 先|Move 目标|Move 대상|Назн. Move|Move hedefi|وجهة Move|Move-mål|Cíl Move|Призн. Move|Move गंतव्य|Tujuan Move|Đích Move")
put("desktop-table-ae-title", "Título AE|Título AE|Titre AE|AE-Titel|Titolo AE|AE-titel|Tytuł AE|AE タイトル|AE 标题|AE 타이틀|AE title|AE title|عنوان AE|AE-titel|Titul AE|AE title|AE title|AE title|Tiêu đề AE")
put("desktop-archive-csv", "CSV|CSV|CSV|CSV|CSV|CSV|CSV|CSV|CSV|CSV|CSV|CSV|CSV|CSV|CSV|CSV|CSV|CSV|CSV")
put("desktop-archive-json", "JSON|JSON|JSON|JSON|JSON|JSON|JSON|JSON|JSON|JSON|JSON|JSON|JSON|JSON|JSON|JSON|JSON|JSON|JSON")
put("desktop-app-title", "DICOM Node|DICOM Node|DICOM Node|DICOM Node|DICOM Node|DICOM Node|DICOM Node|DICOM Node|DICOM Node|DICOM Node|DICOM Node|DICOM Node|DICOM Node|DICOM Node|DICOM Node|DICOM Node|DICOM Node|DICOM Node|DICOM Node")
put("desktop-brand-title", "DICOM Node|DICOM Node|DICOM Node|DICOM Node|DICOM Node|DICOM Node|DICOM Node|DICOM Node|DICOM Node|DICOM Node|DICOM Node|DICOM Node|DICOM Node|DICOM Node|DICOM Node|DICOM Node|DICOM Node|DICOM Node|DICOM Node")
put("desktop-doc-title", "DICOM Node|DICOM Node|DICOM Node|DICOM Node|DICOM Node|DICOM Node|DICOM Node|DICOM Node|DICOM Node|DICOM Node|DICOM Node|DICOM Node|DICOM Node|DICOM Node|DICOM Node|DICOM Node|DICOM Node|DICOM Node|DICOM Node")
put("summary-ae", "AE|AE|AE|AE|AE|AE|AE|AE|AE|AE|AE|AE|AE|AE|AE|AE|AE|AE|AE")
put("summary-counts", "Contagens|Recuentos|Compteurs|Zähler|Conteggi|Aantallen|Liczniki|件数|计数|건수|Счётчики|Sayımlar|العدادات|Antal|Počty|Лічильники|गणना|Jumlah|Số liệu")
put("summary-criteria", "Critérios|Criterios|Critères|Kriterien|Criteri|Criteria|Kryteria|条件|条件|조건|Критерии|Kriterler|المعايير|Kriterier|Kritéria|Критерії|मानदंड|Kriteria|Tiêu chí")
put("summary-duration", "Duração|Duración|Durée|Dauer|Durata|Duur|Czas trwania|所要時間|持续时间|소요 시간|Длительность|Süre|المدة|Varaktighet|Trvání|Тривалість|अवधि|Durasi|Thời lượng")
put("summary-duration-ms", "{ $ms }ms|{ $ms }ms|{ $ms }ms|{ $ms }ms|{ $ms }ms|{ $ms }ms|{ $ms }ms|{ $ms }ms|{ $ms }ms|{ $ms }ms|{ $ms }ms|{ $ms }ms|{ $ms }ms|{ $ms }ms|{ $ms }ms|{ $ms }ms|{ $ms }ms|{ $ms }ms|{ $ms }ms")
put("summary-failures", "Falhas:|Fallos:|Échecs :|Fehler:|Errori:|Mislukt:|Niepowodzenia:|失敗:|失败：|실패:|Сбои:|Hatalar:|إخفاقات:|Fel:|Selhání:|Збої:|विफलताएँ:|Kegagalan:|Thất bại:")
put("summary-kind", "Tipo|Tipo|Type|Art|Tipo|Soort|Rodzaj|種類|类型|종류|Тип|Tür|النوع|Typ|Druh|Тип|प्रकार|Jenis|Loại")
put("summary-logs", "Logs:|Registros:|Journaux :|Protokolle:|Log:|Logboeken:|Dzienniki:|ログ:|日志：|로그:|Журналы:|Günlükler:|السجلات:|Loggar:|Protokoly:|Журнали:|लॉग:|Log:|Nhật ký:")
put("summary-peer", "Peer|Peer|Pair|Peer|Peer|Peer|Peer|ピア|对端|피어|Узел|Eş|النظير|Peer|Peer|Пір|पीयर|Peer|Peer")
put("summary-status", "Status|Estado|État|Status|Stato|Status|Status|状態|状态|상태|Статус|Durum|الحالة|Status|Stav|Статус|स्थिति|Status|Trạng thái")
put("summary-title", "Resumo da operação|Resumen de la operación|Résumé de l’opération|Operationszusammenfassung|Riepilogo operazione|Operatiesamenvatting|Podsumowanie operacji|操作の要約|操作摘要|작업 요약|Сводка операции|İşlem özeti|ملخص العملية|Åtgärdssammanfattning|Souhrn operace|Підсумок операції|ऑपरेशन सारांश|Ringkasan operasi|Tóm tắt thao tác")

put(
    "desktop-nodes-err-ae",
    "O título AE é obrigatório.|El título AE es obligatorio.|Le titre AE est obligatoire.|AE-Titel ist erforderlich.|Il titolo AE è obbligatorio.|AE-titel is verplicht.|Tytuł AE jest wymagany.|"
    "AE タイトルは必須です。|必须填写 AE 标题。|AE 타이틀은 필수입니다.|Требуется AE title.|AE title gerekli.|عنوان AE مطلوب.|"
    "AE-titel krävs.|Titul AE je povinný.|Потрібен AE title.|AE title आवश्यक है.|AE title wajib.|AE title là bắt buộc.",
)
put(
    "desktop-nodes-err-ae-len",
    "O título AE deve ter 16 caracteres ou menos.|El título AE debe tener 16 caracteres o menos.|Le titre AE doit comporter au plus 16 caractères.|AE-Titel darf höchstens 16 Zeichen haben.|Il titolo AE deve avere al massimo 16 caratteri.|AE-titel mag maximaal 16 tekens hebben.|Tytuł AE może mieć co najwyżej 16 znaków.|"
    "AE タイトルは 16 文字以内です。|AE 标题最多 16 个字符。|AE 타이틀은 최대 16자입니다.|AE title — не более 16 символов.|AE title en fazla 16 karakter olmalıdır.|يجب ألا يتجاوز عنوان AE 16 حرفًا.|"
    "AE-titel får vara högst 16 tecken.|Titul AE smí mít nejvýše 16 znaků.|AE title — не більше 16 символів.|AE title अधिकतम 16 वर्ण।|AE title maksimal 16 karakter.|AE title tối đa 16 ký tự.",
)
put(
    "desktop-nodes-err-host",
    "O host é obrigatório.|El host es obligatorio.|L’hôte est obligatoire.|Host ist erforderlich.|L’host è obbligatorio.|Host is verplicht.|Host jest wymagany.|"
    "ホストは必須です。|必须填写主机。|호스트는 필수입니다.|Требуется хост.|Host gerekli.|المضيف مطلوب.|"
    "Värd krävs.|Host je povinný.|Потрібен хост.|होस्ट आवश्यक है.|Host wajib.|Host là bắt buộc.",
)
put(
    "desktop-nodes-err-name",
    "O nome é obrigatório.|El nombre es obligatorio.|Le nom est obligatoire.|Name ist erforderlich.|Il nome è obbligatorio.|Naam is verplicht.|Nazwa jest wymagana.|"
    "名前は必須です。|必须填写名称。|이름은 필수입니다.|Требуется имя.|Ad gerekli.|الاسم مطلوب.|"
    "Namn krävs.|Název je povinný.|Потрібна назва.|नाम आवश्यक है.|Nama wajib.|Tên là bắt buộc.",
)
put(
    "desktop-nodes-err-port",
    "A porta deve estar entre 1 e 65535.|El puerto debe estar entre 1 y 65535.|Le port doit être compris entre 1 et 65535.|Port muss zwischen 1 und 65535 liegen.|La porta deve essere tra 1 e 65535.|Poort moet tussen 1 en 65535 liggen.|Port musi być z zakresu 1–65535.|"
    "ポートは 1～65535 です。|端口必须介于 1 和 65535 之间。|포트는 1–65535여야 합니다.|Порт должен быть от 1 до 65535.|Port 1 ile 65535 arasında olmalıdır.|يجب أن يكون المنفذ بين 1 و 65535.|"
    "Port måste vara 1–65535.|Port musí být 1–65535.|Порт має бути 1–65535.|पोर्ट 1–65535 होना चाहिए.|Port harus 1–65535.|Cổng phải từ 1 đến 65535.",
)

put("desktop-action-inspect-archive", "Inspecionar arquivo local|Inspeccionar archivo local|Inspecter l’archive locale|Lokales Archiv prüfen|Ispeziona archivio locale|Lokale archief inspecteren|Sprawdź lokalne archiwum|ローカルアーカイブを確認|检查本地归档|로컬 아카이브 검사|Просмотреть локальный архив|Yerel arşivi incele|فحص الأرشيف المحلي|Inspektera lokalt arkiv|Zkontrolovat místní archiv|Переглянути локальний архів|स्थानीय संग्रह देखें|Periksa arsip lokal|Kiểm tra kho lưu trữ cục bộ")
put("desktop-action-inspect-archive-desc", "Revise estudos, séries e instâncias; depois envie ou exporte.|Revise estudios, series e instancias; luego envíe o exporte.|Parcourez études, séries et instances, puis envoyez ou exportez.|Studien, Serien und Instanzen prüfen, dann senden oder exportieren.|Scorri studi, serie e istanze, poi invia o esporta.|Bekijk studies, series en instanties; verzend of exporteer daarna.|Przejrzyj badania, serie i instancje, potem wyślij lub eksportuj.|スタディ・シリーズ・インスタンスを確認し、送信またはエクスポートします。|查看检查、序列和实例，然后发送或导出。|스터디·시리즈·인스턴스를 검토한 뒤 전송하거나 내보내세요.|Просмотрите исследования, серии и инстансы, затем отправьте или экспортируйте.|Çalışma, seri ve örnekleri inceleyin; ardından gönderin veya dışa aktarın.|راجع الدراسات والسلاسل والمثيلات ثم أرسل أو صدّر.|Granska undersökningar, serier och instanser; skicka eller exportera sedan.|Prohlédněte vyšetření, série a instance, poté odešlete nebo exportujte.|Перегляньте дослідження, серії та примірники, потім надішліть або експортуйте.|अध्ययन, सीरीज़ और इंस्टेंस देखें; फिर भेजें या निर्यात करें.|Tinjau studi, seri, dan instans; lalu kirim atau ekspor.|Xem ca khám, chuỗi và phiên bản; rồi gửi hoặc xuất.")
put("desktop-action-manage-peers", "Gerenciar peers|Gestionar peers|Gérer les pairs|Peers verwalten|Gestisci peer|Peers beheren|Zarządzaj peerami|ピアを管理|管理对端|피어 관리|Управление узлами|Eşleri yönet|إدارة النظراء|Hantera peers|Spravovat peery|Керувати пірами|पीयर प्रबंधित करें|Kelola peer|Quản lý peer")
put("desktop-action-manage-peers-desc", "Adicione e edite nós PACS ou estações usados em query, retrieve e store.|Añada y edite nodos PACS o estaciones usados en query, retrieve y store.|Ajoutez et modifiez les nœuds PACS ou postes utilisés pour query, retrieve et store.|PACS- oder Workstation-Knoten für Query, Retrieve und Store hinzufügen und bearbeiten.|Aggiungi e modifica nodi PACS o workstation usati da query, retrieve e store.|Voeg PACS- of workstation-knooppunten toe en bewerk ze voor query, retrieve en store.|Dodawaj i edytuj węzły PACS lub stacje używane do query, retrieve i store.|query / retrieve / store で使う PACS やワークステーションノードを追加・編集します。|添加并编辑用于 query、retrieve 和 store 的 PACS 或工作站节点。|query, retrieve, store에 쓰는 PACS/워크스테이션 노드를 추가·편집합니다.|Добавляйте и изменяйте узлы PACS и рабочих станций для query, retrieve и store.|Query, retrieve ve store için PACS veya iş istasyonu düğümlerini ekleyin ve düzenleyin.|أضف وعدّل عقد PACS أو محطات العمل المستخدمة في query و retrieve و store.|Lägg till och redigera PACS- eller arbetsstationsnoder för query, retrieve och store.|Přidejte a upravte uzly PACS nebo stanic pro query, retrieve a store.|Додавайте й редагуйте вузли PACS або станцій для query, retrieve і store.|query, retrieve और store के PACS/वर्कस्टेशन नोड जोड़ें और संपादित करें.|Tambah dan sunting node PACS atau workstation untuk query, retrieve, dan store.|Thêm và sửa nút PACS hoặc trạm làm việc dùng cho query, retrieve và store.")
put("desktop-action-monitor-scp", "Monitorar Storage SCP|Supervisar Storage SCP|Surveiller le Storage SCP|Storage-SCP überwachen|Monitora Storage SCP|Storage-SCP bewaken|Monitoruj Storage SCP|Storage SCP を監視|监视 Storage SCP|Storage SCP 모니터링|Мониторинг Storage SCP|Storage SCP’yi izle|مراقبة Storage SCP|Övervaka Storage SCP|Sledovat Storage SCP|Моніторинг Storage SCP|Storage SCP मॉनिटर करें|Pantau Storage SCP|Giám sát Storage SCP")
put("desktop-action-start-scp", "Iniciar Storage SCP|Iniciar Storage SCP|Démarrer le Storage SCP|Storage-SCP starten|Avvia Storage SCP|Storage-SCP starten|Uruchom Storage SCP|Storage SCP を開始|启动 Storage SCP|Storage SCP 시작|Запустить Storage SCP|Storage SCP’yi başlat|بدء Storage SCP|Starta Storage SCP|Spustit Storage SCP|Запустити Storage SCP|Storage SCP शुरू करें|Mulai Storage SCP|Khởi động Storage SCP")

put("patient-name", '\n    "DOE^JOHN"\n    Press \'m\' on a selected result to open retrieve.|\n    "DOE^JOHN"\n    Pulse \'m\' en un resultado seleccionado para abrir retrieve.|\n    "DOE^JOHN"\n    Appuyez sur \'m\' sur un résultat sélectionné pour ouvrir retrieve.|\n    "DOE^JOHN"\n    Drücken Sie \'m\' auf einem ausgewählten Ergebnis, um retrieve zu öffnen.|\n    "DOE^JOHN"\n    Premi \'m\' su un risultato selezionato per aprire retrieve.|\n    "DOE^JOHN"\n    Druk op \'m\' op een geselecteerd resultaat om retrieve te openen.|\n    "DOE^JOHN"\n    Naciśnij \'m\' na wybranym wyniku, aby otworzyć retrieve.|\n    "DOE^JOHN"\n    選択した結果で \'m\' を押すと retrieve を開きます。|\n    "DOE^JOHN"\n    在所选结果上按 \'m\' 打开 retrieve。|\n    "DOE^JOHN"\n    선택한 결과에서 \'m\'을 누르면 retrieve가 열립니다.|\n    "DOE^JOHN"\n    Нажмите \'m\' на выбранном результате, чтобы открыть retrieve.|\n    "DOE^JOHN"\n    Seçili sonuçta retrieve açmak için \'m\' tuşuna basın.|\n    "DOE^JOHN"\n    اضغط \'m\' على نتيجة محددة لفتح retrieve.|\n    "DOE^JOHN"\n    Tryck på \'m\' på ett valt resultat för att öppna retrieve.|\n    "DOE^JOHN"\n    Stiskněte \'m\' na vybraném výsledku pro otevření retrieve.|\n    "DOE^JOHN"\n    Натисніть \'m\' на вибраному результаті, щоб відкрити retrieve.|\n    "DOE^JOHN"\n    चयनित परिणाम पर retrieve खोलने के लिए \'m\' दबाएँ।|\n    "DOE^JOHN"\n    Tekan \'m\' pada hasil terpilih untuk membuka retrieve.|\n    "DOE^JOHN"\n    Nhấn \'m\' trên kết quả đã chọn để mở retrieve.')


PHRASES: dict[str, list[tuple[str, str]]] = {}


def add_phrases(loc: str, pairs: list[tuple[str, str]]) -> None:
    PHRASES[loc] = sorted(pairs, key=lambda p: len(p[0]), reverse=True)


# Word/phrase replacements applied only to leftover English (after restore).
add_phrases(
    "pt-BR",
    [
        ("Select a remote node and press 'f' to query.", QUERY_SELECT["pt-BR"]),
        ("remote node", "nó remoto"),
        ("Remote node", "Nó remoto"),
        ("Remote Nodes", "Nós remotos"),
        ("local node", "nó local"),
        ("Local node", "Nó local"),
        ("saved nodes", "nós salvos"),
        ("Configured nodes", "Nós configurados"),
        ("Total nodes", "Total de nós"),
        ("No remote nodes yet.", "Ainda não há nós remotos."),
        ("No saved nodes", "Nenhum nó salvo"),
        ("node name", "nome do nó"),
        (" nodes", " nós"),
        (" node", " nó"),
        ("Node ", "Nó "),
        ("cannot be empty", "não pode ficar vazio"),
        ("when not typing", "quando não estiver digitando"),
        ("No active task", "Nenhuma tarefa ativa"),
        ("nothing running", "nada em execução"),
        ("could not open", "não foi possível abrir"),
        ("has not been created yet", "ainda não foi criado"),
        ("not loaded yet", "ainda não carregado"),
        ("not loaded", "não carregado"),
        ("Listener not loaded", "Listener não carregado"),
        ("No matches.", "Nenhuma correspondência."),
        ("No local studies yet.", "Ainda não há estudos locais."),
        ("No indexed", "Nenhum indexado"),
        ("<no name>", "<sem nome>"),
        ("none", "nenhum"),
        ("unknown", "desconhecido"),
        ("optional", "opcional"),
        ("required", "obrigatório"),
        ("failed", "falhou"),
        ("Cancelled", "Cancelado"),
        ("Running", "Em execução"),
        ("Queued", "Na fila"),
    ],
)

# Generic phrases reused via a small generator for remaining locales.
GENERIC = {
    "es-ES": {
        "remote node": "nodo remoto",
        "Remote node": "Nodo remoto",
        "Remote Nodes": "Nodos remotos",
        "local node": "nodo local",
        "Local node": "Nodo local",
        "saved nodes": "nodos guardados",
        "Configured nodes": "Nodos configurados",
        "Total nodes": "Nodos totales",
        "No remote nodes yet.": "Aún no hay nodos remotos.",
        "No saved nodes": "No hay nodos guardados",
        "node name": "nombre del nodo",
        " nodes": " nodos",
        " node": " nodo",
        "Node ": "Nodo ",
        "cannot be empty": "no puede estar vacío",
        "when not typing": "cuando no se está escribiendo",
        "No active task": "Ninguna tarea activa",
        "nothing running": "nada en ejecución",
        "could not open": "no se pudo abrir",
        "has not been created yet": "aún no se ha creado",
        "not loaded yet": "aún no cargado",
        "not loaded": "no cargado",
        "Listener not loaded": "Listener no cargado",
        "No matches.": "Sin coincidencias.",
        "No local studies yet.": "Aún no hay estudios locales.",
        "<no name>": "<sin nombre>",
        "none": "ninguno",
        "unknown": "desconocido",
        "optional": "opcional",
        "required": "obligatorio",
    },
    "fr-FR": {
        "remote node": "nœud distant",
        "Remote node": "Nœud distant",
        "Remote Nodes": "Nœuds distants",
        "local node": "nœud local",
        "Local node": "Nœud local",
        "saved nodes": "nœuds enregistrés",
        "Configured nodes": "Nœuds configurés",
        "Total nodes": "Nombre de nœuds",
        "No remote nodes yet.": "Aucun nœud distant pour le moment.",
        "No saved nodes": "Aucun nœud enregistré",
        "node name": "nom du nœud",
        " nodes": " nœuds",
        " node": " nœud",
        "Node ": "Nœud ",
        "cannot be empty": "ne peut pas être vide",
        "when not typing": "lorsque vous ne saisissez pas",
        "No active task": "Aucune tâche active",
        "nothing running": "rien n’est en cours",
        "could not open": "impossible d’ouvrir",
        "has not been created yet": "n’a pas encore été créé",
        "not loaded yet": "pas encore chargé",
        "not loaded": "non chargé",
        "Listener not loaded": "Listener non chargé",
        "No matches.": "Aucune correspondance.",
        "No local studies yet.": "Aucune étude locale pour le moment.",
        "<no name>": "<sans nom>",
        "none": "aucun",
        "unknown": "inconnu",
        "optional": "facultatif",
        "required": "obligatoire",
    },
    "de-DE": {
        "remote node": "entfernter Knoten",
        "Remote node": "Entfernter Knoten",
        "Remote Nodes": "Entfernte Knoten",
        "local node": "lokaler Knoten",
        "Local node": "Lokaler Knoten",
        "saved nodes": "gespeicherte Knoten",
        "Configured nodes": "Konfigurierte Knoten",
        "Total nodes": "Knoten insgesamt",
        "No remote nodes yet.": "Noch keine entfernten Knoten.",
        "No saved nodes": "Keine gespeicherten Knoten",
        "node name": "Knotenname",
        " nodes": " Knoten",
        " node": " Knoten",
        "Node ": "Knoten ",
        "cannot be empty": "darf nicht leer sein",
        "when not typing": "wenn nicht getippt wird",
        "No active task": "Keine aktive Aufgabe",
        "nothing running": "nichts läuft",
        "could not open": "konnte nicht geöffnet werden",
        "has not been created yet": "wurde noch nicht erstellt",
        "not loaded yet": "noch nicht geladen",
        "not loaded": "nicht geladen",
        "Listener not loaded": "Listener nicht geladen",
        "No matches.": "Keine Treffer.",
        "No local studies yet.": "Noch keine lokalen Studien.",
        "<no name>": "<kein Name>",
        "none": "keine",
        "unknown": "unbekannt",
        "optional": "optional",
        "required": "erforderlich",
        "Added node": "Knoten hinzugefügt",
        "Updated node": "Knoten aktualisiert",
        "Deleted node": "Knoten gelöscht",
    },
    "it-IT": {
        "remote node": "nodo remoto",
        "Remote node": "Nodo remoto",
        "Remote Nodes": "Nodi remoti",
        "local node": "nodo locale",
        "Local node": "Nodo locale",
        " nodes": " nodi",
        " node": " nodo",
        "Node ": "Nodo ",
        "cannot be empty": "non può essere vuoto",
        "when not typing": "quando non si sta digitando",
        "No active task": "Nessuna attività attiva",
        "nothing running": "nulla in esecuzione",
        "could not open": "impossibile aprire",
        "not loaded": "non caricato",
        "No matches.": "Nessuna corrispondenza.",
        "No local studies yet.": "Nessuno studio locale.",
        "<no name>": "<nessun nome>",
        "none": "nessuno",
        "unknown": "sconosciuto",
        "No remote nodes yet.": "Nessun nodo remoto.",
        "No saved nodes": "Nessun nodo salvato",
        "Configured nodes": "Nodi configurati",
        "Total nodes": "Nodi totali",
    },
    "nl-NL": {
        "remote node": "extern knooppunt",
        "Remote node": "Extern knooppunt",
        "Remote Nodes": "Externe knooppunten",
        "local node": "lokaal knooppunt",
        "Local node": "Lokaal knooppunt",
        " nodes": " knooppunten",
        " node": " knooppunt",
        "cannot be empty": "mag niet leeg zijn",
        "when not typing": "wanneer u niet typt",
        "No active task": "Geen actieve taak",
        "could not open": "kon niet openen",
        "not loaded": "niet geladen",
        "No matches.": "Geen overeenkomsten.",
        "<no name>": "<geen naam>",
        "none": "geen",
        "unknown": "onbekend",
        "No remote nodes yet.": "Nog geen externe knooppunten.",
        "No saved nodes": "Geen opgeslagen knooppunten",
        "Configured nodes": "Geconfigureerde knooppunten",
        "Total nodes": "Totaal knooppunten",
    },
    "pl-PL": {
        "remote node": "węzeł zdalny",
        "Remote node": "Węzeł zdalny",
        "Remote Nodes": "Węzły zdalne",
        "local node": "węzeł lokalny",
        "Local node": "Węzeł lokalny",
        " nodes": " węzły",
        " node": " węzeł",
        "cannot be empty": "nie może być puste",
        "when not typing": "gdy nie trwa wpisywanie",
        "No active task": "Brak aktywnego zadania",
        "could not open": "nie można otworzyć",
        "not loaded": "niezaładowany",
        "No matches.": "Brak dopasowań.",
        "<no name>": "<brak nazwy>",
        "none": "brak",
        "unknown": "nieznany",
        "No remote nodes yet.": "Brak zdalnych węzłów.",
        "No saved nodes": "Brak zapisanych węzłów",
        "Configured nodes": "Skonfigurowane węzły",
        "Total nodes": "Łącznie węzłów",
    },
    "ja-JP": {
        "remote node": "リモートノード",
        "Remote node": "リモートノード",
        "Remote Nodes": "リモートノード",
        "local node": "ローカルノード",
        "Local node": "ローカルノード",
        " nodes": "ノード",
        " node": "ノード",
        "cannot be empty": "空にできません",
        "when not typing": "入力していないとき",
        "No active task": "実行中のタスクはありません",
        "could not open": "開けませんでした",
        "not loaded": "未読み込み",
        "No matches.": "一致なし。",
        "<no name>": "<名前なし>",
        "none": "なし",
        "unknown": "不明",
        "No remote nodes yet.": "リモートノードはまだありません。",
        "No saved nodes": "保存済みノードはありません",
        "Configured nodes": "設定済みノード",
        "Total nodes": "ノード総数",
    },
    "zh-CN": {
        "remote node": "远程节点",
        "Remote node": "远程节点",
        "Remote Nodes": "远程节点",
        "local node": "本地节点",
        "Local node": "本地节点",
        " nodes": "节点",
        " node": "节点",
        "cannot be empty": "不能为空",
        "when not typing": "未在输入时",
        "No active task": "没有活动任务",
        "could not open": "无法打开",
        "not loaded": "未加载",
        "No matches.": "无匹配。",
        "<no name>": "<无名称>",
        "none": "无",
        "unknown": "未知",
        "No remote nodes yet.": "尚无远程节点。",
        "No saved nodes": "没有已保存的节点",
        "Configured nodes": "已配置节点",
        "Total nodes": "节点总数",
    },
    "ko-KR": {
        "remote node": "원격 노드",
        "Remote node": "원격 노드",
        "Remote Nodes": "원격 노드",
        "local node": "로컬 노드",
        "Local node": "로컬 노드",
        " nodes": " 노드",
        " node": " 노드",
        "cannot be empty": "비울 수 없습니다",
        "when not typing": "입력 중이 아닐 때",
        "No active task": "활성 작업 없음",
        "could not open": "열 수 없음",
        "not loaded": "로드되지 않음",
        "No matches.": "일치 항목 없음.",
        "<no name>": "<이름 없음>",
        "none": "없음",
        "unknown": "알 수 없음",
        "No remote nodes yet.": "아직 원격 노드가 없습니다.",
        "No saved nodes": "저장된 노드 없음",
        "Configured nodes": "구성된 노드",
        "Total nodes": "전체 노드",
    },
    "ru-RU": {
        "remote node": "удалённый узел",
        "Remote node": "Удалённый узел",
        "Remote Nodes": "Удалённые узлы",
        "local node": "локальный узел",
        "Local node": "Локальный узел",
        " nodes": " узлы",
        " node": " узел",
        "cannot be empty": "не может быть пустым",
        "when not typing": "когда нет ввода",
        "No active task": "Нет активной задачи",
        "could not open": "не удалось открыть",
        "not loaded": "не загружен",
        "No matches.": "Нет совпадений.",
        "<no name>": "<без имени>",
        "none": "нет",
        "unknown": "неизвестно",
        "No remote nodes yet.": "Удалённых узлов пока нет.",
        "No saved nodes": "Нет сохранённых узлов",
        "Configured nodes": "Настроенные узлы",
        "Total nodes": "Всего узлов",
    },
    "tr-TR": {
        "remote node": "uzak düğüm",
        "Remote node": "Uzak düğüm",
        "Remote Nodes": "Uzak düğümler",
        "local node": "yerel düğüm",
        "Local node": "Yerel düğüm",
        " nodes": " düğüm",
        " node": " düğüm",
        "cannot be empty": "boş olamaz",
        "when not typing": "yazılmıyorken",
        "No active task": "Etkin görev yok",
        "could not open": "açılamadı",
        "not loaded": "yüklenmedi",
        "No matches.": "Eşleşme yok.",
        "<no name>": "<ad yok>",
        "none": "yok",
        "unknown": "bilinmiyor",
        "No remote nodes yet.": "Henüz uzak düğüm yok.",
        "No saved nodes": "Kayıtlı düğüm yok",
        "Configured nodes": "Yapılandırılmış düğümler",
        "Total nodes": "Toplam düğüm",
    },
    "ar": {
        "remote node": "عقدة بعيدة",
        "Remote node": "عقدة بعيدة",
        "Remote Nodes": "العقد البعيدة",
        "local node": "عقدة محلية",
        "Local node": "عقدة محلية",
        " nodes": " عقد",
        " node": " عقدة",
        "cannot be empty": "لا يمكن أن يكون فارغًا",
        "when not typing": "عند عدم الكتابة",
        "No active task": "لا توجد مهمة نشطة",
        "could not open": "تعذر الفتح",
        "not loaded": "غير محمّل",
        "No matches.": "لا تطابق.",
        "<no name>": "<بدون اسم>",
        "none": "لا شيء",
        "unknown": "غير معروف",
        "No remote nodes yet.": "لا توجد عقد بعيدة بعد.",
        "No saved nodes": "لا توجد عقد محفوظة",
        "Configured nodes": "العقد المُعدّة",
        "Total nodes": "إجمالي العقد",
    },
    "sv-SE": {
        "remote node": "fjärrnod",
        "Remote node": "Fjärrnod",
        "Remote Nodes": "Fjärrnoder",
        "local node": "lokal nod",
        "Local node": "Lokal nod",
        " nodes": " noder",
        " node": " nod",
        "cannot be empty": "får inte vara tom",
        "when not typing": "när du inte skriver",
        "No active task": "Ingen aktiv uppgift",
        "could not open": "kunde inte öppna",
        "not loaded": "inte inläst",
        "No matches.": "Inga träffar.",
        "<no name>": "<inget namn>",
        "none": "ingen",
        "unknown": "okänd",
        "No remote nodes yet.": "Inga fjärrnoder ännu.",
        "No saved nodes": "Inga sparade noder",
        "Configured nodes": "Konfigurerade noder",
        "Total nodes": "Totalt antal noder",
    },
    "cs-CZ": {
        "remote node": "vzdálený uzel",
        "Remote node": "Vzdálený uzel",
        "Remote Nodes": "Vzdálené uzly",
        "local node": "místní uzel",
        "Local node": "Místní uzel",
        " nodes": " uzly",
        " node": " uzel",
        "cannot be empty": "nesmí být prázdné",
        "when not typing": "když se nepíše",
        "No active task": "Žádná aktivní úloha",
        "could not open": "nelze otevřít",
        "not loaded": "nenačteno",
        "No matches.": "Žádné shody.",
        "<no name>": "<bez názvu>",
        "none": "žádné",
        "unknown": "neznámý",
        "No remote nodes yet.": "Zatím žádné vzdálené uzly.",
        "No saved nodes": "Žádné uložené uzly",
        "Configured nodes": "Nakonfigurované uzly",
        "Total nodes": "Celkem uzlů",
    },
    "uk-UA": {
        "remote node": "віддалений вузол",
        "Remote node": "Віддалений вузол",
        "Remote Nodes": "Віддалені вузли",
        "local node": "локальний вузол",
        "Local node": "Локальний вузол",
        " nodes": " вузли",
        " node": " вузол",
        "cannot be empty": "не може бути порожнім",
        "when not typing": "коли немає введення",
        "No active task": "Немає активного завдання",
        "could not open": "не вдалося відкрити",
        "not loaded": "не завантажено",
        "No matches.": "Немає збігів.",
        "<no name>": "<без назви>",
        "none": "немає",
        "unknown": "невідомо",
        "No remote nodes yet.": "Віддалених вузлів ще немає.",
        "No saved nodes": "Немає збережених вузлів",
        "Configured nodes": "Налаштовані вузли",
        "Total nodes": "Усього вузлів",
    },
    "hi-IN": {
        "remote node": "रिमोट नोड",
        "Remote node": "रिमोट नोड",
        "Remote Nodes": "रिमोट नोड",
        "local node": "स्थानीय नोड",
        "Local node": "स्थानीय नोड",
        " nodes": " नोड",
        " node": " नोड",
        "cannot be empty": "खाली नहीं हो सकता",
        "when not typing": "टाइप न करते समय",
        "No active task": "कोई सक्रिय कार्य नहीं",
        "could not open": "खोल नहीं सके",
        "not loaded": "लोड नहीं हुआ",
        "No matches.": "कोई मेल नहीं.",
        "<no name>": "<कोई नाम नहीं>",
        "none": "कोई नहीं",
        "unknown": "अज्ञात",
        "No remote nodes yet.": "अभी कोई रिमोट नोड नहीं।",
        "No saved nodes": "कोई सहेजा नोड नहीं",
        "Configured nodes": "कॉन्फ़िगर नोड",
        "Total nodes": "कुल नोड",
    },
    "id-ID": {
        "remote node": "node jarak jauh",
        "Remote node": "Node jarak jauh",
        "Remote Nodes": "Node jarak jauh",
        "local node": "node lokal",
        "Local node": "Node lokal",
        " nodes": " node",
        " node": " node",
        "cannot be empty": "tidak boleh kosong",
        "when not typing": "saat tidak mengetik",
        "No active task": "Tidak ada tugas aktif",
        "could not open": "tidak dapat membuka",
        "not loaded": "belum dimuat",
        "No matches.": "Tidak ada yang cocok.",
        "<no name>": "<tanpa nama>",
        "none": "tidak ada",
        "unknown": "tidak dikenal",
        "No remote nodes yet.": "Belum ada node jarak jauh.",
        "No saved nodes": "Tidak ada node tersimpan",
        "Configured nodes": "Node terkonfigurasi",
        "Total nodes": "Total node",
    },
    "vi-VN": {
        "remote node": "nút từ xa",
        "Remote node": "Nút từ xa",
        "Remote Nodes": "Nút từ xa",
        "local node": "nút cục bộ",
        "Local node": "Nút cục bộ",
        " nodes": " nút",
        " node": " nút",
        "cannot be empty": "không được để trống",
        "when not typing": "khi không gõ",
        "No active task": "Không có tác vụ đang chạy",
        "could not open": "không thể mở",
        "not loaded": "chưa tải",
        "No matches.": "Không có kết quả khớp.",
        "<no name>": "<không tên>",
        "none": "không",
        "unknown": "không rõ",
        "No remote nodes yet.": "Chưa có nút từ xa.",
        "No saved nodes": "Không có nút đã lưu",
        "Configured nodes": "Nút đã cấu hình",
        "Total nodes": "Tổng số nút",
    },
}

for loc, mapping in GENERIC.items():
    add_phrases(loc, list(mapping.items()))


def apply_phrases(text: str, loc: str) -> str:
    for src, dst in PHRASES.get(loc, ()):
        text = text.replace(src, dst)
    return text


def choose_value(loc: str, key: str, en_val: str, existing: str | None, no_word: str) -> str:
    if key in T and loc in T[key]:
        return T[key][loc]
    if key == "tui-empty-query-body":
        return query_body(loc)
    if key in KEEP_ENGLISH:
        return en_val
    cur = existing if existing is not None else en_val
    cur = unsplice_no(cur, no_word)
    cur = restore_no_corruption(cur, en_val, no_word)
    if looks_like_stub(cur, no_word):
        cur = en_val
    if cur.strip() == en_val.strip():
        return apply_phrases(en_val, loc)
    return cur


HEADER = """# Fluent catalog ({locale}). Message IDs are hyphenated identifiers
# (cli-about, tui-pane-remote-nodes, desktop-nav-dashboard, error-import-file-too-large).
# Dotted names are Fluent attributes (message + .attr), not message IDs.
# Do not translate DICOM tokens (C-FIND, C-MOVE, C-STORE, SOP, AE, UID) or JSON/CSV machine keys.
"""


def rebuild(en_src: str, values: dict[str, str]) -> str:
    events = parse_en_structure(en_src)
    chunks: list[str] = []
    for kind, payload in events:
        if kind == "raw":
            chunks.append(payload)
        else:
            chunks.append(format_message(payload, values[payload]))
    text = "\n".join(chunks)
    if not text.endswith("\n"):
        text += "\n"
    return text


def main() -> None:
    en_src = EN_PATH.read_text()
    en = parse_ftl(en_src)
    for loc in LOCALES:
        path = ROOT / f"{loc}.ftl"
        old_src = path.read_text() if path.exists() else ""
        old = parse_ftl(old_src) if old_src else {}
        no_word = old.get("common-no", "no")
        values = {
            key: choose_value(loc, key, en_val, old.get(key), no_word)
            for key, en_val in en.items()
        }
        # Keep locale-specific header comments from en-US structure (first raw block).
        out = rebuild(en_src, values)
        # Swap locale in the copied en-US header.
        out = out.replace("(en-US)", f"({loc})", 1)
        path.write_text(out)
        print(f"{loc}: wrote {len(values)} messages")


if __name__ == "__main__":
    main()
