#!/usr/bin/env bash
set -euo pipefail

# Get the directory where this script is located to set
# paths independently of the current working directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BDK_DART_DIR="$SCRIPT_DIR/.."
NATIVE_DIR="$BDK_DART_DIR/native"

OS=$(uname -s)
ARCH=$(uname -m)
echo "Running on $OS ($ARCH)"

# Navigate to bdk-dart directory (parent of scripts/)
cd "$BDK_DART_DIR"

dart --version
dart pub get

# Install Rust targets if on macOS
if [[ "$OS" == "Darwin" ]]; then
    LIBNAME=libbdk_dart_ffi.dylib
elif [[ "$OS" == "Linux" ]]; then
    LIBNAME=libbdk_dart_ffi.so
else
    echo "Unsupported os: $OS" >&2
    exit 1
fi

# Navigate to the native directory to build the rust code using Cargo.toml
cd "$NATIVE_DIR"
echo "Building bdk-dart-ffi..."
cargo build --profile dev

# Generate Dart bindings using local uniffi-bindgen wrapper
cargo run --profile dev --bin uniffi-bindgen -- generate --library --language dart --out-dir "$BDK_DART_DIR/lib/" "$NATIVE_DIR/target/debug/$LIBNAME"

echo "Bindings generated successfully!"