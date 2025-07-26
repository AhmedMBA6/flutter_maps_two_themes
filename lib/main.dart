import 'package:flutter/material.dart';
import 'package:flutter_login_two_themes/presentation/login.dart';
import 'package:flutter_login_two_themes/constants/themes/app_theme.dart';
import 'package:flutter_login_two_themes/constants/themes/theme_model.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeModel(),
      child: Consumer<ThemeModel>(
          builder: (context, ThemeModel themeNotifier, child) => MaterialApp(
                home: const LoginPage(),
                theme: themeNotifier.isDark ? AppTheme.dark : AppTheme.light,
                debugShowCheckedModeBanner: false,
              )),
    );
  }
}
