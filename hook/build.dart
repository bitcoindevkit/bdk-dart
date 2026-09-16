import 'package:hooks/hooks.dart';
import 'package:native_toolchain_rust/native_toolchain_rust.dart';

Future<void> main(List<String> args) async {
  await build(args, (input, output) async {
    // Android 16 KiB page alignment is handled by native/build.rs, so no extra
    // Cargo configuration needs to be shipped or passed here.
    await RustBuilder(
      assetName: 'uniffi:bdk_dart_ffi',
      extraCargoBuildArgs: ['--locked'],
    ).run(input: input, output: output);
  });
}
