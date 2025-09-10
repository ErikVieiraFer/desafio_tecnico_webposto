import 'dart:async';
import 'package:mobx/mobx.dart';
import 'package:desafio_tecnico/src/features/kanban/data/models/kanban_list.dart';
import 'package:desafio_tecnico/src/repositories/kanban_list_repository.dart';
import 'package:desafio_tecnico/src/repositories/auth_repository.dart';

part 'kanban_store.g.dart';

class KanbanStore = _KanbanStore with _$KanbanStore;

abstract class _KanbanStore with Store {
  final KanbanListRepository _kanbanListRepository;
  final AuthRepository _authRepository;

  StreamSubscription<List<KanbanList>>? _kanbanListsSubscription;
  Completer<void>? _listsLoadedCompleter;

  _KanbanStore(this._kanbanListRepository, this._authRepository);

  @observable
  ObservableList<KanbanList> kanbanLists = ObservableList<KanbanList>();

  @observable
  bool isLoading = false;

  @action
  Future<void> loadKanbanLists() {
    if (_listsLoadedCompleter != null && !_listsLoadedCompleter!.isCompleted) {
      return _listsLoadedCompleter!.future;
    }
    _listsLoadedCompleter = Completer<void>();

    final userId = _authRepository.currentUser?.uid;
    if (userId == null) {
      isLoading = false;
      _listsLoadedCompleter!.complete();
      return _listsLoadedCompleter!.future;
    }

    isLoading = true;
    _kanbanListsSubscription?.cancel();
    _kanbanListsSubscription =
        _kanbanListRepository.getKanbanLists(userId).listen((lists) {
      runInAction(() {
        if (lists.isEmpty && kanbanLists.isEmpty) {
          _createDefaultKanbanList(userId);
        }
        kanbanLists = ObservableList.of(lists);
        isLoading = false;

        if (!_listsLoadedCompleter!.isCompleted) {
          _listsLoadedCompleter!.complete();
        }
      });
    }, onError: (error) {
      print("Erro ao carregar listas Kanban: $error");
      runInAction(() {
        isLoading = false;
        if (!_listsLoadedCompleter!.isCompleted) {
          _listsLoadedCompleter!.completeError(error);
        }
      });
    });

    return _listsLoadedCompleter!.future;
  }

  @action
  Future<void> _createDefaultKanbanList(String userId) async {
    final defaultList = KanbanList(
      id: '', 
      name: 'A Fazer',
      order: 0,
      userId: userId,
    );
    await _kanbanListRepository.addKanbanList(defaultList);
  }

  @action
  Future<void> addKanbanList(String name) async {
    final userId = _authRepository.currentUser?.uid;
    if (userId == null) return;

    final newOrder =
        kanbanLists.isEmpty ? 0 : kanbanLists.map((l) => l.order).reduce((a, b) => a > b ? a : b) + 1;
    final newList = KanbanList(
      id: '',
      name: name,
      order: newOrder,
      userId: userId,
    );
    await _kanbanListRepository.addKanbanList(newList);
  }

  @action
  Future<void> updateKanbanList(KanbanList list) async {
    await _kanbanListRepository.updateKanbanList(list);
  }

  @action
  Future<void> deleteKanbanList(String listId) async {
    kanbanLists.removeWhere((list) => list.id == listId);
    try {
      await _kanbanListRepository.deleteKanbanList(listId);
    } catch (e) {
      print("Erro ao excluir coluna: $e");
    }
  }

  @action
  Future<void> reorderKanbanLists(int oldIndex, int newIndex) async {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final KanbanList movedList = kanbanLists.removeAt(oldIndex);
    kanbanLists.insert(newIndex, movedList);

    for (int i = 0; i < kanbanLists.length; i++) {
      kanbanLists[i].order = i;
    }
    await _kanbanListRepository.updateKanbanLists(kanbanLists.toList());
  }

  @action
  void dispose() {
    _kanbanListsSubscription?.cancel();
  }
}