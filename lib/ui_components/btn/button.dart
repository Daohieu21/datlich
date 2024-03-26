import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  const Button({
  super.key, 
  required this.textButton, 
  required this.onTap});

  final String textButton;
  final void Function()? onTap;
 

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          )),
          backgroundColor: MaterialStateProperty.all(Colors.blue),
          padding: MaterialStateProperty.all(
              const EdgeInsets.symmetric(vertical: 16, horizontal: 32)),
        ),
        onPressed: onTap,
        child: Text(textButton, style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'Rubik',
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
    )),
      ),
    );
  }
} 