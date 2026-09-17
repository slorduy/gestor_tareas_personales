import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestor_de_tareas_personales/presentation/providers/task_selectors.dart';
import 'package:gestor_de_tareas_personales/presentation/providers/tasks_provider.dart';
import 'package:gestor_de_tareas_personales/presentation/providers/theme_provider.dart';
import 'package:gestor_de_tareas_personales/presentation/screens/add_task_screen.dart';
import 'package:gestor_de_tareas_personales/presentation/widgets/task_list_builder.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AddTaskScreen()),
            );
          },
          icon: const Icon(Icons.add),
          label: const Text('Nueva tarea'),
        ),
        appBar: AppBar(
          title: const Text('Mis tareas'),
          actions: [
            IconButton(
              onPressed: () => ref.read(themeProvider.notifier).toggleTheme(),
              icon: Icon(
                themeMode == ThemeMode.light
                    ? Icons.light_mode_outlined
                    : Icons.dark_mode_outlined,
              ),
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.list_alt), text: 'Todos'),
              Tab(icon: Icon(Icons.radio_button_unchecked), text: 'Por hacer'),
              Tab(icon: Icon(Icons.autorenew), text: 'En proceso'),
              Tab(icon: Icon(Icons.check_circle), text: 'Completado'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            TaskListBuilder(tasksList: ref.watch(taskProvider)),
            TaskListBuilder(tasksList: ref.watch(toDoTasksProvider)),
            TaskListBuilder(tasksList: ref.watch(inProgressTasksProvider)),
            TaskListBuilder(tasksList: ref.watch(doneTasksProvider)),
          ],
        ),
      ),
    );
  }
}
