import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../change_info.dart';
import '../../gen/assets.gen.dart';
import '../../login/page/login.dart';
import '../../main.dart';
import '../../models/language.dart';
import '../../models/language_constants.dart';
import '../../models/user_model.dart';
import '../../resources/colors.dart';
import '../../ui_components/btn/buttom_setting.dart';

class Setting extends StatefulWidget {
  const Setting ({Key? key}) : super(key: key);
  static const String routeName = "/profile";

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel(
    uid: '',
    email: '',
    fullName: '',
    createAt: DateTime.now(),
    modifiedAt: DateTime.now(),
    avatarBase64: '', 
    role: '',
  );

  
  @override
  void initState() {
    super.initState();
    loadUserDetails();
  }

  Future<void> loadUserDetails() async {
      try {
        final value = await FirebaseFirestore.instance
            .collection("users")
            .doc(user!.uid)
            .get();
        loggedInUser = UserModel.fromMap(value.data());
        setState(() {});
      } catch (error) {
        print('Error loading user details: $error');
      }
  }

  void changeAvatar(String avatarBase64, String uid, String value) async {
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .update({avatarBase64: value});
      // Cập nhật dữ liệu thành công
      print('Updated $avatarBase64 successfully.');
    } catch (error) {
      // Xử lý lỗi khi cập nhật dữ liệu
      print('Error updating $avatarBase64: $error');
    }
  }

  void changeName(String uid, String newName) async {
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .update({"fullName": newName});
      print('Updated name successfully.');
      setState(() {
        loggedInUser.fullName = newName;
      });
    } catch (error) {
      print('Error updating name: $error');
    }
  }
  
  void showChangeNameDialog() {
    TextEditingController nameController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(translation(context).change_name),
          content: TextField(
            controller: nameController,
            decoration: InputDecoration(labelText: translation(context).new_name),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(translation(context).cancel),
            ),
            TextButton(
              onPressed: () {
                String newName = nameController.text;
                if (newName.isNotEmpty) {
                  changeName(loggedInUser.uid!, newName);
                }
                Navigator.pop(context);
              },
              child: Text(translation(context).save),
            ),
          ],
        );
      },
    );
  }

  void showChangeLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(translation(context).language),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: Language.languageList()
                  .map((lang) => ListTile(
                        title: Text(lang.name),
                        leading: CircleAvatar(
                          child: Text(lang.flag),
                        ),
                        onTap: () {
                          MyApp.setLocale(context, Locale(lang.languageCode));
                          Navigator.pop(context);
                        },
                      ))
                  .toList(),
            ),
          ),
        );
      },
    );
  }



  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        var bytes = await image.readAsBytes();
        String base64Image = base64Encode(bytes);
        setState(() {
          if (base64Image.isNotEmpty) {
            loggedInUser.avatarBase64 = base64Image;
          }
          changeAvatar("avatarBase64", loggedInUser.uid!, base64Image);
        });
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget avatarWidget;
    if (loggedInUser.avatarBase64 != null && loggedInUser.avatarBase64!.isNotEmpty) {
      avatarWidget = Image.memory(
        base64Decode(loggedInUser.avatarBase64!),
        fit: BoxFit.cover,
        width: 130,
        height: 130,
      );
    } else {
      avatarWidget = Image.asset(
        'assets/images/profile.png',
        width: 130,
        height: 130,
      );
    }
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Center(
          child: Text(
            translation(context).setting,
            style: const TextStyle(
              color: Colors.black,
              fontFamily: 'Rubik',
              fontSize: 24,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w500,
              letterSpacing: -0.5,
            ),
          ),
        ),
      ),
      body: user != null ? ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      GestureDetector(
                        onTap: () {
                          pickImage();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                width: 3,
                                color: Colors.blue,
                              ),
                              borderRadius: BorderRadius.circular(80)
                              ),
                          child: SizedBox(
                                width: 140,
                                height: 140,
                                child: ClipOval(
                                  child: avatarWidget,
                                ),
                              ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 15,
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blue,
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 32),
              ButtonNotification(text: translation(context).notice),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  translation(context).account_information,
                  style: const TextStyle(
                    color: Colors.black,
                    fontFamily: 'Rubik',
                    fontSize: 20,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w500,
                    letterSpacing: -0.5,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ButtonSettings(
                text: loggedInUser.fullName?? '',
                title: translation(context).name,
                image: Assets.images.name.path,
                onTap: () => showChangeNameDialog(),
              ),
              const SizedBox(height: 16),
              ButtonSettings(
                title: translation(context).email,
                text: loggedInUser.email?? '',
                image: Assets.images.email.path,
              ),
              const SizedBox(height: 16),
              ButtonSettings(
                title: translation(context).password,
                text: '',
                image: Assets.images.lock.path,
                onTap: () => showChangePasswordDialog(context),
              ),
              const SizedBox(height: 16),
              ButtonSettings(
                title: translation(context).language,
                text: '',
                image: Assets.images.language.path,
                onTap: () => showChangeLanguageDialog(context),
              ),
              const SizedBox(height: 30),
              Center(
                child: TextButton(
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    // ignore: use_build_context_synchronously
                    Navigator.pushNamedAndRemoveUntil(
                      context, Login.routeName, (route) => false);
                  },
                  child: Text(
                    translation(context).log_out,
                    style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Color(0xFF78746D)),
                  ),
                ),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ],
      ) : const Center(
              child: Text(
                "Bạn cần đăng nhập để sử dụng chức năng này",
                style: TextStyle(fontSize: 18),
              ),
            ),
    );
  }
}


class ButtonNotification extends StatelessWidget {
  const ButtonNotification({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 24,
        horizontal: 16,
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: AppColors.gray,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      width: double.infinity,
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.blue,
            ),
            width: 32,
            height: 32,
            child: 
            Assets.images.notification.image(
              height: 12,
              width: 12,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            text,
            style: const TextStyle(
              color: Colors.black,
              fontFamily: 'Rubik',
              fontSize: 20,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w500,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }
}
