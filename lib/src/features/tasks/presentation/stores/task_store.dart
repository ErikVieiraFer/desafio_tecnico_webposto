import 'package:desafio_tecnico/src/features/tasks/domain/task.dart';
import 'package:desafio_tecnico/src/features/tasks/data/task_repository.dart';
import 'package:mobx/mobx.dart';
import 'dart:async'; // Importar para StreamSubscription

part 'task_store.g.dart';

class TaskStore = _TaskStoreBase with _$TaskStore;

abstract class _TaskStoreBase with Store {
  final TaskRepository _taskRepository;
  StreamSubscription<List<Task>>? _tasksSubscription;

  _TaskStoreBase(this._taskRepository);

  @observable
  ObservableList<Task> tasks = ObservableList<Task>();

  @observable
  bool isLoading = false;

  @observable
  String? error;

  @action
  Future<void> fetchTasks(String userId) async {
    isLoading = true;
    error = null;
    _tasksSubscription?.cancel(); // Cancela a inscrição anterior, se houver

    try {
      _tasksSubscription = _taskRepository.getTasks(userId).listen(
        (taskList) {
          runInAction(() {
            tasks = ObservableList.of(taskList);
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
    } catch (e) {
      runInAction(() {
        error = e.toString();
        isLoading = false;
      });
    }
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

  // M_étodo para limpar a inscrição quando a store n_ão for mais necess_ária
  @action
  void dispose() {
    _tasksSubscription?.cancel();
  }
}