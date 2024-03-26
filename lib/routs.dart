import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'change_info.dart';
import 'intro.dart';
import 'login/bloc/login_bloc.dart';
import 'login/page/login.dart';
import 'navigation.dart';
import 'setting/page/setting.dart';
import 'signup/bloc/sign_up_bloc.dart';
import 'signup/page/sign_up.dart';
import 'splash_screen.dart';
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
