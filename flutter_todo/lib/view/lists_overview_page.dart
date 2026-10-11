import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_todo/view/todo_list_page.dart';
import 'package:flutter_todo/viewmodels/todos_view_model.dart';

class ListsOverviewPage extends StatelessWidget {
  const ListsOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    // watch = rebuild whenever the view model notifies
    final viewModel = context.watch<TodosViewModel>();
    final lists = viewModel.lists;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('My Lists'),
      ),
      body: ListView(
        children: [
          for (final list in lists)
            ListTile(
              title: Text(list.name),
              subtitle: Text('${list.openTodos.length} open'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => TodoListPage(listId: list.id),
                  ),
                );
              },
            ),
        ],
      ),
      // TEMPORARY
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            viewModel.addList('List ${viewModel.lists.length + 1}'),
        tooltip: 'Add list',
        child: const Icon(Icons.add),
      ),
    );
  }
}