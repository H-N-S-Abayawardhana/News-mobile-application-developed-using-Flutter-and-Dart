import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/article.dart';
import '../providers/news_provider.dart';
import '../providers/theme_provider.dart';
import 'news_detail_screen.dart';

class NewsCategoryScreen extends StatefulWidget {
  @override
  _NewsCategoryScreenState createState() => _NewsCategoryScreenState();
}

class _NewsCategoryScreenState extends State<NewsCategoryScreen> {
  final List<Map<String, dynamic>> categories = [
    {
      'name': 'Technology',
      'keywords': ['tech', 'technology', 'digital', 'software', 'hardware', 'ai', 'computer', 'mobile', 'smartphone', 'gadget'],
      'icon': Icons.computer
    },
    {
      'name': 'Business',
      'keywords': ['business', 'economy', 'finance', 'market', 'stock', 'trade', 'company', 'corporate', 'startup'],
      'icon': Icons.business
    },
    {
      'name': 'Sports',
      'keywords': ['sport', 'sports', 'football', 'soccer', 'basketball', 'tennis', 'cricket', 'athletics', 'game'],
      'icon': Icons.sports_baseball
    },
    {
      'name': 'Entertainment',
      'keywords': ['entertainment', 'movie', 'film', 'music', 'celebrity', 'hollywood', 'tv', 'show', 'cinema', 'actor'],
      'icon': Icons.movie
    },
    {
      'name': 'Science',
      'keywords': ['science', 'research', 'study', 'scientific', 'discovery', 'space', 'physics', 'biology', 'chemistry'],
      'icon': Icons.science
    },
    {
      'name': 'Health',
      'keywords': ['health', 'medical', 'medicine', 'healthcare', 'disease', 'doctor', 'hospital', 'wellness', 'covid'],
      'icon': Icons.health_and_safety
    }
  ];

  bool isArticleInCategory(Article article, List<String> keywords) {
    final String searchText = '${article.title} ${article.description ?? ''}'.toLowerCase();
    return keywords.any((keyword) => searchText.contains(keyword.toLowerCase()));
  }

  Widget _buildImageWithFallback(String? imageUrl, {double? width, double? height}) {
    return imageUrl != null
        ? Image.network(
      imageUrl,
      width: width,
      height: height,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: width,
          height: height,
          color: Colors.grey[200],
          child: Icon(Icons.newspaper, size: 30, color: Colors.grey[400]),
        );
      },
    )
        : Container(
      width: width,
      height: height,
      color: Colors.grey[200],
      child: Icon(Icons.newspaper, size: 30, color: Colors.grey[400]),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    final newsProvider = Provider.of<NewsProvider>(context);
    final articles = newsProvider.articles;

    // Group articles by categories using the keywords
    final Map<String, List<Article>> categorizedArticles = {
      for (var category in categories)
        category['name']: articles
            .where((article) => isArticleInCategory(article, List<String>.from(category['keywords'])))
            .toList()
    };

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'News Categories',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(isDarkMode ? Icons.dark_mode : Icons.light_mode),
            onPressed: () => themeProvider.toggleTheme(!isDarkMode),
          ),
        ],
      ),
      body: newsProvider.isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final categoryName = category['name'] as String;
          final categoryArticles = categorizedArticles[categoryName] ?? [];
          final icon = category['icon'] as IconData;

          return Card(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            elevation: 2,
            child: ExpansionTile(
              leading: Icon(icon, color: Theme.of(context).primaryColor),
              title: Row(
                children: [
                  Text(
                    categoryName,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 8),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${categoryArticles.length}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
              children: categoryArticles.isEmpty
                  ? [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'No articles available in this category.',
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                    ),
                  ),
                )
              ]
                  : categoryArticles.map((article) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NewsDetailScreen(article: article),
                      ),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.all(12),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: _buildImageWithFallback(
                            article.urlToImage,
                            width: 80,
                            height: 80,
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                article.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 4),
                              if (article.description != null)
                                Text(
                                  article.description!,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}