import { FormEvent, useEffect, useState } from "react";
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
      <div className="page-header">
        <h1>Remote Nodes</h1>
        <p>PACS and workstation peers for query, retrieve, and store operations.</p>
      </div>

      {error && <div className="alert error">{error}</div>}
      {notice && <div className="alert success">{notice}</div>}

      <div className="card">
        <h2>{editingId ? "Edit node" : "Add node"}</h2>
        <form onSubmit={submit}>
          <div className="form-grid">
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
              <label>Move destination (optional)</label>
              <input
                placeholder="Defaults to local AE"
                value={draft.move_destination ?? ""}
                onChange={(e) =>
                  setDraft({ ...draft, move_destination: e.target.value || null })
                }
              />
            </div>
            <div className="field">
              <label>Notes (optional)</label>
              <input
                placeholder="Reading room PACS"
                value={draft.notes ?? ""}
                onChange={(e) => setDraft({ ...draft, notes: e.target.value || null })}
              />
            </div>
          </div>
          <div className="toolbar" style={{ marginTop: 14 }}>
            <button type="submit" className="btn primary" disabled={busy}>
              {editingId ? "Save changes" : "Add node"}
            </button>
            {editingId && (
              <button type="button" className="btn ghost" onClick={reset}>
                Cancel
              </button>
            )}
          </div>
        </form>
      </div>

      <div className="card">
        <h2>Configured nodes</h2>
        <div className="table-wrap">
          <table>
            <thead>
              <tr>
                <th>Name</th>
                <th>AE Title</th>
                <th>Host</th>
                <th className="num">Port</th>
                <th>Move dest.</th>
                <th>Notes</th>
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
                <tr key={node.id}>
                  <td style={{ fontWeight: 550 }}>{node.name}</td>
                  <td className="mono">{node.ae_title}</td>
                  <td className="mono">{node.host}</td>
                  <td className="num">{node.port}</td>
                  <td className="mono dim">{node.preferred_move_destination ?? "—"}</td>
                  <td className="dim">{node.notes ?? "—"}</td>
                  <td style={{ whiteSpace: "nowrap", textAlign: "right" }}>
                    <button className="btn sm ghost" onClick={() => startEdit(node)}>
                      Edit
                    </button>{" "}
                    <button className="btn sm danger" onClick={() => remove(node)}>
                      Delete
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
