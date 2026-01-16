import 'dart:io';

import 'package:bdk_dart/src/precompiled/options.dart';
import 'package:path/path.dart' as path;
import 'package:test/test.dart';
import 'package:yaml/yaml.dart';

void main() {
  group('PrecompiledBinariesConfig', () {
    test(
      'normalizes artifact_host into owner/repo and respects mode aliases',
      () {
        final node =
            loadYamlNode('''
artifact_host: https://github.com/nucode-tech/bdk-dart/
public_key: ${_hexKey(64)}
mode: download
''')
                as YamlMap;

        final config = PrecompiledBinariesConfig.parse(node);
        expect(config.mode, PrecompiledBinaryMode.always);
        expect(config.artifactHost, 'nucode-tech/bdk-dart');

        final fileUrl = config.fileUrl(crateHash: 'abc123', fileName: 'asset');
        expect(
          fileUrl.toString(),
          'https://github.com/nucode-tech/bdk-dart/releases/download/precompiled_abc123/asset',
        );
      },
    );

    test('uses url_prefix when configured and leaves artifact host empty', () {
      final node =
          loadYamlNode('''
url_prefix: http://example.com/exports/
public_key: ${_hexKey(64)}
''')
              as YamlMap;

      final config = PrecompiledBinariesConfig.parse(node);
      expect(config.artifactHost, isEmpty);

      final fileUrl = config.fileUrl(crateHash: 'hash', fileName: 'binary');
      expect(fileUrl.toString(), 'http://example.com/exports/hash/binary');
    });
  });

  group('PubspecOptions', () {
    test('returns null when pubspec is missing', () {
      final root = Directory.systemTemp.createTempSync('precompiled-options-');
      addTearDown(() => root.deleteSync(recursive: true));

      final options = PubspecOptions.load(
        packageRoot: root.path,
        pluginConfigKey: 'bdk_dart',
      );
      expect(options.precompiledBinaries, isNull);
    });

    test('loads precompiled configuration from pubspec', () {
      final root = Directory.systemTemp.createTempSync('precompiled-options-');
      addTearDown(() => root.deleteSync(recursive: true));

      final pubspecFile = File(path.join(root.path, 'pubspec.yaml'));
      pubspecFile.writeAsStringSync('''
name: sample
bdk_dart:
  precompiled_binaries:
    artifact_host: nuCode-Tech/bdk-dart
    public_key: ${_hexKey(64)}
''');

      final options = PubspecOptions.load(
        packageRoot: root.path,
        pluginConfigKey: 'bdk_dart',
      );
      expect(options.precompiledBinaries, isNotNull);
      expect(options.precompiledBinaries!.artifactHost, 'nuCode-Tech/bdk-dart');
    });

    test('loadModeOverride honors invoker pubspec mode overrides', () {
      final root = Directory.systemTemp.createTempSync('precompiled-mode-');
      addTearDown(() => root.deleteSync(recursive: true));

      final pubspecFile = File(path.join(root.path, 'pubspec.yaml'));
      pubspecFile.writeAsStringSync('''
name: invoker
bdk_dart:
  precompiled_binaries:
    mode: download
''');

      final mode = PubspecOptions.loadModeOverride(
        packageRoot: root.path,
        packageName: 'bdk_dart',
      );
      expect(mode, PrecompiledBinaryMode.always);
    });
  });
}

String _hexKey(int length) => ''.padLeft(length, 'a');
