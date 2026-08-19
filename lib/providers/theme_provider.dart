import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Persisted light/dark/system preference — the Flutter counterpart of the
/// `useColorScheme` + `userInterfaceStyle: "automatic"` setup on the Expo
/// side, except here the user can also override the OS setting explicitly.
class ThemeProvider extends ChangeNotifier {
  ThemeProvider() {
    _restore();
  }

  static const _key = 'theme_mode';

  ThemeMode mode = ThemeMode.system;

  Future<void> _restore() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_key);
    mode = switch (saved) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
    notifyListeners();
  }

  Future<void> setMode(ThemeMode newMode) async {
    mode = newMode;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, newMode.name);
  }
}
