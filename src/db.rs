use std::path::{Path, PathBuf};

use anyhow::Context;
use rusqlite::{params, Connection, OptionalExtension};

use crate::{
    error::Result,
    models::{LocalInstance, RemoteNode, SeriesSummary, StudySummary},
};

pub fn update_managed_paths(
    db_path: impl AsRef<Path>,
    old_base_dir: impl AsRef<Path>,
    new_base_dir: impl AsRef<Path>,
) -> Result<usize> {
    let db_path = db_path.as_ref();
    let old_base_dir = old_base_dir.as_ref().to_string_lossy().to_string();
    let new_base_dir = new_base_dir.as_ref().to_string_lossy().to_string();
    let old_base_like = format!("{old_base_dir}%");

    let conn = Connection::open(db_path)
        .with_context(|| format!("opening database {}", db_path.display()))?;
    let updated = conn
        .execute(
            r#"
            UPDATE local_instances
            SET managed_path = replace(managed_path, ?1, ?2)
            WHERE managed_path LIKE ?3
            "#,
            params![old_base_dir, new_base_dir, old_base_like],
        )
        .with_context(|| format!("updating managed paths in {}", db_path.display()))?;
    Ok(updated)
}

#[derive(Debug, Clone)]
pub struct Database {
    path: PathBuf,
}

impl Database {
    pub fn open(path: impl AsRef<Path>) -> Result<Self> {
        let db = Self {
            path: path.as_ref().to_path_buf(),
        };
        db.init()?;
        Ok(db)
    }

    fn connection(&self) -> Result<Connection> {
        let conn = Connection::open(&self.path)
            .with_context(|| format!("opening database {}", self.path.display()))?;
        Ok(conn)
    }

    pub fn init(&self) -> Result<()> {
        let conn = self.connection()?;
        conn.execute_batch(
            r#"
            PRAGMA journal_mode = WAL;
            PRAGMA foreign_keys = ON;

            CREATE TABLE IF NOT EXISTS remote_nodes (
                id TEXT PRIMARY KEY,
                -- Names are stored normalized (lowercase); NOCASE keeps uniqueness aligned with lookup semantics.
                name TEXT NOT NULL COLLATE NOCASE UNIQUE,
                ae_title TEXT NOT NULL,
                host TEXT NOT NULL,
                port INTEGER NOT NULL,
                preferred_move_destination TEXT,
                use_tls INTEGER NOT NULL DEFAULT 0,
                notes TEXT,
                created_at TEXT NOT NULL,
                updated_at TEXT NOT NULL
            );

            CREATE TABLE IF NOT EXISTS local_instances (
                sop_instance_uid TEXT PRIMARY KEY,
                study_instance_uid TEXT NOT NULL,
                series_instance_uid TEXT NOT NULL,
                sop_class_uid TEXT NOT NULL,
                transfer_syntax_uid TEXT,
                patient_id TEXT,
                patient_name TEXT,
                accession_number TEXT,
                study_date TEXT,
                study_description TEXT,
                series_description TEXT,
                series_number TEXT,
                modality TEXT,
                instance_number TEXT,
                file_size_bytes INTEGER NOT NULL,
                sha256 TEXT NOT NULL,
                source_path TEXT NOT NULL,
                managed_path TEXT NOT NULL,
                imported_at TEXT NOT NULL
            );

            -- Existing databases keep their original table definition, so this
            -- backfills NOCASE uniqueness when `CREATE TABLE IF NOT EXISTS`
            -- does not rewrite the legacy schema.
            CREATE UNIQUE INDEX IF NOT EXISTS idx_remote_nodes_name_nocase
                ON remote_nodes(name COLLATE NOCASE);

            CREATE INDEX IF NOT EXISTS idx_instances_study_uid
                ON local_instances(study_instance_uid);

            CREATE INDEX IF NOT EXISTS idx_instances_series_uid
                ON local_instances(series_instance_uid);

            CREATE INDEX IF NOT EXISTS idx_instances_sha256
                ON local_instances(sha256);
            "#,
        )?;
        Ok(())
    }

    pub fn list_remote_nodes(&self) -> Result<Vec<RemoteNode>> {
        let conn = self.connection()?;
        let mut stmt = conn.prepare(
            r#"
            SELECT id, name, ae_title, host, port, preferred_move_destination, notes, created_at, updated_at
            FROM remote_nodes
            ORDER BY name COLLATE NOCASE
            "#,
        )?;
        let rows = stmt.query_map([], map_remote_node)?;
        let mut out = Vec::new();
        for row in rows {
            out.push(row?);
        }
        Ok(out)
    }

    pub fn get_remote_node(&self, id_or_name: &str) -> Result<Option<RemoteNode>> {
        let conn = self.connection()?;
        conn.query_row(
            r#"
            SELECT id, name, ae_title, host, port, preferred_move_destination, notes, created_at, updated_at
            FROM remote_nodes
            WHERE id = ?1 OR name = ?1 COLLATE NOCASE
            ORDER BY CASE WHEN id = ?1 THEN 0 ELSE 1 END
            LIMIT 1
            "#,
            params![id_or_name],
            map_remote_node,
        )
        .optional()
        .map_err(Into::into)
    }

    pub fn upsert_remote_node(&self, node: &RemoteNode) -> Result<()> {
        let conn = self.connection()?;
        conn.execute(
            r#"
            INSERT INTO remote_nodes (
                id, name, ae_title, host, port, preferred_move_destination, notes, created_at, updated_at
            ) VALUES (?1, ?2, ?3, ?4, ?5, ?6, ?7, ?8, ?9)
            ON CONFLICT(id) DO UPDATE SET
                name = excluded.name,
                ae_title = excluded.ae_title,
                host = excluded.host,
                port = excluded.port,
                preferred_move_destination = excluded.preferred_move_destination,
                notes = excluded.notes,
                updated_at = excluded.updated_at
            "#,
            params![
                node.id,
                node.name,
                node.ae_title,
                node.host,
                node.port,
                node.preferred_move_destination,
                node.notes,
                node.created_at,
                node.updated_at,
            ],
        )?;
        Ok(())
    }

    pub fn delete_remote_node(&self, id_or_name: &str) -> Result<usize> {
        let conn = self.connection()?;
        let affected = conn.execute(
            r#"
            DELETE FROM remote_nodes
            WHERE rowid IN (
                SELECT rowid
                FROM remote_nodes
                WHERE id = ?1 OR name = ?1 COLLATE NOCASE
                ORDER BY CASE WHEN id = ?1 THEN 0 ELSE 1 END
                LIMIT 1
            )
            "#,
            params![id_or_name],
        )?;
        Ok(affected)
    }

    pub fn instance_exists(&self, sop_instance_uid: &str, sha256: &str) -> Result<bool> {
        let conn = self.connection()?;
        let exists: i64 = conn.query_row(
            r#"
            SELECT EXISTS(
                SELECT 1
                FROM local_instances
                WHERE sop_instance_uid = ?1 OR sha256 = ?2
            )
            "#,
            params![sop_instance_uid, sha256],
            |row| row.get(0),
        )?;
        Ok(exists != 0)
    }

    pub fn upsert_instance(&self, instance: &LocalInstance) -> Result<()> {
        let conn = self.connection()?;
        conn.execute(
            r#"
            INSERT INTO local_instances (
                sop_instance_uid,
                study_instance_uid,
                series_instance_uid,
                sop_class_uid,
                transfer_syntax_uid,
                patient_id,
                patient_name,
                accession_number,
                study_date,
                study_description,
                series_description,
                series_number,
                modality,
                instance_number,
                file_size_bytes,
                sha256,
                source_path,
                managed_path,
                imported_at
            ) VALUES (
                ?1, ?2, ?3, ?4, ?5, ?6, ?7, ?8, ?9, ?10,
                ?11, ?12, ?13, ?14, ?15, ?16, ?17, ?18, ?19
            )
            ON CONFLICT(sop_instance_uid) DO UPDATE SET
                study_instance_uid = excluded.study_instance_uid,
                series_instance_uid = excluded.series_instance_uid,
                sop_class_uid = excluded.sop_class_uid,
                transfer_syntax_uid = excluded.transfer_syntax_uid,
                patient_id = excluded.patient_id,
                patient_name = excluded.patient_name,
                accession_number = excluded.accession_number,
                study_date = excluded.study_date,
                study_description = excluded.study_description,
                series_description = excluded.series_description,
                series_number = excluded.series_number,
                modality = excluded.modality,
                instance_number = excluded.instance_number,
                file_size_bytes = excluded.file_size_bytes,
                sha256 = excluded.sha256,
                source_path = excluded.source_path,
                managed_path = excluded.managed_path,
                imported_at = excluded.imported_at
            "#,
            params![
                instance.sop_instance_uid,
                instance.study_instance_uid,
                instance.series_instance_uid,
                instance.sop_class_uid,
                instance.transfer_syntax_uid,
                instance.patient_id,
                instance.patient_name,
                instance.accession_number,
                instance.study_date,
                instance.study_description,
                instance.series_description,
                instance.series_number,
                instance.modality,
                instance.instance_number,
                instance.file_size_bytes as i64,
                instance.sha256,
                instance.source_path,
                instance.managed_path,
                instance.imported_at,
            ],
        )?;
        Ok(())
    }

    pub fn list_studies(&self) -> Result<Vec<StudySummary>> {
        let conn = self.connection()?;
        let mut stmt = conn.prepare(
            r#"
            SELECT
                study_instance_uid,
                MAX(patient_name) AS patient_name,
                MAX(patient_id) AS patient_id,
                MAX(study_date) AS study_date,
                MAX(study_description) AS study_description,
                GROUP_CONCAT(DISTINCT modality) AS modalities,
                COUNT(DISTINCT series_instance_uid) AS series_count,
                COUNT(*) AS instance_count
            FROM local_instances
            GROUP BY study_instance_uid
            ORDER BY COALESCE(MAX(study_date), '') DESC, study_instance_uid
            "#,
        )?;
        let rows = stmt.query_map([], |row| {
            Ok(StudySummary {
                study_instance_uid: row.get(0)?,
                patient_name: row.get(1)?,
                patient_id: row.get(2)?,
                study_date: row.get(3)?,
                study_description: row.get(4)?,
                modalities: row.get(5)?,
                series_count: row.get(6)?,
                instance_count: row.get(7)?,
            })
        })?;

        let mut out = Vec::new();
        for row in rows {
            out.push(row?);
        }
        Ok(out)
    }

    pub fn list_series_for_study(&self, study_instance_uid: &str) -> Result<Vec<SeriesSummary>> {
        let conn = self.connection()?;
        let series_number_order = sqlite_integer_text_order("MAX(series_number)");
        let query = format!(
            r#"
            SELECT
                study_instance_uid,
                series_instance_uid,
                MAX(modality) AS modality,
                MAX(series_number) AS series_number,
                MAX(series_description) AS series_description,
                COUNT(*) AS instance_count
            FROM local_instances
            WHERE study_instance_uid = ?1
            GROUP BY study_instance_uid, series_instance_uid
            ORDER BY {series_number_order}, series_instance_uid
            "#
        );
        let mut stmt = conn.prepare(&query)?;
        let rows = stmt.query_map(params![study_instance_uid], |row| {
            Ok(SeriesSummary {
                study_instance_uid: row.get(0)?,
                series_instance_uid: row.get(1)?,
                modality: row.get(2)?,
                series_number: row.get(3)?,
                series_description: row.get(4)?,
                instance_count: row.get(5)?,
            })
        })?;

        let mut out = Vec::new();
        for row in rows {
            out.push(row?);
        }
        Ok(out)
    }

    pub fn study_files(&self, study_instance_uid: &str) -> Result<Vec<PathBuf>> {
        let conn = self.connection()?;
        let series_number_order = sqlite_integer_text_order("series_number");
        let instance_number_order = sqlite_integer_text_order("instance_number");
        let query = format!(
            r#"
            SELECT managed_path
            FROM local_instances
            WHERE study_instance_uid = ?1
            ORDER BY {series_number_order}, series_instance_uid, {instance_number_order}, sop_instance_uid
            "#
        );
        let mut stmt = conn.prepare(&query)?;
        let rows = stmt.query_map(params![study_instance_uid], |row| row.get::<_, String>(0))?;
        let mut out = Vec::new();
        for row in rows {
            out.push(PathBuf::from(row?));
        }
        Ok(out)
    }

    pub fn series_files(&self, series_instance_uid: &str) -> Result<Vec<PathBuf>> {
        let conn = self.connection()?;
        let instance_number_order = sqlite_integer_text_order("instance_number");
        let query = format!(
            r#"
            SELECT managed_path
            FROM local_instances
            WHERE series_instance_uid = ?1
            ORDER BY {instance_number_order}, sop_instance_uid
            "#
        );
        let mut stmt = conn.prepare(&query)?;
        let rows = stmt.query_map(params![series_instance_uid], |row| row.get::<_, String>(0))?;
        let mut out = Vec::new();
        for row in rows {
            out.push(PathBuf::from(row?));
        }
        Ok(out)
    }
}

/// `sqlite_integer_text_order` builds an ORDER BY fragment that sorts numeric
/// values first, then non-numeric text, then `NULL`. Numeric values are
/// compared by `CAST(TRIM(column) AS INTEGER)`, and the original text is kept
/// as the final tie-breaker for stable ordering.
///
/// Safety: `column` must be a trusted SQL expression from this module, not
/// user-supplied input, because `sqlite_integer_text_order` emits raw SQL.
fn sqlite_integer_text_order(column: &str) -> String {
    let trimmed = format!("TRIM({column})");
    let is_numeric = format!(
        "{trimmed} <> '' AND ({trimmed} NOT GLOB '*[^0-9]*' OR ((({trimmed} GLOB '-*') OR ({trimmed} GLOB '+*')) AND substr({trimmed}, 2) <> '' AND substr({trimmed}, 2) NOT GLOB '*[^0-9]*'))"
    );

    format!(
        "CASE WHEN {column} IS NULL THEN 2 WHEN {is_numeric} THEN 0 ELSE 1 END, \
         CASE WHEN {is_numeric} THEN CAST({trimmed} AS INTEGER) END, \
         {column}"
    )
}

fn map_remote_node(row: &rusqlite::Row<'_>) -> rusqlite::Result<RemoteNode> {
    Ok(RemoteNode {
        id: row.get(0)?,
        name: row.get(1)?,
        ae_title: row.get(2)?,
        host: row.get(3)?,
        port: row.get(4)?,
        preferred_move_destination: row.get(5)?,
        notes: row.get(6)?,
        created_at: row.get(7)?,
        updated_at: row.get(8)?,
    })
}

#[cfg(test)]
mod tests {
    use super::{update_managed_paths, Database};
    use crate::models::{LocalInstance, RemoteNode};
    use rusqlite::{Connection, ErrorCode};
    use std::{
        fs,
        path::{Path, PathBuf},
        process,
        sync::atomic::{AtomicU64, Ordering},
        time::{SystemTime, UNIX_EPOCH},
    };

    static TEMP_DIR_COUNTER: AtomicU64 = AtomicU64::new(0);

    fn unique_temp_dir(prefix: &str) -> PathBuf {
        std::env::temp_dir().join(format!(
            "{prefix}-{}-{}-{}",
            process::id(),
            TEMP_DIR_COUNTER.fetch_add(1, Ordering::Relaxed),
            SystemTime::now()
                .duration_since(UNIX_EPOCH)
                .expect("system clock before unix epoch")
                .as_nanos()
        ))
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

    fn sample_instance_with_numbers(
        managed_path: &Path,
        series_instance_uid: &str,
        sop_instance_uid: &str,
        series_number: Option<&str>,
        instance_number: Option<&str>,
    ) -> LocalInstance {
        let mut instance = sample_instance(managed_path);
        instance.series_instance_uid = series_instance_uid.to_string();
        instance.sop_instance_uid = sop_instance_uid.to_string();
        instance.series_number = series_number.map(str::to_string);
        instance.instance_number = instance_number.map(str::to_string);
        instance.sha256 = format!("sha256-{sop_instance_uid}");
        instance.source_path = format!("/source/{sop_instance_uid}.dcm");
        instance
    }

    fn sample_remote_node(id: &str, name: &str) -> RemoteNode {
        RemoteNode {
            id: id.to_string(),
            name: name.to_string(),
            ae_title: "PACS".to_string(),
            host: "127.0.0.1".to_string(),
            port: 104,
            preferred_move_destination: None,
            notes: None,
            created_at: "2026-04-16T00:00:00Z".to_string(),
            updated_at: "2026-04-16T00:00:00Z".to_string(),
        }
    }

    fn assert_unique_constraint(error: anyhow::Error) {
        let sqlite_error = error
            .downcast::<rusqlite::Error>()
            .expect("error should retain the underlying rusqlite error");
        match sqlite_error {
            rusqlite::Error::SqliteFailure(sqlite_error, _) => {
                assert_eq!(sqlite_error.code, ErrorCode::ConstraintViolation);
                assert_eq!(
                    sqlite_error.extended_code,
                    rusqlite::ffi::SQLITE_CONSTRAINT_UNIQUE
                );
            }
            other => panic!("unexpected sqlite error type: {other:?}"),
        }
    }

    #[test]
    fn remote_node_name_lookup_and_delete_are_case_insensitive() {
        let root = unique_temp_dir("rusty-dicom-node-db-test");
        let db_path = root.join("rusty-dicom-node.sqlite3");
        fs::create_dir_all(&root).expect("create temp dir");
        let db = Database::open(&db_path).expect("open temp db");

        db.upsert_remote_node(&sample_remote_node("node-1", "pacs"))
            .expect("insert remote node");

        let found = db
            .get_remote_node("PACS")
            .expect("lookup remote node")
            .expect("remote node exists");
        assert_eq!(found.name, "pacs");

        let deleted = db
            .delete_remote_node("PACS")
            .expect("delete remote node by mixed-case name");
        assert_eq!(deleted, 1);
        assert!(db
            .get_remote_node("pacs")
            .expect("lookup deleted remote node")
            .is_none());

        let _ = fs::remove_dir_all(root);
    }

    #[test]
    fn remote_node_names_are_unique_case_insensitively() {
        let root = unique_temp_dir("rusty-dicom-node-db-test");
        let db_path = root.join("rusty-dicom-node.sqlite3");
        fs::create_dir_all(&root).expect("create temp dir");
        let db = Database::open(&db_path).expect("open temp db");

        db.upsert_remote_node(&sample_remote_node("node-1", "pacs"))
            .expect("insert remote node");
        let error = db
            .upsert_remote_node(&sample_remote_node("node-2", "PACS"))
            .expect_err("case-insensitive duplicate should be rejected");

        assert_unique_constraint(error);

        let _ = fs::remove_dir_all(root);
    }

    #[test]
    fn init_backfills_nocase_uniqueness_for_legacy_remote_nodes_table() {
        let root = unique_temp_dir("rusty-dicom-node-db-test");
        let db_path = root.join("rusty-dicom-node.sqlite3");
        fs::create_dir_all(&root).expect("create temp dir");

        let conn = Connection::open(&db_path).expect("open legacy db");
        conn.execute_batch(
            r#"
            CREATE TABLE remote_nodes (
                id TEXT PRIMARY KEY,
                name TEXT NOT NULL UNIQUE,
                ae_title TEXT NOT NULL,
                host TEXT NOT NULL,
                port INTEGER NOT NULL,
                preferred_move_destination TEXT,
                use_tls INTEGER NOT NULL DEFAULT 0,
                notes TEXT,
                created_at TEXT NOT NULL,
                updated_at TEXT NOT NULL
            );

            CREATE INDEX idx_remote_nodes_name
                ON remote_nodes(name);
            "#,
        )
        .expect("create legacy schema");
        drop(conn);

        let db = Database::open(&db_path).expect("open db through current init");
        db.upsert_remote_node(&sample_remote_node("node-1", "pacs"))
            .expect("insert remote node");
        let error = db
            .upsert_remote_node(&sample_remote_node("node-2", "PACS"))
            .expect_err("legacy schema should gain NOCASE uniqueness during init");

        assert_unique_constraint(error);

        let _ = fs::remove_dir_all(root);
    }

    #[test]
    fn lookup_and_delete_prefer_id_matches_over_name_matches() {
        let root = unique_temp_dir("rusty-dicom-node-db-test");
        let db_path = root.join("rusty-dicom-node.sqlite3");
        fs::create_dir_all(&root).expect("create temp dir");
        let db = Database::open(&db_path).expect("open temp db");

        let id = "123e4567-e89b-12d3-a456-426614174000";
        db.upsert_remote_node(&sample_remote_node(id, "pacs"))
            .expect("insert id-matching node");
        db.upsert_remote_node(&sample_remote_node("node-2", id))
            .expect("insert name-matching node");

        let found = db
            .get_remote_node(id)
            .expect("lookup node by ambiguous identifier")
            .expect("matching node exists");
        assert_eq!(found.id, id);

        let deleted = db
            .delete_remote_node(id)
            .expect("delete should target only the id match");
        assert_eq!(deleted, 1);
        assert!(db
            .get_remote_node(id)
            .expect("lookup name-matching node after delete")
            .is_some());

        let _ = fs::remove_dir_all(root);
    }

    #[test]
    fn update_managed_paths_rewrites_legacy_prefix() {
        let root = unique_temp_dir("rusty-dicom-node-db-test");
        let old_base_dir = root.join("old");
        let new_base_dir = root.join("new");
        let db_path = new_base_dir.join("rusty-dicom-node.sqlite3");
        fs::create_dir_all(&new_base_dir).expect("create new base dir");

        let original_managed_path = old_base_dir.join("store/study/instance.dcm");
        let db = Database::open(&db_path).expect("open temp db");
        db.upsert_instance(&sample_instance(&original_managed_path))
            .expect("insert local instance");

        let updated =
            update_managed_paths(&db_path, &old_base_dir, &new_base_dir).expect("rewrite paths");
        assert_eq!(updated, 1);

        let files = db.study_files("study").expect("read study files");
        assert_eq!(files, vec![new_base_dir.join("store/study/instance.dcm")]);

        let _ = fs::remove_dir_all(root);
    }

    #[test]
    fn list_series_for_study_orders_series_numerically() {
        let root = unique_temp_dir("rusty-dicom-node-db-test");
        let db_path = root.join("rusty-dicom-node.sqlite3");
        fs::create_dir_all(&root).expect("create temp dir");
        let db = Database::open(&db_path).expect("open temp db");

        for (series_uid, series_number) in [
            ("series-10", "10"),
            ("series-2", "2"),
            ("series-20", "20"),
            ("series-1", "1"),
        ] {
            let managed_path = root.join(format!("{series_uid}.dcm"));
            db.upsert_instance(&sample_instance_with_numbers(
                &managed_path,
                series_uid,
                &format!("instance-{series_uid}"),
                Some(series_number),
                Some("1"),
            ))
            .expect("insert local instance");
        }

        let series = db
            .list_series_for_study("study")
            .expect("read study series");
        let series_numbers: Vec<_> = series
            .iter()
            .map(|series| series.series_number.as_deref())
            .collect();

        assert_eq!(
            series_numbers,
            vec![Some("1"), Some("2"), Some("10"), Some("20")]
        );

        let _ = fs::remove_dir_all(root);
    }

    #[test]
    fn study_files_orders_instances_numerically() {
        let root = unique_temp_dir("rusty-dicom-node-db-test");
        let db_path = root.join("rusty-dicom-node.sqlite3");
        fs::create_dir_all(&root).expect("create temp dir");
        let db = Database::open(&db_path).expect("open temp db");

        let fixtures = [
            (
                "series-1-uid",
                "instance-series-2-10",
                Some("2"),
                Some("10"),
            ),
            ("series-2-uid", "instance-series-1-2", Some("1"), Some("2")),
            (
                "series-2-uid",
                "instance-series-1-10",
                Some("1"),
                Some("10"),
            ),
            ("series-1-uid", "instance-series-2-1", Some("2"), Some("1")),
            ("series-2-uid", "instance-series-1-1", Some("1"), Some("1")),
            ("series-1-uid", "instance-series-2-2", Some("2"), Some("2")),
        ];

        let expected_paths: Vec<_> = [
            "instance-series-1-1",
            "instance-series-1-2",
            "instance-series-1-10",
            "instance-series-2-1",
            "instance-series-2-2",
            "instance-series-2-10",
        ]
        .into_iter()
        .map(|name| root.join(format!("{name}.dcm")))
        .collect();

        for (series_uid, sop_uid, series_number, instance_number) in fixtures {
            let managed_path = root.join(format!("{sop_uid}.dcm"));
            db.upsert_instance(&sample_instance_with_numbers(
                &managed_path,
                series_uid,
                sop_uid,
                series_number,
                instance_number,
            ))
            .expect("insert local instance");
        }

        let files = db.study_files("study").expect("read study files");
        assert_eq!(files, expected_paths);

        let _ = fs::remove_dir_all(root);
    }

    #[test]
    fn series_files_orders_instances_numerically() {
        let root = unique_temp_dir("rusty-dicom-node-db-test");
        let db_path = root.join("rusty-dicom-node.sqlite3");
        fs::create_dir_all(&root).expect("create temp dir");
        let db = Database::open(&db_path).expect("open temp db");

        for (sop_uid, instance_number) in [
            ("instance-10", "10"),
            ("instance-2", "2"),
            ("instance-20", "20"),
            ("instance-1", "1"),
        ] {
            let managed_path = root.join(format!("{sop_uid}.dcm"));
            db.upsert_instance(&sample_instance_with_numbers(
                &managed_path,
                "series",
                sop_uid,
                Some("1"),
                Some(instance_number),
            ))
            .expect("insert local instance");
        }

        let files = db.series_files("series").expect("read series files");
        assert_eq!(
            files,
            vec![
                root.join("instance-1.dcm"),
                root.join("instance-2.dcm"),
                root.join("instance-10.dcm"),
                root.join("instance-20.dcm"),
            ]
        );

        let _ = fs::remove_dir_all(root);
    }

    #[test]
    fn list_series_for_study_orders_numeric_values_before_non_numeric_and_null() {
        let root = unique_temp_dir("rusty-dicom-node-db-test");
        let db_path = root.join("rusty-dicom-node.sqlite3");
        fs::create_dir_all(&root).expect("create temp dir");
        let db = Database::open(&db_path).expect("open temp db");

        let fixtures = [
            ("series-null", None),
            ("series-non-numeric", Some("zeta")),
            ("series-10", Some("10")),
            ("series-empty", Some("")),
            ("series-2", Some("2")),
        ];

        for (series_uid, series_number) in fixtures {
            let managed_path = root.join(format!("{series_uid}.dcm"));
            db.upsert_instance(&sample_instance_with_numbers(
                &managed_path,
                series_uid,
                &format!("instance-{series_uid}"),
                series_number,
                Some("1"),
            ))
            .expect("insert local instance");
        }

        let series = db
            .list_series_for_study("study")
            .expect("read study series");
        let ordered_numbers: Vec<_> = series
            .iter()
            .map(|series| series.series_number.as_deref())
            .collect();

        assert_eq!(
            ordered_numbers,
            vec![Some("2"), Some("10"), Some(""), Some("zeta"), None]
        );

        let _ = fs::remove_dir_all(root);
    }
}
