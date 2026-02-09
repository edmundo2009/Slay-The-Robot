# Testing Framework Documentation

**Framework:** [Godot Runtime Test](https://github.com/khirsahdev/godot-runtime-test)  
**Location:** `addons/runtime_test/`

## 1. Setup

The plugin is installed in `addons/runtime_test/` and enabled in `project.godot`.

## 2. Creating Tests

Create test scripts in the `tests/` directory. Each test script should extend `RuntimeTest`.

### Example: `tests/test_example.gd`
```gdscript
extends RuntimeTest

func test_simple_assertion():
    assert_true(1 + 1 == 2, "Math should work")

func test_node_behavior():
    var node = Node.new()
    add_child(node)
    assert_not_null(node.get_parent(), "Node should be in tree")
    node.queue_free()
```

## 3. Running Tests

### Command Line (Headless)
Run tests by executing the scene file with the test runner arguments:

```powershell
& "C:\Users\Administrator\Downloads\Godot_v4.6-stable_win64.exe\Godot_v4.6-stable_win64_console.exe" --headless tests/test_dummy.tscn -- --set:.:test_val=42 --expect:.:test_val=42
```

### Editor
(If the plugin UI is active)
- Use the **Runtime Test** bottom panel to run tests.

## 4. Best Practices

- **Naming:** Prefix test files with `test_` and test functions with `test_`.
- **Isolation:** Tests run in a real scene tree. Cleanup created nodes in `_exit_tree()` or ensure they are freed.
- **Async:** Use `await` for async operations (e.g., waiting for signals).
