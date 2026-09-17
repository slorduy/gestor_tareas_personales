import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestor_de_tareas_personales/presentation/providers/tasks_provider.dart';
import 'package:gestor_de_tareas_personales/presentation/widgets/task_form.dart';

class AddTaskScreen extends ConsumerWidget {
  const AddTaskScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nueva tarea')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: TaskForm(
          onSave: (title, description) {
            ref
                .read(taskProvider.notifier)
                .createAndSaveTask(title: title, description: description);
            Navigator.pop(context);
          },
          buttonLabel: 'Guardar tarea',
        ),
      ),
    );
  }
}
