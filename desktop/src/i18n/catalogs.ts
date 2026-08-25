import { FluentBundle, FluentResource, type FluentVariable } from "@fluent/bundle";
import fallbackEn from "./fallback-en.ftl?raw";
import { catalogs as repoCatalogs } from "virtual:i18n-catalogs";

export const STORAGE_KEY = "dicom-node.locale";
export const FALLBACK_LOCALE = "en-US";

export type Translate = (id: string, args?: Record<string, FluentVariable>) => string;

/** Dotted issue keys (`desktop.nav.dashboard`) → valid Fluent identifiers. */
export function fluentId(id: string): string {
  return id.replaceAll(/[._]/g, "-");
}

/** Normalize leftover dotted identifiers if any catalog still has them. */
export function fluentize(source: string): string {
  return source.replace(/^([a-zA-Z][a-zA-Z0-9_.-]*)(\s*=)/gm, (_, name: string, rest: string) => {
    return `${name.replaceAll(/[._]/g, "-")}${rest}`;
  });
}

function localeFromFilename(name: string): string {
  return name.replace(/\.ftl$/i, "");
}

export function availableLocales(): string[] {
  const locales = new Set<string>([FALLBACK_LOCALE]);
  for (const key of Object.keys(repoCatalogs)) {
    locales.add(localeFromFilename(key));
  }
  return [...locales].sort((a, b) => a.localeCompare(b));
}

export function detectLocale(available: string[]): string {
  try {
    const stored = localStorage.getItem(STORAGE_KEY);
    if (stored) {
      const resolved = resolveLocale(stored, available);
      if (resolved) return resolved;
    }
  } catch {
    /* ignore: storage may be unavailable */
  }
  const nav = typeof navigator !== "undefined" ? navigator.language : FALLBACK_LOCALE;
  return resolveLocale(nav, available) ?? FALLBACK_LOCALE;
}

export function resolveLocale(requested: string, available: string[]): string | null {
  if (available.includes(requested)) return requested;
  const lang = requested.split("-")[0]?.toLowerCase();
  if (!lang) return available.includes(FALLBACK_LOCALE) ? FALLBACK_LOCALE : available[0] ?? null;
  const exactLang = available.find((item) => item.toLowerCase() === lang);
  if (exactLang) return exactLang;
  const prefix = available.find((item) => item.toLowerCase().startsWith(`${lang}-`));
  if (prefix) return prefix;
  if (available.includes(FALLBACK_LOCALE)) return FALLBACK_LOCALE;
  return available[0] ?? null;
}

function addSource(bundle: FluentBundle, source: string) {
  const errors = bundle.addResource(new FluentResource(fluentize(source)), { allowOverrides: true });
  if (import.meta.env.DEV && errors.length > 0) {
    console.warn("Fluent catalog errors", errors);
  }
}

export function bundleFor(locale: string): FluentBundle {
  const bundle = new FluentBundle(locale, { useIsolating: false });
  addSource(bundle, fallbackEn);
  const overlay =
    repoCatalogs[locale] ??
    Object.entries(repoCatalogs).find(([key]) => localeFromFilename(key) === locale)?.[1];
  if (overlay) addSource(bundle, overlay);
  return bundle;
}

export function persistLocale(locale: string) {
  try {
    localStorage.setItem(STORAGE_KEY, locale);
  } catch {
    /* ignore */
  }
}

export function applyDocumentLocale(locale: string, title: string) {
  document.documentElement.lang = locale;
  document.title = title;
}

/** Sibling catalogs use `$n` / `$node`; call sites may pass `count` / `destination`. */
function expandArgs(
  args?: Record<string, FluentVariable>,
): Record<string, FluentVariable> | undefined {
  if (!args) return args;
  const next: Record<string, FluentVariable> = { ...args };
  if (next.count !== undefined && next.n === undefined) next.n = next.count;
  if (next.destination !== undefined && next.node === undefined) next.node = next.destination;
  if (next.scanned !== undefined && next.scanned_files === undefined) next.scanned_files = next.scanned;
  return next;
}

/** Map desktop chrome keys onto the hyphenated IDs in `i18n/pt-BR.ftl` (and dotted aliases). */
const KEY_ALIASES: Record<string, string[]> = {
  "desktop-doc-title": ["desktop-title"],
  "desktop-status-listening": ["desktop-listening", "desktop-scp-listening"],
  "desktop-status-stopped": ["desktop-stopped", "desktop-scp-stopped"],
  "desktop-status-loading": ["common-loading"],
  "desktop-action-refresh-status": ["desktop-title-refresh-status", "desktop-strip-refresh_status"],
  "desktop-action-reveal-log": ["desktop-title-reveal-log", "desktop-strip-reveal_log"],
  "desktop-locale-label": ["desktop-lang-label"],
  "desktop-common-yes": ["common-yes"],
  "desktop-common-no": ["common-no"],
  "desktop-common-enabled": ["desktop-enabled"],
  "desktop-common-disabled": ["desktop-disabled"],
  "desktop-common-cancel": ["common-cancel", "desktop-query-clear"],
  "desktop-common-clear": ["common-clear", "desktop-query-clear"],
  "desktop-common-refresh": ["common-refresh"],
  "desktop-dashboard-metric-studies": ["desktop-metric-studies"],
  "desktop-dashboard-metric-series": ["desktop-metric-series"],
  "desktop-dashboard-metric-instances": ["desktop-metric-instances"],
  "desktop-dashboard-metric-nodes": ["desktop-metric-remote-nodes"],
  "desktop-dashboard-inspect-archive-title": ["desktop-dashboard-inspect-archive"],
  "desktop-dashboard-manage-peers-title": ["desktop-dashboard-manage-peers"],
  "desktop-dashboard-listener-missing": ["desktop-dashboard-listener-unloaded"],
  "desktop-dashboard-kv-ae-title": ["desktop-label-ae-title"],
  "desktop-dashboard-kv-listener": ["desktop-label-listener"],
  "desktop-dashboard-kv-server": ["desktop-label-server"],
  "desktop-dashboard-kv-max-pdu": ["desktop-label-max-pdu"],
  "desktop-dashboard-kv-strict-pdu": ["desktop-label-strict-pdu"],
  "desktop-dashboard-kv-promiscuous": ["desktop-label-promiscuous"],
  "desktop-dashboard-kv-store-syntax": ["desktop-label-store-syntax"],
  "desktop-dashboard-kv-data-dir": ["desktop-label-data-dir"],
  "desktop-dashboard-kv-log-file": ["desktop-label-log-file"],
  "desktop-dashboard-loading-status": ["desktop-loading-status"],
  "desktop-dashboard-loading-metrics": ["desktop-loading-metrics"],
  "desktop-dashboard-loading-studies": ["desktop-loading-studies"],
  "desktop-dashboard-empty-studies": ["desktop-no-local-studies"],
  "desktop-dashboard-counter-c-store-stored": ["desktop-counter-cstore-stored"],
  "desktop-dashboard-counter-c-store-failed": ["desktop-counter-cstore-failed"],
  "desktop-dashboard-counter-c-find-requests": ["desktop-counter-cfind"],
  "desktop-dashboard-counter-c-move-requests": ["desktop-counter-cmove"],
  "desktop-dashboard-counter-bytes-ingested": ["desktop-counter-bytes-ingested"],
  "desktop-dashboard-counter-assoc-accepted": ["desktop-counter-assoc-accepted"],
  "desktop-table-patient": ["desktop-col-patient"],
  "desktop-table-patient-id": ["desktop-col-patient-id"],
  "desktop-table-date": ["desktop-col-date"],
  "desktop-table-description": ["desktop-col-description"],
  "desktop-table-modalities": ["desktop-col-modalities"],
  "desktop-table-series": ["desktop-col-series"],
  "desktop-table-instances": ["desktop-col-instances"],
  "desktop-table-accession": ["desktop-query-col-accession", "desktop-col-accession"],
  "desktop-table-name": ["desktop-nodes-name", "desktop-col-name"],
  "desktop-table-ae-title": ["desktop-label-ae-title", "desktop-col-ae_title"],
  "desktop-table-endpoint": ["desktop-nodes-col-endpoint"],
  "desktop-table-move-dest": ["desktop-nodes-col-move-dest"],
  "desktop-table-notes": ["desktop-nodes-col-notes"],
  "desktop-table-updated": ["desktop-nodes-col-updated"],
  "desktop-query-search-criteria": ["desktop-query-criteria", "desktop-query-search_criteria"],
  "desktop-query-placeholder-modality": ["desktop-query-modality-placeholder"],
  "desktop-query-placeholder-patient": ["desktop-query-patient-placeholder"],
  "desktop-query-placeholder-description": ["desktop-query-study-description-placeholder"],
  "desktop-query-selected-match": ["desktop-query-selected", "desktop-query-selected_match"],
  "desktop-query-select-hint": ["desktop-query-run-select", "desktop-query-run_and_select"],
  "desktop-query-activity-ok": ["desktop-query-cfind-ok", "desktop-query-cfind_title"],
  "desktop-query-activity-fail": ["desktop-query-cfind-failed", "desktop-query-cfind_failed"],
  "desktop-query-activity-detail": ["desktop-query-cfind-detail"],
  "desktop-query-retrieve-activity-ok": ["desktop-query-cmove-ok", "desktop-query-cmove_title"],
  "desktop-query-retrieve-activity-fail": ["desktop-query-cmove-failed", "desktop-query-cmove_failed"],
  "desktop-query-run": ["desktop-query-run_cfind"],
  "desktop-import-placeholder": ["desktop-import-path-placeholder"],
  "desktop-import-running": ["desktop-import-importing"],
  "desktop-import-pick-dir": ["desktop-import-choose-dir", "desktop-import-choose_dir"],
  "desktop-import-pick-zip": ["desktop-import-choose-zip", "desktop-import-choose_zip"],
  "desktop-import-dup-sop": ["desktop-import-sop-uid", "desktop-import-dup_sop"],
  "desktop-import-dup-sha": ["desktop-import-sha256", "desktop-import-dup_sha"],
  "desktop-import-dup-total": ["desktop-import-total", "desktop-import-dup_total"],
  "desktop-import-activity-ok": ["desktop-import-complete"],
  "desktop-import-activity-fail": ["desktop-import-failed"],
  "desktop-import-failures-more": ["desktop-import-more-failures"],
  "desktop-server-logs": ["desktop-nav-logs"],
  "desktop-server-activity-stopped": ["desktop-server-scp-stopped", "desktop-server-stopped_toast"],
  "desktop-server-activity-stopped-empty": ["desktop-server-no-session"],
  "desktop-server-activity-started": ["desktop-server-scp-started", "desktop-server-started"],
  "desktop-server-activity-started-detail": ["desktop-server-listener-started"],
  "desktop-server-activity-fail": ["desktop-server-scp-failed", "desktop-server-control_failed"],
  "desktop-server-loading-metrics": ["desktop-loading-metrics", "desktop-server-health-loading"],
  "desktop-server-stopped-pill": ["desktop-server-stopped"],
  "desktop-server-counter-received": ["desktop-server-cstore-received", "desktop-server-c_store_received"],
  "desktop-server-counter-stored": ["desktop-counter-cstore-stored", "desktop-server-c_store_stored"],
  "desktop-server-counter-failed": ["desktop-counter-cstore-failed", "desktop-server-c_store_failed"],
  "desktop-server-counter-find": ["desktop-server-cfind-req-matches", "desktop-server-c_find_req_matches"],
  "desktop-server-counter-move": ["desktop-counter-cmove", "desktop-server-c_move_requests"],
  "desktop-server-counter-move-sub": ["desktop-server-cmove-subops", "desktop-server-c_move_subops"],
  "desktop-server-counter-get": ["desktop-server-cget", "desktop-server-c_get_requests"],
  "desktop-server-counter-bytes": ["desktop-counter-bytes-ingested", "desktop-server-bytes_ingested"],
  "desktop-logs-lines": ["desktop-logs-n-lines"],
  "desktop-logs-activity-ok": ["desktop-logs-refreshed"],
  "desktop-logs-activity-detail": ["desktop-logs-lines-loaded", "desktop-logs-lines_loaded"],
  "desktop-logs-activity-fail": ["desktop-logs-refresh-failed", "desktop-logs-refresh_failed"],
  "desktop-logs-missing": ["desktop-logs-not_created"],
  "desktop-archive-filter": ["desktop-archive-filter-placeholder"],
  "desktop-archive-loading": ["desktop-loading-studies", "desktop-archive-loading_studies"],
  "desktop-archive-export-ok": ["desktop-archive-exported"],
  "desktop-archive-export-fail": ["desktop-archive-export-failed", "desktop-archive-export_failed"],
  "desktop-archive-send-study-label": ["desktop-archive-study-to", "desktop-archive-study_to"],
  "desktop-archive-send-series-label": ["desktop-archive-series-to", "desktop-archive-series_to"],
  "desktop-archive-send-fail-title": ["desktop-archive-study-to-failed", "desktop-archive-study_to_failed"],
  "desktop-archive-inst-abbrev": ["desktop-archive-instances-count", "desktop-archive-inst_abbrev"],
  "desktop-nodes-need-name": ["desktop-nodes-name-required", "desktop-nodes-name_required"],
  "desktop-nodes-need-ae": ["desktop-nodes-ae-required", "desktop-nodes-ae_required"],
  "desktop-nodes-ae-length": ["desktop-nodes-ae-too-long", "desktop-nodes-ae_too_long"],
  "desktop-nodes-need-host": ["desktop-nodes-host-required", "desktop-nodes-host_required"],
  "desktop-nodes-placeholder-move": ["desktop-nodes-move_placeholder"],
  "desktop-nodes-placeholder-notes": ["desktop-nodes-notes_placeholder"],
};

function lookupIds(id: string): string[] {
  const fid = fluentId(id);
  return [...new Set([fid, id, ...(KEY_ALIASES[fid] ?? [])])];
}

export function formatMessage(
  bundles: FluentBundle[],
  id: string,
  args?: Record<string, FluentVariable>,
): string {
  const vars = expandArgs(args);
  for (const key of lookupIds(id)) {
    for (const bundle of bundles) {
      const message = bundle.getMessage(key);
      if (!message?.value) continue;
      const errors: Error[] = [];
      const formatted = bundle.formatPattern(message.value, vars, errors);
      if (formatted) return formatted;
    }
  }
  return id;
}
