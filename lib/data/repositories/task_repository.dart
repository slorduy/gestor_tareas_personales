import 'dart:convert';

import 'package:gestor_de_tareas_personales/core/enums/task_states.dart';
import 'package:gestor_de_tareas_personales/core/models/task_model.dart';
import 'package:gestor_de_tareas_personales/data/storage/preference_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class TaskRepository {
  final SharedPreferences _prefs;
  final String _key = PreferencesService.tasksKey;

  TaskRepository(this._prefs);

  /// Carga las tareas desde el almacenamiento local.
  List<TaskModel> getTasks() {
    final String? jsonString = _prefs.getString(_key);
    if (jsonString == null || jsonString.isEmpty) return [];

    final List<dynamic> decodedList = json.decode(jsonString);
    return decodedList.map((item) => TaskModel.fromMap(item)).toList();
  }

  void saveTasks(List<TaskModel> tasks) async {
    final listaMapas = tasks.map((task) => task.toMap()).toList();
    await _prefs.setString(_key, json.encode(listaMapas));
  }

  TaskModel buildNewTask({required String title, required String description}) {
    return TaskModel(
      id: const Uuid().v4(),
      title: title,
      description: description,
      state: TaskStates.toDo,
    );
  }
}
