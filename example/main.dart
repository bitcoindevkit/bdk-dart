import 'dart:io';

import 'package:bdk_dart/bdk.dart';

/// Run with: `dart run examples/network_example.dart`
///
/// Prerequisites:
///  * Generated bindings (`scripts/generate_bindings.sh`)
///  * Native library (`libbdkffi.*`) discoverable by the Dart process
void main() {
  final network = Network.testnet;

  // 1. Create fresh seed material.
  final mnemonic = Mnemonic(WordCount.words12);
  stdout.writeln('Mnemonic: $mnemonic');

  // 2. Turn the mnemonic into descriptor keys for external/change paths.
  final rootKey = DescriptorSecretKey(network, mnemonic, null);
  final externalDescriptor =
      Descriptor.newBip84(rootKey, KeychainKind.external_, network);
  final changeDescriptor =
      Descriptor.newBip84(rootKey, KeychainKind.internal, network);

  stdout
    ..writeln('\nExternal descriptor:\n  $externalDescriptor')
    ..writeln('Change descriptor:\n  $changeDescriptor');

  // 3. Spin up an in-memory wallet using the descriptors.
  final persister = Persister.newInMemory();
  final wallet =
      Wallet(externalDescriptor, changeDescriptor, network, persister, 25);
  stdout.writeln('\nWallet ready on ${wallet.network()}');

  // 4. Hand out the next receive address and persist the staged change.
  final receive = wallet.revealNextAddress(KeychainKind.external_);
  stdout.writeln(
      'Next receive address (#${receive.index}): ${receive.address.toString()}');
  final persisted = wallet.persist(persister);
  stdout.writeln('Persisted staged wallet changes: $persisted');

  // 5. Try a quick Electrum sync to fetch history/balances.
  try {
    stdout.writeln('\nSyncing via Electrum (blockstream.info)…');
    final client =
        ElectrumClient('ssl://electrum.blockstream.info:60002', null);
    final syncRequest = wallet.startSyncWithRevealedSpks().build();
    final update = client.sync_(syncRequest, 100, true);

    wallet.applyUpdate(update);
    wallet.persist(persister);

    final balance = wallet.balance();
    stdout.writeln('Confirmed balance: ${balance.confirmed.toSat()} sats');
    stdout.writeln('Total balance: ${balance.total.toSat()} sats');

    client.dispose();
  } catch (error) {
    stdout.writeln(
      'Electrum sync failed: $error\n'
      'Ensure TLS-enabled Electrum access is available, or skip this step.',
    );
  }

  // 6. Clean up FFI handles explicitly so long-lived examples don’t leak.
  wallet.dispose();
  persister.dispose();
  externalDescriptor.dispose();
  changeDescriptor.dispose();
  rootKey.dispose();
  mnemonic.dispose();
}
