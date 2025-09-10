// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$TaskStore on _TaskStoreBase, Store {
  Computed<List<Task>>? _$filteredTasksComputed;

  @override
  List<Task> get filteredTasks =>
      (_$filteredTasksComputed ??= Computed<List<Task>>(
        () => super.filteredTasks,
        name: '_TaskStoreBase.filteredTasks',
      )).value;
  Computed<List<String>>? _$allTagsComputed;

  @override
  List<String> get allTags => (_$allTagsComputed ??= Computed<List<String>>(
    () => super.allTags,
    name: '_TaskStoreBase.allTags',
  )).value;

  late final _$tasksAtom = Atom(name: '_TaskStoreBase.tasks', context: context);

  @override
  ObservableList<Task> get tasks {
    _$tasksAtom.reportRead();
    return super.tasks;
  }

  @override
  set tasks(ObservableList<Task> value) {
    _$tasksAtom.reportWrite(value, super.tasks, () {
      super.tasks = value;
    });
  }

  late final _$isLoadingAtom = Atom(
    name: '_TaskStoreBase.isLoading',
    context: context,
  );

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$errorAtom = Atom(name: '_TaskStoreBase.error', context: context);

  @override
  String? get error {
    _$errorAtom.reportRead();
    return super.error;
  }

  @override
  set error(String? value) {
    _$errorAtom.reportWrite(value, super.error, () {
      super.error = value;
    });
  }

  late final _$selectedTagAtom = Atom(
    name: '_TaskStoreBase.selectedTag',
    context: context,
  );

  @override
  String? get selectedTag {
    _$selectedTagAtom.reportRead();
    return super.selectedTag;
  }

  @override
  set selectedTag(String? value) {
    _$selectedTagAtom.reportWrite(value, super.selectedTag, () {
      super.selectedTag = value;
    });
  }

  late final _$dateFilterAtom = Atom(
    name: '_TaskStoreBase.dateFilter',
    context: context,
  );

  @override
  DateTimeRange<DateTime>? get dateFilter {
    _$dateFilterAtom.reportRead();
    return super.dateFilter;
  }

  @override
  set dateFilter(DateTimeRange<DateTime>? value) {
    _$dateFilterAtom.reportWrite(value, super.dateFilter, () {
      super.dateFilter = value;
    });
  }

  late final _$fetchTasksAsyncAction = AsyncAction(
    '_TaskStoreBase.fetchTasks',
    context: context,
  );

  @override
  Future<void> fetchTasks(String userId) {
    return _$fetchTasksAsyncAction.run(() => super.fetchTasks(userId));
  }

  late final _$addTaskAsyncAction = AsyncAction(
    '_TaskStoreBase.addTask',
    context: context,
  );

  @override
  Future<void> addTask(String userId, Task task) {
    return _$addTaskAsyncAction.run(() => super.addTask(userId, task));
  }

  late final _$updateTaskAsyncAction = AsyncAction(
    '_TaskStoreBase.updateTask',
    context: context,
  );

  @override
  Future<void> updateTask(String userId, Task task) {
    return _$updateTaskAsyncAction.run(() => super.updateTask(userId, task));
  }

  late final _$deleteTaskAsyncAction = AsyncAction(
    '_TaskStoreBase.deleteTask',
    context: context,
  );

  @override
  Future<void> deleteTask(String userId, String taskId) {
    return _$deleteTaskAsyncAction.run(() => super.deleteTask(userId, taskId));
  }

  late final _$_TaskStoreBaseActionController = ActionController(
    name: '_TaskStoreBase',
    context: context,
  );

  @override
  void setTagFilter(String? tag) {
    final _$actionInfo = _$_TaskStoreBaseActionController.startAction(
      name: '_TaskStoreBase.setTagFilter',
    );
    try {
      return super.setTagFilter(tag);
    } finally {
      _$_TaskStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setDateFilter(DateTimeRange<DateTime>? range) {
    final _$actionInfo = _$_TaskStoreBaseActionController.startAction(
      name: '_TaskStoreBase.setDateFilter',
    );
    try {
      return super.setDateFilter(range);
    } finally {
      _$_TaskStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void dispose() {
    final _$actionInfo = _$_TaskStoreBaseActionController.startAction(
      name: '_TaskStoreBase.dispose',
    );
    try {
      return super.dispose();
    } finally {
      _$_TaskStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
tasks: ${tasks},
isLoading: ${isLoading},
error: ${error},
selectedTag: ${selectedTag},
dateFilter: ${dateFilter},
filteredTasks: ${filteredTasks},
allTags: ${allTags}
    ''';
  }
}
