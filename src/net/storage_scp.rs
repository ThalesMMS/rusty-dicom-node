use std::{
    fs,
    io::{BufWriter, Write},
    net::{SocketAddr, TcpListener, TcpStream},
    sync::{
        atomic::{AtomicBool, AtomicU32, AtomicUsize, Ordering},
        Arc,
    },
    time::Duration,
};

use anyhow::Context;
use dicom_dictionary_std::tags;
use dicom_ul::{
    association::{Association, ServerAssociationOptions},
    pdu::PDataValueType,
    Pdu,
};
use tracing::{error, info, warn};

use ipnet::IpNet;

use crate::{
    archive::SqliteArchiveCatalog,
    config::{
        now_utc_string, AppConfig, AppPaths, LocalAeConfig, LocalAeService,
        DEFAULT_MAX_CONCURRENT_ASSOCIATIONS,
    },
    db::Database,
    dicom::read_u16_opt_from_mem,
    error::Result,
    models::ScpSessionReport,
    net::metrics::{ServerMetrics, ServerMetricsSnapshot},
};

use super::{
    assoc::AssociationFactory,
    service::{
        DimseServiceKind, FindCommand, GetCommand, MoveCommand, ProviderRegistration,
        QueryProvider, RetrieveProvider, ServiceClassRegistry, StorageProvider, StoreCommand,
        VerificationProvider,
    },
    transfer::all_supported_transfer_syntaxes,
};

#[derive(Debug, Clone)]
struct InboundAssociationPolicy {
    allowed_calling_aet: Vec<String>,
    allowed_peer_ips: Vec<String>,
}

fn normalize_ae_title(aet: &str) -> &str {
    aet.trim_end_matches(' ')
}

#[cfg(test)]
mod policy_tests {
    use super::*;
    use std::net::{IpAddr, Ipv4Addr, Ipv6Addr, SocketAddr};

    #[test]
    fn calling_aet_allowed_when_allowlist_empty() {
        let policy = InboundAssociationPolicy {
            allowed_calling_aet: vec![],
            allowed_peer_ips: vec![],
        };

        assert!(policy.is_calling_aet_allowed("ANY_AE"));
        assert!(policy.is_calling_aet_allowed(""));
    }

    #[test]
    fn calling_aet_trims_trailing_spaces_for_comparison() {
        let policy = InboundAssociationPolicy {
            allowed_calling_aet: vec!["MODALITY".to_string()],
            allowed_peer_ips: vec![],
        };

        assert!(policy.is_calling_aet_allowed("MODALITY"));
        assert!(policy.is_calling_aet_allowed("MODALITY   "));
        assert!(!policy.is_calling_aet_allowed("MODALITYX"));
    }

    #[test]
    fn peer_ip_allowed_when_allowlist_empty() {
        let policy = InboundAssociationPolicy {
            allowed_calling_aet: vec![],
            allowed_peer_ips: vec![],
        };

        let peer = SocketAddr::new(IpAddr::V4(Ipv4Addr::new(192, 168, 1, 50)), 104);
        assert!(policy.is_peer_ip_allowed(&peer));
    }

    #[test]
    fn peer_ip_exact_match_allows() {
        let policy = InboundAssociationPolicy {
            allowed_calling_aet: vec![],
            allowed_peer_ips: vec!["127.0.0.1".to_string()],
        };

        let peer_ok = SocketAddr::new(IpAddr::V4(Ipv4Addr::LOCALHOST), 111);
        let peer_bad = SocketAddr::new(IpAddr::V4(Ipv4Addr::new(127, 0, 0, 2)), 111);

        assert!(policy.is_peer_ip_allowed(&peer_ok));
        assert!(!policy.is_peer_ip_allowed(&peer_bad));
    }

    #[test]
    fn peer_ip_cidr_match_allows_ipv4_and_ipv6() {
        let policy = InboundAssociationPolicy {
            allowed_calling_aet: vec![],
            allowed_peer_ips: vec!["10.0.0.0/8".to_string(), "2001:db8::/32".to_string()],
        };

        let peer_ok_v4 = SocketAddr::new(IpAddr::V4(Ipv4Addr::new(10, 1, 2, 3)), 104);
        let peer_bad_v4 = SocketAddr::new(IpAddr::V4(Ipv4Addr::new(11, 1, 2, 3)), 104);
        let peer_ok_v6 = SocketAddr::new(
            IpAddr::V6(Ipv6Addr::new(0x2001, 0x0db8, 0, 0, 0, 0, 0, 1)),
            104,
        );
        let peer_bad_v6 = SocketAddr::new(IpAddr::V6(Ipv6Addr::LOCALHOST), 104);

        assert!(policy.is_peer_ip_allowed(&peer_ok_v4));
        assert!(!policy.is_peer_ip_allowed(&peer_bad_v4));
        assert!(policy.is_peer_ip_allowed(&peer_ok_v6));
        assert!(!policy.is_peer_ip_allowed(&peer_bad_v6));
    }

    #[test]
    fn peer_ip_invalid_entry_does_not_match() {
        let policy = InboundAssociationPolicy {
            allowed_calling_aet: vec![],
            allowed_peer_ips: vec!["not-an-ip".to_string()],
        };

        let peer = SocketAddr::new(IpAddr::V4(Ipv4Addr::LOCALHOST), 104);
        assert!(!policy.is_peer_ip_allowed(&peer));
    }
}

impl InboundAssociationPolicy {
    fn from_local_ae(ae: &LocalAeConfig) -> Self {
        Self {
            allowed_calling_aet: ae.allowed_calling_aet.clone(),
            allowed_peer_ips: ae.allowed_peer_ips.clone(),
        }
    }

    fn is_allowed(&self, peer_socket_addr: &SocketAddr, peer_ae_title: &str) -> bool {
        self.is_calling_aet_allowed(peer_ae_title) && self.is_peer_ip_allowed(peer_socket_addr)
    }

    fn is_calling_aet_allowed(&self, peer_ae_title: &str) -> bool {
        if self.allowed_calling_aet.is_empty() {
            return true;
        }

        let peer_ae_title = normalize_ae_title(peer_ae_title);

        self.allowed_calling_aet
            .iter()
            .map(|allowed| normalize_ae_title(allowed))
            .any(|allowed| allowed == peer_ae_title)
    }

    fn is_peer_ip_allowed(&self, peer_socket_addr: &SocketAddr) -> bool {
        if self.allowed_peer_ips.is_empty() {
            return true;
        }

        let peer_ip = peer_socket_addr.ip();

        self.allowed_peer_ips.iter().any(|allowed| {
            // Accept either:
            // - exact IP (v4/v6), e.g. "127.0.0.1" / "::1"
            // - CIDR, e.g. "10.0.0.0/8" / "2001:db8::/32"
            if let Ok(net) = allowed.parse::<IpNet>() {
                net.contains(&peer_ip)
            } else {
                allowed.trim() == peer_ip.to_string()
            }
        })
    }
}

#[derive(Debug, Clone)]
pub struct StorageScpServer {
    config: AppConfig,
    paths: AppPaths,
    db: Database,
    metrics: ServerMetrics,
}

#[derive(Debug)]
pub struct BackgroundStorageScp {
    stop_flag: Arc<AtomicBool>,
    received: Arc<AtomicU32>,
    stored: Arc<AtomicU32>,
    failed: Arc<AtomicU32>,
    ae_title: String,
    bind_addr: String,
    max_concurrent_associations: usize,
    port: u16,
    join_handle: Option<std::thread::JoinHandle<Result<()>>>,
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct BackgroundStorageScpListener {
    pub ae_title: String,
    pub bind_addr: String,
    pub port: u16,
    pub max_concurrent_associations: usize,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct StorageScpRuntimeOptions {
    pub global_max_concurrent_associations: Option<usize>,
    pub association_slot_wait_timeout: Duration,
    pub shutdown_timeout: Duration,
}

impl Default for StorageScpRuntimeOptions {
    fn default() -> Self {
        Self {
            global_max_concurrent_associations: None,
            association_slot_wait_timeout: Duration::ZERO,
            shutdown_timeout: Duration::from_secs(5),
        }
    }
}

#[derive(Debug)]
pub struct BackgroundStorageScpSet {
    listeners: Vec<BackgroundStorageScpListener>,
    servers: Vec<BackgroundStorageScp>,
    global_limiter: Option<AssociationLimiter>,
    shutdown_timeout: Duration,
}

impl StorageScpServer {
    pub fn new(config: AppConfig, paths: AppPaths, db: Database) -> Self {
        Self {
            config,
            paths,
            db,
            metrics: ServerMetrics::default(),
        }
    }

    pub fn metrics(&self) -> ServerMetrics {
        self.metrics.clone()
    }

    pub fn metrics_snapshot(&self) -> ServerMetricsSnapshot {
        self.metrics.snapshot()
    }

    pub fn run_forever(&self) -> Result<ScpSessionReport> {
        let aes = vec![self.legacy_local_ae_for_server()?];
        let stop = Arc::new(AtomicBool::new(false));
        let received = Arc::new(AtomicU32::new(0));
        let stored = Arc::new(AtomicU32::new(0));
        let failed = Arc::new(AtomicU32::new(0));

        let mut listeners = Vec::new();
        for ae in aes {
            let listener = self.bind_listener_for_ae(&ae)?;
            listeners.push((listener, ae));
        }

        let mut join_handles = Vec::new();
        while listeners.len() > 1 {
            let (listener, ae) = listeners
                .pop()
                .expect("listener exists while len greater than one");
            let server = self.clone();
            let thread_stop = stop.clone();
            let thread_received = received.clone();
            let thread_stored = stored.clone();
            let thread_failed = failed.clone();
            join_handles.push(std::thread::spawn(move || {
                server.run_until_stop(
                    listener,
                    ae,
                    None,
                    Duration::ZERO,
                    thread_stop,
                    thread_received,
                    thread_stored,
                    thread_failed,
                )
            }));
        }

        let (listener, ae) = listeners
            .pop()
            .expect("configured_local_aes_for_server returns at least one AE");
        let mut run_result = self.run_until_stop(
            listener,
            ae,
            None,
            Duration::ZERO,
            stop.clone(),
            received.clone(),
            stored.clone(),
            failed.clone(),
        );

        stop.store(true, Ordering::Relaxed);
        for join_handle in join_handles {
            match join_handle.join() {
                Ok(Ok(())) => {}
                Ok(Err(err)) if run_result.is_ok() => run_result = Err(err),
                Ok(Err(_)) => {}
                Err(_) if run_result.is_ok() => {
                    run_result = Err(crate::net::err("error-net-scp-thread-panicked"));
                }
                Err(_) => {}
            }
        }

        run_result?;

        Ok(ScpSessionReport {
            received: received.load(Ordering::Relaxed),
            stored: stored.load(Ordering::Relaxed),
            failed: failed.load(Ordering::Relaxed),
        })
    }

    pub fn spawn_background(&self) -> Result<BackgroundStorageScp> {
        let ae = self.legacy_local_ae_for_server()?;
        self.spawn_background_for_ae(ae, None, StorageScpRuntimeOptions::default())
    }

    pub fn spawn_configured_background(&self) -> Result<BackgroundStorageScpSet> {
        self.spawn_configured_background_with_options(StorageScpRuntimeOptions::default())
    }

    pub fn spawn_configured_background_with_options(
        &self,
        options: StorageScpRuntimeOptions,
    ) -> Result<BackgroundStorageScpSet> {
        let global_limiter = options
            .global_max_concurrent_associations
            .map(AssociationLimiter::new);
        let mut servers = Vec::new();
        let mut listeners = Vec::new();
        for ae in self.configured_local_aes_for_server()? {
            match self.spawn_background_for_ae(ae, global_limiter.clone(), options) {
                Ok(server) => {
                    listeners.push(server.listener());
                    servers.push(server);
                }
                Err(err) => {
                    for server in servers {
                        let _ = server.stop();
                    }
                    return Err(err);
                }
            }
        }

        Ok(BackgroundStorageScpSet {
            listeners,
            servers,
            global_limiter,
            shutdown_timeout: options.shutdown_timeout,
        })
    }

    fn spawn_background_for_ae(
        &self,
        ae: LocalAeConfig,
        global_limiter: Option<AssociationLimiter>,
        options: StorageScpRuntimeOptions,
    ) -> Result<BackgroundStorageScp> {
        let stop_flag = Arc::new(AtomicBool::new(false));
        let received = Arc::new(AtomicU32::new(0));
        let stored = Arc::new(AtomicU32::new(0));
        let failed = Arc::new(AtomicU32::new(0));
        let listener = self.bind_listener_for_ae(&ae)?;
        let local_addr = listener
            .local_addr()
            .context(crate::error::msg("error-net-listener-address"))?;
        let port = listener
            .local_addr()
            .context(crate::error::msg("error-net-listener-port"))?
            .port();
        let server = self.clone();
        let thread_ae = ae.clone();
        let thread_stop = stop_flag.clone();
        let thread_received = received.clone();
        let thread_stored = stored.clone();
        let thread_failed = failed.clone();
        let join_handle = std::thread::spawn(move || {
            server.run_until_stop(
                listener,
                thread_ae,
                global_limiter,
                options.association_slot_wait_timeout,
                thread_stop,
                thread_received,
                thread_stored,
                thread_failed,
            )
        });
        Ok(BackgroundStorageScp {
            stop_flag,
            received,
            stored,
            failed,
            ae_title: ae.title,
            bind_addr: local_addr.to_string(),
            max_concurrent_associations: ae.max_concurrent_associations,
            port,
            join_handle: Some(join_handle),
        })
    }

    fn configured_local_aes_for_server(&self) -> Result<Vec<LocalAeConfig>> {
        if self.config.local_aes.is_empty() {
            return Err(crate::net::err("error-net-local-aes-empty"));
        }
        Ok(self.config.local_aes.clone())
    }

    fn legacy_local_ae_for_server(&self) -> Result<LocalAeConfig> {
        if self.config.local_aes.is_empty() {
            return Err(crate::net::err("error-net-local-aes-empty"));
        }

        let mut ae = self
            .config
            .local_aes
            .iter()
            .find(|ae| ae.title == self.config.local_ae_title)
            .cloned()
            .unwrap_or_else(|| LocalAeConfig {
                title: self.config.local_ae_title.clone(),
                bind_addr: self.config.storage_socket_addr(),
                services: vec![
                    LocalAeService::Verification,
                    LocalAeService::Storage,
                    LocalAeService::Query,
                    LocalAeService::Retrieve,
                ],
                max_concurrent_associations: DEFAULT_MAX_CONCURRENT_ASSOCIATIONS,
                allowed_calling_aet: self.config.allowed_calling_aet.clone(),
                allowed_peer_ips: self.config.allowed_peer_ips.clone(),
            });
        ae.title = self.config.local_ae_title.clone();
        ae.bind_addr = self.config.storage_socket_addr();
        if ae.allowed_calling_aet.is_empty() {
            ae.allowed_calling_aet = self.config.allowed_calling_aet.clone();
        }
        if ae.allowed_peer_ips.is_empty() {
            ae.allowed_peer_ips = self.config.allowed_peer_ips.clone();
        }
        Ok(ae)
    }

    fn bind_listener_for_ae(&self, ae: &LocalAeConfig) -> Result<TcpListener> {
        let addr = &ae.bind_addr;
        let listener = TcpListener::bind(&addr).with_context(|| {
            let config = self.paths.config_json.display().to_string();
            crate::error::msg_with(
                "error-net-binding-storage-scp",
                [
                    ("addr", addr.as_str()),
                    ("ae", ae.title.as_str()),
                    ("config", config.as_str()),
                ],
            )
        })?;
        listener
            .set_nonblocking(true)
            .context(crate::error::msg("error-net-listener-nonblocking"))?;
        Ok(listener)
    }

    fn run_until_stop(
        &self,
        listener: TcpListener,
        ae: LocalAeConfig,
        global_limiter: Option<AssociationLimiter>,
        association_slot_wait_timeout: Duration,
        stop_flag: Arc<AtomicBool>,
        received: Arc<AtomicU32>,
        stored: Arc<AtomicU32>,
        failed: Arc<AtomicU32>,
    ) -> Result<()> {
        let association_limiter = AssociationLimiter::new(ae.max_concurrent_associations);
        while !stop_flag.load(Ordering::Relaxed) {
            match listener.accept() {
                Ok((stream, addr)) => {
                    let Some(association_permits) = acquire_association_permits(
                        &association_limiter,
                        global_limiter.as_ref(),
                        association_slot_wait_timeout,
                        &stop_flag,
                    ) else {
                        warn!(
                            "rejected storage association from {} for AE {} because association concurrency limit is reached",
                            addr, ae.title
                        );
                        self.metrics.record_association_rejected();
                        continue;
                    };

                    if let Err(err) = stream.set_nonblocking(false) {
                        return Err(err)
                            .context(crate::error::msg("error-net-setting-socket-blocking"));
                    }
                    let server = self.clone();
                    let connection_ae = ae.clone();
                    let connection_received = received.clone();
                    let connection_stored = stored.clone();
                    let connection_failed = failed.clone();
                    std::thread::spawn(move || {
                        let _association_permits = association_permits;
                        if let Err(err) = server.handle_connection(
                            stream,
                            &connection_ae,
                            connection_received,
                            connection_stored,
                            connection_failed,
                        ) {
                            error!("storage SCP connection failed: {err:#}");
                        }
                    });
                }
                Err(err) if err.kind() == std::io::ErrorKind::WouldBlock => {
                    std::thread::sleep(Duration::from_millis(100));
                }
                Err(err) => return Err(err.into()),
            }
        }

        Ok(())
    }

    fn handle_connection(
        &self,
        stream: TcpStream,
        ae: &LocalAeConfig,
        received: Arc<AtomicU32>,
        stored: Arc<AtomicU32>,
        failed: Arc<AtomicU32>,
    ) -> Result<()> {
        let peer_socket_addr = stream
            .peer_addr()
            .context(crate::error::msg("error-net-peer-socket"))?;
        let mut ae_config = self.config.clone();
        ae_config.local_ae_title = ae.title.clone();
        let verification_provider = VerificationProvider::new();
        let query_provider = QueryProvider::with_metrics(
            SqliteArchiveCatalog::new(self.db.clone()),
            self.metrics.clone(),
        );
        let retrieve_provider = RetrieveProvider::with_metrics(
            ae_config.clone(),
            self.db.clone(),
            self.metrics.clone(),
        );
        let storage_provider = StorageProvider::with_metrics(
            ae_config,
            self.paths.clone(),
            self.db.clone(),
            self.metrics.clone(),
        );
        let registry = registry_for_local_ae(
            ae,
            &verification_provider,
            &query_provider,
            &retrieve_provider,
            &storage_provider,
        );

        let mut options = ServerAssociationOptions::new()
            .accept_called_ae_title()
            .ae_title(ae.title.clone())
            .strict(self.config.strict_pdu)
            .max_pdu_length(self.config.max_pdu_length)
            .promiscuous(self.config.allow_promiscuous_storage)
            .read_timeout(Duration::from_secs(60))
            .write_timeout(Duration::from_secs(60));

        for ts in all_supported_transfer_syntaxes() {
            options = options.with_transfer_syntax(ts);
        }
        for abstract_syntax in registry.supported_abstract_syntaxes() {
            options = options.with_abstract_syntax(abstract_syntax);
        }

        let mut association = match options.establish(stream) {
            Ok(association) => association,
            Err(err) => {
                return Err(err).context(crate::error::msg("error-net-establishing-assoc"));
            }
        };
        let peer_ae_title = association.peer_ae_title().to_string();

        let policy = InboundAssociationPolicy::from_local_ae(ae);
        if !policy.is_allowed(&peer_socket_addr, &peer_ae_title) {
            self.metrics.record_association_rejected();
            warn!(
                "rejected storage association from {} ({}) due to inbound association policy",
                normalize_ae_title(&peer_ae_title),
                peer_socket_addr
            );
            return Ok(());
        }

        let correlation_id = uuid::Uuid::new_v4().to_string();
        let association_started = std::time::Instant::now();
        self.metrics.record_association_accepted();
        let abstract_syntaxes = association
            .presentation_contexts()
            .iter()
            .map(|context| context.abstract_syntax.as_str())
            .collect::<Vec<_>>();
        let negotiated_services = abstract_syntaxes
            .iter()
            .filter_map(|syntax| {
                registry
                    .providers()
                    .iter()
                    .find(|provider| provider.supports_abstract_syntax(syntax))
                    .map(|provider| format!("{}:{syntax}", provider.name))
            })
            .collect::<Vec<_>>();
        info!(
            correlation_id = %correlation_id,
            calling_ae = %normalize_ae_title(&peer_ae_title),
            called_ae = %ae.title,
            peer = %peer_socket_addr,
            negotiated_presentation_contexts = association.presentation_contexts().len(),
            abstract_syntaxes = ?abstract_syntaxes,
            negotiated_services = ?negotiated_services,
            "accepted storage association"
        );

        let mut command_buffer = Vec::new();
        let mut accumulated_bytes: u64 = 0;
        let mut current_store: Option<StoreCommand> = None;
        let mut current_find: Option<FindCommand> = None;
        let mut find_dataset_bytes: Vec<u8> = Vec::new();
        let mut current_move: Option<MoveCommand> = None;
        let mut move_dataset_bytes: Vec<u8> = Vec::new();
        let mut current_get: Option<GetCommand> = None;
        let mut get_dataset_bytes: Vec<u8> = Vec::new();

        // Stream incoming dataset PDV bytes to a temporary file to avoid buffering
        // the entire dataset in memory.
        //
        // Spec: temp files should live under the managed store directory, in a hidden
        // subdir. This keeps lifecycle/cleanup tied to the app's managed data.
        let temp_dir = self.paths.managed_store_dir.join(".incoming");
        fs::create_dir_all(&temp_dir).context(crate::error::msg("error-net-creating-incoming-dir"))?;

        let mut temp_dataset_path: Option<std::path::PathBuf> = None;
        let mut temp_dataset_writer: Option<BufWriter<fs::File>> = None;
        // Ensure we delete in-flight temp files on release/abort/connection error.
        let mut _temp_dataset_cleanup_guard: Option<RemoveFileOnDrop> = None;

        let final_association_status: &'static str;
        loop {
            match association.receive() {
                Ok(Pdu::PData { data }) => {
                    for value in data {
                        match value.value_type {
                            PDataValueType::Command => {
                                command_buffer.extend_from_slice(&value.data);
                                if value.is_last {
                                    let command =
                                        AssociationFactory::read_command_dataset(&command_buffer)?;
                                    command_buffer.clear();

                                    let command_field =
                                        read_u16_opt_from_mem(&command, tags::COMMAND_FIELD)
                                            .ok_or_else(|| {
                                                crate::net::err("error-net-missing-command-field")
                                            })?;
                                    let abstract_syntax = negotiated_abstract_syntax(
                                        &association,
                                        value.presentation_context_id,
                                    )?;

                                    match provider_for_command(
                                        &registry,
                                        command_field,
                                        abstract_syntax,
                                        self.config.allow_promiscuous_storage,
                                    ) {
                                        Ok(provider)
                                            if provider.kind == DimseServiceKind::Verification =>
                                        {
                                            verification_provider.handle_command(
                                                &mut association,
                                                &command,
                                                value.presentation_context_id,
                                            )?;
                                        }
                                        Ok(provider)
                                            if provider.kind == DimseServiceKind::Storage =>
                                        {
                                            current_find = None;
                                            find_dataset_bytes.clear();
                                            current_move = None;
                                            move_dataset_bytes.clear();
                                            current_get = None;
                                            get_dataset_bytes.clear();
                                            current_store =
                                                Some(storage_provider.begin_store_command(
                                                    &command,
                                                    value.presentation_context_id,
                                                )?);

                                            if let Some(path) = temp_dataset_path.take() {
                                                let _ = fs::remove_file(path);
                                            }
                                            _temp_dataset_cleanup_guard = None;
                                            temp_dataset_writer = None;
                                            accumulated_bytes = 0;
                                        }
                                        Ok(provider)
                                            if provider.kind == DimseServiceKind::Query =>
                                        {
                                            current_store = None;
                                            current_move = None;
                                            move_dataset_bytes.clear();
                                            current_get = None;
                                            get_dataset_bytes.clear();
                                            current_find =
                                                Some(query_provider.begin_find_command(
                                                    &command,
                                                    value.presentation_context_id,
                                                )?);
                                            find_dataset_bytes.clear();

                                            let data_set_type = read_u16_opt_from_mem(
                                                &command,
                                                tags::COMMAND_DATA_SET_TYPE,
                                            )
                                            .unwrap_or(0x0101);
                                            if data_set_type == 0x0101 {
                                                if let Some(find_command) = current_find.take() {
                                                    query_provider.handle_find_command(
                                                        &mut association,
                                                        &find_command,
                                                        &[],
                                                    )?;
                                                }
                                            }
                                        }
                                        Ok(provider)
                                            if provider.kind == DimseServiceKind::Retrieve =>
                                        {
                                            current_store = None;
                                            current_find = None;
                                            find_dataset_bytes.clear();
                                            current_move = None;
                                            move_dataset_bytes.clear();
                                            current_get = None;
                                            get_dataset_bytes.clear();

                                            let data_set_type = read_u16_opt_from_mem(
                                                &command,
                                                tags::COMMAND_DATA_SET_TYPE,
                                            )
                                            .unwrap_or(0x0101);
                                            if command_field == 0x0021 {
                                                current_move =
                                                    Some(retrieve_provider.begin_move_command(
                                                        &command,
                                                        value.presentation_context_id,
                                                    )?);
                                                if data_set_type == 0x0101 {
                                                    if let Some(move_command) = current_move.take()
                                                    {
                                                        retrieve_provider.handle_move_command(
                                                            &mut association,
                                                            &move_command,
                                                            &[],
                                                        )?;
                                                    }
                                                }
                                            } else if command_field == 0x0010 {
                                                current_get =
                                                    Some(retrieve_provider.begin_get_command(
                                                        &command,
                                                        value.presentation_context_id,
                                                    )?);
                                                if data_set_type == 0x0101 {
                                                    if let Some(get_command) = current_get.take() {
                                                        retrieve_provider.handle_get_command(
                                                            &mut association,
                                                            &get_command,
                                                            &[],
                                                        )?;
                                                    }
                                                }
                                            } else {
                                                warn!(
                                                    "retrieve provider received unsupported command 0x{command_field:04X}"
                                                );
                                            }
                                        }
                                        Ok(provider) => {
                                            warn!(
                                                "DIMSE provider {} is registered but not implemented in this listener",
                                                provider.name
                                            );
                                        }
                                        Err(err) => {
                                            warn!("{err:#}");
                                        }
                                    }
                                }
                            }
                            PDataValueType::Data => {
                                if let Some(find_command) = current_find.as_ref() {
                                    find_dataset_bytes.extend_from_slice(&value.data);
                                    if value.is_last {
                                        let find_command = find_command.clone();
                                        current_find = None;
                                        let identifier_bytes =
                                            std::mem::take(&mut find_dataset_bytes);
                                        query_provider.handle_find_command(
                                            &mut association,
                                            &find_command,
                                            &identifier_bytes,
                                        )?;
                                    }
                                    continue;
                                }

                                if let Some(move_command) = current_move.as_ref() {
                                    move_dataset_bytes.extend_from_slice(&value.data);
                                    if value.is_last {
                                        let move_command = move_command.clone();
                                        current_move = None;
                                        let identifier_bytes =
                                            std::mem::take(&mut move_dataset_bytes);
                                        retrieve_provider.handle_move_command(
                                            &mut association,
                                            &move_command,
                                            &identifier_bytes,
                                        )?;
                                    }
                                    continue;
                                }

                                if let Some(get_command) = current_get.as_ref() {
                                    get_dataset_bytes.extend_from_slice(&value.data);
                                    if value.is_last {
                                        let get_command = get_command.clone();
                                        current_get = None;
                                        let identifier_bytes =
                                            std::mem::take(&mut get_dataset_bytes);
                                        retrieve_provider.handle_get_command(
                                            &mut association,
                                            &get_command,
                                            &identifier_bytes,
                                        )?;
                                    }
                                    continue;
                                }

                                let projected_bytes =
                                    accumulated_bytes.saturating_add(value.data.len() as u64);
                                let max_store_object_bytes =
                                    storage_provider.max_store_object_bytes();

                                if let Some(max_store_object_bytes) = max_store_object_bytes {
                                    if projected_bytes > max_store_object_bytes {
                                        warn!(
                                            "incoming C-STORE dataset exceeded configured limit: {projected_bytes} > {max_store_object_bytes} bytes"
                                        );
                                        if let Some(store_command) = current_store.take() {
                                            received.fetch_add(1, Ordering::Relaxed);
                                            failed.fetch_add(1, Ordering::Relaxed);
                                            self.metrics.record_c_store_received();
                                            self.metrics.record_c_store_failed();
                                            error!(
                                                accumulated_bytes,
                                                projected_bytes,
                                                max_store_object_bytes,
                                                dimse_status = "0xA700",
                                                "failed to persist incoming object: C-STORE dataset exceeded configured size limit"
                                            );
                                            storage_provider.send_store_response(
                                                &mut association,
                                                &store_command,
                                                0xA700,
                                            )?;
                                        }
                                        if let Some(path) = temp_dataset_path.take() {
                                            let _ = fs::remove_file(path);
                                        }
                                        _temp_dataset_cleanup_guard = None;
                                        info!(
                                            correlation_id = %correlation_id,
                                            calling_ae = %normalize_ae_title(&peer_ae_title),
                                            called_ae = %ae.title,
                                            peer = %peer_socket_addr,
                                            status = "failed",
                                            dimse_status = "0xA700",
                                            duration_ms = association_started.elapsed().as_millis() as u64,
                                            "storage association finished"
                                        );
                                        return Ok(());
                                    }
                                }

                                accumulated_bytes = projected_bytes;

                                if temp_dataset_writer.is_none() {
                                    let path = temp_dir.join(format!(
                                        "incoming-{}-{}-{}.dcm",
                                        std::process::id(),
                                        now_utc_string(),
                                        uuid::Uuid::new_v4()
                                    ));
                                    let file = fs::File::create(&path)
                                        .with_context(|| format!("creating {}", path.display()))?;
                                    _temp_dataset_cleanup_guard =
                                        Some(RemoveFileOnDrop::new(&path));
                                    temp_dataset_path = Some(path);
                                    temp_dataset_writer = Some(BufWriter::new(file));
                                }

                                if let Some(writer) = temp_dataset_writer.as_mut() {
                                    writer
                                        .write_all(&value.data)
                                        .context(crate::error::msg("error-net-writing-temp-dataset"))?;
                                }

                                if value.is_last {
                                    if let Some(store_command) = current_store.take() {
                                        received.fetch_add(1, Ordering::Relaxed);
                                        self.metrics.record_c_store_received();

                                        if let Some(writer) = temp_dataset_writer.as_mut() {
                                            writer.flush().context(crate::error::msg(
                                                "error-net-flushing-temp-dataset",
                                            ))?;
                                        }
                                        temp_dataset_writer = None;

                                        let status = if let Some(temp_path) =
                                            temp_dataset_path.take()
                                        {
                                            // Keep the drop guard armed so we also clean up in case
                                            // persist_store fails/panics.
                                            let result = storage_provider.persist_store(
                                                &association,
                                                &store_command,
                                                &temp_path,
                                            );
                                            _temp_dataset_cleanup_guard = None;
                                            let _ = fs::remove_file(&temp_path);
                                            match result {
                                                Ok(()) => {
                                                    stored.fetch_add(1, Ordering::Relaxed);
                                                    self.metrics.record_c_store_stored();
                                                    0x0000
                                                }
                                                Err(err) => {
                                                    failed.fetch_add(1, Ordering::Relaxed);
                                                    self.metrics.record_c_store_failed();
                                                    error!(
                                                        "failed to persist incoming object: {err:#}"
                                                    );
                                                    0xA700
                                                }
                                            }
                                        } else {
                                            failed.fetch_add(1, Ordering::Relaxed);
                                            self.metrics.record_c_store_failed();
                                            error!(
                                                "failed to persist incoming object: missing temp dataset path"
                                            );
                                            0xA700
                                        };

                                        accumulated_bytes = 0;

                                        storage_provider.send_store_response(
                                            &mut association,
                                            &store_command,
                                            status,
                                        )?;
                                    } else {
                                        if let Some(path) = temp_dataset_path.take() {
                                            let _ = fs::remove_file(path);
                                        }
                                        _temp_dataset_cleanup_guard = None;
                                        temp_dataset_writer = None;
                                        accumulated_bytes = 0;
                                    }
                                }
                            }
                        }
                    }
                }
                Ok(Pdu::ReleaseRQ) => {
                    association.send(&Pdu::ReleaseRP)?;
                    final_association_status = "released";
                    // best-effort cleanup of any in-flight dataset (drop the guard)
                    _temp_dataset_cleanup_guard = None;
                    break;
                }
                Ok(Pdu::AbortRQ { source }) => {
                    final_association_status = "aborted";
                    warn!(
                        "peer {} aborted storage association: {:?}",
                        peer_ae_title, source
                    );
                    // best-effort cleanup of any in-flight dataset (drop the guard)
                    _temp_dataset_cleanup_guard = None;
                    break;
                }
                Ok(Pdu::ReleaseRP) => {
                    final_association_status = "released";
                    _temp_dataset_cleanup_guard = None;
                    break;
                }
                Ok(_) => {}
                Err(err) => {
                    final_association_status = "error";
                    warn!("storage association error from {}: {err:#}", peer_ae_title);
                    // best-effort cleanup of any in-flight dataset (drop the guard)
                    _temp_dataset_cleanup_guard = None;
                    break;
                }
            }
        }

        info!(
            correlation_id = %correlation_id,
            calling_ae = %normalize_ae_title(&peer_ae_title),
            called_ae = %ae.title,
            peer = %peer_socket_addr,
            status = final_association_status,
            duration_ms = association_started.elapsed().as_millis() as u64,
            "storage association finished"
        );

        Ok(())
    }
}

fn registry_for_local_ae(
    ae: &LocalAeConfig,
    verification_provider: &VerificationProvider,
    query_provider: &QueryProvider,
    retrieve_provider: &RetrieveProvider,
    storage_provider: &StorageProvider,
) -> ServiceClassRegistry {
    let mut registry = ServiceClassRegistry::new();
    if ae.services.contains(&LocalAeService::Verification) {
        registry.register(verification_provider);
    }
    if ae.services.contains(&LocalAeService::Query) {
        registry.register(query_provider);
    }
    if ae.services.contains(&LocalAeService::Retrieve) {
        registry.register(retrieve_provider);
    }
    if ae.services.contains(&LocalAeService::Storage) {
        registry.register(storage_provider);
    }
    registry
}

fn provider_for_command<'a>(
    registry: &'a ServiceClassRegistry,
    command_field: u16,
    abstract_syntax: &str,
    allow_promiscuous_storage: bool,
) -> Result<&'a ProviderRegistration> {
    match registry.provider_for_command(command_field, abstract_syntax) {
        Ok(provider) => Ok(provider),
        Err(err) => {
            if allow_promiscuous_storage && command_field == 0x0001 {
                if let Some(provider) = registry
                    .providers()
                    .iter()
                    .find(|provider| provider.kind == DimseServiceKind::Storage)
                {
                    return Ok(provider);
                }
            }
            Err(err)
        }
    }
}

fn acquire_association_permits(
    local_limiter: &AssociationLimiter,
    global_limiter: Option<&AssociationLimiter>,
    timeout: Duration,
    cancel_flag: &AtomicBool,
) -> Option<AssociationPermits> {
    let global_permit = match global_limiter {
        Some(limiter) => Some(limiter.acquire_until(timeout, cancel_flag)?),
        None => None,
    };
    let local_permit = local_limiter.acquire_until(timeout, cancel_flag)?;
    Some(AssociationPermits {
        _global: global_permit,
        _local: local_permit,
    })
}

struct AssociationPermits {
    _global: Option<AssociationPermit>,
    _local: AssociationPermit,
}

#[derive(Debug, Clone)]
pub(crate) struct AssociationLimiter {
    active: Arc<AtomicUsize>,
    max: usize,
}

impl AssociationLimiter {
    pub(crate) fn new(max: usize) -> Self {
        Self {
            active: Arc::new(AtomicUsize::new(0)),
            max,
        }
    }

    pub(crate) fn acquire_until(
        &self,
        timeout: Duration,
        cancel_flag: &AtomicBool,
    ) -> Option<AssociationPermit> {
        let deadline = std::time::Instant::now() + timeout;
        loop {
            if cancel_flag.load(Ordering::Acquire) {
                return None;
            }
            if self.try_acquire() {
                return Some(AssociationPermit {
                    active: self.active.clone(),
                });
            }
            if std::time::Instant::now() >= deadline {
                return None;
            }
            std::thread::sleep(Duration::from_millis(10));
        }
    }

    pub(crate) fn active(&self) -> usize {
        self.active.load(Ordering::Acquire)
    }

    pub(crate) fn wait_until_idle(&self, timeout: Duration) -> bool {
        let deadline = std::time::Instant::now() + timeout;
        while self.active() > 0 {
            if std::time::Instant::now() >= deadline {
                return false;
            }
            std::thread::sleep(Duration::from_millis(10));
        }
        true
    }

    fn try_acquire(&self) -> bool {
        let mut current = self.active.load(Ordering::Acquire);
        loop {
            if current >= self.max {
                return false;
            }
            match self.active.compare_exchange_weak(
                current,
                current + 1,
                Ordering::AcqRel,
                Ordering::Acquire,
            ) {
                Ok(_) => return true,
                Err(next) => current = next,
            }
        }
    }
}

pub(crate) struct AssociationPermit {
    active: Arc<AtomicUsize>,
}

impl Drop for AssociationPermit {
    fn drop(&mut self) {
        self.active.fetch_sub(1, Ordering::AcqRel);
    }
}

fn negotiated_abstract_syntax(
    association: &dicom_ul::association::ServerAssociation<TcpStream>,
    presentation_context_id: u8,
) -> Result<&str> {
    association
        .presentation_contexts()
        .iter()
        .find(|context| context.id == presentation_context_id)
        .map(|context| context.abstract_syntax.as_str())
        .ok_or_else(|| {
            let id = presentation_context_id.to_string();
            crate::net::err_with(
                "error-net-no-presentation-context-id",
                [("id", id.as_str())],
            )
        })
}

struct RemoveFileOnDrop {
    path: std::path::PathBuf,
    armed: bool,
}

impl RemoveFileOnDrop {
    fn new(path: &std::path::Path) -> Self {
        Self {
            path: path.to_path_buf(),
            armed: true,
        }
    }
}

impl Drop for RemoveFileOnDrop {
    fn drop(&mut self) {
        if self.armed {
            let _ = std::fs::remove_file(&self.path);
        }
    }
}

impl BackgroundStorageScp {
    pub fn listener(&self) -> BackgroundStorageScpListener {
        BackgroundStorageScpListener {
            ae_title: self.ae_title.clone(),
            bind_addr: self.bind_addr.clone(),
            port: self.port,
            max_concurrent_associations: self.max_concurrent_associations,
        }
    }

    pub fn port(&self) -> u16 {
        self.port
    }

    fn stop_listener(&mut self) -> Result<()> {
        self.stop_flag.store(true, Ordering::Relaxed);
        if let Some(join_handle) = self.join_handle.take() {
            match join_handle.join() {
                Ok(result) => result?,
                Err(_) => return Err(crate::net::err("error-net-scp-thread-panicked")),
            }
        }
        Ok(())
    }

    fn report(&self) -> ScpSessionReport {
        ScpSessionReport {
            received: self.received.load(Ordering::Relaxed),
            stored: self.stored.load(Ordering::Relaxed),
            failed: self.failed.load(Ordering::Relaxed),
        }
    }

    pub fn stop(mut self) -> Result<ScpSessionReport> {
        self.stop_listener()?;
        Ok(self.report())
    }
}

impl BackgroundStorageScpSet {
    pub fn listeners(&self) -> &[BackgroundStorageScpListener] {
        &self.listeners
    }

    pub fn stop(self) -> Result<ScpSessionReport> {
        let BackgroundStorageScpSet {
            mut servers,
            global_limiter,
            shutdown_timeout,
            ..
        } = self;
        let mut first_error = None;

        for server in &mut servers {
            match server.stop_listener() {
                Ok(()) => {}
                Err(err) if first_error.is_none() => first_error = Some(err),
                Err(_) => {}
            }
        }

        if let Some(limiter) = &global_limiter {
            if !limiter.wait_until_idle(shutdown_timeout) {
                warn!(
                    "storage SCP shutdown timed out with {} active association(s)",
                    limiter.active()
                );
            }
        }

        if let Some(err) = first_error {
            return Err(err);
        }

        let mut received = 0;
        let mut stored = 0;
        let mut failed = 0;
        for server in &servers {
            let report = server.report();
            received += report.received;
            stored += report.stored;
            failed += report.failed;
        }

        Ok(ScpSessionReport {
            received,
            stored,
            failed,
        })
    }
}

#[cfg(test)]
mod tests {
    use super::{
        registry_for_local_ae, AssociationLimiter, BackgroundStorageScp, BackgroundStorageScpSet,
        StorageScpServer,
    };
    use crate::{
        archive::SqliteArchiveCatalog,
        config::{AppConfig, AppPaths, LocalAeConfig, LocalAeService, RECOMMENDED_MAX_PDU_LENGTH},
        db::Database,
        net::service::{QueryProvider, RetrieveProvider, StorageProvider, VerificationProvider},
    };
    use dicom_dictionary_std::uids::{CT_IMAGE_STORAGE, VERIFICATION};
    use std::{
        fs,
        net::TcpListener,
        process,
        sync::{
            atomic::{AtomicBool, AtomicU32, Ordering},
            Arc,
        },
        time::{Duration, SystemTime, UNIX_EPOCH},
    };

    fn temp_paths() -> AppPaths {
        let unique = format!("dicom-node-client-test-{}", uuid::Uuid::new_v4());
        let base_dir = std::env::temp_dir().join(unique);
        AppPaths {
            config_json: base_dir.join("config.json"),
            sqlite_db: base_dir.join("app.sqlite3"),
            managed_store_dir: base_dir.join("store"),
            logs_dir: base_dir.join("logs"),
            active_log_file: base_dir.join("logs").join("app.log"),
            base_dir,
        }
    }

    use std::io::{BufWriter, Read, Write};

    #[test]
    fn spawn_background_fails_when_port_is_in_use() {
        let occupied = TcpListener::bind("127.0.0.1:0").expect("bind test port");
        let port = occupied
            .local_addr()
            .expect("read occupied listener addr")
            .port();

        let paths = temp_paths();
        paths.ensure().expect("create temp paths");
        let db = Database::open(&paths.sqlite_db).expect("open temp db");
        let config = AppConfig {
            local_ae_title: "TESTAE".to_string(),
            storage_bind_addr: "127.0.0.1".to_string(),
            storage_scp_port: port,
            max_pdu_length: RECOMMENDED_MAX_PDU_LENGTH,
            strict_pdu: true,
            allow_promiscuous_storage: false,
            preferred_store_transfer_syntax: crate::config::StoreTransferSyntaxPreference::default(
            ),
            ..AppConfig::default()
        };
        let server = StorageScpServer::new(config, paths.clone(), db);

        let err = server.spawn_background().unwrap_err();
        assert!(err
            .to_string()
            .contains(&format!("binding storage SCP at 127.0.0.1:{port}")));

        let _ = fs::remove_dir_all(paths.base_dir);
    }

    #[test]
    fn spawn_configured_background_rejects_empty_local_aes() {
        let paths = temp_paths();
        paths.ensure().expect("create temp paths");
        let db = Database::open(&paths.sqlite_db).expect("open temp db");
        let config = AppConfig {
            local_aes: vec![],
            ..AppConfig::default()
        };
        let server = StorageScpServer::new(config, paths.clone(), db);

        let err = server
            .spawn_configured_background()
            .expect_err("empty local_aes should reject server start");

        assert!(err.to_string().contains("local_aes must contain"));
        let _ = fs::remove_dir_all(paths.base_dir);
    }

    #[test]
    fn spawn_configured_background_starts_one_listener_per_local_ae() {
        let paths = temp_paths();
        paths.ensure().expect("create temp paths");
        let db = Database::open(&paths.sqlite_db).expect("open temp db");
        db.init().expect("init temp db");
        let config = AppConfig {
            local_ae_title: "LOCALONE".to_string(),
            storage_bind_addr: "127.0.0.1".to_string(),
            storage_scp_port: 0,
            local_aes: vec![
                LocalAeConfig {
                    title: "LOCALONE".to_string(),
                    bind_addr: "127.0.0.1:0".to_string(),
                    services: vec![LocalAeService::Verification, LocalAeService::Storage],
                    max_concurrent_associations: 1,
                    allowed_calling_aet: vec![],
                    allowed_peer_ips: vec![],
                },
                LocalAeConfig {
                    title: "LOCALTWO".to_string(),
                    bind_addr: "127.0.0.1:0".to_string(),
                    services: vec![LocalAeService::Verification],
                    max_concurrent_associations: 2,
                    allowed_calling_aet: vec![],
                    allowed_peer_ips: vec![],
                },
            ],
            ..AppConfig::default()
        };
        let server = StorageScpServer::new(config, paths.clone(), db);

        let background = server
            .spawn_configured_background()
            .expect("spawn configured local AEs");
        let listeners = background.listeners();
        assert_eq!(listeners.len(), 2);
        assert_eq!(listeners[0].ae_title, "LOCALONE");
        assert_eq!(listeners[0].max_concurrent_associations, 1);
        assert_eq!(listeners[1].ae_title, "LOCALTWO");
        assert_eq!(listeners[1].max_concurrent_associations, 2);
        assert_ne!(listeners[0].port, 0);
        assert_ne!(listeners[1].port, 0);
        assert_ne!(listeners[0].port, listeners[1].port);

        background.stop().expect("stop configured local AEs");
        let _ = fs::remove_dir_all(paths.base_dir);
    }

    #[test]
    fn legacy_storage_scp_ignores_unrelated_configured_ae_bind_port() {
        let occupied = TcpListener::bind("127.0.0.1:0").expect("bind unrelated port");
        let occupied_addr = occupied.local_addr().expect("read occupied addr");
        let paths = temp_paths();
        paths.ensure().expect("create temp paths");
        let db = Database::open(&paths.sqlite_db).expect("open temp db");
        db.init().expect("init temp db");
        let config = AppConfig {
            local_ae_title: "LEGACYAE".to_string(),
            storage_bind_addr: "127.0.0.1".to_string(),
            storage_scp_port: 0,
            local_aes: vec![LocalAeConfig {
                title: "OTHERAE".to_string(),
                bind_addr: occupied_addr.to_string(),
                services: vec![LocalAeService::Verification],
                max_concurrent_associations: 1,
                allowed_calling_aet: vec![],
                allowed_peer_ips: vec![],
            }],
            ..AppConfig::default()
        };
        let server = StorageScpServer::new(config, paths.clone(), db);

        let background = server
            .spawn_background()
            .expect("legacy storage SCP should bind advertised listener");

        assert_eq!(background.listener().ae_title, "LEGACYAE");
        assert_ne!(background.port(), occupied_addr.port());
        background.stop().expect("stop legacy storage scp");
        let _ = fs::remove_dir_all(paths.base_dir);
    }

    #[test]
    fn configured_stop_waits_for_active_associations_before_summing_reports() {
        let limiter = AssociationLimiter::new(1);
        let cancel_flag = AtomicBool::new(false);
        let permit = limiter
            .acquire_until(Duration::from_millis(1), &cancel_flag)
            .expect("acquire active association permit");
        let received = Arc::new(AtomicU32::new(0));
        let stored = Arc::new(AtomicU32::new(0));
        let failed = Arc::new(AtomicU32::new(0));

        let worker_received = received.clone();
        let worker_stored = stored.clone();
        let worker_failed = failed.clone();
        let worker = std::thread::spawn(move || {
            std::thread::sleep(Duration::from_millis(50));
            worker_received.store(1, Ordering::Relaxed);
            worker_stored.store(2, Ordering::Relaxed);
            worker_failed.store(3, Ordering::Relaxed);
            drop(permit);
        });

        let server = BackgroundStorageScp {
            stop_flag: Arc::new(AtomicBool::new(false)),
            received,
            stored,
            failed,
            ae_title: "LOCAL".to_string(),
            bind_addr: "127.0.0.1:0".to_string(),
            max_concurrent_associations: 1,
            port: 0,
            join_handle: Some(std::thread::spawn(|| Ok(()))),
        };
        let set = BackgroundStorageScpSet {
            listeners: Vec::new(),
            servers: vec![server],
            global_limiter: Some(limiter),
            shutdown_timeout: Duration::from_secs(1),
        };

        let report = set.stop().expect("stop configured set");
        worker.join().expect("worker completes");

        assert_eq!(report.received, 1);
        assert_eq!(report.stored, 2);
        assert_eq!(report.failed, 3);
    }

    #[test]
    fn local_ae_service_selection_registers_only_enabled_providers() {
        let paths = temp_paths();
        paths.ensure().expect("create temp paths");
        let db = Database::open(&paths.sqlite_db).expect("open temp db");
        db.init().expect("init temp db");
        let config = AppConfig::default();
        let ae = LocalAeConfig {
            title: "ECHONLY".to_string(),
            bind_addr: "127.0.0.1:0".to_string(),
            services: vec![LocalAeService::Verification],
            max_concurrent_associations: 1,
            allowed_calling_aet: vec![],
            allowed_peer_ips: vec![],
        };
        let verification_provider = VerificationProvider::new();
        let query_provider = QueryProvider::new(SqliteArchiveCatalog::new(db.clone()));
        let retrieve_provider = RetrieveProvider::new(config.clone(), db.clone());
        let storage_provider = StorageProvider::new(config, paths.clone(), db);

        let registry = registry_for_local_ae(
            &ae,
            &verification_provider,
            &query_provider,
            &retrieve_provider,
            &storage_provider,
        );

        assert_eq!(registry.providers().len(), 1);
        assert!(registry.supports_abstract_syntax(VERIFICATION));
        assert!(!registry.supports_abstract_syntax(CT_IMAGE_STORAGE));
        let _ = fs::remove_dir_all(paths.base_dir);
    }

    #[test]
    fn association_limiter_enforces_limit_until_permit_is_dropped() {
        let limiter = super::AssociationLimiter::new(1);
        let cancel_flag = AtomicBool::new(false);

        let first = limiter
            .acquire_until(Duration::from_millis(1), &cancel_flag)
            .expect("first slot");
        assert_eq!(limiter.active(), 1);
        assert!(limiter
            .acquire_until(Duration::from_millis(5), &cancel_flag)
            .is_none());

        drop(first);

        assert!(limiter
            .acquire_until(Duration::from_millis(1), &cancel_flag)
            .is_some());
    }

    #[test]
    fn association_limiter_stops_waiting_when_cancelled() {
        let limiter = super::AssociationLimiter::new(1);
        let cancel_flag = AtomicBool::new(true);

        assert!(limiter
            .acquire_until(Duration::from_millis(50), &cancel_flag)
            .is_none());
        assert_eq!(limiter.active(), 0);
    }

    #[test]
    fn association_permits_hold_global_and_local_slots_until_drop() {
        let global = super::AssociationLimiter::new(2);
        let local = super::AssociationLimiter::new(2);
        let cancel_flag = AtomicBool::new(false);

        let permits = super::acquire_association_permits(
            &local,
            Some(&global),
            Duration::from_millis(1),
            &cancel_flag,
        )
        .expect("combined permits");

        assert_eq!(global.active(), 1);
        assert_eq!(local.active(), 1);

        drop(permits);

        assert_eq!(global.active(), 0);
        assert_eq!(local.active(), 0);
    }

    #[test]
    fn association_permits_do_not_consume_local_slot_when_global_limit_is_full() {
        let global = super::AssociationLimiter::new(1);
        let local = super::AssociationLimiter::new(2);
        let cancel_flag = AtomicBool::new(false);
        let _occupied_global = global
            .acquire_until(Duration::from_millis(1), &cancel_flag)
            .expect("occupy global slot");

        assert!(super::acquire_association_permits(
            &local,
            Some(&global),
            Duration::from_millis(5),
            &cancel_flag,
        )
        .is_none());

        assert_eq!(global.active(), 1);
        assert_eq!(local.active(), 0);
    }

    #[test]
    fn cstore_temp_file_write_is_byte_exact_across_chunks() {
        let base = std::env::temp_dir().join(format!(
            "dicom-node-client-test-temp-write-{}-{}",
            process::id(),
            SystemTime::now()
                .duration_since(UNIX_EPOCH)
                .expect("system clock before unix epoch")
                .as_nanos()
        ));
        fs::create_dir_all(&base).expect("create temp base dir");
        let path = base.join("incoming.dcm");

        let mut writer = BufWriter::new(fs::File::create(&path).expect("create temp file"));

        let chunk1 = b"hello";
        let chunk2 = b"-";
        let chunk3 = b"world";
        writer.write_all(chunk1).expect("write chunk1");
        writer.write_all(chunk2).expect("write chunk2");
        writer.write_all(chunk3).expect("write chunk3");
        writer.flush().expect("flush");
        drop(writer);

        let mut f = fs::File::open(&path).expect("open temp file");
        let mut contents = Vec::new();
        f.read_to_end(&mut contents).expect("read temp file");
        assert_eq!(contents, b"hello-world");

        let _ = fs::remove_dir_all(&base);
    }
}
