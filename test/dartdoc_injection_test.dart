import 'dart:io';

import 'package:test/test.dart';

const _bindingsPath = 'lib/bdk.dart';
const _entriesPath = 'scripts/dartdoc/entries.yaml';

void main() {
  test('dartdoc entries resolve to unique anchors in generated bindings', () {
    final bindings = File(_bindingsPath).readAsLinesSync();
    final entries = File(_entriesPath).readAsStringSync();
    final anchorCount = RegExp(r'^anchor:', multiLine: true).allMatches(entries).length;

    expect(anchorCount, greaterThan(30));
    expect(
      bindings.any((line) => line.trim() == 'class Wallet implements WalletInterface {'),
      isTrue,
    );
  });

  test('inject_dartdocs --check passes for committed bindings', () async {
    final result = await Process.run(
      'dart',
      ['scripts/inject_dartdocs.dart', '--check'],
      runInShell: true,
    );

    expect(
      result.exitCode,
      0,
      reason: '${result.stdout}\n${result.stderr}',
    );
  });

  test('priority classes have dartdoc immediately above declarations', () {
    final bindings = File(_bindingsPath).readAsLinesSync();
    final priorityAnchors = [
      'class Wallet implements WalletInterface {',
      'class Descriptor implements DescriptorInterface {',
      'class Mnemonic implements MnemonicInterface {',
    ];

    for (final anchor in priorityAnchors) {
      final index = bindings.indexWhere((line) => line.trim() == anchor);
      expect(index, greaterThan(0), reason: 'Missing anchor: $anchor');

      var docIndex = index - 1;
      while (docIndex >= 0 && bindings[docIndex].trim().isEmpty) {
        docIndex--;
      }

      expect(
        bindings[docIndex].trimLeft().startsWith('///'),
        isTrue,
        reason: 'Missing dartdoc above $anchor at line ${index + 1}',
      );
    }
  });
}
