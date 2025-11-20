import 'package:flutter/material.dart';
import 'package:food_order_app_flutter_firebase/themes/dark_mode.dart';
import 'package:food_order_app_flutter_firebase/themes/light_mode.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// ThemeProvider that persists the user's theme choice in SharedPreferences.
/// Kept simple and readable (junior-dev style) as requested.
class ThemeProvider with ChangeNotifier {
  static const String _prefKey = 'isDarkMode';
  final prefs = SharedPreferences.getInstance();

  ThemeData _themeData = lightMode;

  ThemeProvider() {
    _loadThemeFromPrefs();
  }

  ThemeData get themeData => _themeData;

  bool get isDarkMode => _themeData == darkMode;

  set themeData(ThemeData themeData) {
    _themeData = themeData;
    // persist choice; don't await here to keep setter sync
    SharedPreferences.getInstance().then((prefs) {
      prefs.setBool(_prefKey, _themeData == darkMode);
    });
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();
    if (_themeData == lightMode) {
      _themeData = darkMode;
      await prefs.setBool(_prefKey, true);
    } else {
      _themeData = lightMode;
      await prefs.setBool(_prefKey, false);
    }
    notifyListeners();
  }

  Future<void> _loadThemeFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedIsDark = prefs.getBool(_prefKey) ?? false;
      _themeData = savedIsDark ? darkMode : lightMode;
      notifyListeners();
    } catch (_) {
      // If reading prefs fails, keep default theme
    }
  }
}
