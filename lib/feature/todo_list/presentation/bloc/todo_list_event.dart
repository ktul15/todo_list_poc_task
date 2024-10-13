part of 'todo_list_bloc.dart';

sealed class TodoListEvent {
  const TodoListEvent();
}

class TodoListLoaded extends TodoListEvent {
  TodoListLoaded();
}

class TodoListNewTodoAdded extends TodoListEvent {
  TodoListNewTodoAdded({required this.todo});

  final Todo todo;
}
