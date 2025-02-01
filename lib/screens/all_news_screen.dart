import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/news_provider.dart';
import '../providers/bookmarked_provider.dart';
import '../providers/theme_provider.dart';
import './news_category_screen.dart';
import '../models/article.dart';
import 'news_bookmarked.dart';
import 'aboutus_news_whiz.dart';
import 'news_detail_screen.dart';

class AllNewsScreen extends StatefulWidget {
  @override
  _AllNewsScreenState createState() => _AllNewsScreenState();
}

class _AllNewsScreenState extends State<AllNewsScreen> {
  String selectedSort = "Newest First";
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
    });
    Provider.of<NewsProvider>(context, listen: false).searchNews(_searchQuery);
  }

  Widget _buildImageWithFallback(String? imageUrl, {double? width, double? height, bool isDarkMode = false}) {
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
          color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
          child: Icon(
            Icons.newspaper,
            size: (height ?? 120) * 0.5,
            color: isDarkMode ? Colors.grey[600] : Colors.grey[400],
          ),
        );
      },
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          width: width,
          height: height,
          color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
          child: Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                  loadingProgress.expectedTotalBytes!
                  : null,
            ),
          ),
        );
      },
    )
        : Container(
      width: width,
      height: height,
      color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
      child: Icon(
        Icons.newspaper,
        size: (height ?? 120) * 0.5,
        color: isDarkMode ? Colors.grey[600] : Colors.grey[400],
      ),
    );
  }

  void _showBookmarkDialog(BuildContext context, Article article) {
    final TextEditingController titleController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Bookmark'),
        content: TextField(
          controller: titleController,
          decoration: InputDecoration(
              labelText: 'Bookmark Title',
              hintText: 'Enter a title for this bookmark'
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              if (titleController.text.isNotEmpty) {
                // Get the provider without listening
                final provider = Provider.of<BookmarkedProvider>(context, listen: false);

                // Add the bookmark
                await provider.addBookmark(article, titleController.text);

                // Show success message
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Bookmark added successfully!'),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );

                // Update the UI
                setState(() {});
              }
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'NewsWhiZ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Your Daily News Companion',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.newspaper),
            title: Text('All News'),
            selected: true,
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: Icon(Icons.category),
            title: Text('Categories'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NewsCategoryScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.star),
            title: Text('Bookmarks'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NewsBookmarkedScreen()),
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.info),
            title: Text('About Us'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AboutUsNewswhiz()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(bool isDarkMode) {
    return TextField(
      controller: _searchController,
      autofocus: true,
      decoration: InputDecoration(
        hintText: 'Search news...',
        border: InputBorder.none,
        hintStyle: TextStyle(
          color: isDarkMode ? Colors.white70 : Colors.black54,
        ),
      ),
      style: TextStyle(
        color: isDarkMode ? Colors.white : Colors.black,
      ),
    );
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _showSortOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Sort By',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              ListTile(
                title: Text('A-Z'),
                onTap: () {
                  setState(() => selectedSort = "A-Z");
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Z-A'),
                onTap: () {
                  setState(() => selectedSort = "Z-A");
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Newest First'),
                onTap: () {
                  setState(() => selectedSort = "Newest First");
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Oldest First'),
                onTap: () {
                  setState(() => selectedSort = "Oldest First");
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  List<Article> _getSortedArticles(List<Article> articles) {
    List<Article> sortedArticles = [...articles];

    switch (selectedSort) {
      case "A-Z":
        sortedArticles.sort((a, b) => a.title.compareTo(b.title));
        break;
      case "Z-A":
        sortedArticles.sort((a, b) => b.title.compareTo(a.title));
        break;
      case "Newest First":
        sortedArticles.sort((a, b) => b.publishedAt.compareTo(a.publishedAt));
        break;
      case "Oldest First":
        sortedArticles.sort((a, b) => a.publishedAt.compareTo(b.publishedAt));
        break;
    }

    return sortedArticles;
  }

  List<Article> _getFilteredArticles(List<Article> articles) {
    if (_searchQuery.isEmpty) return articles;

    return articles.where((article) {
      final titleMatch = article.title.toLowerCase().contains(_searchQuery.toLowerCase());
      final descriptionMatch = article.description?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false;
      return titleMatch || descriptionMatch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      drawer: _buildDrawer(),
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: _isSearching
            ? _buildSearchBar(isDarkMode)
            : Text(
          'All News',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                  Provider.of<NewsProvider>(context, listen: false).getTopHeadlines();
                }
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.sort),
            onPressed: () => _showSortOptions(context),
          ),
          IconButton(
            icon: Icon(isDarkMode ? Icons.dark_mode : Icons.light_mode),
            onPressed: () => themeProvider.toggleTheme(!isDarkMode),
          ),
        ],
      ),
      body: Consumer<NewsProvider>(
        builder: (context, newsProvider, child) {
          if (newsProvider.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          final articles = _getSortedArticles(newsProvider.articles);
          final filteredArticles = _getFilteredArticles(articles);

          if (filteredArticles.isEmpty) {
            return Center(
              child: Text(
                _searchQuery.isNotEmpty
                    ? 'No articles found for "$_searchQuery"'
                    : 'No articles found',
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.8,
              ),
              itemCount: filteredArticles.length,
              itemBuilder: (context, index) {
                final article = filteredArticles[index];
                final isBookmarked = context.watch<BookmarkedProvider>().isBookmarked(article);

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NewsDetailScreen(article: article),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: isDarkMode
                              ? Colors.black26
                              : Colors.grey.withOpacity(0.2),
                          blurRadius: 4,
                          offset: Offset(2, 2),
                        ),
                      ],
                      color: Theme.of(context).cardColor,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(12),
                          ),
                          child: _buildImageWithFallback(
                            article.urlToImage,
                            height: 80,
                            width: double.infinity,
                            isDarkMode: isDarkMode,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      article.title,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      isBookmarked ? Icons.star : Icons.star_border,
                                      color: isBookmarked ? Colors.yellow : null,
                                    ),
                                    onPressed: () => _showBookmarkDialog(context, article),
                                  ),
                                ],
                              ),
                              if (article.description != null)
                                Text(
                                  article.description!,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Theme.of(context).textTheme.bodyMedium?.color,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}