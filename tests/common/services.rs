use dicom_node_client::{
    config::{AppConfig, AppPaths, StoreTransferSyntaxPreference},
    models::RemoteNode,
    services::AppServices,
};
use tempfile::{tempdir, TempDir};
use uuid::Uuid;

#[derive(Debug)]
pub struct TestServices {
    pub temp_dir: TempDir,
    pub services: AppServices,
}

impl TestServices {
    pub fn new() -> anyhow::Result<Self> {
        let temp_dir = tempdir()?;
        let base_dir = temp_dir.path().join("app");
        let paths = AppPaths {
            base_dir: base_dir.clone(),
            config_json: base_dir.join("config.json"),
            sqlite_db: base_dir.join("rusty-dicom-node.sqlite3"),
            managed_store_dir: base_dir.join("store"),
            logs_dir: base_dir.join("logs"),
        };
        paths.ensure()?;

        let config = AppConfig {
            local_ae_title: "LOCALTEST".to_string(),
            storage_bind_addr: "127.0.0.1".to_string(),
            storage_scp_port: 0,
            preferred_store_transfer_syntax: StoreTransferSyntaxPreference::ExplicitVrLittleEndian,
            ..AppConfig::default()
        };
        config.save(&paths)?;

        let services = AppServices::load_from_paths(paths)?;
        Ok(Self { temp_dir, services })
    }
}

pub fn remote_node_fixture(name: &str, ae_title: &str, port: u16) -> RemoteNode {
    RemoteNode {
        id: Uuid::new_v4().to_string(),
        name: name.trim().to_ascii_lowercase(),
        ae_title: ae_title.trim().to_ascii_uppercase(),
        host: "127.0.0.1".to_string(),
        port,
        preferred_move_destination: None,
        notes: None,
        created_at: String::new(),
        updated_at: String::new(),
    }
}
