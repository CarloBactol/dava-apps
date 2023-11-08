import 'package:flutter/material.dart';
import 'package:laravel_test_api/constant.dart';
import 'package:laravel_test_api/models/api_response.dart';
import 'package:laravel_test_api/screens/home1.dart';
import 'package:laravel_test_api/screens/login.dart';
import 'package:laravel_test_api/services/user_services.dart';

class Loading extends StatefulWidget {
  const Loading({super.key});
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  void _loadUserInfo() async {
    print('test');
    // logout().then((value) => Navigator.of(context).pushAndRemoveUntil(
    //     MaterialPageRoute(builder: (context) => const Login()),
    //     (route) => false));
    String token = await getToken();
    print(token);

    if (token == '') {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const Login()),
          (route) => false);
    } else {
      ApiResponse response = await getUserDetails();
      print(response.data);
      if (token != '') {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => BottomNavigationApp()),
            (route) => false);
      } else if (response.error == unauthorize) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const Login()),
            (route) => false);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('${response.error}')));
      }
    }
  }

// Init
  void initState() {
    _loadUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      color: Colors.white,
      child: Center(child: CircularProgressIndicator()),
    );
  }
}
