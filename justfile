[group("Repo")]
[doc("Default command; list all available commands.")]
@list:
  just --list --unsorted

[group("Repo")]
[doc("Open repo on GitHub in your default browser.")]
repo:
  open https://github.com/bitcoindevkit/bdk-dart

[group("Submodule")]
[doc("Initialize bdk-ffi submodule to committed hash.")]
submodule-init:
  git submodule update --init

[group("Submodule")]
[doc("Hard reset the bdk-ffi submodule to committed hash.")]
submodule-reset:
  git submodule update --force

[group("Submodule")]
[doc("Checkout the bdk-ffi submodule to the latest commit on master.")]
submodule-to-master:
  cd ./bdk-ffi/ \
  && git fetch origin \
  && git checkout master \
  && git pull origin master

[group("Dart")]
[doc("Format the Dart codebase.")]
format:
  dart format .

[group("Dart")]
[doc("Run static analysis.")]
analyze:
  dart analyze

[group("Dart")]
[doc("Generate the API documentation.")]
docs:
  dart doc

[group("Dart")]
[doc("Run all tests, optionally filtering by expression.")]
test *ARGS:
  dart test {{ if ARGS == "" { "" } else { ARGS } }}

[group("Dart")]
[doc("Remove build and tool artifacts to start fresh.")]
clean:
  rm -rf .dart_tool/
  rm -rf build/
  rm -rf target/
  rm -rf bdk-ffi/target/
  rm -rf coverage/
  rm -rf bdk_demo/.dart_tool/
  rm -rf bdk_demo/build/
  rm -rf examples/.dart_tool/
  rm -rf examples/build/