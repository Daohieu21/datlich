import 'dart:convert';

class UserAccount {
  String email;
  DateTime createAt;
  DateTime modifiedAt;

  UserAccount({
    required this.email, 
    required this.createAt,
    required this.modifiedAt,

    });
    
  List<Object> get props =>[email, createAt, modifiedAt];


  UserAccount copyWith ({
   String? email,
   DateTime? createAt,
   DateTime? modifiedAt,
  }) {
  return UserAccount (
    email: email ?? this.email,
    createAt: createAt ?? this.createAt,
    modifiedAt: modifiedAt ?? this.modifiedAt
  );
  }

  @override 
  Map<String, dynamic> toMap(){
    return <String, dynamic>{
      'email': email,
      'createAt': createAt.toIso8601String(),
      'modifiedAt': modifiedAt.toIso8601String(),
    };
  }

  factory UserAccount.fromMap(Map<String, dynamic> map) {
    return UserAccount(
      email: map['email'] != null ? map['email'] as String : '',
      createAt: map['createAt'] != null ? DateTime.parse(map['createAt'] as String) : DateTime.now(),
      modifiedAt: map['modifiedAt'] != null ? DateTime.parse(map['modifiedAt'] as String) : DateTime.now(),
      );
  }
  
  String toJson() => json.encode(toMap());

  factory UserAccount.fromJson(String source) => 
    UserAccount.fromMap(json.decode(source) as Map<String, dynamic>);

  @override 
  String toString(){
    return 'Account(email: $email, createAt: $createAt, modifiedAt: $modifiedAt)';
  }
}