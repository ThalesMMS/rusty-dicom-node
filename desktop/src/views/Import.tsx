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
import { useI18n } from "../i18n";
import type { ActivityEntry, ImportProgress, ImportReport } from "../types";

interface Props {
  onActivity: (entry: Omit<ActivityEntry, "id" | "at">) => void;
}

export default function ImportView({ onActivity }: Props) {
  const { t } = useI18n();
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
    const selected = await open({ directory: true, multiple: false, title: t("desktop-import-pick-dir") });
    if (typeof selected === "string") {
      setPath(selected);
      rememberPath(selected);
    }
  };

  const pickZip = async () => {
    const selected = await open({
      multiple: false,
      title: t("desktop-import-pick-zip"),
      filters: [{ name: t("desktop-import-zip-filter"), extensions: ["zip"] }],
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
        title: t("desktop-import-activity-ok"),
        detail: t("desktop-import-activity-detail", {
          accepted: result.accepted,
          scanned: result.scanned_files,
          duplicates: result.duplicates,
          bytes: formatBytes(result.stored_bytes),
        }),
        tone: result.failures.length > 0 || result.invalid_dicom > 0 || result.unreadable > 0 ? "warning" : "success",
      });
    } catch (e) {
      const message = String(e);
      setError(message);
      onActivity({ kind: "import", title: t("desktop-import-activity-fail"), detail: message, tone: "error" });
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

  const progressLabel =
    progress == null
      ? ""
      : progress.total
        ? `${progress.processed} / ${progress.total}`
        : String(progress.processed);

  return (
    <>
      <div className="page-header compact">
        <div>
          <h1>{t("desktop-import-title")}</h1>
          <p>{t("desktop-import-subtitle")}</p>
        </div>
      </div>

      {error && <div className="alert error">{error}</div>}

      <div className="card">
        <h2>{t("desktop-import-source")}</h2>
        <div className="toolbar source-toolbar">
          <input
            className="mono"
            placeholder={t("desktop-import-placeholder")}
            value={path}
            onChange={(e) => setPath(e.target.value)}
            disabled={running}
          />
          <button className="btn" onClick={pickDirectory} disabled={running}>
            <FolderOpen size={15} />
            {t("desktop-import-folder")}
          </button>
          <button className="btn" onClick={pickZip} disabled={running}>
            <FileArchive size={15} />
            {t("desktop-import-zip")}
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
            {running ? t("desktop-import-running") : t("desktop-import-start")}
          </button>
          {running && (
            <button className="btn danger" onClick={cancel}>
              <Ban size={15} />
              {t("desktop-common-cancel")}
            </button>
          )}
          <button className="btn ghost" onClick={() => setPath("")} disabled={running}>
            <RotateCcw size={15} />
            {t("desktop-import-clear-path")}
          </button>
          {running && progress && (
            <span className="muted">{t("desktop-import-files-progress", { label: progressLabel })}</span>
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
          <h2>{t("desktop-import-report")}</h2>
          <div className="grid cols-4">
            <ReportStat label={t("desktop-import-scanned")} value={report.scanned_files} />
            <ReportStat label={t("desktop-import-accepted")} value={report.accepted} accent />
            <ReportStat label={t("desktop-import-duplicates")} value={report.duplicates} />
            <ReportStat label={t("desktop-import-stored")} value={formatBytes(report.stored_bytes)} icon />
          </div>
          <div className="grid cols-3" style={{ marginTop: 14 }}>
            <div className="card micro-card">
              <h3>{t("desktop-import-rejected")}</h3>
              <dl className="kv dense">
                <dt>{t("desktop-import-invalid-dicom")}</dt>
                <dd>{report.invalid_dicom}</dd>
                <dt>{t("desktop-import-unreadable")}</dt>
                <dd>{report.unreadable}</dd>
                <dt>{t("desktop-import-skipped")}</dt>
                <dd>{report.skipped}</dd>
              </dl>
            </div>
            <div className="card micro-card">
              <h3>{t("desktop-import-duplicates")}</h3>
              <dl className="kv dense">
                <dt>{t("desktop-import-dup-sop")}</dt>
                <dd>{report.duplicate_by_sop_instance_uid}</dd>
                <dt>{t("desktop-import-dup-sha")}</dt>
                <dd>{report.duplicate_by_sha256}</dd>
                <dt>{t("desktop-import-dup-total")}</dt>
                <dd>{report.duplicates}</dd>
              </dl>
            </div>
            <div className="card micro-card">
              <h3>{t("desktop-import-cleanup")}</h3>
              <dl className="kv dense">
                <dt>{t("desktop-import-failed-cleanup")}</dt>
                <dd>{report.failed_cleanup}</dd>
                <dt>{t("desktop-import-failures")}</dt>
                <dd>{report.failures.length}</dd>
                <dt>{t("desktop-import-accepted-bytes")}</dt>
                <dd>{formatBytes(report.stored_bytes)}</dd>
              </dl>
            </div>
          </div>
          {report.failures.length > 0 && (
            <div className="alert error" style={{ marginTop: 14, marginBottom: 0 }}>
              <strong>{t("desktop-import-failures-heading", { count: report.failures.length })}</strong>
              <ul className="failure-list">
                {report.failures.slice(0, 12).map((f, i) => (
                  <li key={i} className="mono">
                    {f}
                  </li>
                ))}
                {report.failures.length > 12 && (
                  <li>{t("desktop-import-failures-more", { count: report.failures.length - 12 })}</li>
                )}
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
