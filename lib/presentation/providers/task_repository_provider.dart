import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestor_de_tareas_personales/data/repositories/task_repository.dart';
import 'package:gestor_de_tareas_personales/presentation/providers/preference_provider.dart';

final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  final prefs = ref.watch(preferencesProvider);
  return TaskRepository(prefs);
});
