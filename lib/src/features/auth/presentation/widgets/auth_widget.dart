import 'package:desafio_tecnico/src/features/auth/presentation/login_controller.dart';
import 'package:desafio_tecnico/src/features/auth/presentation/screens/login_screen.dart';
import 'package:desafio_tecnico/src/features/tasks/presentation/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AuthWidget extends ConsumerWidget {
  const AuthWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateChangesProvider);

    return authState.when(
      data: (user) => user != null ? const HomeScreen() : const LoginScreen(),
      loading: () => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, stackTrace) => Scaffold(
        body: Center(
          child: Text(error.toString()),
        ),
      ),
    );
  }
}

final authStateChangesProvider = StreamProvider.autoDispose((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges;
});
