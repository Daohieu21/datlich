import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:f_quizz/login/bloc/login_state.dart';
import 'package:f_quizz/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'login_event.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginBloc() : super(LoginInitialState()) {
    on<LoginEventTogglePassword>((event, emit) {
      emit(LoginState(isShow: !state.isShow));
    });

    on<LoginEventSubmit>((event, emit) async {
      try {
        emit(LoginLoadingState(isLoading: true));
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        User? user = userCredential.user;

        if (user != null) {
          // Đăng nhập thành công
          await postDetailsToFirestore(user);
          emit(LoginSuccessState(user: user));
        } else {
          // Đăng nhập thất bại
          emit(LoginErrorState(errorMessage: ""));
        }
      } catch (e) {
        // Xử lý lỗi đăng nhập
        emit(LoginErrorState(errorMessage: e.toString()));
      } finally {
          // Kết thúc loading
          emit(LoginLoadingState(isLoading: false));
        }
    });
  }
  
  Future<void> postDetailsToFirestore(User user) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    // Kiểm tra xem user có tồn tại trong Firestore chưa
    DocumentSnapshot userSnapshot = await firebaseFirestore
        .collection("users")
        .doc(user.uid)
        .get();
    if (!userSnapshot.exists) {
      // Nếu user chưa tồn tại, thêm mới
      UserModel userModel = UserModel(
        uid: user.uid,
        email: user.email!,
        fullName: 'Default',
        createAt: DateTime.now(),
        modifiedAt: DateTime.now(),
        avatarBase64: '', 
        role: 'admin',
      );

      await firebaseFirestore
          .collection("users")
          .doc(user.uid)
          .set(userModel.toMap());
    }
  }
}
