# Precompiled binaries (maintainers)

This document describes how precompiled binaries are built, signed, and published for the plugin.

## Overview

- CI builds and uploads precompiled binaries via `.github/workflows/precompile_binaries.yml`.
- Artifacts are tagged by the crate hash and uploaded to a GitHub release.
- Each binary is signed with an Ed25519 key; the public key is embedded in `pubspec.yaml`.
- The build hook downloads verified binaries when appropriate (depending on mode configuration) and falls back to local builds if needed.

## Mode behavior

The `mode` configuration in `pubspec.yaml` controls fallback behavior:

- `auto`: Uses a heuristic to prefer local builds for development. If the Rust toolchain (`rustup`) is detected, it disables precompiled binaries and builds locally. If no Rust toolchain is found, it uses precompiled binaries. This provides optimal developer experience while keeping end-user builds fast.
- `always`: Throws an exception if download/verification fails; does not fall back.
- `never`: Always builds locally via the standard build hook, ignoring precompiled binaries.

## CI workflow

The workflow runs on `push` to `main` and on manual dispatch. It invokes:

```
dart run bin/build_tool.dart precompile-binaries ...
```

It currently builds macOS/iOS and Android targets.

## Release expectations

- The workflow creates/releases a GitHub release named `precompiled_<crateHash>` where `<crateHash>` comes from the verified crate sources and config.
- If the release already exists, the workflow uploads missing assets without rebuilding anything already present.
- If `gh release view precompiled_<crateHash>` fails locally, rerun `dart run bin/build_tool.dart precompile-binaries ...` with the same crate hash to recreate or update the release.

## How the download works

- The crate hash is computed from the Rust crate sources plus the plugin's `precompiled_binaries` config.
- The release tag is `precompiled_<crateHash>`.
- Assets are named `<targetTriple>_<libraryFileName>` with a matching `.sig` file.
- Each binary is paired with the `.sig` file that the hook uses to verify the download before applying it.
- The hook chooses the correct `lib$cratePackage` (or `lib$cratePackage.so`) artifact by matching the target triple and link mode from the Dart build config.
- On build, the hook downloads the signature and binary, verifies it, then places it in the build output.
- If any step fails (missing asset, bad signature), the hook builds locally via the standard build hook.

## Manual release (local)

Use this when debugging CI or producing artifacts manually.

Required environment variables:

- `PRIVATE_KEY` (Ed25519 private key, hex-encoded, 64 bytes)
- `GH_TOKEN` or `GITHUB_TOKEN` (GitHub token with release upload permissions)

Example:

```
dart run bin/build_tool.dart precompile-binaries \
  --manifest-dir="native" \
  --crate-package="bdk_dart_ffi" \
  --repository="owner/repo" \
  --os=macos

```

## Troubleshooting & ops tips

- If `gh release view precompiled_<crateHash>` shows a release without the expected `<targetTriple>_` assets, rerun the build locally to regenerate them.
- A stale crate hash (because sources or `precompiled_binaries` config changed) will point to a release that either doesn’t exist yet or lacks current binaries; re-run `dart run bin/build_tool.dart hash --manifest-dir=native` to confirm the hash and rebuild with the same inputs.
- Use `gh release view precompiled_<crateHash> --json assets --jq '.assets[].name'` to inspect what’s uploaded and verify `.sig` coverage.
- When debugging download failures, set `BDK_DART_PRECOMPILED_VERBOSE=1` to see why the hook skipped an asset.

## Configuration knobs

- `rust-toolchain.toml` controls the Rust channel and target list.
- `pubspec.yaml` under `bdk_dart.precompiled_binaries` must include:
  - `artifact_host` (owner/repo)
  - `public_key` (Ed25519 public key, hex-encoded, 32 bytes)

## Environment, keys, and secrets

- `PRIVATE_KEY`: 64-byte hex string (Ed25519 private key). This must be set locally or as a GitHub Actions secret before running `precompile-binaries`. Keep it out of source control.
- `PUBLIC_KEY`: Add the matching 32-byte hex public key to `pubspec.yaml` so consumers can verify downloads.
- `GH_TOKEN` / `GITHUB_TOKEN`: release upload permissions (already used in the CI workflow).
- `BDK_DART_PRECOMPILED_VERBOSE=1`: optional; shows download and verification details when debugging consumer builds.

Generate a keypair with `dart run bin/build_tool.dart gen-key` and copy the printed `PRIVATE_KEY`/`PUBLIC_KEY` values. Rotate the pair if you ever suspect the signing key was exposed, and update every release’s config accordingly.

## Security reminder

- Treat the `PRIVATE_KEY` used for signing as highly sensitive; do not commit it to version control and rotate it immediately if you suspect compromise.
- Update the public key in `pubspec.yaml` if the private key is rotated so consumers can still verify downloads.
