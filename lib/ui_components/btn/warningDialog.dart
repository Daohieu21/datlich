import 'package:flutter/material.dart';

import 'buttonPrimary.dart';

class WarningDialog extends StatelessWidget {
  const WarningDialog(
      {super.key,
      required this.title,
      required this.content,
      });

  final String title;
  final String content;
  
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/error.jpg",
            height: 80,
            width: 80,),
            const SizedBox(
              height: 32,
            ),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 24,
                  color: Colors.black,
                  fontWeight: FontWeight.w500),
            ),
            SizedBox(
                height: 8,
              ),
            Text(
              content,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 32,
            ),
            ButtonPrimary(
                textButton: 'OK',
              ),
          ],
        ),
      ),
    );
  }
}
