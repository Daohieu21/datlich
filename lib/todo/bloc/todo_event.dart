
import '../../models/todo_model.dart';

class TodoEvent {}

class TodoEventAdd extends TodoEvent {
final TodoModel newTodo;
  TodoEventAdd({ required this.newTodo});
}

class TodoEventReadData extends TodoEvent {}

class TodoEventEdit extends TodoEvent {
  final int index;
  final TodoModel editedTodo;

  TodoEventEdit({required this.index,required this.editedTodo});
}

class TodoEventDelete extends TodoEvent {
  final int index;
  TodoEventDelete({ 
    required this.index});
}

class TodoEventChooseItem extends TodoEvent {
 final int index;

  TodoEventChooseItem(this.index);
}

class TodoEventToggleComplete extends TodoEvent {
  final int index;

  TodoEventToggleComplete(this.index);
}

