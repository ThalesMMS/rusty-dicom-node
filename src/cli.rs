use std::path::PathBuf;

use clap::{Args, Parser, Subcommand};

use crate::models::{QueryLevel, QueryModel};

#[derive(Debug, Clone, Copy, clap::ValueEnum)]
pub enum LocalExportFormat {
    Json,
    Csv,
}

#[derive(Debug, Parser)]
#[command(
    name = "dicom-node-client",
    version,
    about = "Terminal-first DICOM node client built with dicom-rs"
)]
pub struct Cli {
    #[command(subcommand)]
    pub command: Option<Commands>,
}

#[derive(Debug, Subcommand)]
pub enum Commands {
    Tui,
    Node {
        #[command(subcommand)]
        command: NodeCommand,
    },
    Import(ImportArgs),
    Query(QueryArgs),
    Retrieve(RetrieveArgs),
    Send {
        /// Output a final operation summary as JSON (stable schema).
        #[arg(long)]
        json: bool,

        #[command(subcommand)]
        command: SendCommand,
    },
    Local {
        #[command(subcommand)]
        command: LocalCommand,
    },
    Serve {
        /// Output a final operation summary as JSON (stable schema).
        #[arg(long)]
        json: bool,

        /// Print the final in-memory server metrics snapshot as JSON when the server exits.
        #[arg(long)]
        metrics_json: bool,
    },
    StorageScp {
        /// Output a final operation summary as JSON (stable schema).
        #[arg(long)]
        json: bool,
    },
}

#[derive(Debug, Subcommand)]
pub enum NodeCommand {
    Add(NodeAddArgs),
    Edit(NodeEditArgs),
    Delete(NodeDeleteArgs),
    List,
}

#[derive(Debug, Subcommand)]
pub enum SendCommand {
    Study(SendStudyArgs),
    Series(SendSeriesArgs),
}

#[derive(Debug, Subcommand)]
pub enum LocalCommand {
    Studies(LocalStudiesArgs),
    Series(LocalSeriesArgs),
}

#[derive(Debug, Args, Default)]
pub struct LocalStudiesArgs {
    /// Export results as JSON or CSV.
    #[arg(long, value_enum)]
    pub export: Option<LocalExportFormat>,

    /// Output file path. If omitted, writes to stdout.
    #[arg(long)]
    pub out: Option<PathBuf>,

    /// Filter by patient name (case-insensitive substring).
    /// Example: --patient-name smith
    #[arg(long)]
    pub patient_name: Option<String>,

    /// Filter by patient ID (case-insensitive substring).
    /// Example: --patient-id 123
    #[arg(long)]
    pub patient_id: Option<String>,

    /// Filter by accession number (case-insensitive substring).
    /// Example: --accession-number ACC-42
    #[arg(long)]
    pub accession_number: Option<String>,

    /// Filter by study description (case-insensitive substring).
    /// Example: --study-description abdomen
    #[arg(long)]
    pub study_description: Option<String>,

    /// Filter by study date. Supports `VALUE`, `START..END`, `..END`, `START..`.
    /// Dates are compared lexicographically (recommended format: YYYYMMDD).
    /// Examples:
    ///   --study-date 20250101
    ///   --study-date 20250101..20250131
    ///   --study-date ..20250131
    ///   --study-date 20250101..
    #[arg(long)]
    pub study_date: Option<String>,

    /// Filter by modality. Comma-separated list (e.g. `CT,MR`).
    /// Example: --modality CT,MR
    #[arg(long)]
    pub modality: Option<String>,

    /// Filter by source path (case-insensitive substring).
    /// Example: --source-path /incoming/site-a/
    #[arg(long)]
    pub source_path: Option<String>,

    /// Filter by import timestamp. Supports `VALUE`, `START..END`, `..END`, `START..`.
    /// Compared lexicographically (recommended format: RFC3339).
    /// Examples:
    ///   --imported-at 2025-01-01T00:00:00Z..
    ///   --imported-at ..2025-01-31T23:59:59Z
    #[arg(long)]
    pub imported_at: Option<String>,

    /// Filter by duplicate status.
    #[arg(long)]
    pub duplicate: Option<bool>,
}

#[derive(Debug, Args)]
pub struct LocalSeriesArgs {
    /// Export results as JSON or CSV.
    #[arg(long, value_enum)]
    pub export: Option<LocalExportFormat>,

    /// Output file path. If omitted, writes to stdout.
    #[arg(long)]
    pub out: Option<PathBuf>,

    pub study_instance_uid: String,

    /// Filter by accession number (case-insensitive substring).
    /// Example: --accession-number ACC-42
    #[arg(long)]
    pub accession_number: Option<String>,

    /// Filter by series description (case-insensitive substring).
    /// Example: --series-description pelvis
    #[arg(long)]
    pub series_description: Option<String>,

    /// Filter by modality. Comma-separated list (e.g. `CT,MR`).
    /// Example: --modality CT,MR
    #[arg(long)]
    pub modality: Option<String>,

    /// Filter by source path (case-insensitive substring).
    /// Example: --source-path /incoming/site-a/
    #[arg(long)]
    pub source_path: Option<String>,

    /// Filter by import timestamp. Supports `VALUE`, `START..END`, `..END`, `START..`.
    /// Compared lexicographically (recommended format: RFC3339).
    /// Examples:
    ///   --imported-at 2025-01-01T00:00:00Z..
    ///   --imported-at ..2025-01-31T23:59:59Z
    #[arg(long)]
    pub imported_at: Option<String>,

    /// Filter by duplicate status.
    #[arg(long)]
    pub duplicate: Option<bool>,
}

#[derive(Debug, Args)]
pub struct NodeAddArgs {
    #[arg(long)]
    pub name: String,
    #[arg(long)]
    pub ae_title: String,
    #[arg(long)]
    pub host: String,
    #[arg(long)]
    pub port: u16,
    #[arg(long)]
    pub move_destination: Option<String>,
    #[arg(long)]
    pub notes: Option<String>,
}

#[derive(Debug, Args)]
pub struct NodeEditArgs {
    pub node: String,
    #[arg(long)]
    pub name: Option<String>,
    #[arg(long)]
    pub ae_title: Option<String>,
    #[arg(long)]
    pub host: Option<String>,
    #[arg(long)]
    pub port: Option<u16>,
    #[arg(long)]
    pub move_destination: Option<String>,
    #[arg(long)]
    pub notes: Option<String>,
}

#[derive(Debug, Args)]
pub struct NodeDeleteArgs {
    pub node: String,
}

#[derive(Debug, Args)]
pub struct ImportArgs {
    /// Output a final operation summary as JSON (stable schema).
    #[arg(long)]
    pub json: bool,

    pub path: PathBuf,
}

#[derive(Debug, Args)]
pub struct QueryArgs {
    #[arg(long)]
    pub node: String,

    /// Output a final operation summary as JSON (stable schema).
    #[arg(long)]
    pub json: bool,
    #[arg(long, value_enum, default_value_t = QueryModel::StudyRoot)]
    pub model: QueryModel,
    #[arg(long, value_enum, default_value_t = QueryLevel::Study)]
    pub level: QueryLevel,
    #[arg(long)]
    pub patient_name: Option<String>,
    #[arg(long)]
    pub patient_id: Option<String>,
    #[arg(long)]
    pub accession_number: Option<String>,
    #[arg(long)]
    pub study_instance_uid: Option<String>,
    #[arg(long)]
    pub series_instance_uid: Option<String>,
    #[arg(long)]
    pub sop_instance_uid: Option<String>,
    #[arg(long)]
    pub study_date_from: Option<String>,
    #[arg(long)]
    pub study_date_to: Option<String>,
    #[arg(long)]
    pub modality: Option<String>,
    #[arg(long)]
    pub study_description: Option<String>,
}

#[derive(Debug, Args)]
pub struct RetrieveArgs {
    #[arg(long)]
    pub node: String,

    /// Output a final operation summary as JSON (stable schema).
    #[arg(long)]
    pub json: bool,

    #[arg(long, value_enum, default_value_t = QueryModel::StudyRoot)]
    pub model: QueryModel,
    #[arg(long, value_enum, default_value_t = QueryLevel::Study)]
    pub level: QueryLevel,
    #[arg(long)]
    pub study_instance_uid: String,
    #[arg(long)]
    pub series_instance_uid: Option<String>,
    #[arg(long)]
    pub sop_instance_uid: Option<String>,
    #[arg(long)]
    pub move_destination: Option<String>,
}

#[derive(Debug, Args)]
pub struct SendStudyArgs {
    #[arg(long)]
    pub study_instance_uid: String,
    #[arg(long)]
    pub destination_node: String,
}

#[derive(Debug, Args)]
pub struct SendSeriesArgs {
    #[arg(long)]
    pub series_instance_uid: String,
    #[arg(long)]
    pub destination_node: String,
}
