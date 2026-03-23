# BDK-Dart Wallet (Flutter)

The _BDK-Dart Wallet_ is a Flutter reference app for [bitcoindevkit](https://github.com/bitcoindevkit) using [bdk-dart](https://github.com/bitcoindevkit/bdk-dart). It is intentionally a demo and scaffold, not a production-ready wallet, and currently targets Signet, Testnet 3, and Regtest.

The demo app is built with the following goals in mind:
1. Be a reference application for the `bdk_dart` API on Flutter (iOS & Android).
2. Sketch the wallet creation, recovery, sync, send, receive, and transaction-history flows the app can grow into over time.
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
| Transaction history | Scaffolded placeholder UI |
| Transaction detail | - |
| Recovery data viewer | - |
| Theme toggle (light / dark) | - |
| In-app log viewer | - |

Today the active-wallet flow is deliberately small: it loads a wallet scaffold, shows placeholder wallet metadata, and renders placeholder transaction rows. No real wallet sync or transaction fetching is implemented yet.

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
- **Domain objects:** Uses app-local scaffold models with room to grow into fuller `bdk_dart` integrations
- **Secure storage:** Planned for mnemonic and descriptor handling as wallet flows land
- **Heavy sync work:** Planned to move off the UI isolate when real sync is added

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
