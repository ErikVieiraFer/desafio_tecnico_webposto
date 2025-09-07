import 'package:desafio_tecnico/src/features/auth/presentation/stores/auth_store.dart';
import 'package:desafio_tecnico/src/repositories/auth_exception.dart';
import 'package:mobx/mobx.dart';

part 'login_store.g.dart';

class LoginStore = _LoginStoreBase with _$LoginStore;

abstract class _LoginStoreBase with Store {
  final AuthStore _authStore;

  _LoginStoreBase(this._authStore);

  @observable
  String email = '';

  @observable
  String password = '';

  @observable
  bool isLoading = false;

  @observable
  String? error;

  @action
  void setEmail(String value) => email = value;

  @action
  void setPassword(String value) => password = value;

  @computed
  bool get isEmailValid => RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
  ).hasMatch(email);

  @computed
  bool get isPasswordValid => password.length >= 6;

  @computed
  bool get isFormValid => isEmailValid && isPasswordValid;

  @action
  Future<void> login() async {
    if (!isFormValid) {
      error = 'Por favor, preencha os campos corretamente.';
      return;
    }
    isLoading = true;
    error = null;
    try {
      await _authStore.signIn(email, password);
    } on AuthException catch (e) {
      error = e.message;
      print('Erro de autenticação: $error');
    } catch (e) {
      error = 'Ocorreu um erro inesperado. Tente novamente.';
      print('Erro no login: $e');
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> loginWithGoogle() async {
    isLoading = true;
    error = null;
    try {
      await _authStore.signInWithGoogle();
    } on AuthException catch (e) {
      error = e.message;
      print('Erro de autenticação com Google: $error');
    } catch (e) {
      error = 'Ocorreu um erro inesperado. Tente novamente.';
      print('Erro no login com Google: $e');
    } finally {
      isLoading = false;
    }
  }
}
