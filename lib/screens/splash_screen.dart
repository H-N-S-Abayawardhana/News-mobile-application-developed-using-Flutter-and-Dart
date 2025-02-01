import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Navigate to HomeScreen after 3 seconds
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/homeScreen');
    });

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white, // Background color
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Logo
            Image.asset(
              'assets/images/Logo.png', // Path to your logo in assets
              height: 250,
              width: 250,
            ),
            SizedBox(height: 80),
            // App Slogan
            Text(
              'Soar Above the Rest, Stay Informed.',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                  color: Color(0xFF510298),
              ),
            ),
            SizedBox(height: 100),
            // Spinner
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF510298)),
            ),
          ],
        ),
      ),
    );
  }
}
