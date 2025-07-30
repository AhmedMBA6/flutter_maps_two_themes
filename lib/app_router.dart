import 'package:flutter/material.dart';
import 'package:flutter_login_two_themes/presentation/screens/auth/auth_screen.dart';
import 'package:flutter_login_two_themes/presentation/screens/home/home_screen.dart';

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (_) => const AuthScreen(),
        );
      case '/home':
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const AuthScreen(), // Fallback route
        );
    }
  }
}
