import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:f_quizz/models/firebase_service.dart';
import 'package:f_quizz/models/language_constants.dart';
import 'package:f_quizz/models/todo_model.dart';
import 'package:f_quizz/models/user_model.dart';
import 'package:f_quizz/resources/colors.dart';
import 'package:f_quizz/todo/bloc/todo_bloc.dart';
import 'package:f_quizz/todo/bloc/todo_event.dart';
import 'package:f_quizz/todo/bloc/todo_state.dart';
import 'package:f_quizz/todo/widget/todo_bottomsheet.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({Key? key}) : super(key: key);
  static const String routeName = "/todo";


  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  final ScrollController _scrollController = ScrollController();
  Map<String, List<TodoModel>> todoMap = {};
  late FirebaseService firebaseService;
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
    loadUserDetails();
    context.read<TodoBloc>().add(TodoEventReadData());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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

  void addTodo(TodoModel newTodo) {
    context.read<TodoBloc>().add(TodoEventAdd(newTodo: newTodo));
  }

  void editTodo(int index, TodoModel newTodo) async {
    context.read<TodoBloc>().add(TodoEventEdit(index: index, editedTodo: newTodo));
  }

  void deleteTodo(int index) async {
    context.read<TodoBloc>().add(TodoEventDelete(index: index));
  }

  void chooseItem(int index) async {
    context.read<TodoBloc>().add(TodoEventChooseItem(index));
  }

  void toggleTodoComplete(int index) {
    context.read<TodoBloc>().add(TodoEventToggleComplete(index));
  }

  Future<void> showTodoBottomSheet(context, TodoModel? currentTodo, int? index) async {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (_) {
        return TodoBottomSheet(
          onAdd: addTodo, 
          onEdit: editTodo, 
          currentTodo: currentTodo,
          index: index,
          );
      }
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
            onPressed: () {
              deleteTodo(index);
              Navigator.of(context).pop();
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
  
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TodoBloc, TodoState>(
      builder: (context, state) {
        final List<TodoModel> todoList = state.todoList;
        return Scaffold(
          body: user != null ? ListView.builder(
            controller: _scrollController,
            itemCount: todoList.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onLongPressStart: (_) async {
                  chooseItem(index);
                },
                onLongPressEnd: (_) {
                  Future.delayed(const Duration(seconds: 2), () {
                    chooseItem(-1);
                  });
                },
                onTap: () async {
                  showTodoBottomSheet(context, todoList[index], index);
                },
                child: Container(
                  padding: const EdgeInsets.only(bottom: 10, top: 10),
                  margin: const EdgeInsets.only(top: 0, left: 10, right: 10),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(width: 2, color: AppColors.gray),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 2,
                            color: Colors.grey,
                          ),
                          borderRadius: BorderRadius.circular(0),
                        ),
                        child: SizedBox(
                          child: Image.memory(
                            base64Decode(todoList[index].imageBase64),
                            fit: BoxFit.cover,
                            width: 90,
                            height: 90,
                          )
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          // decoration: const BoxDecoration(
                          //   color: Colors.red,
                          //   borderRadius: BorderRadius.circular(20),
                          // ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                text: TextSpan(
                                  style: const TextStyle(
                                    fontSize: 16,
                                    //fontWeight: FontWeight.w400,
                                    fontStyle: FontStyle.normal,
                                    color: Colors.black,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: translation(context).title,
                                      style: const TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                    const TextSpan(
                                      text: ':',
                                      style: TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                    const WidgetSpan(child: SizedBox(width: 5),),
                                    TextSpan(
                                      text: todoList[index].title,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                              RichText(
                                text: TextSpan(
                                  style: const TextStyle(
                                    fontSize: 16,
                                    //fontWeight: FontWeight.w400,
                                    fontStyle: FontStyle.normal,
                                    color: Colors.black,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: translation(context).content,
                                      style: const TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                    const TextSpan(
                                      text: ':',
                                      style: TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                    const WidgetSpan(child: SizedBox(width: 5),),
                                    TextSpan(
                                      text: todoList[index].content,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                              RichText(
                                text: TextSpan(
                                  style: const TextStyle(
                                    fontSize: 16,
                                    //fontWeight: FontWeight.w400,
                                    fontStyle: FontStyle.normal,
                                    color: Colors.black,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: translation(context).experience,
                                      style: const TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                    const TextSpan(
                                      text: ':',
                                      style: TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                    const WidgetSpan(child: SizedBox(width: 5),),
                                    TextSpan(
                                      text: todoList[index].experience,
                                    ),
                                    const WidgetSpan(child: SizedBox(width: 5),),
                                    TextSpan(
                                      text: translation(context).year,
                                      style: const TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (state.selectedIndex == index)
                        IconButton(
                          onPressed: () {
                            deleteTodoDialog(context, index);
                          },
                          icon: const Icon(Icons.delete),
                        ),
                    ],
                  ),
                ),
              );
            },
          ) : const Center(
              child: Text(
                "Bạn cần đăng nhập để sử dụng chức năng này",
                style: TextStyle(fontSize: 18),
              ),
            ),
          floatingActionButton: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 30, 0),
            child: FloatingActionButton(
              onPressed: () async {
                showTodoBottomSheet(context, null, null);
              },
              child: const Icon(Icons.add),
            ),
          ),
        );
      },
    );
  }
}
