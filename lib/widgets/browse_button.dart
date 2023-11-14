import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

final Uri _url =
    Uri.parse('https://dava-93d325f7c120.herokuapp.com/password/reset');

class ForgotPassword extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // return const ElevatedButton(
    //   onPressed: _launchUrl,
    //   child: Text(
    //     'forgot Password',
    //     style: TextStyle(fontSize: 15),
    //   ),
    // );
    return const FloatingActionButton(
      onPressed: _launchUrl,
      child: Icon(Icons.lock),
    );
  }
}

Future<void> _launchUrl() async {
  if (!await launchUrl(_url)) {
    throw Exception('Could not launch $_url');
  }
}
