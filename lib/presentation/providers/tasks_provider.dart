import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestor_de_tareas_personales/core/enums/task_states.dart';
import 'package:gestor_de_tareas_personales/core/models/task.dart';
import 'package:gestor_de_tareas_personales/data/repositories/task_repository.dart';
import 'package:gestor_de_tareas_personales/presentation/providers/task_repository_provider.dart';

class TaskNotifier extends Notifier<List<Task>> {
  late final TaskRepository _repository;

  @override
  List<Task> build() {
    _repository = ref.read(taskRepositoryProvider);
    return _repository.getTasks();
  }

  /// Delega la creación del objeto [Task] al repositorio para centralizar
  /// la lógica de ID y estado inicial en una sola capa.
  void createAndSaveTask({required String title, required String description}) {
    final newTask = _repository.buildNewTask(
      title: title,
      description: description,
    );

    state = [...state, newTask];
    _repository.saveTasks(state);
  }

  void updateTask(Task updatedTask) {
    state = state.map((task) {
      return task.id == updatedTask.id ? updatedTask : task;
    }).toList();
    _repository.saveTasks(state);
  }

  void deleteTask(String id) {
    state = state.where((task) => task.id != id).toList();
    _repository.saveTasks(state);
  }

  void advanceTask(String id) {
    state = state.map((task) {
      if (task.id != id) return task;
      final nextState = switch (task.state) {
        TaskStates.toDo => TaskStates.inProcess,
        TaskStates.inProcess => TaskStates.done,
        TaskStates.done => TaskStates.done,
      };
      return Task(
        id: task.id,
        title: task.title,
        description: task.description,
        state: nextState,
      );
    }).toList();
    _repository.saveTasks(state);
  }
}

final taskProvider = NotifierProvider<TaskNotifier, List<Task>>(
  TaskNotifier.new,
);
