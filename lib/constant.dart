import 'package:flutter/material.dart';

// const baseURL = 'https://laravel-flutter-ff26614def02.herokuapp.com/api';
const baseURL = 'https://dava-93d325f7c120.herokuapp.com/api';
const loginURL = baseURL + '/login';
const registerURL = baseURL + '/register';
const logoutURL = baseURL + '/logout';
const forgetpassURL = baseURL + '/password/reset';
const userURL = baseURL + '/user';
const postsURL = baseURL + '/posts';
const services = baseURL + '/services';

// Server Error
const serverError = 'Server Error';
const unauthorize = 'Unauthorize';
const somethingWentWrong = 'Something went wrong, please try again!';

// Input Text
InputDecoration KInputDecoration(String label) {
  return InputDecoration(
    labelText: label,
    contentPadding: EdgeInsets.all(10),
    border: OutlineInputBorder(
        borderSide: BorderSide(width: 1, color: Colors.black)),
  );
}

// TextButton
TextButton KTextButton(String label, Function onPressed) {
  return TextButton(
    child: Text(label, style: TextStyle(color: Colors.white)),
    style: ButtonStyle(
        backgroundColor:
            MaterialStateColor.resolveWith((states) => Colors.blue),
        padding: MaterialStateProperty.resolveWith(
            (states) => EdgeInsets.symmetric(vertical: 10))),
    onPressed: () => onPressed(),
  );
}

// LoginRegisterHint
Row KloginRegisterHint(String text, String label, Function onTap) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(text),
      GestureDetector(
        child: Text(label, style: TextStyle(color: Colors.blue)),
        onTap: () => onTap(),
      )
    ],
  );
}

Text Ktext(String text) {
  return Text(text);
}
