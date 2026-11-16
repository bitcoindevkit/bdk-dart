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

/// Broadcasts a transaction to a Regtest address without mining it.
///
/// Returns the transaction ID.
Future<String> broadcastRegtestAddress(
  String address, {
  double amount = 1.0,
}) async {
  return await _rpcCall('sendtoaddress', {
        'address': address,
        'amount': amount,
        'fee_rate': 1.0,
      })
      as String;
}

/// Mines [blocks] Regtest blocks.
Future<void> mineRegtestBlocks({int blocks = 2}) async {
  final minerAddress = await _rpcCall('getnewaddress') as String;
  await _rpcCall('generatetoaddress', [blocks, minerAddress]);
}

/// Funds a Regtest address and mines 2 blocks to confirm the transaction.
///
/// Returns the transaction ID.
Future<String> fundRegtestAddress(String address, {double amount = 1.0}) async {
  final txid = await broadcastRegtestAddress(address, amount: amount);
  await mineRegtestBlocks();
  return txid;
}
