import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:todo_list_poc_task/core/utils/preference_keys.dart';
import 'package:todo_list_poc_task/core/utils/urls.dart';

import '../../core/utils/failure.dart';
import '../../main.dart';
import 'models/todo.dart';

class TodoRemoteDataSource {
  TodoRemoteDataSource() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiUrls.jsonPlaceholderBaseUrl,
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

  Future<Either<List<Todo>, Failure>> getTodos() async {
    int? idFromDeepLink =
        int.tryParse(prefs?.getString(PreferenceKeys.idFromDeepLink) ?? "");
    print("idFromDeepLink: $idFromDeepLink");
    Response<dynamic> res;
    List<Todo> todosList;

    try {
      if (idFromDeepLink == null) {
        res = await _dio.get("/");

        if (res.data == null || res.data.length == 0) {
          return right(
              const Failure(message: "Todos not found. Please try again."));
        }

        todosList = List.generate(res.data.length ?? 0, (index) {
          return Todo.fromJson(res.data[index]);
        });
      } else {
        res = await _dio.get("/$idFromDeepLink");

        if (res.data == null) {
          return right(
              const Failure(message: "Todo not found. Please try again."));
        } else if (res.statusCode != 200) {
          return right(Failure(message: res.data));
        }

        prefs?.setString(PreferenceKeys.idFromDeepLink, "");
        Todo todo = Todo.fromJson(res.data);
        todosList = [todo];
      }

      return left(todosList);
    } on DioException catch (e) {
      print("fsadf: $e");

      if (e.type == DioExceptionType.connectionError &&
          e.error is SocketException) {
        return right(const SocketFailure());
      }
      return right(Failure(message: e.message));
    } on Exception {
      return right(const Failure(message: "Something went wrong."));
    }
  }

  Future<Either<Todo, Failure>> addTodo(Todo todo) async {
    try {
      final res = await _dio.post(
        "/",
        data: todo.toJson(),
      );

      if (res.data == null) {
        return right(
            const Failure(message: "Todo not found. Please try again."));
      } else if (res.statusCode != 201) {
        return right(Failure(message: res.data));
      }

      Todo todoRes = Todo.fromJson(res.data);

      final pushRes = await sendPushNotification(todoRes);

      return pushRes.fold((l) {
        return left(todoRes);
      }, (r) {
        return right(Failure(message: r.message));
      });
    } on DioException catch (e) {
      print("fsadf: $e");

      if (e.type == DioExceptionType.connectionError &&
          e.error is SocketException) {
        return right(const SocketFailure());
      }
      return right(Failure(message: e.message));
    } on Exception {
      return right(const Failure());
    }
  }

  Future<Either<void, Failure>> sendPushNotification(Todo todo) async {
    final serverAccessToken = prefs?.getString(PreferenceKeys.accessToken);
    try {
      await _dio.post(
        ApiUrls.googleApiPushSend,
        data: {
          'message': {
            'token': prefs?.getString(PreferenceKeys.fcmToken),
            'notification': {
              'title': "Task due today.",
              'body': todo.text,
            },
            'data': {
              'date': todo.date.toString(),
            },
          }
        },
        options: Options(
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $serverAccessToken',
          },
        ),
      );
      return left(null);
    } on DioException catch (e) {
      print("fsadf: $e");

      if (e.type == DioExceptionType.connectionError &&
          e.error is SocketException) {
        return right(const SocketFailure());
      }
      return right(Failure(message: e.message));
    } on Exception {
      return right(const Failure(message: "Something went wrong."));
    }
  }
}
