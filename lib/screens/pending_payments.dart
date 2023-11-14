import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:laravel_test_api/constant.dart';
import 'package:laravel_test_api/screens/bottom_navigation_app.dart';
import 'package:laravel_test_api/screens/process_premium.dart';
import 'package:laravel_test_api/screens/success_premium.dart';
import 'package:laravel_test_api/services/user_services.dart';

class PendingPayments extends StatefulWidget {
  const PendingPayments({Key? key}) : super(key: key);

  @override
  State<PendingPayments> createState() => _PendingPaymentsState();
}

class _PendingPaymentsState extends State<PendingPayments> {
  bool isPaid = false;

  @override
  void initState() {
    super.initState();
    _checkPaymentStatus();
  }

  Future<void> _checkPaymentStatus() async {
    String email = await getUserEmail();

    final response = await http.get(
      Uri.parse('$baseURL/user_status?email=$email'),
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final status = jsonDecode(response.body)['status'];
      setState(() {
        isPaid = (status == '0');
      });
    }
  }

  void _navigateToHome(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => BottomNavigationApp(),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Status'),
        actions: [
          IconButton(
            onPressed: () => _navigateToHome(context),
            icon: const Icon(Icons.home),
          ),
        ],
      ),
      body: isPaid
          ? ProcessCard(
              title: 'Pending',
              message:
                  'Once your payment has been approved, you may take advantage of free pet vaccinations and healthcare information.',
            )
          : PremiumCard(
              title: 'Congrats',
              description:
                  'You can now enjoy free pet vaccinations and healthcare information.',
            ),
    );
  }
}
