part of 'add_todo_bloc.dart';

class AddTodoState extends Equatable {
  AddTodoState({
    required this.text,
    this.dueDate,
    this.todoPriority,
    this.newlyAddedTodo,
    required this.errorMessage,
    this.isInProgress,
  });

  final String text;
  DateTime? dueDate;
  TodoPriority? todoPriority = TodoPriority.low;
  Todo? newlyAddedTodo;
  String errorMessage;
  bool? isInProgress;

  @override
  List<Object> get props => [
        text,
        dueDate ?? DateTime.now(),
        todoPriority ?? TodoPriority.low,
        newlyAddedTodo ?? Todo(),
        errorMessage,
        isInProgress ?? false,
      ];

  AddTodoState copyWith({
    String? text,
    DateTime? dueDate,
    TodoPriority? todoPriority,
    Todo? newlyAddedTodo,
    String? errorMessage,
    bool? isInProgress,
  }) {
    return AddTodoState(
      text: text ?? this.text,
      dueDate: dueDate ?? this.dueDate,
      todoPriority: todoPriority ?? this.todoPriority,
      newlyAddedTodo: newlyAddedTodo ?? this.newlyAddedTodo,
      errorMessage: errorMessage ?? this.errorMessage,
      isInProgress: isInProgress ?? this.isInProgress,
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
