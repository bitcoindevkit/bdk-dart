#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
PROJECT_ROOT=$(cd "$SCRIPT_DIR/.." && pwd)
IOS_BUILD_ROOT="$PROJECT_ROOT/build/ios"
OUTPUT_ROOT="ios/Release"
XCFRAMEWORK_NAME="bdkffi.xcframework"

DEVICE_LIB="$IOS_BUILD_ROOT/aarch64-apple-ios/libbdkffi.a"
SIM_ARM64_LIB="$IOS_BUILD_ROOT/aarch64-apple-ios-sim/libbdkffi.a"
SIM_X86_LIB="$IOS_BUILD_ROOT/x86_64-apple-ios/libbdkffi.a"
SIM_UNIVERSAL_DIR="$IOS_BUILD_ROOT/simulator-universal"
SIM_UNIVERSAL_LIB="$SIM_UNIVERSAL_DIR/libbdkffi.a"

usage() {
    cat <<EOF
Usage: $(basename "$0") [--output <dir>]

Create an XCFramework from previously built static libraries and write it to
<dir>. When <dir> is relative, it is resolved from the repository root.
Defaults to ios/Release.
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

if [[ ! -f "$DEVICE_LIB" ]]; then
    echo "Missing device library: $DEVICE_LIB" >&2
    echo "Run scripts/generate_bindings.sh --target ios first." >&2
    exit 1
fi

if [[ ! -f "$SIM_ARM64_LIB" || ! -f "$SIM_X86_LIB" ]]; then
    echo "Missing simulator libraries: $SIM_ARM64_LIB or $SIM_X86_LIB" >&2
    echo "Run scripts/generate_bindings.sh --target ios first." >&2
    exit 1
fi

if ! command -v xcodebuild >/dev/null 2>&1; then
    echo "xcodebuild is required to create an XCFramework" >&2
    exit 1
fi

mkdir -p "$SIM_UNIVERSAL_DIR"

echo "Combining simulator slices with lipo..."
lipo -create "$SIM_ARM64_LIB" "$SIM_X86_LIB" -output "$SIM_UNIVERSAL_LIB"

mkdir -p "$OUTPUT_ROOT"
OUTPUT_PATH="$OUTPUT_ROOT/$XCFRAMEWORK_NAME"
rm -rf "$OUTPUT_PATH"

echo "Creating XCFramework at $OUTPUT_PATH..."
xcodebuild -create-xcframework \
  -library "$DEVICE_LIB" \
  -library "$SIM_UNIVERSAL_LIB" \
  -output "$OUTPUT_PATH"

echo "XCFramework created: $OUTPUT_PATH"
