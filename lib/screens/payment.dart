import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:laravel_test_api/constant.dart';
import 'package:laravel_test_api/screens/home1.dart';
import 'package:laravel_test_api/screens/pending_payments.dart';
import 'package:laravel_test_api/screens/subscriptions.dart';
import 'package:laravel_test_api/services/payment_service.dart';
import 'package:laravel_test_api/services/user_services.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({Key? key}) : super(key: key);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController numberController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController referenceController = TextEditingController();
  bool loading = false;

  Future<void> _submitForm() async {
    final email = await getUserEmail();
    final number = numberController.text;
    final amount = amountController.text;
    final reference = referenceController.text;

    setState(() {
      loading = true;
    });

    try {
      final payment =
          await PaymentService.submitPayment(email, number, amount, reference);
      setState(() {
        loading = false;
      });

      // Data sent successfully
      print('Data sent successfully');
      storePaymentStatus(email);
      numberController.clear();
      amountController.clear();
      referenceController.clear();
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Payment sent successfully'),
      ));
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => BottomNavigationScreen(),
        ),
        (route) => false,
      );
    } catch (e) {
      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
      ));
    }
  }

  @override
  void dispose() {
    numberController.dispose();
    amountController.dispose();
    referenceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payments'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              SizedBox(height: 20),
              PaymentInputField(
                controller: amountController,
                hintText: 'Amount',
                validator: (value) {
                  if (value!.isEmpty || value.trim() == '0') {
                    return 'Amount is required and cannot be zero';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              PaymentInputField(
                controller: numberController,
                hintText: 'Phone No.',
                validator: (value) {
                  if (value!.isEmpty || value.trim().length != 11) {
                    return 'Phone No. must be 11 digits';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              PaymentInputField(
                controller: referenceController,
                hintText: 'Reference No.',
                validator: (value) {
                  if (value!.isEmpty || value.trim().length != 13) {
                    return 'Reference No. must be 13 digits';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              loading
                  ? const SpinKitCircle(color: Colors.blue)
                  : ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          _submitForm();
                        }
                      },
                      child: const Text('Pay'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

class PaymentInputField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final FormFieldValidator<String>? validator;

  PaymentInputField({
    required this.controller,
    required this.hintText,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLength: hintText == 'Phone No.' ? 11 : 13,
      validator: validator,
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
      ],
      decoration: KInputDecoration(hintText),
    );
  }
}
