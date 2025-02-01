import 'package:flutter/material.dart';
import '../models/article.dart';
import '../models/bookmark.dart';
import '../database/bookmark_database_helper.dart';

class BookmarkedProvider extends ChangeNotifier {
  final List<Bookmark> _bookmarks = [];  // Fixed variable name
  final _dbHelper = BookmarkDatabaseHelper.instance;  // Fixed variable name

  // Getter for bookmarked articles (converted from bookmarks)
  List<Article> get bookmarkedArticles {
    return _bookmarks.map((bookmark) => bookmark.toArticle()).toList();
  }

  // Getter for raw bookmarks
  List<Bookmark> get bookmarks => List.unmodifiable(_bookmarks);

  // Initialize bookmarks from database
  Future<void> loadBookmarks() async {
    try {
      _bookmarks.clear();
      _bookmarks.addAll(await _dbHelper.getAllBookmarks());
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading bookmarks: $e');
      // You might want to show an error message to the user
    }
  }

  // Add bookmark with custom title
  Future<void> addBookmark(Article article, String bookmarkTitle) async {
    try {
      final bookmark = Bookmark.fromArticle(article, bookmarkTitle);
      final savedBookmark = await _dbHelper.insertBookmark(bookmark);
      _bookmarks.add(savedBookmark);
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding bookmark: $e');
      rethrow;
    }
  }

  // Toggle bookmark status
  Future<void> toggleBookmark(Article article) async {
    try {
      if (isBookmarked(article)) {
        final bookmark = _bookmarks.firstWhere(
              (b) => b.articleUrl == article.url,
        );
        await removeBookmark(bookmark);
      } else {
        await addBookmark(article, article.title);
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error toggling bookmark: $e');
      rethrow;
    }
  }

  // Check if an article is bookmarked
  bool isBookmarked(Article article) {
    return _bookmarks.any((bookmark) => bookmark.articleUrl == article.url);
  }

  // Get bookmark title with the news article
  String? getBookmarkTitle(Article article) {
    try {
      final bookmark = _bookmarks.firstWhere(
            (bookmark) => bookmark.articleUrl == article.url,
        orElse: () => Bookmark(
          bookmarkTitle: '',
          articleTitle: '',
          articleUrl: '',
          publishedAt: '',
          sourceId: '',
          sourceName: '',
        ),
      );
      return bookmark.bookmarkTitle;
    } catch (e) {
      return null;
    }
  }

  // Update bookmark title
  Future<void> updateBookmarkTitle(Bookmark bookmark, String newTitle) async {
    try {
      final updatedBookmark = bookmark.copyWith(bookmarkTitle: newTitle);
      await _dbHelper.updateBookmark(updatedBookmark);

      final index = _bookmarks.indexWhere((b) => b.id == bookmark.id);
      if (index != -1) {
        _bookmarks[index] = updatedBookmark;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error updating bookmark title: $e');
      rethrow;
    }
  }

  // Remove bookmark
  Future<void> removeBookmark(Bookmark bookmark) async {
    try {
      if (bookmark.id != null) {
        await _dbHelper.deleteBookmark(bookmark.id!);
        _bookmarks.removeWhere((b) => b.id == bookmark.id);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error removing bookmark: $e');
      rethrow;
    }
  }
}