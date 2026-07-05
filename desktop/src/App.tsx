import { useEffect, useState } from "react";
import { getStatus } from "./api";
import type { Status } from "./types";
import Dashboard from "./views/Dashboard";
import Query from "./views/Query";
import Archive from "./views/Archive";
import Nodes from "./views/Nodes";
import ImportView from "./views/Import";
import Server from "./views/Server";

type View = "dashboard" | "query" | "archive" | "nodes" | "import" | "server";

const NAV: { id: View; label: string; icon: JSX.Element }[] = [
  {
    id: "dashboard",
    label: "Dashboard",
    icon: (
      <svg className="icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
        <rect x="3" y="3" width="7" height="9" rx="1.5" />
        <rect x="14" y="3" width="7" height="5" rx="1.5" />
        <rect x="14" y="12" width="7" height="9" rx="1.5" />
        <rect x="3" y="16" width="7" height="5" rx="1.5" />
      </svg>
    ),
  },
  {
    id: "query",
    label: "Query / Retrieve",
    icon: (
      <svg className="icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
        <circle cx="11" cy="11" r="7" />
        <path d="m21 21-4.3-4.3" strokeLinecap="round" />
      </svg>
    ),
  },
  {
    id: "archive",
    label: "Local Archive",
    icon: (
      <svg className="icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
        <ellipse cx="12" cy="5" rx="8" ry="3" />
        <path d="M4 5v14c0 1.66 3.58 3 8 3s8-1.34 8-3V5" />
        <path d="M4 12c0 1.66 3.58 3 8 3s8-1.34 8-3" />
      </svg>
    ),
  },
  {
    id: "nodes",
    label: "Remote Nodes",
    icon: (
      <svg className="icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
        <circle cx="5" cy="12" r="2.5" />
        <circle cx="19" cy="5" r="2.5" />
        <circle cx="19" cy="19" r="2.5" />
        <path d="M7.3 10.8 16.7 6.2M7.3 13.2l9.4 4.6" />
      </svg>
    ),
  },
  {
    id: "import",
    label: "Import",
    icon: (
      <svg className="icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
        <path d="M12 3v12m0 0 4-4m-4 4-4-4" strokeLinecap="round" strokeLinejoin="round" />
        <path d="M4 17v2a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2v-2" strokeLinecap="round" />
      </svg>
    ),
  },
  {
    id: "server",
    label: "Storage Server",
    icon: (
      <svg className="icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2">
        <rect x="3" y="4" width="18" height="7" rx="1.5" />
        <rect x="3" y="13" width="18" height="7" rx="1.5" />
        <path d="M7 7.5h.01M7 16.5h.01" strokeLinecap="round" />
      </svg>
    ),
  },
];

export default function App() {
  const [view, setView] = useState<View>("dashboard");
  const [status, setStatus] = useState<Status | null>(null);

  const refreshStatus = () => {
    getStatus().then(setStatus).catch(console.error);
  };

  useEffect(() => {
    refreshStatus();
    const timer = setInterval(refreshStatus, 5000);
    return () => clearInterval(timer);
  }, []);

  return (
    <div className="app">
      <div className="titlebar" data-tauri-drag-region />
      <aside className="sidebar">
        <div className="brand">
          <div className="brand-mark">Dx</div>
          <div>
            <div className="brand-title">DICOM Node</div>
            <div className="brand-sub">{status?.local_ae_title ?? "…"}</div>
          </div>
        </div>
        <nav className="nav">
          {NAV.filter((i) => ["dashboard", "query", "archive", "import"].includes(i.id)).map(
            (item) => (
              <button
                key={item.id}
                className={`nav-item${view === item.id ? " active" : ""}`}
                onClick={() => setView(item.id)}
              >
                {item.icon}
                {item.label}
              </button>
            ),
          )}
          <div className="nav-label">Network</div>
          {NAV.filter((i) => ["nodes", "server"].includes(i.id)).map((item) => (
            <button
              key={item.id}
              className={`nav-item${view === item.id ? " active" : ""}`}
              onClick={() => setView(item.id)}
            >
              {item.icon}
              {item.label}
            </button>
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
        <div className="page">
          <div className="view-anim" key={view}>
            {view === "dashboard" && <Dashboard status={status} onNavigate={(v) => setView(v as View)} />}
            {view === "query" && <Query />}
            {view === "archive" && <Archive />}
            {view === "nodes" && <Nodes />}
            {view === "import" && <ImportView />}
            {view === "server" && <Server status={status} onStatusChange={refreshStatus} />}
          </div>
        </div>
      </main>
    </div>
  );
}
