import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_todo/models/todo.dart';
import 'package:flutter_todo/view/todo_dialog.dart';
import 'package:flutter_todo/view/todo_item_tile.dart';
import 'package:flutter_todo/view/widgets/empty_state.dart';
import 'package:flutter_todo/viewmodels/todos_view_model.dart';

class TodoListPage extends StatelessWidget {
  final String listId;

  const TodoListPage({super.key, required this.listId});

  Future<void> _addTodo(BuildContext context) async {
    final viewModel = context.read<TodosViewModel>();

    final todo = await showDialog<Todo>(
      context: context,
      builder: (_) => const TodoDialog(),
    );

    if (todo == null) return;
    viewModel.addTodo(listId, todo);
  }

  @override
  Widget build(BuildContext context) {
    final list = context.watch<TodosViewModel>().listById(listId);

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
      body: list.isEmpty
          ? EmptyState(
              icon: Icons.check_circle_outline,
              title: 'No todos yet',
              message: 'Add your first todo to "${list.name}".',
              actionLabel: 'Add a todo',
              onAction: () => _addTodo(context),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _TodoSection(
                  title: 'To do',
                  listId: listId,
                  todos: list.openTodos,
                  emptyMessage: 'Nothing left to do. Nice work!',
                  reorderable: true,
                ),
                const SizedBox(height: 16),
                _TodoSection(
                  title: 'Completed',
                  listId: listId,
                  todos: list.completedTodos,
                  emptyMessage: 'Nothing completed yet.',
                  onClear: () =>
                      context.read<TodosViewModel>().clearCompleted(listId),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addTodo(context),
        tooltip: 'Add todo',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _TodoSection extends StatelessWidget {
  final String title;
  final String listId;
  final List<Todo> todos;
  final String emptyMessage;
  final bool reorderable;
  final VoidCallback? onClear;

  const _TodoSection({
    required this.title,
    required this.listId,
    required this.todos,
    required this.emptyMessage,
    this.reorderable = false,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 8, 4),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '$title (${todos.length})',
                    style: theme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                if (onClear != null && todos.isNotEmpty)
                  TextButton(
                    onPressed: onClear,
                    child: const Text('Remove all'),
                  ),
              ],
            ),
          ),
          if (todos.isEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Text(
                emptyMessage,
                style: theme.textTheme.bodyMedium
                    ?.copyWith(color: theme.colorScheme.outline),
              ),
            )
          else if (reorderable)
            ReorderableListView(
              // Needed because this list sits inside another scrolling list
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              onReorderItem: (oldIndex, newIndex) => context
                  .read<TodosViewModel>()
                  .reorderOpenTodos(listId, oldIndex, newIndex),
              children: [
                for (final todo in todos)
                  TodoItemTile(
                    key: ValueKey(todo.id),
                    listId: listId,
                    todo: todo,
                  ),
              ],
            )
          else
            for (final todo in todos)
              TodoItemTile(
                key: ValueKey(todo.id),
                listId: listId,
                todo: todo,
              ),
        ],
      ),
    );
  }
}