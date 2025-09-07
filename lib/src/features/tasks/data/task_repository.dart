import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desafio_tecnico/src/features/tasks/domain/task.dart';

class TaskRepository {
  final FirebaseFirestore _firestore;

  TaskRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Task> _tasksRef(String userId) => _firestore
      .collection('users')
      .doc(userId)
      .collection('tasks')
      .withConverter<Task>(
        fromFirestore: (snapshot, _) => Task.fromMap(snapshot),
        toFirestore: (task, _) => task.toMap(),
      );

  Stream<List<Task>> getTasks(String userId) {
    return _tasksRef(userId).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  Future<void> addTask(String userId, Task task) async {
    await _tasksRef(userId).add(task);
  }

  Future<void> updateTask(String userId, Task task) async {
    await _tasksRef(userId).doc(task.id).update(task.toMap());
  }

  Future<void> deleteTask(String userId, String taskId) async {
    await _tasksRef(userId).doc(taskId).delete();
  }
}
