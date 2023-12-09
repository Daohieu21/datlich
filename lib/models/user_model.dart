import 'package:f_quizz/models/user_account.dart';

class UserModel extends UserAccount {
  String? uid;
  String? fullName;
  String? avatarBase64;
  final String role;

  UserModel({
    this.uid,
    required String email,
    required DateTime createAt,
    required DateTime modifiedAt,
    this.fullName,
    this.avatarBase64,
    required this.role,
  }) : super(email: email, createAt: createAt, modifiedAt: modifiedAt);

  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      createAt: map['createAt'] != null
          ? DateTime.parse(map['createAt'] as String)
          : DateTime.now(),
      modifiedAt: map['modifiedAt'] != null
          ? DateTime.parse(map['modifiedAt'] as String)
          : DateTime.now(),
      fullName: map['fullName'],
      avatarBase64: map['avatarBase64'],
      role: map['role'],
    );
  }

  @override
    Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'createAt': createAt.toIso8601String(),
      'modifiedAt': modifiedAt.toIso8601String(),
      'fullName': fullName,
      'avatarBase64': avatarBase64,
      'role': role,
    };
  }
}

