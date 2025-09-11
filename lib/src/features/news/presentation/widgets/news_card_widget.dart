import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:desafio_tecnico/src/features/news/presentation/stores/news_store.dart';
import 'package:desafio_tecnico/src/features/news/data/news_api_service.dart';
import 'package:dio/dio.dart';
import 'package:desafio_tecnico/src/core/routing/app_router.dart';

final newsApiService = NewsApiService(Dio());
final newsStore = NewsStore(newsApiService);

class NewsCardWidget extends StatefulWidget {
  const NewsCardWidget({super.key});

  @override
  State<NewsCardWidget> createState() => _NewsCardWidgetState();
}

class _NewsCardWidgetState extends State<NewsCardWidget> {
  @override
  void initState() {
    super.initState();
    newsStore.fetchTopHeadlines(country: 'br');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Observer(
      builder: (_) {
        if (newsStore.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (newsStore.error != null) {
          return Center(child: Text('Ocorreu um erro: ${newsStore.error}'));
        }

        if (newsStore.articles.isEmpty) {
          return const Center(child: Text('Nenhuma notícia encontrada.'));
        }

        return Card(
          margin: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: 240,
            child: PageView.builder(
              itemCount: newsStore.articles.length,
              itemBuilder: (context, index) {
                final article = newsStore.articles[index];
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (article.urlToImage != null &&
                          article.urlToImage!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Image.network(
                            article.urlToImage!,
                            height: 100,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const SizedBox.shrink();
                            },
                          ),
                        ),
                      Text(
                        article.title,
                        style: theme.textTheme.titleMedium,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (article.author != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            'Por ${article.author}',
                            style: theme.textTheme.bodySmall,
                          ),
                        ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            AppRouter.newsDetail,
                            arguments: article,
                          );
                        },
                        child: Text(
                          'Ler mais',
                          style: TextStyle(color: theme.colorScheme.secondary),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}