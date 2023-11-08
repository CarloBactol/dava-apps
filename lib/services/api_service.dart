import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:laravel_test_api/services/user_services.dart';

import '../models/profile_model.dart';

class ApiService {
  final String baseUrl;

  ApiService(this.baseUrl);

  Future<Profile> fetchProfile() async {
    String token = await getToken();
    final response = await http.get(Uri.parse('$baseUrl/user'), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });

    if (response.statusCode == 200) {
      print("yes");
      final jsonData = json.decode(response.body);
      print(jsonData);
      return Profile.fromJson(jsonData);
    } else {
      throw Exception('Failed to load profile data');
    }
  }
}
