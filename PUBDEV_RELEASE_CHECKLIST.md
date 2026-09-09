# Pub.dev Release Checklist

Use this checklist before publishing `bdk_dart` to pub.dev.

## Automated publishing setup (one time)

- [ ] In the [package Admin tab](https://pub.dev/packages/bdk_dart/admin), enable publishing from GitHub Actions for `bitcoindevkit/bdk-dart` with tag pattern `v{{version}}`.
- [ ] In the same pub.dev settings, require the GitHub Actions environment `pub.dev`.
- [ ] In the GitHub repository settings, create the `pub.dev` environment and configure required reviewers. If the maintainer who pushes the tag will also approve publication, leave **Prevent self-review** disabled.
- [ ] Restrict the environment's deployment tags to the release tags and configure repository tag rules to limit who can create or change them.
- [ ] Merge `.github/workflows/publish.yml` and the reusable CI configuration before creating a release tag.

The workflow handles stable tags and prerelease tags such as `v1.0.0-rc.4`.
It checks the tag against `pubspec.yaml`, runs the full CI workflow on the tagged
commit, and then waits for environment approval. The official Dart publishing
workflow performs a dry run and publishes using a short-lived OIDC token; no
stored pub.dev credentials are needed.

Creating the environment alone does not enable approval: required reviewers must
be configured. Confirm that this protection is available and enabled for the
repository before relying on the approval step.

See [Dart's automated publishing documentation](https://dart.dev/tools/pub/automated-publishing).

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

- [ ] Create and push the release tag from the reviewed release commit on `main` (for example, `v1.0.0-rc.4` for package version `1.0.0-rc.4`). Pushing the tag starts publication; creating a GitHub release for an existing tag does not start a new tag-push run.
- [ ] Wait for the **Publish to pub.dev** workflow's version check and full CI validation to pass.
- [ ] Review the tagged commit and approve deployment to the `pub.dev` environment.
- [ ] Confirm the publishing job's dry run and upload succeed. If a run fails, inspect its logs and pub.dev before retrying; do not move an existing release tag or attempt to overwrite a published version.
- [ ] Verify package page renders correctly on pub.dev.
- [ ] Verify version and metadata fields are correct.
- [ ] Perform a clean install test from pub.dev in a sample project.
- [ ] Announce release with release notes.

### Manual fallback

If automated publishing is unavailable, an authorized uploader can check out the
clean release tag and run `dart pub publish --dry-run`, then `dart pub publish`.
First ensure no automated publishing job is running or awaiting approval for the
same version. Do not approve that job after publishing manually.
