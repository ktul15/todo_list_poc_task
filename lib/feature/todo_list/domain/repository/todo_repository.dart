import 'package:intl/intl.dart';
import 'package:todo_list_poc_task/feature/todo_list/data/todo_remote_data_source.dart';

import '../models/todo.dart';

class TodoRepository {
  const TodoRepository({required this.todoRemoteDataSource});

  final TodoRemoteDataSource todoRemoteDataSource;

  Future<List<Todo>> getTodos() async {
    final res = await todoRemoteDataSource.getTodos();

    print("res from repo = ${res}");

    List<Todo> todoList = [];

    res.forEach((todo) {
      todoList.add(
        Todo(
          text: todo.title ?? "",
          date: DateFormat("dd MMM yyyy").format(DateTime.now()),
          isCompleted: todo.completed ?? false,
        ),
      );
    });

    return todoList;
  }
}
