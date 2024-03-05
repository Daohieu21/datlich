import 'dart:convert';

class AppointModel{
  String? aid;
  String todoid;
  String title;
  String content;
  String email;
  DateTime time;
  bool isCompleted;

  AppointModel({
    this.aid,
    required this.todoid, 
    required this.title, 
    required this.content,
    required this.email,
    required this.time,
    this.isCompleted = false,
    });

    AppointModel copyWith({
    String? aid,
    String? todoid,
    String? title,
    String? content,
    String? email,
    DateTime? time,
    bool? isCompleted,
  }) {
    return AppointModel(
      aid: aid ?? this.aid,
      todoid: todoid ?? this.todoid,
      title: title ?? this.title,
      content: content ?? this.content,
      email: email ?? this.email,
      time: time ?? this.time,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  // Chuyển đổi thành Map để lưu trữ trong cơ sở dữ liệu 
  Map<String, dynamic> toMap(){
    return <String, dynamic>{
      'aid': aid,
      'todoid': todoid,
      'title': title,
      'content': content,
      'email': email,
      'time': time.toIso8601String(),
      'isCompleted': isCompleted,
    };
  }
  
  // Chuyển đổi thành chuỗi JSON
  String toJson() => json.encode(toMap());

  // Factory methods để chuyển đổi từ Map và JSON thành đối tượng AppointModel
  factory AppointModel.fromMap(Map<String, dynamic> map){
    return AppointModel(
      aid: map['aid'] as String,
      todoid: map['todoid'] as String, 
      title: map['title'] as String, 
      content: map['content'] as String,
      email: map['email'] as String,
      time: DateTime.parse(map['time']),
      isCompleted: map['isCompleted'] as bool? ?? false,
    );
  }
  factory AppointModel.fromJson(String source) =>
    AppointModel.fromMap(json.decode(source) as Map<String, dynamic>);

    @override
  String toString() {
    return 'Todo(aid: $aid, title: $title, content: $content)';
  }
}