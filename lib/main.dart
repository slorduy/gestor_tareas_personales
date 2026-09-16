import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestor_de_tareas_personales/presentation/providers/preference_provider.dart';
import 'package:gestor_de_tareas_personales/presentation/providers/theme_provider.dart';
import 'package:gestor_de_tareas_personales/presentation/screens/home_screen.dart';
import 'package:gestor_de_tareas_personales/presentation/theme/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Punto de entrada de la app.
///
/// [SharedPreferences] se inicializa antes de [runApp] porque los providers
/// lo necesitan desde su primer build. Inyectarlo vía [ProviderScope.overrides]
/// desacopla los providers del acceso directo a disco.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [preferencesProvider.overrideWithValue(prefs)],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      home: const HomeScreen(),
    );
  }
}
