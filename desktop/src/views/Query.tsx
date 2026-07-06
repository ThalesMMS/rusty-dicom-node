import { FormEvent, useEffect, useMemo, useRef, useState } from "react";
import { Ban, Download, RotateCcw, Search } from "lucide-react";
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
  ActivityEntry,
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
  series_instance_uid: "",
  sop_instance_uid: "",
};

interface Props {
  onActivity: (entry: Omit<ActivityEntry, "id" | "at">) => void;
}

export default function Query({ onActivity }: Props) {
  const [nodes, setNodes] = useState<RemoteNode[]>([]);
  const [node, setNode] = useState("");
  const [level, setLevel] = useState<QueryLevel>("Study");
  const [form, setForm] = useState(EMPTY_FORM);
  const [results, setResults] = useState<QueryMatch[] | null>(null);
  const [selectedKey, setSelectedKey] = useState<string | null>(null);
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

  const selected = useMemo(() => {
    if (!results || !selectedKey) return null;
    return results.find((match) => matchKey(match) === selectedKey) ?? null;
  }, [results, selectedKey]);

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
      series_instance_uid: form.series_instance_uid || null,
      sop_instance_uid: form.sop_instance_uid || null,
    };
    const taskId = newTaskId();
    queryTask.current = taskId;
    setQuerying(true);
    setError(null);
    setLastOutcome(null);
    setSelectedKey(null);
    try {
      const matches = await runQuery(taskId, node, criteria);
      setResults(matches);
      if (matches.length > 0) setSelectedKey(matchKey(matches[0]));
      onActivity({
        kind: "query",
        title: `C-FIND ${node}`,
        detail: `${matches.length} match${matches.length === 1 ? "" : "es"} at ${level} level`,
        tone: "success",
      });
    } catch (err) {
      const message = String(err);
      setError(message);
      setResults(null);
      onActivity({ kind: "query", title: `C-FIND ${node} failed`, detail: message, tone: "error" });
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
    setSelectedKey(key);
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
      onActivity({
        kind: "retrieve",
        title: `C-MOVE ${node}`,
        detail: `completed=${outcome.completed}, warning=${outcome.warning}, failed=${outcome.failed}`,
        tone: outcome.failed > 0 ? "warning" : "success",
      });
    } catch (err) {
      const message = String(err);
      setError(message);
      onActivity({ kind: "retrieve", title: `C-MOVE ${node} failed`, detail: message, tone: "error" });
    } finally {
      setRetrieving(null);
    }
  };

  return (
    <>
      <div className="page-header compact">
        <div>
          <h1>Query / Retrieve</h1>
          <p>C-FIND a remote node, inspect matches, then C-MOVE into the local archive.</p>
        </div>
      </div>

      {error && <div className="alert error">{error}</div>}
      {lastOutcome && (
        <div className={`alert ${lastOutcome.failed > 0 ? "error" : "success"}`}>
          Retrieve finished: completed {lastOutcome.completed}, warnings {lastOutcome.warning}, failed{" "}
          {lastOutcome.failed}.
        </div>
      )}

      <div className="workspace-grid">
        <section className="card">
          <h2>Search criteria</h2>
          <form onSubmit={submit}>
            <div className="form-grid compact">
              <div className="field span-2">
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
                <label>Modality</label>
                <input placeholder="CT, MR, …" value={form.modality} onChange={set("modality")} />
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
              <div className="field span-2">
                <label>Study Instance UID</label>
                <input className="mono" value={form.study_instance_uid} onChange={set("study_instance_uid")} />
              </div>
              <div className="field span-2">
                <label>Series Instance UID</label>
                <input className="mono" value={form.series_instance_uid} onChange={set("series_instance_uid")} />
              </div>
              <div className="field span-2">
                <label>SOP Instance UID</label>
                <input className="mono" value={form.sop_instance_uid} onChange={set("sop_instance_uid")} />
              </div>
            </div>
            <div className="toolbar" style={{ marginTop: 14 }}>
              <button type="submit" className="btn primary" disabled={querying || !node}>
                {querying ? <span className="spinner" /> : <Search size={15} />}
                {querying ? "Querying…" : "Run C-FIND"}
              </button>
              {querying && (
                <button type="button" className="btn danger" onClick={cancelQuery}>
                  <Ban size={15} />
                  Cancel
                </button>
              )}
              <button
                type="button"
                className="btn ghost"
                onClick={() => {
                  setForm(EMPTY_FORM);
                  setResults(null);
                  setSelectedKey(null);
                }}
              >
                <RotateCcw size={15} />
                Clear
              </button>
              {results && <span className="muted">{results.length} matches</span>}
            </div>
          </form>
        </section>

        <aside className="card detail-card">
          <h2>Selected match</h2>
          {selected ? (
            <>
              <dl className="kv dense">
                <dt>Patient</dt>
                <dd>{formatPersonName(selected.patient_name)}</dd>
                <dt>Patient ID</dt>
                <dd>{selected.patient_id ?? "—"}</dd>
                <dt>Date</dt>
                <dd>{formatDicomDate(selected.study_date)}</dd>
                <dt>Level</dt>
                <dd>{selected.level}</dd>
                <dt>Modality</dt>
                <dd>{selected.modality ?? "—"}</dd>
                <dt>Study UID</dt>
                <dd>{selected.study_instance_uid ?? "—"}</dd>
                <dt>Series UID</dt>
                <dd>{selected.series_instance_uid ?? "—"}</dd>
                <dt>SOP UID</dt>
                <dd>{selected.sop_instance_uid ?? "—"}</dd>
              </dl>
              <button
                className="btn primary full"
                disabled={retrieving !== null}
                onClick={() => retrieve(selected)}
                style={{ marginTop: 14 }}
              >
                {retrieving === matchKey(selected) ? <span className="spinner" /> : <Download size={15} />}
                Retrieve selected
              </button>
            </>
          ) : (
            <div className="empty small">Run a query and select a match.</div>
          )}
        </aside>
      </div>

      {results && (
        <div className="card" style={{ marginTop: 14 }}>
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
                  <th>Series</th>
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
                  const isSelected = selectedKey === key;
                  return (
                    <tr key={key} className={isSelected ? "selected-row" : ""} onClick={() => setSelectedKey(key)}>
                      <td>{formatPersonName(m.patient_name)}</td>
                      <td className="mono">{m.patient_id ?? "—"}</td>
                      <td className="mono">{formatDicomDate(m.study_date)}</td>
                      <td>{m.modality ? <span className="pill accent">{m.modality}</span> : "—"}</td>
                      <td className="dim">{m.study_description ?? m.series_description ?? "—"}</td>
                      <td className="mono dim">{m.accession_number ?? "—"}</td>
                      <td className="mono dim">
                        {m.series_number ?? ""} {m.series_description ?? ""}
                      </td>
                      <td style={{ textAlign: "right" }}>
                        <button
                          className="btn sm"
                          disabled={retrieving !== null}
                          onClick={(e) => {
                            e.stopPropagation();
                            retrieve(m);
                          }}
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
