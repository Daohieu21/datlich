import 'dart:convert';

class TodoEntity{
  String todoid;
  String title;
  String content;
  DateTime startTime;
  DateTime endTime;
  bool? isImportant;


  TodoEntity({
    required this.todoid, 
    required this.title, 
    required this.content,
    required this.startTime,
    required this.endTime,
    this.isImportant,
    });
  // Chuyển đổi thành Map để lưu trữ trong cơ sở dữ liệu 
  Map<String, dynamic> toMap(){
    return <String, dynamic>{
      'todoid': todoid,
      'title': title,
      'content': content,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'isImportant': isImportant,
    };
  }
  
  // Chuyển đổi thành chuỗi JSON
  String toJson() => json.encode(toMap());

  // Factory methods để chuyển đổi từ Map và JSON thành đối tượng TodoEntity
  factory TodoEntity.fromMap(Map<String, dynamic> map){
    return TodoEntity(
      todoid: map['todoid'] as String,
      title: map['title'] as String, 
      content: map['content'] as String,
      startTime: DateTime.parse(map['startTime']),
      endTime: DateTime.parse(map['endTime']),
      isImportant: map['isImportant'] as bool?, 
    );
  }
  factory TodoEntity.fromJson(String source) =>
    TodoEntity.fromMap(json.decode(source) as Map<String, dynamic>);
}

                      