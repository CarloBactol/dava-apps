import 'package:flutter/material.dart';
import 'package:laravel_test_api/provider/booking_provider.dart';
import 'package:laravel_test_api/provider/location_provider.dart';
import 'package:laravel_test_api/screens/getstarted.dart';
import 'package:laravel_test_api/screens/loading.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => LocationProvider()),
      ChangeNotifierProvider(create: (_) => BookingProvider()),
    ],
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      // initialRoute: '/getstarted',
      // routes: {
      //   '/getstarted': (context) => const GetStarted(),
      //   '/loading': (context) => const Loading()
      // },
      home: MyApp(),
    ),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      initialRoute: '/getstarted', // Set the initial route to GetStartedScreen
      routes: {
        '/getstarted': (context) => GetStarted(),
        '/loading': (context) => Loading(),
      },
    );
  }
}
