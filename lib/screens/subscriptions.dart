import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:laravel_test_api/constant.dart';
import 'package:laravel_test_api/models/gc_account.dart';
import 'package:laravel_test_api/screens/payment.dart';
import 'package:laravel_test_api/screens/pending_payments.dart';
import 'package:laravel_test_api/services/gc_account_services.dart';
import 'package:laravel_test_api/services/user_services.dart';

class Subscriptions extends StatefulWidget {
  @override
  State<Subscriptions> createState() => _SubscriptionsState();
}

class _SubscriptionsState extends State<Subscriptions> {
  bool isButtonEnabled = true;
  bool isVerified = false;
  bool isStatus = false;

  @override
  void initState() {
    super.initState();
    _checkStatus();
  }

  Future<void> _checkStatus() async {
    final email = await getUserEmail();

    final response =
        await http.post(Uri.parse('$baseURL/user_status'), headers: {
      'Accept': 'application/json',
    }, body: {
      'email': email,
    });

    print(response.statusCode);
    final body = response.body;
    final json = jsonDecode(body);
    final status = json['status'];

    if (status == '1') {
      setState(() {
        isStatus = true;
      });
    } else {
      setState(() {
        isStatus = false;
      });
    }

    if (response.statusCode == 200) {
      setState(() {
        isButtonEnabled = false;
        isVerified = true;
      });
    } else {
      setState(() {
        isButtonEnabled = true;
        isVerified = false;
      });
    }
  }

  void _submitForm() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const PaymentScreen()));
  }

  void _gotoStatusPayment() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const PendingPayments()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<GcashAccount>(
        future: fetchAccount(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: SpinKitCircle(color: Colors.blue));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final acc = snapshot.data;
            return Column(
              children: [
                SubscriptionButtons(
                  data: acc,
                  isStatus: isStatus,
                  isButtonEnabled: isButtonEnabled,
                  isVerified: isVerified,
                  onSubmitForm: _submitForm,
                  onGotoStatusPayment: _gotoStatusPayment,
                ),
              ],
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: isButtonEnabled ? Colors.blue : Colors.grey[400],
        onPressed: isButtonEnabled ? _submitForm : null,
        child: isButtonEnabled
            ? Icon(Icons.credit_card_rounded)
            : Icon(Icons.verified),
      ),
    );
  }
}

Future<GcashAccount> fetchAccount() async {
  final res = await Account.fetchAccount();
  return res;
}

class SubscriptionButtons extends StatelessWidget {
  final bool isButtonEnabled;
  final bool isVerified;
  final bool isStatus;
  final VoidCallback onSubmitForm;
  final VoidCallback onGotoStatusPayment;
  final GcashAccount data;

  SubscriptionButtons({
    required this.isButtonEnabled,
    required this.isVerified,
    required this.isStatus,
    required this.onSubmitForm,
    required this.onGotoStatusPayment,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      color: Colors.blue[100],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          const CircleAvatar(
            radius: 70,
            backgroundImage: AssetImage('assets/vaccine_pet.png'),
          ),
          const SizedBox(height: 10),
          SubscriptionCard(
            isProcess: false,
            title: 'Free Vaccine 💉🐶',
            subtitle:
                'Subscribe now and receive a complimentary dose of valuable pet healthcare knowledge, and as a special bonus, enjoy a free vaccine for your furry friend.',
          ),
          SubscriptionCard(
            isProcess: false,
            title: 'Gcash Account',
            subtitle:
                '${data.accountName} \n ${data.accountNumber} \n Amount: ${data.cost} PHP',
          ),
          isButtonEnabled
              ? Text('')
              : isStatus
                  ? SubscriptionCard(
                      isProcess: false,
                      title: 'Congrats',
                      subtitle: 'Your are now subscriber ✔️')
                  : SubscriptionCard(
                      isProcess: true,
                      title: 'Processing',
                      subtitle: 'Your payment is under review...'),
        ],
      ),
    );
  }
}

class SubscriptionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isProcess;

  SubscriptionCard({
    required this.title,
    required this.subtitle,
    required this.isProcess,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isProcess ? Colors.yellow[100] : Colors.blue[50],
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontStyle: FontStyle.italic,
          ),
          textAlign: TextAlign.center,
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 15,
            color: Colors.black,
            fontStyle: FontStyle.italic,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class SubscriptionButton extends StatelessWidget {
  final bool isEnabled;
  final Icon icon;
  final String label;
  final VoidCallback? onPressed;

  SubscriptionButton({
    required this.isEnabled,
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Center(child: icon),
        label: Text(label),
        style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.all(isEnabled ? Colors.blue : Colors.grey),
        ),
      ),
    );
  }
}
