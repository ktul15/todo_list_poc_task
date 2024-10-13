part of 'add_todo_bloc.dart';

sealed class AddTodoEvent {
  const AddTodoEvent();
}

class AddTodoTextChanged extends AddTodoEvent {
  const AddTodoTextChanged({required this.text});

  final String text;
}

class AddTodoDateChanged extends AddTodoEvent {
  const AddTodoDateChanged({required this.date});

  final DateTime date;
}

class AddTodoPriorityChanged extends AddTodoEvent {
  const AddTodoPriorityChanged({required this.todoPriority});

  final TodoPriority todoPriority;
}

class AddTodoFormSubmitted extends AddTodoEvent {
  const AddTodoFormSubmitted();
}
