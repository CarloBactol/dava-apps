import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:laravel_test_api/constant.dart';
import 'package:laravel_test_api/models/api_response.dart';
import 'package:http/http.dart' as http;
import 'package:laravel_test_api/models/users.dart';

Future<ApiResponse> login(String email, String password) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    final response = await http.post(Uri.parse(loginURL),
        headers: {'Accept': 'application/json'},
        body: {'email': email, 'password': password});

    switch (response.statusCode) {
      case 200:
        apiResponse.data = User.fromJson(jsonDecode(response.body));
        break;
      case 422:
        final error = jsonDecode(response.body)['errors'];
        apiResponse.error = error[error.keys.elementAt(0)][0];
        break;
      case 403:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    apiResponse.error = serverError;
  }
  return apiResponse;
}

// Register
Future<ApiResponse> register(String firstname, String lastname, String email,
    String address, String phoneNumber, String password) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    final response = await http.post(Uri.parse(registerURL), headers: {
      'Accept': 'application/json'
    }, body: {
      'first_name': firstname,
      'last_name': lastname,
      'email': email,
      'address': address,
      'phone_number': phoneNumber,
      'password': password,
      'password_confirmation': password,
    });

    switch (response.statusCode) {
      case 200:
        apiResponse.data = User.fromJson(jsonDecode(response.body));
        break;
      case 422:
        final error = jsonDecode(response.body)['errors'];
        apiResponse.error = error[error.keys.elementAt(0)][0];
        break;
      case 403:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    apiResponse.error = serverError;
  }
  return apiResponse;
}

// Get Users Details
Future<ApiResponse> getUserDetails() async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.get(Uri.parse(userURL), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });

    switch (response.statusCode) {
      case 200:
        apiResponse.data = User.fromJson(jsonDecode(response.body));
        break;
      case 422:
        final error = jsonDecode(response.body)['errors'];
        apiResponse.error = error[error.keys.elementAt(0)][0];
        break;
      case 403:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    apiResponse.error = serverError;
  }
  return apiResponse;
}

// get Token
Future<String> getToken() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getString('token') ?? '';
}

// get UserId
Future<int> getUserId() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getInt('userId') ?? 0;
}

// store Email
Future<void> storeUserEmail(String email) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('user_email', email);
}

// get Email
Future<String> getUserEmail() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('user_email') ?? '';
}

// store payment status
Future<void> storePaymentStatus(String status) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('status', status);
}

//get payment Status
Future<String> getPaymentStatus() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('status') ?? '';
}

// logout
Future<bool> logout() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.remove('token');
}

// Get base64 encoded image
String? getStringImage(File? file) {
  if (file == null) return null;
  return base64Encode(file.readAsBytesSync());
}
