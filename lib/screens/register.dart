import 'package:flutter/material.dart';
import 'package:laravel_test_api/screens/home1.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:laravel_test_api/constant.dart';
import 'package:laravel_test_api/models/api_response.dart';
import 'package:laravel_test_api/models/users.dart';
import 'package:laravel_test_api/screens/login.dart';
import 'package:laravel_test_api/services/user_services.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController newtxtEmail = TextEditingController();
  TextEditingController newtxtPassword = TextEditingController();
  TextEditingController newtxtPasswordConfirmed = TextEditingController();
  TextEditingController newtxtName = TextEditingController();
  TextEditingController newFirstName = TextEditingController();
  TextEditingController newLastName = TextEditingController();
  TextEditingController ctrAddress = TextEditingController();
  TextEditingController ctrPhoneNumber = TextEditingController();
  bool loading = false;

  void _registerUser() async {
    ApiResponse response = await register(
        newFirstName.text,
        newLastName.text,
        newtxtEmail.text,
        ctrAddress.text,
        ctrPhoneNumber.text,
        newtxtPassword.text);
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
    await pref.setInt('userId', user.id ?? 0);
    storeUserEmail(user.email!);
    print(user.email);
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
        title: Text('Register'),
        centerTitle: true,
      ),
      body: Form(
          key: formKey,
          child: ListView(
            padding: EdgeInsets.all(32),
            children: [
              TextFormField(
                  controller: newFirstName,
                  validator: (val) => val!.isEmpty ? 'Invalid firstname' : null,
                  decoration: KInputDecoration('Firstname')),
              SizedBox(height: 10),
              TextFormField(
                  controller: newLastName,
                  validator: (val) => val!.isEmpty ? 'Invalid lastname' : null,
                  decoration: KInputDecoration('Lastname')),
              SizedBox(height: 10),
              TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: newtxtEmail,
                  validator: (val) {
                    if (val!.isEmpty ||
                        !val.trim().contains('@') ||
                        !val.trim().contains('.')) {
                      return 'Invalid email address';
                    }
                    return null;
                  },
                  decoration: KInputDecoration('Email')),
              const SizedBox(height: 10),
              TextFormField(
                  controller: ctrAddress,
                  validator: (val) {
                    if (val!.isEmpty || val.trim().length > 100) {
                      return 'Max length is not greater than 100 characters';
                    }
                    return null;
                  },
                  decoration: KInputDecoration('Address')),
              const SizedBox(height: 10),
              TextFormField(
                  controller: ctrPhoneNumber,
                  maxLength: 11,
                  validator: (val) {
                    if (val!.isEmpty || val.trim().length > 11) {
                      return 'Max length is not greater than 20 characters';
                    }
                    return null;
                  },
                  decoration: KInputDecoration('Phone No.')),
              SizedBox(height: 10),
              TextFormField(
                controller: newtxtPassword,
                obscureText: true,
                validator: (val) =>
                    val!.isEmpty ? 'Required at least 6 chars' : null,
                decoration: KInputDecoration('Password'),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: newtxtPasswordConfirmed,
                obscureText: true,
                validator: (val) => val != newtxtPassword.text
                    ? 'Confirm password did not match!'
                    : null,
                decoration: KInputDecoration('Confirmed Password'),
              ),
              SizedBox(height: 10),
              loading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : KTextButton('Register', () {
                      if (formKey.currentState!.validate()) {
                        setState(() {
                          loading = true;
                          _registerUser();
                        });
                      }
                    }),
              SizedBox(
                height: 10,
              ),
              KloginRegisterHint('Already have account! ', 'Login', () {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const Login()),
                    (route) => false);
              }),
            ],
          )),
    );
  }
}
