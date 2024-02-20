import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:f_quizz/appoint_screen.dart';
import 'package:f_quizz/models/firebase_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'models/todo_model.dart';
import 'models/user_model.dart';

class DoctorsInfo extends StatefulWidget {
  const DoctorsInfo({super.key});

  @override
  State<DoctorsInfo> createState() => _DoctorsInfoState();
}

class _DoctorsInfoState extends State<DoctorsInfo> {
  late FirebaseService firebaseService; // Khai báo FirebaseService
  List<TodoModel> todos = []; // Danh sách TodoModel
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
    firebaseService = FirebaseService(user?.uid ?? '');
    // Lấy thông tin người dùng
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    });
    // Gọi hàm getTodos để lấy danh sách TodoModel
    loadTodos();
  }

  Future<void> loadTodos() async {
    try {
      // Gọi phương thức getTodos từ FirebaseService
      List<TodoModel> fetchedTodos = await firebaseService.getTodos();
      // Cập nhật trạng thái với dữ liệu mới
      setState(() {
        todos = fetchedTodos;
      });
    } catch (error) {
      // Xử lý lỗi nếu có
      print('Error loading todos: $error');
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 340,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: todos.length,
        itemBuilder: (context, index) {
          TodoModel todo = todos[index];
          return Column(
            children: [
              Container(
                height: 300,
                width: 200,
                margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                decoration: BoxDecoration(
                  color: const Color(0xFFF2F8FF),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 4,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) => AppointScreen(doctorInfo: todo),
                              ));
                          },
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15),
                            ),
                            child: Image.memory(
                              base64Decode(todo.imageBase64),
                              height: 200,
                              width: 200,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: Container(
                            margin: const EdgeInsets.all(8),
                            height: 45,
                            width: 45,
                            decoration: const BoxDecoration(
                              color: Color(0xFFF2F8FF),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey,
                                  blurRadius: 4,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.favorite_outline,
                                color: Colors.blue,
                                size: 28,
                                ),
                              ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            todo.title,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w500,
                              color: Colors.blue,
                            ),
                          ),
                          Text(
                            todo.content,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w300,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 8,),
                          Row(
                            children: const [
                              Icon(
                                Icons.star,
                                color:  Colors.amber,
                              ),
                              SizedBox(width: 5,),
                              Text(
                                "4.8",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                                ),
                            ],
                          ),
                        ]),
                      ),
                ]),
              ),
            ],
          );
        }
      ),
    );
  }
}