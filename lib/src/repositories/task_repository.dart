import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desafio_tecnico/src/features/tasks/data/models/comment_model.dart';
import 'package:desafio_tecnico/src/features/tasks/domain/task.dart';

class TaskRepository {
  final FirebaseFirestore _firestore;

  TaskRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Task> _tasksRef(String userId) =>
      _firestore.collection('users').doc(userId).collection('tasks').withConverter<Task>(
            fromFirestore: (snapshot, _) => Task.fromMap(snapshot),
            toFirestore: (task, _) => task.toMap(),
          );

  CollectionReference<Comment> _commentsRef(String userId, String taskId) =>
      _tasksRef(userId).doc(taskId).collection('comments').withConverter<Comment>(
            fromFirestore: (snapshot, _) => Comment.fromFirestore(snapshot),
            toFirestore: (comment, _) => comment.toFirestore(),
          );

  Stream<List<Task>> getTasks(String userId) {
    return _tasksRef(userId).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  Future<DocumentReference<Task>> addTask(String userId, Task task) async {
    return await _tasksRef(userId).add(task);
  }

  Future<void> updateTask(String userId, Task task) async {
    await _tasksRef(userId).doc(task.id).update(task.toMap());
  }

  Future<void> deleteTask(String userId, String taskId) async {
    await _tasksRef(userId).doc(taskId).delete();
  }

  Stream<List<Comment>> getTaskCommentsStream(String userId, String taskId) {
    return _commentsRef(userId, taskId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  Future<void> addCommentToTask(String userId, String taskId, Comment comment) async {
    await _commentsRef(userId, taskId).add(comment);
  }

  Stream<List<Task>> getTasksByKanbanListId(String userId, String kanbanListId) {
    return _tasksRef(userId)
        .where('kanbanListId', isEqualTo: kanbanListId)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }
}
