import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:laravel_test_api/services/user_services.dart';

class BookingScreen extends StatefulWidget {
  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  List<dynamic> myBooks = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final email = await getUserEmail();
    final response = await http.get(Uri.parse(
        'https://davs-apps-150658629956.herokuapp.com/api/my_bookings/${email}'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print(data);
      setState(() {
        myBooks = data['mybook'];
      });
    } else {
      // Handle error
      print('Failed to load data');
    }
  }

  Future<void> cancelBook() async {
    final email = await getUserEmail();
    final response = await http.get(Uri.parse(
        'https://davs-apps-150658629956.herokuapp.com/api/my_bookings/'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print(data);
      setState(() {
        myBooks = data['mybook'];
      });
    } else {
      // Handle error
      print('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'My Bookings',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: myBooks.length,
              itemBuilder: (context, index) {
                final book = myBooks[index];
                return SingleChildScrollView(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppointmentCard(
                          serviceName: book['services'] ?? '',
                          serviceBranch: book['branch'] ?? '',
                          serviceLocation: book['address'] ?? '',
                          selectedService: book['type'] ?? '',
                          selectedDateTime: book['appointment'] ?? '',
                          status: book['status'],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class AppointmentCard extends StatelessWidget {
  final String serviceName;
  final String serviceBranch;
  final String serviceLocation;
  final String selectedService;
  final String selectedDateTime;
  final String status;

  const AppointmentCard({
    required this.serviceName,
    required this.serviceBranch,
    required this.serviceLocation,
    required this.selectedService,
    required this.selectedDateTime,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Card(
          color: Colors.lightBlue[100],
          margin: const EdgeInsets.only(top: 10),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Name: $serviceName'),
                Text('Branch: $serviceBranch'),
                if (serviceLocation.isNotEmpty)
                  Text('Your Address: $serviceLocation'),
                Text('Type of Service: $selectedService'),
                Text('Appointment Date: $selectedDateTime'),
                Text('Status: $status'),
                // ElevatedButton(
                //   onPressed: () {
                //     // Implement the logic for canceling the appointment
                //     print('Appointment canceled!');
                //   },
                //   child: const Text('Cancel Appointment'),
                // ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
