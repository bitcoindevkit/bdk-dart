# Allow experimental features like [group(...)]
set unstable := true

set shell := ["sh", "-c"]

set windows-shell := ["powershell.exe", "-Command"]

windows_generate_bindings := "cd native; if (-not $?) { exit 1 }; cargo build --profile dev; if (-not $?) { exit 1 }; cargo run --profile dev --bin uniffi-bindgen -- generate --library target/debug/bdk_dart_ffi.dll --language dart --config uniffi.toml --out-dir ../lib/"

unix_generate_bindings := "bash ./scripts/generate_bindings.sh"

windows_clean := "'.dart_tool', 'build', 'native/target', 'coverage', 'bdk_demo/.dart_tool', 'bdk_demo/build', 'example/.dart_tool', 'example/build' | Where-Object { Test-Path $_ } | ForEach-Object { Remove-Item -Recurse -Force $_ }"

unix_clean := "rm -rf .dart_tool/ build/ native/target/ coverage/ bdk_demo/.dart_tool/ bdk_demo/build/ example/.dart_tool/ example/build/"

opener := if os_family() == "windows" { "Start-Process" } else if os() == "macos" { "open" } else { "xdg-open" }

[group("Repo")]
[doc("Default command; list all available commands.")]
@list:
  just --list --unsorted

[group("Repo")]
[doc("Open repo on GitHub in your default browser.")]
repo:
  @{{ opener }} "https://github.com/bitcoindevkit/bdk-dart"

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
  {{ if os() == "windows" { windows_generate_bindings } else { unix_generate_bindings } }}

[group("Demo")]
[doc("Run Flutter analysis for the demo app.")]
[working-directory: "bdk_demo"]
demo-analyze:
  flutter analyze

[group("Demo")]
[doc("Run Flutter tests for the demo app.")]
[working-directory: "bdk_demo"]
demo-test *ARGS:
  flutter test {{ if ARGS == "" { "" } else { ARGS } }}

[group("CI")]
[doc("Run the same checks as CI.")]
ci:
  just format
  just analyze
  just test
  just demo-analyze
  just demo-test

[group("Dart")]
[doc("Remove build and tool artifacts to start fresh.")]
clean:
  {{ if os() == "windows" { windows_clean } else { unix_clean } }}