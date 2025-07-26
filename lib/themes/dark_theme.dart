import 'package:flutter/material.dart';
import 'package:flutter_login_two_themes/themes/app_color.dart';

ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColor.bodyColorDark,
    hintColor: AppColor.textColorDark,
    primaryColorLight: AppColor.buttonBackgroundColorDark,
    textTheme: const TextTheme(
        headlineLarge: TextStyle(
            color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold)),
    buttonTheme: const ButtonThemeData(
        textTheme: ButtonTextTheme.primary, buttonColor: Colors.white), dialogTheme: DialogThemeData(backgroundColor: AppColor.bodyColorDark));
