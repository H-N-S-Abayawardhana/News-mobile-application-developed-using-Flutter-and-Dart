import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/bookmarked_provider.dart';
import '../providers/theme_provider.dart';
import '../models/article.dart';
import '../models/bookmark.dart';
import 'news_detail_screen.dart';

class NewsBookmarkedScreen extends StatefulWidget {
  @override
  _NewsBookmarkedScreenState createState() => _NewsBookmarkedScreenState();
}

class _NewsBookmarkedScreenState extends State<NewsBookmarkedScreen> {
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    // Load bookmarks when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BookmarkedProvider>().loadBookmarks();
    });
  }

  void _showEditTitleDialog(BuildContext context, Bookmark bookmark) {
    final TextEditingController titleController = TextEditingController(
        text: bookmark.bookmarkTitle
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Bookmark Title'),
        content: TextField(
          controller: titleController,
          decoration: InputDecoration(
            labelText: 'Bookmark Title',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (titleController.text.isNotEmpty) {
                context.read<BookmarkedProvider>()
                    .updateBookmarkTitle(bookmark, titleController.text);
                Navigator.pop(context);
              }
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  Widget _buildImageWithFallback(String? imageUrl, {double? width, double? height, bool isDarkMode = false}) {
    // Your existing _buildImageWithFallback implementation remains the same
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
            size: (height ?? 60) * 0.5,
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
        size: (height ?? 60) * 0.5,
        color: isDarkMode ? Colors.grey[600] : Colors.grey[400],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bookmarkedProvider = Provider.of<BookmarkedProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    final allBookmarks = bookmarkedProvider.bookmarks;

    // Filter bookmarks based on search query
    final filteredBookmarks = allBookmarks
        .where((bookmark) =>
    bookmark.articleTitle.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        bookmark.bookmarkTitle.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Bookmarked News',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(isDarkMode ? Icons.dark_mode : Icons.light_mode),
            onPressed: () => themeProvider.toggleTheme(!isDarkMode),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar (your existing search bar implementation)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search bookmarked news...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Theme.of(context).primaryColor,
                    width: 2,
                  ),
                ),
                filled: true,
                fillColor: isDarkMode ? Colors.grey[800] : Colors.grey[50],
              ),
            ),
          ),
          Expanded(
            child: filteredBookmarks.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.bookmark_border,
                    size: 64,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No bookmarks found!',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            )
                : ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: filteredBookmarks.length,
              itemBuilder: (context, index) {
                final bookmark = filteredBookmarks[index];
                final article = bookmark.toArticle();

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NewsDetailScreen(article: article),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 2,
                    margin: EdgeInsets.only(bottom: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(12),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: _buildImageWithFallback(
                          article.urlToImage,
                          width: 60,
                          height: 60,
                          isDarkMode: isDarkMode,
                        ),
                      ),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            bookmark.bookmarkTitle,
                            style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            article.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (article.description != null) ...[
                            SizedBox(height: 4),
                            Text(
                              article.description!,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: isDarkMode
                                    ? Colors.grey[400]
                                    : Colors.grey[700],
                              ),
                            ),
                          ],
                          SizedBox(height: 4),
                          Text(
                            article.publishedAt.toString().substring(0, 10),
                            style: TextStyle(
                              fontSize: 12,
                              color: isDarkMode
                                  ? Colors.grey[500]
                                  : Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => _showEditTitleDialog(context, bookmark),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              bookmarkedProvider.removeBookmark(bookmark);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Bookmark removed!'),
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}