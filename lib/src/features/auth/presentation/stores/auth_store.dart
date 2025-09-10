import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobx/mobx.dart';
import 'package:desafio_tecnico/src/repositories/auth_repository.dart';
import 'package:desafio_tecnico/src/repositories/auth_exception.dart';
import 'dart:async';

part 'auth_store.g.dart';

class AuthStore = _AuthStoreBase with _$AuthStore;

abstract class _AuthStoreBase with Store {
  final AuthRepository _authRepository;
  StreamSubscription<User?>? _userSubscription;

  _AuthStoreBase(this._authRepository) {
    _userSubscription = _authRepository.authStateChanges.listen((user) {
      print('Auth state changed! User: ${user?.uid}');
      runInAction(() {
        this.user = user;
        isLoading = false;
      });
    });
  }

  @observable
  User? user;

  @observable
  bool isLoading = false;

  @observable
  String? error;

  @action
  Future<void> signIn(String email, String password) async {
    isLoading = true;
    error = null;
    try {
      await _authRepository.signInWithEmailAndPassword(email: email, password: password);
    } on AuthException catch (e) {
      error = e.message;
      throw e;
    } catch (e) {
      error = 'Erro desconhecido: ${e.toString()}';
      throw e;
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> signUp(String email, String password) async {
    isLoading = true;
    error = null;
    try {
      await _authRepository.createUserWithEmailAndPassword(email: email, password: password);
    } on AuthException catch (e) {
      error = e.message;
      throw e;
    } catch (e) {
      error = 'Erro desconhecido: ${e.toString()}';
      throw e;
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> signInWithGoogle() async {
    // This method is not implemented in the current AuthRepository
    // You might need to add it to AuthRepository or remove this call if not needed.
    isLoading = true;
    error = null;
    try {
      // await _authRepository.signInWithGoogle(); // Commented out
      error = 'Login com Google não implementado.';
      throw AuthException('Login com Google não implementado.');
    } on AuthException catch (e) {
      error = e.message;
      throw e;
    } catch (e) {
      error = 'Erro desconhecido: ${e.toString()}';
      throw e;
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> signOut() async {
    isLoading = true;
    error = null;
    try {
      await _authRepository.signOut();
    } on AuthException catch (e) {
      error = e.message;
    } catch (e) {
      error = 'Erro desconhecido ao sair: ${e.toString()}';
    } finally {
      isLoading = false;
    }
  }

  @action
  void dispose() {
    _userSubscription?.cancel();
  }
}
