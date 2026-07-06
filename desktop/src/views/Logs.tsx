import { useEffect, useState } from "react";
import { revealItemInDir } from "@tauri-apps/plugin-opener";
import { Check, FileText, FolderOpen, RefreshCw } from "lucide-react";
import { tailLog } from "../api";
import type { ActivityEntry, LogTailResult, Status } from "../types";

interface Props {
  status: Status | null;
  onActivity: (entry: Omit<ActivityEntry, "id" | "at">) => void;
}

export default function Logs({ status, onActivity }: Props) {
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
          title: "Log refreshed",
          detail: `${result.lines.length} line${result.lines.length === 1 ? "" : "s"} loaded`,
          tone: "info",
        });
      }
    } catch (e) {
      const message = String(e);
      setError(message);
      onActivity({ kind: "log", title: "Log refresh failed", detail: message, tone: "error" });
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
          <h1>Logs</h1>
          <p>Bounded tail of the active desktop log file.</p>
        </div>
        <div className="header-actions">
          <button className="btn" onClick={() => refresh(true)}>
            <RefreshCw size={15} />
            Refresh
          </button>
          <button className="btn" disabled={!path} onClick={() => path && revealItemInDir(path)}>
            <FolderOpen size={15} />
            Reveal
          </button>
        </div>
      </div>

      {error && <div className="alert error">{error}</div>}

      <div className="card log-controls">
        <div>
          <span className={`pill ${tail?.exists ? "ok" : "warn"}`}>
            {tail?.exists ? "LOG FILE FOUND" : "WAITING FOR LOG FILE"}
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
            <span>Auto refresh</span>
          </label>
          <select value={maxLines} onChange={(e) => setMaxLines(Number(e.target.value))}>
            <option value={100}>100 lines</option>
            <option value={200}>200 lines</option>
            <option value={500}>500 lines</option>
            <option value={1000}>1000 lines</option>
          </select>
        </div>
      </div>

      <div className="card" style={{ marginTop: 14 }}>
        <div className="pane-heading-row">
          <h2>Tail</h2>
          {tail?.truncated && <span className="pill warn">TRUNCATED</span>}
          {autoRefresh && (
            <span className="pill ok">
              <Check size={11} /> AUTO
            </span>
          )}
        </div>
        {!tail ? (
          <div className="empty small">Loading log…</div>
        ) : !tail.exists ? (
          <div className="empty small">
            <FileText size={18} />
            The active log file has not been created yet.
          </div>
        ) : tail.lines.length === 0 ? (
          <div className="empty small">The log file is empty.</div>
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
