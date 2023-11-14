import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:laravel_test_api/constant.dart';
import 'package:laravel_test_api/models/user_profile.dart';
import 'package:laravel_test_api/services/user_services.dart';

class UserProfileApi {
  static Future<UserProfile> fetchProfileApi() async {
    String token = await getToken();
    final email = await getUserEmail();
    const url = '$baseURL/user_profile';
    final response = await http.post(Uri.parse(url), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    }, body: {
      'email': email
    });

    if (response.statusCode == 200) {
      print("yes");
      final jsonData = json.decode(response.body);
      print(jsonData);
      return UserProfile.fromJson(jsonData);
    } else {
      throw Exception('Failed to load profile data');
    }
  }
}
