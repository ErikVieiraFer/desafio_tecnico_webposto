class AuthException implements Exception {
  final String message;

  AuthException(this.message);

  factory AuthException.fromCode(String code) {
    switch (code) {
      case 'invalid-email':
        return AuthException('O endereço de e-mail é inválido.');
      case 'user-disabled':
        return AuthException('O usuário foi desativado.');
      case 'user-not-found':
        return AuthException('Nenhum usuário encontrado para este e-mail.');
      case 'wrong-password':
        return AuthException('Senha incorreta.');
      case 'email-already-in-use':
        return AuthException('O e-mail já está em uso por outra conta.');
      case 'operation-not-allowed':
        return AuthException('Operação não permitida. Habilite o provedor de e-mail/senha no Firebase.');
      case 'weak-password':
        return AuthException('A senha é muito fraca.');
      default:
        return AuthException('Ocorreu um erro desconhecido. Tente novamente.');
    }
  }

  @override
  String toString() => message;
}