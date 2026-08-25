use std::path::PathBuf;

use clap::{Arg, Args, Command, CommandFactory, FromArgMatches, Parser, Subcommand};

use crate::i18n::{self, t};
use crate::models::{QueryLevel, QueryModel};

#[derive(Debug, Clone, Copy, clap::ValueEnum)]
pub enum LocalExportFormat {
    Json,
    Csv,
}

#[derive(Debug, Parser)]
#[command(name = "dicom-node-client", version, about = "cli-about")]
pub struct Cli {
    /// UI language (BCP-47). Parsed from argv before help is printed.
    #[arg(long, global = true, value_name = "cli-value-name-locale", help = "cli-flag-lang")]
    pub lang: Option<String>,

    #[command(subcommand)]
    pub command: Option<Commands>,
}

impl Cli {
    /// Parse argv after resolving `--lang` and localizing clap help/about strings.
    pub fn parse() -> Self {
        i18n::init_from_cli_args();
        let command = localize_command(Self::command());
        Self::from_arg_matches(&command.get_matches()).unwrap_or_else(|err| err.exit())
    }
}

#[derive(Debug, Subcommand)]
pub enum Commands {
    #[command(about = "cli-cmd-tui-about")]
    Tui,
    #[command(about = "cli-cmd-node-about")]
    Node {
        #[command(subcommand)]
        command: NodeCommand,
    },
    #[command(about = "cli-cmd-import-about")]
    Import(ImportArgs),
    #[command(about = "cli-cmd-query-about")]
    Query(QueryArgs),
    #[command(about = "cli-cmd-retrieve-about")]
    Retrieve(RetrieveArgs),
    #[command(about = "cli-cmd-send-about")]
    Send {
        #[arg(long, help = "cli-arg-json")]
        json: bool,

        #[command(subcommand)]
        command: SendCommand,
    },
    #[command(about = "cli-cmd-local-about")]
    Local {
        #[command(subcommand)]
        command: LocalCommand,
    },
    #[command(about = "cli-cmd-serve-about")]
    Serve {
        #[arg(long, help = "cli-arg-json")]
        json: bool,

        #[arg(long, help = "cli-arg-metrics-json")]
        metrics_json: bool,
    },
    #[command(about = "cli-cmd-storage-scp-about")]
    StorageScp {
        #[arg(long, help = "cli-arg-json")]
        json: bool,
    },
}

#[derive(Debug, Subcommand)]
pub enum NodeCommand {
    #[command(about = "cli-cmd-node-add-about")]
    Add(NodeAddArgs),
    #[command(about = "cli-cmd-node-edit-about")]
    Edit(NodeEditArgs),
    #[command(about = "cli-cmd-node-delete-about")]
    Delete(NodeDeleteArgs),
    #[command(about = "cli-cmd-node-list-about")]
    List,
}

#[derive(Debug, Subcommand)]
pub enum SendCommand {
    #[command(about = "cli-cmd-send-study-about")]
    Study(SendStudyArgs),
    #[command(about = "cli-cmd-send-series-about")]
    Series(SendSeriesArgs),
}

#[derive(Debug, Subcommand)]
pub enum LocalCommand {
    #[command(about = "cli-cmd-local-studies-about")]
    Studies(LocalStudiesArgs),
    #[command(about = "cli-cmd-local-series-about")]
    Series(LocalSeriesArgs),
}

#[derive(Debug, Args, Default)]
pub struct LocalStudiesArgs {
    #[arg(long, value_enum, help = "cli-arg-export", value_name = "cli-value-name-format")]
    pub export: Option<LocalExportFormat>,

    #[arg(long, help = "cli-arg-out", value_name = "cli-value-name-file")]
    pub out: Option<PathBuf>,

    #[arg(long, help = "cli-arg-patient-name")]
    pub patient_name: Option<String>,

    #[arg(long, help = "cli-arg-patient-id")]
    pub patient_id: Option<String>,

    #[arg(long, help = "cli-arg-accession-number")]
    pub accession_number: Option<String>,

    #[arg(long, help = "cli-arg-study-description")]
    pub study_description: Option<String>,

    #[arg(long, help = "cli-arg-study-date")]
    pub study_date: Option<String>,

    #[arg(long, help = "cli-arg-modality")]
    pub modality: Option<String>,

    #[arg(long, help = "cli-arg-source-path")]
    pub source_path: Option<String>,

    #[arg(long, help = "cli-arg-imported-at")]
    pub imported_at: Option<String>,

    #[arg(long, help = "cli-arg-duplicate")]
    pub duplicate: Option<bool>,
}

#[derive(Debug, Args)]
pub struct LocalSeriesArgs {
    #[arg(long, value_enum, help = "cli-arg-export", value_name = "cli-value-name-format")]
    pub export: Option<LocalExportFormat>,

    #[arg(long, help = "cli-arg-out", value_name = "cli-value-name-file")]
    pub out: Option<PathBuf>,

    #[arg(help = "cli-arg-study-instance-uid")]
    pub study_instance_uid: String,

    #[arg(long, help = "cli-arg-accession-number")]
    pub accession_number: Option<String>,

    #[arg(long, help = "cli-arg-series-description")]
    pub series_description: Option<String>,

    #[arg(long, help = "cli-arg-modality")]
    pub modality: Option<String>,

    #[arg(long, help = "cli-arg-source-path")]
    pub source_path: Option<String>,

    #[arg(long, help = "cli-arg-imported-at")]
    pub imported_at: Option<String>,

    #[arg(long, help = "cli-arg-duplicate")]
    pub duplicate: Option<bool>,
}

#[derive(Debug, Args)]
pub struct NodeAddArgs {
    #[arg(long, help = "cli-arg-name")]
    pub name: String,
    #[arg(long, help = "cli-arg-ae-title")]
    pub ae_title: String,
    #[arg(long, help = "cli-arg-host")]
    pub host: String,
    #[arg(long, help = "cli-arg-port")]
    pub port: u16,
    #[arg(long, help = "cli-arg-move-destination")]
    pub move_destination: Option<String>,
    #[arg(long, help = "cli-arg-notes")]
    pub notes: Option<String>,
}

#[derive(Debug, Args)]
pub struct NodeEditArgs {
    #[arg(help = "cli-arg-node")]
    pub node: String,
    #[arg(long, help = "cli-arg-name")]
    pub name: Option<String>,
    #[arg(long, help = "cli-arg-ae-title")]
    pub ae_title: Option<String>,
    #[arg(long, help = "cli-arg-host")]
    pub host: Option<String>,
    #[arg(long, help = "cli-arg-port")]
    pub port: Option<u16>,
    #[arg(long, help = "cli-arg-move-destination")]
    pub move_destination: Option<String>,
    #[arg(long, help = "cli-arg-notes")]
    pub notes: Option<String>,
}

#[derive(Debug, Args)]
pub struct NodeDeleteArgs {
    #[arg(help = "cli-arg-node")]
    pub node: String,
}

#[derive(Debug, Args)]
pub struct ImportArgs {
    #[arg(long, help = "cli-arg-json")]
    pub json: bool,

    #[arg(help = "cli-arg-path", value_name = "cli-value-name-path")]
    pub path: PathBuf,
}

#[derive(Debug, Args)]
pub struct QueryArgs {
    #[arg(long, help = "cli-arg-node")]
    pub node: String,

    #[arg(long, help = "cli-arg-json")]
    pub json: bool,
    #[arg(long, value_enum, default_value_t = QueryModel::StudyRoot, help = "cli-arg-model")]
    pub model: QueryModel,
    #[arg(long, value_enum, default_value_t = QueryLevel::Study, help = "cli-arg-level")]
    pub level: QueryLevel,
    #[arg(long, help = "cli-arg-patient-name")]
    pub patient_name: Option<String>,
    #[arg(long, help = "cli-arg-patient-id")]
    pub patient_id: Option<String>,
    #[arg(long, help = "cli-arg-accession-number")]
    pub accession_number: Option<String>,
    #[arg(long, help = "cli-arg-study-instance-uid")]
    pub study_instance_uid: Option<String>,
    #[arg(long, help = "cli-arg-series-instance-uid")]
    pub series_instance_uid: Option<String>,
    #[arg(long, help = "cli-arg-sop-instance-uid")]
    pub sop_instance_uid: Option<String>,
    #[arg(long, help = "cli-arg-study-date-from")]
    pub study_date_from: Option<String>,
    #[arg(long, help = "cli-arg-study-date-to")]
    pub study_date_to: Option<String>,
    #[arg(long, help = "cli-arg-modality")]
    pub modality: Option<String>,
    #[arg(long, help = "cli-arg-study-description")]
    pub study_description: Option<String>,
}

#[derive(Debug, Args)]
pub struct RetrieveArgs {
    #[arg(long, help = "cli-arg-node")]
    pub node: String,

    #[arg(long, help = "cli-arg-json")]
    pub json: bool,

    #[arg(long, value_enum, default_value_t = QueryModel::StudyRoot, help = "cli-arg-model")]
    pub model: QueryModel,
    #[arg(long, value_enum, default_value_t = QueryLevel::Study, help = "cli-arg-level")]
    pub level: QueryLevel,
    #[arg(long, help = "cli-arg-study-instance-uid")]
    pub study_instance_uid: String,
    #[arg(long, help = "cli-arg-series-instance-uid")]
    pub series_instance_uid: Option<String>,
    #[arg(long, help = "cli-arg-sop-instance-uid")]
    pub sop_instance_uid: Option<String>,
    #[arg(long, help = "cli-arg-move-destination")]
    pub move_destination: Option<String>,
}

#[derive(Debug, Args)]
pub struct SendStudyArgs {
    #[arg(long, help = "cli-arg-study-instance-uid")]
    pub study_instance_uid: String,
    #[arg(long, help = "cli-arg-destination-node")]
    pub destination_node: String,
}

#[derive(Debug, Args)]
pub struct SendSeriesArgs {
    #[arg(long, help = "cli-arg-series-instance-uid")]
    pub series_instance_uid: String,
    #[arg(long, help = "cli-arg-destination-node")]
    pub destination_node: String,
}

fn localize_command(command: Command) -> Command {
    let usage_heading = t("cli-heading-usage");
    let template = format!(
        "\
{{before-help}}{{name}} {{version}}
{{author-with-newline}}{{about-with-newline}}
{usage_heading} {{usage}}

{{all-args}}{{after-help}}
"
    );
    let mut command = command
        .help_template(template)
        .subcommand_help_heading(
            Box::leak(t("cli-heading-commands").into_boxed_str()) as &'static str,
        );

    if let Some(about) = command.get_about() {
        let key = about.to_string();
        if key.starts_with("cli-") {
            command = command.about(t(&key));
        }
    }

    command = command.mut_args(localize_arg);

    let names: Vec<String> = command
        .get_subcommands()
        .map(|sub| sub.get_name().to_string())
        .collect();
    for name in names {
        command = command.mut_subcommand(name, localize_command);
    }
    command
}

fn localize_arg(mut arg: Arg) -> Arg {
    if let Some(help) = arg.get_help() {
        let key = help.to_string();
        if key.starts_with("cli-") {
            arg = arg.help(t(&key));
        }
    } else {
        match arg.get_id().as_str() {
            "help" => arg = arg.help(t("cli-flag-help")),
            "version" => arg = arg.help(t("cli-flag-version")),
            _ => {}
        }
    }

    if let Some(names) = arg.get_value_names() {
        let translated: Vec<String> = names
            .iter()
            .map(|name| {
                let key = name.to_string();
                if key.starts_with("cli-") {
                    t(&key)
                } else {
                    key
                }
            })
            .collect();
        if !translated.is_empty() {
            let leaked: Vec<&'static str> = translated
                .into_iter()
                .map(|name| Box::leak(name.into_boxed_str()) as &'static str)
                .collect();
            arg = arg.value_names(leaked);
        }
    }

    arg
}
