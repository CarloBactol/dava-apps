import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:laravel_test_api/constant.dart';
import 'package:laravel_test_api/models/fc_animal.dart';
import 'package:laravel_test_api/services/user_services.dart';

class FCUserAnimals {
  static Future<List<Animals>> fetchAnimal() async {
    String token = await getToken();
    int id = await getUserId();
    final idString = id.toString();
    const url = "$baseURL/medical_records";
    final uri = Uri.parse(url);
    final response = await http.post(
      uri,
      headers: {'Accept': 'application/json'},
      body: {'id': idString},
    );
    final body = response.body;
    final json = jsonDecode(body);
    final results = json['animals'] as List<dynamic>;
    print(response.statusCode);
    final animals = results.map((e) {
      return Animals.fromMap(e);
    }).toList();
    return animals;
  }
}
