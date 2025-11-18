#!/usr/bin/env bash
set -euo pipefail

TARGET="desktop"
while [[ $# -gt 0 ]]; do
    case "$1" in
        --target)
            TARGET="${2:-desktop}"
            shift 2
            ;;
        --help|-h)
            echo "Usage: $0 [--target desktop|ios|android]"
            exit 0
            ;;
        *)
            echo "Unknown option: $1" >&2
            exit 1
            ;;
    esac
done

OS=$(uname -s)
ARCH=$(uname -m)
echo "Running on $OS ($ARCH)"

dart --version
dart pub get

mkdir -p lib
rm -f lib/bdk.dart

if [[ "$OS" == "Darwin" ]]; then
    LIBNAME=libbdkffi.dylib
elif [[ "$OS" == "Linux" ]]; then
    LIBNAME=libbdkffi.so
else
    echo "Unsupported os: $OS" >&2
    exit 1
fi

# Run from the specific crate inside the embedded submodule
cd ./bdk-ffi/bdk-ffi/

generate_bindings() {
    echo "Building bdk-ffi crate and generating Dart bindings..."
    cargo build --profile dev -p bdk-ffi
    (cd ../../ && cargo run --profile dev --bin uniffi-bindgen -- --language dart --library bdk-ffi/bdk-ffi/target/debug/$LIBNAME --out-dir lib/)
}

build_ios() {
    echo "Building iOS static libraries..."
    rustup target add aarch64-apple-ios x86_64-apple-ios aarch64-apple-ios-sim >/dev/null

    PROFILE="release-smaller"
    OUT_ROOT="../../build/ios"
    mkdir -p "$OUT_ROOT"

    for TARGET_TRIPLE in aarch64-apple-ios x86_64-apple-ios aarch64-apple-ios-sim; do
        echo "  -> $TARGET_TRIPLE"
        cargo build --profile "$PROFILE" -p bdk-ffi --target "$TARGET_TRIPLE"
        ARTIFACT="target/${TARGET_TRIPLE}/${PROFILE}/libbdkffi.a"
        DEST_DIR="$OUT_ROOT/${TARGET_TRIPLE}"
        mkdir -p "$DEST_DIR"
        cp "$ARTIFACT" "$DEST_DIR/"
    done
}

build_android() {
    if [[ -z "${ANDROID_NDK_ROOT:-}" ]]; then
        echo "ANDROID_NDK_ROOT must be set to build Android artifacts" >&2
        exit 1
    fi

    echo "Building Android shared libraries..."
    rustup target add aarch64-linux-android armv7-linux-androideabi x86_64-linux-android >/dev/null

    API_LEVEL=24
    case "$OS" in
        Darwin)
            HOST_OS=darwin
            ;;
        Linux)
            HOST_OS=linux
            ;;
        *)
            echo "Unsupported host for Android builds: $OS" >&2
            exit 1
            ;;
    esac

    case "$ARCH" in
        x86_64)
            HOST_ARCH=x86_64
            ;;
        arm64|aarch64)
            HOST_ARCH=arm64
            ;;
        *)
            echo "Unsupported architecture for Android builds: $ARCH" >&2
            exit 1
            ;;
    esac

    TOOLCHAIN="$ANDROID_NDK_ROOT/toolchains/llvm/prebuilt/${HOST_OS}-${HOST_ARCH}/bin"
    if [[ ! -d "$TOOLCHAIN" ]]; then
        echo "Unable to locate NDK toolchain at $TOOLCHAIN" >&2
        exit 1
    fi

    OUT_ROOT="../../build/android"
    mkdir -p "$OUT_ROOT"

    for TARGET_TRIPLE in aarch64-linux-android armv7-linux-androideabi x86_64-linux-android; do
        case "$TARGET_TRIPLE" in
            aarch64-linux-android)
                ABI="arm64-v8a"
                CLANG="${TOOLCHAIN}/aarch64-linux-android${API_LEVEL}-clang"
                TARGET_ENV_LOWER="aarch64_linux_android"
                ;;
            armv7-linux-androideabi)
                ABI="armeabi-v7a"
                CLANG="${TOOLCHAIN}/armv7a-linux-androideabi${API_LEVEL}-clang"
                TARGET_ENV_LOWER="armv7_linux_androideabi"
                ;;
            x86_64-linux-android)
                ABI="x86_64"
                CLANG="${TOOLCHAIN}/x86_64-linux-android${API_LEVEL}-clang"
                TARGET_ENV_LOWER="x86_64_linux_android"
                ;;
        esac

        TARGET_ENV=$(echo "$TARGET_TRIPLE" | tr '[:lower:]' '[:upper:]' | tr '-' '_')

        export CARGO_TARGET_${TARGET_ENV}_LINKER="$CLANG"
        export CARGO_TARGET_${TARGET_ENV}_AR="${TOOLCHAIN}/llvm-ar"

        export CC_${TARGET_ENV_LOWER}="$CLANG"
        export AR_${TARGET_ENV_LOWER}="${TOOLCHAIN}/llvm-ar"

        echo "  -> $TARGET_TRIPLE ($ABI)"
        cargo build --profile release-smaller -p bdk-ffi --target "$TARGET_TRIPLE"
        ARTIFACT="target/${TARGET_TRIPLE}/release-smaller/libbdkffi.so"
        DEST_DIR="$OUT_ROOT/$ABI"
        mkdir -p "$DEST_DIR"
        cp "$ARTIFACT" "$DEST_DIR/"
    done
}

case "$TARGET" in
    ios)
        generate_bindings
        build_ios
        ;;
    android)
        generate_bindings
        build_android
        ;;
    desktop|*)
        generate_bindings
        if [[ "$OS" == "Darwin" ]]; then
            echo "Generating native macOS binaries..."
            rustup target add aarch64-apple-darwin x86_64-apple-darwin >/dev/null
            cargo build --profile dev -p bdk-ffi --target aarch64-apple-darwin &
            cargo build --profile dev -p bdk-ffi --target x86_64-apple-darwin &
            wait

            echo "Building macOS fat library"
            lipo -create -output ../../$LIBNAME \
                target/aarch64-apple-darwin/debug/$LIBNAME \
                target/x86_64-apple-darwin/debug/$LIBNAME
        else
            echo "Generating native Linux binaries..."
            rustup target add x86_64-unknown-linux-gnu >/dev/null
            cargo build --profile dev -p bdk-ffi --target x86_64-unknown-linux-gnu

            echo "Copying bdk-ffi binary"
            cp target/x86_64-unknown-linux-gnu/debug/$LIBNAME ../../$LIBNAME
        fi
        ;;
esac

echo "All done!"
