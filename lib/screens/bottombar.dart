import 'package:flutter/material.dart';

class BottomBarWidget extends StatefulWidget {
  @override
  _BottomBarWidgetState createState() => _BottomBarWidgetState();
}

class _BottomBarWidgetState extends State<BottomBarWidget> {
  int _currentIndex = 0;

  final List<String> profiles = [
    "Profile 1",
    "Profile 2",
    "Profile 3",
    // Add more profiles as needed
  ];

  final List<String> services = [
    "Service 1",
    "Service 2",
    "Service 3",
    // Add more services as needed
  ];

  final List<String> subscriptions = [
    "Subscription 1",
    "Subscription 2",
    "Subscription 3",
    // Add more subscriptions as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dava'),
      ),
      body: Center(
        child: _currentIndex == 0
            ? _buildProfileList()
            : _currentIndex == 1
                ? _buildServicesList()
                : _buildSubscriptionsList(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profiles',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Services',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.subscriptions),
            label: 'Subscription',
          ),
        ],
      ),
    );
  }

  Widget _buildProfileList() {
    return ListView.builder(
      itemCount: profiles.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(profiles[index]),
          // You can add additional profile-related functionality here
        );
      },
    );
  }

  Widget _buildServicesList() {
    return ListView.builder(
      itemCount: services.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(services[index]),
          // You can add additional service-related functionality here
        );
      },
    );
  }

  Widget _buildSubscriptionsList() {
    return ListView.builder(
      itemCount: subscriptions.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(subscriptions[index]),
          // You can add additional subscription-related functionality here
        );
      },
    );
  }
}
