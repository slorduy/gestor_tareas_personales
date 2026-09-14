import 'dart:convert';

import 'package:gestor_de_tareas_personales/core/models/task.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Abstrae el acceso a [SharedPreferences] para tareas y preferencias de UI.
///
/// Centralizar las claves como constantes estáticas previene errores de
/// tipeo y permite que los providers las referencien sin instanciar la clase.
class PreferencesService {
  PreferencesService(this._prefs);

  final SharedPreferences _prefs;

  static const String themeKey = 'theme';
  static const String tasksKey = 'tasks';

  Future<void> setTheme(String theme) async {
    await _prefs.setString(themeKey, theme);
  }

  String? getTheme() {
    return _prefs.getString(themeKey);
  }

  /// Serializa la lista completa de tareas a JSON y la guarda.
  /// Reemplaza siempre la entrada entera; no hay operaciones parciales
  /// porque [SharedPreferences] no soporta actualizaciones atómicas por ítem.
  Future<void> guardarTareas(List<Task> tasks) async {
    final List<Map<String, dynamic>> listaMapas = tasks
        .map((task) => task.toMap())
        .toList();
    final String jsonString = jsonEncode(listaMapas);
    await _prefs.setString(tasksKey, jsonString);
  }

  /// Carga y deserializa las tareas guardadas.
  /// Retorna lista vacía si no hay datos, en lugar de null,
  /// para que los consumidores no necesiten manejar nulabilidad.
  List<Task> obtenerTareas() {
    final String? jsonString = _prefs.getString(tasksKey);

    if (jsonString == null || jsonString.isEmpty) return [];

    final List<dynamic> decodedList = jsonDecode(jsonString);
    return decodedList
        .map((map) => Task.fromMap(map as Map<String, dynamic>))
        .toList();
  }
}
