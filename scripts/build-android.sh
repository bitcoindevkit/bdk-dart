#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
PROJECT_ROOT=$(cd "$SCRIPT_DIR/.." && pwd)
ANDROID_BUILD_ROOT="$PROJECT_ROOT/build/android"
OUTPUT_ROOT="$PROJECT_ROOT/android/libs"

if [[ -z "${ANDROID_NDK_ROOT:-}" ]]; then
    echo "ANDROID_NDK_ROOT must be set" >&2
    exit 1
fi

if [[ ! -d "$ANDROID_BUILD_ROOT" ]]; then
    echo "Android build artifacts not found in $ANDROID_BUILD_ROOT" >&2
    echo "Run scripts/generate_bindings.sh --target android first." >&2
    exit 1
fi

mkdir -p "$OUTPUT_ROOT"

for ABI in arm64-v8a armeabi-v7a x86_64; do
    ARTIFACT="$ANDROID_BUILD_ROOT/${ABI}/libbdkffi.so"
    if [[ ! -f "$ARTIFACT" ]]; then
        echo "Missing artifact for $ABI at $ARTIFACT" >&2
        exit 1
    fi

    DEST_DIR="$OUTPUT_ROOT/$ABI"
    mkdir -p "$DEST_DIR"
    cp "$ARTIFACT" "$DEST_DIR/"
    echo "Copied $ABI artifact to $DEST_DIR"
done

echo "Android libraries staged under $OUTPUT_ROOT"
