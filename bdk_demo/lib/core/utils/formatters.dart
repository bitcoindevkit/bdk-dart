import 'package:bdk_demo/models/currency_unit.dart';

abstract final class Formatters {
  static String formatBalance(int satoshis, CurrencyUnit unit) =>
      switch (unit) {
        CurrencyUnit.bitcoin => (satoshis / 100000000).toStringAsFixed(8),
        CurrencyUnit.satoshi => '$satoshis sat',
      };

  static String formatAddress(String address) =>
      address.splitByLength(4).join(' ');

  static String formatTimestamp(int unixSeconds) {
    final dt = DateTime.fromMillisecondsSinceEpoch(unixSeconds * 1000);
    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    final month = months[dt.month - 1];
    final hour = dt.hour.toString().padLeft(2, '0');
    final minute = dt.minute.toString().padLeft(2, '0');
    return '$month ${dt.day} ${dt.year} $hour:$minute';
  }

  static String abbreviateTxid(String txid) => txid.length > 16
      ? '${txid.substring(0, 8)}...${txid.substring(txid.length - 8)}'
      : txid;
}

extension StringChunking on String {
  List<String> splitByLength(int size) {
    final chunks = <String>[];
    for (var i = 0; i < length; i += size) {
      chunks.add(substring(i, i + size > length ? length : i + size));
    }
    return chunks;
  }
}
