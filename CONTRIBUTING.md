# Contributing

Keep PRs focused and include the smallest checks that cover the change.

## Setup

Install Dart 3.10 or newer and Rust stable. Install Flutter stable when working
on `bdk_demo` or mobile targets.

From the repository root:

```bash
dart pub get
```

For the Flutter demo:

```bash
cd bdk_demo
flutter pub get
```

## Bindings

The generated Dart bindings live in `lib/bdk.dart`. Do not edit that file by hand.
When changing native Rust inputs or the pinned `bdk-ffi` dependency, regenerate
bindings and the native library:

```bash
bash ./scripts/generate_bindings.sh
```

## Checks

These shortcuts require `just`; `just ci` runs the full local format, analysis,
test, and demo check set.

Before opening a PR, run the relevant subset:

```bash
just format
just analyze
just test
```

If you touch `bdk_demo`, also run:

```bash
just demo-analyze
just demo-test
```

Integration tests are skipped unless enabled. See `README.md` for
`BDK_DART_RUN_INTEGRATION`, Electrum, and Esplora environment variables.

## Pull requests

Use clear branch names and Conventional Commits messages, for example
`fix: handle null fee rates`, `feat: expose wallet sync options`, or
`docs: update setup instructions`.

If the PR is squashed before merge, make sure the final squash commit or PR
title uses Conventional Commits format. In the PR description, include a short
summary, any relevant issue link, and the checks you ran.

CI runs format, analysis, tests, binding generation, and platform smoke builds.
