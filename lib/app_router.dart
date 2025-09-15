import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_login_two_themes/data_layer/repos/map/maps_repo.dart';
import 'package:flutter_login_two_themes/data_layer/webservices/places_web_services.dart';
import 'package:flutter_login_two_themes/logic_layer/auth/auth_cubit.dart';
import 'package:flutter_login_two_themes/logic_layer/auth/auth_state.dart';
import 'package:flutter_login_two_themes/logic_layer/maps/maps_cubit.dart';
import 'package:flutter_login_two_themes/presentation/screens/auth/auth_screen.dart';
import 'package:flutter_login_two_themes/presentation/screens/maps/maps_screen.dart';

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (_) => const InitialRouteHandler(),
        );
      case '/auth':
        return MaterialPageRoute(
          builder: (_) => const AuthScreen(),
        );
      case '/home':
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => MapsCubit(MapsRepository(PlacesWebServices())),
            child: const MapsScreen(),
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const InitialRouteHandler(), // Fallback route
        );
    }
  }
}

class InitialRouteHandler extends StatefulWidget {
  const InitialRouteHandler({super.key});

  @override
  State<InitialRouteHandler> createState() => _InitialRouteHandlerState();
}

class _InitialRouteHandlerState extends State<InitialRouteHandler> {
  bool _hasNavigated = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        // Handle navigation after auth state changes
        if (_hasNavigated) return;

        if (state is SignInSuccess ||
            state is SignUpSuccess ||
            state is AuthSuccess) {
          _hasNavigated = true;
          // Navigate to maps screen if authenticated
          Navigator.of(context).pushReplacementNamed('/home');
        } else if (state is SignOutSuccess) {
          _hasNavigated = true;
          // Navigate to auth screen if signed out
          Navigator.of(context).pushReplacementNamed('/auth');
        }
      },
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          // Show loading while checking auth state
          if (state is AuthLoading || state is AuthInitial) {
            return const Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Checking authentication...'),
                  ],
                ),
              ),
            );
          }

          // If user is authenticated, show maps screen
          if (state is SignInSuccess ||
              state is SignUpSuccess ||
              state is AuthSuccess) {
            return const MapsScreen();
          }

          // If not authenticated, show auth screen
          return const AuthScreen();
        },
      ),
    );
  }
}
