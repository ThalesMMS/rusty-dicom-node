import { useEffect, useMemo, useState } from "react";
import { Archive as ArchiveIcon, Database, Download, Network, Search, Server, Upload } from "lucide-react";
import type { LucideIcon } from "lucide-react";
import { formatBytes, formatDicomDate, formatPersonName, getServerMetrics, listNodes, localStudies } from "../api";
import { useI18n } from "../i18n";
import type { RemoteNode, ServerMetrics, Status, StudySummary } from "../types";

interface Props {
  status: Status | null;
  onNavigate: (view: string) => void;
}

export default function Dashboard({ status, onNavigate }: Props) {
  const { t, locale } = useI18n();
  const [studies, setStudies] = useState<StudySummary[] | null>(null);
  const [nodes, setNodes] = useState<RemoteNode[] | null>(null);
  const [metrics, setMetrics] = useState<ServerMetrics | null>(null);

  useEffect(() => {
    const load = () => {
      localStudies().then(setStudies).catch(console.error);
      listNodes().then(setNodes).catch(console.error);
      getServerMetrics().then(setMetrics).catch(console.error);
    };
    load();
    const timer = setInterval(load, 5000);
    return () => clearInterval(timer);
  }, []);

  const instanceCount = studies?.reduce((acc, s) => acc + s.instance_count, 0) ?? null;
  const seriesCount = studies?.reduce((acc, s) => acc + s.series_count, 0) ?? null;
  const recentStudies = useMemo(() => {
    return [...(studies ?? [])]
      .sort((a, b) => (b.study_date ?? "").localeCompare(a.study_date ?? ""))
      .slice(0, 6);
  }, [studies]);

  return (
    <>
      <div className="page-header compact">
        <div>
          <h1>{t("desktop-dashboard-title")}</h1>
          <p>{t("desktop-dashboard-subtitle")}</p>
        </div>
        <div className="header-actions">
          <button className="btn" onClick={() => onNavigate("query")}>
            <Search size={15} />
            {t("desktop-action-query")}
          </button>
          <button className="btn" onClick={() => onNavigate("import")}>
            <Download size={15} />
            {t("desktop-action-import")}
          </button>
        </div>
      </div>

      <div className="grid cols-4">
        <Metric
          label={t("desktop-dashboard-metric-studies")}
          value={studies == null ? "—" : t("count-studies", { n: studies.length })}
          icon={Database}
          accent
        />
        <Metric
          label={t("desktop-dashboard-metric-series")}
          value={seriesCount == null ? "—" : t("count-series", { n: seriesCount })}
          icon={Upload}
        />
        <Metric
          label={t("desktop-dashboard-metric-instances")}
          value={instanceCount == null ? "—" : t("count-instances", { n: instanceCount })}
          icon={ArchiveIcon}
        />
        <Metric
          label={t("desktop-dashboard-metric-nodes")}
          value={nodes == null ? "—" : t("count-nodes", { n: nodes.length })}
          icon={Network}
        />
      </div>

      <div className="grid cols-3" style={{ marginTop: 14 }}>
        <div className="card action-card" onClick={() => onNavigate("archive")}>
          <Database size={18} />
          <div>
            <h3>{t("desktop-dashboard-inspect-archive-title")}</h3>
            <p>{t("desktop-dashboard-inspect-archive-body")}</p>
          </div>
        </div>
        <div className="card action-card" onClick={() => onNavigate("nodes")}>
          <Network size={18} />
          <div>
            <h3>{t("desktop-dashboard-manage-peers-title")}</h3>
            <p>{t("desktop-dashboard-manage-peers-body")}</p>
          </div>
        </div>
        <div className="card action-card" onClick={() => onNavigate("server")}>
          <Server size={18} />
          <div>
            <h3>
              {status?.server_running
                ? t("desktop-dashboard-monitor-scp")
                : t("desktop-dashboard-start-scp")}
            </h3>
            <p>{status?.listener_addr ?? t("desktop-dashboard-listener-missing")}</p>
          </div>
        </div>
      </div>

      <div className="grid cols-2" style={{ marginTop: 14 }}>
        <div className="card">
          <h2>{t("desktop-dashboard-local-node")}</h2>
          {status ? (
            <dl className="kv dense">
              <dt>{t("desktop-dashboard-kv-ae-title")}</dt>
              <dd>{status.local_ae_title}</dd>
              <dt>{t("desktop-dashboard-kv-listener")}</dt>
              <dd>{status.listener_addr}</dd>
              <dt>{t("desktop-dashboard-kv-server")}</dt>
              <dd>
                {status.server_running
                  ? t("desktop-status-listening")
                  : t("desktop-status-stopped")}
              </dd>
              <dt>{t("desktop-dashboard-kv-max-pdu")}</dt>
              <dd>{status.max_pdu_length}</dd>
              <dt>{t("desktop-dashboard-kv-strict-pdu")}</dt>
              <dd>{status.strict_pdu ? t("desktop-common-yes") : t("desktop-common-no")}</dd>
              <dt>{t("desktop-dashboard-kv-promiscuous")}</dt>
              <dd>
                {status.allow_promiscuous_storage
                  ? t("desktop-common-enabled")
                  : t("desktop-common-disabled")}
              </dd>
              <dt>{t("desktop-dashboard-kv-store-syntax")}</dt>
              <dd>{status.preferred_store_transfer_syntax}</dd>
              <dt>{t("desktop-dashboard-kv-data-dir")}</dt>
              <dd>{status.data_dir}</dd>
              <dt>{t("desktop-dashboard-kv-log-file")}</dt>
              <dd>{status.active_log_file}</dd>
            </dl>
          ) : (
            <div className="empty small">{t("desktop-dashboard-loading-status")}</div>
          )}
        </div>

        <div className="card">
          <h2>{t("desktop-dashboard-live-counters")}</h2>
          {metrics ? (
            <div className="metric-list">
              <Counter label={t("desktop-dashboard-counter-c-store-stored")} value={metrics.c_store_stored_total} />
              <Counter
                label={t("desktop-dashboard-counter-c-store-failed")}
                value={metrics.c_store_failed_total}
                tone="danger"
              />
              <Counter label={t("desktop-dashboard-counter-c-find-requests")} value={metrics.c_find_requests_total} />
              <Counter label={t("desktop-dashboard-counter-c-move-requests")} value={metrics.c_move_requests_total} />
              <Counter
                label={t("desktop-dashboard-counter-bytes-ingested")}
                value={formatBytes(metrics.archive_ingest_bytes_total)}
              />
              <Counter
                label={t("desktop-dashboard-counter-assoc-accepted")}
                value={metrics.server_associations_accepted_total}
              />
            </div>
          ) : (
            <div className="empty small">{t("desktop-dashboard-loading-metrics")}</div>
          )}
        </div>
      </div>

      <div className="card" style={{ marginTop: 14 }}>
        <h2>{t("desktop-dashboard-recent-studies")}</h2>
        <div className="table-wrap">
          <table>
            <thead>
              <tr>
                <th>{t("desktop-table-patient")}</th>
                <th>{t("desktop-table-patient-id")}</th>
                <th>{t("desktop-table-date")}</th>
                <th>{t("desktop-table-description")}</th>
                <th>{t("desktop-table-modalities")}</th>
                <th className="num">{t("desktop-table-series")}</th>
                <th className="num">{t("desktop-table-instances")}</th>
              </tr>
            </thead>
            <tbody>
              {recentStudies.length === 0 && (
                <tr>
                  <td colSpan={7} className="empty">
                    {studies === null
                      ? t("desktop-dashboard-loading-studies")
                      : t("desktop-dashboard-empty-studies")}
                  </td>
                </tr>
              )}
              {recentStudies.map((study) => (
                <tr key={study.study_instance_uid}>
                  <td>{formatPersonName(study.patient_name)}</td>
                  <td className="mono">{study.patient_id ?? "—"}</td>
                  <td className="mono">{formatDicomDate(study.study_date, locale)}</td>
                  <td className="dim">{study.study_description ?? "—"}</td>
                  <td>{modalityPills(study.modalities)}</td>
                  <td className="num">{study.series_count}</td>
                  <td className="num">{study.instance_count}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>
    </>
  );
}

function Metric({
  label,
  value,
  icon: Icon,
  accent = false,
}: {
  label: string;
  value: string | number;
  icon: LucideIcon;
  accent?: boolean;
}) {
  return (
    <div className="stat">
      <div className="stat-top">
        <span className="label">{label}</span>
        <Icon size={16} />
      </div>
      <div className={`value${accent ? " accent" : ""}`}>{value}</div>
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

function modalityPills(value: string | null) {
  const modalities = (value ?? "").split(/[\\,]/).map((m) => m.trim()).filter(Boolean);
  if (modalities.length === 0) return "—";
  return modalities.map((m) => (
    <span key={m} className="pill accent" style={{ marginRight: 4 }}>
      {m}
    </span>
  ));
}
