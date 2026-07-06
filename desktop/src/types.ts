// Mirrors of the Rust serde models (snake_case, serde defaults).

export type QueryModel = "PatientRoot" | "StudyRoot";
export type QueryLevel = "Patient" | "Study" | "Series" | "Image";
export type ArchiveExportScope = "studies" | "series";
export type ArchiveExportFormat = "json" | "csv";

export interface RemoteNode {
  id: string;
  name: string;
  ae_title: string;
  host: string;
  port: number;
  preferred_move_destination: string | null;
  notes: string | null;
  created_at: string;
  updated_at: string;
}

export interface NodeDraft {
  name: string;
  ae_title: string;
  host: string;
  port: number;
  move_destination: string | null;
  notes: string | null;
}

export interface QueryCriteria {
  model: QueryModel;
  level: QueryLevel;
  patient_name?: string | null;
  patient_id?: string | null;
  accession_number?: string | null;
  study_instance_uid?: string | null;
  series_instance_uid?: string | null;
  sop_instance_uid?: string | null;
  study_date_from?: string | null;
  study_date_to?: string | null;
  modality?: string | null;
  study_description?: string | null;
}

export interface QueryMatch {
  level: QueryLevel;
  patient_name: string | null;
  patient_id: string | null;
  accession_number: string | null;
  study_instance_uid: string | null;
  series_instance_uid: string | null;
  sop_instance_uid: string | null;
  study_date: string | null;
  study_description: string | null;
  series_description: string | null;
  series_number: string | null;
  modality: string | null;
  instance_number: string | null;
}

export interface MoveRequest {
  node_name_or_id: string;
  model: QueryModel;
  level: QueryLevel;
  study_instance_uid: string;
  series_instance_uid: string | null;
  sop_instance_uid: string | null;
  move_destination: string | null;
}

export interface MoveOutcome {
  final_status: number;
  remaining: number;
  completed: number;
  failed: number;
  warning: number;
  started_at: string;
  finished_at: string;
}

export interface SendOutcome {
  attempted: number;
  sent: number;
  failed: number;
  failures: string[];
}

export interface ScpSessionReport {
  received: number;
  stored: number;
  failed: number;
}

export interface StudySummary {
  study_instance_uid: string;
  patient_name: string | null;
  patient_id: string | null;
  study_date: string | null;
  study_description: string | null;
  modalities: string | null;
  series_count: number;
  instance_count: number;
}

export interface SeriesSummary {
  study_instance_uid: string;
  series_instance_uid: string;
  modality: string | null;
  series_number: string | null;
  series_description: string | null;
  instance_count: number;
}

export interface LocalInstance {
  study_instance_uid: string;
  series_instance_uid: string;
  sop_instance_uid: string;
  sop_class_uid: string;
  transfer_syntax_uid: string | null;
  modality: string | null;
  instance_number: string | null;
  file_size_bytes: number;
  managed_path: string;
  imported_at: string;
}

export interface ImportReport {
  scanned_files: number;
  accepted: number;
  duplicates: number;
  duplicate_by_sop_instance_uid: number;
  duplicate_by_sha256: number;
  unreadable: number;
  invalid_dicom: number;
  failures: string[];
  stored_bytes: number;
  skipped: number;
  failed_cleanup: number;
}

export interface ImportProgress {
  task_id: string;
  processed: number;
  total: number | null;
}

export interface Status {
  local_ae_title: string;
  listener_addr: string;
  max_pdu_length: number;
  strict_pdu: boolean;
  allow_promiscuous_storage: boolean;
  preferred_store_transfer_syntax: string;
  config_path: string;
  data_dir: string;
  log_dir: string;
  active_log_file: string;
  server_running: boolean;
}

export interface ServerMetrics {
  server_associations_accepted_total: number;
  server_associations_rejected_total: number;
  c_store_received_total: number;
  c_store_stored_total: number;
  c_store_failed_total: number;
  c_find_requests_total: number;
  c_find_matches_total: number;
  c_move_requests_total: number;
  c_move_suboperations_completed_total: number;
  c_move_suboperations_failed_total: number;
  c_get_requests_total: number;
  archive_ingest_bytes_total: number;
}

export interface LogTailResult {
  path: string;
  exists: boolean;
  lines: string[];
  truncated: boolean;
}

export interface ArchiveExportResult {
  path: string;
  rows: number;
  scope: ArchiveExportScope;
  format: ArchiveExportFormat;
}

export interface ActivityEntry {
  id: string;
  at: string;
  kind: "query" | "retrieve" | "import" | "send" | "export" | "server" | "log";
  title: string;
  detail?: string;
  tone?: "info" | "success" | "warning" | "error";
}
