import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list_poc_task/feature/todo_repository/todo_repository.dart';

import '../../../todo_remote_data_source/models/todo.dart';

part 'todo_list_event.dart';
part 'todo_list_state.dart';

class TodoListBloc extends Bloc<TodoListEvent, TodoListState> {
  TodoListBloc(super.initialState, {required TodoRepository todoRepository}) {
    _todoRepository = todoRepository;
    on<TodoListLoaded>(_onInitial);
    on<TodoListNewTodoAdded>(_onNewTodoAdded);

    add(TodoListLoaded());
  }

  late TodoRepository _todoRepository;
  int? idFromDeepLink;

  void _onInitial(TodoListLoaded event, Emitter emit) async {
    emit(const TodoListInProgress());

    final res = await _todoRepository.getTodos();

    List<Todo> todoList = [];

    res.forEach((todo) {
      todoList.add(
        Todo(
          text: todo.text ?? "",
          date: DateTime.now(),
          isCompleted: todo.isCompleted ?? false,
          priority: todo.priority,
        ),
      );
    });

    print("to: ${todoList.length}");

    emit(TodoListSuccess(todoList: todoList.reversed.toList()));
  }

  void _onNewTodoAdded(TodoListNewTodoAdded event, Emitter emit) async {
    // emit(const TodoListInProgress());

    final previousTodoList =
        (state as TodoListSuccess).todoList.reversed.toList();
    final newTodoList = [...previousTodoList, event.todo];
    print("newTodoList: ${newTodoList.length}");

    emit(TodoListSuccess(todoList: newTodoList.reversed.toList()));
  }
}
