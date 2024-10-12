part of 'todo_list_bloc.dart';

sealed class TodoListState extends Equatable {
  const TodoListState();

  @override
  List<Object> get props => [];
}

class TodoListInitial extends TodoListState {
  const TodoListInitial();

  @override
  List<Object> get props => [];
}

class TodoListInProgress extends TodoListState {
  const TodoListInProgress();

  @override
  List<Object> get props => [];
}

class TodoListSuccess extends TodoListState {
  final List<Todo> todoList;

  const TodoListSuccess({required this.todoList});

  @override
  List<Object> get props => [todoList];
}
