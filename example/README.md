# BDK Dart Example

A simple example demonstrating how to use the BDK Dart bindings.

## Running the example

1. Make sure you're in the example directory:
   ```bash
   cd example
   ```

2. Get dependencies (this will trigger the build hook to compile the native library):
   ```bash
   dart pub get
   ```

3. Run the example:
   ```bash
   dart run
   ```

The example demonstrates:
- Generating a new mnemonic
- Creating BIP84 descriptors
- Initializing a wallet
- Generating addresses
- Syncing with an Electrum server
