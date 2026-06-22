import 'dart:io';

import 'package:code_assets/code_assets.dart';

import '../hook/build.dart' as build_hook;
import 'check_android_elf_alignment.dart' as elf_alignment;

const _androidNdkVersion = '27.1.12297006';
const _androidApi = 35;
const _assetId = 'package:bdk_dart/uniffi:bdk_dart_ffi';
const _defaultArchitectureName = 'arm64';
const _targetArchitectures = <String, Architecture>{
  'arm64': Architecture.arm64,
  'x64': Architecture.x64,
};
const _androidClangs = <String, String>{
  'arm64': 'aarch64-linux-android35-clang',
  'x64': 'x86_64-linux-android35-clang',
};

Future<void> main(List<String> args) async {
  final options = _parseOptions(args);
  final targetArchitecture = _targetArchitectures[options.architectureName]!;
  final androidClang = _androidClangs[options.architectureName]!;
  final ndk = _findNdk(options.ndkPath);
  final toolchain = _findLlvmToolchain(ndk, androidClang);
  final clang = _tool(toolchain, androidClang);

  await testCodeBuildHook(
    mainMethod: build_hook.main,
    targetOS: OS.android,
    targetArchitecture: targetArchitecture,
    targetAndroidNdkApi: _androidApi,
    cCompiler: CCompilerConfig(
      archiver: _tool(toolchain, 'llvm-ar').uri,
      compiler: clang.uri,
      linker: clang.uri,
    ),
    check: (_, output) async {
      final assets = output.assets.code
          .where((asset) => asset.id == _assetId)
          .toList();
      if (assets.length != 1) {
        _fail(
          'Expected exactly one $_assetId asset, found ${assets.length}: '
          '${output.assets.code.map((asset) => asset.id).join(', ')}',
        );
      }

      final file = assets.single.file;
      if (file == null) {
        _fail('$_assetId did not include a file path');
      }

      final library = File.fromUri(file);
      if (!library.existsSync()) {
        _fail('Hook output file does not exist: ${library.path}');
      }

      stdout.writeln('Hook emitted ${library.path}');
      await elf_alignment.main([library.path]);
    },
  );
}

Directory _findNdk(String? explicitNdkPath) {
  final androidHome = Platform.environment['ANDROID_HOME'];
  final androidSdkRoot = Platform.environment['ANDROID_SDK_ROOT'];
  final candidates = <String?>[
    explicitNdkPath,
    Platform.environment['ANDROID_NDK_HOME'],
    Platform.environment['ANDROID_NDK_ROOT'],
    if (androidHome != null)
      _join(_join(androidHome, 'ndk'), _androidNdkVersion),
    if (androidSdkRoot != null)
      _join(_join(androidSdkRoot, 'ndk'), _androidNdkVersion),
  ];

  for (final path in candidates.whereType<String>()) {
    final ndk = Directory(path);
    if (ndk.existsSync()) {
      return ndk;
    }
  }

  _fail(
    'Android NDK $_androidNdkVersion not found. Set ANDROID_NDK_HOME, '
    'ANDROID_NDK_ROOT, ANDROID_HOME, ANDROID_SDK_ROOT, or pass --ndk <path>.',
  );
}

({String architectureName, String? ndkPath}) _parseOptions(List<String> args) {
  var architectureName = _defaultArchitectureName;
  String? ndkPath;

  for (var index = 0; index < args.length; index++) {
    final arg = args[index];
    if (arg == '--ndk') {
      if (index + 1 >= args.length) {
        _usage();
      }
      ndkPath = args[++index];
    } else if (arg.startsWith('--ndk=')) {
      ndkPath = arg.substring('--ndk='.length);
    } else if (arg == '--arch') {
      if (index + 1 >= args.length) {
        _usage();
      }
      architectureName = args[++index];
    } else if (arg.startsWith('--arch=')) {
      architectureName = arg.substring('--arch='.length);
    } else {
      _usage();
    }
  }

  if (!_targetArchitectures.containsKey(architectureName)) {
    _usage();
  }

  return (architectureName: architectureName, ndkPath: ndkPath);
}

Directory _findLlvmToolchain(Directory ndk, String androidClang) {
  final prebuilt = Directory(
    _join(_join(_join(ndk.path, 'toolchains'), 'llvm'), 'prebuilt'),
  );
  if (!prebuilt.existsSync()) {
    _fail('NDK LLVM prebuilt directory not found: ${prebuilt.path}');
  }

  final candidates =
      prebuilt
          .listSync()
          .whereType<Directory>()
          .where(
            (directory) =>
                _tool(directory, 'llvm-ar').existsSync() &&
                _tool(directory, androidClang).existsSync(),
          )
          .toList()
        ..sort((a, b) => a.path.compareTo(b.path));
  if (candidates.isEmpty) {
    _fail(
      'No NDK LLVM toolchain under ${prebuilt.path} contains llvm-ar and '
      '$androidClang',
    );
  }

  return candidates.first;
}

File _tool(Directory toolchain, String name) {
  final bin = Directory(_join(toolchain.path, 'bin'));
  final tool = File(_join(bin.path, name));
  if (tool.existsSync() || !Platform.isWindows) {
    return tool;
  }

  final cmdTool = File(_join(bin.path, '$name.cmd'));
  if (cmdTool.existsSync()) {
    return cmdTool;
  }

  return File(_join(bin.path, '$name.exe'));
}

String _join(String parent, String child) {
  final separator = Platform.pathSeparator;
  return parent.endsWith(separator)
      ? '$parent$child'
      : '$parent$separator$child';
}

Never _usage() {
  _fail(
    'Usage: dart scripts/check_android_hook_alignment.dart '
    '[--arch <arm64|x64>] [--ndk <path>]',
  );
}

Never _fail(String message) {
  stderr.writeln(message);
  exit(1);
}
