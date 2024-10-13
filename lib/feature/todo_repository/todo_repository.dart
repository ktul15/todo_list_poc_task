import 'package:todo_list_poc_task/feature/todo_remote_data_source/todo_remote_data_source.dart';

import '../todo_remote_data_source/models/todo.dart';

class TodoRepository {
  const TodoRepository({required this.todoRemoteDataSource});

  final TodoRemoteDataSource todoRemoteDataSource;

  Future<List<Todo>> getTodos() async {
    final res = await todoRemoteDataSource.getTodos();

    print("res from repo = ${res}");

    return res;
  }

  Future<Todo> addTodo(Todo todo) async {
    Todo todoRequest = Todo(
      text: todo.text,
      date: todo.date,
      isCompleted: todo.isCompleted,
      priority: todo.priority,
    );
    return await todoRemoteDataSource.addTodo(todoRequest);
  }
}
