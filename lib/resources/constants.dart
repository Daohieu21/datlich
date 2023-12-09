
import 'dart:convert';
import 'package:crypto/crypto.dart';

// bool isNameValid(String name) {
//   return name.length >= 4;
// }
// bool isEmailValid(String value) {
//   RegExp emailRegExp = RegExp(r"^[a-zA-Z0-9._]+@[a-zA-Z0-9]+\.[a-zA-Z]+$");
//   RegExp phoneRegExp = RegExp(r'^\+?\d{1,4}?[-.\s]?\(?\d{1,3}\)?[-.\s]?\d{1,4}[-.\s]?\d{1,9}$');
//   return emailRegExp.hasMatch(value ?? "") || phoneRegExp.hasMatch(value ?? "");
// }
// bool isPasswordValid(String password) {
//   RegExp passwordRegExp = RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{6,}$');
//   return passwordRegExp.hasMatch(password);
// }


class DBConstants {
  static const String ACCOUNT = "ACCOUNT";
  static const String USER_INFO = "USER_INFO";
}

String md5X(String password) =>
    md5.convert(utf8.encode(password)).toString();

// String md5X(String password) {
//   var bytes = utf8.encode(password);
//   var digest = md5.convert(bytes);
//   return digest.toString();
// }