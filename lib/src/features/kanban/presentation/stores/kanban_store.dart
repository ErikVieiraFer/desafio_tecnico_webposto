import 'package:mobx/mobx.dart';
import 'package:desafio_tecnico/src/features/kanban/data/models/kanban_list.dart';
import 'package:desafio_tecnico/src/repositories/kanban_list_repository.dart';
import 'package:desafio_tecnico/src/repositories/auth_repository.dart'; // Assuming AuthRepository exists

part 'kanban_store.g.dart';

class KanbanStore = _KanbanStore with _$KanbanStore;

abstract class _KanbanStore with Store {
  final KanbanListRepository _kanbanListRepository;
  final AuthRepository _authRepository; // Assuming AuthRepository exists

  _KanbanStore(this._kanbanListRepository, this._authRepository);

  @observable
  ObservableList<KanbanList> kanbanLists = ObservableList<KanbanList>();

  @observable
  bool isLoading = false;

  @action
  Future<void> loadKanbanLists() async {
    final userId = _authRepository.currentUser?.uid;
    if (userId == null) return;

    isLoading = true;

    var lists = await _kanbanListRepository.getKanbanLists(userId).first;

    if (!lists.any((list) => list.name == 'A Fazer')) {
      await _createDefaultKanbanList(userId);
      // After creating, we need to get the updated list
      lists = await _kanbanListRepository.getKanbanLists(userId).first;
    }

    runInAction(() {
      kanbanLists = ObservableList.of(lists);
      isLoading = false;
    });
  }

  @action
  Future<void> _createDefaultKanbanList(String userId) async {
    final defaultList = KanbanList(
      id: '', // Firestore will generate ID
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

    final newOrder = kanbanLists.isEmpty ? 0 : kanbanLists.last.order + 1;
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
    await _kanbanListRepository.deleteKanbanList(listId);
  }

  @action
  Future<void> reorderKanbanLists(int oldIndex, int newIndex) async {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final KanbanList movedList = kanbanLists.removeAt(oldIndex);
    kanbanLists.insert(newIndex, movedList);

    // Update order in Firestore
    for (int i = 0; i < kanbanLists.length; i++) {
      kanbanLists[i].order = i;
    }
    await _kanbanListRepository.updateKanbanLists(kanbanLists.toList());
  }

  // Method to move a task between Kanban lists
  @action
  Future<void> moveTaskBetweenKanbanLists(
      String taskId, String oldListId, String newListId) async {
    final oldList = kanbanLists.firstWhere((list) => list.id == oldListId);
    final newList = kanbanLists.firstWhere((list) => list.id == newListId);

    oldList.taskIds.remove(taskId);
    newList.taskIds.add(taskId);

    await _kanbanListRepository.updateKanbanList(oldList);
    await _kanbanListRepository.updateKanbanList(newList);
  }
}
