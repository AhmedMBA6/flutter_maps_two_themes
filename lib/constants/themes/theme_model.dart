import 'package:flutter/material.dart';
import 'theme_preference.dart';

class ThemeModel extends ChangeNotifier {
  bool _isDark = false;
  final ThemePreference _preference = ThemePreference();

  bool get isDark => _isDark;

  ThemeModel() {
    getPreferences();
  }

  set isDark(bool value) {
    _isDark = value;
    _preference.setTheme(value);
    notifyListeners();
  }

  Future<void> getPreferences() async {
    _isDark = await _preference.getTheme();
    notifyListeners();
  }
}
