import 'dart:io';

import 'package:bdk_dart/bdk.dart';

typedef Disposer = void Function();

const integrationEnabledEnv = 'BDK_DART_RUN_INTEGRATION';
const electrumUrlEnv = 'BDK_DART_ELECTRUM_URL';
const electrumSocks5Env = 'BDK_DART_ELECTRUM_SOCKS5';
const esploraUrlEnv = 'BDK_DART_ESPLORA_URL';
const esploraProxyEnv = 'BDK_DART_ESPLORA_PROXY';

bool isIntegrationEnabled({Map<String, String>? env}) {
  final value = (env ?? Platform.environment)[integrationEnabledEnv];
  if (value == null) return false;

  final normalized = value.trim().toLowerCase();
  return normalized == '1' ||
      normalized == 'true' ||
      normalized == 'yes' ||
      normalized == 'on';
}

String? integrationSkipReason({
  Map<String, String>? env,
  List<String> requiredEnv = const [],
}) {
  final environment = env ?? Platform.environment;
  if (!isIntegrationEnabled(env: environment)) {
    return 'Integration tests disabled. Set $integrationEnabledEnv=1.';
  }

  final missing = requiredEnv
      .where((name) => (environment[name] ?? '').trim().isEmpty)
      .toList();

  if (missing.isNotEmpty) {
    return 'Missing required env vars: ${missing.join(', ')}';
  }
  return null;
}

String envOrThrow(String name, {Map<String, String>? env}) {
  final value = (env ?? Platform.environment)[name];
  if (value == null || value.trim().isEmpty) {
    throw StateError('Missing required env var: $name');
  }
  return value.trim();
}

ElectrumClient buildElectrumClientFromEnv({Map<String, String>? env}) {
  final environment = env ?? Platform.environment;
  final url = envOrThrow(electrumUrlEnv, env: environment);
  final socks5 = environment[electrumSocks5Env];
  return ElectrumClient(url: url, socks5: socks5);
}

EsploraClient buildEsploraClientFromEnv({Map<String, String>? env}) {
  final environment = env ?? Platform.environment;
  final url = envOrThrow(esploraUrlEnv, env: environment);
  final proxy = environment[esploraProxyEnv];
  return EsploraClient(url: url, proxy: proxy);
}

void addDisposer(List<Disposer> disposers, Disposer disposer) {
  disposers.add(disposer);
}

void disposeAll(List<Disposer> disposers) {
  Object? firstError;
  StackTrace? firstStackTrace;

  for (final dispose in disposers.reversed) {
    try {
      dispose();
    } catch (error, stackTrace) {
      firstError ??= error;
      firstStackTrace ??= stackTrace;
      stderr.writeln('Error while disposing integration test resource: $error');
    }
  }

  if (firstError != null && firstStackTrace != null) {
    Error.throwWithStackTrace(firstError, firstStackTrace);
  }
}
