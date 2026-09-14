import 'package:flutter/material.dart';
import 'package:gestor_de_tareas_personales/core/enums/task_states.dart';
import 'package:gestor_de_tareas_personales/core/models/task.dart';
import 'package:gestor_de_tareas_personales/screens/task_detail_screen.dart';

/// Tarjeta visual que representa una tarea en la lista.
///
/// Las acciones (editar, eliminar, avanzar estado) se exponen como callbacks
/// opcionales para que el widget sea reutilizable en distintos contextos sin
/// acoplarse directamente a ningún provider.
class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onNextState;

  const TaskCard({
    super.key,
    required this.task,
    this.onEdit,
    this.onDelete,
    this.onNextState,
  });

  @override
  Widget build(BuildContext context) {
    final themeColor = Theme.of(context).colorScheme.primary;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => TaskDetailScreen(task: task)),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: themeColor, width: 1),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: IntrinsicHeight(
            child: Row(
              children: [
                // La barra de color izquierda es la señal visual más rápida
                // del estado; el usuario identifica el estado sin leer el tag.
                Container(width: 6, color: task.state.color),
                const SizedBox(width: 16),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Tag de estado con color de fondo semitransparente
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: task.state.color.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            task.state.label,
                            style: TextStyle(
                              color: task.state.color,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          task.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
                // El menú contextual agrupa acciones secundarias para no
                // saturar la card con múltiples botones visibles.
                Padding(
                  padding: const EdgeInsets.only(top: 8, right: 4),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: PopupMenuButton<String>(
                      icon: const Icon(
                        Icons.more_vert,
                        color: Color(0xFF94A3B8),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      onSelected: (value) {
                        if (value == 'edit' && onEdit != null) onEdit!();
                        if (value == 'delete' && onDelete != null) onDelete!();
                        if (value == 'advance-task' && onNextState != null) {
                          onNextState!();
                        }
                      },
                      itemBuilder: (context) => [
                        // La opción de avance solo aparece si la tarea
                        // aún no está completada.
                        if (task.state != TaskStates.completado)
                          const PopupMenuItem(
                            value: 'advance-task',
                            child: Row(
                              children: [
                                Icon(
                                  Icons.arrow_forward_ios_outlined,
                                  size: 20,
                                ),
                                SizedBox(width: 8),
                                Text('Advance Task'),
                              ],
                            ),
                          ),
                        const PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(Icons.edit_outlined, size: 20),
                              SizedBox(width: 8),
                              Text('Edit'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(
                                Icons.delete_outline,
                                color: Colors.red,
                                size: 20,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Delete',
                                style: TextStyle(color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
