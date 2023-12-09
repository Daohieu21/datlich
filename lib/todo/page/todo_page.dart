import 'dart:async';
import 'dart:convert';
import 'package:f_quizz/models/language_constants.dart';
import 'package:f_quizz/models/todo_model.dart';
import 'package:f_quizz/resources/colors.dart';
import 'package:f_quizz/todo/bloc/todo_bloc.dart';
import 'package:f_quizz/todo/bloc/todo_event.dart';
import 'package:f_quizz/todo/bloc/todo_state.dart';
import 'package:f_quizz/todo/widget/todo_bottomsheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({Key? key}) : super(key: key);
  static const String routeName = "/todo";


  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  final ScrollController _scrollController = ScrollController();
  Map<String, List<TodoModel>> todoMap = {};
  int selectedIndex = -1;

  @override
  void initState() {
    super.initState();
    context.read<TodoBloc>().add(TodoEventReadData());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
          body: ListView.builder(
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
                  padding: const EdgeInsets.only(bottom: 10),
                  margin: const EdgeInsets.only(top: 16, left: 16, right: 16),
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
                            color: Colors.blue,
                          ),
                          borderRadius: BorderRadius.circular(0),
                        ),
                        child: SizedBox(
                          child: Image.memory(
                            base64Decode(todoList[index].imageBase64),
                            fit: BoxFit.cover,
                            width: 100,
                            height: 100,
                          )
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            //color: Colors.white,
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
