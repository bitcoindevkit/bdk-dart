# BDK Demo Real Transaction History Design

## Goal

Continue PR #62 by replacing the transaction history placeholder data with real data from the active BDK wallet while preserving the standalone `features/transactions/` module structure requested during review.

## Scope

- Use the active wallet already managed by `activeWalletProvider`.
- Keep transaction history presentation inside `bdk_demo/lib/features/transactions/`.
- Keep fake repositories only for tests.
- Do not move transaction-history UI concerns into `WalletService`.
- Do not add blockchain syncing to the transaction page; syncing remains owned by the existing sync controller and home refresh flow.

## Architecture

The default `transactionsRepositoryProvider` will become wallet-backed. It will read the current active wallet and map BDK transaction surface data into the app-side transaction model:

- `wallet.transactions()` provides canonical wallet transactions.
- `wallet.sentAndReceived(tx:)` provides wallet-specific sent and received values.
- `wallet.txDetails(txid:)` is used for direct detail lookup when available.
- `CanonicalTx.chainPosition` provides pending versus confirmed status, block height, and confirmation timestamp.

The transaction model will be renamed away from demo wording so the UI reflects real wallet data. Existing widget tests will keep overriding the repository with fake data.

## User Flow

When the user opens the transaction history screen:

- If no active wallet is loaded, the screen shows an unavailable state asking the user to load or create a wallet.
- If an active wallet exists but has no transactions, the screen shows an empty wallet-history state.
- If transactions exist, the screen renders real transaction rows derived from the active wallet.
- Tapping a row opens the detail screen for that real transaction txid.

The page copy will no longer claim that the screen is only a placeholder demo.

## Error Handling

Repository errors will continue flowing through `TransactionsController` into the existing error state. Missing detail lookups return `null`, preserving the current "Transaction not found" behavior.

## Testing

Tests will stay feature-scoped:

- Unit tests for mapping BDK-like transaction records into app transaction items.
- Controller tests for no active wallet, empty history, and loaded real-history data.
- Widget tests updated from placeholder wording to active-wallet history wording.

The implementation will use TDD: each behavior gets a failing test before production changes.
