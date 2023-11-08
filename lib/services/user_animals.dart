import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:laravel_test_api/services/user_services.dart';

import '../models/animal.dart';

class UserAnimals {
  static Future<List<Animal>> fetchAnimal() async {
    String token = await getToken();
    int id = await getUserId();
    final idString = id.toString();
    const url = "https://davs-apps-150658629956.herokuapp.com/api/animal";
    final uri = Uri.parse(url);
    final response = await http.post(
      uri,
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
      body: {'owner_id': idString},
    );
    final body = response.body;
    final json = jsonDecode(body);
    final results = json['animals'] as List<dynamic>;

    final animals = results.map((e) {
      final owner = Owner(owneremail: e['owner']['owner_email']);
      final veterinarian = Veterinarian(
          veterinarianemail: e['medical_records']['veterinarian']
              ['veterinarian_email']);

      final medicalrecord = Medicalrecord(
        procedure: e['medical_records']['procedure'],
        typeofprocedure: e['medical_records']['type_of_procedure'],
        cost: e['medical_records']['cost'],
        notes: e['medical_records']['notes'],
        createdat: e['medical_records']['created_at'],
        veterinarian: veterinarian,
      );
      return Animal(
        name: e['name'],
        species: e['species'],
        breed: e['breed'],
        gender: e['gender'],
        color: e['color'],
        dob: e['date_of_birth'],
        medicalrecords: medicalrecord,
        owneremail: owner,
      );
    }).toList();
    return animals;
  }
}
