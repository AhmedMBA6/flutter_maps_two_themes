import 'package:shared_preferences/shared_preferences.dart';

class ThemePreference {
  static const String _prefKey = 'theme_mode';

  Future<void> setTheme(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefKey, value);
  }

  Future<bool> getTheme() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_prefKey) ?? false;
  }
}
