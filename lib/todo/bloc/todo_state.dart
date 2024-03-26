
import '../../models/todo_model.dart';

class TodoState {
  final List<TodoModel> todoList;
  final int selectedIndex;
  TodoState({
    this.todoList = const [],
    this.selectedIndex = -1,
  });
}

class TodoInitial extends TodoState {}

class TodoAddState extends TodoState {}
