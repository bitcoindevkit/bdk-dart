# Receive Page Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace the demo app's `/receive` placeholder with a tested Receive page that generates, displays, QR-encodes, and copies the active wallet's persisted receive address.

**Architecture:** Add one presentation-only `ConsumerWidget` that watches the existing active-wallet and receive-address providers. Keep address generation and persistence in the existing notifier/service, and use provider overrides in widget tests so UI behavior is deterministic and isolated.

**Tech Stack:** Flutter, Dart, Riverpod 3, GoRouter, `pretty_qr_code`, `flutter_test`

---

## File Structure

- Create `bdk_demo/lib/features/receive/receive_page.dart`: Receive UI and state rendering.
- Create `bdk_demo/lib/features/receive/receive_address_card.dart`: QR, address, index, and copy presentation.
- Create `bdk_demo/lib/features/receive/receive_error_panel.dart`: Provider error presentation.
- Create `bdk_demo/test/presentation/receive_page_test.dart`: Widget coverage using a fake receive notifier.
- Modify `bdk_demo/lib/core/router/app_router.dart`: Replace the Receive placeholder route.
- Modify `bdk_demo/test/presentation/router_wiring_test.dart`: Verify `/receive` resolves to `ReceivePage`.

### Task 1: Receive Page States And Actions

**Files:**
- Create: `bdk_demo/test/presentation/receive_page_test.dart`
- Create: `bdk_demo/lib/features/receive/receive_page.dart`

- [ ] **Step 1: Write the failing widget tests**

Create a fake notifier that exposes a chosen `ReceiveAddressState` and records generation calls:

```dart
class _FakeReceiveAddressNotifier extends CurrentReceiveAddressNotifier {
  _FakeReceiveAddressNotifier(this.initialState);

  final ReceiveAddressState initialState;
  var generationCalls = 0;

  @override
  ReceiveAddressState build() => initialState;

  @override
  Future<void> generateForActiveWallet() async {
    generationCalls += 1;
  }
}
```

Pump `ReceivePage` inside `ProviderScope` with overrides for `currentReceiveAddressProvider` and `activeWalletRecordProvider`. Add tests that assert:

```dart
testWidgets('shows generate action for an active wallet', (tester) async {
  final notifier = _FakeReceiveAddressNotifier(ReceiveAddressState.empty);
  await pumpReceivePage(tester, notifier: notifier, activeWallet: testRecord);

  expect(find.text('Generate address'), findsOneWidget);
  await tester.tap(find.text('Generate address'));
  await tester.pump();
  expect(notifier.generationCalls, 1);
});

testWidgets('shows QR, address, index, and new-address action', (tester) async {
  final notifier = _FakeReceiveAddressNotifier(
    const ReceiveAddressState(
      walletId: 'wallet-1',
      address: testAddress,
      index: 7,
    ),
  );
  await pumpReceivePage(tester, notifier: notifier, activeWallet: testRecord);

  expect(find.byKey(const Key('receive-address-qr')), findsOneWidget);
  expect(find.text(testAddress), findsOneWidget);
  expect(find.text('External index 7'), findsOneWidget);
  expect(find.text('Generate new address'), findsOneWidget);
});

testWidgets('shows loading and disables generation', (tester) async {
  final notifier = _FakeReceiveAddressNotifier(
    const ReceiveAddressState(walletId: 'wallet-1', isGenerating: true),
  );
  await pumpReceivePage(tester, notifier: notifier, activeWallet: testRecord);

  expect(find.byType(CircularProgressIndicator), findsOneWidget);
  expect(tester.widget<FilledButton>(find.byType(FilledButton)).onPressed, isNull);
});

testWidgets('shows provider error and retry action', (tester) async {
  final notifier = _FakeReceiveAddressNotifier(
    const ReceiveAddressState(
      walletId: 'wallet-1',
      errorMessage: 'StateError: generation failed',
    ),
  );
  await pumpReceivePage(tester, notifier: notifier, activeWallet: testRecord);

  expect(find.textContaining('generation failed'), findsOneWidget);
  expect(find.text('Try again'), findsOneWidget);
});

testWidgets('shows safe state without an active wallet', (tester) async {
  final notifier = _FakeReceiveAddressNotifier(ReceiveAddressState.empty);
  await pumpReceivePage(tester, notifier: notifier);

  expect(find.text('No active wallet'), findsOneWidget);
  expect(find.text('Generate address'), findsNothing);
});
```

Add a clipboard test by installing a mock handler for `SystemChannels.platform`, tapping the copy button, asserting the `Clipboard.setData` payload equals `testAddress`, and checking for the `Address copied` snackbar.

- [ ] **Step 2: Run the new tests and verify they fail**

Run:

```bash
cd bdk_demo
flutter test test/presentation/receive_page_test.dart
```

Expected: FAIL because `ReceivePage` does not exist.

- [ ] **Step 3: Implement the minimal Receive page**

Create `ReceivePage` as a `ConsumerWidget` with:

```dart
class ReceivePage extends ConsumerWidget {
  const ReceivePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final record = ref.watch(activeWalletRecordProvider);
    final receiveState = ref.watch(currentReceiveAddressProvider);

    return Scaffold(
      appBar: const SecondaryAppBar(title: 'Receive'),
      body: SafeArea(
        child: record == null
            ? const WalletStateCard(
                icon: Icons.account_balance_wallet_outlined,
                title: 'No active wallet',
                message: 'Load a wallet before generating a receive address.',
                centered: true,
              )
            : ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  Text('Receive on ${record.network.displayName}'),
                  const SizedBox(height: 16),
                  if (receiveState.address case final address?)
                    _ReceiveAddressCard(
                      address: address,
                      index: receiveState.index,
                    )
                  else
                    WalletStateCard(
                      icon: Icons.qr_code_2,
                      title: receiveState.isGenerating
                          ? 'Generating address'
                          : 'Ready to receive',
                      message: receiveState.isGenerating
                          ? 'Revealing and saving the next external address.'
                          : 'Generate a fresh external address for this wallet.',
                      showSpinner: receiveState.isGenerating,
                    ),
                  if (receiveState.errorMessage case final error?) ...[
                    const SizedBox(height: 12),
                    Text(error, key: const Key('receive-error')),
                  ],
                  const SizedBox(height: 20),
                  FilledButton.icon(
                    onPressed: receiveState.isGenerating
                        ? null
                        : () => ref
                            .read(currentReceiveAddressProvider.notifier)
                            .generateForActiveWallet(),
                    icon: const Icon(Icons.add_location_alt_outlined),
                    label: Text(
                      receiveState.address != null
                          ? 'Generate new address'
                          : receiveState.errorMessage != null
                          ? 'Try again'
                          : 'Generate address',
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
```

Implement `_ReceiveAddressCard` in the same file using `PrettyQrView.data(data: address, key: const Key('receive-address-qr'))`, `SelectableText(address)`, `External index $index`, and an `OutlinedButton.icon` that calls:

```dart
ClipboardUtil.copyAndNotify(
  context,
  address,
  message: 'Address copied',
);
```

- [ ] **Step 4: Format and run the focused tests**

Run:

```bash
dart format lib/features/receive/receive_page.dart test/presentation/receive_page_test.dart
flutter test test/presentation/receive_page_test.dart
```

Expected: all Receive page tests pass.

- [ ] **Step 5: Commit the Receive page**

```bash
git add bdk_demo/lib/features/receive/receive_page.dart bdk_demo/test/presentation/receive_page_test.dart
git commit -m "feat(demo): add receive address page"
```

### Task 2: Route Wiring

**Files:**
- Modify: `bdk_demo/lib/core/router/app_router.dart`
- Modify: `bdk_demo/test/presentation/router_wiring_test.dart`

- [ ] **Step 1: Write the failing route test**

Import `ReceivePage` and add:

```dart
testWidgets('/receive resolves to ReceivePage', (tester) async {
  await pumpRouterAt(
    tester,
    AppRoutes.receive,
    seedActiveWallet: true,
  );

  expect(find.byType(ReceivePage), findsOneWidget);
  expect(find.byType(PlaceholderPage), findsNothing);
});
```

- [ ] **Step 2: Run the route test and verify it fails**

Run:

```bash
cd bdk_demo
flutter test test/presentation/router_wiring_test.dart --plain-name '/receive resolves to ReceivePage'
```

Expected: FAIL because `/receive` still builds `PlaceholderPage`.

- [ ] **Step 3: Replace the placeholder route**

Import the page and update the route builder:

```dart
import 'package:bdk_demo/features/receive/receive_page.dart';

GoRoute(
  path: AppRoutes.receive,
  name: 'receive',
  builder: (context, state) => const ReceivePage(),
),
```

- [ ] **Step 4: Format and run routing tests**

Run:

```bash
dart format lib/core/router/app_router.dart test/presentation/router_wiring_test.dart
flutter test test/presentation/router_wiring_test.dart
```

Expected: all router wiring tests pass.

- [ ] **Step 5: Commit route wiring**

```bash
git add bdk_demo/lib/core/router/app_router.dart bdk_demo/test/presentation/router_wiring_test.dart
git commit -m "feat(demo): route receive screen"
```

### Task 3: Verification And Draft PR

**Files:**
- Verify all files changed by Tasks 1-2.

- [ ] **Step 1: Run formatting checks**

```bash
cd bdk_demo
dart format --output=none --set-exit-if-changed lib test
```

Expected: exit code 0 with no changed files.

- [ ] **Step 2: Run static analysis**

```bash
flutter analyze
```

Expected: `No issues found!`

- [ ] **Step 3: Run the complete demo test suite**

```bash
flutter test
```

Expected: all tests pass.

- [ ] **Step 4: Inspect final scope**

```bash
git diff upstream/main...HEAD --stat
git diff --check upstream/main...HEAD
git status --short --branch
```

Expected: only the design/plan, Receive page, Receive page tests, router, and router tests are changed; the worktree is clean.

- [ ] **Step 5: Push and open a draft PR**

```bash
git push -u origin feat/receive-page
gh pr create \
  --repo bitcoindevkit/bdk-dart \
  --head j-kon:feat/receive-page \
  --base main \
  --draft \
  --title "bdk_demo: add receive address screen" \
  --body "## Summary

- replace the Receive placeholder with a focused receive-address screen
- render the generated address as QR and selectable text
- add copy, loading, empty, error, and retry states
- cover the page and route with widget tests

Closes #83

## Testing

- flutter analyze
- flutter test"
```

Expected: GitHub returns a new PR URL and the PR is marked Draft.
