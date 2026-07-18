import 'package:bdk_demo/features/transactions/models/transaction_history_item.dart';
import 'package:bdk_demo/features/transactions/transactions_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum TransactionsLoadState { idle, loading, success, error, noWallet }

class TransactionsState {
  final TransactionsLoadState status;
  final List<TransactionHistoryItem> transactions;
  final String statusMessage;
  final String? errorMessage;

  const TransactionsState({
    required this.status,
    required this.transactions,
    required this.statusMessage,
    this.errorMessage,
  });

  const TransactionsState.idle()
    : this(
        status: TransactionsLoadState.idle,
        transactions: const [],
        statusMessage: 'Load the active wallet transaction history.',
      );

  TransactionsState copyWith({
    TransactionsLoadState? status,
    List<TransactionHistoryItem>? transactions,
    String? statusMessage,
    String? errorMessage,
  }) {
    return TransactionsState(
      status: status ?? this.status,
      transactions: transactions ?? this.transactions,
      statusMessage: statusMessage ?? this.statusMessage,
      errorMessage: errorMessage,
    );
  }
}

final transactionsControllerProvider = NotifierProvider.autoDispose
    .family<TransactionsController, TransactionsState, String?>(
      TransactionsController.new,
    );

final transactionDetailsProvider = FutureProvider.autoDispose
    .family<TransactionHistoryItem?, ({String? walletId, String txid})>((
      ref,
      arg,
    ) {
      if (arg.walletId == null) {
        return Future.value(null);
      }
      final repository = ref.watch(transactionsRepositoryProvider);
      return repository.loadTransactionByTxid(arg.txid);
    });

class TransactionsController extends Notifier<TransactionsState> {
  TransactionsController(this.walletId);

  final String? walletId;

  @override
  TransactionsState build() {
    if (walletId == null) {
      return const TransactionsState(
        status: TransactionsLoadState.noWallet,
        transactions: [],
        statusMessage:
            'Create or load a wallet before viewing transaction history.',
      );
    }
    return const TransactionsState.idle();
  }

  Future<void> loadTransactions() async {
    if (walletId == null) {
      state = const TransactionsState(
        status: TransactionsLoadState.noWallet,
        transactions: [],
        statusMessage:
            'Create or load a wallet before viewing transaction history.',
      );
      return;
    }

    state = state.copyWith(
      status: TransactionsLoadState.loading,
      transactions: const [],
      statusMessage: 'Loading transaction history...',
      errorMessage: null,
    );

    try {
      final transactions = await ref
          .read(transactionsRepositoryProvider)
          .loadTransactions();

      if (!ref.mounted) {
        return;
      }

      state = state.copyWith(
        status: TransactionsLoadState.success,
        transactions: transactions,
        statusMessage: transactions.isEmpty
            ? 'Transaction history loaded. No transactions yet.'
            : 'Transaction history loaded.',
        errorMessage: null,
      );
    } catch (error) {
      if (!ref.mounted) {
        return;
      }

      state = state.copyWith(
        status: TransactionsLoadState.error,
        transactions: const [],
        statusMessage: 'Transaction history could not be loaded.',
        errorMessage: _readableError(error),
      );
    }
  }

  String _readableError(Object error) =>
      error.toString().replaceFirst('Exception: ', '');
}
