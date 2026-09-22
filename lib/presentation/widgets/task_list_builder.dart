import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestor_de_tareas_personales/core/models/task_model.dart';
import 'package:gestor_de_tareas_personales/presentation/providers/tasks_provider.dart';
import 'package:gestor_de_tareas_personales/presentation/screens/edit_task_screen.dart';
import 'package:gestor_de_tareas_personales/presentation/widgets/delete_task_dialog.dart';
import 'package:gestor_de_tareas_personales/presentation/widgets/task_list.dart';

class TaskListBuilder extends ConsumerWidget {
  const TaskListBuilder({super.key, required this.tasksList});

  final List<TaskModel> tasksList;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TaskList(
      tasks: tasksList,
      onNextState: (id) => ref.read(taskProvider.notifier).advanceTask(id),
      onEdit: (TaskModel task) => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => EditTaskScreen(task: task)),
      ),
      onDelete: (TaskModel task) => confirmDelete(
        context,
        ref,
        'Eliminar tarea',
        '¿Estás seguro de que deseas eliminar "${task.title}"?',
        () {
          ref.read(taskProvider.notifier).deleteTask(task.id);
          Navigator.pop(context);
        },
      ),
    );
  }
}
