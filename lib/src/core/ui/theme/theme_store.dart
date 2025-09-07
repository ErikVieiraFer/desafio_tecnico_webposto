import 'package:mobx/mobx.dart';
import 'package:flutter/material.dart';

part 'theme_store.g.dart';

class ThemeStore = _ThemeStoreBase with _$ThemeStore;

abstract class _ThemeStoreBase with Store {
  @observable
  ThemeMode currentThemeMode = ThemeMode.light;

  @action
  void toggleTheme() {
    currentThemeMode = currentThemeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
  }
}
