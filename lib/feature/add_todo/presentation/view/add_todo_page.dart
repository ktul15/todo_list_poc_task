import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list_poc_task/feature/add_todo/presentation/bloc/add_todo_bloc.dart';
import 'package:todo_list_poc_task/feature/todo_remote_data_source/todo_remote_data_source.dart';
import 'package:todo_list_poc_task/feature/todo_repository/todo_repository.dart';

import 'add_todo_view.dart';

class AddTodoPage extends StatelessWidget {
  const AddTodoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AddTodoBloc>(
      create: (_) => AddTodoBloc(
        AddTodoState(text: ""),
        todoRepository: TodoRepository(
          todoRemoteDataSource: TodoRemoteDataSource(),
        ),
      ),
      child: AddTodoView(),
    );
  }
}
