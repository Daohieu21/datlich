import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final AutovalidateMode autovalidateMode;
  final String? Function(String?)? validator;
  final bool obscureText;
  final TextStyle style;
  final InputDecoration decoration;

  const CustomTextFormField({
    Key? key,
    required this.controller,
    required this.autovalidateMode,
    required this.validator,
    required this.obscureText,
    required this.style,
    required this.decoration,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      autovalidateMode: autovalidateMode,
      validator: validator,
      obscureText: obscureText,
      style: style,
      decoration: decoration,
    );
  }
}