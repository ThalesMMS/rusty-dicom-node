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
import { LocaleToggle, useI18n } from "./i18n";
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

const NAV: { id: View; labelKey: string; icon: LucideIcon }[] = [
  { id: "dashboard", labelKey: "desktop-nav-dashboard", icon: LayoutDashboard },
  { id: "query", labelKey: "desktop-nav-query", icon: Search },
  { id: "archive", labelKey: "desktop-nav-archive", icon: Database },
  { id: "import", labelKey: "desktop-nav-import", icon: HardDriveDownload },
  { id: "nodes", labelKey: "desktop-nav-nodes", icon: Network },
  { id: "server", labelKey: "desktop-nav-server", icon: ServerIcon },
  { id: "logs", labelKey: "desktop-nav-logs", icon: FileText },
];

export default function App() {
  const { t } = useI18n();
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
            <div className="brand-title">{t("desktop-brand-title")}</div>
            <div className="brand-sub">{status?.local_ae_title ?? "…"}</div>
          </div>
        </div>
        <nav className="nav">
          {NAV.filter((item) => !networkNav.has(item.id)).map((item) => (
            <NavButton
              key={item.id}
              icon={item.icon}
              label={t(item.labelKey)}
              active={view === item.id}
              onClick={() => setView(item.id)}
            />
          ))}
          <div className="nav-label">{t("desktop-nav-network")}</div>
          {NAV.filter((item) => networkNav.has(item.id)).map((item) => (
            <NavButton
              key={item.id}
              icon={item.icon}
              label={t(item.labelKey)}
              active={view === item.id}
              onClick={() => setView(item.id)}
            />
          ))}
        </nav>
        <div className="sidebar-footer">
          <span>
            <span className={`status-dot${status?.server_running ? " on" : ""}`} />
            {status?.server_running
              ? t("desktop-scp-listening")
              : t("desktop-scp-stopped")}
          </span>
          <span>{status?.listener_addr ?? ""}</span>
          <LocaleToggle />
        </div>
      </aside>
      <main className="main">
        <header className="operator-strip" onMouseDown={startWindowDrag}>
          <div className="operator-status">
            <span className={`status-dot${status?.server_running ? " on" : ""}`} />
            <strong>{status?.local_ae_title ?? t("desktop-status-loading")}</strong>
            <span>{status?.listener_addr ?? "…"}</span>
            <span className="strip-muted">
              {t("desktop-strip-pdu", { value: status?.max_pdu_length ?? "…" })}
            </span>
          </div>
          <div className="strip-drag-spacer" data-tauri-drag-region />
          <div className="operator-actions">
            <button className="icon-btn" title={t("desktop-action-refresh-status")} onClick={refreshStatus}>
              <RefreshCw size={16} />
            </button>
            <button
              className="icon-btn"
              title={t("desktop-action-reveal-log")}
              onClick={revealLog}
              disabled={!status?.active_log_file}
            >
              <FileText size={16} />
            </button>
            <button className="btn sm" onClick={() => setView("query")}>
              <Search size={15} />
              {t("desktop-action-query")}
            </button>
            <button className="btn sm" onClick={() => setView("import")}>
              <Download size={15} />
              {t("desktop-action-import")}
            </button>
            <button className="btn sm" onClick={() => setView("archive")}>
              <Upload size={15} />
              {t("desktop-action-send")}
            </button>
            <button className="btn sm" onClick={() => setActivityOpen((open) => !open)}>
              <Activity size={15} />
              {activity.length > 0
                ? t("desktop-action-activity", { count: activity.length })
                : t("desktop-action-activity-empty")}
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
  icon: Icon,
  label,
  active,
  onClick,
}: {
  icon: LucideIcon;
  label: string;
  active: boolean;
  onClick: () => void;
}) {
  return (
    <button className={`nav-item${active ? " active" : ""}`} onClick={onClick}>
      <Icon size={17} />
      {label}
    </button>
  );
}

function ActivityPanel({ entries }: { entries: ActivityEntry[] }) {
  const { t, locale } = useI18n();
  return (
    <aside className="activity-panel">
      <div className="panel-heading">
        <Activity size={16} />
        <h2>{t("desktop-activity-title")}</h2>
      </div>
      {entries.length === 0 ? (
        <div className="empty small">{t("desktop-activity-empty")}</div>
      ) : (
        <div className="activity-list">
          {entries.map((entry) => (
            <div key={entry.id} className={`activity-item ${entry.tone ?? "info"}`}>
              <div className="activity-time">{new Date(entry.at).toLocaleTimeString(locale)}</div>
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
