import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:test/test.dart';

import 'package:bdk_dart/src/precompiled/cargo.dart';

void main() {
  test('CrateInfo.load extracts the package name', () {
    final dir = Directory.systemTemp.createTempSync('cargo-test-');
    addTearDown(() => dir.deleteSync(recursive: true));

    final manifest = File(path.join(dir.path, 'Cargo.toml'));
    manifest.writeAsStringSync('''
[package]
name = "bdk_dart_ffi"
''');

    final info = CrateInfo.load(dir.path);
    expect(info.packageName, 'bdk_dart_ffi');
  });
}
