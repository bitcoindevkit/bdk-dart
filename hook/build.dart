import 'dart:io';
import 'package:hooks/hooks.dart';
import 'package:code_assets/code_assets.dart';

void main(List<String> args) async {
  await build(args, (input, output) async {
    // Get paths
    final bdkFfiPath = Directory.fromUri(
      input.packageRoot.resolve('/native'),
    ).path;

    // Determine library name based on OS
    final String libName;
    final String buildMode;
    if (Platform.isWindows) {
      libName = 'bdkffi.dll';
      buildMode = 'debug'; // TODO: detect from build config
    } else if (Platform.isMacOS) {
      libName = 'libbdkffi.dylib';
      buildMode = 'debug';
    } else if (Platform.isLinux) {
      libName = 'libbdkffi.so';
      buildMode = 'debug';
    } else {
      throw UnsupportedError(
        'Unsupported platform: ${Platform.operatingSystem}',
      );
    }

    // Build with cargo
    print('Building BDK FFI library...');
    final result = await Process.run('cargo', [
      'build',
      if (buildMode == 'release') '--release',
      '--features',
      'dart',
    ], workingDirectory: bdkFfiPath);

    if (result.exitCode != 0) {
      print('cargo build failed:');
      print(result.stdout);
      print(result.stderr);
      throw Exception('Failed to build Rust library');
    }

    // Add the built library as a code asset
    final builtLib = File('$bdkFfiPath/target/$buildMode/$libName');
    if (!builtLib.existsSync()) {
      throw Exception('Built library not found at ${builtLib.path}');
    }

    output.assets.code.add(
      CodeAsset(
        name: 'bdkffi',
        file: builtLib.uri,
        package: input.packageName,
        linkMode: DynamicLoadingBundled(),
      ),
    );

    print('BDK FFI library built successfully!');
  });
}
