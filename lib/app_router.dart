import 'package:flutter/material.dart';
import 'package:flutter_login_two_themes/presentation/screens/auth/auth_screen.dart';

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (_) => const AuthScreen(),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const AuthScreen(), // Fallback route
        );
    }
  }
}
