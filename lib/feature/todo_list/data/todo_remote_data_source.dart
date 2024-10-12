import 'package:dio/dio.dart';

import 'models/todo_list_response.dart';

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

  Future<List<TodoListResponse>> getTodos() async {
    final res = await _dio.get("/");

    print("res from api = ${res.data}");

    List<TodoListResponse> todosList =
        List.generate(res.data.length ?? 0, (index) {
      return TodoListResponse.fromJson(res.data[index]);
    });

    return todosList;
  }
}
