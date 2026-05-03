use super::prelude::*;

#[test]
fn app_handles_input_while_background_task_is_running() {
    let services = test_services();
    let mut app = TuiApp::new(services.services.clone());

    // Queue a background task so the app transitions into a busy state.
    app.start_task(BackgroundTask::Query {
        node_name_or_id: "node-1".to_string(),
        criteria: QueryCriteria::default(),
    })
    .unwrap();

    // Pull initial task events and start the task.
    app.tick_tasks().unwrap();

    assert!(app.is_busy());

    // While the task is running, the app should still accept input and update state.
    app.handle_key(key(KeyCode::Char('a'))).unwrap();
    assert_eq!(app.editor.content(), "a");

    // Drive the background task to completion while ensuring input remains responsive.
    let deadline = Instant::now() + Duration::from_secs(5);
    while Instant::now() < deadline {
        app.tick_tasks().unwrap();

        if !app.is_busy() {
            break;
        }

        // Simulate additional user input events while work continues.
        app.handle_key(key(KeyCode::Char('b'))).unwrap();

        std::thread::sleep(Duration::from_millis(10));
    }

    assert!(!app.is_busy(), "background task should complete");
    assert!(
        app.editor.content().contains('b'),
        "expected editor to reflect input while busy"
    );
}
