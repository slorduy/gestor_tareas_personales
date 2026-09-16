import 'dart:ui';

/// [label] es el texto visible en la UI.
/// [persistedKey] es la clave guardada en disco; se mantiene estable para
/// no romper datos ya almacenados si el [label] cambia en el futuro.
enum TaskStates {
  toDo(label: 'Por hacer', persistedKey: 'to do', color: Color(0xFF64748B)),
  inProcess(
    label: 'En proceso',
    persistedKey: 'in progress',
    color: Color(0xFFF59E0B),
  ),
  done(label: 'Completado', persistedKey: 'done', color: Color(0xFF22C55E));

  final String label;
  final String persistedKey;
  final Color color;

  const TaskStates({
    required this.label,
    required this.persistedKey,
    required this.color,
  });

  /// Acepta [persistedKey], [label] o [name] del enum para tolerar datos
  /// persistidos en formatos distintos. Retorna [toDo] como fallback.
  static TaskStates fromString(String value) {
    return TaskStates.values.firstWhere(
      (e) => e.persistedKey == value || e.label == value || e.name == value,
      orElse: () => TaskStates.toDo,
    );
  }
}
