import 'package:flutter/material.dart';
import '../models/article.dart';

class NewsDetailScreen extends StatefulWidget {
  final Article article;

  const NewsDetailScreen({Key? key, required this.article}) : super(key: key);

  @override
  State<NewsDetailScreen> createState() => _NewsDetailScreenState();
}

class _NewsDetailScreenState extends State<NewsDetailScreen> {
  bool _isDescriptionExpanded = false;
  final int _descriptionMaxLines = 3;

  Widget _buildImageWithFallback(BuildContext context, String? imageUrl, {double? height}) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      height: height ?? 250,
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
      ),
      child: imageUrl != null && imageUrl.isNotEmpty
          ? Image.network(
        imageUrl,
        width: double.infinity,
        height: height ?? 250,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.newspaper,
                  size: 80,
                  color: isDarkMode ? Colors.grey[600] : Colors.grey[400],
                ),
                SizedBox(height: 8),
                Text(
                  'Image not available',
                  style: TextStyle(
                    color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          );
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                  loadingProgress.expectedTotalBytes!
                  : null,
            ),
          );
        },
      )
          : Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.newspaper,
              size: 80,
              color: isDarkMode ? Colors.grey[600] : Colors.grey[400],
            ),
            SizedBox(height: 8),
            Text(
              'No image available',
              style: TextStyle(
                color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandableDescription(BuildContext context, String description) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          description,
          maxLines: _isDescriptionExpanded ? null : _descriptionMaxLines,
          overflow: _isDescriptionExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 16,
            height: 1.6,
            color: isDarkMode ? Colors.grey[300] : Colors.grey[800],
          ),
        ),
        SizedBox(height: 8),
        GestureDetector(
          onTap: () {
            setState(() {
              _isDescriptionExpanded = !_isDescriptionExpanded;
            });
          },
          child: Row(
            children: [
              Text(
                _isDescriptionExpanded ? 'Show Less' : 'See More',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icon(
                _isDescriptionExpanded
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
                color: Theme.of(context).primaryColor,
                size: 20,
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'News Detail',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImageWithFallback(context, widget.article.urlToImage),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.article.title,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      if (widget.article.source?.name != null) ...[
                        Icon(
                          Icons.public,
                          size: 16,
                          color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                        ),
                        SizedBox(width: 4),
                        Text(
                          widget.article.source!.name,
                          style: TextStyle(
                            color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(width: 16),
                      ],
                      Icon(
                        Icons.calendar_today,
                        size: 16,
                        color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                      ),
                      SizedBox(width: 4),
                      Text(
                        _formatDate(widget.article.publishedAt),
                        style: TextStyle(
                          color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),

                  // Description with See More functionality
                  if (widget.article.description != null)
                    _buildExpandableDescription(context, widget.article.description!),

                  SizedBox(height: 24),

                  // Full Content Section
                  if (widget.article.content != null && widget.article.content!.isNotEmpty) ...[
                    Divider(
                      thickness: 1,
                      color: isDarkMode ? Colors.grey[800] : Colors.grey[300],
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Article',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      widget.article.content!,
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.6,
                      ),
                    ),
                  ] else
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      alignment: Alignment.center,
                      child: Text(
                        'Full content not available',
                        style: TextStyle(
                          fontSize: 16,
                          color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}