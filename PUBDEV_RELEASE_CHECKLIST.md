# Pub.dev Release Checklist

Use this checklist before publishing `bdk_dart` to pub.dev.

## 1. Package metadata

- [ ] `pubspec.yaml` includes a clear `description`.
- [ ] `pubspec.yaml` includes `license` and it matches repository licensing.
- [ ] `pubspec.yaml` includes `homepage`.
- [ ] `pubspec.yaml` includes `repository`.
- [ ] `pubspec.yaml` includes `issue_tracker`.
- [ ] Version is bumped to the intended release version.

## 2. Source and generated bindings

- [ ] Native and bindings changes are finalized.
- [ ] `lib/bdk.dart` is regenerated if needed.
- [ ] `scripts/generate_bindings.sh` succeeds on a clean checkout.

## 3. Local quality gates

Run all checks from repository root:

```bash
dart pub get
dart format --output=none --set-exit-if-changed lib test example bdk_demo/lib bdk_demo/test
dart analyze --fatal-infos --fatal-warnings lib test example
dart test
cd bdk_demo && flutter pub get && flutter analyze
```

- [ ] All commands above pass locally.
- [ ] CI is green on `main`.

## 4. Release prep

- [ ] `README.md` is up to date for install and usage.
- [ ] `SUPPORTED_TARGETS.md` is up to date.
- [ ] Changelog/release notes are prepared.
- [ ] Release tag/version plan is confirmed with maintainers.

## 5. Publish dry run

```bash
dart pub publish --dry-run
```

- [ ] Dry run passes with no unexpected warnings/errors.

## 6. Publish and verify

- [ ] Publish to pub.dev from the release commit/tag.
- [ ] Verify package page renders correctly on pub.dev.
- [ ] Verify version and metadata fields are correct.
- [ ] Perform a clean install test from pub.dev in a sample project.
- [ ] Announce release with release notes.
