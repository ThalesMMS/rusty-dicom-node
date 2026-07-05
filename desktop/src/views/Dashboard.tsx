import { useEffect, useState } from "react";
import { formatBytes, getServerMetrics, listNodes, localStudies } from "../api";
import type { RemoteNode, ServerMetrics, Status, StudySummary } from "../types";

interface Props {
  status: Status | null;
  onNavigate: (view: string) => void;
}

export default function Dashboard({ status, onNavigate }: Props) {
  const [studies, setStudies] = useState<StudySummary[] | null>(null);
  const [nodes, setNodes] = useState<RemoteNode[] | null>(null);
  const [metrics, setMetrics] = useState<ServerMetrics | null>(null);

  useEffect(() => {
    localStudies().then(setStudies).catch(console.error);
    listNodes().then(setNodes).catch(console.error);
    getServerMetrics().then(setMetrics).catch(console.error);
  }, []);

  const instanceCount = studies?.reduce((acc, s) => acc + s.instance_count, 0) ?? null;

  return (
    <>
      <div className="page-header">
        <h1>Dashboard</h1>
        <p>Local archive overview and node status.</p>
      </div>

      <div className="grid cols-4">
        <div className="stat">
          <div className="label">Studies</div>
          <div className="value accent">{studies?.length ?? "—"}</div>
        </div>
        <div className="stat">
          <div className="label">Instances</div>
          <div className="value">{instanceCount ?? "—"}</div>
        </div>
        <div className="stat">
          <div className="label">Remote nodes</div>
          <div className="value">{nodes?.length ?? "—"}</div>
        </div>
        <div className="stat">
          <div className="label">Ingested (session)</div>
          <div className="value">
            {metrics ? formatBytes(metrics.archive_ingest_bytes_total) : "—"}
          </div>
        </div>
      </div>

      <div className="grid cols-2" style={{ marginTop: 16 }}>
        <div className="card">
          <h2>Local node</h2>
          {status ? (
            <dl className="kv">
              <dt>AE title</dt>
              <dd>{status.local_ae_title}</dd>
              <dt>Listener</dt>
              <dd>{status.listener_addr}</dd>
              <dt>Max PDU</dt>
              <dd>{status.max_pdu_length}</dd>
              <dt>Strict PDU</dt>
              <dd>{status.strict_pdu ? "yes" : "no"}</dd>
              <dt>Promiscuous storage</dt>
              <dd>{status.allow_promiscuous_storage ? "enabled" : "disabled"}</dd>
              <dt>Store transfer syntax</dt>
              <dd>{status.preferred_store_transfer_syntax}</dd>
              <dt>Config</dt>
              <dd>{status.config_path}</dd>
              <dt>Data dir</dt>
              <dd>{status.data_dir}</dd>
              <dt>Logs</dt>
              <dd>{status.log_dir}</dd>
            </dl>
          ) : (
            <div className="empty">Loading…</div>
          )}
        </div>

        <div className="card">
          <h2>Quick actions</h2>
          <div style={{ display: "flex", flexDirection: "column", gap: 10 }}>
            <button className="btn" onClick={() => onNavigate("query")}>
              Query a remote node (C-FIND)
            </button>
            <button className="btn" onClick={() => onNavigate("import")}>
              Import DICOM files from disk
            </button>
            <button className="btn" onClick={() => onNavigate("archive")}>
              Browse the local archive
            </button>
            <button className="btn" onClick={() => onNavigate("server")}>
              {status?.server_running ? "Storage server is running" : "Start the storage server"}
            </button>
          </div>
          {nodes !== null && nodes.length === 0 && (
            <div className="alert info" style={{ marginTop: 14, marginBottom: 0 }}>
              No remote nodes configured yet — add one in{" "}
              <a
                style={{ color: "inherit", fontWeight: 600, cursor: "pointer" }}
                onClick={() => onNavigate("nodes")}
              >
                Remote Nodes
              </a>{" "}
              to start querying.
            </div>
          )}
        </div>
      </div>
    </>
  );
}
