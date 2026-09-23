import 'package:bdk_dart/bdk.dart';
import 'package:test/test.dart';

void main() {
  test('Amount round-trips the full u64 range', () {
    final upperHalfStart = BigInt.one << 63;
    final u64Max = (BigInt.one << 64) - BigInt.one;

    for (final satoshis in [upperHalfStart, u64Max]) {
      final amount = Amount.fromSat(satoshi: satoshis);
      try {
        expect(amount.toSat(), satoshis);
        expect(() => amount.toSat().toIntChecked(), throwsRangeError);
      } finally {
        amount.dispose();
      }
    }
  });

  test('Amount still accepts ordinary int input', () {
    final amount = Amount.fromSat(satoshi: 42);
    try {
      expect(amount.toSat(), BigInt.from(42));
      expect(amount.toSat().toIntChecked(), 42);
    } finally {
      amount.dispose();
    }
  });

  test('Amount rejects values outside u64', () {
    expect(() => Amount.fromSat(satoshi: -1), throwsRangeError);
    expect(() => Amount.fromSat(satoshi: BigInt.one << 64), throwsRangeError);
  });
}
