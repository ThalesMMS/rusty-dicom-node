import { useEffect, useRef, useState } from "react";
import { open } from "@tauri-apps/plugin-dialog";
import {
  cancelTask,
  formatBytes,
  newTaskId,
  onImportProgress,
  runImport,
} from "../api";
import type { ImportProgress, ImportReport } from "../types";

export default function ImportView() {
  const [path, setPath] = useState("");
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

  const pickDirectory = async () => {
    const selected = await open({ directory: true, multiple: false, title: "Choose a directory to import" });
    if (typeof selected === "string") setPath(selected);
  };

  const pickZip = async () => {
    const selected = await open({
      multiple: false,
      title: "Choose a ZIP archive to import",
      filters: [{ name: "ZIP archives", extensions: ["zip"] }],
    });
    if (typeof selected === "string") setPath(selected);
  };

  const start = async () => {
    if (!path.trim()) return;
    const taskId = newTaskId();
    taskRef.current = taskId;
    setRunning(true);
    setError(null);
    setReport(null);
    setProgress(null);
    try {
      const result = await runImport(taskId, path.trim());
      setReport(result);
    } catch (e) {
      setError(String(e));
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
      <div className="page-header">
        <h1>Import</h1>
        <p>
          Index DICOM files into the local archive from a directory (recursive) or a ZIP
          archive — non-DICOM files are skipped safely.
        </p>
      </div>

      {error && <div className="alert error">{error}</div>}

      <div className="card">
        <h2>Source</h2>
        <div className="toolbar">
          <input
            style={{ flex: 1, minWidth: 260 }}
            className="mono"
            placeholder="/path/to/dicom-folder or /path/to/archive.zip"
            value={path}
            onChange={(e) => setPath(e.target.value)}
            disabled={running}
          />
          <button className="btn" onClick={pickDirectory} disabled={running}>
            Choose folder…
          </button>
          <button className="btn" onClick={pickZip} disabled={running}>
            Choose ZIP…
          </button>
        </div>
        <div className="toolbar" style={{ marginTop: 14 }}>
          <button className="btn primary" onClick={start} disabled={running || !path.trim()}>
            {running && <span className="spinner" />}
            {running ? "Importing…" : "Start import"}
          </button>
          {running && (
            <button className="btn danger" onClick={cancel}>
              Cancel
            </button>
          )}
          {running && progress && (
            <span style={{ color: "var(--text-dim)", fontSize: 12.5 }}>
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
            <div className="stat">
              <div className="label">Scanned</div>
              <div className="value">{report.scanned_files}</div>
            </div>
            <div className="stat">
              <div className="label">Accepted</div>
              <div className="value accent">{report.accepted}</div>
            </div>
            <div className="stat">
              <div className="label">Duplicates</div>
              <div className="value">{report.duplicates}</div>
            </div>
            <div className="stat">
              <div className="label">Stored</div>
              <div className="value">{formatBytes(report.stored_bytes)}</div>
            </div>
          </div>
          <dl className="kv" style={{ marginTop: 16 }}>
            <dt>Invalid DICOM</dt>
            <dd>{report.invalid_dicom}</dd>
            <dt>Unreadable</dt>
            <dd>{report.unreadable}</dd>
            <dt>Skipped</dt>
            <dd>{report.skipped}</dd>
            <dt>Duplicate by SOP UID</dt>
            <dd>{report.duplicate_by_sop_instance_uid}</dd>
            <dt>Duplicate by SHA-256</dt>
            <dd>{report.duplicate_by_sha256}</dd>
          </dl>
          {report.failures.length > 0 && (
            <div className="alert error" style={{ marginTop: 14, marginBottom: 0 }}>
              <strong>{report.failures.length} failure(s):</strong>
              <ul style={{ marginTop: 6, paddingLeft: 18 }}>
                {report.failures.slice(0, 10).map((f, i) => (
                  <li key={i} className="mono" style={{ fontSize: 11.5 }}>
                    {f}
                  </li>
                ))}
                {report.failures.length > 10 && <li>… and {report.failures.length - 10} more</li>}
              </ul>
            </div>
          )}
        </div>
      )}
    </>
  );
}
