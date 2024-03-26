import 'package:Appointment/models/todo_model.dart';
import 'package:Appointment/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';

import 'appoint_model.dart';


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

  Future<List<AppointModel>> getAppointAdmin() async {
    try {
      UserModel? userInfo = await getUserInfo();
      if (userInfo != null && userInfo.role == 'admin') {

      Response response = await dio.get(
        'https://todo-5b469-default-rtdb.asia-southeast1.firebasedatabase.app/appointadmin.json',
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

      } else {
      print('Permission denied. User does not have admin role.');
      // Xử lý thông báo hoặc các hành động khác khi không có quyền
      return [];
      }

    } catch (error) {
      print('Error getting todos: $error');
      throw error;
    }
  }

Future<void> addAppoint({
  required String todoid,
  required String title,
  required String content,
  required String email,
  required String time,
  required String reason,
  required String isCompleted,
}) async {
  try {
    DateTime parsedDateTime = DateTime.parse(time);
    
    // Tạo một đối tượng AppointModel mà không cần aid ban đầu
    AppointModel appoint = AppointModel(
      todoid: todoid,
      title: title,
      content: content,
      email: email,
      reason: reason,
      time: parsedDateTime,
      isCompleted: "false",
    );
    

    // Thêm vào 'appoint'
    Response responseAppoint = await dio.post(
      'https://todo-5b469-default-rtdb.asia-southeast1.firebasedatabase.app/appoint/$uid.json',
      data: appoint.toMap(),
    );

    if (responseAppoint.statusCode == 200) {
      String newAppointId = responseAppoint.data['name'];
      print('newAppointId (appoint): $newAppointId');
      appoint.aid = newAppointId;

      // Cập nhật vào 'appoint'
      await dio.put(
        'https://todo-5b469-default-rtdb.asia-southeast1.firebasedatabase.app/appoint/$uid/$newAppointId.json',
        data: appoint.toMap(),
      );

      // Thêm vào 'appointadmin' với cùng một ID
      Response responseAppointAdmin = await dio.put(
        'https://todo-5b469-default-rtdb.asia-southeast1.firebasedatabase.app/appointadmin/$newAppointId.json',
        data: appoint.toMap(),
      );

      if (responseAppointAdmin.statusCode == 200) {
        print('Appoint added successfully! Appoint ID (appointadmin): $newAppointId');
      } else {
        print('Failed to add appoint (appointadmin): ${responseAppointAdmin.statusCode}');
      }

      print('Appoint added successfully! Appoint ID (appoint): $newAppointId');
    } else {
      print('Failed to add appoint (appoint): ${responseAppoint.statusCode}');
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
    }) async {
      try {
        UserModel? userInfo = await getUserInfo();
        if (userInfo != null && userInfo.role == 'admin') {
          TodoModel todos = TodoModel(
            todoid: todoid,
            title: title,
            content: content,
            experience: experience,
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

  Future<void> updateAppoint(String aid, {
    String? title,
    String? content,
    DateTime? time,
    String isCompleted = "false",
  }) async {
    try {
      UserModel? userInfo = await getUserInfo();
      if (userInfo != null && userInfo.role == 'admin') {

        // Lấy dữ liệu hiện tại từ server (nếu cần)
        Response currentDataResponse = await dio.get(
          'https://todo-5b469-default-rtdb.asia-southeast1.firebasedatabase.app/appointadmin/$aid.json',
        );

        // Chuyển dữ liệu từ server thành đối tượng AppointModel
        AppointModel? currentAppoint = AppointModel.fromMap(currentDataResponse.data);

        if (currentAppoint != null) {
          // Sử dụng phương thức copyWith để tạo một bản sao với các thay đổi
          AppointModel updatedAppoint = currentAppoint.copyWith(
            aid: aid,
            title: title,
            content: content,
            time: time,
            isCompleted: isCompleted,
          );

          // Gửi dữ liệu đã cập nhật lên server
          Response response = await dio.put(
            'https://todo-5b469-default-rtdb.asia-southeast1.firebasedatabase.app/appointadmin/$aid.json',
            data: updatedAppoint.toMap(),
          );

          // Gửi dữ liệu đã cập nhật lên server
          Response responsedata = await dio.put(
            'https://todo-5b469-default-rtdb.asia-southeast1.firebasedatabase.app/appoint/$uid/$aid.json',
            data: updatedAppoint.toMap(),
          );

          if (response.statusCode == 200 && responsedata.statusCode == 200 ) {
            print('Appoint updated successfully! Appoint ID: $aid');
          } else {
            print('Failed to update appoint: ${response.statusCode}');
          }
        } else {
          print('Failed to retrieve current appoint data.');
          // Xử lý thông báo hoặc các hành động khác nếu không thể lấy dữ liệu hiện tại
        }
      } else {
        print('Permission denied. User does not have admin role.');
        // Xử lý thông báo hoặc các hành động khác khi không có quyền
      }
    } catch (error) {
      print('Error updating appoint: $error');
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

  Future<void> deleteAppoint(String aid) async {
    try {
      // Xóa ở 'appoint'
      Response responseAppoint = await dio.delete(
        'https://todo-5b469-default-rtdb.asia-southeast1.firebasedatabase.app/appoint/$uid/$aid.json',
      );

      if (responseAppoint.statusCode == 200) {
        print('Appoint deleted successfully (appoint)!');
      } else {
        print('Failed to delete appoint (appoint): ${responseAppoint.statusCode}');
      }

      // Xóa ở 'appointadmin'
      Response responseAppointAdmin = await dio.delete(
        'https://todo-5b469-default-rtdb.asia-southeast1.firebasedatabase.app/appointadmin/$aid.json',
      );

      if (responseAppointAdmin.statusCode == 200) {
        print('Appoint deleted successfully (appointadmin)!');
      } else {
        print('Failed to delete appoint (appointadmin): ${responseAppointAdmin.statusCode}');
      }
    } catch (error) {
      print('Error deleting appoint: $error');
      throw error;
    }
  }
}