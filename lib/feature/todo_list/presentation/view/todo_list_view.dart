import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_list_poc_task/core/router/path_constants.dart';
import 'package:todo_list_poc_task/feature/todo_list/presentation/bloc/todo_list_bloc.dart';

import '../../../todo_remote_data_source/models/todo.dart';

class TodoListView extends StatelessWidget {
  const TodoListView({super.key});

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(appLocalizations!.todoList),
      ),
      body: BlocBuilder<TodoListBloc, TodoListState>(
        builder: (context, state) {
          switch (state) {
            case TodoListInProgress():
              return const Center(
                child: CircularProgressIndicator(),
              );
            case TodoListInitial():
              return const Center(
                child: CircularProgressIndicator(),
              );
            case TodoListSuccess():
              final todoList = state.todoList;
              return ListView.separated(
                itemCount: todoList.length,
                itemBuilder: (context, index) {
                  final currentTodo = todoList[index];
                  return TodoItem(
                    text: currentTodo.text ?? "",
                    date: currentTodo.date.toString(),
                    isCompleted: currentTodo.isCompleted ?? false,
                  );
                },
                separatorBuilder: (context, index) {
                  if (index != todoList.length - 1) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      height: 2,
                      color: Colors.grey.withOpacity(0.5),
                    );
                  } else {
                    return Container();
                  }
                },
              );
          }
        },
      ),
      floatingActionButton: InkWell(
        onTap: () {
          context.pushNamed(PathConstants.addTodo).then((value) {
            print("val: $value");
            if (value != null) {
              context
                  .read<TodoListBloc>()
                  .add(TodoListNewTodoAdded(todo: value as Todo));
            }
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
              color: Colors.blue, borderRadius: BorderRadius.circular(32)),
          child: const Icon(
            Icons.add,
            size: 32,
          ),
        ),
      ),
    );
  }
}

class TodoItem extends StatelessWidget {
  const TodoItem(
      {super.key,
      required this.text,
      required this.date,
      required this.isCompleted});

  final String text;
  final String date;
  final bool isCompleted;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                  child: Text(
                text,
                maxLines: 2,
              )),
              Text(isCompleted == true ? "Completed" : "Pending"),
            ],
          ),
          Text(date),
        ],
      ),
    );
  }
}
