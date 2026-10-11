import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_todo/viewmodels/todos_view_model.dart';

class TodoListPage extends StatelessWidget {
  final String listId;

  const TodoListPage({super.key, required this.listId});

  @override
  Widget build(BuildContext context) {
    final list = context.watch<TodosViewModel>().listById(listId);

    // The list can disappear (e.g. removed while this page is open)
    if (list == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('This list no longer exists.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(list.name),
      ),
      // PLACEHOLDER: real todo UI comes in step 5
      body: Center(
        child: Text('${list.todos.length} todos'),
      ),
    );
  }
}