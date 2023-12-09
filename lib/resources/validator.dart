import 'package:f_quizz/models/language_constants.dart';
import 'package:flutter/material.dart';

class ValidatorUtils {
  static String? usernameValidator(BuildContext context, String? username) {
    if (username == null || username.isEmpty) {
      return translation(context).empty;
    }
    // Regular expressions for email and phone number
    final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
    final phoneRegex = RegExp(r'^\d{10}$'); // Assuming a 10-digit phone number
    if (!emailRegex.hasMatch(username) && !phoneRegex.hasMatch(username)) {
      return translation(context).password_format;
    }
    return null;
  }

  static String? passwordValidator(BuildContext context, String? password) {
  if (password == null || password.isEmpty) {
    return translation(context).empty;
  }
  final passwordRegex = RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{6,}$');
  if (!passwordRegex.hasMatch(password)) {
    return translation(context).password_characters;
  }
  return null; // Trả về null khi mật khẩu hợp lệ
}

  ///validate dữ liệu todo
  static String? todoValidate(BuildContext context, String? value) {
    if ((value ?? "").isEmpty) return translation(context).empty;
    return null;
  }
}