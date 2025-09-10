// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kanban_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$KanbanStore on _KanbanStore, Store {
  late final _$kanbanListsAtom = Atom(
    name: '_KanbanStore.kanbanLists',
    context: context,
  );

  @override
  ObservableList<KanbanList> get kanbanLists {
    _$kanbanListsAtom.reportRead();
    return super.kanbanLists;
  }

  @override
  set kanbanLists(ObservableList<KanbanList> value) {
    _$kanbanListsAtom.reportWrite(value, super.kanbanLists, () {
      super.kanbanLists = value;
    });
  }

  late final _$isLoadingAtom = Atom(
    name: '_KanbanStore.isLoading',
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

  late final _$loadKanbanListsAsyncAction = AsyncAction(
    '_KanbanStore.loadKanbanLists',
    context: context,
  );

  @override
  Future<void> loadKanbanLists() {
    return _$loadKanbanListsAsyncAction.run(() => super.loadKanbanLists());
  }

  late final _$_createDefaultKanbanListAsyncAction = AsyncAction(
    '_KanbanStore._createDefaultKanbanList',
    context: context,
  );

  @override
  Future<void> _createDefaultKanbanList(String userId) {
    return _$_createDefaultKanbanListAsyncAction.run(
      () => super._createDefaultKanbanList(userId),
    );
  }

  late final _$addKanbanListAsyncAction = AsyncAction(
    '_KanbanStore.addKanbanList',
    context: context,
  );

  @override
  Future<void> addKanbanList(String name) {
    return _$addKanbanListAsyncAction.run(() => super.addKanbanList(name));
  }

  late final _$updateKanbanListAsyncAction = AsyncAction(
    '_KanbanStore.updateKanbanList',
    context: context,
  );

  @override
  Future<void> updateKanbanList(KanbanList list) {
    return _$updateKanbanListAsyncAction.run(
      () => super.updateKanbanList(list),
    );
  }

  late final _$deleteKanbanListAsyncAction = AsyncAction(
    '_KanbanStore.deleteKanbanList',
    context: context,
  );

  @override
  Future<void> deleteKanbanList(String listId) {
    return _$deleteKanbanListAsyncAction.run(
      () => super.deleteKanbanList(listId),
    );
  }

  late final _$reorderKanbanListsAsyncAction = AsyncAction(
    '_KanbanStore.reorderKanbanLists',
    context: context,
  );

  @override
  Future<void> reorderKanbanLists(int oldIndex, int newIndex) {
    return _$reorderKanbanListsAsyncAction.run(
      () => super.reorderKanbanLists(oldIndex, newIndex),
    );
  }

  late final _$moveTaskBetweenKanbanListsAsyncAction = AsyncAction(
    '_KanbanStore.moveTaskBetweenKanbanLists',
    context: context,
  );

  @override
  Future<void> moveTaskBetweenKanbanLists(
    String taskId,
    String oldListId,
    String newListId,
  ) {
    return _$moveTaskBetweenKanbanListsAsyncAction.run(
      () => super.moveTaskBetweenKanbanLists(taskId, oldListId, newListId),
    );
  }

  @override
  String toString() {
    return '''
kanbanLists: ${kanbanLists},
isLoading: ${isLoading}
    ''';
  }
}
