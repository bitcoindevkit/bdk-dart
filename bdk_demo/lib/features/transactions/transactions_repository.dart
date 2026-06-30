import 'package:bdk_dart/bdk.dart' as bdk;
import 'package:bdk_demo/features/transactions/models/transaction_history_item.dart';
import 'package:bdk_demo/features/transactions/transaction_history_mapper.dart';
import 'package:bdk_demo/providers/wallet_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract interface class TransactionsRepository {
  Future<List<TransactionHistoryItem>> loadTransactions();
  Future<TransactionHistoryItem?> loadTransactionByTxid(String txid);
}

final transactionsRepositoryProvider = Provider<TransactionsRepository>((ref) {
  final wallet = ref.watch(activeWalletProvider);
  return WalletTransactionsRepository(
    source: wallet == null ? null : BdkWalletTransactionSource(wallet),
  );
});

abstract interface class TransactionHistorySource {
  List<TransactionHistoryRecord> transactions();

  TransactionHistoryRecord? transactionByTxid(String txid);
}

class TransactionHistoryRecord {
  final String txid;
  final int sent;
  final int received;
  final TransactionHistoryPosition position;

  const TransactionHistoryRecord({
    required this.txid,
    required this.sent,
    required this.received,
    required this.position,
  });
}

class WalletTransactionsRepository implements TransactionsRepository {
  WalletTransactionsRepository({required TransactionHistorySource? source})
    : _source = source;

  final TransactionHistorySource? _source;

  @override
  Future<List<TransactionHistoryItem>> loadTransactions() async {
    final source = _source;
    if (source == null) return const [];

    return source.transactions().map(_mapRecord).toList(growable: false);
  }

  @override
  Future<TransactionHistoryItem?> loadTransactionByTxid(String txid) async {
    final source = _source;
    if (source == null) return null;

    final record = source.transactionByTxid(txid);
    return record == null ? null : _mapRecord(record);
  }

  TransactionHistoryItem _mapRecord(TransactionHistoryRecord record) {
    return TransactionHistoryMapper.fromWalletData(
      txid: record.txid,
      sent: record.sent,
      received: record.received,
      position: record.position,
    );
  }
}

class BdkWalletTransactionSource implements TransactionHistorySource {
  BdkWalletTransactionSource(this._wallet);

  final bdk.Wallet _wallet;

  @override
  List<TransactionHistoryRecord> transactions() {
    return _wallet
        .transactions()
        .map(_recordFromCanonicalTx)
        .toList(growable: false);
  }

  @override
  TransactionHistoryRecord? transactionByTxid(String txid) {
    try {
      final parsedTxid = bdk.Txid.fromString(hex: txid);
      try {
        final canonicalTx = _wallet.getTx(txid: parsedTxid);
        if (canonicalTx != null) return _recordFromCanonicalTx(canonicalTx);
      } finally {
        parsedTxid.dispose();
      }
    } catch (_) {
      // If the txid cannot be parsed or fetched directly, fall back to the
      // wallet transaction list so the detail page still behaves gracefully.
    }

    return _findTransactionByTxid(transactions(), txid);
  }

  TransactionHistoryRecord _recordFromCanonicalTx(bdk.CanonicalTx canonicalTx) {
    final transaction = canonicalTx.transaction;
    final sentAndReceived = _wallet.sentAndReceived(tx: transaction);
    final txid = transaction.computeTxid();
    final txidText = txid.toString();
    final sentSat = sentAndReceived.sent.toSat();
    final receivedSat = sentAndReceived.received.toSat();

    txid.dispose();
    transaction.dispose();
    sentAndReceived.sent.dispose();
    sentAndReceived.received.dispose();

    return TransactionHistoryRecord(
      txid: txidText,
      sent: sentSat,
      received: receivedSat,
      position: _positionFromBdk(canonicalTx.chainPosition),
    );
  }

  TransactionHistoryPosition _positionFromBdk(bdk.ChainPosition position) {
    if (position is bdk.ConfirmedChainPosition) {
      final confirmation = position.confirmationBlockTime;
      return ConfirmedTransactionPosition(
        blockHeight: confirmation.blockId.height,
        confirmationTime: confirmation.confirmationTime,
      );
    }

    if (position is bdk.UnconfirmedChainPosition) {
      return UnconfirmedTransactionPosition(timestamp: position.timestamp);
    }

    throw StateError('Unsupported transaction chain position: $position');
  }
}

TransactionHistoryRecord? _findTransactionByTxid(
  List<TransactionHistoryRecord> transactions,
  String txid,
) {
  for (final transaction in transactions) {
    if (transaction.txid == txid) return transaction;
  }
  return null;
}
