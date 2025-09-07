import 'package:mobx/mobx.dart';
import 'package:desafio_tecnico/src/features/news/domain/models/article.dart';
import 'package:desafio_tecnico/src/features/news/data/news_api_service.dart';

part 'news_store.g.dart';

class NewsStore = _NewsStoreBase with _$NewsStore;

abstract class _NewsStoreBase with Store {
  final NewsApiService _newsApiService;

  _NewsStoreBase(this._newsApiService);

  @observable
  ObservableList<Article> articles = ObservableList<Article>();

  @observable
  bool isLoading = false;

  @observable
  String? error;

  @action
  Future<void> fetchTopHeadlines({String country = 'us', String category = 'technology'}) async {
    isLoading = true;
    error = null;
    print('NewsStore: Fetching top headlines...');
    try {
      final fetchedArticles = await _newsApiService.getTopHeadlines(country: country, category: category);
      articles = ObservableList.of(fetchedArticles);
      print('NewsStore: Successfully fetched ${articles.length} articles.');
    } catch (e) {
      error = e.toString();
      print('NewsStore Error: ${error}');
    } finally {
      isLoading = false;
      print('NewsStore: Loading finished. IsLoading: $isLoading');
    }
  }
}