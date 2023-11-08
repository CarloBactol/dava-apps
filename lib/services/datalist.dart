import 'package:http/http.dart' as http;
import 'package:laravel_test_api/constant.dart';
import 'dart:convert';

import 'package:laravel_test_api/services/user_services.dart';

Future<List<dynamic>> fetchData() async {
  String token = await getToken();
  final response = await http.get(Uri.parse('$baseURL/services'), headers: {
    'Accept': 'application/json',
    'Authorization': 'Bearer $token'
  });

  if (response.statusCode == 200) {
    print("yes");
    final jsonData = json.decode(response.body);
    print(jsonData);
    return jsonData;
  } else {
    throw Exception('Failed to load profile data');
  }
}
