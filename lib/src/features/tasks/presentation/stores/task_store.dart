import 'package:desafio_tecnico/src/features/tasks/data/task_repository.dart';
import 'package:desafio_tecnico/src/features/tasks/domain/tag.dart';
import 'package:desafio_tecnico/src/features/tasks/domain/task.dart';
import 'package:desafio_tecnico/src/features/tasks/presentation/stores/tag_store.dart';
import 'package:mobx/mobx.dart';
import 'dart:async';
import 'package:rxdart/rxdart.dart';

part 'task_store.g.dart';

class TaskStore = _TaskStoreBase with _$TaskStore;

abstract class _TaskStoreBase with Store {
  final TaskRepository _taskRepository;
  final TagStore _tagStore;
  StreamSubscription<List<Task>>? _tasksSubscription;

  _TaskStoreBase(this._taskRepository, this._tagStore);

  @observable
  ObservableList<Task> tasks = ObservableList<Task>();

  @observable
  bool isLoading = false;

  @observable
  String? error;

  @observable
  String? selectedTag;

  @computed
  List<Task> get filteredTasks {
    if (selectedTag == null || selectedTag!.isEmpty) {
      return tasks;
    }
    return tasks
        .where((task) => task.tags.any((tag) => tag.name == selectedTag))
        .toList();
  }

  @computed
  List<String> get allTags {
    final tags = <String>{};
    for (var task in tasks) {
      tags.addAll(task.tags.map((t) => t.name));
    }
    return tags.toList()..sort();
  }

  @action
  void setTagFilter(String? tag) {
    selectedTag = tag;
  }

  @action
  Future<void> fetchTasks(String userId) async {
    isLoading = true;
    error = null;
    _tasksSubscription?.cancel();

    final tasksStream = _taskRepository.getTasks(userId);
    final tagsStream = _tagStore.tagsStream(userId);

    _tasksSubscription = Rx.combineLatest2(
      tasksStream,
      tagsStream,
      (List<Task> taskList, List<Tag> tagList) {
        // Cria um mapa de tags para busca rápida
        final tagMap = {for (var tag in tagList) tag.id: tag};

        for (var task in taskList) {
          task.tags = task.tagIds
              .map((tagId) => tagMap[tagId]) // Busca a tag no mapa
              .whereType<Tag>() // Filtra os nulos de forma segura
              .toList();
        }
        return taskList;
      },
    ).listen(
      (populatedTasks) {
        runInAction(() {
          tasks = ObservableList.of(populatedTasks);
          isLoading = false;
        });
      },
      onError: (e) {
        runInAction(() {
          error = e.toString();
          isLoading = false;
        });
      },
    );
  }

  @action
  Future<void> addTask(String userId, Task task) async {
    try {
      await _taskRepository.addTask(userId, task);
    } catch (e) {
      error = e.toString();
    }
  }

  @action
  Future<void> updateTask(String userId, Task task) async {
    try {
      await _taskRepository.updateTask(userId, task);
    } catch (e) {
      error = e.toString();
    }
  }

  @action
  Future<void> deleteTask(String userId, String taskId) async {
    try {
      await _taskRepository.deleteTask(userId, taskId);
    } catch (e) {
      error = e.toString();
    }
  }

  @action
  void dispose() {
    _tasksSubscription?.cancel();
  }
}
