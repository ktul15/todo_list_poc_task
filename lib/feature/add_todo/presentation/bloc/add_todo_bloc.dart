import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:todo_list_poc_task/feature/todo_remote_data_source/models/todo.dart';
import 'package:todo_list_poc_task/feature/todo_repository/todo_repository.dart';

import '../../../../core/firebase_api.dart';
import '../../../../main.dart';

part 'add_todo_event.dart';
part 'add_todo_state.dart';

class AddTodoBloc extends Bloc<AddTodoEvent, AddTodoState> {
  AddTodoBloc(super.initialState, {required TodoRepository todoRepository}) {
    _todoRepository = todoRepository;
    on<AddTodoTextChanged>(_onTodoTextChanged);
    on<AddTodoDateChanged>(_onTodoDateChanged);
    on<AddTodoPriorityChanged>(_onTodoPriorityChanged);
    on<AddTodoFormSubmitted>(_onTodoFormSubmitted);
  }

  late TodoRepository _todoRepository;

  void _onTodoTextChanged(AddTodoTextChanged event, Emitter emit) {
    emit(state.copyWith(text: event.text));
  }

  void _onTodoDateChanged(AddTodoDateChanged event, Emitter emit) {
    emit(state.copyWith(dueDate: event.date));
  }

  void _onTodoPriorityChanged(AddTodoPriorityChanged event, Emitter emit) {
    emit(state.copyWith(todoPriority: event.todoPriority));
  }

  void _onTodoFormSubmitted(AddTodoFormSubmitted event, Emitter emit) async {
    Todo todo = Todo(
      text: state.text,
      date: state.dueDate,
      isCompleted: false,
      priority: state.todoPriority?.text ?? "",
    );
    final newlyAddedTodo = await _todoRepository.addTodo(todo);
    print("new: ${newlyAddedTodo.date}");

    /////////////////////////////////////////
    Dio _dio = Dio();
    final serverAccessToken = await FirebaseApi().getAccessToken();
    final res2 = await _dio.post(
      'https://fcm.googleapis.com/v1/projects/poc-todo-app-74fe1/messages:send',
      data: {
        'message': {
          'token': prefs?.getString("fcmToken"),
          'notification': {
            'title': "Task due today.",
            'body': newlyAddedTodo.text,
          },
          'data': {
            'date': newlyAddedTodo.date.toString(),
          },
        }
      },
      options: Options(
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $serverAccessToken',
        },
      ),
    );

    print("res2 $res2");
    /////////////////////////////////////////

    emit(state.copyWith(newlyAddedTodo: newlyAddedTodo));
  }
}
