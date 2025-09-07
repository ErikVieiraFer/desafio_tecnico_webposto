import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:desafio_tecnico/src/repositories/auth_repository.dart';

class LoginController extends StateNotifier<AsyncValue<void>> {
  final AuthRepository _authRepository;

  LoginController(this._authRepository) : super(const AsyncValue.data(null));

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      await _authRepository.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      state = const AsyncValue.data(null);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
  }
}

final loginControllerProvider =
    StateNotifierProvider<LoginController, AsyncValue<void>>((ref) {
      return LoginController(ref.watch(authRepositoryProvider));
    });

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});
