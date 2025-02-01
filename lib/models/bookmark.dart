import 'article.dart';

class Bookmark {
  final int? id;
  final String bookmarkTitle;
  final String articleTitle;
  final String? articleDescription;
  final String articleUrl;
  final String? articleUrlToImage;
  final String publishedAt;
  final String? articleContent;
  final String sourceId;
  final String sourceName;

  Bookmark({
    this.id,
    required this.bookmarkTitle,
    required this.articleTitle,
    this.articleDescription,
    required this.articleUrl,
    this.articleUrlToImage,
    required this.publishedAt,
    this.articleContent,
    required this.sourceId,
    required this.sourceName,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'bookmarkTitle': bookmarkTitle,
      'articleTitle': articleTitle,
      'articleDescription': articleDescription,
      'articleUrl': articleUrl,
      'articleUrlToImage': articleUrlToImage,
      'publishedAt': publishedAt,
      'articleContent': articleContent,
      'sourceId': sourceId,
      'sourceName': sourceName,
    };
  }

  factory Bookmark.fromMap(Map<String, dynamic> map) {
    return Bookmark(
      id: map['id'],
      bookmarkTitle: map['bookmarkTitle'],
      articleTitle: map['articleTitle'],
      articleDescription: map['articleDescription'],
      articleUrl: map['articleUrl'],
      articleUrlToImage: map['articleUrlToImage'],
      publishedAt: map['publishedAt'],
      articleContent: map['articleContent'],
      sourceId: map['sourceId'],
      sourceName: map['sourceName'],
    );
  }

  factory Bookmark.fromArticle(Article article, String bookmarkTitle) {
    return Bookmark(
      bookmarkTitle: bookmarkTitle,
      articleTitle: article.title,
      articleDescription: article.description,
      articleUrl: article.url,
      articleUrlToImage: article.urlToImage,
      publishedAt: article.publishedAt.toIso8601String(),
      articleContent: article.content,
      sourceId: article.source.id,
      sourceName: article.source.name,
    );
  }

  Article toArticle() {
    return Article(
      title: articleTitle,
      description: articleDescription,
      url: articleUrl,
      urlToImage: articleUrlToImage,
      publishedAt: DateTime.parse(publishedAt),
      content: articleContent,
      source: Source(id: sourceId, name: sourceName),
    );
  }

  // Add copyWith method for updating bookmark properties
  Bookmark copyWith({
    int? id,
    String? bookmarkTitle,
    String? articleTitle,
    String? articleDescription,
    String? articleUrl,
    String? articleUrlToImage,
    String? publishedAt,
    String? articleContent,
    String? sourceId,
    String? sourceName,
  }) {
    return Bookmark(
      id: id ?? this.id,
      bookmarkTitle: bookmarkTitle ?? this.bookmarkTitle,
      articleTitle: articleTitle ?? this.articleTitle,
      articleDescription: articleDescription ?? this.articleDescription,
      articleUrl: articleUrl ?? this.articleUrl,
      articleUrlToImage: articleUrlToImage ?? this.articleUrlToImage,
      publishedAt: publishedAt ?? this.publishedAt,
      articleContent: articleContent ?? this.articleContent,
      sourceId: sourceId ?? this.sourceName,
      sourceName: sourceName ?? this.sourceName,
    );
  }
}