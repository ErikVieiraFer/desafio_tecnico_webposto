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
      runInAction(() {
        this.user = user;
        isLoading = false;
      });
    });
  }

  @observable
  User? user;

  @observable
  String email = '';

  @observable
  String password = '';

  @observable
  String confirmPassword = '';

  @observable
  String name = '';

  @observable
  bool isLoading = false;

  @observable
  String? error;

  @action
  void setEmail(String value) => email = value.trim();

  @action
  void setPassword(String value) => password = value.trim();

  @action
  void setConfirmPassword(String value) => confirmPassword = value.trim();

  @action
  void setName(String value) => name = value.trim();

  @computed
  bool get isLoginFormValid => email.isNotEmpty && password.isNotEmpty;

  @computed
  bool get isRegistrationFormValid =>
      email.isNotEmpty && password.isNotEmpty && confirmPassword.isNotEmpty && password == confirmPassword && name.isNotEmpty;

  @action
  Future<void> signInWithEmailAndPassword() async {
    if (!isLoginFormValid) return;
    isLoading = true;
    error = null;
    try {
      await _authRepository.signInWithEmailAndPassword(email: email, password: password);
    } on AuthException catch (e) {
      error = e.message;
    } catch (e) {
      error = 'Erro desconhecido: ${e.toString()}';
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<bool> createUserWithEmailAndPassword() async {
    if (!isRegistrationFormValid) {
      error = 'Por favor, preencha todos os campos corretamente.';
      if (password != confirmPassword) {
        error = 'As senhas não coincidem.';
      }
      return false;
    }
    isLoading = true;
    error = null;
    try {
      await _authRepository.createUserWithEmailAndPassword(email: email, password: password, name: name);
      return true;
    } on AuthException catch (e) {
      error = e.message;
      return false;
    } catch (e) {
      error = 'Erro desconhecido: ${e.toString()}';
      return false;
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> signInWithGoogle() async {
    isLoading = true;
    error = null;
    try {
      await _authRepository.signInWithGoogle();
    } on AuthException catch (e) {
      error = e.message;
    } catch (e) {
      error = 'Erro desconhecido: ${e.toString()}';
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
