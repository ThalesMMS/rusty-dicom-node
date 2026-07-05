import { FormEvent, useEffect, useRef, useState } from "react";
import {
  cancelTask,
  formatDicomDate,
  formatPersonName,
  listNodes,
  newTaskId,
  runQuery,
  runRetrieve,
} from "../api";
import type {
  MoveOutcome,
  QueryCriteria,
  QueryLevel,
  QueryMatch,
  RemoteNode,
} from "../types";

const EMPTY_FORM = {
  patient_name: "",
  patient_id: "",
  accession_number: "",
  modality: "",
  study_description: "",
  study_date_from: "",
  study_date_to: "",
  study_instance_uid: "",
};

export default function Query() {
  const [nodes, setNodes] = useState<RemoteNode[]>([]);
  const [node, setNode] = useState("");
  const [level, setLevel] = useState<QueryLevel>("Study");
  const [form, setForm] = useState(EMPTY_FORM);
  const [results, setResults] = useState<QueryMatch[] | null>(null);
  const [querying, setQuerying] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [retrieving, setRetrieving] = useState<string | null>(null);
  const [lastOutcome, setLastOutcome] = useState<MoveOutcome | null>(null);
  const queryTask = useRef<string | null>(null);

  useEffect(() => {
    listNodes()
      .then((n) => {
        setNodes(n);
        if (n.length > 0) setNode((prev) => prev || n[0].name);
      })
      .catch((e) => setError(String(e)));
  }, []);

  const set = (key: keyof typeof EMPTY_FORM) => (e: { target: { value: string } }) =>
    setForm({ ...form, [key]: e.target.value });

  const submit = async (e: FormEvent) => {
    e.preventDefault();
    if (!node) return;
    const criteria: QueryCriteria = {
      model: "StudyRoot",
      level,
      patient_name: form.patient_name || null,
      patient_id: form.patient_id || null,
      accession_number: form.accession_number || null,
      modality: form.modality || null,
      study_description: form.study_description || null,
      study_date_from: form.study_date_from.replaceAll("-", "") || null,
      study_date_to: form.study_date_to.replaceAll("-", "") || null,
      study_instance_uid: form.study_instance_uid || null,
    };
    const taskId = newTaskId();
    queryTask.current = taskId;
    setQuerying(true);
    setError(null);
    setLastOutcome(null);
    try {
      const matches = await runQuery(taskId, node, criteria);
      setResults(matches);
    } catch (err) {
      setError(String(err));
      setResults(null);
    } finally {
      setQuerying(false);
      queryTask.current = null;
    }
  };

  const cancelQuery = () => {
    if (queryTask.current) cancelTask(queryTask.current).catch(console.error);
  };

  const retrieve = async (match: QueryMatch) => {
    if (!match.study_instance_uid) {
      setError("Match has no StudyInstanceUID; cannot retrieve.");
      return;
    }
    const key = matchKey(match);
    const taskId = newTaskId();
    setRetrieving(key);
    setError(null);
    setLastOutcome(null);
    try {
      const outcome = await runRetrieve(taskId, {
        node_name_or_id: node,
        model: "StudyRoot",
        level: match.level,
        study_instance_uid: match.study_instance_uid,
        series_instance_uid: match.series_instance_uid,
        sop_instance_uid: match.sop_instance_uid,
        move_destination: null,
      });
      setLastOutcome(outcome);
    } catch (err) {
      setError(String(err));
    } finally {
      setRetrieving(null);
    }
  };

  return (
    <>
      <div className="page-header">
        <h1>Query / Retrieve</h1>
        <p>C-FIND against a remote node, C-MOVE results into the local archive.</p>
      </div>

      {error && <div className="alert error">{error}</div>}
      {lastOutcome && (
        <div className={`alert ${lastOutcome.failed > 0 ? "error" : "success"}`}>
          Retrieve finished — completed {lastOutcome.completed}, warnings{" "}
          {lastOutcome.warning}, failed {lastOutcome.failed}.
        </div>
      )}

      <div className="card">
        <h2>Search criteria</h2>
        <form onSubmit={submit}>
          <div className="form-grid">
            <div className="field">
              <label>Remote node</label>
              <select value={node} onChange={(e) => setNode(e.target.value)}>
                {nodes.length === 0 && <option value="">No nodes configured</option>}
                {nodes.map((n) => (
                  <option key={n.id} value={n.name}>
                    {n.name} ({n.ae_title}@{n.host}:{n.port})
                  </option>
                ))}
              </select>
            </div>
            <div className="field">
              <label>Level</label>
              <select value={level} onChange={(e) => setLevel(e.target.value as QueryLevel)}>
                <option value="Study">Study</option>
                <option value="Series">Series</option>
                <option value="Image">Image</option>
              </select>
            </div>
            <div className="field">
              <label>Patient name</label>
              <input placeholder="DOE^JOHN or DOE*" value={form.patient_name} onChange={set("patient_name")} />
            </div>
            <div className="field">
              <label>Patient ID</label>
              <input value={form.patient_id} onChange={set("patient_id")} />
            </div>
            <div className="field">
              <label>Accession #</label>
              <input value={form.accession_number} onChange={set("accession_number")} />
            </div>
            <div className="field">
              <label>Modality</label>
              <input placeholder="CT, MR, …" value={form.modality} onChange={set("modality")} />
            </div>
            <div className="field">
              <label>Study description</label>
              <input placeholder="CHEST*" value={form.study_description} onChange={set("study_description")} />
            </div>
            <div className="field">
              <label>Study date from</label>
              <input type="date" value={form.study_date_from} onChange={set("study_date_from")} />
            </div>
            <div className="field">
              <label>Study date to</label>
              <input type="date" value={form.study_date_to} onChange={set("study_date_to")} />
            </div>
            <div className="field">
              <label>Study Instance UID</label>
              <input className="mono" value={form.study_instance_uid} onChange={set("study_instance_uid")} />
            </div>
          </div>
          <div className="toolbar" style={{ marginTop: 14 }}>
            <button type="submit" className="btn primary" disabled={querying || !node}>
              {querying && <span className="spinner" />}
              {querying ? "Querying…" : "Run C-FIND"}
            </button>
            {querying && (
              <button type="button" className="btn danger" onClick={cancelQuery}>
                Cancel
              </button>
            )}
            <button
              type="button"
              className="btn ghost"
              onClick={() => {
                setForm(EMPTY_FORM);
                setResults(null);
              }}
            >
              Clear
            </button>
            {results && (
              <span style={{ color: "var(--text-dim)", fontSize: 12.5 }}>
                {results.length} match{results.length === 1 ? "" : "es"}
              </span>
            )}
          </div>
        </form>
      </div>

      {results && (
        <div className="card">
          <h2>Results</h2>
          <div className="table-wrap">
            <table>
              <thead>
                <tr>
                  <th>Patient</th>
                  <th>Patient ID</th>
                  <th>Date</th>
                  <th>Modality</th>
                  <th>Description</th>
                  <th>Accession</th>
                  {level !== "Study" && <th>Series</th>}
                  <th />
                </tr>
              </thead>
              <tbody>
                {results.length === 0 && (
                  <tr>
                    <td colSpan={8} className="empty">
                      No matches.
                    </td>
                  </tr>
                )}
                {results.map((m) => {
                  const key = matchKey(m);
                  return (
                    <tr key={key}>
                      <td>{formatPersonName(m.patient_name)}</td>
                      <td className="mono">{m.patient_id ?? "—"}</td>
                      <td className="mono">{formatDicomDate(m.study_date)}</td>
                      <td>
                        {m.modality ? <span className="pill accent">{m.modality}</span> : "—"}
                      </td>
                      <td className="dim">
                        {m.study_description ?? m.series_description ?? "—"}
                      </td>
                      <td className="mono dim">{m.accession_number ?? "—"}</td>
                      {level !== "Study" && (
                        <td className="mono dim">
                          {m.series_number ?? ""} {m.series_description ?? ""}
                        </td>
                      )}
                      <td style={{ textAlign: "right" }}>
                        <button
                          className="btn sm"
                          disabled={retrieving !== null}
                          onClick={() => retrieve(m)}
                        >
                          {retrieving === key && <span className="spinner" />}
                          Retrieve
                        </button>
                      </td>
                    </tr>
                  );
                })}
              </tbody>
            </table>
          </div>
        </div>
      )}
    </>
  );
}

function matchKey(m: QueryMatch): string {
  return (
    m.sop_instance_uid ??
    m.series_instance_uid ??
    m.study_instance_uid ??
    `${m.patient_id}-${m.study_date}-${m.accession_number}`
  );
}
