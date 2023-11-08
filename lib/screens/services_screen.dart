import 'package:flutter/material.dart';

void main() => runApp(ServiceInfoApp());

class ServiceInfoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ServiceInfoScreen(),
    );
  }
}

class ServiceInfoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Service Information'),
      ),
      body: Center(
        child: ServiceCard(),
      ),
    );
  }
}

class ServiceCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          Image.asset(
            'assets/pet.png', // Replace with your image asset path
            fit: BoxFit.cover,
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Service Name',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Description of the service goes here. You can provide more details about the service in this section.',
              style: TextStyle(fontSize: 16.0),
            ),
          ),
        ],
      ),
    );
  }
}
