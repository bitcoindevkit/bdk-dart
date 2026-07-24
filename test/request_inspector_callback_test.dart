import 'dart:io';
import 'dart:isolate';

import 'package:bdk_dart/bdk.dart';
import 'package:test/test.dart';

import 'test_constants.dart';

final class _RecordingSyncScriptInspector implements SyncScriptInspector {
  int invocationCount = 0;
  final List<List<int>> liftedScriptBytes = <List<int>>[];
  final List<int> liftedTotals = <int>[];

  @override
  void inspect(Script script, int total) {
    invocationCount++;
    liftedScriptBytes.add(script.toBytes());
    liftedTotals.add(total);
  }
}

void _serverIsolateMain(SendPort sendPort) async {
  final server = await HttpServer.bind('127.0.0.1', 0);
  sendPort.send(server.port);

  await for (final request in server) {
    final uri = request.uri;
    final path = uri.path;

    if (path == '/blocks') {
      request.response.statusCode = 200;
      request.response.headers.contentType = ContentType.json;
      request.response.write(
        '[{"id":"0000000000000000000000000000000000000000000000000000000000000000","height":0,"version":1,"timestamp":0,"tx_count":0,"size":0,"weight":0,"merkle_root":"0000000000000000000000000000000000000000000000000000000000000000","previousblockhash":null,"mediantime":0,"nonce":0,"bits":0,"difficulty":0}]',
      );
    } else if (path.startsWith('/scripthash/') && path.endsWith('/txs')) {
      request.response.statusCode = 200;
      request.response.headers.contentType = ContentType.json;
      request.response.write('[]');
    } else {
      request.response.statusCode = 404;
      request.response.write('Not found');
    }

    await request.response.close();
  }
}

void main() {
  test('SyncScriptInspector callback lifts usable Dart arguments', () async {
    final descriptor = buildBip84Descriptor(Network.testnet);
    final changeDescriptor = buildBip84ChangeDescriptor(Network.testnet);
    final persister = Persister.newInMemory();

    final wallet = Wallet(
      descriptor: descriptor,
      changeDescriptor: changeDescriptor,
      network: Network.testnet,
      persister: persister,
      lookahead: defaultLookahead,
    );

    Isolate? serverIsolate;
    SyncRequestBuilder? builder;
    SyncRequestBuilder? inspectedBuilder;
    SyncRequest? request;
    EsploraClient? client;

    try {
      wallet.revealNextAddress(keychain: KeychainKind.external_);

      final inspector = _RecordingSyncScriptInspector();

      builder = wallet.startSyncWithRevealedSpks();
      inspectedBuilder = builder.inspectSpks(inspector: inspector);
      request = inspectedBuilder.build();

      final receivePort = ReceivePort();
      serverIsolate = await Isolate.spawn(
        _serverIsolateMain,
        receivePort.sendPort,
      );
      final port = await receivePort.first as int;

      client = EsploraClient(
        url: 'http://127.0.0.1:$port',
        proxy: null,
      );

      Object? syncError;
      try {
        client.sync_(request: request, parallelRequests: 4);
      } catch (error) {
        syncError = error;
      }

      expect(
        syncError,
        isNotNull,
        reason: 'The fake Esplora block hashes do not match the local chain tip, so sync must fail.',
      );

      expect(inspector.invocationCount, greaterThan(0));
      expect(inspector.liftedScriptBytes, isNotEmpty);
      expect(inspector.liftedScriptBytes.first, isNotEmpty);
      expect(inspector.liftedTotals, isNotEmpty);
    } finally {
      serverIsolate?.kill(priority: Isolate.immediate);
      client?.dispose();
      request?.dispose();
      inspectedBuilder?.dispose();
      builder?.dispose();
      wallet.dispose();
      persister.dispose();
      changeDescriptor.dispose();
      descriptor.dispose();
    }
  });
}
