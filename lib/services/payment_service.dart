// lib/services/payment_service.dart
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:laravel_test_api/constant.dart';
import 'package:laravel_test_api/models/payment_model.dart';

class PaymentService {
  static Future<Payment> submitPayment(
      String email, String phoneNo, String amount, String referenceNo) async {
    final apiUrl = '$baseURL/payment';
    final response = await http.post(
      Uri.parse(apiUrl),
      body: {
        'email': email,
        'phone_no': phoneNo,
        'amount': amount,
        'reference_no': referenceNo,
        'status': '0',
      },
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final paymentData = jsonDecode(response.body);
      print(response.statusCode);
      print(paymentData);
      return Payment.fromJson(paymentData);
    } else {
      print(response.statusCode);
      final error = jsonDecode(response.body)['errors'];
      final errorMessage = error[error.keys.elementAt(0)][0];
      throw Exception(errorMessage);
    }
  }
}
