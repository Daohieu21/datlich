import 'package:f_quizz/change_info.dart';
import 'package:f_quizz/login/bloc/login_bloc.dart';
import 'package:f_quizz/navigation.dart';
import 'package:f_quizz/setting/page/setting.dart';
import 'package:f_quizz/signup/bloc/sign_up_bloc.dart';
import 'package:flutter/material.dart';
import 'package:f_quizz/login/page/login.dart';
import 'package:f_quizz/signup/page/sign_up.dart';
import 'package:f_quizz/splash_screen.dart';
import 'package:f_quizz/intro.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'todo/page/todo_page.dart';

Route<dynamic>? Function(RouteSettings)? onGenerateRoute = (settings) {
  if (settings.name == SplashScreen.routeName) {
    return MaterialPageRoute(builder: (_) => const SplashScreen());
  }

  if (settings.name == SignUp.routeName) {
    final String? arg = settings.arguments as String?;
    return MaterialPageRoute(
        builder: (_) => BlocProvider(
              create: (context) => SignUpBloc(),
              child: SignUp(
                email: arg,
              ),
            ));
  }

  if (settings.name == Intro.routeName) {
    return MaterialPageRoute(builder: (_) => const Intro());
  }

  if (settings.name == Login.routeName) {
    final String? arg = settings.arguments as String?;
    return MaterialPageRoute(
        builder: (_) => BlocProvider(
              create: (context) => LoginBloc(),
              child: Login(
                email: arg,
              ),
            ));
  }

  // if (settings.name == Home.routeName) {
  //   return MaterialPageRoute(builder: (_) => Home());
  // }

  if (settings.name == Setting.routeName) {
    return MaterialPageRoute(builder: (_) => Setting());
  }

  if (settings.name == ChangePasswordPage.routeName) {
    return MaterialPageRoute(builder: (_) => const ChangePasswordPage());
  }

  if (settings.name == TodoPage.routeName) {
    return MaterialPageRoute(builder: (_) => const TodoPage());
  }

  if (settings.name == MyBottomNavigationBar.routeName) {
    return MaterialPageRoute(
      builder: (_) => const MyBottomNavigationBar(),
    );
  }

  return null;
};
