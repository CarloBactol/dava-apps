import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:laravel_test_api/models/booking_model.dart';
import 'package:laravel_test_api/services/user_services.dart';

class BookingProvider extends ChangeNotifier {
  List<BookingsM> _bookings = [];
  List<BookingsM> _filteredBookings = [];

  List<BookingsM> get bookings => _filteredBookings;

  Future<void> fetchServices() async {
    String token = await getToken();
    const apiUrl = 'https://davs-apps-150658629956.herokuapp.com/api/services';
    final response = await http.get(Uri.parse(apiUrl), headers: {
      "Accept": "application/json",
    });
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      _bookings.clear();
      _bookings = data.map((item) => BookingsM.fromJson(item)).toList();
      _filteredBookings.clear();
      _filteredBookings = _bookings;
    } else {
      // Handle error, maybe show an error message or log the error
      print('Failed to load services');
    }
    notifyListeners();
  }

  void filterServices(String query) {
    if (_bookings.isEmpty) {
      // Fetch services if not already loaded
      fetchServices();
    }

    if (query.isEmpty) {
      _filteredBookings = _bookings;
    } else {
      _filteredBookings = _bookings
          .where((service) =>
              service.appointment.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }
}
