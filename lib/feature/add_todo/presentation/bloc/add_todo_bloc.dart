import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
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
    emit(state.copyWith(isInProgress: true, errorMessage: ""));
    Todo todo = Todo(
      text: state.text,
      date: state.dueDate,
      isCompleted: false,
      priority: state.todoPriority?.text ?? "",
    );
    final res = await _todoRepository.addTodo(todo);

    res.fold((todo) async {
      print("new: ${todo.date}");

      emit(state.copyWith(
        newlyAddedTodo: todo,
        errorMessage: "",
        isInProgress: false,
      ));
    }, (failure) {
      emit(state.copyWith(
        newlyAddedTodo: null,
        errorMessage: failure.message,
        isInProgress: false,
      ));
    });
  }
}
