#!/usr/bin/env bash
set -euo pipefail

# Get the directory where this script is located to set
# paths independently of the current working directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BDK_DART_DIR="$SCRIPT_DIR/.."
BDK_FFI_DIR="$BDK_DART_DIR/bdk-ffi"
NATIVE_DIR="$BDK_DART_DIR/native"

OS=$(uname -s)
echo "Running on $OS"

# Navigate to bdk-dart directory (parent of scripts/)
cd "$BDK_DART_DIR"

dart --version
dart pub get

# Install Rust targets if on macOS
if [[ "$OS" == "Darwin" ]]; then
    LIBNAME=libbdk_ffi.dylib
elif [[ "$OS" == "Linux" ]]; then
    LIBNAME=libbdk_ffi.so
else
    echo "Unsupported os: $OS"
    exit 1
fi

# Initialize and update bdk-ffi submodule
git submodule update --init --recursive

# Checkout specific version (branch, tag, or commit)
cd "$BDK_FFI_DIR"
git checkout master # Change 'master' to a specific tag before releasing

# Navigate to bdk-dart directory to build using root Cargo.toml
cd "$BDK_DART_DIR"
echo "Building bdk-ffi..."
cargo build --profile dev

# Generate Dart bindings using local uniffi-bindgen wrapper
cargo run --profile dev --bin uniffi-bindgen -- generate --library --language dart --out-dir "$BDK_DART_DIR/lib/" "$BDK_DART_DIR/target/debug/$LIBNAME"

echo "Bindings generated successfully!"
echo "Note: Native library compilation is now handled automatically by Native Assets (hook/build.dart)"
echo "      when you run 'dart pub get' or 'flutter pub get'"

# Copy the bdk-ffi folder from bdk-ffi to bdk-dart/native
# so that it can be included in the published package
# and built by Native Assets hook/build.dart
mkdir -p "$NATIVE_DIR"
rsync -a --delete --exclude 'target' "$BDK_FFI_DIR/bdk-ffi/" "$NATIVE_DIR/"

# Update library name to bdk_ffi (with underscore) to match hook expectations
sed -i.bak 's/name = "bdkffi"/name = "bdk_ffi"/' "$NATIVE_DIR/Cargo.toml" && rm "$NATIVE_DIR/Cargo.toml.bak"

# Add cross-compilation targets to rust-toolchain.toml
cat >> "$NATIVE_DIR/rust-toolchain.toml" << 'EOF'
targets = [
    # Android
    "armv7-linux-androideabi",
    "aarch64-linux-android",
    "x86_64-linux-android",

    # iOS (device + simulator)
    "aarch64-apple-ios",
    "aarch64-apple-ios-sim",
    "x86_64-apple-ios",

    # Windows
    "aarch64-pc-windows-msvc",
    "x86_64-pc-windows-msvc",

    # Linux
    "aarch64-unknown-linux-gnu",
    "x86_64-unknown-linux-gnu",

    # macOS
    "aarch64-apple-darwin",
    "x86_64-apple-darwin",
]
EOF