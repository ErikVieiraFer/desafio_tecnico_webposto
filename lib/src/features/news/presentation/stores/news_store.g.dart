// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$NewsStore on _NewsStoreBase, Store {
  late final _$articlesAtom = Atom(
    name: '_NewsStoreBase.articles',
    context: context,
  );

  @override
  ObservableList<Article> get articles {
    _$articlesAtom.reportRead();
    return super.articles;
  }

  @override
  set articles(ObservableList<Article> value) {
    _$articlesAtom.reportWrite(value, super.articles, () {
      super.articles = value;
    });
  }

  late final _$isLoadingAtom = Atom(
    name: '_NewsStoreBase.isLoading',
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

  late final _$errorAtom = Atom(name: '_NewsStoreBase.error', context: context);

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

  late final _$fetchTopHeadlinesAsyncAction = AsyncAction(
    '_NewsStoreBase.fetchTopHeadlines',
    context: context,
  );

  @override
  Future<void> fetchTopHeadlines({
    String country = 'us',
    String category = 'technology',
  }) {
    return _$fetchTopHeadlinesAsyncAction.run(
      () => super.fetchTopHeadlines(country: country, category: category),
    );
  }

  @override
  String toString() {
    return '''
articles: ${articles},
isLoading: ${isLoading},
error: ${error}
    ''';
  }
}
