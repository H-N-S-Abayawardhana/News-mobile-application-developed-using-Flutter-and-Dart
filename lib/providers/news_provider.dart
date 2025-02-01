import 'package:flutter/material.dart';
import '../models/article.dart';
import '../services/news_api_service.dart';

class NewsProvider extends ChangeNotifier {
  final _newsApiService = NewsApiService();
  List<Article> _articles = [];
  String? _currentCategory;
  String? _currentQuery;
  bool _isLoading = false;

  // Getters
  List<Article> get articles => _articles;
  String? get currentCategory => _currentCategory;
  String? get currentQuery => _currentQuery;
  bool get isLoading => _isLoading;

  // Get top headlines with optional category and query
  Future<void> getTopHeadlines({
    String? category,
    String? query,
  }) async {
    _setLoading(true);
    try {
      _currentCategory = category;
      _currentQuery = query;
      _articles = await _newsApiService.getTopHeadlines(
        category: category,
        query: query,
      );
    } catch (e) {
      debugPrint('Error fetching top headlines: $e');
      _articles = [];
    } finally {
      _setLoading(false);
    }
  }

  // Search news method
  Future<void> searchNews(String query) async {
    if (query.isEmpty) {
      return getTopHeadlines();
    }

    _setLoading(true);
    try {
      _currentQuery = query;
      _currentCategory = null; // Reset category when searching
      _articles = await _newsApiService.getTopHeadlines(
        query: query,
      );
    } catch (e) {
      debugPrint('Error searching news: $e');
      _articles = [];
    } finally {
      _setLoading(false);
    }
  }

  // Reset search and category
  void resetFilters() {
    _currentCategory = null;
    _currentQuery = null;
    getTopHeadlines();
  }

  // Helper method to handle loading state
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}