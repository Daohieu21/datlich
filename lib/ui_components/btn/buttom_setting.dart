import 'package:flutter/material.dart';
import '../../resources/colors.dart';

class ButtonSettings extends StatelessWidget {
  const ButtonSettings({
    Key? key,
    required this.text,
    required this.title,
    required this.image,
    this.onTap,
  }) : super(key: key);

  final String text;
  final String title;
  final String image;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 24,
          horizontal: 16,
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: AppColors.gray,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        width: double.infinity,
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.blue,
              ),
              width: 32,
              height: 32,
              child: Image.asset(
                image,
                height: 12,
                width: 12,
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.black,
                    fontFamily: 'Rubik',
                    fontSize: 20,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w500,
                    letterSpacing: -0.5,
                  ),
                ),
                Text(
                  text,
                  style: const TextStyle(
                    color: Colors.black,
                    fontFamily: 'Rubik',
                    fontSize: 14,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            const Spacer(),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}