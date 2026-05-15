[group("Repo")]
[doc("Default command; list all available commands.")]
@list:
  just --list --unsorted

[group("Repo")]
[doc("Open repo on GitHub in your default browser.")]
repo:
  open https://github.com/bitcoindevkit/bdk-dart

[group("Dart")]
[doc("Format the Dart codebase.")]
format:
  dart format lib test example bdk_demo/lib bdk_demo/test

[group("Dart")]
[doc("Run static analysis.")]
analyze:
  dart analyze --fatal-infos --fatal-warnings lib test example

[group("Dart")]
[doc("Generate the API documentation.")]
docs:
  dart doc

[group("Dart")]
[doc("Run all tests, optionally filtering by expression.")]
test *ARGS:
  dart test {{ if ARGS == "" { "" } else { ARGS } }}

[group("Bindings")]
[doc("Build native library and regenerate bindings.")]
generate-bindings:
  bash ./scripts/generate_bindings.sh

[group("Demo")]
[doc("Run Flutter analysis for the demo app.")]
demo-analyze:
  cd bdk_demo && flutter analyze

[group("CI")]
[doc("Run the same checks as CI.")]
ci:
  just format
  just analyze
  just test
  just demo-analyze

[group("Dart")]
[doc("Remove build and tool artifacts to start fresh.")]
clean:
  rm -rf .dart_tool/
  rm -rf build/
  rm -rf native/target/
  rm -rf coverage/
  rm -rf bdk_demo/.dart_tool/
  rm -rf bdk_demo/build/
  rm -rf example/.dart_tool/
  rm -rf example/build/
