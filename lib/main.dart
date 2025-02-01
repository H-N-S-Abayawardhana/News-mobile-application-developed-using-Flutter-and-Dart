import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/news_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/bookmarked_provider.dart';
import 'screens/splash_screen.dart';
import 'screens/home_screen.dart';
import 'screens/all_news_screen.dart';
import 'screens/news_category_screen.dart';
import 'screens/news_bookmarked.dart';
import 'screens/aboutus_news_whiz.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NewsProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => BookmarkedProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'News App',
          theme: ThemeData.light().copyWith(
            primaryColor: Colors.blue,
            scaffoldBackgroundColor: Colors.white,
          ),
          darkTheme: ThemeData.dark().copyWith(
            primaryColor: Colors.blue,
            scaffoldBackgroundColor: Colors.black,
          ),
          themeMode: themeProvider.themeMode,
          initialRoute: '/',
          routes: {
            '/': (context) => SplashScreen(),
            '/homeScreen': (context) => HomeScreen(),
            '/allNewsScreen': (context) => AllNewsScreen(),
            '/newscategory': (context) => NewsCategoryScreen(),
            '/bookmarkednews': (context) => NewsBookmarkedScreen(),
            '/aboutusnewswhiz': (context) => AboutUsNewswhiz(),
          },
        );
      },
    );
  }
}