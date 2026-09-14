import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestor_de_tareas_personales/core/enums/task_states.dart';
import 'package:gestor_de_tareas_personales/core/models/task.dart';
import 'package:gestor_de_tareas_personales/core/providers/tasks_provider.dart';
import 'package:gestor_de_tareas_personales/core/providers/theme_provider.dart';
import 'package:gestor_de_tareas_personales/screens/add_task_screen.dart';
import 'package:gestor_de_tareas_personales/screens/edit_task_screen.dart';
import 'package:gestor_de_tareas_personales/widgets/task_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  void _confirmDelete(BuildContext context, WidgetRef ref, Task task) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete task'),
        content: Text('Are you sure you want to delete "${task.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref.read(taskProvider.notifier).deleteTask(task.id);
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final tasks = ref.watch(taskProvider);

    final toDoTasks = tasks
        .where((t) => t.state == TaskStates.porHacer)
        .toList();
    final inProgressTasks = tasks
        .where((t) => t.state == TaskStates.enProceso)
        .toList();
    final doneTasks = tasks
        .where((t) => t.state == TaskStates.completado)
        .toList();

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
          label: const Text('New Task'),
        ),
        appBar: AppBar(
          title: const Text('Task Manager'),
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
              Tab(icon: Icon(Icons.list_alt), text: 'All'),
              Tab(icon: Icon(Icons.radio_button_unchecked), text: 'To Do'),
              Tab(icon: Icon(Icons.autorenew), text: 'In progress'),
              Tab(icon: Icon(Icons.check_circle), text: 'Done'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _TaskList(
              tasks: tasks,
              onNextState: (id) =>
                  ref.read(taskProvider.notifier).advanceTask(id),
              onEdit: (task) => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => EditTaskScreen(task: task)),
              ),
              onDelete: (task) => _confirmDelete(context, ref, task),
            ),
            _TaskList(
              tasks: toDoTasks,
              emptyMessage: 'No tasks to do',
              onNextState: (id) =>
                  ref.read(taskProvider.notifier).advanceTask(id),
              onEdit: (task) => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => EditTaskScreen(task: task)),
              ),
              onDelete: (task) => _confirmDelete(context, ref, task),
            ),
            _TaskList(
              tasks: inProgressTasks,
              emptyMessage: 'No tasks in progress',
              onNextState: (id) =>
                  ref.read(taskProvider.notifier).advanceTask(id),
              onEdit: (task) => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => EditTaskScreen(task: task)),
              ),
              onDelete: (task) => _confirmDelete(context, ref, task),
            ),
            _TaskList(
              tasks: doneTasks,
              emptyMessage: 'No completed tasks',
              onNextState: (id) =>
                  ref.read(taskProvider.notifier).advanceTask(id),
              onEdit: (task) => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => EditTaskScreen(task: task)),
              ),
              onDelete: (task) => _confirmDelete(context, ref, task),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget privado reutilizable para cada tab
class _TaskList extends StatelessWidget {
  final List<Task> tasks;
  final String emptyMessage;
  final void Function(String id) onNextState;
  final void Function(Task task) onEdit;
  final void Function(Task task) onDelete;

  const _TaskList({
    required this.tasks,
    required this.onNextState,
    required this.onEdit,
    required this.onDelete,
    this.emptyMessage = 'No tasks yet',
  });

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.checklist_rounded,
              size: 64,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 12),
            Text(
              emptyMessage,
              style: TextStyle(fontSize: 16, color: Colors.grey.shade400),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return TaskCard(
          task: task,
          onNextState: () => onNextState(task.id),
          onEdit: () => onEdit(task),
          onDelete: () => onDelete(task),
        );
      },
    );
  }
}
