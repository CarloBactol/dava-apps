import 'package:flutter/material.dart';
import 'package:laravel_test_api/constant.dart';
import 'package:laravel_test_api/services/user_services.dart';
import 'package:http/http.dart' as http;

class SubscriptionData {
  bool isButtonEnabled;
  bool isVerified;

  SubscriptionData({required this.isButtonEnabled, required this.isVerified});
}

class SubscriptionDataProvider extends ChangeNotifier {
  SubscriptionData _data =
      SubscriptionData(isButtonEnabled: true, isVerified: false);

  SubscriptionData get data => _data;

  Future<void> checkStatus() async {
    final email = await getUserEmail();
    final response = await http
        .get(Uri.parse('$baseURL/user_status?email=$email'), headers: {
      'Accept': 'application/json',
    });
    if (response.statusCode == 200) {
      _data.isButtonEnabled = false;
      _data.isVerified = true;
    } else {
      _data.isButtonEnabled = true;
      _data.isVerified = false;
    }
    notifyListeners();
  }
}
