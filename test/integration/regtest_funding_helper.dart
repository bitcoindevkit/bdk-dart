import 'dart:convert';
import 'dart:io';

String _envOrDefault(String key, String defaultValue) {
  final value = Platform.environment[key];
  return (value != null && value.trim().isNotEmpty)
      ? value.trim()
      : defaultValue;
}

/// Makes a JSON-RPC call to the local Bitcoin Core Regtest node.
Future<dynamic> _rpcCall(String method, [dynamic params = const []]) async {
  // Note the /wallet/faucet path for wallet-specific commands
  final rpcUrl = _envOrDefault(
    'BDK_DART_BITCOIN_RPC_URL',
    'http://127.0.0.1:18443/wallet/faucet',
  );
  final rpcUser = _envOrDefault('BDK_DART_BITCOIN_RPC_USER', 'regtest');
  final rpcPassword = _envOrDefault(
    'BDK_DART_BITCOIN_RPC_PASSWORD',
    'password',
  );

  final client = HttpClient();
  client.connectionTimeout = const Duration(seconds: 10);

  try {
    final request = await client
        .postUrl(Uri.parse(rpcUrl))
        .timeout(const Duration(seconds: 10));

    final auth = base64Encode(utf8.encode('$rpcUser:$rpcPassword'));
    request.headers.set(HttpHeaders.authorizationHeader, 'Basic $auth');
    request.headers.contentType = ContentType.json;

    final body = jsonEncode({
      'jsonrpc': '1.0',
      'id': 'bdk_dart_integration',
      'method': method,
      'params': params,
    });

    request.write(body);

    final response = await request.close().timeout(const Duration(seconds: 10));
    final responseBody = await response.transform(utf8.decoder).join();

    if (response.statusCode != HttpStatus.ok) {
      throw Exception('RPC Error (HTTP ${response.statusCode}): $responseBody');
    }

    final decoded = jsonDecode(responseBody) as Map<String, dynamic>;
    if (decoded['error'] != null) {
      throw Exception('RPC JSON Error: ${decoded['error']}');
    }

    return decoded['result'];
  } finally {
    client.close();
  }
}

/// Funds a Regtest address with the given [amount] (in BTC) and mines 2 blocks
/// to confirm it.
///
/// Returns the transaction ID as a String.
Future<String> fundRegtestAddress(String address, {double amount = 1.0}) async {
  // 1. Send BTC to the provided address with a fixed fee rate to avoid estimation errors
  final txid =
      await _rpcCall('sendtoaddress', {
            'address': address,
            'amount': amount,
            'fee_rate': 1.0, // 1 sat/vB
          })
          as String;

  // 2. Get a new address to receive the block rewards
  final minerAddress = await _rpcCall('getnewaddress') as String;

  // 3. Mine 2 blocks to confirm the transaction (2 confirmations)
  await _rpcCall('generatetoaddress', [2, minerAddress]);

  return txid;
}
