import 'package:flutter/material.dart';
import 'package:f_quizz/ui_components/btn/warningDialog.dart';


class ButtonPrimary extends StatelessWidget {
  const ButtonPrimary({super.key, required this.textButton});

  final String textButton;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: ElevatedButton(
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            )),
            backgroundColor: MaterialStateProperty.all(Colors.red),
            padding: MaterialStateProperty.all(
                EdgeInsets.symmetric(vertical: 16, horizontal: 32)),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(textButton,
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w500))),
    );
  }
}
