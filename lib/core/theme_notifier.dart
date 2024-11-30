import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeNotifier extends ValueNotifier<ThemeMode> {
  final SharedPreferences _prefs;
  ThemeNotifier(this._prefs) : super(_prefs.getTheme());

  set theme(ThemeMode theme) {
    unawaited(_prefs.setTheme(theme));
    super.value = theme;
  }
}

extension ThemeNotifierExtensions on SharedPreferences {
  ThemeMode getTheme() {
    final theme = getString('theme');
    return switch (theme) {
      "light" => ThemeMode.light,
      "dark" => ThemeMode.dark,
      "system" => ThemeMode.system,
      _ => ThemeMode.system,
    };
  }

  Future<void> setTheme(ThemeMode theme) async {
    await setString('theme', theme.name);
  }
}