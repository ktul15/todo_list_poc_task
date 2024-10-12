import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list_poc_task/feature/todo_list/domain/repository/todo_repository.dart';

import '../../domain/models/todo.dart';

part 'todo_list_event.dart';
part 'todo_list_state.dart';

class TodoListBloc extends Bloc<TodoListEvent, TodoListState> {
  TodoListBloc(super.initialState, {required TodoRepository todoRepository}) {
    _todoRepository = todoRepository;
    on<TodoListLoaded>(_onInitial);

    add(TodoListLoaded());
  }

  late TodoRepository _todoRepository;

  void _onInitial(TodoListLoaded event, Emitter emit) async {
    emit(const TodoListInProgress());

    final todoList = await _todoRepository.getTodos();
    print("to: ${todoList.length}");

    emit(TodoListSuccess(todoList: todoList));
  }
}
