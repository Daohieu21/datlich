import 'dart:async';
import 'package:f_quizz/gen/assets.gen.dart';
import 'package:f_quizz/intro.dart';
import 'package:f_quizz/navigation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
   static const String routeName = "/splash_screen";

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Kiểm tra xem người dùng đã đăng nhập hay chưa
    User? user = FirebaseAuth.instance.currentUser;
    print('User: $user');
    Timer(const Duration(seconds: 2), () {
      if (user != null) {
        // Nếu người dùng đã đăng nhập, chuyển hướng đến màn hình Intro
        Navigator.pushNamedAndRemoveUntil(context, MyBottomNavigationBar.routeName, (route) => false);
      } else {
        // Nếu người dùng chưa đăng nhập, chuyển hướng đến màn hình Intro
        Navigator.pushNamedAndRemoveUntil(context, Intro.routeName, (route) => false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Assets.images.picture3.image(
              height: 150,
              width: 150
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "TODO APP",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800),
            ),
          ],
        ),
      ),
    );
  }
}

