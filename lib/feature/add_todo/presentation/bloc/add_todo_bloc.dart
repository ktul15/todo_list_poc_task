import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:todo_list_poc_task/feature/todo_remote_data_source/models/todo.dart';
import 'package:todo_list_poc_task/feature/todo_repository/todo_repository.dart';

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
      date: DateFormat().format(state.dueDate ?? DateTime.now()),
      isCompleted: false,
      priority: state.todoPriority?.text ?? "",
    );
    final newlyAddedTodo = await _todoRepository.addTodo(todo);
    print("new: $newlyAddedTodo");
    emit(state.copyWith(newlyAddedTodo: newlyAddedTodo));
  }
}
