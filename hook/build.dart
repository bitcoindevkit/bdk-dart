import 'package:bdk_dart/src/precompiled/precompiled_builder.dart';
import 'package:hooks/hooks.dart';
import 'package:native_toolchain_rust/native_toolchain_rust.dart' as ntr;

void main(List<String> args) async {
  await build(args, (input, output) async {
    final builder = PrecompiledBuilder(
      assetName: 'uniffi:bdk_dart_ffi',
      buildModeName: ntr.BuildMode.release.name,
      fallback: (input, output, assetRouting, logger) async {
        final rustBuilder = ntr.RustBuilder(
          assetName: 'uniffi:bdk_dart_ffi',
          buildMode: ntr.BuildMode.release,
        );
        await rustBuilder.run(
          input: input,
          output: output,
          assetRouting: assetRouting,
          logger: logger,
        );
      },
    );
    await builder.run(input: input, output: output);
  });
}
