import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_login_two_themes/data_layer/repos/map/maps_repo.dart';
import 'package:flutter_login_two_themes/data_layer/webservices/places_web_services.dart';
import 'package:flutter_login_two_themes/logic_layer/auth/auth_cubit.dart';
import 'package:flutter_login_two_themes/logic_layer/maps/maps_cubit.dart';
import 'package:flutter_login_two_themes/presentation/screens/auth/auth_screen.dart';
import 'package:flutter_login_two_themes/presentation/screens/maps/maps_screen.dart';

import 'data_layer/repos/auth/auth_repository_export.dart';

class AppRouter {
  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/auth':
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
          create: (context) => AuthCubit(
            authRepository: AuthRepository(),
          ),
          child: const AuthScreen(),
        ),
        );
      case '/home':
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => MapsCubit(MapsRepository(PlacesWebServices())),
            child: const MapsScreen(),
          ),
        );
      default:
        return null;
    }
  }
}
