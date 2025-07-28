import 'package:flutter/material.dart';
import 'app_colors.dart';

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: Colors.transparent,
  primaryColor: AppColors.primary,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
    foregroundColor: AppColors.foregroundDark,
    elevation: 0,
  ),
  colorScheme: const ColorScheme.dark(
    primary: AppColors.primary,
    secondary: AppColors.primaryLight,
    surface: AppColors.darkScaffoldColor,
    error: AppColors.error,
    onPrimary: AppColors.foregroundDark,
    onSecondary: AppColors.foregroundDark,
    onSurface: AppColors.foregroundDark,
    onError: Colors.black,
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: AppColors.foregroundDark),
    bodyMedium: TextStyle(color: AppColors.foregroundDark),
    labelLarge: TextStyle(color: AppColors.foregroundDark),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.inputBackgroundDark,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: AppColors.borderDark),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: AppColors.primary),
    ),
  ),
);
