import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:path/path.dart' as path;
import 'package:yaml/yaml.dart';

// Computes a stable hash for crate inputs used in precompiled releases.
class CrateHash {
  // Compute (and optionally cache) the crate hash.
  static String compute(String manifestDir, {String? tempStorage}) {
    return CrateHash._(
      manifestDir: manifestDir,
      tempStorage: tempStorage,
    )._compute();
  }

  CrateHash._({required this.manifestDir, required this.tempStorage});

  final String manifestDir;
  final String? tempStorage;

  // Collect all files that participate in the crate hash.
  static List<File> collectFiles(String manifestDir) {
    return CrateHash._(manifestDir: manifestDir, tempStorage: null)._getFiles();
  }

  String _compute() {
    final files = _getFiles();
    final tempStorage = this.tempStorage;
    if (tempStorage != null) {
      // Quick hash keyed by file path + size + mtime to reuse cached full hash.
      final quickHash = _computeQuickHash(files);
      final quickHashFolder = Directory(path.join(tempStorage, 'crate_hash'));
      quickHashFolder.createSync(recursive: true);
      final quickHashFile = File(path.join(quickHashFolder.path, quickHash));
      if (quickHashFile.existsSync()) {
        return quickHashFile.readAsStringSync();
      }
      final hash = _computeHash(files);
      quickHashFile.writeAsStringSync(hash);
      return hash;
    }
    return _computeHash(files);
  }

  // Fast hash over file metadata to key the cache.
  String _computeQuickHash(List<File> files) {
    final output = AccumulatorSink<Digest>();
    final input = sha256.startChunkedConversion(output);

    final data = ByteData(8);
    for (final file in files) {
      input.add(utf8.encode(file.path));
      final stat = file.statSync();
      data.setUint64(0, stat.size);
      input.add(data.buffer.asUint8List());
      data.setUint64(0, stat.modified.millisecondsSinceEpoch);
      input.add(data.buffer.asUint8List());
    }

    input.close();
    return base64Url.encode(output.events.single.bytes);
  }

  // Deterministic content hash; normalizes pubspec precompiled config.
  String _computeHash(List<File> files) {
    final output = AccumulatorSink<Digest>();
    final input = sha256.startChunkedConversion(output);

    void addTextFile(File file) {
      final splitter = const LineSplitter();
      if (file.existsSync()) {
        final data = file.readAsStringSync();
        final lines = splitter.convert(data);
        for (final line in lines) {
          input.add(utf8.encode(line));
        }
      }
    }

    // Include precompiled_binaries config so it invalidates releases.
    void addPrecompiledBinariesFromPubspec(File file) {
      if (!file.existsSync()) {
        return;
      }
      final yamlContent = file.readAsStringSync();
      final doc = loadYaml(yamlContent);
      final extensionSection = doc is YamlMap ? doc['bdk_dart'] : null;
      final precompiled = extensionSection is YamlMap
          ? extensionSection['precompiled_binaries']
          : null;
      final normalized = _normalizeYaml(precompiled ?? <String, Object?>{});
      input.add(utf8.encode('pubspec.yaml:bdk_dart.precompiled_binaries:'));
      input.add(utf8.encode(jsonEncode(normalized)));
    }

    // Find pubspec.yaml at package root (one level up from crate).
    final rootDir = path.normalize(path.join(manifestDir, '../'));
    final pubspecFile = File(path.join(rootDir, 'pubspec.yaml'));
    addPrecompiledBinariesFromPubspec(pubspecFile);

    for (final file in files) {
      addTextFile(file);
    }

    input.close();
    final res = output.events.single;
    final hash = res.bytes.sublist(0, 16);
    return _hexEncode(hash);
  }

  String _hexEncode(List<int> bytes) {
    final b = StringBuffer();
    for (final v in bytes) {
      b.write(v.toRadixString(16).padLeft(2, '0'));
    }
    return b.toString();
  }

  // Normalize maps/lists for deterministic serialization.
  Object? _normalizeYaml(Object? value) {
    if (value is YamlMap) {
      final keys = value.keys.map((key) => key.toString()).toList()..sort();
      final result = <String, Object?>{};
      for (final key in keys) {
        result[key] = _normalizeYaml(value[key]);
      }
      return result;
    }
    if (value is YamlList) {
      return value.map(_normalizeYaml).toList();
    }
    if (value is Map) {
      final keys = value.keys.map((key) => key.toString()).toList()..sort();
      final result = <String, Object?>{};
      for (final key in keys) {
        result[key] = _normalizeYaml(value[key]);
      }
      return result;
    }
    if (value is List) {
      return value.map(_normalizeYaml).toList();
    }
    return value;
  }

  // Collect all source and manifest files that affect the build.
  List<File> _getFiles() {
    final src = Directory(path.join(manifestDir, 'src'));
    final files = src.existsSync()
        ? src
              .listSync(recursive: true, followLinks: false)
              .whereType<File>()
              .toList()
        : <File>[];
    files.sort((a, b) => a.path.compareTo(b.path));

    void addFileInCrate(String relative) {
      final file = File(path.join(manifestDir, relative));
      if (file.existsSync()) {
        files.add(file);
      }
    }

    addFileInCrate('Cargo.toml');
    addFileInCrate('Cargo.lock');
    addFileInCrate('build.rs');
    return files;
  }
}
