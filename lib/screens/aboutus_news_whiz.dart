import 'package:flutter/material.dart';
import './news_category_screen.dart';
import 'news_bookmarked.dart';

class AboutUsNewswhiz extends StatelessWidget {
  Widget _buildDrawer(BuildContext context) {
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
              Navigator.pop(context); // Return to home screen
            },
          ),
          ListTile(
            leading: Icon(Icons.newspaper),
            title: Text('All News'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pop(context);
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
            selected: true,
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(BuildContext context, String feature) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '• ',
            style: TextStyle(fontSize: 20, color: Theme.of(context).primaryColor),
          ),
          Expanded(
            child: Text(
              feature,
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey[300]
                    : Colors.grey[800],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'About Us',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      drawer: _buildDrawer(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App Logo
            Center(
              child: Image.asset(
                'assets/images/Logo.png',
                height: 120,
                width: 120,
              ),
            ),
            SizedBox(height: 16),

            // App Name
            Center(
              child: Text(
                'News Whiz',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 8),

            // Tagline
            Center(
              child: Text(
                'Soar Above the Rest, Stay Informed.',
                style: TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
            ),
            SizedBox(height: 24),

            // About Section
            Text(
              'About News Whiz',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'News Whiz is a modern news application designed to keep you updated with the latest news from around the world. '
                  'We strive to deliver accurate, unbiased, and up-to-date information to our users. Our app is built to make news discovery easier, '
                  'offering features like trending headlines, category filtering, bookmarks, and more.',
              style: TextStyle(
                fontSize: 16,
                color: isDarkMode ? Colors.grey[300] : Colors.grey[800],
              ),
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 16),

            // Features Section
            Text(
              'Features',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildFeatureItem(
                  context,
                  '📢 Stay updated with the latest headlines.',
                ),
                _buildFeatureItem(
                  context,
                  '🔍 Search and discover news by category or keywords.',
                ),
                _buildFeatureItem(
                  context,
                  '🌟 Bookmark articles for easy access later.',
                ),
                _buildFeatureItem(
                  context,
                  '🌓 Switch between Light and Dark mode.',
                ),
              ],
            ),
            SizedBox(height: 16),

            // Team Section
            Text(
              'Our Team',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'We are a group of passionate developers, designers, and journalists dedicated to building a seamless news-reading experience. '
                  'Our goal is to create a platform that keeps you informed and empowered in today\'s fast-changing world.',
              style: TextStyle(
                fontSize: 16,
                color: isDarkMode ? Colors.grey[300] : Colors.grey[800],
              ),
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 16),

            // Footer
            Center(
              child: Text(
                'Thank you for choosing News Whiz!',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}