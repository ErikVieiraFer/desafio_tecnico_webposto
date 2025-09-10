import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desafio_tecnico/src/features/kanban/domain/kanban_list.dart';

class KanbanListRepository {
  final FirebaseFirestore _firestore;

  KanbanListRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<KanbanList> _listsRef(String userId) => _firestore
      .collection('users')
      .doc(userId)
      .collection('kanban_lists')
      .withConverter<KanbanList>(
        fromFirestore: (snapshot, _) => KanbanList.fromSnapshot(snapshot),
        toFirestore: (list, _) => list.toMap(),
      );

  Stream<List<KanbanList>> getKanbanLists(String userId) {
    return _listsRef(userId).orderBy('order').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  Future<void> addKanbanList(String userId, KanbanList list) async {
    await _listsRef(userId).add(list);
  }

  Future<void> updateKanbanList(String userId, KanbanList list) async {
    await _listsRef(userId).doc(list.id).update(list.toMap());
  }

  Future<void> deleteKanbanList(String userId, String listId) async {
    await _listsRef(userId).doc(listId).delete();
  }

  Future<void> createDefaultList(String userId) async {
    final lists = await _listsRef(userId).limit(1).get();
    if (lists.docs.isEmpty) {
      final defaultList = KanbanList(name: 'A Fazer', order: 0);
      await addKanbanList(userId, defaultList);
    }
  }
}
