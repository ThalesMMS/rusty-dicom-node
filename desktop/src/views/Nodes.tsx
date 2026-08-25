import { FormEvent, useEffect, useMemo, useState } from "react";
import { Edit3, Plus, RotateCcw, Trash2 } from "lucide-react";
import { addNode, deleteNode, listNodes, updateNode } from "../api";
import { useI18n } from "../i18n";
import type { Translate } from "../i18n";
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
  const { t, locale } = useI18n();
  const [nodes, setNodes] = useState<RemoteNode[]>([]);
  const [draft, setDraft] = useState<NodeDraft>(EMPTY);
  const [editingId, setEditingId] = useState<string | null>(null);
  const [error, setError] = useState<string | null>(null);
  const [notice, setNotice] = useState<string | null>(null);
  const [busy, setBusy] = useState(false);

  const validation = useMemo(() => validateDraft(draft, t), [draft, t]);
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
        setNotice(t("desktop-nodes-updated", { name: updated.name }));
      } else {
        const created = await addNode(draft);
        setNotice(t("desktop-nodes-added", { name: created.name }));
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
    if (!confirm(t("desktop-nodes-confirm-delete", { name: node.name }))) return;
    setError(null);
    setNotice(null);
    try {
      await deleteNode(node.id);
      if (editingId === node.id) reset();
      setNotice(t("desktop-nodes-deleted", { name: node.name }));
      await refresh();
    } catch (err) {
      setError(String(err));
    }
  };

  return (
    <>
      <div className="page-header compact">
        <div>
          <h1>{t("desktop-nodes-title")}</h1>
          <p>{t("desktop-nodes-subtitle")}</p>
        </div>
      </div>

      {error && <div className="alert error">{error}</div>}
      {notice && <div className="alert success">{notice}</div>}

      <div className="workspace-grid">
        <section className="card">
          <h2>{editingId ? t("desktop-nodes-edit") : t("desktop-nodes-add")}</h2>
          <form onSubmit={submit}>
            <div className="form-grid compact">
              <div className="field">
                <label>{t("desktop-nodes-name")}</label>
                <input
                  required
                  placeholder={t("desktop-nodes-placeholder-name")}
                  value={draft.name}
                  onChange={(e) => setDraft({ ...draft, name: e.target.value })}
                />
              </div>
              <div className="field">
                <label>{t("desktop-nodes-ae-title")}</label>
                <input
                  required
                  placeholder={t("desktop-nodes-placeholder-ae")}
                  maxLength={16}
                  value={draft.ae_title}
                  onChange={(e) => setDraft({ ...draft, ae_title: e.target.value })}
                />
              </div>
              <div className="field">
                <label>{t("desktop-nodes-host")}</label>
                <input
                  required
                  placeholder={t("desktop-nodes-placeholder-host")}
                  value={draft.host}
                  onChange={(e) => setDraft({ ...draft, host: e.target.value })}
                />
              </div>
              <div className="field">
                <label>{t("desktop-nodes-port")}</label>
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
                <label>{t("desktop-nodes-move-dest")}</label>
                <input
                  placeholder={t("desktop-nodes-placeholder-move")}
                  value={draft.move_destination ?? ""}
                  onChange={(e) =>
                    setDraft({ ...draft, move_destination: e.target.value || null })
                  }
                />
              </div>
              <div className="field">
                <label>{t("desktop-nodes-notes")}</label>
                <input
                  placeholder={t("desktop-nodes-placeholder-notes")}
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
                {editingId ? t("desktop-nodes-save") : t("desktop-nodes-add")}
              </button>
              {editingId && (
                <button type="button" className="btn ghost" onClick={reset}>
                  <RotateCcw size={15} />
                  {t("desktop-common-cancel")}
                </button>
              )}
            </div>
          </form>
        </section>

        <aside className="card">
          <h2>{t("desktop-nodes-summary")}</h2>
          <div className="metric-list">
            <div className="counter-row">
              <span>{t("count-nodes", { n: nodes.length })}</span>
            </div>
            <div className="counter-row">
              <span>{t("desktop-nodes-with-move")}</span>
              <strong>{nodes.filter((node) => !!node.preferred_move_destination).length}</strong>
            </div>
            <div className="counter-row">
              <span>{t("desktop-nodes-port-104")}</span>
              <strong>{nodes.filter((node) => node.port === 104).length}</strong>
            </div>
          </div>
        </aside>
      </div>

      <div className="card" style={{ marginTop: 14 }}>
        <h2>{t("desktop-nodes-configured")}</h2>
        <div className="table-wrap">
          <table>
            <thead>
              <tr>
                <th>{t("desktop-table-name")}</th>
                <th>{t("desktop-table-ae-title")}</th>
                <th>{t("desktop-table-endpoint")}</th>
                <th>{t("desktop-table-move-dest")}</th>
                <th>{t("desktop-table-notes")}</th>
                <th>{t("desktop-table-updated")}</th>
                <th />
              </tr>
            </thead>
            <tbody>
              {nodes.length === 0 && (
                <tr>
                  <td colSpan={7} className="empty">
                    {t("desktop-nodes-empty")}
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
                  <td className="dim">{new Date(node.updated_at).toLocaleString(locale)}</td>
                  <td style={{ whiteSpace: "nowrap", textAlign: "right" }}>
                    <button className="icon-btn" title={t("desktop-nodes-edit-title")} onClick={() => startEdit(node)}>
                      <Edit3 size={15} />
                    </button>{" "}
                    <button className="icon-btn danger" title={t("desktop-nodes-delete-title")} onClick={() => remove(node)}>
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

function validateDraft(draft: NodeDraft, t: Translate): string[] {
  const hints: string[] = [];
  if (!draft.name.trim()) hints.push(t("desktop-nodes-need-name"));
  if (!draft.ae_title.trim()) hints.push(t("desktop-nodes-need-ae"));
  if (draft.ae_title.length > 16) hints.push(t("desktop-nodes-ae-length"));
  if (!draft.host.trim()) hints.push(t("desktop-nodes-need-host"));
  if (!Number.isInteger(draft.port) || draft.port < 1 || draft.port > 65535) {
    hints.push(t("desktop-nodes-port-range"));
  }
  return hints;
}
