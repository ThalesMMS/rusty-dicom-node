use std::{fmt, fs};

use anyhow::Context;
use dicom_dictionary_std::uids::{
    DEFLATED_EXPLICIT_VR_LITTLE_ENDIAN, EXPLICIT_VR_LITTLE_ENDIAN, IMPLICIT_VR_LITTLE_ENDIAN,
    JPEG2000_LOSSLESS,
};
use serde::{Deserialize, Serialize};

use super::paths::AppPaths;
use crate::error::Result;

pub const LEGACY_DEFAULT_MAX_PDU_LENGTH: u32 = 16_378;
pub const RECOMMENDED_MAX_PDU_LENGTH: u32 = 262_138;
pub const DEFAULT_MAX_ZIP_ENTRY_BYTES: u64 = 2 * 1024 * 1024 * 1024;
pub const DEFAULT_MAX_ZIP_TOTAL_BYTES: u64 = 50 * 1024 * 1024 * 1024;
pub const DEFAULT_MAX_ZIP_ENTRY_COUNT: usize = 100_000;
pub const DEFAULT_MAX_FILE_IMPORT_BYTES: u64 = 2 * 1024 * 1024 * 1024;
pub const DEFAULT_MAX_STORE_OBJECT_BYTES: u64 = 2 * 1024 * 1024 * 1024;
const BACKFILL_CONFIG_KEYS: [&str; 6] = [
    "preferred_store_transfer_syntax",
    "max_zip_entry_bytes",
    "max_zip_total_bytes",
    "max_zip_entry_count",
    "max_file_import_bytes",
    "max_store_object_bytes",
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

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct AppConfig {
    pub local_ae_title: String,
    pub storage_bind_addr: String,
    pub storage_scp_port: u16,
    pub max_pdu_length: u32,
    pub strict_pdu: bool,
    pub allow_promiscuous_storage: bool,
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
            preferred_store_transfer_syntax: StoreTransferSyntaxPreference::default(),
            max_zip_entry_bytes: default_max_zip_entry_bytes(),
            max_zip_total_bytes: default_max_zip_total_bytes(),
            max_zip_entry_count: default_max_zip_entry_count(),
            max_file_import_bytes: default_max_file_import_bytes(),
            max_store_object_bytes: default_max_store_object_bytes(),
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

impl AppConfig {
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
            if cfg.max_pdu_length == LEGACY_DEFAULT_MAX_PDU_LENGTH {
                cfg.max_pdu_length = RECOMMENDED_MAX_PDU_LENGTH;
                should_save = true;
            }
            if should_save {
                cfg.save(paths)?;
            }
            Ok(cfg)
        } else {
            let cfg = Self::default();
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
        AppConfig, StoreTransferSyntaxPreference, DEFAULT_MAX_FILE_IMPORT_BYTES,
        DEFAULT_MAX_STORE_OBJECT_BYTES, DEFAULT_MAX_ZIP_ENTRY_BYTES, DEFAULT_MAX_ZIP_ENTRY_COUNT,
        DEFAULT_MAX_ZIP_TOTAL_BYTES, LEGACY_DEFAULT_MAX_PDU_LENGTH, RECOMMENDED_MAX_PDU_LENGTH,
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

        let saved = fs::read_to_string(&paths.config_json).expect("read migrated config");
        assert!(saved.contains(&RECOMMENDED_MAX_PDU_LENGTH.to_string()));
        assert!(saved.contains("\"preferred_store_transfer_syntax\": \"jpeg2000_lossless\""));
        assert!(saved.contains("\"max_zip_entry_bytes\": 2147483648"));
        assert!(saved.contains("\"max_zip_total_bytes\": 53687091200"));
        assert!(saved.contains("\"max_zip_entry_count\": 100000"));
        assert!(saved.contains("\"max_file_import_bytes\": 2147483648"));
        assert!(saved.contains("\"max_store_object_bytes\": 2147483648"));
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
}
