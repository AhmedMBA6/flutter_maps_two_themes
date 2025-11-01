// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'package:flutter_login_two_themes/app_router.dart';
import 'package:flutter_login_two_themes/constants/themes/app_theme.dart';
import 'package:flutter_login_two_themes/constants/themes/theme_model.dart';

import 'firebase_options.dart';

late String initialRoute;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseAuth.instance.authStateChanges().listen((user) {
    if (user == null) {
      initialRoute = '/auth';
      
    } else {
      initialRoute = '/home';
    }
  });
  runApp(MyApp(appRouter: AppRouter(),));
}


class MyApp extends StatelessWidget {
  final AppRouter appRouter;

  const MyApp({
    super.key,
    required this.appRouter,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ThemeModel>(
      create: (_) => ThemeModel(),
      child: Consumer<ThemeModel>(
        builder: (context, themeNotifier, _) {
          return MaterialApp(
            theme: themeNotifier.isDark ? AppTheme.dark : AppTheme.light,
            debugShowCheckedModeBanner: false,
            onGenerateRoute: appRouter.generateRoute,
            initialRoute: '/home',//initialRoute,
          );
        },
      ),
    );
  }
}
