import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desafio_tecnico/src/features/kanban/data/models/kanban_list.dart';

class KanbanListRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionPath = 'kanban_lists';

  Stream<List<KanbanList>> getKanbanLists(String userId) {
    return _firestore
        .collection(_collectionPath)
        .where('userId', isEqualTo: userId)
        .orderBy('order')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => KanbanList.fromSnapshot(doc)).toList();
    });
  }

  Future<void> addKanbanList(KanbanList list) async {
    await _firestore.collection(_collectionPath).add(list.toMap());
  }

  Future<void> updateKanbanList(KanbanList list) async {
    await _firestore
        .collection(_collectionPath)
        .doc(list.id)
        .update(list.toMap());
  }

  Future<void> deleteKanbanList(String listId) async {
    await _firestore.collection(_collectionPath).doc(listId).delete();
  }

  Future<void> updateKanbanLists(List<KanbanList> lists) async {
    final batch = _firestore.batch();
    for (final list in lists) {
      final docRef = _firestore.collection(_collectionPath).doc(list.id);
      batch.update(docRef, list.toMap());
    }
    await batch.commit();
  }
}
