import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:laravel_test_api/constant.dart';
import 'package:laravel_test_api/models/services.dart';

class ServiceApi {
  static Future<List<ServiceModel>> fetchService() async {
    const url = "$baseURL/home_treatments";
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final body = response.body;
    final json = jsonDecode(body);
    final results = json['services'] as List<dynamic>;

    final services = results.map((e) {
      return ServiceModel(
        name: e['name'],
        status: e['status'],
        description: e['description'],
      );
    }).toList();
    return services;
  }
}
