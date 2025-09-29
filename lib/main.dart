import 'package:crypto_portfolio_tracker/features/authentication/views/splash_screen.dart';
import 'package:crypto_portfolio_tracker/shared/app_shared_preferences.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AppSharedPreferences.customSharedPreferences.initPrefs();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: SplashScreen());
  }
}
