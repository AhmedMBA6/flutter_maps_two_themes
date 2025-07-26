import 'package:flutter/material.dart';
import 'package:flutter_login_two_themes/constants/themes/theme_preference.dart';

class ThemeModel extends ChangeNotifier{
  bool _isDark = false;
  late ThemePreference  _preference;
  bool get isDark => _isDark;
  ThemeModel () {
    _isDark = false;
    _preference = ThemePreference();
    getPreferences();
  }
  set isDark(bool value){
    _isDark = value;
    _preference.setTheme(value);
    notifyListeners();
  }
  getPreferences() async{
    _isDark = await _preference.getTheme();
    notifyListeners();
  }

}