import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Lanza [UnimplementedError] intencionalmente si se accede sin override,
/// forzando que siempre se inyecte la instancia real desde [main].
final preferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences no ha sido inicializado');
});
