import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desafio_tecnico/src/features/tasks/domain/tag.dart';

class TagRepository {
  final FirebaseFirestore _firestore;

  TagRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Tag> _tagsRef(String userId) => _firestore
      .collection('users')
      .doc(userId)
      .collection('tags')
      .withConverter<Tag>(
        fromFirestore: (snapshot, _) {
          final data = snapshot.data()!;
          return Tag.fromMap({
            ...data,
            'id': snapshot.id, // Adiciona o ID do documento ao mapa
          });
        },
        toFirestore: (tag, _) => tag.toMap(),
      );

  Stream<List<Tag>> getTags(String userId) {
    return _tagsRef(userId).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  Future<DocumentReference<Tag>> addTag(String userId, Tag tag) async {
    return await _tagsRef(userId).add(tag);
  }

  Future<void> deleteTag(String userId, String tagId) async {
    await _tagsRef(userId).doc(tagId).delete();
  }
}
