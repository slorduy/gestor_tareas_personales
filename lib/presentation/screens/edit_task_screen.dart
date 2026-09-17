import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestor_de_tareas_personales/core/models/task.dart';
import 'package:gestor_de_tareas_personales/presentation/providers/tasks_provider.dart';
import 'package:gestor_de_tareas_personales/presentation/widgets/task_form.dart';

class EditTaskScreen extends ConsumerStatefulWidget {
  final Task task;

  const EditTaskScreen({super.key, required this.task});

  @override
  ConsumerState<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends ConsumerState<EditTaskScreen> {
  @override
  void dispose() {
    super.dispose();
  }

  void _saveChanges(String title, String description) {
    final updatedTask = Task(
      id: widget.task.id,
      title: title,
      description: description,
      state: widget.task.state,
    );

    ref.read(taskProvider.notifier).updateTask(updatedTask);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar tarea')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: TaskForm(
          onSave: _saveChanges,
          buttonLabel: 'Guardar cambios',
          task: widget.task,
        ),
      ),
    );
  }
}
