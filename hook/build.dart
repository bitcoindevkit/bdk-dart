import 'package:hooks/hooks.dart';
import 'package:native_toolchain_rust/native_toolchain_rust.dart';

Future<void> main(List<String> args) async {
  await build(args, (input, output) async {
    final cargoConfigPath = input.packageRoot
        .resolve('native/.cargo/config.toml')
        .toFilePath();

    // Native Assets invokes Cargo from the package root, so pass the crate-local
    // config explicitly instead of relying on Cargo's working-directory lookup.
    await RustBuilder(
      assetName: 'uniffi:bdk_dart_ffi',
      extraCargoBuildArgs: ['--config', cargoConfigPath],
    ).run(input: input, output: output);
  });
}
