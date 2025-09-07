import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:desafio_tecnico/src/repositories/auth_repository.dart';
import 'package:desafio_tecnico/src/features/auth/presentation/login_controller.dart';

class RegistrationController extends StateNotifier<AsyncValue<void>> {
  final AuthRepository _authRepository;

  RegistrationController(this._authRepository)
    : super(const AsyncValue.data(null));

  Future<void> register(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      await _authRepository.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      state = const AsyncValue.data(null);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
  }
}

final registrationControllerProvider =
    StateNotifierProvider<RegistrationController, AsyncValue<void>>((ref) {
      return RegistrationController(ref.watch(authRepositoryProvider));
    });
