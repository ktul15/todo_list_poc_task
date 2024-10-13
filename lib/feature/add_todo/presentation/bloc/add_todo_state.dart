part of 'add_todo_bloc.dart';

class AddTodoState extends Equatable {
  AddTodoState({
    required this.text,
    this.dueDate,
    this.todoPriority,
    this.newlyAddedTodo,
  });

  final String text;
  DateTime? dueDate;
  TodoPriority? todoPriority = TodoPriority.low;
  Todo? newlyAddedTodo;

  @override
  List<Object> get props => [
        text,
        dueDate ?? DateTime.now(),
        todoPriority ?? TodoPriority.low,
        newlyAddedTodo ?? Todo(),
      ];

  AddTodoState copyWith({
    String? text,
    DateTime? dueDate,
    TodoPriority? todoPriority,
    Todo? newlyAddedTodo,
  }) {
    return AddTodoState(
      text: text ?? this.text,
      dueDate: dueDate ?? this.dueDate,
      todoPriority: todoPriority ?? this.todoPriority,
      newlyAddedTodo: newlyAddedTodo ?? this.newlyAddedTodo,
    );
  }
}

enum TodoPriority {
  low(text: "Low"),
  medium(text: "Medium"),
  high(text: "High");

  const TodoPriority({required this.text});

  final String text;
}
