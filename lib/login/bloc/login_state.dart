import 'package:firebase_auth/firebase_auth.dart';

class LoginInitialState extends LoginState {
  LoginInitialState();
}

class LoginState {
  final bool isShow;
  LoginState({
    this.isShow = true
  });
}

class LoginLoadingState extends LoginState {
  final bool isLoading;
  LoginLoadingState({
    this.isLoading = true
    });
}

class LoginSuccessState extends LoginState {
  final User? user;
  LoginSuccessState({required this.user});
}

class LoginErrorState extends LoginState {
  final String errorMessage;
  LoginErrorState({required this.errorMessage});
}

