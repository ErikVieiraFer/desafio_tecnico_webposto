import 'package:dio/dio.dart';
import 'package:desafio_tecnico/src/features/news/domain/models/article.dart';

class NewsApiService {
  final Dio _dio;
  final String _apiKey = '2d93ba35d5b6b4a4a4c481d5ef0e5d51'; // Sua chave da GNews API
  final String _baseUrl = 'https://gnews.io/api/v4';

  NewsApiService(this._dio);

  Future<List<Article>> getTopHeadlines({String country = 'br', String category = 'technology'}) async {
    try {
      final response = await _dio.get(
        '$_baseUrl/top-headlines',
        queryParameters: {
          'country': country,
          'lang': 'pt', // Usando 'lang' para GNews API
          'token': _apiKey, // Usando 'token' para GNews API
        },
      );

      print('NewsAPI Response Status Code: ${response.statusCode}');
      print('NewsAPI Response Data: ${response.data}');

      if (response.statusCode == 200) {
        final List<dynamic> articlesJson = response.data['articles'];
        print('Number of articles received: ${articlesJson.length}');
        return articlesJson.map((json) => Article.fromJson(json)).toList();
      } else {
        print('NewsAPI Error: Falha ao carregar notícias: ${response.statusCode}');
        throw Exception('Falha ao carregar notícias: ${response.statusCode}');
      }
    } catch (e) {
      print('NewsAPI Error: Erro ao conectar à NewsAPI: ${e.toString()}');
      throw Exception('Erro ao conectar à NewsAPI: ${e.toString()}');
    }
  }
}