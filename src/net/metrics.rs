use std::sync::{
    atomic::{AtomicU64, Ordering},
    Arc,
};

use serde::{Deserialize, Serialize};

#[derive(Debug, Clone, Default)]
pub struct ServerMetrics {
    inner: Arc<ServerMetricsInner>,
}

#[derive(Debug, Default)]
struct ServerMetricsInner {
    server_associations_accepted_total: AtomicU64,
    server_associations_rejected_total: AtomicU64,
    c_store_received_total: AtomicU64,
    c_store_stored_total: AtomicU64,
    c_store_failed_total: AtomicU64,
    c_find_requests_total: AtomicU64,
    c_find_matches_total: AtomicU64,
    c_move_requests_total: AtomicU64,
    c_move_suboperations_completed_total: AtomicU64,
    c_move_suboperations_failed_total: AtomicU64,
    c_get_requests_total: AtomicU64,
    archive_ingest_bytes_total: AtomicU64,
}

#[derive(Debug, Clone, Default, PartialEq, Eq, Serialize, Deserialize)]
pub struct ServerMetricsSnapshot {
    pub server_associations_accepted_total: u64,
    pub server_associations_rejected_total: u64,
    pub c_store_received_total: u64,
    pub c_store_stored_total: u64,
    pub c_store_failed_total: u64,
    pub c_find_requests_total: u64,
    pub c_find_matches_total: u64,
    pub c_move_requests_total: u64,
    pub c_move_suboperations_completed_total: u64,
    pub c_move_suboperations_failed_total: u64,
    pub c_get_requests_total: u64,
    pub archive_ingest_bytes_total: u64,
}

impl ServerMetrics {
    pub fn snapshot(&self) -> ServerMetricsSnapshot {
        ServerMetricsSnapshot {
            server_associations_accepted_total: load(
                &self.inner.server_associations_accepted_total,
            ),
            server_associations_rejected_total: load(
                &self.inner.server_associations_rejected_total,
            ),
            c_store_received_total: load(&self.inner.c_store_received_total),
            c_store_stored_total: load(&self.inner.c_store_stored_total),
            c_store_failed_total: load(&self.inner.c_store_failed_total),
            c_find_requests_total: load(&self.inner.c_find_requests_total),
            c_find_matches_total: load(&self.inner.c_find_matches_total),
            c_move_requests_total: load(&self.inner.c_move_requests_total),
            c_move_suboperations_completed_total: load(
                &self.inner.c_move_suboperations_completed_total,
            ),
            c_move_suboperations_failed_total: load(&self.inner.c_move_suboperations_failed_total),
            c_get_requests_total: load(&self.inner.c_get_requests_total),
            archive_ingest_bytes_total: load(&self.inner.archive_ingest_bytes_total),
        }
    }

    pub fn record_association_accepted(&self) {
        increment(&self.inner.server_associations_accepted_total, 1);
    }

    pub fn record_association_rejected(&self) {
        increment(&self.inner.server_associations_rejected_total, 1);
    }

    pub fn record_c_store_received(&self) {
        increment(&self.inner.c_store_received_total, 1);
    }

    pub fn record_c_store_stored(&self) {
        increment(&self.inner.c_store_stored_total, 1);
    }

    pub fn record_c_store_failed(&self) {
        increment(&self.inner.c_store_failed_total, 1);
    }

    pub fn record_c_find_request(&self) {
        increment(&self.inner.c_find_requests_total, 1);
    }

    pub fn record_c_find_matches(&self, matches: u64) {
        increment(&self.inner.c_find_matches_total, matches);
    }

    pub fn record_c_move_request(&self) {
        increment(&self.inner.c_move_requests_total, 1);
    }

    pub fn record_c_move_suboperations(&self, completed: u64, failed: u64) {
        increment(&self.inner.c_move_suboperations_completed_total, completed);
        increment(&self.inner.c_move_suboperations_failed_total, failed);
    }

    pub fn record_c_get_request(&self) {
        increment(&self.inner.c_get_requests_total, 1);
    }

    pub fn record_archive_ingest_bytes(&self, bytes: u64) {
        increment(&self.inner.archive_ingest_bytes_total, bytes);
    }
}

fn load(counter: &AtomicU64) -> u64 {
    counter.load(Ordering::Relaxed)
}

fn increment(counter: &AtomicU64, amount: u64) {
    counter.fetch_add(amount, Ordering::Relaxed);
}
