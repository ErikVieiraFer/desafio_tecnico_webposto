import 'package:desafio_tecnico/src/features/tasks/data/tag_repository.dart';
import 'package:desafio_tecnico/src/features/tasks/presentation/stores/tag_store.dart';
import 'package:desafio_tecnico/src/features/tasks/presentation/stores/task_store.dart';
import 'package:desafio_tecnico/src/repositories/task_repository.dart';

final tagRepository = TagRepository();
final taskRepository = TaskRepository();

final tagStore = TagStore(tagRepository);
final taskStore = TaskStore(taskRepository, tagStore);