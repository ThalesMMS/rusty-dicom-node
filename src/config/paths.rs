use std::{
    fs,
    path::{Path, PathBuf},
};

use anyhow::{anyhow, Context};
use directories::ProjectDirs;

use crate::error::Result;

pub(super) const LEGACY_SQLITE_DB_FILENAME: &str = "dicom-node-client.sqlite3";
pub(super) const SQLITE_DB_FILENAME: &str = "rusty-dicom-node.sqlite3";

pub(super) fn legacy_base_dir() -> Option<PathBuf> {
    #[cfg(test)]
    if let Some(path) = test_legacy_base_override::get() {
        return Some(path);
    }

    ProjectDirs::from("br", "openai", "dicom-node-client")
        .map(|dirs| dirs.data_local_dir().to_path_buf())
}

#[cfg(test)]
pub(super) mod test_legacy_base_override {
    use std::{
        cell::RefCell,
        path::{Path, PathBuf},
    };

    thread_local! {
        static LEGACY_BASE_DIR: RefCell<Option<PathBuf>> = const { RefCell::new(None) };
    }

    pub struct LegacyBaseDirOverride {
        previous: Option<PathBuf>,
    }

    pub fn get() -> Option<PathBuf> {
        LEGACY_BASE_DIR.with(|path| path.borrow().clone())
    }

    pub fn set(path: &Path) -> LegacyBaseDirOverride {
        let previous = LEGACY_BASE_DIR.with(|stored| stored.replace(Some(path.to_path_buf())));
        LegacyBaseDirOverride { previous }
    }

    impl Drop for LegacyBaseDirOverride {
        fn drop(&mut self) {
            LEGACY_BASE_DIR.with(|stored| {
                stored.replace(self.previous.take());
            });
        }
    }
}

#[derive(Debug, Clone)]
pub struct AppPaths {
    pub base_dir: PathBuf,
    pub config_json: PathBuf,
    pub sqlite_db: PathBuf,
    pub managed_store_dir: PathBuf,
    pub logs_dir: PathBuf,
}

impl AppPaths {
    pub fn discover() -> Result<Self> {
        let dirs = ProjectDirs::from("com", "ThalesMMS", "rusty-dicom-node")
            .ok_or_else(|| anyhow!("could not determine project directories"))?;
        let base_dir = dirs.data_local_dir().to_path_buf();
        Ok(Self {
            config_json: base_dir.join("config.json"),
            sqlite_db: base_dir.join(SQLITE_DB_FILENAME),
            managed_store_dir: base_dir.join("store"),
            logs_dir: base_dir.join("logs"),
            base_dir,
        })
    }

    pub fn ensure(&self) -> Result<()> {
        fs::create_dir_all(&self.base_dir)
            .with_context(|| format!("creating {}", self.base_dir.display()))?;
        fs::create_dir_all(&self.managed_store_dir)
            .with_context(|| format!("creating {}", self.managed_store_dir.display()))?;
        fs::create_dir_all(&self.logs_dir)
            .with_context(|| format!("creating {}", self.logs_dir.display()))?;
        Ok(())
    }

    pub fn ensure_parent(path: &Path) -> Result<()> {
        if let Some(parent) = path.parent() {
            fs::create_dir_all(parent).with_context(|| format!("creating {}", parent.display()))?;
        }
        Ok(())
    }
}
