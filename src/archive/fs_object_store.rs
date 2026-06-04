use std::{
    fs::{self, File},
    io::Read,
    path::{Path, PathBuf},
};

use anyhow::Context;

use crate::{dicom::managed_file_path, error::Result};

use super::{
    ObjectLocator, ObjectMetadata, ObjectReadStore, ObjectWriteSession, ObjectWriteStore,
    StoredObjectRef,
};

#[derive(Debug, Clone)]
pub struct FsObjectStore {
    root: PathBuf,
}

impl FsObjectStore {
    pub fn new(root: impl AsRef<Path>) -> Self {
        Self {
            root: root.as_ref().to_path_buf(),
        }
    }

    pub fn root(&self) -> &Path {
        &self.root
    }

    fn path_for(&self, locator: &ObjectLocator) -> PathBuf {
        managed_file_path(
            &self.root,
            &locator.study_instance_uid,
            &locator.series_instance_uid,
            &locator.sop_instance_uid,
        )
    }
}

impl ObjectReadStore for FsObjectStore {
    fn head(&self, object: &StoredObjectRef) -> Result<Option<ObjectMetadata>> {
        match fs::metadata(&object.path) {
            Ok(metadata) => Ok(Some(ObjectMetadata {
                path: object.path.clone(),
                size_bytes: metadata.len(),
            })),
            Err(err) if err.kind() == std::io::ErrorKind::NotFound => Ok(None),
            Err(err) => Err(err).with_context(|| format!("reading {}", object.path.display())),
        }
    }

    fn open(&self, object: &StoredObjectRef) -> Result<Box<dyn Read + Send>> {
        let file = File::open(&object.path)
            .with_context(|| format!("opening {}", object.path.display()))?;
        Ok(Box::new(file))
    }
}

impl ObjectWriteStore for FsObjectStore {
    fn begin_write(&self, locator: &ObjectLocator) -> Result<ObjectWriteSession> {
        let final_path = self.path_for(locator);
        let partial_path = final_path.with_extension("dcm.partial");
        ObjectWriteSession::create(final_path, partial_path)
    }

    fn delete(&self, object: &StoredObjectRef) -> Result<()> {
        match fs::remove_file(&object.path) {
            Ok(()) => Ok(()),
            Err(err) if err.kind() == std::io::ErrorKind::NotFound => Ok(()),
            Err(err) => Err(err).with_context(|| format!("removing {}", object.path.display())),
        }
    }
}
