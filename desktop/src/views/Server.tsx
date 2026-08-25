import { useEffect, useMemo, useRef, useState } from "react";
import { FileText, Play, Square } from "lucide-react";
import { formatBytes, getServerMetrics, startServer, stopServer } from "../api";
import { useI18n } from "../i18n";
import type { ActivityEntry, ScpSessionReport, ServerMetrics, Status } from "../types";

interface Props {
  status: Status | null;
  onStatusChange: () => void;
  onNavigate: (view: string) => void;
  onActivity: (entry: Omit<ActivityEntry, "id" | "at">) => void;
}

export default function Server({ status, onStatusChange, onNavigate, onActivity }: Props) {
  const { t } = useI18n();
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
    if (!metrics) return t("desktop-server-health-loading");
    if (metrics.server_associations_rejected_total > 0 || metrics.c_store_failed_total > 0) {
      return t("desktop-server-health-review");
    }
    return running ? t("desktop-server-health-ready") : t("desktop-server-health-stopped");
  }, [metrics, running, t]);

  const toggle = async () => {
    setBusy(true);
    setError(null);
    try {
      if (running) {
        const report = await stopServer();
        setLastReport(report);
        onActivity({
          kind: "server",
          title: t("desktop-server-activity-stopped"),
          detail: report
            ? t("desktop-server-activity-stopped-detail", {
                received: report.received,
                stored: report.stored,
                failed: report.failed,
              })
            : t("desktop-server-activity-stopped-empty"),
          tone: report && report.failed > 0 ? "warning" : "info",
        });
      } else {
        setLastReport(null);
        await startServer();
        onActivity({
          kind: "server",
          title: t("desktop-server-activity-started"),
          detail: status?.listener_addr ?? t("desktop-server-activity-started-detail"),
          tone: "success",
        });
      }
      onStatusChange();
    } catch (e) {
      const message = String(e);
      setError(message);
      onActivity({ kind: "server", title: t("desktop-server-activity-fail"), detail: message, tone: "error" });
    } finally {
      setBusy(false);
    }
  };

  return (
    <>
      <div className="page-header compact">
        <div>
          <h1>{t("desktop-server-title")}</h1>
          <p>{t("desktop-server-subtitle")}</p>
        </div>
        <div className="header-actions">
          <button className="btn" onClick={() => onNavigate("logs")}>
            <FileText size={15} />
            {t("desktop-server-logs")}
          </button>
          <button className={`btn ${running ? "danger" : "primary"}`} onClick={toggle} disabled={busy}>
            {busy ? <span className="spinner" /> : running ? <Square size={15} /> : <Play size={15} />}
            {running ? t("desktop-server-stop") : t("desktop-server-start")}
          </button>
        </div>
      </div>

      {error && <div className="alert error">{error}</div>}
      {lastReport && (
        <div className="alert info">
          {t("desktop-server-session-ended", {
            received: lastReport.received,
            stored: lastReport.stored,
            failed: lastReport.failed,
          })}
        </div>
      )}

      <div className="card status-card">
        <div>
          <span className={`pill ${running ? "ok" : ""}`}>
            {running ? t("desktop-server-listening") : t("desktop-server-stopped-pill")}
          </span>
          <h2 style={{ marginTop: 10, marginBottom: 0 }}>{health}</h2>
          <p className="muted" style={{ marginTop: 6 }}>
            {t("desktop-server-addr-ae", {
              addr: status?.listener_addr ?? "…",
              ae: status?.local_ae_title ?? "…",
            })}
          </p>
        </div>
        <dl className="kv dense">
          <dt>{t("desktop-dashboard-kv-strict-pdu")}</dt>
          <dd>{status?.strict_pdu ? t("desktop-common-yes") : t("desktop-common-no")}</dd>
          <dt>{t("desktop-dashboard-kv-promiscuous")}</dt>
          <dd>
            {status?.allow_promiscuous_storage
              ? t("desktop-common-enabled")
              : t("desktop-common-disabled")}
          </dd>
          <dt>{t("desktop-dashboard-kv-log-file")}</dt>
          <dd>{status?.active_log_file ?? "—"}</dd>
        </dl>
      </div>

      <div className="grid cols-4" style={{ marginTop: 14 }}>
        <Metric
          label={t("desktop-server-stored")}
          value={metrics?.c_store_stored_total ?? "—"}
          rate={rates.stored}
          rateLabel={t("desktop-server-rate", { rate: rates.stored })}
          accent
        />
        <Metric
          label={t("desktop-server-failed")}
          value={metrics?.c_store_failed_total ?? "—"}
          rate={rates.failed}
          rateLabel={t("desktop-server-rate", { rate: rates.failed })}
          danger
        />
        <Metric
          label={t("desktop-server-assoc-accepted")}
          value={metrics?.server_associations_accepted_total ?? "—"}
          rate={rates.associations}
          rateLabel={t("desktop-server-rate", { rate: rates.associations })}
        />
        <Metric
          label={t("desktop-server-assoc-rejected")}
          value={metrics?.server_associations_rejected_total ?? "—"}
          danger
        />
      </div>

      <div className="card" style={{ marginTop: 14 }}>
        <h2>{t("desktop-server-dimse")}</h2>
        {metrics ? (
          <div className="metric-list two-col">
            <Counter label={t("desktop-server-counter-received")} value={metrics.c_store_received_total} />
            <Counter label={t("desktop-server-counter-stored")} value={metrics.c_store_stored_total} />
            <Counter
              label={t("desktop-server-counter-failed")}
              value={metrics.c_store_failed_total}
              tone="danger"
            />
            <Counter
              label={t("desktop-server-counter-find")}
              value={`${metrics.c_find_requests_total} / ${metrics.c_find_matches_total}`}
            />
            <Counter label={t("desktop-server-counter-move")} value={metrics.c_move_requests_total} />
            <Counter
              label={t("desktop-server-counter-move-sub")}
              value={`${metrics.c_move_suboperations_completed_total} / ${metrics.c_move_suboperations_failed_total}`}
            />
            <Counter label={t("desktop-server-counter-get")} value={metrics.c_get_requests_total} />
            <Counter
              label={t("desktop-server-counter-bytes")}
              value={formatBytes(metrics.archive_ingest_bytes_total)}
            />
          </div>
        ) : (
          <div className="empty small">{t("desktop-server-loading-metrics")}</div>
        )}
      </div>
    </>
  );
}

function Metric({
  label,
  value,
  rate,
  rateLabel,
  accent = false,
  danger = false,
}: {
  label: string;
  value: string | number;
  rate?: number;
  rateLabel?: string;
  accent?: boolean;
  danger?: boolean;
}) {
  return (
    <div className="stat">
      <div className="label">{label}</div>
      <div className={`value${accent ? " accent" : ""}${danger ? " danger-text" : ""}`}>{value}</div>
      {rate !== undefined && <div className="stat-foot">{rateLabel}</div>}
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
