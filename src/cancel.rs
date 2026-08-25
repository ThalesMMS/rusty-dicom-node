use std::{
    error::Error,
    fmt, io,
    sync::atomic::{AtomicBool, Ordering},
};

use crate::error::Result;

#[derive(Debug)]
pub struct OperationCancelled;

impl fmt::Display for OperationCancelled {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        f.write_str(&crate::error::msg("error-operation-cancelled"))
    }
}

impl Error for OperationCancelled {}

pub fn is_cancelled(cancel_flag: Option<&AtomicBool>) -> bool {
    cancel_flag
        .map(|flag| flag.load(Ordering::Acquire))
        .unwrap_or(false)
}

pub fn ensure_not_cancelled(cancel_flag: Option<&AtomicBool>) -> Result<()> {
    if is_cancelled(cancel_flag) {
        Err(OperationCancelled.into())
    } else {
        Ok(())
    }
}

pub fn io_error() -> io::Error {
    io::Error::other(OperationCancelled)
}

pub fn is_cancelled_error(error: &anyhow::Error) -> bool {
    error.chain().any(|cause| {
        cause.is::<OperationCancelled>()
            || cause
                .downcast_ref::<io::Error>()
                .map(|error| {
                    error.kind() == io::ErrorKind::Interrupted
                        || error
                            .get_ref()
                            .map(|source| source.is::<OperationCancelled>())
                            .unwrap_or(false)
                })
                .unwrap_or(false)
    })
}
