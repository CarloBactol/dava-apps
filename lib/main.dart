import 'package:flutter/material.dart';
import 'package:laravel_test_api/models/subscription_data.dart';
import 'package:laravel_test_api/screens/getstarted.dart';
import 'package:laravel_test_api/screens/loading.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    // MultiProvider(
    //   providers: [
    //     ChangeNotifierProvider(create: (context) => SubscriptionDataProvider()),
    //   ],
    //   child: MyApp(),
    // ),
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/getstarted', // Set the initial route to GetStartedScreen
      routes: {
        '/getstarted': (context) => GetStarted(),
        '/loading': (context) => Loading(),
      },
    );
  }
}
