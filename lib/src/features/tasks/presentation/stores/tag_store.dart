import 'package:desafio_tecnico/src/features/tasks/data/tag_repository.dart';
import 'package:desafio_tecnico/src/features/tasks/domain/tag.dart';
import 'package:mobx/mobx.dart';
import 'dart:async';

part 'tag_store.g.dart';

class TagStore = _TagStoreBase with _$TagStore;

abstract class _TagStoreBase with Store {
  final TagRepository _tagRepository;
  StreamSubscription<List<Tag>>? _tagsSubscription;

  _TagStoreBase(this._tagRepository);

  @observable
  ObservableList<Tag> tags = ObservableList<Tag>();

  @observable
  bool isLoading = false;

  @observable
  String? error;

  Stream<List<Tag>> tagsStream(String userId) {
    return _tagRepository.getTags(userId);
  }

  @action
  Future<void> fetchTags(String userId) async {
    isLoading = true;
    error = null;
    _tagsSubscription?.cancel();

    try {
      _tagsSubscription = _tagRepository.getTags(userId).listen(
        (tagList) {
          runInAction(() {
            tags = ObservableList.of(tagList);
            isLoading = false;
          });
        },
        onError: (e) {
          runInAction(() {
            error = e.toString();
            isLoading = false;
          });
        },
      );
    } catch (e) {
      runInAction(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  @action
  Future<void> addTag(String userId, Tag tag) async {
    try {
      await _tagRepository.addTag(userId, tag);
    } catch (e) {
      error = e.toString();
    }
  }

  @action
  void dispose() {
    _tagsSubscription?.cancel();
  }
}
