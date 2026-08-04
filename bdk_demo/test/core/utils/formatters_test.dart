import 'package:flutter_test/flutter_test.dart';
import 'package:bdk_demo/core/utils/formatters.dart';
import 'package:bdk_demo/models/currency_unit.dart';

void main() {
  group('Formatters', () {
    group('formatBalance', () {
      test('formats correctly when unit is Bitcoin', () {
        const satoshis = 150000000;
        final result = Formatters.formatBalance(satoshis, CurrencyUnit.bitcoin);
        expect(result, '1.50000000');
      });

      test('formats correctly when unit is Satoshi', () {
        const satoshis = 150000000;
        final result = Formatters.formatBalance(satoshis, CurrencyUnit.satoshi);
        expect(result, '150000000 sat');
      });

      // Edge Cases
      test('handles zero balance correctly for Bitcoin', () {
        final result = Formatters.formatBalance(0, CurrencyUnit.bitcoin);
        expect(result, '0.00000000');
      });

      test('handles zero balance correctly for Satoshi', () {
        final result = Formatters.formatBalance(0, CurrencyUnit.satoshi);
        expect(result, '0 sat');
      });

      test('handles negative balance correctly for Bitcoin', () {
        final result = Formatters.formatBalance(
          -150000000,
          CurrencyUnit.bitcoin,
        );
        expect(result, '-1.50000000');
      });
    });

    group('formatAddress', () {
      test('chunks string into groups of 4 characters', () {
        const address = 'tb1q1234567890';
        final result = Formatters.formatAddress(address);
        expect(result, 'tb1q 1234 5678 90');
      });

      // Edge Case
      test('handles empty string gracefully', () {
        final result = Formatters.formatAddress('');
        expect(result, '');
      });
    });

    group('formatTimestamp', () {
      test('formats unix seconds into human readable date', () {
        // We dynamically get the current time
        final now = DateTime.now();
        final unixSeconds = (now.millisecondsSinceEpoch / 1000).round();

        final result = Formatters.formatTimestamp(unixSeconds);

        // We check that the formatted string contains the current year!
        expect(result.contains(now.year.toString()), isTrue);
        expect(result.contains(':'), isTrue);
      });
    });

    group('abbreviateTxid', () {
      test('abbreviates long txids', () {
        const txid = '1234567890abcdef1234567890abcdef';
        final result = Formatters.abbreviateTxid(txid);
        expect(result, '123456...cdef');
      });

      test('returns original string if txid is short', () {
        const txid = '1234567890';
        final result = Formatters.abbreviateTxid(txid);
        expect(result, '1234567890');
      });

      // Edge Case
      test('handles empty string gracefully', () {
        final result = Formatters.abbreviateTxid('');
        expect(result, '');
      });
    });
  });

  group('StringChunking Extension', () {
    test('splitByLength splits correctly', () {
      const text = 'abcdefghij';
      final result = text.splitByLength(3);
      expect(result, ['abc', 'def', 'ghi', 'j']);
    });

    // Edge Case
    test('splitByLength handles empty string gracefully', () {
      const text = '';
      final result = text.splitByLength(3);
      expect(result, []);
    });
  });
}
