import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/news_provider.dart';
/*import '../providers/bookmarked_provider.dart';*/
import '../providers/theme_provider.dart';
/*import '../models/article.dart';*/
import 'all_news_screen.dart';
import 'news_bookmarked.dart';
import 'news_category_screen.dart';
import 'aboutus_news_whiz.dart';
import 'news_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  late PageController _trendingPageController;
  int _currentTrendingPage = 0;
  int _displayedNewsCount = 10;


  @override
  void initState() {
    super.initState();
    _trendingPageController = PageController(initialPage: 0);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<NewsProvider>(context, listen: false).getTopHeadlines();
      _startTrendingAutoScroll();
    });

    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    if (_searchController.text.isNotEmpty) {
      Provider.of<NewsProvider>(context, listen: false).searchNews(_searchController.text);
    } else {
      Provider.of<NewsProvider>(context, listen: false).getTopHeadlines();
    }
  }

  void _loadMore() {
    setState(() {
      _displayedNewsCount += 10;
    });
  }

  void _startTrendingAutoScroll() {
    Future.delayed(Duration(seconds: 5), () {
      if (mounted) {
        if (_currentTrendingPage < 4) {
          _currentTrendingPage++;
        } else {
          _currentTrendingPage = 0;
        }
        _trendingPageController
            .animateToPage(
          _currentTrendingPage,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        )
            .then((_) => _startTrendingAutoScroll());
      }
    });
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
          child: Icon(
            Icons.newspaper,
            size: (height ?? 60) * 0.5,
            color: Colors.grey[600],
          ),
        );
      },
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          width: width,
          height: height,
          color: Colors.grey[200],
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
      color: Colors.grey[200],
      child: Icon(
        Icons.newspaper,
        size: (height ?? 60) * 0.5,
        color: Colors.grey[600],
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
            },
          ),
          ListTile(
            leading: Icon(Icons.newspaper),
            title: Text('All News'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AllNewsScreen()),
              );
            },
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

  Widget _buildSearchBar() {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;
    return TextField(
      controller: _searchController,
      autofocus: true,
      decoration: InputDecoration(
        hintText: 'Search news...',
        border: InputBorder.none,
        hintStyle: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black54),
      ),
      style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _trendingPageController.dispose();
    super.dispose();
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
            ? _buildSearchBar()
            : Text(
          'NewsWhiZ',
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
            icon: Icon(isDarkMode ? Icons.dark_mode : Icons.light_mode),
            onPressed: () => themeProvider.toggleTheme(!isDarkMode),
          ),
        ],
      ),
      body: Consumer<NewsProvider>(
        builder: (context, newsProvider, child) {
          final articles = newsProvider.articles;

          if (articles.isEmpty) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          final trendingNews = articles.take(5).toList();
          final displayedNews = articles.take(_displayedNewsCount).toList();

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Trending News',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  Container(
                    height: 300,
                    child: PageView.builder(
                      controller: _trendingPageController,
                      itemCount: trendingNews.length,
                      onPageChanged: (index) {
                        setState(() {
                          _currentTrendingPage = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        final article = trendingNews[index];
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
                            margin: EdgeInsets.symmetric(horizontal: 8),
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
                                    height: 160,
                                    width: double.infinity,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        article.title,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            article.source?.name ?? '',
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
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
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      trendingNews.length,
                          (index) => Container(
                        width: 8,
                        height: 8,
                        margin: EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentTrendingPage == index
                              ? Theme.of(context).primaryColor
                              : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  Text(
                    'Latest News',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: displayedNews.length,
                    separatorBuilder: (context, index) => Divider(),
                    itemBuilder: (context, index) {
                      final article = displayedNews[index];
                      return ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NewsDetailScreen(article: article),
                            ),
                          );
                        },
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: _buildImageWithFallback(
                            article.urlToImage,
                            width: 60,
                            height: 60,
                          ),
                        ),
                        title: Text(
                          article.title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          article.description ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      );
                    },
                  ),
                  if (articles.length > _displayedNewsCount)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: ElevatedButton(
                          onPressed: _loadMore,
                          child: Text('Load More'),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}