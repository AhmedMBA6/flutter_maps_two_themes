import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_login_two_themes/app_router.dart';
import 'package:flutter_login_two_themes/constants/themes/app_theme.dart';
import 'package:flutter_login_two_themes/constants/themes/theme_model.dart';
import 'package:flutter_login_two_themes/data_layer/repos/auth/auth_repository.dart';
import 'package:flutter_login_two_themes/logic_layer/auth/auth_cubit.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp(
    appRouter: AppRouter(),
  ));
}

class MyApp extends StatelessWidget {
  final AppRouter appRouter;
  const MyApp({super.key, required this.appRouter});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (context) {
            final authCubit = AuthCubit(
              authRepository: AuthRepository(),
            );
            // Check current auth state when app starts
            authCubit.checkInitialAuthState();
            return authCubit;
          },
        ),
        ChangeNotifierProvider<ThemeModel>(
          create: (_) => ThemeModel(),
        ),
      ],
      child: Consumer<ThemeModel>(
          builder: (context, ThemeModel themeNotifier, child) => MaterialApp(
                theme: themeNotifier.isDark ? AppTheme.dark : AppTheme.light,
                debugShowCheckedModeBanner: false,
                onGenerateRoute: appRouter.generateRoute,
              )),
    );
  }
}
