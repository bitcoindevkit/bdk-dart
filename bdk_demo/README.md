# bdk_demo

`bdk_demo` is a small Flutter reference app for `bdk_dart`.

It is intentionally scoped to one screen that helps you verify the bindings are
wired up correctly from Flutter. The demo:

- explains what the example is doing before you run it
- loads an example testnet descriptor through `bdk_dart`
- shows clear idle, loading, success, and error states
- presents the returned network and descriptor preview in a readable way

This app is not a full wallet UI. It does not add send/receive flows, wallet
setup, or persistence. The goal is to provide a simple onboarding example you
can use as a reference when integrating `bdk_dart` into a Flutter app.

## Run the demo

From this directory:

```sh
flutter pub get
flutter run
```

Tap the primary action on the home screen to load the example demo data and
inspect the returned state.
