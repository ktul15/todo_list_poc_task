import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list_poc_task/feature/todo_list/presentation/bloc/todo_list_bloc.dart';
import 'package:todo_list_poc_task/feature/todo_list/presentation/view/todo_list_view.dart';
import 'package:todo_list_poc_task/feature/todo_remote_data_source/todo_remote_data_source.dart';
import 'package:todo_list_poc_task/feature/todo_repository/todo_repository.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key, this.idFromDeepLink});

  final int? idFromDeepLink;

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  @override
  void initState() {
    super.initState();
    print("in here");
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TodoListBloc>(
      create: (_) => TodoListBloc(
        const TodoListInitial(),
        todoRepository: TodoRepository(
          todoRemoteDataSource: TodoRemoteDataSource(),
        ),
      ),
      child: Builder(builder: (context) {
        return const TodoListView();
      }),
    );
  }
}
