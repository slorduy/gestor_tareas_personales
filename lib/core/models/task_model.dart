import 'dart:convert';

import 'package:gestor_de_tareas_personales/core/enums/task_states.dart';

/// Modelo inmutable que representa una tarea personal.
class TaskModel {
  final String id;
  final TaskStates state;
  final String title;
  final String description;

  TaskModel({
    required this.state,
    required this.title,
    required this.description,
    required this.id,
  });

  /// El estado se guarda con [TaskStates.persistedKey] en lugar del [label]
  /// para que los datos en disco no se rompan si el texto visible cambia.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'state': state.persistedKey,
      'description': description,
    };
  }

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      state: TaskStates.fromString(map['state'] ?? ''),
      description: map['description'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory TaskModel.fromJson(String source) =>
      TaskModel.fromMap(json.decode(source));
}
