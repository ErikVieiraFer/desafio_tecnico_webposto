// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'registration_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$RegistrationStore on _RegistrationStoreBase, Store {
  Computed<bool>? _$isNameValidComputed;

  @override
  bool get isNameValid => (_$isNameValidComputed ??= Computed<bool>(
    () => super.isNameValid,
    name: '_RegistrationStoreBase.isNameValid',
  )).value;
  Computed<bool>? _$isEmailValidComputed;

  @override
  bool get isEmailValid => (_$isEmailValidComputed ??= Computed<bool>(
    () => super.isEmailValid,
    name: '_RegistrationStoreBase.isEmailValid',
  )).value;
  Computed<bool>? _$isPasswordValidComputed;

  @override
  bool get isPasswordValid => (_$isPasswordValidComputed ??= Computed<bool>(
    () => super.isPasswordValid,
    name: '_RegistrationStoreBase.isPasswordValid',
  )).value;
  Computed<bool>? _$isConfirmPasswordValidComputed;

  @override
  bool get isConfirmPasswordValid =>
      (_$isConfirmPasswordValidComputed ??= Computed<bool>(
        () => super.isConfirmPasswordValid,
        name: '_RegistrationStoreBase.isConfirmPasswordValid',
      )).value;
  Computed<bool>? _$isFormValidComputed;

  @override
  bool get isFormValid => (_$isFormValidComputed ??= Computed<bool>(
    () => super.isFormValid,
    name: '_RegistrationStoreBase.isFormValid',
  )).value;

  late final _$nameAtom = Atom(
    name: '_RegistrationStoreBase.name',
    context: context,
  );

  @override
  String get name {
    _$nameAtom.reportRead();
    return super.name;
  }

  @override
  set name(String value) {
    _$nameAtom.reportWrite(value, super.name, () {
      super.name = value;
    });
  }

  late final _$emailAtom = Atom(
    name: '_RegistrationStoreBase.email',
    context: context,
  );

  @override
  String get email {
    _$emailAtom.reportRead();
    return super.email;
  }

  @override
  set email(String value) {
    _$emailAtom.reportWrite(value, super.email, () {
      super.email = value;
    });
  }

  late final _$passwordAtom = Atom(
    name: '_RegistrationStoreBase.password',
    context: context,
  );

  @override
  String get password {
    _$passwordAtom.reportRead();
    return super.password;
  }

  @override
  set password(String value) {
    _$passwordAtom.reportWrite(value, super.password, () {
      super.password = value;
    });
  }

  late final _$confirmPasswordAtom = Atom(
    name: '_RegistrationStoreBase.confirmPassword',
    context: context,
  );

  @override
  String get confirmPassword {
    _$confirmPasswordAtom.reportRead();
    return super.confirmPassword;
  }

  @override
  set confirmPassword(String value) {
    _$confirmPasswordAtom.reportWrite(value, super.confirmPassword, () {
      super.confirmPassword = value;
    });
  }

  late final _$isLoadingAtom = Atom(
    name: '_RegistrationStoreBase.isLoading',
    context: context,
  );

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$errorAtom = Atom(
    name: '_RegistrationStoreBase.error',
    context: context,
  );

  @override
  String? get error {
    _$errorAtom.reportRead();
    return super.error;
  }

  @override
  set error(String? value) {
    _$errorAtom.reportWrite(value, super.error, () {
      super.error = value;
    });
  }

  late final _$isRegistrationSuccessAtom = Atom(
    name: '_RegistrationStoreBase.isRegistrationSuccess',
    context: context,
  );

  @override
  bool get isRegistrationSuccess {
    _$isRegistrationSuccessAtom.reportRead();
    return super.isRegistrationSuccess;
  }

  @override
  set isRegistrationSuccess(bool value) {
    _$isRegistrationSuccessAtom.reportWrite(
      value,
      super.isRegistrationSuccess,
      () {
        super.isRegistrationSuccess = value;
      },
    );
  }

  late final _$registerAsyncAction = AsyncAction(
    '_RegistrationStoreBase.register',
    context: context,
  );

  @override
  Future<void> register() {
    return _$registerAsyncAction.run(() => super.register());
  }

  late final _$_RegistrationStoreBaseActionController = ActionController(
    name: '_RegistrationStoreBase',
    context: context,
  );

  @override
  void setName(String value) {
    final _$actionInfo = _$_RegistrationStoreBaseActionController.startAction(
      name: '_RegistrationStoreBase.setName',
    );
    try {
      return super.setName(value);
    } finally {
      _$_RegistrationStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setEmail(String value) {
    final _$actionInfo = _$_RegistrationStoreBaseActionController.startAction(
      name: '_RegistrationStoreBase.setEmail',
    );
    try {
      return super.setEmail(value);
    } finally {
      _$_RegistrationStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setPassword(String value) {
    final _$actionInfo = _$_RegistrationStoreBaseActionController.startAction(
      name: '_RegistrationStoreBase.setPassword',
    );
    try {
      return super.setPassword(value);
    } finally {
      _$_RegistrationStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setConfirmPassword(String value) {
    final _$actionInfo = _$_RegistrationStoreBaseActionController.startAction(
      name: '_RegistrationStoreBase.setConfirmPassword',
    );
    try {
      return super.setConfirmPassword(value);
    } finally {
      _$_RegistrationStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
name: ${name},
email: ${email},
password: ${password},
confirmPassword: ${confirmPassword},
isLoading: ${isLoading},
error: ${error},
isRegistrationSuccess: ${isRegistrationSuccess},
isNameValid: ${isNameValid},
isEmailValid: ${isEmailValid},
isPasswordValid: ${isPasswordValid},
isConfirmPasswordValid: ${isConfirmPasswordValid},
isFormValid: ${isFormValid}
    ''';
  }
}
