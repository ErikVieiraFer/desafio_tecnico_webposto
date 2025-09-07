import 'package:desafio_tecnico/src/repositories/task_repository.dart';
import 'package:desafio_tecnico/src/features/auth/presentation/widgets/auth_widget.dart';
import 'package:desafio_tecnico/src/features/tasks/domain/task.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  return TaskRepository();
});

final tasksProvider = StreamProvider.autoDispose<List<Task>>((ref) {
  final user = ref.watch(authStateChangesProvider).asData?.value;
  if (user != null) {
    return ref.watch(taskRepositoryProvider).getTasks(user.uid);
  }
  return Stream.value([]);
});
