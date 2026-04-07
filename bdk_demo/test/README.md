# Test Layout

Tests are grouped by app layer to keep the suite easy to navigate as features grow.

- `test/presentation/`: widget and UI behavior tests
- `test/providers/`: Riverpod notifier/provider state tests
- `test/services/`: service and mapping/unit logic tests
- `test/integration/` (future): multi-service or app-flow integration tests

Naming convention:
- Use `*_test.dart` suffix.
- Prefer behavior-focused names (example: `app_shell_test.dart`).
