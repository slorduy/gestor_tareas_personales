import 'dart:convert';

import 'package:gestor_de_tareas_personales/core/enums/task_states.dart';

/// Modelo inmutable que representa una tarea personal.
///
/// Todos los campos son [final] para evitar mutaciones directas; cualquier
/// cambio debe pasar por [TaskNotifier], que reemplaza la instancia completa
/// en el estado. Esto hace que los cambios sean trazables y predecibles.
class Task {
  final String id;
  final TaskStates state;
  final String title;
  final String description;

  Task({
    required this.state,
    required this.title,
    required this.description,
    required this.id,
  });

  /// Convierte la tarea a un mapa para serialización JSON.
  /// El estado se guarda como su [TaskStates.persistedKey] para mantener
  /// compatibilidad con datos ya almacenados, independientemente del
  /// label visible que se muestre en la UI.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'state': state.persistedKey,
      'description': description,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      state: TaskStates.fromString(map['state'] ?? ''),
      description: map['description'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Task.fromJson(String source) => Task.fromMap(json.decode(source));
}
