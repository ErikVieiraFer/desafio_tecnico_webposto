import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desafio_tecnico/src/features/auth/presentation/stores/auth_store.dart';
import 'package:desafio_tecnico/src/features/tasks/data/models/comment_model.dart';
import 'package:desafio_tecnico/src/repositories/task_repository.dart';
import 'package:mobx/mobx.dart';

part 'comment_store.g.dart';

class CommentStore = _CommentStore with _$CommentStore;

abstract class _CommentStore with Store {
  final TaskRepository _taskRepository;
  final AuthStore _authStore;

  _CommentStore(this._taskRepository, this._authStore);

  @observable
  ObservableList<Comment> comments = ObservableList<Comment>();

  @observable
  bool isLoading = false;

  late String _currentTaskId;
  late ReactionDisposer _commentsDisposer;

  void setupCommentsStream(String taskId) {
    _currentTaskId = taskId;
    final userId = _authStore.user?.uid;
    if (userId == null) return;

    _commentsDisposer = reaction(
      (_) => _authStore.user,
      (_) {
        final stream = _taskRepository.getTaskCommentsStream(userId, _currentTaskId);
        stream.listen((newComments) {
          comments.clear();
          comments.addAll(newComments);
        });
      },
      fireImmediately: true,
    );
  }

  @action
  Future<void> addComment(String content) async {
    final userId = _authStore.user?.uid;
    final authorName = _authStore.user?.displayName ?? 'Usuário Anônimo';
    if (userId == null || content.trim().isEmpty) return;

    final newComment = Comment(
      id: '',
      authorId: userId,
      authorName: authorName,
      content: content,
      timestamp: Timestamp.now(),
    );

    await _taskRepository.addCommentToTask(userId, _currentTaskId, newComment);
  }

  void dispose() {
    _commentsDisposer();
  }
}
