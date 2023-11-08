import 'package:flutter/material.dart';
import 'package:laravel_test_api/screens/forgot_password.dart';
import 'package:laravel_test_api/screens/home1.dart';
import 'package:laravel_test_api/widgets/browse_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:laravel_test_api/constant.dart';
import 'package:laravel_test_api/models/api_response.dart';
import 'package:laravel_test_api/models/users.dart';
import 'package:laravel_test_api/screens/register.dart';
import 'package:laravel_test_api/services/user_services.dart';

class Login extends StatefulWidget {
  const Login({super.key});
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  bool loading = false;

  void _loginUser() async {
    ApiResponse response = await login(txtEmail.text, txtPassword.text);
    if (response.error == null) {
      _saveAndRedirectToHome(response.data as User);
    } else {
      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${response.error}'),
      ));
    }
  }

  void _saveAndRedirectToHome(User user) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('token', user.token ?? '');
    var email = user.email;
    storeUserEmail(email!);
    await pref.setInt('userId', user.id ?? 0);
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => BottomNavigationApp(),
        ),
        (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        centerTitle: true,
      ),
      body: Form(
        key: formKey,
        child: ListView(
          padding: EdgeInsets.all(32),
          children: [
            TextFormField(
                keyboardType: TextInputType.emailAddress,
                controller: txtEmail,
                validator: (val) =>
                    val!.isEmpty ? 'Invalid email address' : null,
                decoration: KInputDecoration('Email')),
            SizedBox(height: 10),
            TextFormField(
              controller: txtPassword,
              obscureText: true,
              validator: (val) =>
                  val!.isEmpty ? 'Required at least 6 chars' : null,
              decoration: KInputDecoration('Password'),
            ),
            SizedBox(height: 10),
            loading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : KTextButton('Login', () {
                    if (formKey.currentState!.validate()) {
                      setState(() {
                        loading = true;
                        _loginUser();
                      });
                    }
                  }),
            const SizedBox(
              height: 10,
            ),
            KloginRegisterHint('Dont have account! ', 'Register', () {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const Register()),
                  (route) => false);
            }),
            const SizedBox(height: 16),
          ],
        ),
      ),
      floatingActionButton: ForgotPassword(),
    );
  }
}
