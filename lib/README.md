# Generated bindings live here

The Dart bindings are produced by UniFFI-Dart and are **not** checked into
source control. Run `scripts/generate_bindings.sh` to regenerate
`bdk.dart` before building or testing.

This placeholder file keeps the `lib/` directory present in the
repository so that `dart` tooling can resolve the package structure.

## Mobile build artifacts

Mobile consumers (Flutter/Dart) can build platform-specific binaries using the
scripts in `scripts/`.

### iOS (XCFramework)

1. Generate the required static libraries:
   ```bash
   ./scripts/generate_bindings.sh --target ios
   ```
2. Package them into an XCFramework:
   ```bash
   ./scripts/build-ios-xcframework.sh
   ```
   The framework is written to `ios/Release/bdkffi.xcframework/`.

### Android (.so libraries)

1. Ensure `ANDROID_NDK_ROOT` points to an Android NDK r26c (or compatible) installation. For example:
   - macOS/Linux (adjust the NDK directory as needed):
     ```bash
     export ANDROID_NDK_ROOT="$HOME/Library/Android/sdk/ndk/29.0.14206865"
     ```
   - Windows PowerShell:
     ```powershell
     $Env:ANDROID_NDK_ROOT = "C:\\Users\\<you>\\AppData\\Local\\Android\\Sdk\\ndk\\29.0.14206865"
     ```
     (Use `setx ANDROID_NDK_ROOT <path>` if you want the variable persisted for future shells.)
2. Build the shared objects:
   ```bash
   ./scripts/generate_bindings.sh --target android
   ```
3. Stage the artifacts for inclusion in a Flutter project:
   ```bash
   ./scripts/build-android.sh
   ```
   Output libraries are copied to `android/libs/<abi>/libbdkffi.so`.

### Desktop tests (macOS/Linux)

- Run the base script without a target flag before executing `dart test`:
  ```bash
  ./scripts/generate_bindings.sh
  ```
  This regenerates the Dart bindings and drops the host dynamic library
  (`libbdkffi.dylib` on macOS, `libbdkffi.so` on Linux) in the project root.
  The generated loader expects those files when running in the VM, so tests fail if you only invoke the platform-specific targets.

### Verification

- On iOS, confirm the framework slices:
  ```bash
  lipo -info ios/Release/bdkffi.xcframework/ios-arm64/libbdkffi.a
  lipo -info ios/Release/bdkffi.xcframework/ios-arm64_x86_64-simulator/libbdkffi.a
  ```
- On Android, verify the shared objects:
  ```bash
  find android/libs -name "libbdkffi.so"
  ```
