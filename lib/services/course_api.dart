import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:laravel_test_api/models/course.dart';

class CourseApi {
  static Future<List<Course>> fetchCourse() async {
    const url = "https://davs-apps-150658629956.herokuapp.com/api/course_apis";
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final body = response.body;
    final json = jsonDecode(body);
    final results = json['course'] as List<dynamic>;

    final course = results.map((e) {
      return Course(
        name: e['name'],
        imageURL: e['imageURL'],
        description: e['description'],
      );
    }).toList();
    return course;
  }
}
