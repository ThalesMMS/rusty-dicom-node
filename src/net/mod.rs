pub mod assoc;
pub mod dimse_status;
pub mod find;
pub mod malformed_response;
pub mod metrics;
pub mod move_scu;
pub mod server;
pub mod service;
pub mod storage_scp;
pub mod store_scu;
pub mod transfer;

pub(crate) fn err(key: &str) -> anyhow::Error {
    anyhow::anyhow!("{}", crate::error::msg(key))
}

pub(crate) fn err_with<'a>(
    key: &str,
    pairs: impl IntoIterator<Item = (&'a str, &'a str)>,
) -> anyhow::Error {
    anyhow::anyhow!("{}", crate::error::msg_with(key, pairs))
}

pub(crate) fn hint_suffix(hint: Option<&str>) -> String {
    hint.map(|h| crate::error::msg_with("error-net-hint-suffix", [("hint", h)]))
        .unwrap_or_default()
}

pub use assoc::AssociationFactory;
pub use find::FindScu;
pub use metrics::{ServerMetrics, ServerMetricsSnapshot};
pub use move_scu::MoveScu;
pub use server::{DicomServerRuntime, ServerRuntimeOptions};
pub use storage_scp::{StorageScpRuntimeOptions, StorageScpServer};
pub use store_scu::StoreScu;
