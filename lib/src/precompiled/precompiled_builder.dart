import 'dart:io';

import 'package:code_assets/code_assets.dart';
import 'package:hooks/hooks.dart';
import 'package:logging/logging.dart';
import 'package:path/path.dart' as path;

import 'artifacts_provider.dart';
import 'target.dart';

// Build hook that prefers signed precompiled binaries, with local fallback.
final _log = Logger('bdk_dart.precompiled_builder');

// Callback used when no precompiled artifact is available.
typedef FallbackBuilder =
    Future<void> Function(
      BuildInput input,
      BuildOutputBuilder output,
      List<AssetRouting> assetRouting,
      Logger? logger,
    );

// Builder that downloads verified artifacts when available.
final class PrecompiledBuilder implements Builder {
  const PrecompiledBuilder({
    required this.assetName,
    required this.fallback,
    this.cratePath,
    this.buildModeName = 'release',
  });

  final String assetName;
  final FallbackBuilder fallback;
  final String? cratePath;
  final String buildModeName;

  @override
  Future<void> run({
    required BuildInput input,
    required BuildOutputBuilder output,
    List<AssetRouting> assetRouting = const [ToAppBundle()],
    Logger? logger,
  }) async {
    // Configure logging once for the build process.
    _initLogging();
    if (!input.config.buildCodeAssets) {
      return;
    }

    logger ??= Logger('bdk_dart.PrecompiledBuilder');

    // Resolve crate directory from the package root.
    final crateDirectory = _resolveCrateDirectory(
      rootPath: path.fromUri(input.packageRoot),
      cratePathOptions: cratePath != null ? [cratePath!] : ['native', 'rust'],
    );

    // Provider handles download + signature verification.
    final provider = PrecompiledArtifactProvider(
      input: input,
      buildModeName: buildModeName,
      crateDir: crateDirectory,
    );

    final downloaded = await provider.tryGetPrecompiledArtifact();
    if (downloaded != null) {
      for (final dep in downloaded.dependencies) {
        output.dependencies.add(dep);
      }

      final codeConfig = input.config.code;
      final linkMode = codeConfig.linkMode;

      // Register the verified asset under each routing.
      for (final routing in assetRouting) {
        output.assets.code.add(
          CodeAsset(
            package: input.packageName,
            name: assetName,
            linkMode: linkMode,
            file: File(downloaded.filePath).absolute.uri,
          ),
          routing: routing,
        );
      }
      _log.info('Using precompiled binary for ${codeConfig.targetTriple}');
      return;
    }

    _log.info(
      'Falling back to local build for ${input.config.code.targetTriple}',
    );
    await fallback(input, output, assetRouting, logger);
  }

  // Locate the Rust crate folder based on common paths or override.
  Directory _resolveCrateDirectory({
    required String rootPath,
    required List<String> cratePathOptions,
  }) {
    for (final option in cratePathOptions) {
      final dir = Directory(path.join(rootPath, option));
      if (dir.existsSync()) {
        return dir;
      }
    }
    throw StateError(
      'Could not find crate directory. Checked: $cratePathOptions at $rootPath',
    );
  }
}

// Prevent duplicate log handlers across multiple invocations.
bool _loggingInitialized = false;

void _initLogging() {
  if (_loggingInitialized) return;
  _loggingInitialized = true;

  // Verbose mode is opt-in via env var to avoid noisy builds.
  final verbose = Platform.environment['BDK_DART_PRECOMPILED_VERBOSE'] == '1';
  Logger.root.level = verbose ? Level.ALL : Level.INFO;
  Logger.root.onRecord.listen((rec) {
    final out = rec.level >= Level.WARNING ? stderr : stdout;
    out.writeln('${rec.level.name}: ${rec.message}');
    if (rec.error != null) {
      out.writeln(rec.error);
    }
    if (rec.stackTrace != null && verbose) {
      out.writeln(rec.stackTrace);
    }
  });
}
