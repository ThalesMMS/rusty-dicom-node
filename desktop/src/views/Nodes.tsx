import { FormEvent, useEffect, useMemo, useState } from "react";
import { Edit3, Plus, RotateCcw, Trash2 } from "lucide-react";
import { addNode, deleteNode, listNodes, updateNode } from "../api";
import type { NodeDraft, RemoteNode } from "../types";

const EMPTY: NodeDraft = {
  name: "",
  ae_title: "",
  host: "",
  port: 104,
  move_destination: null,
  notes: null,
};

export default function Nodes() {
  const [nodes, setNodes] = useState<RemoteNode[]>([]);
  const [draft, setDraft] = useState<NodeDraft>(EMPTY);
  const [editingId, setEditingId] = useState<string | null>(null);
  const [error, setError] = useState<string | null>(null);
  const [notice, setNotice] = useState<string | null>(null);
  const [busy, setBusy] = useState(false);

  const validation = useMemo(() => validateDraft(draft), [draft]);
  const canSubmit = validation.length === 0 && !busy;

  const refresh = () => listNodes().then(setNodes).catch((e) => setError(String(e)));

  useEffect(() => {
    refresh();
  }, []);

  const startEdit = (node: RemoteNode) => {
    setEditingId(node.id);
    setDraft({
      name: node.name,
      ae_title: node.ae_title,
      host: node.host,
      port: node.port,
      move_destination: node.preferred_move_destination,
      notes: node.notes,
    });
    setError(null);
    setNotice(null);
  };

  const reset = () => {
    setEditingId(null);
    setDraft(EMPTY);
  };

  const submit = async (e: FormEvent) => {
    e.preventDefault();
    if (!canSubmit) return;
    setBusy(true);
    setError(null);
    setNotice(null);
    try {
      if (editingId) {
        const updated = await updateNode(editingId, draft);
        setNotice(`Updated node "${updated.name}".`);
      } else {
        const created = await addNode(draft);
        setNotice(`Added node "${created.name}".`);
      }
      reset();
      await refresh();
    } catch (err) {
      setError(String(err));
    } finally {
      setBusy(false);
    }
  };

  const remove = async (node: RemoteNode) => {
    if (!confirm(`Delete node "${node.name}"?`)) return;
    setError(null);
    setNotice(null);
    try {
      await deleteNode(node.id);
      if (editingId === node.id) reset();
      setNotice(`Deleted node "${node.name}".`);
      await refresh();
    } catch (err) {
      setError(String(err));
    }
  };

  return (
    <>
      <div className="page-header compact">
        <div>
          <h1>Remote Nodes</h1>
          <p>PACS and workstation peers for query, retrieve, and store operations.</p>
        </div>
      </div>

      {error && <div className="alert error">{error}</div>}
      {notice && <div className="alert success">{notice}</div>}

      <div className="workspace-grid">
        <section className="card">
          <h2>{editingId ? "Edit node" : "Add node"}</h2>
          <form onSubmit={submit}>
            <div className="form-grid compact">
              <div className="field">
                <label>Name</label>
                <input
                  required
                  placeholder="main-pacs"
                  value={draft.name}
                  onChange={(e) => setDraft({ ...draft, name: e.target.value })}
                />
              </div>
              <div className="field">
                <label>AE title</label>
                <input
                  required
                  placeholder="PACS01"
                  maxLength={16}
                  value={draft.ae_title}
                  onChange={(e) => setDraft({ ...draft, ae_title: e.target.value })}
                />
              </div>
              <div className="field">
                <label>Host</label>
                <input
                  required
                  placeholder="192.168.0.10"
                  value={draft.host}
                  onChange={(e) => setDraft({ ...draft, host: e.target.value })}
                />
              </div>
              <div className="field">
                <label>Port</label>
                <input
                  required
                  type="number"
                  min={1}
                  max={65535}
                  value={draft.port}
                  onChange={(e) => setDraft({ ...draft, port: Number(e.target.value) })}
                />
              </div>
              <div className="field">
                <label>Move destination</label>
                <input
                  placeholder="Defaults to local AE"
                  value={draft.move_destination ?? ""}
                  onChange={(e) =>
                    setDraft({ ...draft, move_destination: e.target.value || null })
                  }
                />
              </div>
              <div className="field">
                <label>Notes</label>
                <input
                  placeholder="Reading room PACS"
                  value={draft.notes ?? ""}
                  onChange={(e) => setDraft({ ...draft, notes: e.target.value || null })}
                />
              </div>
            </div>
            {validation.length > 0 && (
              <div className="inline-hints">
                {validation.map((hint) => (
                  <span key={hint}>{hint}</span>
                ))}
              </div>
            )}
            <div className="toolbar" style={{ marginTop: 14 }}>
              <button type="submit" className="btn primary" disabled={!canSubmit}>
                {editingId ? <Edit3 size={15} /> : <Plus size={15} />}
                {editingId ? "Save changes" : "Add node"}
              </button>
              {editingId && (
                <button type="button" className="btn ghost" onClick={reset}>
                  <RotateCcw size={15} />
                  Cancel
                </button>
              )}
            </div>
          </form>
        </section>

        <aside className="card">
          <h2>Node summary</h2>
          <div className="metric-list">
            <div className="counter-row">
              <span>Total nodes</span>
              <strong>{nodes.length}</strong>
            </div>
            <div className="counter-row">
              <span>With move destination</span>
              <strong>{nodes.filter((node) => !!node.preferred_move_destination).length}</strong>
            </div>
            <div className="counter-row">
              <span>Default port 104</span>
              <strong>{nodes.filter((node) => node.port === 104).length}</strong>
            </div>
          </div>
        </aside>
      </div>

      <div className="card" style={{ marginTop: 14 }}>
        <h2>Configured nodes</h2>
        <div className="table-wrap">
          <table>
            <thead>
              <tr>
                <th>Name</th>
                <th>AE Title</th>
                <th>Endpoint</th>
                <th>Move dest.</th>
                <th>Notes</th>
                <th>Updated</th>
                <th />
              </tr>
            </thead>
            <tbody>
              {nodes.length === 0 && (
                <tr>
                  <td colSpan={7} className="empty">
                    No remote nodes yet.
                  </td>
                </tr>
              )}
              {nodes.map((node) => (
                <tr key={node.id} className={editingId === node.id ? "selected-row" : ""}>
                  <td style={{ fontWeight: 600 }}>{node.name}</td>
                  <td className="mono">{node.ae_title}</td>
                  <td className="mono">{node.host}:{node.port}</td>
                  <td className="mono dim">{node.preferred_move_destination ?? "—"}</td>
                  <td className="dim">{node.notes ?? "—"}</td>
                  <td className="dim">{new Date(node.updated_at).toLocaleString()}</td>
                  <td style={{ whiteSpace: "nowrap", textAlign: "right" }}>
                    <button className="icon-btn" title="Edit node" onClick={() => startEdit(node)}>
                      <Edit3 size={15} />
                    </button>{" "}
                    <button className="icon-btn danger" title="Delete node" onClick={() => remove(node)}>
                      <Trash2 size={15} />
                    </button>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>
    </>
  );
}

function validateDraft(draft: NodeDraft): string[] {
  const hints: string[] = [];
  if (!draft.name.trim()) hints.push("Name is required.");
  if (!draft.ae_title.trim()) hints.push("AE title is required.");
  if (draft.ae_title.length > 16) hints.push("AE title must be 16 characters or fewer.");
  if (!draft.host.trim()) hints.push("Host is required.");
  if (!Number.isInteger(draft.port) || draft.port < 1 || draft.port > 65535) {
    hints.push("Port must be 1-65535.");
  }
  return hints;
}
