import 'package:f_quizz/gen/assets.gen.dart';
import 'package:f_quizz/models/language_constants.dart';
import 'package:f_quizz/resources/colors.dart';
import 'package:f_quizz/resources/validator.dart';
import 'package:f_quizz/signup/bloc/sign_up_bloc.dart';
import 'package:f_quizz/signup/bloc/sign_up_event.dart';
import 'package:f_quizz/signup/bloc/sign_up_state.dart';
import 'package:flutter/material.dart';
import 'package:f_quizz/login/page/login.dart';
import 'package:f_quizz/ui_components/btn/button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key, this.email}) : super(key: key);
  static const String routeName = "/sign_up";
  final String? email;

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    context.read<SignUpBloc>().emailController.text =
        widget.email != null ? widget.email ?? "" : "";
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpBloc, SignUpState>(
      listener: (context, state) {
        if (state is SignUpErrorState) {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text(translation(context).notice),
                //content: Text(state.errorMessage),
                content: const Text('Tài khoản đã tồn tại'),
                actions: [
                  TextButton(
                    child: Text(translation(context).ok),
                    onPressed: () {
                      onTapSuccess();
                    },
                  ),
                ],
              );
            },
          );
        }
        if (state is SignUpSuccessState) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(translation(context).notice),
                content: Text(translation(context).successfully_created),
                actions: [
                  TextButton(
                    child: Text(translation(context).ok),
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
        body: BlocBuilder<SignUpBloc, SignUpState>(
          builder: (context, state) {
            bool isLoading = false;
            if (state is SignUpLoadingState) {
              isLoading = state.isLoading;
            }
            return Stack(
              children: [
                ListView(
                  padding: const EdgeInsets.only(top: 96, right: 16, left: 16),
                  children: [
                    Column(
                      children: [
                        Assets.images.picture2.image(),
                        const SizedBox(
                          height: 15,
                        ),
                        Column(
                          children: [
                            Text(
                              translation(context).sign_up,
                              style: const TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Text(
                              translation(context).create_your_account,
                              style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFF78746D)),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: <Widget>[
                              BlocBuilder<SignUpBloc, SignUpState>(
                                builder: (context, state) {
                                  return TextFormField(
                                    controller: context
                                        .read<SignUpBloc>()
                                        .emailController,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    validator: (value) => ValidatorUtils.usernameValidator(context, value),
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xFF78746D)),
                                    decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.all(16),
                                        labelText: 'Email',
                                        border: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              width: 1,
                                              color: Color(0xFFBEBAB3)),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        )),
                                  );
                                },
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              BlocBuilder<SignUpBloc, SignUpState>(
                                builder: (context, state) {
                                  return TextFormField(
                                    controller: context
                                        .read<SignUpBloc>()
                                        .passwordController,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    validator: (value) => ValidatorUtils.passwordValidator(context, value),
                                    obscureText: state.isShow,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.darkgray,
                                    ),
                                    decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.all(16),
                                      labelText: translation(context).password,
                                      border: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            width: 1, color: AppColors.gray),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      suffixIcon: GestureDetector(
                                        onTap: () {
                                          context
                                              .read<SignUpBloc>()
                                              .add(SignUpEventTogglePassword());
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
                              const SizedBox(
                                height: 15,
                              ),
                              Button(
                                textButton: translation(context).sign_up,
                                onTap: () {
                                  if (_formKey.currentState!.validate()) {
                                    context.read<SignUpBloc>().add(SignUpEventSubmit());
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: () => onTapToLoginPage(context),
                          child: Text(
                            translation(context).login,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF78746D),
                            ),
                          ),
                        ),
                      ],
                    ),
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

  void onTapToLoginPage(BuildContext context) {
    Navigator.pushNamed(context, Login.routeName);
  }

  void onTapSuccess() {
    Navigator.pushNamedAndRemoveUntil(
        context, Login.routeName, (route) => false,
        arguments: context.read<SignUpBloc>().emailController.text);
  }

  void onTapToSignUpPage() {
    context.read<SignUpBloc>().add(SignUpEventSubmit());
  }
}
