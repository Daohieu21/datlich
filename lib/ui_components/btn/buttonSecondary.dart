import 'package:flutter/material.dart';


class ButtonSecondary extends StatelessWidget {
  const ButtonSecondary({super.key, required this.textButton});

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
                    side: BorderSide(color: Colors.red, width: 2))),
            backgroundColor: MaterialStateProperty.all(Colors.white),
            padding: MaterialStateProperty.all(
                EdgeInsets.symmetric(vertical: 16, horizontal: 32)),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(textButton,
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.w500))),
    );
  }
}
