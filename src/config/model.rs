use std::{collections::BTreeSet, fmt, fs, net::SocketAddr};

use anyhow::Context;
use dicom_dictionary_std::uids::{
    DEFLATED_EXPLICIT_VR_LITTLE_ENDIAN, EXPLICIT_VR_LITTLE_ENDIAN, IMPLICIT_VR_LITTLE_ENDIAN,
    JPEG2000_LOSSLESS,
};
use serde::{Deserialize, Serialize};

use super::paths::AppPaths;
use crate::{
    error::Result,
    models::{normalize_ae_title, validate_ae_title},
};

pub const LEGACY_DEFAULT_MAX_PDU_LENGTH: u32 = 16_378;
pub const RECOMMENDED_MAX_PDU_LENGTH: u32 = 262_138;
pub const DEFAULT_MAX_ZIP_ENTRY_BYTES: u64 = 2 * 1024 * 1024 * 1024;
pub const DEFAULT_MAX_ZIP_TOTAL_BYTES: u64 = 50 * 1024 * 1024 * 1024;
pub const DEFAULT_MAX_ZIP_ENTRY_COUNT: usize = 100_000;
pub const DEFAULT_MAX_FILE_IMPORT_BYTES: u64 = 2 * 1024 * 1024 * 1024;
pub const DEFAULT_MAX_STORE_OBJECT_BYTES: u64 = 2 * 1024 * 1024 * 1024;
pub const DEFAULT_MAX_CONCURRENT_ASSOCIATIONS: usize = 32;
pub const DEFAULT_SERVER_MAX_CONCURRENT_ASSOCIATIONS: usize = 128;
pub const DEFAULT_SERVER_ASSOCIATION_SLOT_WAIT_TIMEOUT_MS: u64 = 1_000;
pub const DEFAULT_SERVER_SHUTDOWN_TIMEOUT_MS: u64 = 5_000;

// Import hardening defaults. These are stored as Options in the config to preserve
// backwards compatibility and allow "unset" to mean "no limit" where applicable.
pub const DEFAULT_MAX_IMPORT_TOTAL_FILES: usize = 1_000_000;
pub const DEFAULT_MAX_IMPORT_PATH_LENGTH: usize = 4096;
pub const DEFAULT_MAX_IMPORT_DIRECTORY_DEPTH: usize = 64;

const BACKFILL_CONFIG_KEYS: [&str; 13] = [
    "local_aes",
    "server_max_concurrent_associations",
    "server_association_slot_wait_timeout_ms",
    "server_shutdown_timeout_ms",
    "preferred_store_transfer_syntax",
    "max_zip_entry_bytes",
    "max_zip_total_bytes",
    "max_zip_entry_count",
    "max_file_import_bytes",
    "max_store_object_bytes",
    "max_import_total_files",
    "max_import_path_length",
    "max_import_directory_depth",
];

#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize, Deserialize, Default)]
#[serde(rename_all = "snake_case")]
pub enum StoreTransferSyntaxPreference {
    #[default]
    Jpeg2000Lossless,
    ExplicitVrLittleEndian,
    ImplicitVrLittleEndian,
    DeflatedExplicitVrLittleEndian,
    ExplicitVrBigEndian,
}

impl StoreTransferSyntaxPreference {
    #[allow(deprecated)]
    pub fn uid(self) -> &'static str {
        match self {
            Self::Jpeg2000Lossless => JPEG2000_LOSSLESS,
            Self::ExplicitVrLittleEndian => EXPLICIT_VR_LITTLE_ENDIAN,
            Self::ImplicitVrLittleEndian => IMPLICIT_VR_LITTLE_ENDIAN,
            Self::DeflatedExplicitVrLittleEndian => DEFLATED_EXPLICIT_VR_LITTLE_ENDIAN,
            Self::ExplicitVrBigEndian => dicom_dictionary_std::uids::EXPLICIT_VR_BIG_ENDIAN,
        }
    }

    pub fn label(self) -> &'static str {
        match self {
            Self::Jpeg2000Lossless => "JPEG 2000 Lossless",
            Self::ExplicitVrLittleEndian => "Explicit VR Little Endian",
            Self::ImplicitVrLittleEndian => "Implicit VR Little Endian",
            Self::DeflatedExplicitVrLittleEndian => "Deflated Explicit VR Little Endian",
            Self::ExplicitVrBigEndian => "Explicit VR Big Endian",
        }
    }
}

impl fmt::Display for StoreTransferSyntaxPreference {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        f.write_str(self.label())
    }
}

#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize, Deserialize)]
#[serde(rename_all = "snake_case")]
pub enum LocalAeService {
    Verification,
    Storage,
    Query,
    Retrieve,
}

#[derive(Debug, Clone, PartialEq, Eq, Serialize, Deserialize)]
pub struct LocalAeConfig {
    pub title: String,
    pub bind_addr: String,
    #[serde(default = "default_local_ae_services")]
    pub services: Vec<LocalAeService>,
    #[serde(default = "default_max_concurrent_associations_value")]
    pub max_concurrent_associations: usize,
    #[serde(default)]
    pub allowed_calling_aet: Vec<String>,
    #[serde(default)]
    pub allowed_peer_ips: Vec<String>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct AppConfig {
    pub local_ae_title: String,
    pub storage_bind_addr: String,
    pub storage_scp_port: u16,
    pub max_pdu_length: u32,
    pub strict_pdu: bool,
    pub allow_promiscuous_storage: bool,

    /// If non-empty, only allow associations from these Calling AE Titles.
    ///
    /// Comparison is case-sensitive and performed after trimming trailing spaces
    /// from the received AE title.
    #[serde(default)]
    pub allowed_calling_aet: Vec<String>,

    /// If non-empty, only allow associations from these peer IPs/CIDRs.
    ///
    /// Supported formats: exact IP (e.g. `127.0.0.1`, `::1`) or CIDR notation
    /// (e.g. `10.0.0.0/8`, `2001:db8::/32`). Hostnames are not supported.
    #[serde(default)]
    pub allowed_peer_ips: Vec<String>,

    #[serde(default)]
    pub preferred_store_transfer_syntax: StoreTransferSyntaxPreference,
    #[serde(default = "default_max_zip_entry_bytes")]
    pub max_zip_entry_bytes: Option<u64>,
    #[serde(default = "default_max_zip_total_bytes")]
    pub max_zip_total_bytes: Option<u64>,
    #[serde(default = "default_max_zip_entry_count")]
    pub max_zip_entry_count: Option<usize>,
    #[serde(default = "default_max_file_import_bytes")]
    pub max_file_import_bytes: Option<u64>,
    #[serde(default = "default_max_store_object_bytes")]
    pub max_store_object_bytes: Option<u64>,

    #[serde(default)]
    pub local_aes: Vec<LocalAeConfig>,

    #[serde(default = "default_server_max_concurrent_associations")]
    pub server_max_concurrent_associations: usize,
    #[serde(default = "default_server_association_slot_wait_timeout_ms")]
    pub server_association_slot_wait_timeout_ms: u64,
    #[serde(default = "default_server_shutdown_timeout_ms")]
    pub server_shutdown_timeout_ms: u64,

    /// Maximum number of filesystem entries to consider during a single import.
    ///
    /// This is a safety limit to avoid pathological directory trees. Set to null
    /// to disable.
    #[serde(default = "default_max_import_total_files")]
    pub max_import_total_files: Option<usize>,

    /// Maximum length (in bytes) for paths encountered during import.
    ///
    /// Set to null to disable.
    #[serde(default = "default_max_import_path_length")]
    pub max_import_path_length: Option<usize>,

    /// Maximum directory depth to traverse during import.
    ///
    /// Depth is measured relative to the import root. Set to null to disable.
    #[serde(default = "default_max_import_directory_depth")]
    pub max_import_directory_depth: Option<usize>,

    /// Preferred UI locale (BCP-47). Used when `--lang` and `DICOM_NODE_LANG` are unset.
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub locale: Option<String>,
}

impl Default for AppConfig {
    fn default() -> Self {
        Self {
            local_ae_title: "DICOMNODECLIENT".to_string(),
            storage_bind_addr: "0.0.0.0".to_string(),
            storage_scp_port: 11112,
            max_pdu_length: RECOMMENDED_MAX_PDU_LENGTH,
            strict_pdu: true,
            allow_promiscuous_storage: false,
            allowed_calling_aet: Vec::new(),
            allowed_peer_ips: Vec::new(),
            preferred_store_transfer_syntax: StoreTransferSyntaxPreference::default(),
            max_zip_entry_bytes: default_max_zip_entry_bytes(),
            max_zip_total_bytes: default_max_zip_total_bytes(),
            max_zip_entry_count: default_max_zip_entry_count(),
            max_file_import_bytes: default_max_file_import_bytes(),
            max_store_object_bytes: default_max_store_object_bytes(),
            local_aes: vec![default_legacy_local_ae()],
            server_max_concurrent_associations: DEFAULT_SERVER_MAX_CONCURRENT_ASSOCIATIONS,
            server_association_slot_wait_timeout_ms:
                DEFAULT_SERVER_ASSOCIATION_SLOT_WAIT_TIMEOUT_MS,
            server_shutdown_timeout_ms: DEFAULT_SERVER_SHUTDOWN_TIMEOUT_MS,
            max_import_total_files: default_max_import_total_files(),
            max_import_path_length: default_max_import_path_length(),
            max_import_directory_depth: default_max_import_directory_depth(),
            locale: None,
        }
    }
}

fn default_max_zip_entry_bytes() -> Option<u64> {
    Some(DEFAULT_MAX_ZIP_ENTRY_BYTES)
}

fn default_max_zip_total_bytes() -> Option<u64> {
    Some(DEFAULT_MAX_ZIP_TOTAL_BYTES)
}

fn default_max_zip_entry_count() -> Option<usize> {
    Some(DEFAULT_MAX_ZIP_ENTRY_COUNT)
}

fn default_max_file_import_bytes() -> Option<u64> {
    Some(DEFAULT_MAX_FILE_IMPORT_BYTES)
}

fn default_max_store_object_bytes() -> Option<u64> {
    Some(DEFAULT_MAX_STORE_OBJECT_BYTES)
}

fn default_max_import_total_files() -> Option<usize> {
    Some(DEFAULT_MAX_IMPORT_TOTAL_FILES)
}

fn default_max_import_path_length() -> Option<usize> {
    Some(DEFAULT_MAX_IMPORT_PATH_LENGTH)
}

fn default_max_import_directory_depth() -> Option<usize> {
    Some(DEFAULT_MAX_IMPORT_DIRECTORY_DEPTH)
}

fn default_max_concurrent_associations_value() -> usize {
    DEFAULT_MAX_CONCURRENT_ASSOCIATIONS
}

fn default_server_max_concurrent_associations() -> usize {
    DEFAULT_SERVER_MAX_CONCURRENT_ASSOCIATIONS
}

fn default_server_association_slot_wait_timeout_ms() -> u64 {
    DEFAULT_SERVER_ASSOCIATION_SLOT_WAIT_TIMEOUT_MS
}

fn default_server_shutdown_timeout_ms() -> u64 {
    DEFAULT_SERVER_SHUTDOWN_TIMEOUT_MS
}

fn default_local_ae_services() -> Vec<LocalAeService> {
    vec![
        LocalAeService::Verification,
        LocalAeService::Storage,
        LocalAeService::Query,
        LocalAeService::Retrieve,
    ]
}

fn default_legacy_local_ae() -> LocalAeConfig {
    LocalAeConfig {
        title: "DICOMNODECLIENT".to_string(),
        bind_addr: "0.0.0.0:11112".to_string(),
        services: default_local_ae_services(),
        max_concurrent_associations: DEFAULT_MAX_CONCURRENT_ASSOCIATIONS,
        allowed_calling_aet: Vec::new(),
        allowed_peer_ips: Vec::new(),
    }
}

impl AppConfig {
    fn legacy_local_ae(&self) -> LocalAeConfig {
        LocalAeConfig {
            title: normalize_ae_title(&self.local_ae_title),
            bind_addr: self.storage_socket_addr(),
            services: default_local_ae_services(),
            max_concurrent_associations: DEFAULT_MAX_CONCURRENT_ASSOCIATIONS,
            allowed_calling_aet: self.allowed_calling_aet.clone(),
            allowed_peer_ips: self.allowed_peer_ips.clone(),
        }
    }

    fn normalize_local_aes(&mut self) -> bool {
        let before_title = self.local_ae_title.clone();
        let before_aes = self.local_aes.clone();
        self.local_ae_title = normalize_ae_title(&self.local_ae_title);
        for ae in &mut self.local_aes {
            ae.title = normalize_ae_title(&ae.title);
        }
        before_title != self.local_ae_title || before_aes != self.local_aes
    }

    fn validate(&self) -> Result<()> {
        fn ensure_nonzero_u64(name: &str, value: Option<u64>) -> Result<()> {
            if let Some(0) = value {
                anyhow::bail!(
                    "{}",
                    crate::error::msg_with("error-config-must-be-positive", [("name", name)])
                );
            }
            Ok(())
        }

        fn ensure_nonzero_usize(name: &str, value: Option<usize>) -> Result<()> {
            if let Some(0) = value {
                anyhow::bail!(
                    "{}",
                    crate::error::msg_with("error-config-must-be-positive", [("name", name)])
                );
            }
            Ok(())
        }

        // ZIP / file import safety knobs
        ensure_nonzero_u64("max_zip_entry_bytes", self.max_zip_entry_bytes)?;
        ensure_nonzero_u64("max_zip_total_bytes", self.max_zip_total_bytes)?;
        ensure_nonzero_usize("max_zip_entry_count", self.max_zip_entry_count)?;
        ensure_nonzero_u64("max_file_import_bytes", self.max_file_import_bytes)?;
        ensure_nonzero_u64("max_store_object_bytes", self.max_store_object_bytes)?;

        // Traversal safety knobs
        ensure_nonzero_usize("max_import_total_files", self.max_import_total_files)?;
        ensure_nonzero_usize("max_import_path_length", self.max_import_path_length)?;
        ensure_nonzero_usize(
            "max_import_directory_depth",
            self.max_import_directory_depth,
        )?;
        if self.server_max_concurrent_associations == 0 {
            anyhow::bail!(
                "{}",
                crate::error::msg_with(
                    "error-config-must-be-positive-required",
                    [("name", "server_max_concurrent_associations")],
                )
            );
        }
        if self.server_association_slot_wait_timeout_ms == 0 {
            anyhow::bail!(
                "{}",
                crate::error::msg_with(
                    "error-config-must-be-positive-required",
                    [("name", "server_association_slot_wait_timeout_ms")],
                )
            );
        }
        if self.server_shutdown_timeout_ms == 0 {
            anyhow::bail!(
                "{}",
                crate::error::msg_with(
                    "error-config-must-be-positive-required",
                    [("name", "server_shutdown_timeout_ms")],
                )
            );
        }

        validate_ae_title(&self.local_ae_title)
            .with_context(|| "validating legacy local_ae_title")?;
        self.validate_local_aes()?;

        Ok(())
    }

    fn validate_local_aes(&self) -> Result<()> {
        let mut nonzero_ports = BTreeSet::new();
        for ae in &self.local_aes {
            validate_ae_title(&ae.title)
                .with_context(|| format!("validating local AE title {}", ae.title))?;
            if ae.services.is_empty() {
                anyhow::bail!(
                    "{}",
                    crate::error::msg_with(
                        "error-config-local-ae-no-services",
                        [("title", ae.title.as_str())],
                    )
                );
            }
            if ae.max_concurrent_associations == 0 {
                anyhow::bail!(
                    "{}",
                    crate::error::msg_with(
                        "error-config-local-ae-max-assoc",
                        [("title", ae.title.as_str())],
                    )
                );
            }

            let bind_addr: SocketAddr = ae.bind_addr.parse().with_context(|| {
                format!(
                    "validating local AE {} bind_addr {}",
                    ae.title, ae.bind_addr
                )
            })?;
            if bind_addr.port() != 0 && !nonzero_ports.insert(bind_addr.port()) {
                let port = bind_addr.port().to_string();
                anyhow::bail!(
                    "{}",
                    crate::error::msg_with(
                        "error-config-duplicate-bind-port",
                        [("port", port.as_str())],
                    )
                );
            }
        }

        Ok(())
    }

    pub fn load_or_create(paths: &AppPaths) -> Result<Self> {
        if paths.config_json.exists() {
            let text = fs::read_to_string(&paths.config_json)
                .with_context(|| format!("reading {}", paths.config_json.display()))?;
            let raw_config: serde_json::Value = serde_json::from_str(&text)
                .with_context(|| format!("parsing {}", paths.config_json.display()))?;
            let mut cfg: Self = serde_json::from_value(raw_config.clone())
                .with_context(|| format!("parsing {}", paths.config_json.display()))?;
            let mut should_save = BACKFILL_CONFIG_KEYS
                .iter()
                .any(|key| raw_config.get(key).is_none());
            if raw_config.get("local_aes").is_none() {
                cfg.local_aes = vec![cfg.legacy_local_ae()];
                should_save = true;
            }
            if cfg.max_pdu_length == LEGACY_DEFAULT_MAX_PDU_LENGTH {
                cfg.max_pdu_length = RECOMMENDED_MAX_PDU_LENGTH;
                should_save = true;
            }
            if cfg.normalize_local_aes() {
                should_save = true;
            }

            cfg.validate()
                .with_context(|| format!("validating config at {}", paths.config_json.display()))?;

            if should_save {
                cfg.save(paths)?;
            }
            Ok(cfg)
        } else {
            let cfg = Self::default();
            cfg.validate()?;
            cfg.save(paths)?;
            Ok(cfg)
        }
    }

    pub fn save(&self, paths: &AppPaths) -> Result<()> {
        AppPaths::ensure_parent(&paths.config_json)?;
        let text = serde_json::to_string_pretty(self)?;
        fs::write(&paths.config_json, text)
            .with_context(|| format!("writing {}", paths.config_json.display()))?;
        Ok(())
    }

    pub fn storage_socket_addr(&self) -> String {
        format!("{}:{}", self.storage_bind_addr, self.storage_scp_port)
    }
}

pub fn now_utc_string() -> String {
    chrono::Utc::now().to_rfc3339()
}

#[cfg(test)]
mod tests {
    use super::{
        AppConfig, LocalAeService, StoreTransferSyntaxPreference, DEFAULT_MAX_FILE_IMPORT_BYTES,
        DEFAULT_MAX_STORE_OBJECT_BYTES, DEFAULT_MAX_ZIP_ENTRY_BYTES, DEFAULT_MAX_ZIP_ENTRY_COUNT,
        DEFAULT_MAX_ZIP_TOTAL_BYTES, DEFAULT_SERVER_ASSOCIATION_SLOT_WAIT_TIMEOUT_MS,
        DEFAULT_SERVER_MAX_CONCURRENT_ASSOCIATIONS, DEFAULT_SERVER_SHUTDOWN_TIMEOUT_MS,
        LEGACY_DEFAULT_MAX_PDU_LENGTH, RECOMMENDED_MAX_PDU_LENGTH,
    };
    use crate::config::AppPaths;
    use std::fs;
    use tempfile::{tempdir, TempDir};

    fn temp_paths(root: &TempDir) -> AppPaths {
        let base_dir = root.path().join("config");
        AppPaths {
            base_dir: base_dir.clone(),
            config_json: base_dir.join("config.json"),
            sqlite_db: base_dir.join("app.sqlite3"),
            managed_store_dir: base_dir.join("store"),
            logs_dir: base_dir.join("logs"),
            active_log_file: base_dir.join("logs").join("app.log"),
        }
    }

    #[test]
    fn default_config_uses_recommended_max_pdu_length() {
        assert_eq!(
            AppConfig::default().max_pdu_length,
            RECOMMENDED_MAX_PDU_LENGTH
        );
        assert_eq!(
            AppConfig::default().preferred_store_transfer_syntax,
            StoreTransferSyntaxPreference::Jpeg2000Lossless
        );
        assert_eq!(
            AppConfig::default().max_zip_entry_bytes,
            Some(DEFAULT_MAX_ZIP_ENTRY_BYTES)
        );
        assert_eq!(
            AppConfig::default().max_zip_total_bytes,
            Some(DEFAULT_MAX_ZIP_TOTAL_BYTES)
        );
        assert_eq!(
            AppConfig::default().max_zip_entry_count,
            Some(DEFAULT_MAX_ZIP_ENTRY_COUNT)
        );
        assert_eq!(
            AppConfig::default().max_file_import_bytes,
            Some(DEFAULT_MAX_FILE_IMPORT_BYTES)
        );
        assert_eq!(
            AppConfig::default().max_store_object_bytes,
            Some(DEFAULT_MAX_STORE_OBJECT_BYTES)
        );
        assert_eq!(
            AppConfig::default().server_max_concurrent_associations,
            DEFAULT_SERVER_MAX_CONCURRENT_ASSOCIATIONS
        );
        assert_eq!(
            AppConfig::default().server_association_slot_wait_timeout_ms,
            DEFAULT_SERVER_ASSOCIATION_SLOT_WAIT_TIMEOUT_MS
        );
        assert_eq!(
            AppConfig::default().server_shutdown_timeout_ms,
            DEFAULT_SERVER_SHUTDOWN_TIMEOUT_MS
        );
    }

    #[test]
    fn load_or_create_migrates_legacy_max_pdu_length() {
        let root = tempdir().expect("create temp dir");
        let paths = temp_paths(&root);
        paths.ensure().expect("create temp paths");
        fs::write(
            &paths.config_json,
            format!(
                concat!(
                    "{{\n",
                    "  \"local_ae_title\": \"DICOMNODECLIENT\",\n",
                    "  \"storage_bind_addr\": \"0.0.0.0\",\n",
                    "  \"storage_scp_port\": 11112,\n",
                    "  \"max_pdu_length\": {},\n",
                    "  \"strict_pdu\": true,\n",
                    "  \"allow_promiscuous_storage\": false\n",
                    "}}\n"
                ),
                LEGACY_DEFAULT_MAX_PDU_LENGTH
            ),
        )
        .expect("write legacy config");

        let cfg = AppConfig::load_or_create(&paths).expect("load migrated config");
        assert_eq!(cfg.max_pdu_length, RECOMMENDED_MAX_PDU_LENGTH);
        assert_eq!(
            cfg.preferred_store_transfer_syntax,
            StoreTransferSyntaxPreference::Jpeg2000Lossless
        );
        assert_eq!(cfg.max_zip_entry_bytes, Some(DEFAULT_MAX_ZIP_ENTRY_BYTES));
        assert_eq!(cfg.max_zip_total_bytes, Some(DEFAULT_MAX_ZIP_TOTAL_BYTES));
        assert_eq!(cfg.max_zip_entry_count, Some(DEFAULT_MAX_ZIP_ENTRY_COUNT));
        assert_eq!(
            cfg.max_file_import_bytes,
            Some(DEFAULT_MAX_FILE_IMPORT_BYTES)
        );
        assert_eq!(
            cfg.max_store_object_bytes,
            Some(DEFAULT_MAX_STORE_OBJECT_BYTES)
        );
        assert_eq!(cfg.local_aes.len(), 1);
        assert_eq!(cfg.local_aes[0].title, "DICOMNODECLIENT");
        assert_eq!(cfg.local_aes[0].bind_addr, "0.0.0.0:11112");
        assert_eq!(
            cfg.local_aes[0].services,
            vec![
                LocalAeService::Verification,
                LocalAeService::Storage,
                LocalAeService::Query,
                LocalAeService::Retrieve,
            ]
        );

        let saved = fs::read_to_string(&paths.config_json).expect("read migrated config");
        assert!(saved.contains(&RECOMMENDED_MAX_PDU_LENGTH.to_string()));
        assert!(saved.contains("\"local_aes\""));
        assert!(saved.contains("\"preferred_store_transfer_syntax\": \"jpeg2000_lossless\""));
        assert!(saved.contains("\"max_zip_entry_bytes\": 2147483648"));
        assert!(saved.contains("\"max_zip_total_bytes\": 53687091200"));
        assert!(saved.contains("\"max_zip_entry_count\": 100000"));
        assert!(saved.contains("\"max_file_import_bytes\": 2147483648"));
        assert!(saved.contains("\"max_store_object_bytes\": 2147483648"));
        assert!(saved.contains("\"server_max_concurrent_associations\""));
        assert!(saved.contains("\"server_association_slot_wait_timeout_ms\""));
        assert!(saved.contains("\"server_shutdown_timeout_ms\""));
    }

    #[test]
    fn load_or_create_backfills_transfer_syntax_preference_when_missing() {
        let root = tempdir().expect("create temp dir");
        let paths = temp_paths(&root);
        paths.ensure().expect("create temp paths");
        fs::write(
            &paths.config_json,
            concat!(
                "{\n",
                "  \"local_ae_title\": \"DICOMNODECLIENT\",\n",
                "  \"storage_bind_addr\": \"0.0.0.0\",\n",
                "  \"storage_scp_port\": 11112,\n",
                "  \"max_pdu_length\": 262138,\n",
                "  \"strict_pdu\": true,\n",
                "  \"allow_promiscuous_storage\": false\n",
                "}\n"
            ),
        )
        .expect("write old config");

        let cfg = AppConfig::load_or_create(&paths).expect("load config with missing preference");
        assert_eq!(
            cfg.preferred_store_transfer_syntax,
            StoreTransferSyntaxPreference::Jpeg2000Lossless
        );
        assert_eq!(cfg.max_zip_entry_bytes, Some(DEFAULT_MAX_ZIP_ENTRY_BYTES));
        assert_eq!(cfg.max_zip_total_bytes, Some(DEFAULT_MAX_ZIP_TOTAL_BYTES));
        assert_eq!(cfg.max_zip_entry_count, Some(DEFAULT_MAX_ZIP_ENTRY_COUNT));
        assert_eq!(
            cfg.max_file_import_bytes,
            Some(DEFAULT_MAX_FILE_IMPORT_BYTES)
        );
        assert_eq!(
            cfg.max_store_object_bytes,
            Some(DEFAULT_MAX_STORE_OBJECT_BYTES)
        );

        let saved = fs::read_to_string(&paths.config_json).expect("read backfilled config");
        assert!(saved.contains("\"preferred_store_transfer_syntax\": \"jpeg2000_lossless\""));
        assert!(saved.contains("\"max_zip_entry_bytes\": 2147483648"));
        assert!(saved.contains("\"max_zip_total_bytes\": 53687091200"));
        assert!(saved.contains("\"max_zip_entry_count\": 100000"));
        assert!(saved.contains("\"max_file_import_bytes\": 2147483648"));
        assert!(saved.contains("\"max_store_object_bytes\": 2147483648"));
        assert!(saved.contains("\"server_max_concurrent_associations\""));
        assert!(saved.contains("\"server_association_slot_wait_timeout_ms\""));
        assert!(saved.contains("\"server_shutdown_timeout_ms\""));
    }

    #[test]
    fn load_or_create_backfills_missing_keys_even_when_names_appear_nested() {
        let root = tempdir().expect("create temp dir");
        let paths = temp_paths(&root);
        paths.ensure().expect("create temp paths");
        fs::write(
            &paths.config_json,
            concat!(
                "{\n",
                "  \"local_ae_title\": \"DICOMNODECLIENT\",\n",
                "  \"storage_bind_addr\": \"0.0.0.0\",\n",
                "  \"storage_scp_port\": 11112,\n",
                "  \"max_pdu_length\": 262138,\n",
                "  \"strict_pdu\": true,\n",
                "  \"allow_promiscuous_storage\": false,\n",
                "  \"metadata\": {\n",
                "    \"preferred_store_transfer_syntax\": true,\n",
                "    \"max_zip_entry_bytes\": true,\n",
                "    \"max_zip_total_bytes\": true,\n",
                "    \"max_zip_entry_count\": true,\n",
                "    \"max_file_import_bytes\": true,\n",
                "    \"max_store_object_bytes\": true\n",
                "  }\n",
                "}\n"
            ),
        )
        .expect("write old config");

        let cfg = AppConfig::load_or_create(&paths).expect("load config with nested key names");

        assert_eq!(
            cfg.preferred_store_transfer_syntax,
            StoreTransferSyntaxPreference::Jpeg2000Lossless
        );
        assert_eq!(cfg.max_zip_entry_bytes, Some(DEFAULT_MAX_ZIP_ENTRY_BYTES));
        assert_eq!(
            cfg.max_store_object_bytes,
            Some(DEFAULT_MAX_STORE_OBJECT_BYTES)
        );

        let saved = fs::read_to_string(&paths.config_json).expect("read backfilled config");
        assert!(saved.contains("\"preferred_store_transfer_syntax\": \"jpeg2000_lossless\""));
        assert!(saved.contains("\"max_zip_entry_bytes\": 2147483648"));
        assert!(saved.contains("\"max_zip_total_bytes\": 53687091200"));
        assert!(saved.contains("\"max_zip_entry_count\": 100000"));
        assert!(saved.contains("\"max_file_import_bytes\": 2147483648"));
        assert!(saved.contains("\"max_store_object_bytes\": 2147483648"));
    }

    #[test]
    fn load_or_create_preserves_explicit_null_zip_limits() {
        let root = tempdir().expect("create temp dir");
        let paths = temp_paths(&root);
        paths.ensure().expect("create temp paths");
        fs::write(
            &paths.config_json,
            concat!(
                "{\n",
                "  \"local_ae_title\": \"DICOMNODECLIENT\",\n",
                "  \"storage_bind_addr\": \"0.0.0.0\",\n",
                "  \"storage_scp_port\": 11112,\n",
                "  \"max_pdu_length\": 262138,\n",
                "  \"strict_pdu\": true,\n",
                "  \"allow_promiscuous_storage\": false,\n",
                "  \"preferred_store_transfer_syntax\": \"jpeg2000_lossless\",\n",
                "  \"max_zip_entry_bytes\": null,\n",
                "  \"max_zip_total_bytes\": null,\n",
                "  \"max_zip_entry_count\": null,\n",
                "  \"max_file_import_bytes\": null,\n",
                "  \"max_store_object_bytes\": null\n",
                "}\n"
            ),
        )
        .expect("write config with null zip limits");

        let cfg = AppConfig::load_or_create(&paths).expect("load config with null zip limits");

        assert_eq!(cfg.max_zip_entry_bytes, None);
        assert_eq!(cfg.max_zip_total_bytes, None);
        assert_eq!(cfg.max_zip_entry_count, None);
        assert_eq!(cfg.max_file_import_bytes, None);
        assert_eq!(cfg.max_store_object_bytes, None);

        let saved = fs::read_to_string(&paths.config_json).expect("read config after load");
        assert!(saved.contains("\"max_zip_entry_bytes\": null"));
        assert!(saved.contains("\"max_zip_total_bytes\": null"));
        assert!(saved.contains("\"max_zip_entry_count\": null"));
        assert!(saved.contains("\"max_file_import_bytes\": null"));
        assert!(saved.contains("\"max_store_object_bytes\": null"));
    }

    #[test]
    fn load_or_create_rejects_zero_limits() {
        let root = tempdir().expect("create temp dir");
        let paths = temp_paths(&root);
        paths.ensure().expect("create temp paths");
        fs::write(
            &paths.config_json,
            concat!(
                "{\n",
                "  \"local_ae_title\": \"DICOMNODECLIENT\",\n",
                "  \"storage_bind_addr\": \"0.0.0.0\",\n",
                "  \"storage_scp_port\": 11112,\n",
                "  \"max_pdu_length\": 262138,\n",
                "  \"strict_pdu\": true,\n",
                "  \"allow_promiscuous_storage\": false,\n",
                "  \"preferred_store_transfer_syntax\": \"jpeg2000_lossless\",\n",
                "  \"max_zip_entry_bytes\": 0\n",
                "}\n"
            ),
        )
        .expect("write config with invalid zero limit");

        let err = AppConfig::load_or_create(&paths).unwrap_err();
        let msg = format!("{:#}", err);
        assert!(msg.contains("validating config"));
        assert!(msg.contains("max_zip_entry_bytes"));
        assert!(msg.contains("must be > 0"));
    }

    #[test]
    fn load_or_create_rejects_zero_server_runtime_limits() {
        let root = tempdir().expect("create temp dir");
        let paths = temp_paths(&root);
        paths.ensure().expect("create temp paths");
        fs::write(
            &paths.config_json,
            concat!(
                "{\n",
                "  \"local_ae_title\": \"DICOMNODECLIENT\",\n",
                "  \"storage_bind_addr\": \"0.0.0.0\",\n",
                "  \"storage_scp_port\": 11112,\n",
                "  \"max_pdu_length\": 262138,\n",
                "  \"strict_pdu\": true,\n",
                "  \"allow_promiscuous_storage\": false,\n",
                "  \"server_max_concurrent_associations\": 0\n",
                "}\n"
            ),
        )
        .expect("write config with invalid runtime limit");

        let err = AppConfig::load_or_create(&paths).unwrap_err();
        let msg = format!("{:#}", err);
        assert!(msg.contains("validating config"));
        assert!(msg.contains("server_max_concurrent_associations"));
        assert!(msg.contains("must be > 0"));
    }

    #[test]
    fn load_or_create_rejects_invalid_local_ae_title() {
        let root = tempdir().expect("create temp dir");
        let paths = temp_paths(&root);
        paths.ensure().expect("create temp paths");
        fs::write(
            &paths.config_json,
            concat!(
                "{\n",
                "  \"local_ae_title\": \"DICOMNODECLIENT\",\n",
                "  \"storage_bind_addr\": \"0.0.0.0\",\n",
                "  \"storage_scp_port\": 11112,\n",
                "  \"max_pdu_length\": 262138,\n",
                "  \"strict_pdu\": true,\n",
                "  \"allow_promiscuous_storage\": false,\n",
                "  \"local_aes\": [\n",
                "    {\n",
                "      \"title\": \"bad_ae\",\n",
                "      \"bind_addr\": \"127.0.0.1:11112\",\n",
                "      \"services\": [\"verification\"],\n",
                "      \"max_concurrent_associations\": 1\n",
                "    }\n",
                "  ]\n",
                "}\n"
            ),
        )
        .expect("write config with invalid local AE");

        let err = AppConfig::load_or_create(&paths).unwrap_err();
        let msg = format!("{:#}", err);
        assert!(msg.contains("validating config"));
        assert!(msg.contains("AE title"));
    }

    #[test]
    fn load_or_create_rejects_unknown_local_ae_service() {
        let root = tempdir().expect("create temp dir");
        let paths = temp_paths(&root);
        paths.ensure().expect("create temp paths");
        fs::write(
            &paths.config_json,
            concat!(
                "{\n",
                "  \"local_ae_title\": \"DICOMNODECLIENT\",\n",
                "  \"storage_bind_addr\": \"0.0.0.0\",\n",
                "  \"storage_scp_port\": 11112,\n",
                "  \"max_pdu_length\": 262138,\n",
                "  \"strict_pdu\": true,\n",
                "  \"allow_promiscuous_storage\": false,\n",
                "  \"local_aes\": [\n",
                "    {\n",
                "      \"title\": \"LOCALSTORE\",\n",
                "      \"bind_addr\": \"127.0.0.1:11112\",\n",
                "      \"services\": [\"storage\", \"not_a_service\"],\n",
                "      \"max_concurrent_associations\": 1\n",
                "    }\n",
                "  ]\n",
                "}\n"
            ),
        )
        .expect("write config with unknown service");

        let err = AppConfig::load_or_create(&paths).unwrap_err();
        let msg = format!("{:#}", err);
        assert!(msg.contains("not_a_service"));
    }

    #[test]
    fn load_or_create_rejects_duplicate_nonzero_local_ae_ports() {
        let root = tempdir().expect("create temp dir");
        let paths = temp_paths(&root);
        paths.ensure().expect("create temp paths");
        fs::write(
            &paths.config_json,
            concat!(
                "{\n",
                "  \"local_ae_title\": \"DICOMNODECLIENT\",\n",
                "  \"storage_bind_addr\": \"0.0.0.0\",\n",
                "  \"storage_scp_port\": 11112,\n",
                "  \"max_pdu_length\": 262138,\n",
                "  \"strict_pdu\": true,\n",
                "  \"allow_promiscuous_storage\": false,\n",
                "  \"local_aes\": [\n",
                "    {\n",
                "      \"title\": \"LOCALONE\",\n",
                "      \"bind_addr\": \"127.0.0.1:11112\",\n",
                "      \"services\": [\"verification\"],\n",
                "      \"max_concurrent_associations\": 1\n",
                "    },\n",
                "    {\n",
                "      \"title\": \"LOCALTWO\",\n",
                "      \"bind_addr\": \"127.0.0.1:11112\",\n",
                "      \"services\": [\"verification\"],\n",
                "      \"max_concurrent_associations\": 2\n",
                "    }\n",
                "  ]\n",
                "}\n"
            ),
        )
        .expect("write config with duplicate ports");

        let err = AppConfig::load_or_create(&paths).unwrap_err();
        let msg = format!("{:#}", err);
        assert!(msg.contains("duplicate local AE bind port"));
    }

    #[test]
    fn load_or_create_preserves_independent_local_ae_limits() {
        let root = tempdir().expect("create temp dir");
        let paths = temp_paths(&root);
        paths.ensure().expect("create temp paths");
        fs::write(
            &paths.config_json,
            concat!(
                "{\n",
                "  \"local_ae_title\": \"DICOMNODECLIENT\",\n",
                "  \"storage_bind_addr\": \"0.0.0.0\",\n",
                "  \"storage_scp_port\": 11112,\n",
                "  \"max_pdu_length\": 262138,\n",
                "  \"strict_pdu\": true,\n",
                "  \"allow_promiscuous_storage\": false,\n",
                "  \"local_aes\": [\n",
                "    {\n",
                "      \"title\": \"LOCALSTORE\",\n",
                "      \"bind_addr\": \"127.0.0.1:0\",\n",
                "      \"services\": [\"verification\", \"storage\"],\n",
                "      \"max_concurrent_associations\": 1\n",
                "    },\n",
                "    {\n",
                "      \"title\": \"LOCALQR\",\n",
                "      \"bind_addr\": \"127.0.0.1:0\",\n",
                "      \"services\": [\"verification\", \"query\", \"retrieve\"],\n",
                "      \"max_concurrent_associations\": 2\n",
                "    }\n",
                "  ]\n",
                "}\n"
            ),
        )
        .expect("write multi-AE config");

        let cfg = AppConfig::load_or_create(&paths).expect("load multi-AE config");
        assert_eq!(cfg.local_aes.len(), 2);
        assert_eq!(cfg.local_aes[0].max_concurrent_associations, 1);
        assert_eq!(cfg.local_aes[1].max_concurrent_associations, 2);
    }
}
