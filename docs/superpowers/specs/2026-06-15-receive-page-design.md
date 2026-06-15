# Receive Page Design

## Context

The Flutter demo is a reference application for showing how Flutter developers can use `bdk_dart`. Address generation and persistence were added in #78 and PR #79, but the `/receive` route still displays a placeholder. Issue #83 tracks the focused UI follow-up.

## Goal

Add a small Receive page that demonstrates the complete receive-address flow: request the next persisted external address, display it as text and a QR code, show its derivation index, and let the user copy it.

## Scope

- Replace the `/receive` placeholder with `ReceivePage`.
- Read `currentReceiveAddressProvider` for the active wallet.
- Trigger generation through `generateForActiveWallet()`.
- Display loading, initial, success, and error states.
- Render the generated address with `PrettyQrView.data`.
- Display the external derivation index.
- Copy the address through the existing `ClipboardUtil.copyAndNotify` helper.
- Add route and widget tests.

The feature will not add BIP21 amount or label fields, address sharing, new persistence behavior, or send/broadcast changes.

## User Flow

1. The user opens Receive from the wallet home page.
2. If no address has been generated for the active wallet, the page explains the action and presents a `Generate address` button.
3. While generation is running, the action is disabled and a progress indicator is shown.
4. On success, the page shows the QR code, full address, derivation index, and a copy action.
5. The user may request another address with a clearly labeled `Generate new address` action.
6. On failure, the page keeps any previously successful address visible when provider state supplies one, shows a concise error message, and allows retrying.
7. If there is no active wallet, the page shows a safe empty state and does not attempt generation.

## Architecture

### ReceivePage

`ReceivePage` will be a `ConsumerWidget` in `bdk_demo/lib/features/receive/receive_page.dart`. It owns presentation only and watches:

- `activeWalletRecordProvider` to determine whether a wallet is active and show its network context.
- `currentReceiveAddressProvider` for address, index, loading, and error state.

Button actions call `currentReceiveAddressProvider.notifier.generateForActiveWallet()`. The page does not call `WalletService` directly and does not duplicate persistence logic.

### Routing

The existing `/receive` route will construct `ReceivePage` instead of `PlaceholderPage`. No route names or navigation paths change.

### QR And Clipboard

The existing `pretty_qr_code` dependency will render the raw Bitcoin address. BIP21 encoding is intentionally excluded. The existing clipboard utility will provide the copy operation and snackbar confirmation.

## State Presentation

- **No active wallet:** Informational wallet-empty state with no generation action.
- **Initial:** Explanation plus `Generate address` action.
- **Loading:** Progress indicator and disabled generation action.
- **Success:** QR code, selectable address text, derivation index, copy action, and `Generate new address` action.
- **Error without address:** Error text and retry action.
- **Error with previous address:** Keep the QR/address visible, show the error separately, and retain retry capability.

Provider error strings may contain exception prefixes. The page will present them without adding new domain-level error mapping in this PR.

## Testing

Widget tests will cover:

- Initial state with an active wallet.
- Successful address presentation, including QR payload and derivation index.
- Loading state and disabled duplicate action.
- Error state and retry action.
- Copy action and confirmation snackbar.
- No-active-wallet state.

Router tests will verify `/receive` resolves to `ReceivePage` rather than `PlaceholderPage`.

The implementation is complete when `flutter analyze` and the full `flutter test` suite pass in `bdk_demo`.

## File Impact

- Add `bdk_demo/lib/features/receive/receive_page.dart`.
- Add `bdk_demo/lib/features/receive/receive_address_card.dart`.
- Add `bdk_demo/lib/features/receive/receive_error_panel.dart`.
- Add `bdk_demo/test/presentation/receive_page_test.dart`.
- Update `bdk_demo/lib/core/router/app_router.dart`.
- Update `bdk_demo/test/presentation/router_wiring_test.dart`.

No service, generated binding, native, CI, send-feature, or platform-runner files are part of this change.
