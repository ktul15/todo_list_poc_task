import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TodoListScreen extends StatelessWidget {
  const TodoListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(appLocalizations!.todoList),
      ),
      body: Center(
        child: Text(appLocalizations.todoList),
      ),
      floatingActionButton: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
            color: Colors.blue, borderRadius: BorderRadius.circular(32)),
        child: const Icon(
          Icons.add,
          size: 32,
        ),
      ),
    );
  }
}
