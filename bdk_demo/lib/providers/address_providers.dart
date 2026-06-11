import 'package:bdk_demo/models/wallet_record.dart';
import 'package:bdk_demo/providers/wallet_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReceiveAddressState {
  const ReceiveAddressState({
    this.walletId,
    this.address,
    this.index,
    this.isGenerating = false,
    this.errorMessage,
  });

  static const empty = ReceiveAddressState();

  final String? walletId;
  final String? address;
  final int? index;
  final bool isGenerating;
  final String? errorMessage;

  ReceiveAddressState copyWith({
    String? walletId,
    String? address,
    int? index,
    bool? isGenerating,
    String? errorMessage,
    bool clearAddress = false,
    bool clearIndex = false,
    bool clearErrorMessage = false,
  }) {
    return ReceiveAddressState(
      walletId: walletId ?? this.walletId,
      address: clearAddress ? null : (address ?? this.address),
      index: clearIndex ? null : (index ?? this.index),
      isGenerating: isGenerating ?? this.isGenerating,
      errorMessage: clearErrorMessage
          ? null
          : (errorMessage ?? this.errorMessage),
    );
  }
}

final currentReceiveAddressProvider =
    NotifierProvider<CurrentReceiveAddressNotifier, ReceiveAddressState>(
      CurrentReceiveAddressNotifier.new,
    );

class CurrentReceiveAddressNotifier extends Notifier<ReceiveAddressState> {
  bool _inFlight = false;

  @override
  ReceiveAddressState build() {
    ref.listen<WalletRecord?>(activeWalletRecordProvider, (previous, next) {
      final current = state;
      if (current.walletId == null && !current.isGenerating) return;
      if (next == null || current.walletId != next.id) {
        state = ReceiveAddressState.empty;
      }
    });
    return ReceiveAddressState.empty;
  }

  Future<void> generateForActiveWallet() async {
    if (_inFlight) return;

    final record = ref.read(activeWalletRecordProvider);
    if (record == null) {
      state = const ReceiveAddressState(errorMessage: 'No active wallet.');
      return;
    }

    final walletId = record.id;
    _inFlight = true;
    state = ReceiveAddressState.empty.copyWith(
      walletId: walletId,
      isGenerating: true,
      clearAddress: true,
      clearIndex: true,
      clearErrorMessage: true,
    );

    try {
      final walletService = ref.read(walletServiceProvider);
      final (addressInfo, updatedWallet) = await walletService.generateAddress(
        record,
      );

      if (!_stillActive(walletId)) {
        updatedWallet.dispose();
        state = ReceiveAddressState.empty;
        return;
      }

      ref.read(activeWalletProvider.notifier).replaceWallet(updatedWallet);
      state = ReceiveAddressState(
        walletId: walletId,
        address: addressInfo.address.toString(),
        index: addressInfo.index,
      );
    } catch (error) {
      if (_stillActive(walletId)) {
        state = ReceiveAddressState(
          walletId: walletId,
          errorMessage: error.toString(),
        );
      } else {
        state = ReceiveAddressState.empty;
      }
    } finally {
      _inFlight = false;
    }
  }

  bool _stillActive(String walletId) =>
      ref.read(activeWalletRecordProvider)?.id == walletId;
}
