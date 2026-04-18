use std::path::Path;

use anyhow::anyhow;
use uuid::Uuid;

use crate::{
    config::{AppConfig, AppPaths, MigrationResult},
    db::Database,
    error::Result,
    importer::Importer,
    models::{
        normalize_node_name, parse_port, ImportReport, MoveOutcome, MoveRequest, QueryCriteria,
        QueryMatch, RemoteNode, RemoteNodeDraft, RemoteNodePatch, ScpSessionReport, SendOutcome,
        SeriesSummary, StudySummary,
    },
    net::{AssociationFactory, FindScu, MoveScu, StorageScpServer, StoreScu},
};

#[derive(Debug, Clone)]
pub struct AppServices {
    pub paths: AppPaths,
    pub config: AppConfig,
    pub db: Database,
    pub importer: Importer,
    pub find_scu: FindScu,
    pub move_scu: MoveScu,
    pub store_scu: StoreScu,
    pub storage_scp: StorageScpServer,
}

#[allow(dead_code)]
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum TuiReceiverMode {
    OnDemandForLocalRetrieve,
    StandaloneStorageScp,
}

impl TuiReceiverMode {
    pub fn description(self) -> &'static str {
        match self {
            TuiReceiverMode::OnDemandForLocalRetrieve => "on-demand for local retrieve",
            TuiReceiverMode::StandaloneStorageScp => "standalone via storage-scp",
        }
    }
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct TuiStatusSnapshot {
    pub local_ae_title: String,
    pub listener_addr: String,
    pub max_pdu_length: u32,
    pub strict_pdu: bool,
    pub allow_promiscuous_storage: bool,
    pub preferred_store_transfer_syntax: String,
    pub config_path: String,
    pub data_dir: String,
    pub log_dir: String,
    pub receiver_mode: String,
}

#[derive(Debug, Clone)]
pub struct NodeDraftValues {
    pub name: String,
    pub ae_title: String,
    pub host: String,
    pub port: u16,
    pub move_destination: Option<String>,
    pub notes: Option<String>,
}

#[derive(Debug, Clone)]
pub struct NodePatchCliValues {
    pub name: Option<String>,
    pub ae_title: Option<String>,
    pub host: Option<String>,
    pub port: Option<u16>,
    pub move_destination: Option<String>,
    pub notes: Option<String>,
}

pub fn build_tui_status_snapshot(
    paths: &AppPaths,
    config: &AppConfig,
    receiver_mode: TuiReceiverMode,
) -> TuiStatusSnapshot {
    TuiStatusSnapshot {
        local_ae_title: config.local_ae_title.clone(),
        listener_addr: config.storage_socket_addr(),
        max_pdu_length: config.max_pdu_length,
        strict_pdu: config.strict_pdu,
        allow_promiscuous_storage: config.allow_promiscuous_storage,
        preferred_store_transfer_syntax: config.preferred_store_transfer_syntax.to_string(),
        config_path: paths.config_json.display().to_string(),
        data_dir: paths.base_dir.display().to_string(),
        log_dir: paths.logs_dir.display().to_string(),
        receiver_mode: receiver_mode.description().to_string(),
    }
}

fn is_move_warning_status(status: u16) -> bool {
    (status & 0xF000) == 0xB000
}

fn validate_retrieve_outcome(
    outcome: &MoveOutcome,
    move_destination: &str,
    listener_addr: &str,
    scp_session_report: Option<&ScpSessionReport>,
) -> Result<()> {
    let scp_stats = format_scp_session_stats(scp_session_report);

    match outcome.final_status {
        0x0000 => {}
        0xFE00 => {
            return Err(anyhow!(
                "retrieve was canceled by the remote node (status=0x{:04X}, completed={}, failed={}, warning={}, remaining={}, {})",
                outcome.final_status,
                outcome.completed,
                outcome.failed,
                outcome.warning,
                outcome.remaining,
                scp_stats
            ));
        }
        status if is_move_warning_status(status) => {}
        _ => {
            return Err(anyhow!(
                "retrieve failed with status=0x{:04X} (completed={}, failed={}, warning={}, remaining={}, {})",
                outcome.final_status,
                outcome.completed,
                outcome.failed,
                outcome.warning,
                outcome.remaining,
                scp_stats
            ));
        }
    }

    if let Some(report) = scp_session_report {
        if outcome.completed > 0 && report.received == 0 {
            return Err(anyhow!(
                "retrieve finished for destination {} with completed={} but nothing arrived at the local storage SCP ({}). Check for AE mapping or port misconfiguration: ensure {} is free and that the remote node maps AE {} to this app",
                move_destination,
                outcome.completed,
                scp_stats,
                listener_addr,
                move_destination
            ));
        }
    }

    Ok(())
}

fn format_scp_session_stats(report: Option<&ScpSessionReport>) -> String {
    match report {
        Some(report) => format!(
            "scp_received={}, scp_stored={}, scp_failed={}",
            report.received, report.stored, report.failed
        ),
        None => "scp_session=not-started".to_string(),
    }
}

fn normalize_node_lookup(id_or_name: &str) -> String {
    let trimmed = id_or_name.trim();
    Uuid::parse_str(trimmed)
        .map(|uuid| uuid.to_string())
        .unwrap_or_else(|_| normalize_node_name(trimmed))
}

impl AppServices {
    pub fn load_from_paths(paths: AppPaths) -> Result<Self> {
        match paths.migrate_from_legacy()? {
            MigrationResult::MigrationPerformed {
                legacy_base_dir,
                new_base_dir,
            } => {
                let old_path = legacy_base_dir.display();
                let new_path = new_base_dir.display();
                tracing::info!("Migrated data from legacy location: {old_path} -> {new_path}");
            }
            MigrationResult::MigrationRepaired {
                legacy_base_dir,
                new_base_dir,
            } => {
                let old_path = legacy_base_dir.display();
                let new_path = new_base_dir.display();
                tracing::info!(
                    "Repaired incomplete legacy data migration: {old_path} -> {new_path}"
                );
            }
            MigrationResult::AlreadyMigrated { .. } => {
                tracing::debug!("Legacy data migration already complete, skipping migration");
            }
            MigrationResult::NoLegacyData => {}
        }
        paths.ensure()?;

        let config = AppConfig::load_or_create(&paths)?;
        let db = Database::open(&paths.sqlite_db)?;
        db.init()?;

        let importer = Importer::new(paths.clone(), config.clone(), db.clone());
        let assoc_factory = AssociationFactory::new(
            config.local_ae_title.clone(),
            config.max_pdu_length,
            config.strict_pdu,
        );

        let find_scu = FindScu::new(assoc_factory.clone());
        let move_scu = MoveScu::new(assoc_factory.clone());
        let store_scu = StoreScu::new(assoc_factory, config.preferred_store_transfer_syntax);
        let storage_scp = StorageScpServer::new(config.clone(), paths.clone(), db.clone());

        Ok(Self {
            paths,
            config,
            db,
            importer,
            find_scu,
            move_scu,
            store_scu,
            storage_scp,
        })
    }

    pub fn list_nodes(&self) -> Result<Vec<RemoteNode>> {
        self.db.list_remote_nodes()
    }

    pub fn get_node(&self, id_or_name: &str) -> Result<RemoteNode> {
        let lookup = normalize_node_lookup(id_or_name);
        self.db
            .get_remote_node(&lookup)?
            .ok_or_else(|| anyhow!("remote node not found: {}", id_or_name))
    }

    pub fn add_node(&self, draft: RemoteNodeDraft) -> Result<RemoteNode> {
        let node = draft.into_new_node()?;
        self.db.upsert_remote_node(&node)?;
        Ok(node)
    }

    pub fn update_node(&self, id_or_name: &str, patch: RemoteNodePatch) -> Result<RemoteNode> {
        let existing = self.get_node(id_or_name)?;
        let updated = patch.apply_to(existing)?;
        self.db.upsert_remote_node(&updated)?;
        Ok(updated)
    }

    pub fn delete_node(&self, id_or_name: &str) -> Result<usize> {
        let lookup = normalize_node_lookup(id_or_name);
        self.db.delete_remote_node(&lookup)
    }

    pub fn import_path(&self, path: &Path) -> Result<ImportReport> {
        self.importer.import_path(path)
    }

    pub fn query(
        &self,
        node_name_or_id: &str,
        criteria: &QueryCriteria,
    ) -> Result<Vec<QueryMatch>> {
        let node = self.get_node(node_name_or_id)?;
        self.find_scu.query(&node, criteria)
    }

    pub fn retrieve(&self, mut request: MoveRequest) -> Result<MoveOutcome> {
        let node = self.get_node(&request.node_name_or_id)?;

        let resolved_destination = request
            .move_destination
            .clone()
            .or_else(|| node.preferred_move_destination.clone())
            .unwrap_or_else(|| self.config.local_ae_title.clone());

        request.move_destination = Some(resolved_destination.clone());

        let retrieving_to_local_ae = resolved_destination == self.config.local_ae_title;

        let background_server = if retrieving_to_local_ae {
            Some(self.storage_scp.spawn_background()?)
        } else {
            None
        };

        let outcome = self.move_scu.retrieve(&node, &request);

        let scp_session_report = if let Some(handle) = background_server {
            Some(handle.stop()?)
        } else {
            None
        };

        let outcome = outcome?;

        validate_retrieve_outcome(
            &outcome,
            &resolved_destination,
            &self.config.storage_socket_addr(),
            scp_session_report.as_ref(),
        )?;

        Ok(outcome)
    }

    pub fn send_study(
        &self,
        study_instance_uid: &str,
        destination_node: &str,
    ) -> Result<SendOutcome> {
        let node = self.get_node(destination_node)?;
        let files = self.db.study_files(study_instance_uid)?;
        if files.is_empty() {
            return Err(anyhow!(
                "no local files indexed for study {}",
                study_instance_uid
            ));
        }
        self.store_scu.send_files(&node, &files)
    }

    pub fn send_series(
        &self,
        series_instance_uid: &str,
        destination_node: &str,
    ) -> Result<SendOutcome> {
        let node = self.get_node(destination_node)?;
        let files = self.db.series_files(series_instance_uid)?;
        if files.is_empty() {
            return Err(anyhow!(
                "no local files indexed for series {}",
                series_instance_uid
            ));
        }
        self.store_scu.send_files(&node, &files)
    }

    pub fn local_studies(&self) -> Result<Vec<StudySummary>> {
        self.db.list_studies()
    }

    pub fn local_series(&self, study_instance_uid: &str) -> Result<Vec<SeriesSummary>> {
        self.db.list_series_for_study(study_instance_uid)
    }

    pub fn run_storage_scp(&self) -> Result<()> {
        self.storage_scp.run_forever()
    }

    pub fn tui_status_snapshot(&self, receiver_mode: TuiReceiverMode) -> TuiStatusSnapshot {
        build_tui_status_snapshot(&self.paths, &self.config, receiver_mode)
    }

    pub fn node_draft_from_values(&self, values: NodeDraftValues) -> RemoteNodeDraft {
        let NodeDraftValues {
            name,
            ae_title,
            host,
            port,
            move_destination,
            notes,
        } = values;

        RemoteNodeDraft {
            name,
            ae_title,
            host,
            port,
            preferred_move_destination: move_destination,
            notes,
        }
    }

    pub fn node_patch_from_cli(&self, values: NodePatchCliValues) -> Result<RemoteNodePatch> {
        let NodePatchCliValues {
            name,
            ae_title,
            host,
            port,
            move_destination,
            notes,
        } = values;

        Ok(RemoteNodePatch {
            name,
            ae_title,
            host,
            port,
            preferred_move_destination: move_destination,
            notes,
        })
    }

    pub fn parse_port_kv(&self, value: &str) -> Result<u16> {
        parse_port(value)
    }
}

#[cfg(test)]
mod tests {
    use super::{
        build_tui_status_snapshot, validate_retrieve_outcome, AppServices, NodeDraftValues,
        NodePatchCliValues, TuiReceiverMode,
    };
    use crate::{
        config::{AppConfig, AppPaths, StoreTransferSyntaxPreference, RECOMMENDED_MAX_PDU_LENGTH},
        models::{MoveOutcome, RemoteNodeDraft, RemoteNodePatch, ScpSessionReport},
    };
    use std::path::PathBuf;

    fn sample_paths() -> AppPaths {
        AppPaths {
            base_dir: PathBuf::from("/tmp/rusty-dicom-node"),
            config_json: PathBuf::from("/tmp/rusty-dicom-node/config.json"),
            sqlite_db: PathBuf::from("/tmp/rusty-dicom-node/rusty-dicom-node.sqlite3"),
            managed_store_dir: PathBuf::from("/tmp/rusty-dicom-node/store"),
            logs_dir: PathBuf::from("/tmp/rusty-dicom-node/logs"),
        }
    }

    fn scp_report(received: u32, stored: u32, failed: u32) -> ScpSessionReport {
        ScpSessionReport {
            received,
            stored,
            failed,
        }
    }

    fn temp_services() -> (tempfile::TempDir, AppServices) {
        let temp_dir = tempfile::tempdir().expect("create temp dir");
        let base_dir = temp_dir.path().join("app");
        let paths = AppPaths {
            base_dir: base_dir.clone(),
            config_json: base_dir.join("config.json"),
            sqlite_db: base_dir.join("rusty-dicom-node.sqlite3"),
            managed_store_dir: base_dir.join("store"),
            logs_dir: base_dir.join("logs"),
        };
        let services = AppServices::load_from_paths(paths).expect("load services");
        (temp_dir, services)
    }

    #[test]
    fn node_service_normalizes_non_uuid_lookup_targets() {
        let (_temp_dir, services) = temp_services();
        let node = services
            .add_node(RemoteNodeDraft {
                name: "PACS".to_string(),
                ae_title: "pacs".to_string(),
                host: "127.0.0.1".to_string(),
                port: 104,
                preferred_move_destination: None,
                notes: None,
            })
            .expect("add node");

        assert_eq!(node.name, "pacs");
        assert_eq!(node.ae_title, "PACS");
        assert_eq!(
            services.get_node("PACS").expect("lookup by name").id,
            node.id
        );
        assert_eq!(
            services
                .get_node(&node.id.to_uppercase())
                .expect("lookup by canonicalized UUID")
                .id,
            node.id
        );

        let updated = services
            .update_node(
                "PACS",
                RemoteNodePatch {
                    host: Some("10.0.0.10".to_string()),
                    ..RemoteNodePatch::default()
                },
            )
            .expect("update by normalized name");
        assert_eq!(updated.host, "10.0.0.10");

        assert_eq!(services.delete_node("PACS").expect("delete by name"), 1);
        assert_eq!(
            services.get_node("PACS").unwrap_err().to_string(),
            "remote node not found: PACS"
        );
    }

    #[test]
    fn node_add_cli_path_persists_normalized_values() {
        let (_temp_dir, services) = temp_services();
        let draft = services.node_draft_from_values(NodeDraftValues {
            name: "  PACS  ".to_string(),
            ae_title: " pacs1 ".to_string(),
            host: " 127.0.0.1 ".to_string(),
            port: 104,
            move_destination: None,
            notes: None,
        });

        let node = services.add_node(draft).expect("add node");

        assert_eq!(node.name, "pacs");
        assert_eq!(node.ae_title, "PACS1");
        assert_eq!(node.host, "127.0.0.1");

        let stored = services
            .db
            .get_remote_node(&node.id)
            .expect("read stored node")
            .expect("stored node exists");
        assert_eq!(stored.name, "pacs");
        assert_eq!(stored.ae_title, "PACS1");
    }

    #[test]
    fn node_edit_cli_path_normalizes_patch_before_persisting() {
        let (_temp_dir, services) = temp_services();
        services
            .add_node(RemoteNodeDraft {
                name: "pacs".to_string(),
                ae_title: "PACS".to_string(),
                host: "127.0.0.1".to_string(),
                port: 104,
                preferred_move_destination: None,
                notes: None,
            })
            .expect("add node");
        let patch = services
            .node_patch_from_cli(NodePatchCliValues {
                name: Some("  Archive  ".to_string()),
                ae_title: Some(" archive1 ".to_string()),
                host: None,
                port: None,
                move_destination: None,
                notes: None,
            })
            .expect("build patch");

        let node = services.update_node("PACS", patch).expect("update node");

        assert_eq!(node.name, "archive");
        assert_eq!(node.ae_title, "ARCHIVE1");
        assert_eq!(
            services
                .get_node("ARCHIVE")
                .expect("lookup normalized edit")
                .id,
            node.id
        );
    }

    #[test]
    fn status_snapshot_uses_default_config_values() {
        let paths = sample_paths();
        let config = AppConfig::default();

        let snapshot =
            build_tui_status_snapshot(&paths, &config, TuiReceiverMode::OnDemandForLocalRetrieve);

        assert_eq!(snapshot.local_ae_title, "DICOMNODECLIENT");
        assert_eq!(snapshot.listener_addr, "0.0.0.0:11112");
        assert_eq!(snapshot.max_pdu_length, RECOMMENDED_MAX_PDU_LENGTH);
        assert!(snapshot.strict_pdu);
        assert!(!snapshot.allow_promiscuous_storage);
        assert_eq!(
            snapshot.preferred_store_transfer_syntax,
            "JPEG 2000 Lossless"
        );
        assert_eq!(snapshot.receiver_mode, "on-demand for local retrieve");
        assert_eq!(snapshot.config_path, "/tmp/rusty-dicom-node/config.json");
        assert_eq!(snapshot.data_dir, "/tmp/rusty-dicom-node");
        assert_eq!(snapshot.log_dir, "/tmp/rusty-dicom-node/logs");
    }

    #[test]
    fn status_snapshot_reflects_non_default_config_values() {
        let paths = sample_paths();
        let config = AppConfig {
            local_ae_title: "ARCHIVE_AE".to_string(),
            storage_bind_addr: "127.0.0.1".to_string(),
            storage_scp_port: 4104,
            max_pdu_length: 32_768,
            strict_pdu: false,
            allow_promiscuous_storage: true,
            preferred_store_transfer_syntax: StoreTransferSyntaxPreference::ExplicitVrLittleEndian,
            ..AppConfig::default()
        };

        let snapshot =
            build_tui_status_snapshot(&paths, &config, TuiReceiverMode::StandaloneStorageScp);

        assert_eq!(snapshot.local_ae_title, "ARCHIVE_AE");
        assert_eq!(snapshot.listener_addr, "127.0.0.1:4104");
        assert_eq!(snapshot.max_pdu_length, 32_768);
        assert!(!snapshot.strict_pdu);
        assert!(snapshot.allow_promiscuous_storage);
        assert_eq!(
            snapshot.preferred_store_transfer_syntax,
            "Explicit VR Little Endian"
        );
        assert_eq!(snapshot.receiver_mode, "standalone via storage-scp");
    }

    #[test]
    fn retrieve_validation_accepts_successful_first_ingest() {
        let outcome = MoveOutcome {
            final_status: 0x0000,
            completed: 5,
            ..MoveOutcome::default()
        };

        validate_retrieve_outcome(
            &outcome,
            "DICOMNODECLIENT",
            "0.0.0.0:11112",
            Some(&scp_report(5, 5, 0)),
        )
        .expect("retrieve should succeed when received objects are stored");
    }

    #[test]
    fn retrieve_validation_accepts_successful_duplicate_ingest() {
        let outcome = MoveOutcome {
            final_status: 0x0000,
            completed: 5,
            ..MoveOutcome::default()
        };

        validate_retrieve_outcome(
            &outcome,
            "DICOMNODECLIENT",
            "0.0.0.0:11112",
            Some(&scp_report(5, 0, 0)),
        )
        .expect("retrieve should succeed when duplicate objects arrived at the SCP");
    }

    #[test]
    fn retrieve_validation_rejects_success_without_scp_receipts() {
        let outcome = MoveOutcome {
            final_status: 0x0000,
            completed: 5,
            ..MoveOutcome::default()
        };

        let err = validate_retrieve_outcome(
            &outcome,
            "DICOMNODECLIENT",
            "0.0.0.0:11112",
            Some(&scp_report(0, 0, 0)),
        )
        .unwrap_err();

        let message = err.to_string();
        assert!(message.contains("nothing arrived at the local storage SCP"));
        assert!(message.contains("AE mapping or port misconfiguration"));
        assert!(message.contains("scp_received=0"));
    }

    #[test]
    fn retrieve_validation_rejects_failure_status() {
        let outcome = MoveOutcome {
            final_status: 0xA702,
            failed: 1,
            ..MoveOutcome::default()
        };

        let err = validate_retrieve_outcome(
            &outcome,
            "DICOMNODECLIENT",
            "0.0.0.0:11112",
            Some(&scp_report(0, 0, 0)),
        )
        .unwrap_err();

        let message = err.to_string();
        assert!(message.contains("retrieve failed with status=0xA702"));
        assert!(message.contains("scp_received=0"));
    }

    #[test]
    fn retrieve_validation_rejects_canceled_status() {
        let outcome = MoveOutcome {
            final_status: 0xFE00,
            remaining: 3,
            completed: 2,
            ..MoveOutcome::default()
        };

        let err = validate_retrieve_outcome(
            &outcome,
            "DICOMNODECLIENT",
            "0.0.0.0:11112",
            Some(&scp_report(2, 2, 0)),
        )
        .unwrap_err();

        let message = err.to_string();
        assert!(message.contains("retrieve was canceled by the remote node"));
        assert!(message.contains("status=0xFE00"));
        assert!(message.contains("scp_received=2"));
    }
}
