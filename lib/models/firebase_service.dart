import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:f_quizz/models/appoint_model.dart';
import 'package:f_quizz/models/todo_model.dart';
import 'package:f_quizz/models/user_model.dart';

class FirebaseService {
  final String uid;
  final Dio dio;

  FirebaseService(this.uid) : dio = Dio();

  Future<UserModel?> getUserInfo() async {
    try {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .get();

      if (userSnapshot.exists) {
        return UserModel.fromMap(userSnapshot.data() as Map<String, dynamic>);
      } else {
        print('User not found in Firestore');
        return null;
      }
    } catch (error) {
      print('Error getting user info: $error');
      throw error;
    }
  }

  Future<List<TodoModel>> getTodos() async {
    try {
      Response response = await dio.get(
        'https://todo-5b469-default-rtdb.asia-southeast1.firebasedatabase.app/todo.json',
      );

      if (response.statusCode == 200) {
        // Kiểm tra xem response.data có null không
        if (response.data != null) {
          final Map<String, dynamic> rawData = response.data;
          // Chuyển đổi dữ liệu thành danh sách TodoModel
          final todos = rawData.entries
            .where((entry) => entry.value != null)
            .map((entry) => TodoModel.fromMap(entry.value))
            .toList();

          return todos;
        } else {
          print('Response data is null');
          return [];
        }
      } else {
        print('Failed to load todos: ${response.statusCode}');
        return [];
      }
    } catch (error) {
      print('Error getting todos: $error');
      throw error;
    }
  }

  Future<List<AppointModel>> getAppoint() async {
    try {
      Response response = await dio.get(
        'https://todo-5b469-default-rtdb.asia-southeast1.firebasedatabase.app/appoint/$uid.json',
      );

      if (response.statusCode == 200) {
        // Kiểm tra xem response.data có null không
        if (response.data != null) {
          final Map<String, dynamic> rawData = response.data;
          // Chuyển đổi dữ liệu thành danh sách TodoModel
          final appoint = rawData.entries
            .where((entry) => entry.value != null)
            .map((entry) => AppointModel.fromMap(entry.value))
            .toList();

          return appoint;
        } else {
          print('Response data is null');
          return [];
        }
      } else {
        print('Failed to load todos: ${response.statusCode}');
        return [];
      }
    } catch (error) {
      print('Error getting todos: $error');
      throw error;
    }
  }

  Future<void> addAppoint({
    required String title,
    required String content,
    required String time,
  }) async {
    try {
      DateTime parsedDateTime = DateTime.parse(time);
      // Tạo một đối tượng AppointModel mà không cần aid ban đầu
      AppointModel appoint = AppointModel(
        title: title,
        content: content,
        time: parsedDateTime,
        isCompleted: false,
      );

      Response response = await dio.post(
        'https://todo-5b469-default-rtdb.asia-southeast1.firebasedatabase.app/appoint/$uid.json',
        data: appoint.toMap(),
      );

      if (response.statusCode == 200) {
        String newAppointId = response.data['name'];
        print('newAppointId: $newAppointId');
        appoint.aid = newAppointId;

        await dio.put(
        'https://todo-5b469-default-rtdb.asia-southeast1.firebasedatabase.app/appoint/$uid/$newAppointId.json',
        data: appoint.toMap(),
        );

        print('Appoint added successfully! Appoint ID: $newAppointId');
      } else {
        print('Failed to add appoint: ${response.statusCode}');
      }
    } catch (error) {
      print('Error adding appoint: $error');
      throw error;
    }
  }

  Future<void> addTodo({
      required String title,
      required String content,
      required String experience,
      required String imageBase64,
    }) async {
      try {
        UserModel? userInfo = await getUserInfo();
        if (userInfo != null && userInfo.role == 'admin') {
          // Tạo một đối tượng TodoModel mà không cần todoid ban đầu
          TodoModel todos = TodoModel(
            title: title,
            content: content,
            experience: experience,
            isCompleted: false,
            imageBase64: imageBase64,
          );

          Response response = await dio.post(
            'https://todo-5b469-default-rtdb.asia-southeast1.firebasedatabase.app/todo.json',
            data: todos.toMap(),
          );

          if (response.statusCode == 200) {
            String newTodoId = response.data['name'];
            print('newTodoId: $newTodoId');
            todos.todoid = newTodoId;

            await dio.put(
            'https://todo-5b469-default-rtdb.asia-southeast1.firebasedatabase.app/todo/$newTodoId.json',
            data: todos.toMap(),
            );

            print('Todo added successfully! Todo ID: $newTodoId');
          } else {
            print('Failed to add todo: ${response.statusCode}');
          }
        } else {
          print('Permission denied. User does not have admin role.');
          // Xử lý thông báo hoặc các hành động khác khi không có quyền
        }
      } catch (error) {
        print('Error adding todo: $error');
        throw error;
      }
    }

  Future<void> updateTodo(String todoid, {
      required String imageBase64,
      required String title,
      required String content,
      required String experience,
      bool isCompleted = false,
    }) async {
      try {
        UserModel? userInfo = await getUserInfo();
        if (userInfo != null && userInfo.role == 'admin') {
          TodoModel todos = TodoModel(
            todoid: todoid,
            title: title,
            content: content,
            experience: experience,
            isCompleted: isCompleted,
            imageBase64: imageBase64,
          );

          Response response = await dio.put(
            'https://todo-5b469-default-rtdb.asia-southeast1.firebasedatabase.app/todo/$todoid.json',
            data: todos.toMap(), // Đảm bảo toMap trả về một Map<String, dynamic>
          );

          if (response.statusCode == 200) {
            print('Todo updated successfully! Todo ID: $todoid');
          } else {
            print('Failed to update todo: ${response.statusCode}');
          }         
        } else {
          print('Permission denied. User does not have admin role.');
          // Xử lý thông báo hoặc các hành động khác khi không có quyền
        }
      } catch (error) {
        print('Error updating todo: $error');
        throw error;
      }
    }

  Future<void> deleteTodo(String todoid) async {
    try {
      UserModel? userInfo = await getUserInfo();
      if (userInfo != null && userInfo.role == 'admin') {
        Response response = await dio.delete(
          'https://todo-5b469-default-rtdb.asia-southeast1.firebasedatabase.app/todo/$todoid.json',
        );

        if (response.statusCode == 200) {
          print('Todo deleted successfully!');
        } else {
          print('Failed to delete todo: ${response.statusCode}');
        }
      } else {
        print('Permission denied. User does not have admin role.');
        // Xử lý thông báo hoặc các hành động khác khi không có quyền
      }
    } catch (error) {
      print('Error deleting todo: $error');
      throw error;
    }
  }
}