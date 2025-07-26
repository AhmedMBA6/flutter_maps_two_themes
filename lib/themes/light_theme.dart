import 'package:flutter/material.dart';
import 'package:flutter_login_two_themes/themes/app_color.dart';

ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColor.bodyColor,
    hintColor: AppColor.textColor,
    primaryColorLight: AppColor.buttonBackgroundColor,
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
          color: Colors.black, fontSize: 40, fontWeight: FontWeight.bold),
    ),
    buttonTheme: const ButtonThemeData(
        textTheme: ButtonTextTheme.primary, buttonColor: Colors.black), dialogTheme: DialogThemeData(backgroundColor: AppColor.bodyColor));
