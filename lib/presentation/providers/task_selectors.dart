import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestor_de_tareas_personales/core/enums/task_states.dart';
import 'package:gestor_de_tareas_personales/core/models/task_model.dart';
import 'package:gestor_de_tareas_personales/presentation/providers/tasks_provider.dart';

final toDoTasksProvider = Provider<List<TaskModel>>((ref) {
  final tasks = ref.watch(taskProvider);
  return tasks.where((t) => t.state == TaskStates.toDo).toList();
});

final inProgressTasksProvider = Provider<List<TaskModel>>((ref) {
  final tasks = ref.watch(taskProvider);
  return tasks.where((t) => t.state == TaskStates.inProcess).toList();
});

final doneTasksProvider = Provider<List<TaskModel>>((ref) {
  final tasks = ref.watch(taskProvider);
  return tasks.where((t) => t.state == TaskStates.done).toList();
});
