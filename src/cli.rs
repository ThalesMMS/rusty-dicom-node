use std::path::PathBuf;

use clap::{Args, Parser, Subcommand};

use crate::models::{QueryLevel, QueryModel};

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
        #[command(subcommand)]
        command: SendCommand,
    },
    Local {
        #[command(subcommand)]
        command: LocalCommand,
    },
    StorageScp,
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
    Studies,
    Series { study_instance_uid: String },
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
    pub path: PathBuf,
}

#[derive(Debug, Args)]
pub struct QueryArgs {
    #[arg(long)]
    pub node: String,
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
