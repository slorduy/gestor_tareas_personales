import 'dart:ui';

/// Define los tres estados posibles de una tarea y sus atributos visuales.
///
/// Asociar el color directamente al enum evita lógicas de mapeo dispersas
/// en la UI; cualquier widget puede usar [TaskStates.color] sin condiciones.
///
/// [label] es el texto visible en la UI.
/// [persistedKey] es el valor guardado en disco; se mantiene estable para
/// no romper datos ya almacenados en versiones anteriores de la app.
enum TaskStates {
  porHacer(label: 'To Do', persistedKey: 'por hacer', color: Color(0xFF64748B)),
  enProceso(
    label: 'In Progress',
    persistedKey: 'en proceso',
    color: Color(0xFFF59E0B),
  ),
  completado(
    label: 'Done',
    persistedKey: 'completado',
    color: Color(0xFF22C55E),
  );

  final String label;
  final String persistedKey;
  final Color color;

  const TaskStates({
    required this.label,
    required this.persistedKey,
    required this.color,
  });

  /// Reconstruye un [TaskStates] desde un string guardado en disco.
  /// Acepta [persistedKey], [label] o el [name] del enum para
  /// tolerar datos persistidos con formatos distintos.
  /// Si el valor no coincide con ninguno, retorna [porHacer] como fallback.
  static TaskStates fromString(String value) {
    return TaskStates.values.firstWhere(
      (e) => e.persistedKey == value || e.label == value || e.name == value,
      orElse: () => TaskStates.porHacer,
    );
  }
}
