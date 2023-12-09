import 'package:flutter/material.dart';

class ProgressIndicatorCircular extends StatelessWidget {
  const ProgressIndicatorCircular({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        backgroundColor: Colors.white,
        strokeWidth: 2,
        color: Colors.black,
      ),
    );
  }
}
