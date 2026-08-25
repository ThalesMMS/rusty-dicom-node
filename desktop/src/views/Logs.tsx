import { useEffect, useState } from "react";
import { revealItemInDir } from "@tauri-apps/plugin-opener";
import { Check, FileText, FolderOpen, RefreshCw } from "lucide-react";
import { tailLog } from "../api";
import { useI18n } from "../i18n";
import type { ActivityEntry, LogTailResult, Status } from "../types";

interface Props {
  status: Status | null;
  onActivity: (entry: Omit<ActivityEntry, "id" | "at">) => void;
}

export default function Logs({ status, onActivity }: Props) {
  const { t } = useI18n();
  const [tail, setTail] = useState<LogTailResult | null>(null);
  const [maxLines, setMaxLines] = useState(200);
  const [autoRefresh, setAutoRefresh] = useState(true);
  const [error, setError] = useState<string | null>(null);

  const refresh = async (recordActivity = false) => {
    setError(null);
    try {
      const result = await tailLog(maxLines);
      setTail(result);
      if (recordActivity) {
        onActivity({
          kind: "log",
          title: t("desktop-logs-activity-ok"),
          detail: t("desktop-logs-activity-detail", { count: result.lines.length }),
          tone: "info",
        });
      }
    } catch (e) {
      const message = String(e);
      setError(message);
      onActivity({ kind: "log", title: t("desktop-logs-activity-fail"), detail: message, tone: "error" });
    }
  };

  useEffect(() => {
    refresh().catch(console.error);
  }, [maxLines]);

  useEffect(() => {
    if (!autoRefresh) return;
    const timer = setInterval(() => refresh().catch(console.error), 3000);
    return () => clearInterval(timer);
  }, [autoRefresh, maxLines]);

  const path = tail?.path ?? status?.active_log_file;

  return (
    <>
      <div className="page-header compact">
        <div>
          <h1>{t("desktop-logs-title")}</h1>
          <p>{t("desktop-logs-subtitle")}</p>
        </div>
        <div className="header-actions">
          <button className="btn" onClick={() => refresh(true)}>
            <RefreshCw size={15} />
            {t("desktop-common-refresh")}
          </button>
          <button className="btn" disabled={!path} onClick={() => path && revealItemInDir(path)}>
            <FolderOpen size={15} />
            {t("desktop-logs-reveal")}
          </button>
        </div>
      </div>

      {error && <div className="alert error">{error}</div>}

      <div className="card log-controls">
        <div>
          <span className={`pill ${tail?.exists ? "ok" : "warn"}`}>
            {tail?.exists ? t("desktop-logs-found") : t("desktop-logs-waiting")}
          </span>
          <div className="mono path-line">{path ?? "—"}</div>
        </div>
        <div className="toolbar">
          <label className="toggle">
            <input
              type="checkbox"
              checked={autoRefresh}
              onChange={(e) => setAutoRefresh(e.target.checked)}
            />
            <span>{t("desktop-logs-auto-refresh")}</span>
          </label>
          <select value={maxLines} onChange={(e) => setMaxLines(Number(e.target.value))}>
            {[100, 200, 500, 1000].map((count) => (
              <option key={count} value={count}>
                {t("desktop-logs-lines", { count })}
              </option>
            ))}
          </select>
        </div>
      </div>

      <div className="card" style={{ marginTop: 14 }}>
        <div className="pane-heading-row">
          <h2>{t("desktop-logs-tail")}</h2>
          {tail?.truncated && <span className="pill warn">{t("desktop-logs-truncated")}</span>}
          {autoRefresh && (
            <span className="pill ok">
              <Check size={11} /> {t("desktop-logs-auto")}
            </span>
          )}
        </div>
        {!tail ? (
          <div className="empty small">{t("desktop-logs-loading")}</div>
        ) : !tail.exists ? (
          <div className="empty small">
            <FileText size={18} />
            {t("desktop-logs-missing")}
          </div>
        ) : tail.lines.length === 0 ? (
          <div className="empty small">{t("desktop-logs-empty")}</div>
        ) : (
          <pre className="log-output">
            {tail.lines.map((line, index) => (
              <code key={`${index}-${line}`}>{line}</code>
            ))}
          </pre>
        )}
      </div>
    </>
  );
}
