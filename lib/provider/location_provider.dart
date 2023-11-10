import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:laravel_test_api/models/location_m.dart';

class LocationProvider extends ChangeNotifier {
  List<Service> _allServices = [];
  List<Service> _filteredServices = [];

  List<Service> get services => _filteredServices;

  Future<void> fetchServices() async {
    const token = '1|DW91eNQ9HE1DeR7gJ72DgKa1BqX7Bbd56yJeg5Fi';
    const apiUrl = 'https://davs-apps-150658629956.herokuapp.com/api/services';
    final response = await http.get(Uri.parse(apiUrl), headers: {
      "Accept": "application/json",
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      _allServices = data.map((item) => Service.fromJson(item)).toList();
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
