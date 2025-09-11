
import 'package:desafio_tecnico/main.dart';
import 'package:desafio_tecnico/src/features/auth/presentation/screens/login_screen.dart';
import 'package:desafio_tecnico/src/features/tasks/presentation/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        if (authStore.user != null) {
          return const HomeScreen();
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}
