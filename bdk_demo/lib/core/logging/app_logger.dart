import 'dart:collection';

import 'package:bdk_demo/core/constants/app_constants.dart';

enum LogLevel { info, warn, error }

class AppLogger {
  AppLogger._();

  static final AppLogger instance = AppLogger._();

  final _entries = Queue<String>();

  int get maxEntries => AppConstants.maxLogEntries;

  void log(LogLevel level, String message) {
    final timestamp = DateTime.now().toIso8601String();
    final label = switch (level) {
      LogLevel.info => 'INFO',
      LogLevel.warn => 'WARN',
      LogLevel.error => 'ERROR',
    };
    _entries.addFirst('$timestamp [$label]  $message');
    while (_entries.length > maxEntries) {
      _entries.removeLast();
    }
  }

  void info(String message) => log(LogLevel.info, message);
  void warn(String message) => log(LogLevel.warn, message);
  void error(String message) => log(LogLevel.error, message);

  List<String> getLogs() => _entries.toList();

  void clear() => _entries.clear();
}
