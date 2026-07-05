import { invoke } from "@tauri-apps/api/core";
import { listen, UnlistenFn } from "@tauri-apps/api/event";
import type {
  ImportProgress,
  ImportReport,
  LocalInstance,
  MoveOutcome,
  MoveRequest,
  NodeDraft,
  QueryCriteria,
  QueryMatch,
  RemoteNode,
  ScpSessionReport,
  SendOutcome,
  SeriesSummary,
  ServerMetrics,
  Status,
  StudySummary,
} from "./types";

export const newTaskId = (): string =>
  globalThis.crypto?.randomUUID?.() ?? `${Date.now()}-${Math.random()}`;

export const getStatus = () => invoke<Status>("get_status");
export const getServerMetrics = () => invoke<ServerMetrics>("server_metrics");

export const listNodes = () => invoke<RemoteNode[]>("list_nodes");
export const addNode = (draft: NodeDraft) => invoke<RemoteNode>("add_node", { draft });
export const updateNode = (id: string, draft: NodeDraft) =>
  invoke<RemoteNode>("update_node", { id, draft });
export const deleteNode = (id: string) => invoke<number>("delete_node", { id });

export const runQuery = (taskId: string, node: string, criteria: QueryCriteria) =>
  invoke<QueryMatch[]>("query", { task_id: taskId, node, criteria });

export const runRetrieve = (taskId: string, request: MoveRequest) =>
  invoke<MoveOutcome>("retrieve", { task_id: taskId, request });

export const runImport = (taskId: string, path: string) =>
  invoke<ImportReport>("import_path", { task_id: taskId, path });

export const sendStudy = (taskId: string, studyUid: string, node: string) =>
  invoke<SendOutcome>("send_study", {
    task_id: taskId,
    study_instance_uid: studyUid,
    destination_node: node,
  });

export const sendSeries = (taskId: string, seriesUid: string, node: string) =>
  invoke<SendOutcome>("send_series", {
    task_id: taskId,
    series_instance_uid: seriesUid,
    destination_node: node,
  });

export const localStudies = () => invoke<StudySummary[]>("local_studies");
export const localSeries = (studyUid: string) =>
  invoke<SeriesSummary[]>("local_series", { study_instance_uid: studyUid });
export const localInstances = (seriesUid: string) =>
  invoke<LocalInstance[]>("local_instances", { series_instance_uid: seriesUid });

export const cancelTask = (taskId: string) =>
  invoke<boolean>("cancel_task", { task_id: taskId });

export const startServer = () => invoke<void>("start_server");
export const stopServer = () => invoke<ScpSessionReport | null>("stop_server");

export const onImportProgress = (
  handler: (progress: ImportProgress) => void,
): Promise<UnlistenFn> =>
  listen<ImportProgress>("import-progress", (event) => handler(event.payload));

export const formatBytes = (bytes: number): string => {
  if (!Number.isFinite(bytes) || bytes < 0) return "—";
  const units = ["B", "KB", "MB", "GB", "TB"];
  let value = bytes;
  let unit = 0;
  while (value >= 1024 && unit < units.length - 1) {
    value /= 1024;
    unit += 1;
  }
  return `${value >= 100 || unit === 0 ? Math.round(value) : value.toFixed(1)} ${units[unit]}`;
};

export const formatDicomDate = (value: string | null | undefined): string => {
  if (!value) return "—";
  const digits = value.replaceAll("-", "");
  if (/^\d{8}$/.test(digits)) {
    return `${digits.slice(0, 4)}-${digits.slice(4, 6)}-${digits.slice(6, 8)}`;
  }
  return value;
};

export const formatPersonName = (value: string | null | undefined): string => {
  if (!value) return "—";
  return value.replaceAll("^", " ").trim() || "—";
};
