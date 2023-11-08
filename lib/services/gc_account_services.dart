import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:laravel_test_api/models/gc_account.dart';

class Account {
  static Future<GcashAccount> fetchAccount() async {
    const url = 'https://davs-apps-150658629956.herokuapp.com/api/account';
    final response = await http.get(Uri.parse(url), headers: {
      'Accept': 'application/json',
    });

    if (response.statusCode == 200) {
      print(response.statusCode);
      final jsonData = json.decode(response.body);
      return GcashAccount.fromJson(jsonData);
    } else {
      throw Exception('Failed to load account data');
    }
  }
}
