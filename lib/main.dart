import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestor_de_tareas_personales/core/providers/preference_provicer.dart';
import 'package:gestor_de_tareas_personales/core/providers/theme_provider.dart';
import 'package:gestor_de_tareas_personales/screens/home_screen.dart';
import 'package:gestor_de_tareas_personales/theme/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Punto de entrada de la app.
///
/// Se inicializa [SharedPreferences] de forma asíncrona antes de llamar
/// [runApp] porque los providers de tema y tareas lo necesitan desde su primer
/// build. Inyectarlo vía [ProviderScope.overrides] evita que los providers
/// tengan que obtenerlo ellos mismos y facilita los tests unitarios.
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

/// Widget raíz de la aplicación.
///
/// Observa [themeProvider] para aplicar el tema elegido por el usuario en
/// tiempo real sin reconstruir el árbol completo; solo [MaterialApp] se
/// reconstruye cuando cambia el modo.
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
