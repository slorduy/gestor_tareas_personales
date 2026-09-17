import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestor_de_tareas_personales/data/storage/preference_service.dart';
import 'package:gestor_de_tareas_personales/presentation/providers/preference_provider.dart';

class ThemeNotifier extends Notifier<ThemeMode> {
  final String _themeKey = PreferencesService.themeKey;

  @override
  ThemeMode build() {
    final prefs = ref.read(preferencesProvider);
    final savedTheme = prefs.getString(_themeKey);

    if (savedTheme == 'dark') return ThemeMode.dark;
    if (savedTheme == 'light') return ThemeMode.light;
    return ThemeMode.system;
  }

  void toggleTheme() {
    final prefs = ref.read(preferencesProvider);

    if (state == ThemeMode.light) {
      state = ThemeMode.dark;
      prefs.setString(_themeKey, 'dark');
    } else {
      state = ThemeMode.light;
      prefs.setString(_themeKey, 'light');
    }
  }
}

final themeProvider = NotifierProvider<ThemeNotifier, ThemeMode>(
  ThemeNotifier.new,
);
