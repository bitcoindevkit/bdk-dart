import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:toml/toml.dart';

// Parses rust-toolchain.toml and exposes channel/targets.
class RustToolchain {
  RustToolchain._({
    required this.channel,
    required this.targets,
  });

  final String channel;
  final List<String> targets;

  // Load rust-toolchain.toml from a crate directory.
  static RustToolchain load(String manifestDir) {
    final file = File(path.join(manifestDir, 'rust-toolchain.toml'));
    if (!file.existsSync()) {
      throw StateError('rust-toolchain.toml not found: ${file.path}');
    }
    return _parseToolchain(file.path);
  }

  // Parse the toolchain TOML into a RustToolchain instance.
  static RustToolchain _parseToolchain(String toolchainTomlPath) {
    final doc = TomlDocument.loadSync(toolchainTomlPath).toMap();
    final toolchain = doc['toolchain'];
    if (toolchain is! Map) {
      throw FormatException('Missing [toolchain] table in $toolchainTomlPath');
    }
    final channel = toolchain['channel'];
    if (channel is! String || channel.trim().isEmpty) {
      throw FormatException('Missing toolchain.channel in $toolchainTomlPath');
    }
    final targetsRaw = toolchain['targets'];
    final targets = targetsRaw is List
        ? targetsRaw.whereType<String>().toList(growable: false)
        : const <String>[];
    return RustToolchain._(
      channel: channel.trim(),
      targets: targets,
    );
  }

  // Filter targets for a given OS label.
  List<String> targetsForOs(String os) {
    final normalized = _normalizeOs(os);
    if (normalized == null) {
      return targets;
    }
    return _filterTargets(targets, normalized);
  }

  // Normalize OS aliases used by CLI/workflows.
  static String? _normalizeOs(String raw) {
    final v = raw.trim().toLowerCase();
    return switch (v) {
      'linux' || 'ubuntu-latest' => 'linux',
      'macos' || 'darwin' || 'macos-latest' => 'macos',
      'windows' || 'windows-latest' => 'windows',
      'android' => 'android',
      'ios' => 'ios',
      'all' => null,
      _ => v.isEmpty ? null : v,
    };
  }

  // Apply OS-specific target filtering.
  static List<String> _filterTargets(List<String> targets, String os) {
    bool include(String t) => switch (os) {
      'macos' => t.endsWith('apple-darwin') || t.contains('apple-ios'),
      'ios' => t.contains('apple-ios'),
      'linux' => t.endsWith('unknown-linux-gnu'),
      'windows' => t.endsWith('pc-windows-msvc'),
      'android' => t.endsWith('linux-android') || t.endsWith('linux-androideabi'),
      _ => false,
    };
    return targets.where(include).toList(growable: false);
  }
}

