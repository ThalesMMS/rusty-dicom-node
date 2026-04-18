use std::{
    ffi::OsString,
    fs::{self, File, OpenOptions},
    io::{self, Write},
    path::{Path, PathBuf},
};

use anyhow::{anyhow, Context};

use super::paths::{legacy_base_dir, AppPaths, LEGACY_SQLITE_DB_FILENAME, SQLITE_DB_FILENAME};
use crate::{db, error::Result};

const LEGACY_MIGRATION_COMPLETE_MARKER: &str = ".legacy-migration-complete";

#[derive(Debug, Clone, PartialEq, Eq)]
pub enum MigrationResult {
    NoLegacyData,
    AlreadyMigrated {
        legacy_base_dir: PathBuf,
        new_base_dir: PathBuf,
    },
    MigrationPerformed {
        legacy_base_dir: PathBuf,
        new_base_dir: PathBuf,
    },
    MigrationRepaired {
        legacy_base_dir: PathBuf,
        new_base_dir: PathBuf,
    },
}

#[derive(Debug, Clone)]
struct MigrationArtifact {
    source: PathBuf,
    destination: PathBuf,
}

impl AppPaths {
    pub fn migrate_from_legacy(&self) -> Result<MigrationResult> {
        let Some(legacy_base_dir) = legacy_base_dir() else {
            return Ok(MigrationResult::NoLegacyData);
        };
        self.migrate_from_legacy_base(&legacy_base_dir)
    }

    fn migrate_from_legacy_base(&self, legacy_base_dir: &Path) -> Result<MigrationResult> {
        if !path_exists(legacy_base_dir)? {
            return Ok(MigrationResult::NoLegacyData);
        }

        let artifacts = self.legacy_migration_artifacts(legacy_base_dir)?;
        if artifacts.is_empty() {
            return Ok(MigrationResult::NoLegacyData);
        }

        let marker = self.legacy_migration_complete_marker();
        let marker_exists = path_exists(&marker)?;

        if marker_exists {
            return Ok(MigrationResult::AlreadyMigrated {
                legacy_base_dir: legacy_base_dir.to_path_buf(),
                new_base_dir: self.base_dir.clone(),
            });
        }

        let existing_artifacts = count_existing_destination_artifacts(&artifacts)?;

        fs::create_dir_all(&self.base_dir)
            .with_context(|| format!("creating {}", self.base_dir.display()))?;

        for artifact in &artifacts {
            copy_missing_path(&artifact.source, &artifact.destination)?;
        }

        if path_exists(&self.sqlite_db)? {
            db::update_managed_paths(&self.sqlite_db, legacy_base_dir, &self.base_dir)
                .with_context(|| {
                    format!("updating managed paths in {}", self.sqlite_db.display())
                })?;
        }

        if !migration_artifacts_complete(&artifacts)? {
            return Err(anyhow!(
                "legacy migration incomplete after copy into {}",
                self.base_dir.display()
            ));
        }

        if !marker_exists {
            write_migration_complete_marker(&marker)?;
        }

        if existing_artifacts == 0 {
            Ok(MigrationResult::MigrationPerformed {
                legacy_base_dir: legacy_base_dir.to_path_buf(),
                new_base_dir: self.base_dir.clone(),
            })
        } else {
            Ok(MigrationResult::MigrationRepaired {
                legacy_base_dir: legacy_base_dir.to_path_buf(),
                new_base_dir: self.base_dir.clone(),
            })
        }
    }

    fn legacy_migration_complete_marker(&self) -> PathBuf {
        self.base_dir.join(LEGACY_MIGRATION_COMPLETE_MARKER)
    }

    fn legacy_migration_artifacts(&self, legacy_base_dir: &Path) -> Result<Vec<MigrationArtifact>> {
        let mut artifacts = Vec::new();
        push_existing_artifact(
            &mut artifacts,
            legacy_base_dir.join("config.json"),
            self.config_json.clone(),
        )?;
        push_existing_artifact(
            &mut artifacts,
            legacy_base_dir.join(LEGACY_SQLITE_DB_FILENAME),
            self.sqlite_db.clone(),
        )?;
        push_existing_artifact(
            &mut artifacts,
            sqlite_sidecar_path(legacy_base_dir, LEGACY_SQLITE_DB_FILENAME, "-wal"),
            sqlite_sidecar_path(&self.base_dir, SQLITE_DB_FILENAME, "-wal"),
        )?;
        push_existing_artifact(
            &mut artifacts,
            sqlite_sidecar_path(legacy_base_dir, LEGACY_SQLITE_DB_FILENAME, "-shm"),
            sqlite_sidecar_path(&self.base_dir, SQLITE_DB_FILENAME, "-shm"),
        )?;
        push_existing_artifact(
            &mut artifacts,
            legacy_base_dir.join("store"),
            self.managed_store_dir.clone(),
        )?;
        push_existing_artifact(
            &mut artifacts,
            legacy_base_dir.join("logs"),
            self.logs_dir.clone(),
        )?;
        Ok(artifacts)
    }
}

fn path_exists(path: &Path) -> Result<bool> {
    path.try_exists()
        .with_context(|| format!("checking whether {} exists", path.display()))
}

fn push_existing_artifact(
    artifacts: &mut Vec<MigrationArtifact>,
    source: PathBuf,
    destination: PathBuf,
) -> Result<()> {
    if path_exists(&source)? {
        artifacts.push(MigrationArtifact {
            source,
            destination,
        });
    }
    Ok(())
}

fn count_complete_artifacts(artifacts: &[MigrationArtifact]) -> Result<usize> {
    artifacts.iter().try_fold(0, |count, artifact| {
        Ok(count + usize::from(artifact_complete(artifact)?))
    })
}

fn count_existing_destination_artifacts(artifacts: &[MigrationArtifact]) -> Result<usize> {
    artifacts.iter().try_fold(0, |count, artifact| {
        Ok(count + usize::from(path_exists(&artifact.destination)?))
    })
}

fn migration_artifacts_complete(artifacts: &[MigrationArtifact]) -> Result<bool> {
    Ok(count_complete_artifacts(artifacts)? == artifacts.len())
}

fn artifact_complete(artifact: &MigrationArtifact) -> Result<bool> {
    path_content_complete(&artifact.source, &artifact.destination)
}

fn path_content_complete(source: &Path, destination: &Path) -> Result<bool> {
    if !path_exists(destination)? {
        return Ok(false);
    }

    let source_metadata = fs::metadata(source)
        .with_context(|| format!("reading metadata for {}", source.display()))?;
    let destination_metadata = fs::metadata(destination)
        .with_context(|| format!("reading metadata for {}", destination.display()))?;

    if source_metadata.is_dir() {
        if !destination_metadata.is_dir() {
            return Ok(false);
        }
        directory_content_complete(source, destination)
    } else if source_metadata.is_file() {
        Ok(destination_metadata.is_file() && source_metadata.len() == destination_metadata.len())
    } else {
        Ok(false)
    }
}

fn directory_content_complete(source: &Path, destination: &Path) -> Result<bool> {
    for entry in
        fs::read_dir(source).with_context(|| format!("reading directory {}", source.display()))?
    {
        let entry =
            entry.with_context(|| format!("reading directory entry in {}", source.display()))?;
        let source_path = entry.path();
        let destination_path = destination.join(entry.file_name());
        if !path_content_complete(&source_path, &destination_path)? {
            return Ok(false);
        }
    }
    Ok(true)
}

fn copy_missing_path(source: &Path, destination: &Path) -> Result<()> {
    if !path_exists(source)? {
        return Ok(());
    }
    if path_content_complete(source, destination)? {
        return Ok(());
    }

    let metadata = fs::metadata(source)
        .with_context(|| format!("reading metadata for {}", source.display()))?;
    if metadata.is_dir() {
        copy_missing_dir_recursive(source, destination)
    } else {
        copy_file_atomically(source, destination)
    }
}

fn copy_missing_dir_recursive(source: &Path, destination: &Path) -> Result<()> {
    if path_exists(destination)? {
        if !destination.is_dir() {
            return Err(anyhow!(
                "expected directory at migration destination {}",
                destination.display()
            ));
        }
    } else {
        fs::create_dir_all(destination)
            .with_context(|| format!("creating {}", destination.display()))?;
    }

    for entry in
        fs::read_dir(source).with_context(|| format!("reading directory {}", source.display()))?
    {
        let entry =
            entry.with_context(|| format!("reading directory entry in {}", source.display()))?;
        let source_path = entry.path();
        let destination_path = destination.join(entry.file_name());
        let file_type = entry
            .file_type()
            .with_context(|| format!("reading file type for {}", source_path.display()))?;
        if file_type.is_dir() {
            copy_missing_dir_recursive(&source_path, &destination_path)?;
        } else if !path_content_complete(&source_path, &destination_path)? {
            copy_file_atomically(&source_path, &destination_path)?;
        }
    }
    Ok(())
}

fn copy_file_atomically(source: &Path, destination: &Path) -> Result<()> {
    AppPaths::ensure_parent(destination)?;
    let temp_destination = temporary_copy_path(destination);
    remove_existing_temp_file(&temp_destination)?;

    let mut source_file =
        File::open(source).with_context(|| format!("opening {}", source.display()))?;
    let mut temp_file = OpenOptions::new()
        .create_new(true)
        .write(true)
        .open(&temp_destination)
        .with_context(|| format!("creating {}", temp_destination.display()))?;
    io::copy(&mut source_file, &mut temp_file).with_context(|| {
        format!(
            "copying {} to {}",
            source.display(),
            temp_destination.display()
        )
    })?;
    temp_file
        .sync_all()
        .with_context(|| format!("syncing {}", temp_destination.display()))?;
    drop(temp_file);

    if !path_content_complete(source, &temp_destination)? {
        let _ = fs::remove_file(&temp_destination);
        return Err(anyhow!(
            "temporary migration copy {} did not match {}",
            temp_destination.display(),
            source.display()
        ));
    }

    rename_temp_into_place(&temp_destination, destination)?;

    if !path_content_complete(source, destination)? {
        return Err(anyhow!(
            "migration copy {} did not match {} after rename",
            destination.display(),
            source.display()
        ));
    }

    Ok(())
}

fn remove_existing_temp_file(path: &Path) -> Result<()> {
    if !path_exists(path)? {
        return Ok(());
    }
    if path.is_dir() {
        fs::remove_dir_all(path).with_context(|| format!("removing {}", path.display()))?;
    } else {
        fs::remove_file(path).with_context(|| format!("removing {}", path.display()))?;
    }
    Ok(())
}

fn rename_temp_into_place(temp_path: &Path, destination: &Path) -> Result<()> {
    match fs::rename(temp_path, destination) {
        Ok(()) => Ok(()),
        Err(rename_error) if path_exists(destination)? && destination.is_file() => {
            fs::remove_file(destination)
                .with_context(|| format!("removing {}", destination.display()))?;
            fs::rename(temp_path, destination).with_context(|| {
                format!(
                    "renaming {} to {} after replace failed: {}",
                    temp_path.display(),
                    destination.display(),
                    rename_error
                )
            })
        }
        Err(rename_error) => Err(rename_error).with_context(|| {
            format!(
                "renaming {} to {}",
                temp_path.display(),
                destination.display()
            )
        }),
    }
}

fn temporary_copy_path(destination: &Path) -> PathBuf {
    let mut file_name = destination
        .file_name()
        .map(OsString::from)
        .unwrap_or_else(|| OsString::from("migration-copy"));
    file_name.push(".tmp");
    destination.with_file_name(file_name)
}

fn write_migration_complete_marker(marker: &Path) -> Result<()> {
    AppPaths::ensure_parent(marker)?;
    let temp_marker = temporary_copy_path(marker);
    remove_existing_temp_file(&temp_marker)?;
    let mut file = OpenOptions::new()
        .create_new(true)
        .write(true)
        .open(&temp_marker)
        .with_context(|| format!("creating {}", temp_marker.display()))?;
    file.write_all(b"legacy migration complete\n")
        .with_context(|| format!("writing {}", temp_marker.display()))?;
    file.sync_all()
        .with_context(|| format!("syncing {}", temp_marker.display()))?;
    drop(file);
    rename_temp_into_place(&temp_marker, marker)?;
    Ok(())
}

fn sqlite_sidecar_path(base_dir: &Path, db_filename: &str, suffix: &str) -> PathBuf {
    base_dir.join(format!("{db_filename}{suffix}"))
}

#[cfg(test)]
mod tests {
    use super::MigrationResult;
    use crate::config::AppPaths;
    use crate::{db::Database, models::LocalInstance};
    use std::{
        fs,
        path::{Path, PathBuf},
    };
    use tempfile::tempdir;

    fn app_paths_for(base_dir: PathBuf) -> AppPaths {
        AppPaths {
            base_dir: base_dir.clone(),
            config_json: base_dir.join("config.json"),
            sqlite_db: base_dir.join("rusty-dicom-node.sqlite3"),
            managed_store_dir: base_dir.join("store"),
            logs_dir: base_dir.join("logs"),
        }
    }

    fn sample_instance(managed_path: &Path) -> LocalInstance {
        LocalInstance {
            study_instance_uid: "study".to_string(),
            series_instance_uid: "series".to_string(),
            sop_instance_uid: "instance".to_string(),
            sop_class_uid: "1.2.840.10008.5.1.4.1.1.2".to_string(),
            transfer_syntax_uid: None,
            patient_id: None,
            patient_name: None,
            accession_number: None,
            study_date: None,
            study_description: None,
            series_description: None,
            series_number: None,
            modality: Some("CT".to_string()),
            instance_number: None,
            file_size_bytes: 42,
            sha256: "sha256".to_string(),
            source_path: "/source/file.dcm".to_string(),
            managed_path: managed_path.to_string_lossy().to_string(),
            imported_at: "2026-04-14T00:00:00Z".to_string(),
        }
    }

    fn migrate_with_legacy_base(paths: &AppPaths, legacy_base_dir: &Path) -> MigrationResult {
        let _override = super::super::paths::test_legacy_base_override::set(legacy_base_dir);
        paths.migrate_from_legacy().expect("migrate legacy data")
    }

    fn write_legacy_data(legacy_base_dir: &Path) -> PathBuf {
        let legacy_store_file = legacy_base_dir.join("store/study/instance.dcm");
        let legacy_log_file = legacy_base_dir.join("logs/app.log");
        let legacy_db = legacy_base_dir.join("dicom-node-client.sqlite3");

        fs::create_dir_all(legacy_store_file.parent().expect("store file parent"))
            .expect("create legacy store");
        fs::create_dir_all(legacy_log_file.parent().expect("log file parent"))
            .expect("create legacy logs");
        fs::write(legacy_base_dir.join("config.json"), "legacy config")
            .expect("write legacy config");
        fs::write(&legacy_store_file, b"legacy dicom").expect("write legacy store file");
        fs::write(&legacy_log_file, b"legacy log").expect("write legacy log file");

        let legacy_database = Database::open(&legacy_db).expect("open legacy database");
        legacy_database
            .upsert_instance(&sample_instance(&legacy_store_file))
            .expect("insert legacy local instance");

        legacy_db
    }

    #[test]
    fn test_migration_no_legacy_data() {
        let root = tempdir().expect("create temp dir");
        let legacy_base_dir = root.path().join("missing-legacy");
        let new_base_dir = root.path().join("new");
        let paths = app_paths_for(new_base_dir.clone());

        let result = migrate_with_legacy_base(&paths, &legacy_base_dir);

        assert_eq!(result, MigrationResult::NoLegacyData);
        paths.ensure().expect("new paths should still be usable");
        assert!(paths.managed_store_dir.exists());
        assert!(paths.logs_dir.exists());
    }

    #[test]
    fn test_migration_legacy_exists_new_empty() {
        let root = tempdir().expect("create temp dir");
        let legacy_base_dir = root.path().join("legacy");
        let new_base_dir = root.path().join("new");
        let paths = app_paths_for(new_base_dir.clone());
        fs::create_dir_all(&paths.base_dir).expect("create empty new base dir");

        let legacy_db = write_legacy_data(&legacy_base_dir);

        let result = migrate_with_legacy_base(&paths, &legacy_base_dir);

        assert_eq!(
            result,
            MigrationResult::MigrationPerformed {
                legacy_base_dir: legacy_base_dir.clone(),
                new_base_dir: new_base_dir.clone()
            }
        );
        assert_eq!(
            fs::read_to_string(&paths.config_json).expect("read migrated config"),
            "legacy config"
        );
        assert!(paths.config_json.exists());
        assert!(paths.sqlite_db.exists());
        assert!(paths.managed_store_dir.join("study/instance.dcm").exists());
        assert!(paths.logs_dir.join("app.log").exists());
        assert!(paths.legacy_migration_complete_marker().exists());
        assert_eq!(
            fs::read_to_string(legacy_base_dir.join("config.json")).expect("read legacy config"),
            "legacy config"
        );
        assert_eq!(
            fs::read(legacy_base_dir.join("store/study/instance.dcm"))
                .expect("read legacy store file"),
            b"legacy dicom"
        );
        assert_eq!(
            fs::read(legacy_base_dir.join("logs/app.log")).expect("read legacy log file"),
            b"legacy log"
        );
        assert!(legacy_db.exists());
    }

    #[test]
    fn test_migration_already_migrated() {
        let root = tempdir().expect("create temp dir");
        let legacy_base_dir = root.path().join("legacy");
        let new_base_dir = root.path().join("new");
        let paths = app_paths_for(new_base_dir.clone());

        write_legacy_data(&legacy_base_dir);
        let first_result = migrate_with_legacy_base(&paths, &legacy_base_dir);
        assert!(matches!(
            first_result,
            MigrationResult::MigrationPerformed { .. }
        ));
        let legacy_config = fs::read_to_string(legacy_base_dir.join("config.json"))
            .expect("read legacy config before already migrated check");
        let new_config =
            fs::read_to_string(&paths.config_json).expect("read new config before already check");

        let result = migrate_with_legacy_base(&paths, &legacy_base_dir);

        assert_eq!(
            result,
            MigrationResult::AlreadyMigrated {
                legacy_base_dir: legacy_base_dir.clone(),
                new_base_dir
            }
        );
        assert_eq!(
            fs::read_to_string(legacy_base_dir.join("config.json")).expect("read legacy config"),
            legacy_config
        );
        assert_eq!(
            fs::read_to_string(&paths.config_json).expect("read new config"),
            new_config
        );
        assert_eq!(
            fs::read(legacy_base_dir.join("store/study/instance.dcm"))
                .expect("read legacy store file"),
            b"legacy dicom"
        );
        assert_eq!(
            fs::read(paths.managed_store_dir.join("study/instance.dcm"))
                .expect("read new store file"),
            b"legacy dicom"
        );
        assert_eq!(
            fs::read(legacy_base_dir.join("logs/app.log")).expect("read legacy log file"),
            b"legacy log"
        );
        assert_eq!(
            fs::read(paths.logs_dir.join("app.log")).expect("read new log file"),
            b"legacy log"
        );
    }

    #[test]
    fn test_migration_repairs_partial_new_location() {
        let root = tempdir().expect("create temp dir");
        let legacy_base_dir = root.path().join("legacy");
        let new_base_dir = root.path().join("new");
        let paths = app_paths_for(new_base_dir);

        write_legacy_data(&legacy_base_dir);
        fs::create_dir_all(&paths.base_dir).expect("create partial new base");
        fs::write(&paths.config_json, "legacy config").expect("write partial config");

        let result = migrate_with_legacy_base(&paths, &legacy_base_dir);

        assert!(matches!(result, MigrationResult::MigrationRepaired { .. }));
        assert!(paths.config_json.exists());
        assert!(paths.sqlite_db.exists());
        assert!(paths.managed_store_dir.join("study/instance.dcm").exists());
        assert!(paths.logs_dir.join("app.log").exists());
        assert!(paths.legacy_migration_complete_marker().exists());
    }

    #[test]
    fn test_migration_repairs_truncated_destination_file() {
        let root = tempdir().expect("create temp dir");
        let legacy_base_dir = root.path().join("legacy");
        let new_base_dir = root.path().join("new");
        let paths = app_paths_for(new_base_dir);

        write_legacy_data(&legacy_base_dir);
        fs::create_dir_all(&paths.base_dir).expect("create partial new base");
        fs::write(&paths.config_json, "bad").expect("write truncated config");

        let result = migrate_with_legacy_base(&paths, &legacy_base_dir);

        assert!(matches!(result, MigrationResult::MigrationRepaired { .. }));
        assert_eq!(
            fs::read_to_string(&paths.config_json).expect("read repaired config"),
            "legacy config"
        );
        assert!(paths.legacy_migration_complete_marker().exists());
    }

    #[test]
    fn test_migration_detects_store_only_legacy_data() {
        let root = tempdir().expect("create temp dir");
        let legacy_base_dir = root.path().join("legacy");
        let new_base_dir = root.path().join("new");
        let paths = app_paths_for(new_base_dir);
        let legacy_store_file = legacy_base_dir.join("store/study/instance.dcm");

        fs::create_dir_all(legacy_store_file.parent().expect("store file parent"))
            .expect("create legacy store");
        fs::write(&legacy_store_file, b"legacy dicom").expect("write legacy store file");

        let result = migrate_with_legacy_base(&paths, &legacy_base_dir);

        assert!(matches!(result, MigrationResult::MigrationPerformed { .. }));
        assert_eq!(
            fs::read(paths.managed_store_dir.join("study/instance.dcm"))
                .expect("read migrated store file"),
            b"legacy dicom"
        );
        assert!(paths.legacy_migration_complete_marker().exists());
    }

    #[test]
    fn test_migration_detects_sqlite_sidecar_only_legacy_data() {
        let root = tempdir().expect("create temp dir");
        let legacy_base_dir = root.path().join("legacy");
        let new_base_dir = root.path().join("new");
        let paths = app_paths_for(new_base_dir);
        let legacy_wal = legacy_base_dir.join("dicom-node-client.sqlite3-wal");

        fs::create_dir_all(&legacy_base_dir).expect("create legacy base");
        fs::write(&legacy_wal, b"legacy wal").expect("write legacy wal");

        let result = migrate_with_legacy_base(&paths, &legacy_base_dir);

        assert!(matches!(result, MigrationResult::MigrationPerformed { .. }));
        assert_eq!(
            fs::read(paths.base_dir.join("rusty-dicom-node.sqlite3-wal"))
                .expect("read migrated wal"),
            b"legacy wal"
        );
        assert!(paths.legacy_migration_complete_marker().exists());
    }

    #[test]
    fn test_migration_updates_database_paths() {
        let root = tempdir().expect("create temp dir");
        let legacy_base_dir = root.path().join("legacy");
        let new_base_dir = root.path().join("new");
        let paths = app_paths_for(new_base_dir);

        write_legacy_data(&legacy_base_dir);

        let result = migrate_with_legacy_base(&paths, &legacy_base_dir);
        assert!(matches!(result, MigrationResult::MigrationPerformed { .. }));

        let migrated_database = Database::open(&paths.sqlite_db).expect("open migrated database");
        let files = migrated_database
            .study_files("study")
            .expect("read migrated study files");
        assert_eq!(
            files,
            vec![paths.managed_store_dir.join("study/instance.dcm")]
        );
    }
}
