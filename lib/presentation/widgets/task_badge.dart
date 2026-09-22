import 'package:flutter/material.dart';
import 'package:gestor_de_tareas_personales/core/models/task_model.dart';

class TaskBadge extends StatelessWidget {
  final TaskModel task;
  const TaskBadge({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: task.state.color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        task.state.label,
        style: TextStyle(
          color: task.state.color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
