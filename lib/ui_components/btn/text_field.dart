import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String labelText;
  final TextEditingController controller;

  const CustomTextField({
    required this.labelText, 
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: Color(0xFF78746D),
      ),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(16),
        labelText: labelText,
        border: OutlineInputBorder(
          borderSide: BorderSide(width: 1, color: Color(0xFFBEBAB3)),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}