import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'landing_page.dart';
import 'login/login_page.dart';
import 'register/voluntario/register_step1_page.dart';
import 'register/ong/register_ong_step1_page.dart';

void main() {
  runApp(const MyApp());
}

// 1. O Ponto de Partida
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ABC do Bem',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const AppRouter(),
    );
  }
}

// 2. O Roteador Seguro
class AppRouter extends StatelessWidget {
  const AppRouter({super.key});

  @override
  Widget build(BuildContext context) {
    return LandingPage(
      onLogin: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      },
      onRegisterVolunteer: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const RegisterStep1Page()),
        );
      },
      onRegisterOng: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const RegisterOngStep1Page()),
        );
      },
    );
  }
}
