import 'package:flutter/src/widgets/framework.dart';

class BookingsM {
  String branch;
  String services;
  String appointment;
  String status;

  BookingsM({
    required this.branch,
    required this.services,
    required this.appointment,
    required this.status,
  });

  factory BookingsM.fromJson(Map<String, dynamic> json) {
    return BookingsM(
      branch: json['branch'],
      services: json['services'],
      appointment: json['appointment'],
      status: json['status'],
    );
  }
}
