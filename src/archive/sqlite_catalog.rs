use rusqlite::{params, OptionalExtension, Row};

use crate::{
    db::Database,
    error::Result,
    models::{LocalInstance, SeriesSummary, StudySummary},
};

use super::{
    query::archive_query_entry_from_values, ArchiveCatalogRead, ArchiveCatalogWrite, ArchiveQuery,
    ArchiveQueryEntry, ArchiveRecordQuery, RetrieveSelector, StoredObjectRef,
};

#[derive(Debug, Clone)]
pub struct SqliteArchiveCatalog {
    db: Database,
}

impl SqliteArchiveCatalog {
    pub fn new(db: Database) -> Self {
        Self { db }
    }

    pub fn query_dicom(&self, query: &ArchiveQuery) -> Result<Vec<ArchiveQueryEntry>> {
        let compiled = query.compile()?;
        self.db.with_connection(|conn| {
            let mut stmt = conn.prepare(&compiled.sql)?;
            let rows = stmt.query_map(
                rusqlite::params_from_iter(compiled.params.iter().map(String::as_str)),
                |row| {
                    let values = (0..compiled.return_keys.len())
                        .map(|index| row.get::<_, Option<String>>(index))
                        .collect::<rusqlite::Result<Vec<_>>>()?;
                    Ok(archive_query_entry_from_values(
                        compiled.level,
                        &compiled.return_keys,
                        values,
                    ))
                },
            )?;
            let mut out = Vec::new();
            for row in rows {
                out.push(row?);
            }
            Ok(out)
        })
    }
}

impl ArchiveCatalogRead for SqliteArchiveCatalog {
    fn get_study(&self, study_instance_uid: &str) -> Result<Option<StudySummary>> {
        self.db.with_connection(|conn| {
            conn.query_row(
                r#"
                SELECT
                    studies.study_instance_uid,
                    studies.patient_name,
                    studies.patient_id,
                    studies.study_date,
                    studies.study_description,
                    GROUP_CONCAT(DISTINCT series.modality) AS modalities,
                    COUNT(DISTINCT series.series_instance_uid) AS series_count,
                    COUNT(DISTINCT instances.sop_instance_uid) AS instance_count
                FROM studies
                LEFT JOIN series
                    ON series.study_instance_uid = studies.study_instance_uid
                LEFT JOIN instances
                    ON instances.study_instance_uid = studies.study_instance_uid
                WHERE studies.study_instance_uid = ?1
                GROUP BY
                    studies.study_instance_uid,
                    studies.patient_name,
                    studies.patient_id,
                    studies.study_date,
                    studies.study_description
                HAVING COUNT(DISTINCT instances.sop_instance_uid) > 0
                "#,
                params![study_instance_uid],
                |row| {
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
                },
            )
            .optional()
            .map_err(Into::into)
        })
    }

    fn get_series(&self, series_instance_uid: &str) -> Result<Option<SeriesSummary>> {
        self.db.with_connection(|conn| {
            conn.query_row(
                r#"
                SELECT
                    series.study_instance_uid,
                    series.series_instance_uid,
                    series.modality,
                    series.series_number,
                    series.series_description,
                    COUNT(instances.sop_instance_uid) AS instance_count
                FROM series
                LEFT JOIN instances
                    ON instances.series_instance_uid = series.series_instance_uid
                WHERE series.series_instance_uid = ?1
                GROUP BY
                    series.study_instance_uid,
                    series.series_instance_uid,
                    series.modality,
                    series.series_number,
                    series.series_description
                HAVING COUNT(instances.sop_instance_uid) > 0
                "#,
                params![series_instance_uid],
                |row| {
                    Ok(SeriesSummary {
                        study_instance_uid: row.get(0)?,
                        series_instance_uid: row.get(1)?,
                        modality: row.get(2)?,
                        series_number: row.get(3)?,
                        series_description: row.get(4)?,
                        instance_count: row.get(5)?,
                    })
                },
            )
            .optional()
            .map_err(Into::into)
        })
    }

    fn get_instance(&self, sop_instance_uid: &str) -> Result<Option<LocalInstance>> {
        self.db.with_connection(|conn| {
            let sql = local_instance_select_sql("WHERE sop_instance_uid = ?1");
            conn.query_row(&sql, params![sop_instance_uid], map_local_instance)
                .optional()
                .map_err(Into::into)
        })
    }

    fn query(&self, query: ArchiveRecordQuery) -> Result<Vec<LocalInstance>> {
        self.db.with_connection(|conn| {
            let sql = local_instance_select_sql(
                r#"
                WHERE (?1 IS NULL OR study_instance_uid = ?1)
                  AND (?2 IS NULL OR series_instance_uid = ?2)
                  AND (?3 IS NULL OR sop_instance_uid = ?3)
                ORDER BY
                    series_number_sort_class,
                    CASE WHEN series_number_sort_class = 0 THEN series_number_sort_int END,
                    series_number,
                    series_instance_uid,
                    instance_number_sort_class,
                    CASE WHEN instance_number_sort_class = 0 THEN instance_number_sort_int END,
                    instance_number,
                    sop_instance_uid
                "#,
            );
            let mut stmt = conn.prepare(&sql)?;
            let rows = stmt.query_map(
                params![
                    query.study_instance_uid.as_deref(),
                    query.series_instance_uid.as_deref(),
                    query.sop_instance_uid.as_deref(),
                ],
                map_local_instance,
            )?;
            let mut out = Vec::new();
            for row in rows {
                out.push(row?);
            }
            Ok(out)
        })
    }

    fn instances_for_retrieve(&self, selector: RetrieveSelector) -> Result<Vec<LocalInstance>> {
        let query = match selector {
            RetrieveSelector::Study { study_instance_uid } => ArchiveRecordQuery {
                study_instance_uid: Some(study_instance_uid),
                ..ArchiveRecordQuery::default()
            },
            RetrieveSelector::Series {
                series_instance_uid,
            } => ArchiveRecordQuery {
                series_instance_uid: Some(series_instance_uid),
                ..ArchiveRecordQuery::default()
            },
            RetrieveSelector::Instance { sop_instance_uid } => ArchiveRecordQuery {
                sop_instance_uid: Some(sop_instance_uid),
                ..ArchiveRecordQuery::default()
            },
        };
        self.query(query)
    }
}

impl ArchiveCatalogWrite for SqliteArchiveCatalog {
    fn upsert_instance(&self, instance: &LocalInstance) -> Result<()> {
        self.db.upsert_instance(instance)
    }

    fn attach_object(&self, sop_instance_uid: &str, object: &StoredObjectRef) -> Result<bool> {
        self.db.with_connection(|conn| {
            let affected = conn.execute(
                r#"
                UPDATE local_instances
                SET managed_path = ?2,
                    file_size_bytes = ?3
                WHERE sop_instance_uid = ?1
                "#,
                params![
                    sop_instance_uid,
                    object.path.to_string_lossy().as_ref(),
                    object.size_bytes as i64
                ],
            )?;
            conn.execute(
                r#"
                UPDATE instances
                SET object_key = ?2,
                    managed_path = ?2,
                    object_size_bytes = ?3
                WHERE sop_instance_uid = ?1
                "#,
                params![
                    sop_instance_uid,
                    object.path.to_string_lossy().as_ref(),
                    object.size_bytes as i64
                ],
            )?;
            Ok(affected > 0)
        })
    }
}

fn local_instance_select_sql(where_clause: &str) -> String {
    format!(
        r#"
        SELECT
            study_instance_uid,
            series_instance_uid,
            sop_instance_uid,
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
            attributes_json,
            imported_at
        FROM local_instances
        {where_clause}
        "#
    )
}

fn map_local_instance(row: &Row<'_>) -> rusqlite::Result<LocalInstance> {
    Ok(LocalInstance {
        study_instance_uid: row.get(0)?,
        series_instance_uid: row.get(1)?,
        sop_instance_uid: row.get(2)?,
        sop_class_uid: row.get(3)?,
        transfer_syntax_uid: row.get(4)?,
        patient_id: row.get(5)?,
        patient_name: row.get(6)?,
        accession_number: row.get(7)?,
        study_date: row.get(8)?,
        study_description: row.get(9)?,
        series_description: row.get(10)?,
        series_number: row.get(11)?,
        modality: row.get(12)?,
        instance_number: row.get(13)?,
        file_size_bytes: row.get::<_, i64>(14)? as u64,
        sha256: row.get(15)?,
        source_path: row.get(16)?,
        managed_path: row.get(17)?,
        attributes_json: row.get(18)?,
        imported_at: row.get(19)?,
    })
}
