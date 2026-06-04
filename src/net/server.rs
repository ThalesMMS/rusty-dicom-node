use std::{
    sync::{
        atomic::{AtomicBool, Ordering},
        Arc,
    },
    time::Duration,
};

use crate::{config::AppConfig, error::Result, models::ScpSessionReport};

use super::{StorageScpRuntimeOptions, StorageScpServer};

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct ServerRuntimeOptions {
    pub global_max_concurrent_associations: usize,
    pub association_slot_wait_timeout: Duration,
    pub shutdown_timeout: Duration,
}

impl ServerRuntimeOptions {
    pub fn from_config(config: &AppConfig) -> Self {
        Self {
            global_max_concurrent_associations: config.server_max_concurrent_associations,
            association_slot_wait_timeout: Duration::from_millis(
                config.server_association_slot_wait_timeout_ms,
            ),
            shutdown_timeout: Duration::from_millis(config.server_shutdown_timeout_ms),
        }
    }
}

#[derive(Debug, Clone)]
pub struct DicomServerRuntime {
    storage_scp: StorageScpServer,
    options: ServerRuntimeOptions,
}

impl DicomServerRuntime {
    pub fn new(storage_scp: StorageScpServer, options: ServerRuntimeOptions) -> Self {
        Self {
            storage_scp,
            options,
        }
    }

    pub fn run_until_cancelled(&self, cancel_flag: Arc<AtomicBool>) -> Result<ScpSessionReport> {
        let background = self
            .storage_scp
            .spawn_configured_background_with_options(self.storage_scp_options())?;
        while !cancel_flag.load(Ordering::Acquire) {
            std::thread::sleep(self.poll_interval());
        }
        background.stop()
    }

    fn poll_interval(&self) -> Duration {
        self.options
            .association_slot_wait_timeout
            .min(Duration::from_millis(50))
    }

    fn storage_scp_options(&self) -> StorageScpRuntimeOptions {
        StorageScpRuntimeOptions {
            global_max_concurrent_associations: Some(
                self.options.global_max_concurrent_associations,
            ),
            association_slot_wait_timeout: self.options.association_slot_wait_timeout,
            shutdown_timeout: self.options.shutdown_timeout,
        }
    }
}

#[cfg(test)]
mod tests {
    use std::time::Duration;

    use crate::config::AppConfig;

    use super::ServerRuntimeOptions;

    #[test]
    fn runtime_options_are_derived_from_app_config() {
        let config = AppConfig {
            server_max_concurrent_associations: 7,
            server_association_slot_wait_timeout_ms: 25,
            server_shutdown_timeout_ms: 125,
            ..AppConfig::default()
        };

        let options = ServerRuntimeOptions::from_config(&config);

        assert_eq!(options.global_max_concurrent_associations, 7);
        assert_eq!(
            options.association_slot_wait_timeout,
            Duration::from_millis(25)
        );
        assert_eq!(options.shutdown_timeout, Duration::from_millis(125));
    }
}
