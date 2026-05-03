use super::prelude::*;

use tracing_test::traced_test;

#[traced_test]
#[test]
fn task_failure_is_emitted_to_tracing() {
    let services = test_services();
    let mut app = TuiApp::new(services.services.clone());

    // Do not create the node; this should cause the query task to fail.
    app.start_task(BackgroundTask::Query {
        node_name_or_id: "missing-node".to_string(),
        criteria: QueryCriteria::default(),
    })
    .unwrap();

    let deadline = Instant::now() + Duration::from_secs(5);
    while Instant::now() < deadline {
        app.tick_tasks().unwrap();
        if !app.is_busy() {
            break;
        }
        std::thread::sleep(Duration::from_millis(10));
    }

    assert!(!app.is_busy(), "expected task to complete");

    // Ensure we emitted a failed finished event.
    assert!(
        logs_contain("task.event=\"finished\"") && logs_contain("task.status=\"failed\""),
        "expected tracing logs to include a failed finished event"
    );

    // Ensure the error itself is logged.
    assert!(
        logs_contain("error=") || logs_contain("error ="),
        "expected tracing logs to include an error field"
    );
}
