import 'package:flutter/material.dart';
import 'package:laravel_test_api/screens/bottom_navigation_app.dart';

class ProcessCard extends StatelessWidget {
  final String title;
  final String message;

  ProcessCard({
    required this.title,
    required this.message,
  });

  void _navigateToHome(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => BottomNavigationApp()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Card(
          elevation: 10,
          margin: EdgeInsets.all(20),
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(196, 209, 198, 100),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => _navigateToHome(context),
                  child: Text('Back to Home'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
