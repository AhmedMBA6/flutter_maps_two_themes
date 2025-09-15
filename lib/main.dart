import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_login_two_themes/app_router.dart';
import 'package:flutter_login_two_themes/constants/themes/app_theme.dart';
import 'package:flutter_login_two_themes/constants/themes/theme_model.dart';
import 'package:flutter_login_two_themes/data_layer/repos/auth/auth_repository.dart';
import 'package:flutter_login_two_themes/logic_layer/auth/auth_cubit.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
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
            // Check current auth state immediately when app starts
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
          title: 'Flutter Login Two Themes',
          theme: themeNotifier.isDark ? AppTheme.dark : AppTheme.light,
          debugShowCheckedModeBanner: false,
          onGenerateRoute: appRouter.generateRoute,
          // Use home as initial route, let the app handle auth state
          initialRoute: '/home',
        ),
      ),
    );
  }
}
