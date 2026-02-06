# Supported Targets

This document defines the current target matrix for `bdk_dart`.
It is the source of truth for what is currently validated versus planned.

## Status labels

- `CI-validated`: covered by the current CI workflow.
- `Targeted`: Rust target is configured, but CI coverage is not complete yet.
- `Not supported`: no current support.

## Runtime scope

- `Dart CLI`: supported where native assets can build and load the Rust library.
- `Flutter`: intended for mobile and desktop targets listed below.
- `Web`: not supported (the package depends on `dart:ffi` / native assets).

## Matrix

| Platform | Architecture | Rust target triple | Status | CI coverage |
| --- | --- | --- | --- | --- |
| Android | `arm64-v8a` | `aarch64-linux-android` | Targeted | No |
| Android | `x86_64` | `x86_64-linux-android` | Targeted | No |
| Android | `armeabi-v7a` | `armv7-linux-androideabi` | Targeted | No |
| iOS | `arm64` (device) | `aarch64-apple-ios` | Targeted | No |
| iOS | `arm64` (simulator) | `aarch64-apple-ios-sim` | Targeted | No |
| iOS | `x86_64` (simulator) | `x86_64-apple-ios` | Targeted | No |
| macOS | `arm64` | `aarch64-apple-darwin` | CI-validated | Yes (`macos-latest`) |
| macOS | `x86_64` | `x86_64-apple-darwin` | Targeted | No |
| Linux | `x86_64` | `x86_64-unknown-linux-gnu` | CI-validated | Yes (`ubuntu-latest`) |
| Linux | `arm64` | `aarch64-unknown-linux-gnu` | Targeted | No |
| Windows | `x86_64` | `x86_64-pc-windows-msvc` | Targeted | No |
| Windows | `arm64` | `aarch64-pc-windows-msvc` | Targeted | No |
| Web | n/a | n/a | Not supported | n/a |

## Notes

- CI coverage above refers to the current workflow at `.github/workflows/ci.yml`.
- Expanding CI coverage is tracked in issue `#25`.
