import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_login_two_themes/logic_layer/auth/auth_cubit.dart';
import 'package:flutter_login_two_themes/logic_layer/auth/auth_state.dart';
import 'package:flutter_login_two_themes/presentation/screens/auth/auth_screen.dart';
import 'package:flutter_login_two_themes/presentation/screens/home/home_screen.dart';

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (_) => const AuthWrapper(),
        );
      case '/auth':
        return MaterialPageRoute(
          builder: (_) => const AuthScreen(),
        );
      case '/home':
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const AuthWrapper(), // Fallback route
        );
    }
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        // Check if user is authenticated
        if (state is SignInSuccess || state is SignUpSuccess || state is AuthSuccess) {
          return const HomeScreen();
        }
        
        // Show auth screen for all other states
        return const AuthScreen();
      },
    );
  }
}
