import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/storage_service.dart';

final storageServiceProvider = Provider<StorageService>((ref) {
  throw UnimplementedError(
    'storageServiceProvider must be overridden with a ProviderScope override '
    'after SharedPreferences is initialized in bootstrap().',
  );
});

final themeModeProvider =
    NotifierProvider<ThemeModeNotifier, ThemeMode>(ThemeModeNotifier.new);

class ThemeModeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    final storage = ref.watch(storageServiceProvider);
    return storage.getDarkTheme() ? ThemeMode.dark : ThemeMode.light;
  }

  void toggle() {
    final isDark = state == ThemeMode.dark;
    state = isDark ? ThemeMode.light : ThemeMode.dark;
    ref.read(storageServiceProvider).setDarkTheme(!isDark);
  }

  void setThemeMode(ThemeMode mode) {
    state = mode;
    ref.read(storageServiceProvider).setDarkTheme(mode == ThemeMode.dark);
  }
}

final introDoneProvider = Provider<bool>((ref) {
  final storage = ref.watch(storageServiceProvider);
  return storage.getIntroDone();
});
