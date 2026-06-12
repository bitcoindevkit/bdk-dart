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

  bool get isEmpty =>
      walletId == null &&
      address == null &&
      index == null &&
      !isGenerating &&
      errorMessage == null;

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
  final Set<String> _inFlightWalletIds = <String>{};
  final Map<String, ReceiveAddressState> _stateByWalletId =
      <String, ReceiveAddressState>{};

  @override
  ReceiveAddressState build() {
    ref.listen<WalletRecord?>(activeWalletRecordProvider, (previous, next) {
      if (next == null) {
        if (!state.isEmpty) {
          state = ReceiveAddressState.empty;
        }
        return;
      }

      final nextState = _stateByWalletId[next.id] ?? ReceiveAddressState.empty;
      if (!state.isEmpty || !nextState.isEmpty) {
        state = nextState;
      }
    });

    return ReceiveAddressState.empty;
  }

  Future<void> generateForActiveWallet() async {
    final record = ref.read(activeWalletRecordProvider);
    if (record == null) {
      state = const ReceiveAddressState(errorMessage: 'No active wallet.');
      return;
    }

    final walletId = record.id;
    if (!_inFlightWalletIds.add(walletId)) return;

    final previousState = _stateByWalletId[walletId];
    final generatingState = ReceiveAddressState.empty.copyWith(
      walletId: walletId,
      isGenerating: true,
      clearAddress: true,
      clearIndex: true,
      clearErrorMessage: true,
    );
    _stateByWalletId[walletId] = generatingState;
    state = generatingState;

    try {
      final walletService = ref.read(walletServiceProvider);
      final (addressInfo, updatedWallet) = await walletService.generateAddress(
        record,
      );
      final successState = ReceiveAddressState(
        walletId: walletId,
        address: addressInfo.address.toString(),
        index: addressInfo.index,
      );
      _stateByWalletId[walletId] = successState;

      if (!_stillActive(walletId)) {
        updatedWallet.dispose();
        return;
      }

      ref.read(activeWalletProvider.notifier).replaceWallet(updatedWallet);
      state = successState;
    } catch (error) {
      final errorState = ReceiveAddressState(
        walletId: walletId,
        address: previousState?.address,
        index: previousState?.index,
        errorMessage: error.toString(),
      );

      if (_stillActive(walletId)) {
        _stateByWalletId[walletId] = errorState;
        state = errorState;
      } else if (previousState != null) {
        _stateByWalletId[walletId] = previousState;
      } else {
        _stateByWalletId.remove(walletId);
      }
    } finally {
      _inFlightWalletIds.remove(walletId);
    }
  }

  bool _stillActive(String walletId) =>
      ref.read(activeWalletRecordProvider)?.id == walletId;
}
