import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:f_quizz/models/firebase_service.dart';
import 'package:f_quizz/models/language_constants.dart';
import 'package:f_quizz/models/todo_model.dart';
import 'package:f_quizz/models/user_model.dart';
import 'package:f_quizz/resources/colors.dart';
import 'package:f_quizz/resources/validator.dart';
import 'package:f_quizz/ui_components/btn/button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  static const String routeName = "/home";

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<TodoModel> todoList = [];
  late FirebaseService firebaseService;
  bool isSearchPressed = false;
  String searchKeyword = '';
   late DateTime selectedTime;
  int selectedIndex = -1;
  Timer? deleteTimer; // Timer để ẩn icon xóa
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
    User? user = FirebaseAuth.instance.currentUser;
    firebaseService = FirebaseService(user?.uid ?? '');
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    });
  }

  void showNoResultDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(translation(context).notice),
          content: Text(translation(context).please_enter),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(translation(context).ok),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Color> colors = [
      const Color.fromARGB(255, 246, 75, 63),
      const Color.fromARGB(255, 111, 171, 219),
      const Color.fromARGB(255, 120, 215, 124),
      const Color.fromARGB(255, 234, 157, 43),
      const Color.fromARGB(255, 224, 216, 146),
    ];
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 50,),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              translation(context).hello,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.black),
            ),
            const SizedBox(height: 5),
            Text(
              loggedInUser.fullName ?? '',
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w700, color: Colors.black),
            ),
            const SizedBox(height: 20),
            TextFormField(
              onChanged: (value) {
                setState(() {
                  searchKeyword = value;
                });
              },
              decoration: InputDecoration(
                hintText: translation(context).enter,
                suffixIcon: IconButton(
                  onPressed: () async {
                    setState(() {
                      isSearchPressed = true;
                    });

                    if (searchKeyword.isEmpty) {
                      // Hiển thị thông báo khi không có từ khóa tìm kiếm
                      showNoResultDialog();
                      setState(() {
                        isSearchPressed = false;
                      });
                    } else {
                      List<TodoModel> allTodos = await firebaseService.getTodos();
                      List<TodoModel> filteredTodos = allTodos.where((todo) {
                        return todo.title.toLowerCase().contains(searchKeyword.toLowerCase()) ||
                            todo.content.toLowerCase().contains(searchKeyword.toLowerCase());
                      }).toList();
                      
                      setState(() {
                        todoList = filteredTodos;
                        isSearchPressed = false;
                      });
                    }
                  },
                  icon: const Icon(Icons.search),
                ),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
              ),
            ),
            Text(
              loggedInUser.fullName ?? '',
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w700, color: Colors.black),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: todoList.length,
                itemBuilder: (context, index) {
                  final color = colors[index % colors.length];
                  return GestureDetector(
                    onLongPress: () {
                      setState(() {
                        selectedIndex = index;
                        deleteTimer = Timer(const Duration(seconds: 2), () {
                          setState(() {
                            selectedIndex = -1; // Ẩn icon xóa
                          });
                        });
                      });
                    },
                    onTap: () {
                      deleteTimer?.cancel(); // Hủy timer khi bấm vào mục
                      if (selectedIndex == index) {
                        deleteTodoDialog(context, index);
                      } else {
                        editTodoDialog(context, index);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.only(bottom: 20),
                      margin: const EdgeInsets.only(top: 16),
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(width: 2, color: AppColors.gray),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.1,
                            child: Column(
                              children: [
                                const SizedBox(height: 15),
                                Text(
                                  DateFormat('hh:mm').format(todoList[index].startTime),
                                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  DateFormat('a').format(todoList[index].startTime),
                                  style: const TextStyle(fontSize: 15,fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 5),
                                IconButton(
                                  onPressed: () async {
                                    // Update the isCompleted status
                                      bool newStatus = !todoList[index].isCompleted!;
                                      try {
                                        await firebaseService.updateTodo(
                                          todoList[index].todoid!,
                                          title: todoList[index].title,
                                          content: todoList[index].content,
                                          startTime: todoList[index].startTime,
                                          endTime: todoList[index].endTime,
                                          isCompleted: newStatus, 
                                          imageBase64: todoList[index].imageBase64,
                                        );
                                        // Update the local list with the new isCompleted status
                                        setState(() {
                                          todoList[index].isCompleted = newStatus;
                                        });
                                      } catch (error) {
                                        // Handle error if needed
                                        print('Error updating todo: $error');
                                      }
                                  },
                                  icon: Icon(
                                    todoList[index].isCompleted
                                        ? Icons.star
                                        : Icons.star_border,
                                    color: todoList[index].isCompleted
                                        ? Colors.amber
                                        : Colors.grey,
                                  ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: color,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    todoList[index].title,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Rubik',
                                      fontSize: 25,
                                      fontStyle: FontStyle.normal,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    todoList[index].content,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Rubik',
                                      fontSize: 20,
                                      fontStyle: FontStyle.normal,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '${DateFormat.jm().format(todoList[index].startTime)} - ${DateFormat.jm().format(todoList[index].endTime)}',
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Rubik',
                                      fontSize: 10,
                                      fontStyle: FontStyle.normal,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if(selectedIndex == index)
                          Padding(
                            padding: const EdgeInsets.only(top: 30),
                            child: IconButton(
                              onPressed: () {
                                deleteTodoDialog(context, index);
                              },
                              
                              icon: const Icon(Icons.delete),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void deleteTodoDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(translation(context).notice),
        content: Text(translation(context).delete),
        actions: [
          TextButton(
            onPressed: () async {
              try {
                await firebaseService.deleteTodo(todoList[index].todoid!);
                setState(() {
                  todoList.removeAt(index);
                  selectedIndex = -1; // Ẩn icon xóa
                });
                // ignore: use_build_context_synchronously
                Navigator.of(context).pop();
              } catch (error) {
                print('Error deleting todo: $error');
                // Xử lý lỗi nếu cần thiết
              }
            },
            child: Text(translation(context).ok),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(translation(context).cancel),
          ),
        ],
      ),
    );
  }

  void editTodoDialog(BuildContext context, int index) {
    final TextEditingController controllerTitle = TextEditingController()
      ..text = todoList[index].title;
    final TextEditingController controllerContent = TextEditingController()
      ..text = todoList[index].content;
    TimeOfDay? timeStart =
                  TimeOfDay.fromDateTime(todoList[index].startTime);
    TimeOfDay? timeEnd =
                  TimeOfDay.fromDateTime(todoList[index].endTime);
    DateTime dateTime = DateTime.now();
    final Size size = MediaQuery.of(context).size;
    showModalBottomSheet(
      context: context,
      builder: (_) => Material(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Container(
            height: size.height * .65,
            color: Colors.white,
            child: Center(
              child: Column(
                children: [
                  TextFormField(
                    controller: controllerTitle,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) => ValidatorUtils.todoValidate(context, value),
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color:AppColors.darkgray),
                    decoration: InputDecoration(
                        labelText: translation(context).title,
                        border: OutlineInputBorder(
                          borderSide:
                              const BorderSide(width: 1, color: AppColors.gray),
                          borderRadius: BorderRadius.circular(12),
                        )),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: controllerContent,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) => ValidatorUtils.todoValidate(context, value),
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color:AppColors.darkgray),
                    decoration: InputDecoration(
                        labelText: translation(context).content,
                        border: OutlineInputBorder(
                          borderSide:
                              const BorderSide(width: 1, color: AppColors.gray),
                          borderRadius: BorderRadius.circular(12),
                        )),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(
                            top: 16, right: 16, bottom: 16),
                        width: 90,
                        child: Text(translation(context).start),
                      ),
                      InkWell(
                        onTap: () async {
                          TimeOfDay? picked = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                          if (picked != null) {
                            setState(() {
                              timeStart = picked;
                            });
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Colors.grey.withOpacity(0.7),
                          ),
                          child: Text(
                            textAlign: TextAlign.center,
                            "${timeStart!.hour}:${timeStart!.minute}",
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(
                            top: 16, right: 16, bottom: 16),
                        width: 90,
                        child: Text(translation(context).end),
                      ),
                      InkWell(
                        onTap: () async {
                          TimeOfDay? picked = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                          if (picked != null) {
                            setState(() {
                              timeEnd = picked;
                            });
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Colors.grey.withOpacity(0.7),
                          ),
                          child: Text(
                            textAlign: TextAlign.center,
                            "${timeEnd!.hour}:${timeEnd!.minute}",
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  Button(
                    onTap: () async {
                      if (controllerTitle.text.isNotEmpty &&
                          controllerContent.text.isNotEmpty) {
                        DateTime startTime = DateTime(
                          dateTime.year,
                          dateTime.month,
                          dateTime.day,
                          timeStart!.hour,
                          timeStart!.minute,
                        );
                        DateTime endTime = DateTime(
                          dateTime.year,
                          dateTime.month,
                          dateTime.day,
                          timeEnd!.hour,
                          timeEnd!.minute,
                        );

                        try {
                          await firebaseService.updateTodo(
                            todoList[index].todoid!,
                            title: controllerTitle.text,
                            content: controllerContent.text,
                            startTime: startTime,
                            endTime: endTime, 
                            imageBase64: '',
                          );
                          // Update the local list with the edited todo
                          setState(() {
                            todoList[index].title = controllerTitle.text;
                            todoList[index].content = controllerContent.text;
                            todoList[index].startTime = startTime;
                            todoList[index].endTime = endTime;
                          });
                          // Close the bottom sheet
                          Navigator.of(context).pop();
                        } catch (error) {
                          // Handle error if needed
                          print('Error updating todo: $error');
                        }
                      }
                    },
                    textButton: translation(context).save,
                  ),
                  const SizedBox(height: 16),
                    Button(
                      textButton: translation(context).cancel,
                      onTap: onTapCancel,
                    )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  void onTapCancel() {
    Navigator.pop(context);
  }
}
