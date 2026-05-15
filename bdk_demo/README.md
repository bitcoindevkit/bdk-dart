# BDK-Dart Wallet (Flutter)

The _BDK-Dart Wallet_ is a wallet built as a reference app for the [bitcoindevkit](https://github.com/bitcoindevkit) on Flutter using [bdk-dart](https://github.com/bitcoindevkit/bdk-dart). This repository is not intended to produce a production-ready wallet, the app only works on Signet, Testnet 3, and Regtest.

The demo app is built with the following goals in mind:
1. Be a reference application for the `bdk_dart` API on Flutter (iOS & Android).
2. Showcase the core features of the bitcoindevkit library: wallet creation, recovery, Esplora/Electrum sync, send, receive, and transaction history.
3. Demonstrate a clean, testable Flutter architecture using Riverpod and GoRouter.

## Features

| Feature | Status |
|---|---|
| Create wallet (P2WPKH / P2TR) | - |
| Recover wallet (phrase / descriptor) | - |
| Multi-wallet support | - |
| Esplora sync (Regtest) | - |
| Electrum sync (Testnet / Signet) | - |
| Wallet balance (BTC / sats toggle) | - |
| Receive (address generation + QR) | - |
| Send (single recipient + fee rate) | - |
| Transaction history | - |
| Transaction detail | - |
| Recovery data viewer | - |
| Theme toggle (light / dark) | - |
| In-app log viewer | - |

## Architecture

Clean Architecture + Riverpod:

```
lib/
├── app/           # App shell (MaterialApp, bootstrap)
├── core/          # Theme, router, constants, logging, utils
├── models/        # WalletRecord, TxDetails, CurrencyUnit
├── services/      # WalletService, BlockchainService, StorageService
├── providers/     # Riverpod providers (wallet, blockchain, settings)
└── features/      # Feature pages and widgets
```

**Note:**
- **State management:** Riverpod
- **Navigation:** GoRouter
- **Domain objects:** Uses `bdk_dart` types directly
- **Secure storage:** `flutter_secure_storage` for mnemonics and descriptors
- **BDK threading:** `Isolate.run()` for heavy sync operations

## Getting Started

```bash
# Clone and navigate to the demo app
cd bdk_demo

# Install dependencies
flutter pub get

# Run on a connected device or emulator
flutter run
```

> **Note:** This app depends on `bdk_dart` via a local path (`../`). Make sure the parent `bdk-dart` repository is set up and the native Rust build toolchain is available. See the [bdk-dart README](../README.md) for build prerequisites.

## Supported Networks

| Network | Blockchain Client | Default Endpoint |
|---|---|---|
| Signet | Electrum | `ssl://mempool.space:60602` |
| Testnet 3 | Electrum | `ssl://electrum.blockstream.info:60002` |
| Regtest | Esplora | `http://localhost:3002` |


## Address Types

| Type | Standard | Default |
|---|---|---|
| P2TR (Taproot) | BIP-86 | - |
| P2WPKH (Native SegWit) | BIP-84 | - |

## License

See [LICENSE](../LICENSE).
