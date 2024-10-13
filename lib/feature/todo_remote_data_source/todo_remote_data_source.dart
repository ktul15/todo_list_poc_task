import 'package:dio/dio.dart';

import 'models/todo.dart';

class TodoRemoteDataSource {
  TodoRemoteDataSource() {
    _dio = Dio(
      BaseOptions(
        baseUrl: "https://jsonplaceholder.typicode.com/todos",
        connectTimeout: const Duration(seconds: 5),
        validateStatus: (int? status) {
          return status != null && status >= 200 && status < 300 ||
              status == 409 ||
              status == 400 ||
              status == 500 ||
              status == 401 ||
              status == 405 ||
              status == 403 ||
              status == 422 ||
              status == 404 ||
              status == 402; // Include 409 in the valid status codes
        },
      ),
    );
  }

  late Dio _dio;

  Future<List<Todo>> getTodos() async {
    final res = await _dio.get("/");

    print("res from api = ${res.data}");

    List<Todo> todosList = List.generate(res.data.length ?? 0, (index) {
      return Todo.fromJson(res.data[index]);
    });

    return todosList;
  }

  Future<Todo> addTodo(Todo todo) async {
    final res = await _dio.post(
      "/",
      data: todo.toJson(),
    );

    print("res from api = ${res.data}");
    Todo todoRes = Todo.fromJson(res.data);

    return todoRes;
  }
}
