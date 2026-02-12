import "dart:typed_data";

import "package:bdk_dart/bdk.dart";
import "package:test/test.dart";

void main() {
  group("ChainPosition ffi converter", () {
    test("read reports relative bytes from a non-zero buffer offset", () {
      final chainPosition = UnconfirmedChainPosition(1234567890);
      final encoded = Uint8List(chainPosition.allocationSize());
      final encodedLength = FfiConverterChainPosition.write(chainPosition, encoded);

      expect(encodedLength, encoded.length);

      const prefixLength = 11;
      final padded = Uint8List(prefixLength + encoded.length);
      padded.setRange(prefixLength, padded.length, encoded);

      final lifted = FfiConverterChainPosition.read(
        Uint8List.view(padded.buffer, prefixLength),
      );

      final unconfirmed = lifted.value as UnconfirmedChainPosition;
      expect(unconfirmed.timestamp, 1234567890);
      expect(lifted.bytesRead, encoded.length);
    });

    test("write reports relative bytes from a non-zero buffer offset", () {
      final chainPosition = UnconfirmedChainPosition(1234567890);
      const prefixLength = 7;
      final buffer = Uint8List(prefixLength + chainPosition.allocationSize());

      final bytesWritten = FfiConverterChainPosition.write(
        chainPosition,
        Uint8List.view(buffer.buffer, prefixLength),
      );

      expect(bytesWritten, chainPosition.allocationSize());
    });
  });
}
