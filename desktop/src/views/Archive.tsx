import { useEffect, useMemo, useState } from "react";
import {
  formatDicomDate,
  formatPersonName,
  listNodes,
  localSeries,
  localStudies,
  newTaskId,
  sendSeries,
  sendStudy,
} from "../api";
import type { RemoteNode, SendOutcome, SeriesSummary, StudySummary } from "../types";

export default function Archive() {
  const [studies, setStudies] = useState<StudySummary[]>([]);
  const [seriesByStudy, setSeriesByStudy] = useState<Record<string, SeriesSummary[]>>({});
  const [expanded, setExpanded] = useState<Set<string>>(new Set());
  const [nodes, setNodes] = useState<RemoteNode[]>([]);
  const [destination, setDestination] = useState("");
  const [filter, setFilter] = useState("");
  const [error, setError] = useState<string | null>(null);
  const [notice, setNotice] = useState<string | null>(null);
  const [sending, setSending] = useState<string | null>(null);
  const [loading, setLoading] = useState(true);

  const refresh = () => {
    setLoading(true);
    localStudies()
      .then(setStudies)
      .catch((e) => setError(String(e)))
      .finally(() => setLoading(false));
  };

  useEffect(() => {
    refresh();
    listNodes()
      .then((n) => {
        setNodes(n);
        if (n.length > 0) setDestination((prev) => prev || n[0].name);
      })
      .catch(console.error);
  }, []);

  const toggle = async (studyUid: string) => {
    const next = new Set(expanded);
    if (next.has(studyUid)) {
      next.delete(studyUid);
    } else {
      next.add(studyUid);
      if (!seriesByStudy[studyUid]) {
        try {
          const series = await localSeries(studyUid);
          setSeriesByStudy((prev) => ({ ...prev, [studyUid]: series }));
        } catch (e) {
          setError(String(e));
        }
      }
    }
    setExpanded(next);
  };

  const filtered = useMemo(() => {
    const q = filter.trim().toLowerCase();
    if (!q) return studies;
    return studies.filter((s) =>
      [s.patient_name, s.patient_id, s.study_description, s.modalities, s.study_date]
        .filter(Boolean)
        .some((v) => v!.toLowerCase().includes(q)),
    );
  }, [studies, filter]);

  const reportOutcome = (label: string, outcome: SendOutcome) => {
    if (outcome.failed > 0) {
      setError(
        `${label}: ${outcome.sent}/${outcome.attempted} sent, ${outcome.failed} failed. ` +
          outcome.failures.slice(0, 3).join(" · "),
      );
    } else {
      setNotice(`${label}: sent ${outcome.sent}/${outcome.attempted} instances.`);
    }
  };

  const doSendStudy = async (study: StudySummary) => {
    if (!destination) return;
    setSending(study.study_instance_uid);
    setError(null);
    setNotice(null);
    try {
      const outcome = await sendStudy(newTaskId(), study.study_instance_uid, destination);
      reportOutcome(`Study → ${destination}`, outcome);
    } catch (e) {
      setError(String(e));
    } finally {
      setSending(null);
    }
  };

  const doSendSeries = async (series: SeriesSummary) => {
    if (!destination) return;
    setSending(series.series_instance_uid);
    setError(null);
    setNotice(null);
    try {
      const outcome = await sendSeries(newTaskId(), series.series_instance_uid, destination);
      reportOutcome(`Series → ${destination}`, outcome);
    } catch (e) {
      setError(String(e));
    } finally {
      setSending(null);
    }
  };

  return (
    <>
      <div className="page-header">
        <h1>Local Archive</h1>
        <p>Studies indexed in the local SQLite archive. Expand a study to browse series.</p>
      </div>

      {error && <div className="alert error">{error}</div>}
      {notice && <div className="alert success">{notice}</div>}

      <div className="card">
        <div className="toolbar" style={{ marginBottom: 14 }}>
          <input
            style={{ width: 280 }}
            placeholder="Filter by patient, description, modality…"
            value={filter}
            onChange={(e) => setFilter(e.target.value)}
          />
          <button className="btn" onClick={refresh}>
            Refresh
          </button>
          <div className="spacer" />
          <label style={{ color: "var(--text-dim)", fontSize: 12 }}>Send to</label>
          <select value={destination} onChange={(e) => setDestination(e.target.value)}>
            {nodes.length === 0 && <option value="">No nodes</option>}
            {nodes.map((n) => (
              <option key={n.id} value={n.name}>
                {n.name}
              </option>
            ))}
          </select>
        </div>

        <div className="table-wrap">
          <table>
            <thead>
              <tr>
                <th style={{ width: 26 }} />
                <th>Patient</th>
                <th>Patient ID</th>
                <th>Date</th>
                <th>Description</th>
                <th>Modalities</th>
                <th className="num">Series</th>
                <th className="num">Instances</th>
                <th />
              </tr>
            </thead>
            <tbody>
              {loading && (
                <tr>
                  <td colSpan={9} className="empty">
                    Loading…
                  </td>
                </tr>
              )}
              {!loading && filtered.length === 0 && (
                <tr>
                  <td colSpan={9} className="empty">
                    {studies.length === 0
                      ? "The local archive is empty. Import files or retrieve a study."
                      : "No studies match the filter."}
                  </td>
                </tr>
              )}
              {filtered.map((study) => {
                const uid = study.study_instance_uid;
                const isOpen = expanded.has(uid);
                const series = seriesByStudy[uid];
                return (
                  <FragmentRow
                    key={uid}
                    study={study}
                    isOpen={isOpen}
                    series={series}
                    sending={sending}
                    canSend={!!destination && nodes.length > 0}
                    onToggle={() => toggle(uid)}
                    onSendStudy={() => doSendStudy(study)}
                    onSendSeries={doSendSeries}
                  />
                );
              })}
            </tbody>
          </table>
        </div>
      </div>
    </>
  );
}

function FragmentRow({
  study,
  isOpen,
  series,
  sending,
  canSend,
  onToggle,
  onSendStudy,
  onSendSeries,
}: {
  study: StudySummary;
  isOpen: boolean;
  series: SeriesSummary[] | undefined;
  sending: string | null;
  canSend: boolean;
  onToggle: () => void;
  onSendStudy: () => void;
  onSendSeries: (series: SeriesSummary) => void;
}) {
  return (
    <>
      <tr className="expandable" onClick={onToggle}>
        <td>
          <span className={`chevron${isOpen ? " open" : ""}`}>▶</span>
        </td>
        <td style={{ fontWeight: 550 }}>{formatPersonName(study.patient_name)}</td>
        <td className="mono">{study.patient_id ?? "—"}</td>
        <td className="mono">{formatDicomDate(study.study_date)}</td>
        <td className="dim">{study.study_description ?? "—"}</td>
        <td>
          {(study.modalities ?? "")
            .split(/[\\,]/)
            .filter(Boolean)
            .map((m) => (
              <span key={m} className="pill accent" style={{ marginRight: 4 }}>
                {m.trim()}
              </span>
            ))}
        </td>
        <td className="num">{study.series_count}</td>
        <td className="num">{study.instance_count}</td>
        <td style={{ textAlign: "right" }} onClick={(e) => e.stopPropagation()}>
          <button
            className="btn sm"
            disabled={!canSend || sending !== null}
            onClick={onSendStudy}
          >
            {sending === study.study_instance_uid && <span className="spinner" />}
            Send study
          </button>
        </td>
      </tr>
      {isOpen && (
        <tr className="subrow">
          <td colSpan={9}>
            {!series ? (
              <div className="empty">Loading series…</div>
            ) : series.length === 0 ? (
              <div className="empty">No series found.</div>
            ) : (
              <div className="subtable">
                <table>
                  <thead>
                    <tr>
                      <th className="num" style={{ width: 40 }}>
                        #
                      </th>
                      <th>Modality</th>
                      <th>Description</th>
                      <th className="num">Instances</th>
                      <th>Series UID</th>
                      <th />
                    </tr>
                  </thead>
                  <tbody>
                    {series.map((s) => (
                      <tr key={s.series_instance_uid}>
                        <td className="num dim">{s.series_number ?? "—"}</td>
                        <td>
                          {s.modality ? <span className="pill">{s.modality}</span> : "—"}
                        </td>
                        <td className="dim">{s.series_description ?? "—"}</td>
                        <td className="num">{s.instance_count}</td>
                        <td className="mono dim" style={{ fontSize: 11 }}>
                          {s.series_instance_uid}
                        </td>
                        <td style={{ textAlign: "right" }}>
                          <button
                            className="btn sm ghost"
                            disabled={!canSend || sending !== null}
                            onClick={() => onSendSeries(s)}
                          >
                            {sending === s.series_instance_uid && <span className="spinner" />}
                            Send series
                          </button>
                        </td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            )}
          </td>
        </tr>
      )}
    </>
  );
}
