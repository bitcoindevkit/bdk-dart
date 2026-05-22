#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BDK_DART_DIR="$SCRIPT_DIR/.."
NATIVE_DIR="$BDK_DART_DIR/native"
ENFORCE_NATIVE_HASH="${BDK_DART_ENFORCE_NATIVE_HASH:-0}"

case "$(uname -s)" in
    Darwin)
        LIBNAME=libbdk_dart_ffi.dylib
        ;;
    Linux)
        LIBNAME=libbdk_dart_ffi.so
        ;;
    *)
        echo "Unsupported os: $(uname -s)" >&2
        exit 1
        ;;
esac

hash_file() {
    local file="$1"
    if command -v sha256sum >/dev/null 2>&1; then
        sha256sum "$file" | awk '{print $1}'
    else
        shasum -a 256 "$file" | awk '{print $1}'
    fi
}

cd "$BDK_DART_DIR"

echo "Regenerating Dart bindings..."
bash "$BDK_DART_DIR/scripts/generate_bindings.sh"

echo "Checking generated binding drift..."
if ! git diff --exit-code -- lib/bdk.dart; then
    echo "Generated bindings differ from committed lib/bdk.dart." >&2
    exit 1
fi

TMP_DIR="$(mktemp -d)"
cleanup() {
    rm -rf "$TMP_DIR"
}
trap cleanup EXIT

declare -a HASHES=()

for build_index in 1 2; do
    TARGET_DIR="$TMP_DIR/target-$build_index"
    ARTIFACT="$TARGET_DIR/release/$LIBNAME"

    echo "Building native library pass $build_index..."
    CARGO_INCREMENTAL=0 cargo build \
        --locked \
        --release \
        --manifest-path "$NATIVE_DIR/Cargo.toml" \
        --target-dir "$TARGET_DIR"

    if [[ ! -f "$ARTIFACT" ]]; then
        echo "Expected native artifact not found: $ARTIFACT" >&2
        exit 1
    fi

    HASH="$(hash_file "$ARTIFACT")"
    HASHES+=("$HASH")
    echo "pass $build_index: $HASH  $ARTIFACT"
done

if [[ "${HASHES[0]}" != "${HASHES[1]}" ]]; then
    echo "Native library hashes differ between clean builds." >&2
    echo "This is currently reported as native build input hygiene rather than enforced binary reproducibility." >&2
    echo "Set BDK_DART_ENFORCE_NATIVE_HASH=1 once the UniFFI trait-ordering fix is available in the native dependency stack." >&2
    if [[ "$ENFORCE_NATIVE_HASH" == "1" ]]; then
        exit 1
    fi
else
    echo "Native library hashes match."
fi

echo "Reproducibility hygiene check completed."
