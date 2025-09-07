import 'package:desafio_tecnico/src/features/auth/presentation/stores/auth_store.dart';
import 'package:desafio_tecnico/src/repositories/auth_exception.dart';
import 'package:mobx/mobx.dart';

part 'registration_store.g.dart';

class RegistrationStore = _RegistrationStoreBase with _$RegistrationStore;

abstract class _RegistrationStoreBase with Store {
  final AuthStore _authStore;

  _RegistrationStoreBase(this._authStore);

  @observable
  String name = '';

  @observable
  String email = '';

  @observable
  String password = '';

  @observable
  String confirmPassword = '';

  @observable
  bool isLoading = false;

  @observable
  String? error;

  @observable
  bool isRegistrationSuccess = false;

  @action
  void setName(String value) => name = value;

  @action
  void setEmail(String value) => email = value;

  @action
  void setPassword(String value) => password = value;

  @action
  void setConfirmPassword(String value) => confirmPassword = value;

  @computed
  bool get isNameValid => name.isNotEmpty;

  @computed
  bool get isEmailValid => RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
  ).hasMatch(email);

  @computed
  bool get isPasswordValid => password.length >= 6;

  @computed
  bool get isConfirmPasswordValid => password == confirmPassword;

  @computed
  bool get isFormValid =>
      isNameValid && isEmailValid && isPasswordValid && isConfirmPasswordValid;

  @action
  Future<void> register() async {
    if (!isFormValid) {
      error = 'Por favor, preencha todos os campos corretamente.';
      return;
    }
    isLoading = true;
    error = null;
    try {
      await _authStore.signUp(email, password);
      isRegistrationSuccess = true;
    } on AuthException catch (e) {
      error = e.message;
      print('Erro de autenticação: $error');
    } catch (e) {
      error = 'Ocorreu um erro inesperado. Tente novamente.';
      print('Erro no cadastro: $e');
    } finally {
      isLoading = false;
    }
  }
}
