
import 'package:f_quizz/models/user_account.dart';

class SignUpInitialState extends SignUpState {}

class SignUpState {
  final bool isShow;
  SignUpState({
    this.isShow = true
    });
}

class SignUpLoadingState extends SignUpState {
  final bool isLoading;
  SignUpLoadingState({
    this.isLoading = true
    });
}

class SignUpSuccessState extends SignUpState {
  final UserAccount userAccount;
  SignUpSuccessState({required this.userAccount});
}

class SignUpErrorState extends SignUpState {
  final String errorMessage;
  SignUpErrorState({required this.errorMessage});
}