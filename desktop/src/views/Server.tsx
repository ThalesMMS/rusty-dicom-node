import { useEffect, useMemo, useRef, useState } from "react";
import { FileText, Play, Square } from "lucide-react";
import { formatBytes, getServerMetrics, startServer, stopServer } from "../api";
import type { ActivityEntry, ScpSessionReport, ServerMetrics, Status } from "../types";

interface Props {
  status: Status | null;
  onStatusChange: () => void;
  onNavigate: (view: string) => void;
  onActivity: (entry: Omit<ActivityEntry, "id" | "at">) => void;
}

export default function Server({ status, onStatusChange, onNavigate, onActivity }: Props) {
  const [metrics, setMetrics] = useState<ServerMetrics | null>(null);
  const [busy, setBusy] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [lastReport, setLastReport] = useState<ScpSessionReport | null>(null);
  const previousMetrics = useRef<ServerMetrics | null>(null);
  const [rates, setRates] = useState({ stored: 0, failed: 0, associations: 0 });

  const running = status?.server_running ?? false;

  useEffect(() => {
    const poll = async () => {
      const next = await getServerMetrics();
      const prev = previousMetrics.current;
      if (prev) {
        setRates({
          stored: Math.max(0, next.c_store_stored_total - prev.c_store_stored_total),
          failed: Math.max(0, next.c_store_failed_total - prev.c_store_failed_total),
          associations: Math.max(
            0,
            next.server_associations_accepted_total - prev.server_associations_accepted_total,
          ),
        });
      }
      previousMetrics.current = next;
      setMetrics(next);
    };
    poll().catch(console.error);
    const timer = setInterval(() => poll().catch(console.error), 2000);
    return () => clearInterval(timer);
  }, []);

  const health = useMemo(() => {
    if (!metrics) return "Loading metrics";
    if (metrics.server_associations_rejected_total > 0 || metrics.c_store_failed_total > 0) {
      return "Review failures";
    }
    return running ? "Ready for inbound C-STORE" : "Stopped";
  }, [metrics, running]);

  const toggle = async () => {
    setBusy(true);
    setError(null);
    try {
      if (running) {
        const report = await stopServer();
        setLastReport(report);
        onActivity({
          kind: "server",
          title: "Storage SCP stopped",
          detail: report ? `received=${report.received}, stored=${report.stored}, failed=${report.failed}` : "No active session.",
          tone: report && report.failed > 0 ? "warning" : "info",
        });
      } else {
        setLastReport(null);
        await startServer();
        onActivity({
          kind: "server",
          title: "Storage SCP started",
          detail: status?.listener_addr ?? "Listener started.",
          tone: "success",
        });
      }
      onStatusChange();
    } catch (e) {
      const message = String(e);
      setError(message);
      onActivity({ kind: "server", title: "Storage SCP control failed", detail: message, tone: "error" });
    } finally {
      setBusy(false);
    }
  };

  return (
    <>
      <div className="page-header compact">
        <div>
          <h1>Storage Server</h1>
          <p>Standalone storage SCP for inbound C-STORE and local archive indexing.</p>
        </div>
        <div className="header-actions">
          <button className="btn" onClick={() => onNavigate("logs")}>
            <FileText size={15} />
            Logs
          </button>
          <button className={`btn ${running ? "danger" : "primary"}`} onClick={toggle} disabled={busy}>
            {busy ? <span className="spinner" /> : running ? <Square size={15} /> : <Play size={15} />}
            {running ? "Stop server" : "Start server"}
          </button>
        </div>
      </div>

      {error && <div className="alert error">{error}</div>}
      {lastReport && (
        <div className="alert info">
          Session ended: received {lastReport.received}, stored {lastReport.stored}, failed {lastReport.failed}.
        </div>
      )}

      <div className="card status-card">
        <div>
          <span className={`pill ${running ? "ok" : ""}`}>{running ? "LISTENING" : "STOPPED"}</span>
          <h2 style={{ marginTop: 10, marginBottom: 0 }}>{health}</h2>
          <p className="muted" style={{ marginTop: 6 }}>
            {status?.listener_addr ?? "…"} · AE {status?.local_ae_title ?? "…"}
          </p>
        </div>
        <dl className="kv dense">
          <dt>Strict PDU</dt>
          <dd>{status?.strict_pdu ? "yes" : "no"}</dd>
          <dt>Promiscuous storage</dt>
          <dd>{status?.allow_promiscuous_storage ? "enabled" : "disabled"}</dd>
          <dt>Log file</dt>
          <dd>{status?.active_log_file ?? "—"}</dd>
        </dl>
      </div>

      <div className="grid cols-4" style={{ marginTop: 14 }}>
        <Metric label="Stored" value={metrics?.c_store_stored_total ?? "—"} rate={rates.stored} accent />
        <Metric label="Failed" value={metrics?.c_store_failed_total ?? "—"} rate={rates.failed} danger />
        <Metric label="Accepted associations" value={metrics?.server_associations_accepted_total ?? "—"} rate={rates.associations} />
        <Metric label="Rejected associations" value={metrics?.server_associations_rejected_total ?? "—"} danger />
      </div>

      <div className="card" style={{ marginTop: 14 }}>
        <h2>DIMSE counters</h2>
        {metrics ? (
          <div className="metric-list two-col">
            <Counter label="C-STORE received" value={metrics.c_store_received_total} />
            <Counter label="C-STORE stored" value={metrics.c_store_stored_total} />
            <Counter label="C-STORE failed" value={metrics.c_store_failed_total} tone="danger" />
            <Counter label="C-FIND requests / matches" value={`${metrics.c_find_requests_total} / ${metrics.c_find_matches_total}`} />
            <Counter label="C-MOVE requests" value={metrics.c_move_requests_total} />
            <Counter
              label="C-MOVE sub-ops completed / failed"
              value={`${metrics.c_move_suboperations_completed_total} / ${metrics.c_move_suboperations_failed_total}`}
            />
            <Counter label="C-GET requests" value={metrics.c_get_requests_total} />
            <Counter label="Bytes ingested" value={formatBytes(metrics.archive_ingest_bytes_total)} />
          </div>
        ) : (
          <div className="empty small">Loading metrics…</div>
        )}
      </div>
    </>
  );
}

function Metric({
  label,
  value,
  rate,
  accent = false,
  danger = false,
}: {
  label: string;
  value: string | number;
  rate?: number;
  accent?: boolean;
  danger?: boolean;
}) {
  return (
    <div className="stat">
      <div className="label">{label}</div>
      <div className={`value${accent ? " accent" : ""}${danger ? " danger-text" : ""}`}>{value}</div>
      {rate !== undefined && <div className="stat-foot">+{rate} / poll</div>}
    </div>
  );
}

function Counter({ label, value, tone }: { label: string; value: string | number; tone?: "danger" }) {
  return (
    <div className="counter-row">
      <span>{label}</span>
      <strong className={tone === "danger" ? "danger-text" : ""}>{value}</strong>
    </div>
  );
}
