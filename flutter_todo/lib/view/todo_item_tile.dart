import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_todo/models/date_only.dart';
import 'package:flutter_todo/models/todo.dart';
import 'package:flutter_todo/viewmodels/todos_view_model.dart';

class TodoItemTile extends StatelessWidget {
  final String listId;
  final Todo todo;

  const TodoItemTile({super.key, required this.listId, required this.todo});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final due = todo.dueDate;
    final description = todo.description;

    final isOverdue = due != null &&
        !todo.completed &&
        dateOnly(due).isBefore(dateOnly(DateTime.now()));

    final dueText = due == null
        ? null
        : 'Due: ${MaterialLocalizations.of(context).formatMediumDate(due)}';

    return ListTile(
      leading: Checkbox(
        value: todo.completed,
        onChanged: (value) => context
            .read<TodosViewModel>()
            .setCompleted(listId, todo.id, value ?? false),
      ),
      title: Text(
        todo.title,
        style: todo.completed
            ? TextStyle(
                decoration: TextDecoration.lineThrough,
                color: theme.colorScheme.outline,
              )
            : null,
      ),
      trailing: IconButton(
        icon: const Icon(Icons.delete_outline),
        tooltip: 'Delete todo',
        onPressed: () =>
            context.read<TodosViewModel>().removeTodo(listId, todo.id),
      ),
      subtitle: (description == null && dueText == null)
          ? null
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (description != null)
                  Text(description, maxLines: 2, overflow: TextOverflow.ellipsis),
                if (dueText != null)
                  Text(
                    dueText,
                    style: isOverdue
                        ? TextStyle(color: theme.colorScheme.error)
                        : null,
                  ),
              ],
            ),
    );
  }
}