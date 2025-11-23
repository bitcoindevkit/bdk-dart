#!/usr/bin/env bash
set -euo pipefail

# Get the directory where this script is located to set
# paths independently of the current working directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BDK_DART_DIR="$SCRIPT_DIR/.."
BDK_FFI_DIR="$BDK_DART_DIR/../bdk-ffi"
NATIVE_DIR="$BDK_DART_DIR/native"

OS=$(uname -s)
echo "Running on $OS"

# Navigate to bdk-dart directory (parent of scripts/)
cd "$BDK_DART_DIR"

dart --version
dart pub get

# Install Rust targets if on macOS
if [[ "$OS" == "Darwin" ]]; then
    LIBNAME=libbdkffi.dylib
elif [[ "$OS" == "Linux" ]]; then
    LIBNAME=libbdkffi.so
else
    echo "Unsupported os: $OS"
    exit 1
fi

# Initialize and update bdk-ffi submodule
git submodule update --init --recursive

# Checkout specific version (branch, tag, or commit)
cd "$BDK_FFI_DIR"
git checkout master # Change 'master' to a specific tag before releasing

# Navigate to bdk-ffi directory in the embedded bdk-ffi submodule
cd "$BDK_FFI_DIR"
echo "Building bdk-ffi..."
cargo build --profile dev -p bdk-ffi

# Generate Dart bindings using local uniffi-bindgen wrapper
cd "$BDK_DART_DIR"
cargo run --profile dev --bin uniffi-bindgen -- generate --library --language dart --out-dir "$BDK_DART_DIR/lib/" target/debug/$LIBNAME

echo "Bindings generated successfully!"
echo "Note: Native library compilation is now handled automatically by Native Assets (hook/build.dart)"
echo "      when you run 'dart pub get' or 'flutter pub get'"

# Copy the bdk-ffi folder from bdk-ffi to bdk-dart/native
# so that it can be included in the published package
# and built by Native Assets hook/build.dart
mkdir -p "$NATIVE_DIR"
rsync -a --delete "$BDK_FFI_DIR/bdk-ffi/" "$NATIVE_DIR/"