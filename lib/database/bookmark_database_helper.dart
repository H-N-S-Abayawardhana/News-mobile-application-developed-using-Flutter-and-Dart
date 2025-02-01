import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/bookmark.dart';

class BookmarkDatabaseHelper {
  static final BookmarkDatabaseHelper instance = BookmarkDatabaseHelper._init();
  static Database? _database;  // Fixed variable name

  BookmarkDatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('bookmarks.db');  // Fixed method name
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    try {
      final dbPath = await getDatabasesPath();
      final path = join(dbPath, filePath);

      return await openDatabase(
        path,
        version: 1,
        onCreate: _createDB,
      );
    } catch (e) {
      debugPrint('Error initializing database: $e');
      rethrow;
    }
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE bookmarks(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        bookmarkTitle TEXT NOT NULL,
        articleTitle TEXT NOT NULL,
        articleDescription TEXT,
        articleUrl TEXT NOT NULL UNIQUE,
        articleUrlToImage TEXT,
        publishedAt TEXT NOT NULL,
        articleContent TEXT,
        sourceId TEXT NOT NULL,
        sourceName TEXT NOT NULL
      )
    ''');
  }

  Future<Bookmark> insertBookmark(Bookmark bookmark) async {
    try {
      final db = await instance.database;
      final id = await db.insert(
        'bookmarks',
        bookmark.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return bookmark.copyWith(id: id);
    } catch (e) {
      debugPrint('Error inserting bookmark: $e');
      rethrow;
    }
  }

  Future<List<Bookmark>> getAllBookmarks() async {
    try {
      final db = await instance.database;
      final result = await db.query('bookmarks', orderBy: 'id DESC');
      return result.map((json) => Bookmark.fromMap(json)).toList();
    } catch (e) {
      debugPrint('Error getting bookmarks: $e');
      return [];
    }
  }

  Future<int> updateBookmark(Bookmark bookmark) async {
    try {
      final db = await instance.database;
      return db.update(
        'bookmarks',
        bookmark.toMap(),
        where: 'id = ?',
        whereArgs: [bookmark.id],
      );
    } catch (e) {
      debugPrint('Error updating bookmark: $e');
      rethrow;
    }
  }

  Future<int> deleteBookmark(int id) async {
    try {
      final db = await instance.database;
      return await db.delete(
        'bookmarks',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      debugPrint('Error deleting bookmark: $e');
      rethrow;
    }
  }

  Future<void> close() async {
    final db = await instance.database;
    await db.close();
  }
}