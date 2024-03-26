import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/user_account.dart';
import 'sign_up_event.dart';
import 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  SignUpBloc() : super(SignUpInitialState()) {
    on<SignUpEventTogglePassword>((event, emit) {
      emit(SignUpState(isShow: !state.isShow));
    });

    on<SignUpEventSubmit>((event, emit) async {
      try {
        emit(SignUpLoadingState(isLoading: true));
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
              email: emailController.text,
              password: passwordController.text,
            );
        User user = userCredential.user!;
        UserAccount userAccount = UserAccount(
            email: user.email ?? '',
            createAt: DateTime.now(),
            modifiedAt: DateTime.now(),
          );
        emit(SignUpSuccessState(userAccount:userAccount));
      } catch (e) {
        emit(SignUpErrorState(errorMessage: e.toString()));
      }
    });
  }
}
