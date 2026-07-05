import { useEffect, useState } from "react";
import { formatBytes, getServerMetrics, startServer, stopServer } from "../api";
import type { ScpSessionReport, ServerMetrics, Status } from "../types";

interface Props {
  status: Status | null;
  onStatusChange: () => void;
}

export default function Server({ status, onStatusChange }: Props) {
  const [metrics, setMetrics] = useState<ServerMetrics | null>(null);
  const [busy, setBusy] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [lastReport, setLastReport] = useState<ScpSessionReport | null>(null);

  const running = status?.server_running ?? false;

  useEffect(() => {
    const poll = () => getServerMetrics().then(setMetrics).catch(console.error);
    poll();
    const timer = setInterval(poll, 2000);
    return () => clearInterval(timer);
  }, []);

  const toggle = async () => {
    setBusy(true);
    setError(null);
    try {
      if (running) {
        const report = await stopServer();
        setLastReport(report);
      } else {
        setLastReport(null);
        await startServer();
      }
      onStatusChange();
    } catch (e) {
      setError(String(e));
    } finally {
      setBusy(false);
    }
  };

  return (
    <>
      <div className="page-header">
        <h1>Storage Server</h1>
        <p>Standalone storage SCP — accepts C-STORE from configured peers and indexes received instances.</p>
      </div>

      {error && <div className="alert error">{error}</div>}
      {lastReport && (
        <div className="alert info">
          Session ended — received {lastReport.received}, stored {lastReport.stored}, failed{" "}
          {lastReport.failed}.
        </div>
      )}

      <div className="card">
        <div className="toolbar">
          <span className={`pill ${running ? "ok" : ""}`} style={{ fontSize: 12 }}>
            {running ? "LISTENING" : "STOPPED"}
          </span>
          <span className="mono" style={{ color: "var(--text-dim)" }}>
            {status?.listener_addr ?? "…"}
          </span>
          <span className="mono" style={{ color: "var(--text-faint)" }}>
            AE {status?.local_ae_title ?? "…"}
          </span>
          <div className="spacer" />
          <button className={`btn ${running ? "danger" : "primary"}`} onClick={toggle} disabled={busy}>
            {busy && <span className="spinner" />}
            {running ? "Stop server" : "Start server"}
          </button>
        </div>
      </div>

      <div className="card">
        <h2>Session metrics</h2>
        {metrics ? (
          <>
            <div className="grid cols-4">
              <div className="stat">
                <div className="label">Assoc. accepted</div>
                <div className="value">{metrics.server_associations_accepted_total}</div>
              </div>
              <div className="stat">
                <div className="label">Assoc. rejected</div>
                <div className="value">{metrics.server_associations_rejected_total}</div>
              </div>
              <div className="stat">
                <div className="label">C-STORE stored</div>
                <div className="value accent">{metrics.c_store_stored_total}</div>
              </div>
              <div className="stat">
                <div className="label">C-STORE failed</div>
                <div className="value">{metrics.c_store_failed_total}</div>
              </div>
            </div>
            <dl className="kv" style={{ marginTop: 16 }}>
              <dt>C-STORE received</dt>
              <dd>{metrics.c_store_received_total}</dd>
              <dt>C-FIND requests / matches</dt>
              <dd>
                {metrics.c_find_requests_total} / {metrics.c_find_matches_total}
              </dd>
              <dt>C-MOVE requests</dt>
              <dd>{metrics.c_move_requests_total}</dd>
              <dt>C-MOVE sub-ops completed / failed</dt>
              <dd>
                {metrics.c_move_suboperations_completed_total} /{" "}
                {metrics.c_move_suboperations_failed_total}
              </dd>
              <dt>C-GET requests</dt>
              <dd>{metrics.c_get_requests_total}</dd>
              <dt>Bytes ingested</dt>
              <dd>{formatBytes(metrics.archive_ingest_bytes_total)}</dd>
            </dl>
          </>
        ) : (
          <div className="empty">Loading metrics…</div>
        )}
      </div>
    </>
  );
}
