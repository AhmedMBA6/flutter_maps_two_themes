import 'package:shared_preferences/shared_preferences.dart';

class ThemePreference {
  static const Pref_key = "pref_key";
  setTheme(bool value) async {
    SharedPreferences sharedPreferences =await SharedPreferences.getInstance();
    sharedPreferences.setBool(Pref_key, value);
  }

  getTheme() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool(Pref_key) ?? false;
  }
}