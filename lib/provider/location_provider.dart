import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:laravel_test_api/constant.dart';
import 'package:laravel_test_api/models/location_m.dart';
import 'package:laravel_test_api/services/user_services.dart';

class LocationProvider extends ChangeNotifier {
  List<Service> _allServices = [];
  List<Service> _filteredServices = [];

  List<Service> get services => _filteredServices;

  Future<void> fetchServices() async {
    String token = await getToken();
    const apiUrl = '$baseURL/services';
    final response = await http.get(Uri.parse(apiUrl), headers: {
      "Accept": "application/json",
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      _allServices.clear();
      _allServices = data.map((item) => Service.fromJson(item)).toList();
      _filteredServices.clear();
      _filteredServices = _allServices;
    } else {
      // Handle error, maybe show an error message or log the error
      print('Failed to load services');
    }
    notifyListeners();
  }

  void filterServices(String query) {
    if (_allServices.isEmpty) {
      // Fetch services if not already loaded
      fetchServices();
    }

    if (query.isEmpty) {
      _filteredServices = _allServices;
    } else {
      _filteredServices = _allServices
          .where((service) =>
              service.content.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  void reset() {
    _filteredServices = [];
    notifyListeners();
  }
}
