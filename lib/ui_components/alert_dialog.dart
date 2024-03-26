import 'package:flutter/material.dart';
import '../login/page/login.dart';
import '../signup/page/sign_up.dart';

void showAccountExistDialog1(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Thông báo"),
        content: Text("Tài khoản đã tồn tại."),
        actions: [
          TextButton(
            child: Text("OK"),
            onPressed: () {
              Navigator.of(context).pushNamed(Login.routeName);
            },
          ),
        ],
      );
    },
  );
}

void showAccountExistDialog2(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Thông báo"),
        content: Text("Tài khoản không tồn tại"),
        actions: [
          TextButton(
            child: Text("OK"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

void showAccountExistDialog3(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Thông báo"),
        content: Text("Tài khoản hoặc mật khẩu không đúng"),
        actions: [
          TextButton(
            child: Text("OK"),
            onPressed: () {
              Navigator.of(context).pop();
              //Navigator.of(context).pushNamed(Login.routeName);
            },
          ),
        ],
      );
    },
  );
}
