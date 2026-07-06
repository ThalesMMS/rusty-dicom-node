import { useEffect, useRef, useState } from "react";
import { open } from "@tauri-apps/plugin-dialog";
import { Archive, Ban, FileArchive, FolderOpen, Play, RotateCcw } from "lucide-react";
import {
  cancelTask,
  formatBytes,
  newTaskId,
  onImportProgress,
  runImport,
} from "../api";
import type { ActivityEntry, ImportProgress, ImportReport } from "../types";

interface Props {
  onActivity: (entry: Omit<ActivityEntry, "id" | "at">) => void;
}

export default function ImportView({ onActivity }: Props) {
  const [path, setPath] = useState("");
  const [recentPaths, setRecentPaths] = useState<string[]>([]);
  const [running, setRunning] = useState(false);
  const [progress, setProgress] = useState<ImportProgress | null>(null);
  const [report, setReport] = useState<ImportReport | null>(null);
  const [error, setError] = useState<string | null>(null);
  const taskRef = useRef<string | null>(null);

  useEffect(() => {
    const unlisten = onImportProgress((p) => {
      if (p.task_id === taskRef.current) setProgress(p);
    });
    return () => {
      unlisten.then((fn) => fn());
    };
  }, []);

  const rememberPath = (value: string) => {
    setRecentPaths((prev) => [value, ...prev.filter((item) => item !== value)].slice(0, 6));
  };

  const pickDirectory = async () => {
    const selected = await open({ directory: true, multiple: false, title: "Choose a directory to import" });
    if (typeof selected === "string") {
      setPath(selected);
      rememberPath(selected);
    }
  };

  const pickZip = async () => {
    const selected = await open({
      multiple: false,
      title: "Choose a ZIP archive to import",
      filters: [{ name: "ZIP archives", extensions: ["zip"] }],
    });
    if (typeof selected === "string") {
      setPath(selected);
      rememberPath(selected);
    }
  };

  const start = async () => {
    const cleanPath = path.trim();
    if (!cleanPath) return;
    const taskId = newTaskId();
    taskRef.current = taskId;
    setRunning(true);
    setError(null);
    setReport(null);
    setProgress(null);
    rememberPath(cleanPath);
    try {
      const result = await runImport(taskId, cleanPath);
      setReport(result);
      onActivity({
        kind: "import",
        title: "Import complete",
        detail: `${result.accepted}/${result.scanned_files} accepted, ${result.duplicates} duplicates, ${formatBytes(result.stored_bytes)}`,
        tone: result.failures.length > 0 || result.invalid_dicom > 0 || result.unreadable > 0 ? "warning" : "success",
      });
    } catch (e) {
      const message = String(e);
      setError(message);
      onActivity({ kind: "import", title: "Import failed", detail: message, tone: "error" });
    } finally {
      setRunning(false);
      taskRef.current = null;
    }
  };

  const cancel = () => {
    if (taskRef.current) cancelTask(taskRef.current).catch(console.error);
  };

  const pct =
    progress && progress.total
      ? Math.min(100, Math.round((progress.processed / progress.total) * 100))
      : null;

  return (
    <>
      <div className="page-header compact">
        <div>
          <h1>Import</h1>
          <p>Index DICOM files from recursive folders or ZIP archives into the managed local archive.</p>
        </div>
      </div>

      {error && <div className="alert error">{error}</div>}

      <div className="card">
        <h2>Source</h2>
        <div className="toolbar source-toolbar">
          <input
            className="mono"
            placeholder="/path/to/dicom-folder or /path/to/archive.zip"
            value={path}
            onChange={(e) => setPath(e.target.value)}
            disabled={running}
          />
          <button className="btn" onClick={pickDirectory} disabled={running}>
            <FolderOpen size={15} />
            Folder
          </button>
          <button className="btn" onClick={pickZip} disabled={running}>
            <FileArchive size={15} />
            ZIP
          </button>
        </div>
        {recentPaths.length > 0 && (
          <div className="chip-row">
            {recentPaths.map((item) => (
              <button key={item} className="chip" onClick={() => setPath(item)} disabled={running}>
                {item}
              </button>
            ))}
          </div>
        )}
        <div className="toolbar" style={{ marginTop: 14 }}>
          <button className="btn primary" onClick={start} disabled={running || !path.trim()}>
            {running ? <span className="spinner" /> : <Play size={15} />}
            {running ? "Importing…" : "Start import"}
          </button>
          {running && (
            <button className="btn danger" onClick={cancel}>
              <Ban size={15} />
              Cancel
            </button>
          )}
          <button className="btn ghost" onClick={() => setPath("")} disabled={running}>
            <RotateCcw size={15} />
            Clear path
          </button>
          {running && progress && (
            <span className="muted">
              {progress.processed}
              {progress.total ? ` / ${progress.total}` : ""} files
            </span>
          )}
        </div>
        {running && (
          <div style={{ marginTop: 14 }}>
            <div className="progress-track">
              <div
                className={`progress-fill${pct === null ? " indeterminate" : ""}`}
                style={{ width: pct === null ? undefined : `${pct}%` }}
              />
            </div>
          </div>
        )}
      </div>

      {report && (
        <div className="card">
          <h2>Import report</h2>
          <div className="grid cols-4">
            <ReportStat label="Scanned" value={report.scanned_files} />
            <ReportStat label="Accepted" value={report.accepted} accent />
            <ReportStat label="Duplicates" value={report.duplicates} />
            <ReportStat label="Stored" value={formatBytes(report.stored_bytes)} icon />
          </div>
          <div className="grid cols-3" style={{ marginTop: 14 }}>
            <div className="card micro-card">
              <h3>Rejected</h3>
              <dl className="kv dense">
                <dt>Invalid DICOM</dt>
                <dd>{report.invalid_dicom}</dd>
                <dt>Unreadable</dt>
                <dd>{report.unreadable}</dd>
                <dt>Skipped</dt>
                <dd>{report.skipped}</dd>
              </dl>
            </div>
            <div className="card micro-card">
              <h3>Duplicates</h3>
              <dl className="kv dense">
                <dt>SOP UID</dt>
                <dd>{report.duplicate_by_sop_instance_uid}</dd>
                <dt>SHA-256</dt>
                <dd>{report.duplicate_by_sha256}</dd>
                <dt>Total</dt>
                <dd>{report.duplicates}</dd>
              </dl>
            </div>
            <div className="card micro-card">
              <h3>Cleanup</h3>
              <dl className="kv dense">
                <dt>Failed cleanup</dt>
                <dd>{report.failed_cleanup}</dd>
                <dt>Failures</dt>
                <dd>{report.failures.length}</dd>
                <dt>Accepted bytes</dt>
                <dd>{formatBytes(report.stored_bytes)}</dd>
              </dl>
            </div>
          </div>
          {report.failures.length > 0 && (
            <div className="alert error" style={{ marginTop: 14, marginBottom: 0 }}>
              <strong>{report.failures.length} failure(s):</strong>
              <ul className="failure-list">
                {report.failures.slice(0, 12).map((f, i) => (
                  <li key={i} className="mono">
                    {f}
                  </li>
                ))}
                {report.failures.length > 12 && <li>… and {report.failures.length - 12} more</li>}
              </ul>
            </div>
          )}
        </div>
      )}
    </>
  );
}

function ReportStat({
  label,
  value,
  accent = false,
  icon = false,
}: {
  label: string;
  value: string | number;
  accent?: boolean;
  icon?: boolean;
}) {
  return (
    <div className="stat">
      <div className="stat-top">
        <span className="label">{label}</span>
        {icon && <Archive size={16} />}
      </div>
      <div className={`value${accent ? " accent" : ""}`}>{value}</div>
    </div>
  );
}
