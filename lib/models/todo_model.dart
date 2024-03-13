import 'dart:convert';

class TodoModel{
  String? todoid;
  String imageBase64;
  String title;
  String content;
  String experience;

  TodoModel({
    this.todoid,
    required this.imageBase64,
    required this.title, 
    required this.content,
    required this.experience,
    });

    TodoModel copyWith({
    String? todoid,
    String? imageBase64,
    String? title,
    String? content,
    String? experience,
  }) {
    return TodoModel(
      todoid: todoid ?? this.todoid,
      imageBase64: imageBase64 ?? this.imageBase64,
      title: title ?? this.title,
      content: content ?? this.content,
      experience: experience ?? this.experience,
    );
  }

  // Chuyển đổi thành Map để lưu trữ trong cơ sở dữ liệu 
  Map<String, dynamic> toMap(){
    return <String, dynamic>{
      'todoid': todoid,
      'imageBase64': imageBase64,
      'title': title,
      'content': content,
      'experience': experience,
    };
  }
  
  // Chuyển đổi thành chuỗi JSON
  String toJson() => json.encode(toMap());

  // Factory methods để chuyển đổi từ Map và JSON thành đối tượng TodoModel
  factory TodoModel.fromMap(Map<String, dynamic> map){
    return TodoModel(
      todoid: map['todoid'] as String,
      imageBase64: map['imageBase64'],
      title: map['title'] as String, 
      content: map['content'] as String,
      experience: map['experience'] as String,
    );
  }
  factory TodoModel.fromJson(String source) =>
    TodoModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Todo(uid: $todoid, title: $title, content: $content)';
  }
}