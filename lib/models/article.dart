class Source {
  final String id;
  final String name;

  Source({
    required this.id,
    required this.name,
  });

  factory Source.fromJson(Map<String, dynamic> json) {
    return Source(
      id: json['id'] ?? '',
      name: json['name'] ?? 'Unknown Source',
    );
  }
}

class Article {
  final String title;
  final String? description; // Nullable description
  final String url;
  final String? urlToImage; // Nullable image URL
  final DateTime publishedAt; // Use DateTime instead of String for publishedAt
  final String? content; // Nullable content
  final Source source;

  Article({
    required this.title,
    this.description,
    required this.url,
    this.urlToImage,
    required this.publishedAt,
    this.content,
    required this.source,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'] ?? 'No Title',
      description: json['description'], // Allow null descriptions
      url: json['url'] ?? '',
      urlToImage: json['urlToImage'], // Allow null image URLs
      publishedAt: DateTime.parse(json['publishedAt'] ?? DateTime.now().toIso8601String()),
      content: json['content'], // Allow null content
      source: Source.fromJson(json['source'] ?? {'id': '', 'name': 'Unknown Source'}),
    );
  }
}
