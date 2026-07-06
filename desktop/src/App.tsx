import { useEffect, useMemo, useState } from "react";
import type { MouseEvent } from "react";
import {
  Activity,
  Database,
  Download,
  FileText,
  HardDriveDownload,
  LayoutDashboard,
  Network,
  RefreshCw,
  Search,
  Server as ServerIcon,
  Upload,
} from "lucide-react";
import type { LucideIcon } from "lucide-react";
import { getCurrentWindow } from "@tauri-apps/api/window";
import { revealItemInDir } from "@tauri-apps/plugin-opener";
import { getStatus } from "./api";
import type { ActivityEntry, Status } from "./types";
import Dashboard from "./views/Dashboard";
import Query from "./views/Query";
import Archive from "./views/Archive";
import Nodes from "./views/Nodes";
import ImportView from "./views/Import";
import Server from "./views/Server";
import Logs from "./views/Logs";

type View = "dashboard" | "query" | "archive" | "nodes" | "import" | "server" | "logs";

type ActivityInput = Omit<ActivityEntry, "id" | "at">;

const NAV: { id: View; label: string; icon: LucideIcon }[] = [
  { id: "dashboard", label: "Dashboard", icon: LayoutDashboard },
  { id: "query", label: "Query / Retrieve", icon: Search },
  { id: "archive", label: "Local Archive", icon: Database },
  { id: "import", label: "Import", icon: HardDriveDownload },
  { id: "nodes", label: "Remote Nodes", icon: Network },
  { id: "server", label: "Storage Server", icon: ServerIcon },
  { id: "logs", label: "Logs", icon: FileText },
];

export default function App() {
  const [view, setView] = useState<View>("dashboard");
  const [status, setStatus] = useState<Status | null>(null);
  const [activityOpen, setActivityOpen] = useState(false);
  const [activity, setActivity] = useState<ActivityEntry[]>([]);

  const addActivity = (entry: ActivityInput) => {
    setActivity((prev) => [
      {
        ...entry,
        id: globalThis.crypto?.randomUUID?.() ?? `${Date.now()}-${Math.random()}`,
        at: new Date().toISOString(),
      },
      ...prev,
    ].slice(0, 50));
  };

  const refreshStatus = () => {
    getStatus().then(setStatus).catch(console.error);
  };

  useEffect(() => {
    refreshStatus();
    const timer = setInterval(refreshStatus, 5000);
    return () => clearInterval(timer);
  }, []);

  const networkNav = useMemo(() => new Set<View>(["nodes", "server", "logs"]), []);

  const revealLog = () => {
    if (status?.active_log_file) {
      revealItemInDir(status.active_log_file).catch(console.error);
    }
  };

  const startWindowDrag = (event: MouseEvent<HTMLElement>) => {
    if (event.button !== 0 || event.detail !== 1) return;
    const target = event.target as HTMLElement | null;
    if (target?.closest("button, input, select, textarea, a, label, summary")) return;

    event.preventDefault();
    event.stopPropagation();
    getCurrentWindow().startDragging().catch(console.error);
  };

  return (
    <div className="app">
      <div className="titlebar" data-tauri-drag-region onMouseDown={startWindowDrag} />
      <aside className="sidebar">
        <div className="brand">
          <div className="brand-mark">Dx</div>
          <div>
            <div className="brand-title">DICOM Node</div>
            <div className="brand-sub">{status?.local_ae_title ?? "…"}</div>
          </div>
        </div>
        <nav className="nav">
          {NAV.filter((item) => !networkNav.has(item.id)).map((item) => (
            <NavButton key={item.id} item={item} active={view === item.id} onClick={() => setView(item.id)} />
          ))}
          <div className="nav-label">Network</div>
          {NAV.filter((item) => networkNav.has(item.id)).map((item) => (
            <NavButton key={item.id} item={item} active={view === item.id} onClick={() => setView(item.id)} />
          ))}
        </nav>
        <div className="sidebar-footer">
          <span>
            <span className={`status-dot${status?.server_running ? " on" : ""}`} />
            SCP {status?.server_running ? "listening" : "stopped"}
          </span>
          <span>{status?.listener_addr ?? ""}</span>
        </div>
      </aside>
      <main className="main">
        <header className="operator-strip" onMouseDown={startWindowDrag}>
          <div className="operator-status">
            <span className={`status-dot${status?.server_running ? " on" : ""}`} />
            <strong>{status?.local_ae_title ?? "Loading"}</strong>
            <span>{status?.listener_addr ?? "…"}</span>
            <span className="strip-muted">PDU {status?.max_pdu_length ?? "…"}</span>
          </div>
          <div className="strip-drag-spacer" data-tauri-drag-region />
          <div className="operator-actions">
            <button className="icon-btn" title="Refresh status" onClick={refreshStatus}>
              <RefreshCw size={16} />
            </button>
            <button className="icon-btn" title="Reveal log file" onClick={revealLog} disabled={!status?.active_log_file}>
              <FileText size={16} />
            </button>
            <button className="btn sm" onClick={() => setView("query")}>
              <Search size={15} />
              Query
            </button>
            <button className="btn sm" onClick={() => setView("import")}>
              <Download size={15} />
              Import
            </button>
            <button className="btn sm" onClick={() => setView("archive")}>
              <Upload size={15} />
              Send
            </button>
            <button className="btn sm" onClick={() => setActivityOpen((open) => !open)}>
              <Activity size={15} />
              Activity {activity.length > 0 ? activity.length : ""}
            </button>
          </div>
        </header>
        <div className="content-shell">
          <section className="page">
            <div className="view-anim" key={view}>
              {view === "dashboard" && (
                <Dashboard status={status} onNavigate={(v) => setView(v as View)} />
              )}
              {view === "query" && <Query onActivity={addActivity} />}
              {view === "archive" && <Archive onActivity={addActivity} />}
              {view === "nodes" && <Nodes />}
              {view === "import" && <ImportView onActivity={addActivity} />}
              {view === "server" && (
                <Server
                  status={status}
                  onStatusChange={refreshStatus}
                  onNavigate={(v) => setView(v as View)}
                  onActivity={addActivity}
                />
              )}
              {view === "logs" && <Logs status={status} onActivity={addActivity} />}
            </div>
          </section>
          {activityOpen && <ActivityPanel entries={activity} />}
        </div>
      </main>
    </div>
  );
}

function NavButton({
  item,
  active,
  onClick,
}: {
  item: (typeof NAV)[number];
  active: boolean;
  onClick: () => void;
}) {
  const Icon = item.icon;
  return (
    <button className={`nav-item${active ? " active" : ""}`} onClick={onClick}>
      <Icon size={17} />
      {item.label}
    </button>
  );
}

function ActivityPanel({ entries }: { entries: ActivityEntry[] }) {
  return (
    <aside className="activity-panel">
      <div className="panel-heading">
        <Activity size={16} />
        <h2>Activity</h2>
      </div>
      {entries.length === 0 ? (
        <div className="empty small">No session activity yet.</div>
      ) : (
        <div className="activity-list">
          {entries.map((entry) => (
            <div key={entry.id} className={`activity-item ${entry.tone ?? "info"}`}>
              <div className="activity-time">{new Date(entry.at).toLocaleTimeString()}</div>
              <div>
                <div className="activity-title">{entry.title}</div>
                {entry.detail && <div className="activity-detail">{entry.detail}</div>}
              </div>
            </div>
          ))}
        </div>
      )}
    </aside>
  );
}
