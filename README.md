# bdk-dart

Dart bindings for the [Bitcoin Dev Kit (BDK)](https://bitcoindevkit.org/) wallet library.
The repo packages the generated UniFFI bindings (`lib/bdk.dart`) together with the
compiled `libbdkffi` native library so Dart and Flutter apps can work with descriptor-based
wallets, key management utilities, and blockchain backends from BDK.

## Repository layout

| Path | Purpose |
| ---- | ------- |
| `bdk-ffi/` | Rust sources and build scripts for the underlying `bdk-ffi` crate. |
| `lib/` | Generated Dart bindings (`bdk.dart`) produced by UniFFI-Dart. |
| `examples/` | Standalone Dart examples that exercise common workflows. |
| `test/` | Integration-style tests that cover wallet creation, persistence, and networking. |
| `bdk_demo/` | Flutter sample app you can point at mobile targets once the bindings are built. |
| `scripts/generate_bindings.sh` | Helper used to rebuild the native library and regenerate the Dart bindings. |

## Prerequisites

To build the bindings locally you need:

- Dart SDK 3.2 or newer (see `pubspec.yaml`).
- Rust toolchain with `cargo` and the native targets you intend to build.
- `clang`/`lld` (or equivalent platform toolchain) for producing the shared library.
- Flutter (optional) if you plan to run `bdk_demo`.

Make sure submodules are cloned because the Rust crate lives in `bdk-ffi/`:

```bash
git clone --recurse-submodules https://github.com/bitcoindevkit/bdk-dart.git
cd bdk-dart
```

## Installation

1. Install dependencies:
   ```bash
   dart pub get
   ```
2. Generate the Dart bindings and native binary:
   ```bash
   ./scripts/generate_bindings.sh
   ```
   The script builds `bdk-ffi`, runs the local `uniffi-bindgen` wrapper, and drops the
   resulting `libbdkffi.*` alongside the freshly generated `lib/bdk.dart`.
3. Make sure the produced library is discoverable at runtime. For CLI usage you can export
   `LD_LIBRARY_PATH`/`DYLD_LIBRARY_PATH` or keep the binary in the same directory as your
   Dart entrypoint.

## Usage

After generating the bindings you can run the examples or consume the package from your
own project. For instance, the `examples/network_example.dart` walkthrough shows how to:

1. Create a new mnemonic and derive BIP84 descriptors.
2. Instantiate a wallet backed by the in-memory persister.
3. Reveal addresses and persist staged changes.
4. Optionally sync with Electrum over TLS.

Run it with:

```bash
dart run examples/network_example.dart
```

When embedding in Flutter, add a path or git dependency on this package and ensure the
native library is bundled per target platform (e.g., via `flutter_rust_bridge`-style
build steps or platform-specific build scripts).

## Testing

Once `lib/bdk.dart` and the native library are available you can execute the Dart test
suite, which covers wallet creation, persistence, offline behavior, and descriptor APIs:

```bash
dart test
```

## License

The Rust crate and generated bindings are dual-licensed under MIT or Apache 2.0 per the
`license = "MIT OR Apache-2.0"` entry in `Cargo.toml`. You may choose either license when
using the library in your project.