#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
PROJECT_ROOT=$(cd "$SCRIPT_DIR/.." && pwd)
ANDROID_BUILD_ROOT="$PROJECT_ROOT/build/android"
OUTPUT_ROOT="android/libs"

usage() {
    cat <<EOF
Usage: $(basename "$0") [--output <dir>]

Copy the built Android shared libraries into <dir>. When <dir> is relative,
it is resolved from the repository root. Defaults to android/libs.
EOF
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        --output|-o)
            OUTPUT_ROOT="${2:-}"
            if [[ -z "$OUTPUT_ROOT" ]]; then
                echo "Error: --output requires a value" >&2
                exit 1
            fi
            shift 2
            ;;
        --help|-h)
            usage
            exit 0
            ;;
        *)
            echo "Unknown option: $1" >&2
            usage >&2
            exit 1
            ;;
    esac
done

if [[ "$OUTPUT_ROOT" != /* ]]; then
    OUTPUT_ROOT="$PROJECT_ROOT/$OUTPUT_ROOT"
fi

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
