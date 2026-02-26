import 'dart:io';

import 'package:bdk_dart/bdk.dart';

/// Run with: `dart run example/main.dart`
///
/// Prerequisites:
///  * Rust toolchain available for Native Assets builds.
///  * If you update native bindings, run `bash ./scripts/generate_bindings.sh`.
void main() {
  final network = Network.testnet;

  // 1. Create fresh seed material.
  final mnemonic = Mnemonic(wordCount: WordCount.words12);
  stdout.writeln('Mnemonic: $mnemonic');

  // 2. Turn the mnemonic into descriptor keys for external/change paths.
  final rootKey = DescriptorSecretKey(
    network: network,
    mnemonic: mnemonic,
    password: null,
  );
  final externalDescriptor = Descriptor.newBip84(
    secretKey: rootKey,
    keychainKind: KeychainKind.external_,
    network: network,
  );
  final changeDescriptor = Descriptor.newBip84(
    secretKey: rootKey,
    keychainKind: KeychainKind.internal,
    network: network,
  );

  stdout
    ..writeln('\nExternal descriptor:\n  $externalDescriptor')
    ..writeln('Change descriptor:\n  $changeDescriptor');

  // 3. Spin up an in-memory wallet using the descriptors.
  final persister = Persister.newInMemory();
  final wallet = Wallet(
    descriptor: externalDescriptor,
    changeDescriptor: changeDescriptor,
    network: network,
    persister: persister,
    lookahead: 25,
  );
  stdout.writeln('\nWallet ready on ${wallet.network()}');

  // 4. Hand out the next receive address and persist the staged change.
  final receive = wallet.revealNextAddress(keychain: KeychainKind.external_);
  stdout.writeln(
    'Next receive address (#${receive.index}): ${receive.address.toString()}',
  );
  final persisted = wallet.persist(persister: persister);
  stdout.writeln('Persisted staged wallet changes: $persisted');

  // 5. Try a quick Electrum sync to fetch history/balances.
  ElectrumClient? client;
  try {
    stdout.writeln('\nSyncing via Electrum (blockstream.info)…');
    client = ElectrumClient(
      url: 'ssl://electrum.blockstream.info:60002',
      socks5: null,
    );
    final syncRequest = wallet.startSyncWithRevealedSpks().build();
    final update = client.sync_(
      request: syncRequest,
      batchSize: 100,
      fetchPrevTxouts: true,
    );

    wallet.applyUpdate(update: update);
    wallet.persist(persister: persister);

    final balance = wallet.balance();
    stdout.writeln('Confirmed balance: ${balance.confirmed.toSat()} sats');
    stdout.writeln('Total balance: ${balance.total.toSat()} sats');
  } catch (error) {
    stdout.writeln(
      'Electrum sync failed: $error\n'
      'Ensure TLS-enabled Electrum access is available, or skip this step.',
    );
  } finally {
    client?.dispose();
  }

  // 6. Clean up FFI handles explicitly so long-lived examples don’t leak.
  wallet.dispose();
  persister.dispose();
  externalDescriptor.dispose();
  changeDescriptor.dispose();
  rootKey.dispose();
  mnemonic.dispose();
}
