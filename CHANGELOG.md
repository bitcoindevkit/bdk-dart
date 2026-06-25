# Changelog

All notable changes to `bdk_dart` will be documented in this file.

## 1.0.0-rc.2

- Apply Android 16 KB page-size alignment configuration during native asset builds so `libbdk_dart_ffi.so` meets Google Play requirements.
- Add Android alignment validation coverage for native asset and APK build outputs.

## 1.0.0-rc.1

- Update the generated Dart bindings and native wrapper to `bdk-ffi` `v3.0.0`.
- Add pub.dev package metadata, supported platform declarations, and a package-root `bdk_dart.dart` export.
- Document the pub.dev install path and omit repository-only development files from the published package archive.
