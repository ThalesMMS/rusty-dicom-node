import { useEffect, useMemo, useState } from "react";
import { save } from "@tauri-apps/plugin-dialog";
import { revealItemInDir } from "@tauri-apps/plugin-opener";
import { Download, FileDown, FolderOpen, RefreshCw, Send } from "lucide-react";
import {
  exportLocalArchive,
  formatBytes,
  formatDicomDate,
  formatPersonName,
  listNodes,
  localInstances,
  localSeries,
  localStudies,
  newTaskId,
  sendSeries,
  sendStudy,
} from "../api";
import type {
  ActivityEntry,
  ArchiveExportFormat,
  LocalInstance,
  RemoteNode,
  SendOutcome,
  SeriesSummary,
  StudySummary,
} from "../types";

interface Props {
  onActivity: (entry: Omit<ActivityEntry, "id" | "at">) => void;
}

export default function Archive({ onActivity }: Props) {
  const [studies, setStudies] = useState<StudySummary[]>([]);
  const [series, setSeries] = useState<SeriesSummary[]>([]);
  const [instances, setInstances] = useState<LocalInstance[]>([]);
  const [selectedStudyUid, setSelectedStudyUid] = useState<string | null>(null);
  const [selectedSeriesUid, setSelectedSeriesUid] = useState<string | null>(null);
  const [nodes, setNodes] = useState<RemoteNode[]>([]);
  const [destination, setDestination] = useState("");
  const [filter, setFilter] = useState("");
  const [error, setError] = useState<string | null>(null);
  const [notice, setNotice] = useState<string | null>(null);
  const [sending, setSending] = useState<string | null>(null);
  const [exporting, setExporting] = useState(false);
  const [loading, setLoading] = useState(true);

  const selectedStudy = studies.find((study) => study.study_instance_uid === selectedStudyUid) ?? null;
  const selectedSeries = series.find((row) => row.series_instance_uid === selectedSeriesUid) ?? null;

  const refreshStudies = () => {
    setLoading(true);
    localStudies()
      .then((rows) => {
        setStudies(rows);
        setSelectedStudyUid((current) => {
          if (current && rows.some((row) => row.study_instance_uid === current)) return current;
          return rows[0]?.study_instance_uid ?? null;
        });
      })
      .catch((e) => setError(String(e)))
      .finally(() => setLoading(false));
  };

  useEffect(() => {
    refreshStudies();
    listNodes()
      .then((n) => {
        setNodes(n);
        if (n.length > 0) setDestination((prev) => prev || n[0].name);
      })
      .catch(console.error);
  }, []);

  useEffect(() => {
    if (!selectedStudyUid) {
      setSeries([]);
      setInstances([]);
      setSelectedSeriesUid(null);
      return;
    }
    localSeries(selectedStudyUid)
      .then((rows) => {
        setSeries(rows);
        setSelectedSeriesUid((current) => {
          if (current && rows.some((row) => row.series_instance_uid === current)) return current;
          return rows[0]?.series_instance_uid ?? null;
        });
      })
      .catch((e) => setError(String(e)));
  }, [selectedStudyUid]);

  useEffect(() => {
    if (!selectedSeriesUid) {
      setInstances([]);
      return;
    }
    localInstances(selectedSeriesUid).then(setInstances).catch((e) => setError(String(e)));
  }, [selectedSeriesUid]);

  const filtered = useMemo(() => {
    const q = filter.trim().toLowerCase();
    if (!q) return studies;
    return studies.filter((s) =>
      [s.patient_name, s.patient_id, s.study_description, s.modalities, s.study_date, s.study_instance_uid]
        .filter(Boolean)
        .some((v) => v!.toLowerCase().includes(q)),
    );
  }, [studies, filter]);

  const reportOutcome = (label: string, outcome: SendOutcome) => {
    if (outcome.failed > 0) {
      const message = `${label}: ${outcome.sent}/${outcome.attempted} sent, ${outcome.failed} failed. ${outcome.failures
        .slice(0, 3)
        .join(" · ")}`;
      setError(message);
      onActivity({ kind: "send", title: label, detail: message, tone: "error" });
    } else {
      const message = `${label}: sent ${outcome.sent}/${outcome.attempted} instances.`;
      setNotice(message);
      onActivity({ kind: "send", title: label, detail: message, tone: "success" });
    }
  };

  const doSendStudy = async () => {
    if (!destination || !selectedStudy) return;
    setSending(selectedStudy.study_instance_uid);
    setError(null);
    setNotice(null);
    try {
      const outcome = await sendStudy(newTaskId(), selectedStudy.study_instance_uid, destination);
      reportOutcome(`Study → ${destination}`, outcome);
    } catch (e) {
      const message = String(e);
      setError(message);
      onActivity({ kind: "send", title: `Study → ${destination} failed`, detail: message, tone: "error" });
    } finally {
      setSending(null);
    }
  };

  const doSendSeries = async () => {
    if (!destination || !selectedSeries) return;
    setSending(selectedSeries.series_instance_uid);
    setError(null);
    setNotice(null);
    try {
      const outcome = await sendSeries(newTaskId(), selectedSeries.series_instance_uid, destination);
      reportOutcome(`Series → ${destination}`, outcome);
    } catch (e) {
      const message = String(e);
      setError(message);
      onActivity({ kind: "send", title: `Series → ${destination} failed`, detail: message, tone: "error" });
    } finally {
      setSending(null);
    }
  };

  const doExport = async (format: ArchiveExportFormat, scope: "studies" | "series") => {
    if (scope === "series" && !selectedStudy) return;
    const extension = format === "json" ? "json" : "csv";
    const defaultPath =
      scope === "studies"
        ? `dicom-studies.${extension}`
        : `dicom-series-${selectedStudy!.study_instance_uid.slice(0, 18)}.${extension}`;
    const outPath = await save({
      title: `Export ${scope}`,
      defaultPath,
      filters: [{ name: format.toUpperCase(), extensions: [extension] }],
    });
    if (!outPath) return;
    setExporting(true);
    setError(null);
    setNotice(null);
    try {
      const result = await exportLocalArchive(
        scope,
        format,
        outPath,
        scope === "series" ? selectedStudy!.study_instance_uid : null,
      );
      const message = `Exported ${result.rows} ${scope} row${result.rows === 1 ? "" : "s"} to ${result.path}.`;
      setNotice(message);
      onActivity({ kind: "export", title: `Export ${scope}`, detail: message, tone: "success" });
    } catch (e) {
      const message = String(e);
      setError(message);
      onActivity({ kind: "export", title: `Export ${scope} failed`, detail: message, tone: "error" });
    } finally {
      setExporting(false);
    }
  };

  return (
    <>
      <div className="page-header compact">
        <div>
          <h1>Local Archive</h1>
          <p>Study, series, and instance inventory from the local SQLite archive.</p>
        </div>
        <div className="header-actions">
          <button className="btn" onClick={refreshStudies}>
            <RefreshCw size={15} />
            Refresh
          </button>
          <button className="btn" onClick={() => doExport("csv", "studies")} disabled={exporting}>
            <FileDown size={15} />
            Export studies
          </button>
        </div>
      </div>

      {error && <div className="alert error">{error}</div>}
      {notice && <div className="alert success">{notice}</div>}

      <div className="archive-toolbar card">
        <input
          placeholder="Filter by patient, UID, description, modality…"
          value={filter}
          onChange={(e) => setFilter(e.target.value)}
        />
        <div className="spacer" />
        <label>Send to</label>
        <select value={destination} onChange={(e) => setDestination(e.target.value)}>
          {nodes.length === 0 && <option value="">No nodes</option>}
          {nodes.map((n) => (
            <option key={n.id} value={n.name}>
              {n.name}
            </option>
          ))}
        </select>
      </div>

      <div className="archive-layout">
        <section className="card archive-pane studies-pane">
          <h2>Studies</h2>
          <div className="pane-list">
            {loading && <div className="empty small">Loading studies…</div>}
            {!loading && filtered.length === 0 && (
              <div className="empty small">
                {studies.length === 0 ? "The local archive is empty." : "No studies match the filter."}
              </div>
            )}
            {filtered.map((study) => (
              <button
                key={study.study_instance_uid}
                className={`list-row${selectedStudyUid === study.study_instance_uid ? " active" : ""}`}
                onClick={() => setSelectedStudyUid(study.study_instance_uid)}
              >
                <span className="row-main">{formatPersonName(study.patient_name)}</span>
                <span className="row-sub">
                  {formatDicomDate(study.study_date)} · {study.modalities ?? "—"} · {study.instance_count} inst.
                </span>
                <span className="row-sub mono">{study.patient_id ?? "—"}</span>
              </button>
            ))}
          </div>
        </section>

        <section className="card archive-pane series-pane">
          <div className="pane-heading-row">
            <h2>Series</h2>
            <button className="btn sm ghost" disabled={!selectedStudy || exporting} onClick={() => doExport("json", "series")}>
              <Download size={14} />
              JSON
            </button>
            <button className="btn sm ghost" disabled={!selectedStudy || exporting} onClick={() => doExport("csv", "series")}>
              <Download size={14} />
              CSV
            </button>
          </div>
          <div className="pane-list">
            {!selectedStudy && <div className="empty small">Select a study.</div>}
            {selectedStudy && series.length === 0 && <div className="empty small">No series found.</div>}
            {series.map((row) => (
              <button
                key={row.series_instance_uid}
                className={`list-row${selectedSeriesUid === row.series_instance_uid ? " active" : ""}`}
                onClick={() => setSelectedSeriesUid(row.series_instance_uid)}
              >
                <span className="row-main">
                  {row.modality ? <span className="pill accent">{row.modality}</span> : "—"}{" "}
                  {row.series_description ?? "Series"}
                </span>
                <span className="row-sub">
                  #{row.series_number ?? "—"} · {row.instance_count} instance{row.instance_count === 1 ? "" : "s"}
                </span>
                <span className="row-sub mono">{row.series_instance_uid}</span>
              </button>
            ))}
          </div>
        </section>

        <section className="card archive-pane detail-pane">
          <h2>Details</h2>
          {selectedStudy ? (
            <>
              <dl className="kv dense">
                <dt>Patient</dt>
                <dd>{formatPersonName(selectedStudy.patient_name)}</dd>
                <dt>Patient ID</dt>
                <dd>{selectedStudy.patient_id ?? "—"}</dd>
                <dt>Study date</dt>
                <dd>{formatDicomDate(selectedStudy.study_date)}</dd>
                <dt>Description</dt>
                <dd>{selectedStudy.study_description ?? "—"}</dd>
                <dt>Study UID</dt>
                <dd>{selectedStudy.study_instance_uid}</dd>
              </dl>
              <div className="toolbar tight" style={{ marginTop: 12 }}>
                <button className="btn primary" disabled={!destination || sending !== null} onClick={doSendStudy}>
                  {sending === selectedStudy.study_instance_uid ? <span className="spinner" /> : <Send size={15} />}
                  Send study
                </button>
                <button className="btn" disabled={!selectedSeries || !destination || sending !== null} onClick={doSendSeries}>
                  {selectedSeries && sending === selectedSeries.series_instance_uid ? <span className="spinner" /> : <Send size={15} />}
                  Send series
                </button>
              </div>
            </>
          ) : (
            <div className="empty small">Select a study.</div>
          )}

          <h2 style={{ marginTop: 18 }}>Instances</h2>
          <div className="instance-list">
            {!selectedSeries && <div className="empty small">Select a series.</div>}
            {selectedSeries && instances.length === 0 && <div className="empty small">No instances found.</div>}
            {instances.map((instance) => (
              <div className="instance-row" key={instance.sop_instance_uid}>
                <div>
                  <div className="mono">#{instance.instance_number ?? "—"} · {instance.sop_instance_uid}</div>
                  <div className="row-sub">
                    {formatBytes(instance.file_size_bytes)} · TS {instance.transfer_syntax_uid ?? "—"} · imported{" "}
                    {new Date(instance.imported_at).toLocaleString()}
                  </div>
                  <div className="row-sub mono">{instance.managed_path}</div>
                </div>
                <button className="icon-btn" title="Reveal file" onClick={() => revealItemInDir(instance.managed_path)}>
                  <FolderOpen size={15} />
                </button>
              </div>
            ))}
          </div>
        </section>
      </div>
    </>
  );
}
