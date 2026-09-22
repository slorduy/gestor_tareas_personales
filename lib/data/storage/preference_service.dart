import 'dart:convert';

import 'package:gestor_de_tareas_personales/core/models/task_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  /// Siempre reemplaza la lista completa porque [SharedPreferences]
  /// no soporta actualizaciones atómicas por ítem.
  Future<void> saveTaskModels(List<TaskModel> tasks) async {
    final List<Map<String, dynamic>> listaMapas = tasks
        .map((task) => task.toMap())
        .toList();
    final String jsonString = jsonEncode(listaMapas);
    await _prefs.setString(tasksKey, jsonString);
  }

  List<TaskModel> getTaskModels() {
    final String? jsonString = _prefs.getString(tasksKey);
    if (jsonString == null || jsonString.isEmpty) return [];

    final List<dynamic> decodedList = jsonDecode(jsonString);
    return decodedList
        .map((map) => TaskModel.fromMap(map as Map<String, dynamic>))
        .toList();
  }
}
