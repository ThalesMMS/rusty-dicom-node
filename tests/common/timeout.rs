use std::{
    sync::mpsc,
    time::{Duration, Instant},
};

pub fn run_with_timeout<F>(timeout: Duration, test: F)
where
    F: FnOnce() + Send + 'static,
{
    let (tx, rx) = mpsc::channel();
    let started = Instant::now();
    let worker = std::thread::spawn(move || {
        let result = std::panic::catch_unwind(std::panic::AssertUnwindSafe(test));
        let _ = tx.send(result);
    });

    match rx.recv_timeout(timeout) {
        Ok(Ok(())) => {
            if let Err(payload) = worker.join() {
                std::panic::resume_unwind(payload);
            }
        }
        Ok(Err(payload)) => {
            if let Err(join_payload) = worker.join() {
                std::panic::resume_unwind(join_payload);
            }
            std::panic::resume_unwind(payload);
        }
        Err(mpsc::RecvTimeoutError::Timeout) => {
            panic!("integration test timed out after {:?}", started.elapsed())
        }
        Err(mpsc::RecvTimeoutError::Disconnected) => {
            if let Err(payload) = worker.join() {
                std::panic::resume_unwind(payload);
            }
            panic!("integration test worker disconnected before reporting result");
        }
    }
}
