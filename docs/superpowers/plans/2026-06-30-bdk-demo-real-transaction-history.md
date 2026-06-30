# BDK Demo Real Transaction History Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace the demo app transaction history placeholder rows with real active-wallet transaction data.

**Architecture:** Keep the existing standalone `features/transactions/` module from PR #62. Replace the default repository with a wallet-backed repository that maps active BDK wallet data into app-side transaction rows, while tests continue to use fakes.

**Tech Stack:** Dart, Flutter, Riverpod, GoRouter, BDK Dart bindings.

## Global Constraints

- Branch, PR title, and new document names must follow project naming and must not use restricted tool-specific naming.
- Do not place transaction-history UI logic inside `WalletService`.
- Keep feature code under `bdk_demo/lib/features/transactions/`.
- Use TDD: write the failing test before production changes.
- Keep fake repositories in `bdk_demo/test/helpers/fakes/`.

---

### Task 1: Rename Transaction Model and Copy

**Files:**
- Rename: `bdk_demo/lib/features/transactions/models/demo_tx_details.dart` to `bdk_demo/lib/features/transactions/models/transaction_history_item.dart`
- Modify: `bdk_demo/lib/features/transactions/transactions_controller.dart`
- Modify: `bdk_demo/lib/features/transactions/transactions_list_page.dart`
- Modify: `bdk_demo/lib/features/transactions/transaction_detail_page.dart`
- Modify: `bdk_demo/test/helpers/fakes/fake_transactions_repository.dart`
- Modify: `bdk_demo/test/helpers/fixtures/placeholder_transactions.dart`
- Modify: `bdk_demo/test/presentation/transactions/transactions_list_page_test.dart`
- Modify: `bdk_demo/test/presentation/transactions/transaction_detail_page_test.dart`

**Interfaces:**
- Produces: `TransactionHistoryItem` with `txid`, `sent`, `received`, `pending`, `blockHeight`, `confirmationTime`, `netAmount`, `shortTxid`, and `statusLabel`.

- [ ] **Step 1: Write failing tests**

Update the transaction widget tests to expect real-history wording:

```dart
expect(find.text('Transaction History'), findsOneWidget);
expect(find.text('Load Transaction History'), findsOneWidget);
expect(find.text('Transaction history not loaded yet'), findsOneWidget);
```

- [ ] **Step 2: Run failing tests**

Run: `flutter test bdk_demo/test/presentation/transactions`

Expected: FAIL because the UI still says "Transactions Demo" and imports `DemoTxDetails`.

- [ ] **Step 3: Rename model and update copy**

Rename the model and update imports/types from `DemoTxDetails` to `TransactionHistoryItem`. Update user-facing copy from placeholder/demo wording to active-wallet transaction-history wording.

- [ ] **Step 4: Run passing tests**

Run: `flutter test bdk_demo/test/presentation/transactions`

Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add bdk_demo/lib/features/transactions bdk_demo/test/helpers bdk_demo/test/presentation/transactions
git commit -m "refactor: rename transaction history model"
```

### Task 2: Add Wallet-Backed Mapping

**Files:**
- Create: `bdk_demo/lib/features/transactions/transaction_history_mapper.dart`
- Modify: `bdk_demo/lib/features/transactions/transactions_repository.dart`
- Test: `bdk_demo/test/features/transactions/transaction_history_mapper_test.dart`

**Interfaces:**
- Consumes: `TransactionHistoryItem`.
- Produces: mapping helpers that convert BDK wallet transaction data into `TransactionHistoryItem`.

- [ ] **Step 1: Write failing mapper tests**

Test confirmed and unconfirmed mapping, including sent/received values and confirmation metadata.

- [ ] **Step 2: Run failing tests**

Run: `flutter test bdk_demo/test/features/transactions/transaction_history_mapper_test.dart`

Expected: FAIL because the mapper does not exist.

- [ ] **Step 3: Implement mapper**

Create a focused mapper that turns txid strings, sent/received sats, and chain-position metadata into `TransactionHistoryItem`.

- [ ] **Step 4: Run passing tests**

Run: `flutter test bdk_demo/test/features/transactions/transaction_history_mapper_test.dart`

Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add bdk_demo/lib/features/transactions bdk_demo/test/features/transactions
git commit -m "feat: map wallet transactions for history"
```

### Task 3: Replace Default Repository With Active Wallet Data

**Files:**
- Modify: `bdk_demo/lib/features/transactions/transactions_repository.dart`
- Modify: `bdk_demo/lib/features/transactions/transactions_controller.dart`
- Test: `bdk_demo/test/features/transactions/transactions_repository_test.dart`
- Test: `bdk_demo/test/presentation/transactions/transactions_list_page_test.dart`

**Interfaces:**
- Consumes: `activeWalletProvider` and BDK wallet methods.
- Produces: `WalletTransactionsRepository` as the default repository implementation.

- [ ] **Step 1: Write failing repository tests**

Test that no active wallet returns an empty list and that injected wallet transaction readers return mapped rows.

- [ ] **Step 2: Run failing tests**

Run: `flutter test bdk_demo/test/features/transactions/transactions_repository_test.dart`

Expected: FAIL because the repository still returns hardcoded placeholder data.

- [ ] **Step 3: Implement wallet-backed repository**

Default provider reads `activeWalletProvider`. The repository maps `wallet.transactions()` and `wallet.sentAndReceived(tx:)`; detail lookup uses `wallet.txDetails(txid:)` when available and falls back to the transaction list.

- [ ] **Step 4: Run passing tests**

Run: `flutter test bdk_demo/test/features/transactions/transactions_repository_test.dart`

Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add bdk_demo/lib/features/transactions bdk_demo/test/features/transactions bdk_demo/test/presentation/transactions
git commit -m "feat: load real wallet transaction history"
```

### Task 4: Verification and PR

**Files:**
- No production files expected.

**Interfaces:**
- Consumes: all previous tasks.
- Produces: pushed branch and draft PR.

- [ ] **Step 1: Format**

Run: `dart format --output=none --set-exit-if-changed lib test example bdk_demo/lib bdk_demo/test`

- [ ] **Step 2: Analyze**

Run: `dart analyze --fatal-infos --fatal-warnings lib test example`

- [ ] **Step 3: Test root package**

Run: `dart test`

- [ ] **Step 4: Test demo app**

Run: `flutter test bdk_demo/test`

- [ ] **Step 5: Push and open draft PR**

Push branch `feat/bdk-demo-real-transaction-history` and open a draft PR titled `feat: load real transaction history in demo app`.
