import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Proveedor de la instancia global de [SharedPreferences].
///
/// Lanza [UnimplementedError] intencionalmente si se accede sin override,
/// garantizando que siempre se inyecte la instancia real desde [main] antes
/// de que cualquier provider dependiente intente usarla.
final preferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences no ha sido inicializado');
});
