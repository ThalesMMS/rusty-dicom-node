use std::{
    fs::{self, File},
    io::{Read, Write},
    path::{Path, PathBuf},
};

use anyhow::Context;

use crate::error::Result;

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct ObjectLocator {
    pub study_instance_uid: String,
    pub series_instance_uid: String,
    pub sop_instance_uid: String,
}

impl ObjectLocator {
    pub fn new(
        study_instance_uid: impl Into<String>,
        series_instance_uid: impl Into<String>,
        sop_instance_uid: impl Into<String>,
    ) -> Self {
        Self {
            study_instance_uid: study_instance_uid.into(),
            series_instance_uid: series_instance_uid.into(),
            sop_instance_uid: sop_instance_uid.into(),
        }
    }
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct StoredObjectRef {
    pub path: PathBuf,
    pub size_bytes: u64,
}

impl StoredObjectRef {
    pub fn from_path(path: impl Into<PathBuf>, size_bytes: u64) -> Self {
        Self {
            path: path.into(),
            size_bytes,
        }
    }
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct ObjectMetadata {
    pub path: PathBuf,
    pub size_bytes: u64,
}

pub trait ObjectReadStore {
    fn head(&self, object: &StoredObjectRef) -> Result<Option<ObjectMetadata>>;
    fn open(&self, object: &StoredObjectRef) -> Result<Box<dyn Read + Send>>;
}

pub trait ObjectWriteStore {
    fn begin_write(&self, locator: &ObjectLocator) -> Result<ObjectWriteSession>;
    fn delete(&self, object: &StoredObjectRef) -> Result<()>;
}

pub trait ObjectStore: ObjectReadStore + ObjectWriteStore {}

impl<T> ObjectStore for T where T: ObjectReadStore + ObjectWriteStore {}

#[derive(Debug)]
pub struct ObjectWriteSession {
    final_path: PathBuf,
    partial_path: PathBuf,
    file: Option<File>,
    committed: bool,
}

impl ObjectWriteSession {
    pub(crate) fn create(final_path: PathBuf, partial_path: PathBuf) -> Result<Self> {
        if let Some(parent) = partial_path.parent() {
            fs::create_dir_all(parent).with_context(|| format!("creating {}", parent.display()))?;
        }
        let file = File::create(&partial_path)
            .with_context(|| format!("creating {}", partial_path.display()))?;
        Ok(Self {
            final_path,
            partial_path,
            file: Some(file),
            committed: false,
        })
    }

    pub fn write_chunk(&mut self, chunk: &[u8]) -> Result<()> {
        let file = self
            .file
            .as_mut()
            .context("object write session is already closed")?;
        file.write_all(chunk)
            .with_context(|| format!("writing {}", self.partial_path.display()))?;
        Ok(())
    }

    pub fn commit(mut self) -> Result<StoredObjectRef> {
        if let Some(mut file) = self.file.take() {
            file.flush()
                .with_context(|| format!("flushing {}", self.partial_path.display()))?;
        }

        fs::rename(&self.partial_path, &self.final_path).with_context(|| {
            format!(
                "renaming {} -> {}",
                self.partial_path.display(),
                self.final_path.display()
            )
        })?;
        let size_bytes = fs::metadata(&self.final_path)
            .with_context(|| format!("reading metadata for {}", self.final_path.display()))?
            .len();
        self.committed = true;
        Ok(StoredObjectRef::from_path(
            self.final_path.clone(),
            size_bytes,
        ))
    }

    pub fn abort(mut self) -> Result<()> {
        self.file.take();
        remove_partial(&self.partial_path)?;
        self.committed = true;
        Ok(())
    }
}

impl Drop for ObjectWriteSession {
    fn drop(&mut self) {
        if !self.committed {
            self.file.take();
            let _ = remove_partial(&self.partial_path);
        }
    }
}

fn remove_partial(path: &Path) -> Result<()> {
    match fs::remove_file(path) {
        Ok(()) => Ok(()),
        Err(err) if err.kind() == std::io::ErrorKind::NotFound => Ok(()),
        Err(err) => Err(err).with_context(|| format!("removing {}", path.display())),
    }
}
