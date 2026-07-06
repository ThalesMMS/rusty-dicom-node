import { useEffect, useMemo, useState } from "react";
import { Archive as ArchiveIcon, Database, Download, Network, Search, Server, Upload } from "lucide-react";
import type { LucideIcon } from "lucide-react";
import { formatBytes, formatDicomDate, formatPersonName, getServerMetrics, listNodes, localStudies } from "../api";
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
          <h1>Operator Dashboard</h1>
          <p>Local archive, network peers, and SCP activity at a glance.</p>
        </div>
        <div className="header-actions">
          <button className="btn" onClick={() => onNavigate("query")}>
            <Search size={15} />
            Query
          </button>
          <button className="btn" onClick={() => onNavigate("import")}>
            <Download size={15} />
            Import
          </button>
        </div>
      </div>

      <div className="grid cols-4">
        <Metric label="Studies" value={studies?.length ?? "—"} icon={Database} accent />
        <Metric label="Series" value={seriesCount ?? "—"} icon={Upload} />
        <Metric label="Instances" value={instanceCount ?? "—"} icon={ArchiveIcon} />
        <Metric label="Remote nodes" value={nodes?.length ?? "—"} icon={Network} />
      </div>

      <div className="grid cols-3" style={{ marginTop: 14 }}>
        <div className="card action-card" onClick={() => onNavigate("archive")}>
          <Database size={18} />
          <div>
            <h3>Inspect Local Archive</h3>
            <p>Review studies, drill into series and instances, then send or export.</p>
          </div>
        </div>
        <div className="card action-card" onClick={() => onNavigate("nodes")}>
          <Network size={18} />
          <div>
            <h3>Manage Peers</h3>
            <p>Add and edit PACS or workstation nodes used by query, retrieve, and store.</p>
          </div>
        </div>
        <div className="card action-card" onClick={() => onNavigate("server")}>
          <Server size={18} />
          <div>
            <h3>{status?.server_running ? "Monitor Storage SCP" : "Start Storage SCP"}</h3>
            <p>{status?.listener_addr ?? "Listener not loaded yet."}</p>
          </div>
        </div>
      </div>

      <div className="grid cols-2" style={{ marginTop: 14 }}>
        <div className="card">
          <h2>Local node</h2>
          {status ? (
            <dl className="kv dense">
              <dt>AE title</dt>
              <dd>{status.local_ae_title}</dd>
              <dt>Listener</dt>
              <dd>{status.listener_addr}</dd>
              <dt>Server</dt>
              <dd>{status.server_running ? "listening" : "stopped"}</dd>
              <dt>Max PDU</dt>
              <dd>{status.max_pdu_length}</dd>
              <dt>Strict PDU</dt>
              <dd>{status.strict_pdu ? "yes" : "no"}</dd>
              <dt>Promiscuous storage</dt>
              <dd>{status.allow_promiscuous_storage ? "enabled" : "disabled"}</dd>
              <dt>Store syntax</dt>
              <dd>{status.preferred_store_transfer_syntax}</dd>
              <dt>Data dir</dt>
              <dd>{status.data_dir}</dd>
              <dt>Log file</dt>
              <dd>{status.active_log_file}</dd>
            </dl>
          ) : (
            <div className="empty small">Loading local status…</div>
          )}
        </div>

        <div className="card">
          <h2>Live counters</h2>
          {metrics ? (
            <div className="metric-list">
              <Counter label="C-STORE stored" value={metrics.c_store_stored_total} />
              <Counter label="C-STORE failed" value={metrics.c_store_failed_total} tone="danger" />
              <Counter label="C-FIND requests" value={metrics.c_find_requests_total} />
              <Counter label="C-MOVE requests" value={metrics.c_move_requests_total} />
              <Counter label="Bytes ingested" value={formatBytes(metrics.archive_ingest_bytes_total)} />
              <Counter label="Associations accepted" value={metrics.server_associations_accepted_total} />
            </div>
          ) : (
            <div className="empty small">Loading metrics…</div>
          )}
        </div>
      </div>

      <div className="card" style={{ marginTop: 14 }}>
        <h2>Recent studies</h2>
        <div className="table-wrap">
          <table>
            <thead>
              <tr>
                <th>Patient</th>
                <th>Patient ID</th>
                <th>Date</th>
                <th>Description</th>
                <th>Modalities</th>
                <th className="num">Series</th>
                <th className="num">Instances</th>
              </tr>
            </thead>
            <tbody>
              {recentStudies.length === 0 && (
                <tr>
                  <td colSpan={7} className="empty">
                    {studies === null ? "Loading studies…" : "No local studies yet."}
                  </td>
                </tr>
              )}
              {recentStudies.map((study) => (
                <tr key={study.study_instance_uid}>
                  <td>{formatPersonName(study.patient_name)}</td>
                  <td className="mono">{study.patient_id ?? "—"}</td>
                  <td className="mono">{formatDicomDate(study.study_date)}</td>
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
