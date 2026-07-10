// @Tags(['integration'])

import 'dart:async';
import 'dart:io';

import 'package:bdk_dart/bdk.dart';
import 'package:test/test.dart';

import '../test_constants.dart';
import 'integration_helpers.dart';

Future<void> _deleteDirectoryWithRetry(Directory dir) async {
  for (var attempt = 0; attempt < 10; attempt++) {
    try {
      if (dir.existsSync()) {
        await dir.delete(recursive: true);
      }
      return;
    } on PathAccessException {
      await Future<void>.delayed(const Duration(milliseconds: 100));
    }
  }
  if (dir.existsSync()) {
    await dir.delete(recursive: true);
  }
}

String _createTempSqlitePath(String prefix) {
  final tempDir = Directory.systemTemp.createTempSync(prefix);
  addTearDown(() => _deleteDirectoryWithRetry(tempDir));
  return '${tempDir.path}/wallet.sqlite';
}

void main() {
  group('Full scan binding smoke', () {
    test(
      'full scan request, backend call, and apply update succeed',
      () {
        final disposers = <Disposer>[];
        final sqlitePath = _createTempSqlitePath('bdk_dart_full_scan_smoke_');

        try {
          final descriptor = buildBip84Descriptor(Network.testnet);
          addDisposer(disposers, descriptor.dispose);

          final changeDescriptor = buildBip84ChangeDescriptor(Network.testnet);
          addDisposer(disposers, changeDescriptor.dispose);

          final persister = Persister.newSqlite(path: sqlitePath);
          addDisposer(disposers, persister.dispose);

          final wallet = Wallet(
            descriptor: descriptor,
            changeDescriptor: changeDescriptor,
            network: Network.testnet,
            persister: persister,
            lookahead: defaultLookahead,
          );
          addDisposer(disposers, wallet.dispose);

          final requestBuilder = wallet.startFullScan();
          addDisposer(disposers, requestBuilder.dispose);

          final request = requestBuilder.build();
          addDisposer(disposers, request.dispose);

          final client = buildEsploraClientFromEnv();
          addDisposer(disposers, client.dispose);

          final update = client.fullScan(
            request: request,
            stopGap: defaultLookahead,
            parallelRequests: 4,
          );
          addDisposer(disposers, update.dispose);

          wallet.applyUpdate(update: update);
        } finally {
          disposeAll(disposers);
        }
      },
      skip: integrationSkipReason(requiredEnv: [esploraUrlEnv]),
    );
  });
}
