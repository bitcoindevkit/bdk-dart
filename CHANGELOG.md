# Changelog

All notable changes to `bdk_dart` will be documented in this file.

## 1.0.0-rc.4

- Update the native dependency to `bdk-ffi` `v3.1.0` and regenerate the Dart bindings.
- Enforce locked native dependencies and check generated binding drift in CI.

## 1.0.0-rc.3

- Make native library builds reproducible by tracking `native/Cargo.lock`, shipping it in the pub.dev archive, and pinning release builds to a single Rust codegen unit.

## 1.0.0-rc.2

- Apply Android 16 KB page-size alignment configuration during native asset builds so `libbdk_dart_ffi.so` meets Google Play requirements.
- Add Android alignment validation coverage for native asset and APK build outputs.

## 1.0.0-rc.1

- Update the generated Dart bindings and native wrapper to `bdk-ffi` `v3.0.0`.
- Add pub.dev package metadata, supported platform declarations, and a package-root `bdk_dart.dart` export.
- Document the pub.dev install path and omit repository-only development files from the published package archive.
