import 'package:dio/dio.dart';
import '../models/article.dart';

class NewsApiService {
  final _dio = Dio();
  final _apiKey = '4be10062fb674de68dc4e76c27d7177e';
  final _baseUrl = 'https://newsapi.org/v2/';

  Future<List<Article>> getTopHeadlines({
    String? category,
    String? country,
    String? query,
  }) async {
    try {
      final response = await _dio.get(
        '$_baseUrl/top-headlines',
        queryParameters: {
          'q': query,
          'category': category,
          'country': country ?? 'us',
          'apiKey': _apiKey,
        },
      );


      final articleList = (response.data['articles'] as List)
          .map((article) => Article.fromJson(article))
          .toList();

      return articleList;
    } catch (e) {
      rethrow;
    }
  }
}