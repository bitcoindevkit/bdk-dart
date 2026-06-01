import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:test/test.dart';

import 'package:bdk_dart/src/precompiled/crate_hash.dart';

void main() {
  group('CrateHash', () {
    test('produces stable hash when pubspec config order changes', () {
      final root = Directory.systemTemp.createTempSync('crate-hash-');
      addTearDown(() => root.deleteSync(recursive: true));

      final crateDir = _prepareCrate(root);
      final firstHash = CrateHash.compute(crateDir.path);

      final pubspec = File(path.join(root.path, 'pubspec.yaml'));
      pubspec.writeAsStringSync('''
name: sample
bdk_dart:
  precompiled_binaries:
    public_key: ${_hexKey(64)}
    artifact_host: owner/repo
''');

      final secondHash = CrateHash.compute(crateDir.path);
      expect(secondHash, equals(firstHash));
    });

    test('hash changes when the precompiled configuration changes', () {
      final root = Directory.systemTemp.createTempSync('crate-hash-');
      addTearDown(() => root.deleteSync(recursive: true));

      final crateDir = _prepareCrate(root);
      final original = CrateHash.compute(crateDir.path);

      final pubspec = File(path.join(root.path, 'pubspec.yaml'));
      pubspec.writeAsStringSync('''
name: sample
bdk_dart:
  precompiled_binaries:
    artifact_host: other/repo
    public_key: ${_hexKey(64)}
''');

      final updated = CrateHash.compute(crateDir.path);
      expect(updated, isNot(equals(original)));
    });

    test('collectFiles sees cargo manifest and src code', () {
      final root = Directory.systemTemp.createTempSync('crate-hash-');
      addTearDown(() => root.deleteSync(recursive: true));

      final crateDir = _prepareCrate(root);
      final files = CrateHash.collectFiles(crateDir.path);
      final basenames = files.map((file) => path.basename(file.path)).toSet();

      expect(basenames, contains('Cargo.toml'));
      expect(
        files.any((file) => file.path.contains(path.join('src', 'lib.rs'))),
        isTrue,
      );
    });
  });
}

Directory _prepareCrate(Directory root) {
  final crateDir = Directory(path.join(root.path, 'native'));
  crateDir.createSync(recursive: true);

  File(
    path.join(crateDir.path, 'Cargo.toml'),
  ).writeAsStringSync('[package]\nname = "bdk_test"\nversion = "0.1.0"\n');
  File(path.join(crateDir.path, 'Cargo.lock')).writeAsStringSync('# empty\n');
  File(path.join(crateDir.path, 'build.rs')).writeAsStringSync('');

  final srcFile = File(path.join(crateDir.path, 'src', 'lib.rs'));
  srcFile.createSync(recursive: true);
  srcFile.writeAsStringSync('pub fn hello() {}\n');

  File(path.join(root.path, 'pubspec.yaml')).writeAsStringSync('''
name: sample
bdk_dart:
  precompiled_binaries:
    artifact_host: owner/repo
    public_key: ${_hexKey(64)}
''');

  return crateDir;
}

String _hexKey(int length) => ''.padLeft(length, 'a');
