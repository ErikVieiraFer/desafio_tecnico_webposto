// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ThemeStore on _ThemeStoreBase, Store {
  late final _$currentThemeModeAtom = Atom(
    name: '_ThemeStoreBase.currentThemeMode',
    context: context,
  );

  @override
  ThemeMode get currentThemeMode {
    _$currentThemeModeAtom.reportRead();
    return super.currentThemeMode;
  }

  @override
  set currentThemeMode(ThemeMode value) {
    _$currentThemeModeAtom.reportWrite(value, super.currentThemeMode, () {
      super.currentThemeMode = value;
    });
  }

  late final _$_ThemeStoreBaseActionController = ActionController(
    name: '_ThemeStoreBase',
    context: context,
  );

  @override
  void toggleTheme() {
    final _$actionInfo = _$_ThemeStoreBaseActionController.startAction(
      name: '_ThemeStoreBase.toggleTheme',
    );
    try {
      return super.toggleTheme();
    } finally {
      _$_ThemeStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
currentThemeMode: ${currentThemeMode}
    ''';
  }
}
