// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tag_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$TagStore on _TagStoreBase, Store {
  late final _$tagsAtom = Atom(name: '_TagStoreBase.tags', context: context);

  @override
  ObservableList<Tag> get tags {
    _$tagsAtom.reportRead();
    return super.tags;
  }

  @override
  set tags(ObservableList<Tag> value) {
    _$tagsAtom.reportWrite(value, super.tags, () {
      super.tags = value;
    });
  }

  late final _$isLoadingAtom = Atom(
    name: '_TagStoreBase.isLoading',
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

  late final _$errorAtom = Atom(name: '_TagStoreBase.error', context: context);

  @override
  String? get error {
    _$errorAtom.reportRead();
    return super.error;
  }

  @override
  set error(String? value) {
    _$errorAtom.reportWrite(value, super.error, () {
      super.error = value;
    });
  }

  late final _$fetchTagsAsyncAction = AsyncAction(
    '_TagStoreBase.fetchTags',
    context: context,
  );

  @override
  Future<void> fetchTags(String userId) {
    return _$fetchTagsAsyncAction.run(() => super.fetchTags(userId));
  }

  late final _$addTagAsyncAction = AsyncAction(
    '_TagStoreBase.addTag',
    context: context,
  );

  @override
  Future<void> addTag(String userId, Tag tag) {
    return _$addTagAsyncAction.run(() => super.addTag(userId, tag));
  }

  late final _$_TagStoreBaseActionController = ActionController(
    name: '_TagStoreBase',
    context: context,
  );

  @override
  void dispose() {
    final _$actionInfo = _$_TagStoreBaseActionController.startAction(
      name: '_TagStoreBase.dispose',
    );
    try {
      return super.dispose();
    } finally {
      _$_TagStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
tags: ${tags},
isLoading: ${isLoading},
error: ${error}
    ''';
  }
}
