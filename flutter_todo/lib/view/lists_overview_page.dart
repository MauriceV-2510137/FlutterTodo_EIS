import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_todo/models/todo_list.dart';
import 'package:flutter_todo/view/list_name_dialog.dart';
import 'package:flutter_todo/view/todo_list_page.dart';
import 'package:flutter_todo/view/widgets/empty_state.dart';
import 'package:flutter_todo/viewmodels/todos_view_model.dart';

class ListsOverviewPage extends StatelessWidget {
  const ListsOverviewPage({super.key});

  Future<void> _addList(BuildContext context) async {
    final viewModel = context.read<TodosViewModel>();

    final name = await showDialog<String>(
      context: context,
      builder: (_) => const ListNameDialog(),
    );

    if (name == null) return;
    viewModel.addList(name);
  }

  Future<void> _renameList(BuildContext context, TodoList list) async {
    final viewModel = context.read<TodosViewModel>();

    final name = await showDialog<String>(
      context: context,
      builder: (_) => ListNameDialog(initialName: list.name),
    );

    if (name == null) return;
    viewModel.renameList(list.id, name);
  }

  Future<void> _deleteList(BuildContext context, TodoList list) async {
    final viewModel = context.read<TodosViewModel>();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete list?'),
        content: Text('"${list.name}" and all its todos will be deleted.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      viewModel.removeList(list.id);
    }
  }

  String _subtitle(TodoList list) {
    if (list.isEmpty) return 'No todos yet';
    final open = list.openTodos.length;
    final done = list.completedTodos.length;
    if (open == 0) return 'All done! ($done completed)';
    return '$open open · $done done';
  }

  @override
  Widget build(BuildContext context) {
    final lists = context.watch<TodosViewModel>().lists;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('My Lists'),
      ),
      body: lists.isEmpty
          ? EmptyState(
              icon: Icons.checklist,
              title: 'No lists yet',
              message: 'Create your first list to start adding todos.',
              actionLabel: 'Create a list',
              onAction: () => _addList(context),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                for (final list in lists)
                  Card(
                    child: ListTile(
                      title: Text(list.name),
                      subtitle: Text(_subtitle(list)),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit_outlined),
                            tooltip: 'Rename list',
                            onPressed: () => _renameList(context, list),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline),
                            tooltip: 'Delete list',
                            onPressed: () => _deleteList(context, list),
                          ),
                          const Icon(Icons.chevron_right),
                        ],
                      ),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => TodoListPage(listId: list.id),
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addList(context),
        tooltip: 'Add list',
        child: const Icon(Icons.add),
      ),
    );
  }
}
