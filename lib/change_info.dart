import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'models/language_constants.dart';
import 'resources/validator.dart';
import 'ui_components/btn/button.dart';

void showChangePasswordDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(translation(context).notice),
          content: Text(translation(context).do_you_want),
          actions: <Widget>[
            TextButton(
              child: Text(translation(context).cancel),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng hộp thoại
                Navigator.pushNamed(context, ChangePasswordPage.routeName);
              },
              child: Text(translation(context).ok),
            ),
          ],
        );
      },
    ); 
  }

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage ({Key? key}) : super(key: key);
  static const String routeName = "/changepassword";

  @override
  ChangePasswordPageState createState() => ChangePasswordPageState();
}

class ChangePasswordPageState extends State<ChangePasswordPage> {
  final TextEditingController passwordController= TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isPasswordVisible1 = false;
  bool isPasswordVisible2 = false;
  bool isPasswordVisible3 = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    passwordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> changePassword() async {
    String currentPassword = passwordController.text;
    String newPassword = newPasswordController.text;
    String confirmPassword = confirmPasswordController.text;

    // Kiểm tra mật khẩu mới và xác nhận mật khẩu có khớp không
    if (newPassword != confirmPassword) {
      showSnackBar(translation(context).new_confirm, Colors.red,);
      return;
    }

    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      try {
        // Xác minh mật khẩu hiện tại trực tiếp
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: currentUser.email!,
          password: currentPassword,
        );

        // Đổi mật khẩu sử dụng Firebase Authentication
        await currentUser.updatePassword(newPassword);
        // ignore: use_build_context_synchronously
        showSnackBar(translation(context).password_changed_success, Colors.green);
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
      } on FirebaseAuthException catch (e) {
        //print('Error changing password: $e');
        showSnackBar(translation(context).old_password_incorrect, Colors.red,);
      }
    } else {
      showSnackBar(translation(context).please_login,Colors.red,);
    }
  }

  void showSnackBar(String message, Color backgroundColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(translation(context).change_password),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: passwordController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) => ValidatorUtils.passwordValidator(context, value),
                  decoration: InputDecoration(
                    labelText: translation(context).current,
                    border: OutlineInputBorder(
                          borderSide: const BorderSide(width: 1, color: Colors.grey),
                          borderRadius: BorderRadius.circular(12),
                        ),
                    suffixIcon: IconButton(
                      icon: Icon(isPasswordVisible1 ? Icons.visibility : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          isPasswordVisible1 = !isPasswordVisible1;
                        });
                      },
                    ),
                  ),
                  obscureText: !isPasswordVisible1,
                ),
                const SizedBox(
                      height: 20,
                    ),
                TextFormField(
                  controller: newPasswordController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) => ValidatorUtils.passwordValidator(context, value),
                  decoration: InputDecoration(
                    labelText: translation(context).newp,
                    border: OutlineInputBorder(
                          borderSide: const BorderSide(width: 1, color: Colors.grey),
                          borderRadius: BorderRadius.circular(12),
                        ),
                    suffixIcon: IconButton(
                      icon: Icon(isPasswordVisible2 ? Icons.visibility : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          isPasswordVisible2 = !isPasswordVisible2;
                        });
                      },
                    ),
                  ),
                  obscureText: !isPasswordVisible2,
                ),
                const SizedBox(
                      height: 20,
                    ),
                TextFormField(
                  controller: confirmPasswordController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) => ValidatorUtils.passwordValidator(context, value),
                  decoration: InputDecoration(
                    labelText: translation(context).confirm,
                    border: OutlineInputBorder(
                          borderSide: const BorderSide(width: 1, color: Colors.grey),
                          borderRadius: BorderRadius.circular(12),
                        ),
                    suffixIcon: IconButton(
                      icon: Icon(isPasswordVisible3 ? Icons.visibility : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          isPasswordVisible3 = !isPasswordVisible3;
                        });
                      },
                    ),
                  ),
                  obscureText: !isPasswordVisible3,
                ),
                const SizedBox(height: 20.0),
                Button(
                  onTap: changePassword,
                  textButton: translation(context).save,
                ),
                const SizedBox(height: 20.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}