import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestor_de_tareas_personales/core/enums/task_states.dart';
import 'package:gestor_de_tareas_personales/core/models/task.dart';
import 'package:gestor_de_tareas_personales/core/providers/preference_provicer.dart';
import 'package:gestor_de_tareas_personales/core/storage/preference_service.dart';

/// Gestiona la lista de tareas y su persistencia en [SharedPreferences].
///
/// Cada mutación actualiza primero el [state] en memoria para que la UI
/// reaccione de inmediato y luego llama a [saveTasks] para persistir.
/// Se usa [Notifier] en lugar de [StateNotifier] para tener acceso a [ref]
/// en los métodos sin necesidad de inyectarlo en el constructor.
class TaskNotifier extends Notifier<List<Task>> {
  final _key = PreferencesService.tasksKey;

  /// Carga las tareas guardadas al iniciar. Si no hay datos retorna lista vacía.
  @override
  List<Task> build() {
    final prefs = ref.read(preferencesProvider);
    final String? jsonString = prefs.getString(_key);

    if (jsonString == null || jsonString.isEmpty) return [];

    final List<dynamic> decodedList = json.decode(jsonString);
    return decodedList.map((item) => Task.fromMap(item)).toList();
  }

  /// Agrega una nueva tarea al final de la lista.
  void addNewTask(Task nuevaTarea) {
    state = [...state, nuevaTarea];
    saveTasks();
  }

  /// Reemplaza la tarea cuyo [Task.id] coincida con el de [updatedTask].
  /// El resto de tareas se mantiene sin cambios.
  void updateTask(Task updatedTask) {
    state = state.map((task) {
      return task.id == updatedTask.id ? updatedTask : task;
    }).toList();
    saveTasks();
  }

  /// Elimina la tarea con el [id] dado.
  void deleteTask(String id) {
    state = state.where((task) => task.id != id).toList();
    saveTasks();
  }

  /// Avanza la tarea al siguiente estado del flujo: porHacer → enProceso → completado.
  /// Una tarea ya completada no cambia de estado.
  void advanceTask(String id) {
    state = state.map((task) {
      if (task.id != id) return task;
      final nextState = switch (task.state) {
        TaskStates.porHacer => TaskStates.enProceso,
        TaskStates.enProceso => TaskStates.completado,
        TaskStates.completado => TaskStates.completado,
      };
      return Task(
        id: task.id,
        title: task.title,
        description: task.description,
        state: nextState,
      );
    }).toList();
    saveTasks();
  }

  /// Serializa el estado actual y lo persiste en disco.
  /// Se llama al final de toda operación que modifique la lista.
  void saveTasks() {
    final prefs = ref.read(preferencesProvider);
    final listaMapas = state.map((task) => task.toMap()).toList();
    prefs.setString(_key, json.encode(listaMapas));
  }
}

final taskProvider = NotifierProvider<TaskNotifier, List<Task>>(
  TaskNotifier.new,
);
