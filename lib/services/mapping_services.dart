import 'package:laravel_test_api/constant.dart';
import 'package:laravel_test_api/services/user_services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<dynamic>> fetchDataServices() async {
  String token = await getToken();
  final response = await http.get(Uri.parse('$baseURL/services'), headers: {
    'Accept': 'application/json',
    'Authorization': 'Bearer $token'
  });
  if (response.statusCode == 200) {
    final jsonData = json.decode(response.body);
    print(jsonData);
    return jsonData;
  } else {
    throw Exception('Failed to load services data');
  }
}
