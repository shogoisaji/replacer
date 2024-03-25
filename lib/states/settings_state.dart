import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'settings_state.g.dart';

@Riverpod(keepAlive: true)
class SettingsState extends _$SettingsState {
  @override
  Settings build() => Settings(themeMode: ThemeMode.light);

  void changeToDarkMode() => state = Settings(themeMode: ThemeMode.dark);

  void changeToLightMode() => state = Settings(themeMode: ThemeMode.light);
}

class Settings {
  final ThemeMode themeMode;

  Settings({required this.themeMode});
}
