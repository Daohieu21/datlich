import 'package:f_quizz/models/firebase_service.dart';
import 'package:f_quizz/todo/bloc/todo_event.dart';
import 'package:f_quizz/todo/bloc/todo_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final FirebaseService firebaseService;

  TodoBloc({
    required this.firebaseService,
  }) : super(TodoInitial()) {
    on<TodoEventAdd>((event, emit) async {
      try {
        // Thêm Todo vào Firebase
        await firebaseService.addTodo(
          title: event.newTodo.title,
          content: event.newTodo.content,
          startTime: event.newTodo.startTime.toString(),
          endTime: event.newTodo.endTime.toString(),
          imageBase64: event.newTodo.imageBase64,
        );
        // Lấy danh sách Todos sau khi thêm
        final todoList = await firebaseService.getTodos();
        emit(TodoState(todoList: todoList));
      } catch (error) {
        // Xử lý lỗi nếu cần thiết
      }
    });

    on<TodoEventReadData>((event, emit) async {
      try {
        // Lấy danh sách Todos từ Firebase
        final todoList = await firebaseService.getTodos();
        emit(TodoState(todoList: todoList));
      } catch (error) {
        // Xử lý lỗi nếu cần thiết
      }
    });

    on<TodoEventDelete>((event, emit) async {
      try {
        // Xóa Todo khỏi Firebase
        await firebaseService.deleteTodo(state.todoList[event.index].todoid!);
        // Lấy danh sách Todos sau khi xóa
        final todoList = await firebaseService.getTodos();
        emit(TodoState(todoList: todoList));
      } catch (error) {
        // Xử lý lỗi nếu cần thiết
      }
    });

    on<TodoEventEdit>((event, emit) async {
      try {
        // Cập nhật Todo vào Firebase
        await firebaseService.updateTodo(
          state.todoList[event.index].todoid!,
          title: event.editedTodo.title,
          content: event.editedTodo.content,
          startTime: event.editedTodo.startTime,
          endTime: event.editedTodo.endTime,
          imageBase64: event.editedTodo.imageBase64,

        );
        // Lấy danh sách Todos sau khi cập nhật
        final todoList = await firebaseService.getTodos();
        emit(TodoState(todoList: todoList));
      } catch (error) {
        // Xử lý lỗi nếu cần thiết
      }
    });

    on<TodoEventChooseItem>((event, emit) {
      // Không cần thay đổi trạng thái trong trường hợp này
        emit(TodoState(todoList: state.todoList, selectedIndex: event.index));
      });

    on<TodoEventToggleComplete>((event, emit) async {
    try {
      final updatedTodo = state.todoList[event.index].copyWith(
        isCompleted: !state.todoList[event.index].isCompleted,
      );

      // Cập nhật trạng thái isCompleted vào Firebase
      await firebaseService.updateTodo(
        updatedTodo.todoid!,
        title: updatedTodo.title,
        content: updatedTodo.content,
        startTime: updatedTodo.startTime,
        endTime: updatedTodo.endTime,
        isCompleted: updatedTodo.isCompleted,
        imageBase64: updatedTodo.imageBase64,
      );

      // Cập nhật danh sách Todos sau khi cập nhật
      final todoList = await firebaseService.getTodos();
      emit(TodoState(todoList: todoList));
    } catch (error) {
      // Xử lý lỗi nếu cần thiết
    }
    });
  }
}
