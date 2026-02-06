import 'package:bdk_dart/src/precompiled/util.dart';
import 'package:ed25519_edwards/ed25519_edwards.dart';

// Generate an Ed25519 keypair for signing.
Future<void> run(List<String> args) async {
  if (args.contains('--help') || args.contains('-h')) {
    return;
  }
  final kp = generateKey();
  final privateHex = hexEncode(kp.privateKey.bytes);
  final publicHex = hexEncode(kp.publicKey.bytes);
  // ignore: avoid_print
  print('PRIVATE_KEY=$privateHex');
  // ignore: avoid_print
  print('PUBLIC_KEY=$publicHex');
}
