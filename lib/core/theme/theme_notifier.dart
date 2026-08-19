import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_notifier.g.dart';

/// Persisted light/dark/system preference. App-wide UI state, so it lives
/// in `core/` rather than under any one feature.
@riverpod
class ThemeNotifier extends _$ThemeNotifier {
  static const _key = 'theme_mode';

  @override
  Future<ThemeMode> build() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_key);
    return switch (saved) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }

  Future<void> setMode(ThemeMode newMode) async {
    state = AsyncData(newMode);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, newMode.name);
  }
}
