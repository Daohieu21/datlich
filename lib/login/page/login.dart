import 'package:f_quizz/login/bloc/login_bloc.dart';
import 'package:f_quizz/login/bloc/login_event.dart';
import 'package:f_quizz/login/bloc/login_state.dart';
import 'package:f_quizz/models/language_constants.dart';
import 'package:f_quizz/navigation.dart';
import 'package:f_quizz/gen/assets.gen.dart';
import 'package:f_quizz/resources/validator.dart';
import 'package:f_quizz/signup/page/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:f_quizz/resources/colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:f_quizz/ui_components/btn/button.dart';

class Login extends StatefulWidget {
  const Login({Key? key, this.email}) : super(key: key);
  static const String routeName = "/login";
  final String? email;

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  @override
  void initState() {
    context.read<LoginBloc>().emailController.text =
        widget.email != null ? widget.email ?? "" : "";
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginSuccessState) {
          Navigator.pushNamedAndRemoveUntil(
              context, MyBottomNavigationBar.routeName, (route) => false,);
              //arguments: state.userAccount.user);
        }
        if (state is LoginErrorState) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(translation(context).notice),
                content: Text(state.errorMessage),
                actions: [
                  TextButton(
                    child: const Text("OK"),
                    onPressed: () {
                      onTapSuccess();
                    },
                  ),
                ],
              );
            },
          );
        }
      },
      child: Scaffold(
        body: BlocBuilder<LoginBloc, LoginState>(
          builder: (context, state) {
            bool isLoading = false;
            if (state is LoginLoadingState) {
              isLoading = state.isLoading;
            }
            return Stack(
              children: [
                ListView(
                  children: [
                    Container(
                        padding:
                            const EdgeInsets.only(top: 96, right: 16, left: 16),
                        child: Column(
                          children: [
                            Assets.images.picture1.image(),
                            const SizedBox(
                              height: 15,
                            ),
                            Column(
                              children: [
                                Text(
                                  translation(context).login,
                                  style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  translation(context).login_with_social_networks,
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.darkgray),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Container(
                                  width: double.infinity,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image(
                                        image: Assets.images.icon1.provider(),
                                        width: 40,
                                        height: 40,
                                      ),
                                      const SizedBox(
                                        width: 12,
                                      ),
                                      Image(
                                        image: Assets.images.icon2.provider(),
                                        width: 40,
                                        height: 40,
                                      ),
                                      const SizedBox(
                                        width: 12,
                                      ),
                                      Image(
                                        image: Assets.images.icon3.provider(),
                                        width: 40,
                                        height: 40,
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Form(
                              key: _formKey,
                              child: Column(
                                children: <Widget>[
                                  BlocBuilder<LoginBloc, LoginState>(
                                    builder: (context, state) {
                                      return TextFormField(
                                        controller: context
                                            .read<LoginBloc>()
                                            .emailController,
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        validator: (value) =>
                                            ValidatorUtils.usernameValidator(context, value),
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            color: AppColors.darkgray),
                                        decoration: InputDecoration(
                                            contentPadding:
                                                const EdgeInsets.all(16),
                                            labelText: 'Email',
                                            border: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  width: 1,
                                                  color: AppColors.gray),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            )),
                                      );
                                    },
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  BlocBuilder<LoginBloc, LoginState>(
                                    builder: (context, state) {
                                      return TextFormField(
                                        controller: context
                                            .read<LoginBloc>()
                                            .passwordController,
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        validator: (value) =>
                                            ValidatorUtils.passwordValidator(context, value),
                                        obscureText: state.isShow,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: AppColors.darkgray,
                                        ),
                                        decoration: InputDecoration(
                                          contentPadding:
                                              const EdgeInsets.all(16),
                                          labelText: translation(context).password,
                                          border: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                width: 1,
                                                color: AppColors.gray),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          suffixIcon: GestureDetector(
                                            onTap: () {
                                              context.read<LoginBloc>().add(
                                                  LoginEventTogglePassword());
                                            },
                                            child: Icon(
                                              state.isShow
                                                  ? Icons.visibility_off
                                                  : Icons.visibility,
                                              color: AppColors.gray,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  TextButton(
                                    onPressed: () {},
                                    child: Text(
                                      translation(context).forgot_password,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                          color: AppColors.darkgray),
                                    ),
                                  ),
                                  Button(
                                    textButton: translation(context).login,
                                    onTap: () {
                                      if (_formKey.currentState != null &&
                                          _formKey.currentState!.validate()) {
                                        // Code xử lý khi form hợp lệ
                                        // setState(() {
                                        //   isLoading = true;
                                        // });
                                        // onTapToLoginPage();
                                        context.read<LoginBloc>().add(LoginEventSubmit());
                                      }
                                    },
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pushNamed(
                                          context, SignUp.routeName);
                                    },
                                    child: Text(
                                      translation(context).sign_up,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                          color: AppColors.darkgray),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )),
                  ],
                ),
                if (isLoading) // Nếu isLoading là true, hiển thị CircularProgressIndicator
                  Positioned.fill(
                    child: Container(
                      color: Colors.black.withOpacity(0.5),
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  void onTapToLoginPage() {
    context.read<LoginBloc>().add(LoginEventSubmit());
  }

  void onTapSuccess() {
    Navigator.of(context).pop();
    // Navigator.pushNamedAndRemoveUntil(
    //     context, SignUp.routeName, (route) => false,
    //     arguments: context.read<LoginBloc>().emailController.text);
  }
}
