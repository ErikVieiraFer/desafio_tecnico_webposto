import 'package:desafio_tecnico/src/features/tasks/data/tag_repository.dart';
import 'package:desafio_tecnico/src/features/tasks/data/task_repository.dart';
import 'package:desafio_tecnico/src/features/tasks/presentation/stores/tag_store.dart';
import 'package:desafio_tecnico/src/features/tasks/presentation/stores/task_store.dart';

// Repositories
final tagRepository = TagRepository();
final taskRepository = TaskRepository();

// Stores
final tagStore = TagStore(tagRepository);
final taskStore = TaskStore(taskRepository, tagStore);