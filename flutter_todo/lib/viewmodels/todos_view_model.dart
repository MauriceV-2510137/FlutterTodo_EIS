import 'package:flutter/foundation.dart';
import 'package:flutter_todo/models/todo.dart';
import 'package:flutter_todo/models/todo_list.dart';

class TodosViewModel extends ChangeNotifier {
  final List<TodoList> _lists = [];

  List<TodoList> get lists => List.unmodifiable(_lists);

  TodoList? listById(String listId) {
    for (final list in _lists) {
      if (list.id == listId) return list;
    }
    return null;
  }

  // ---------- Lists ----------

  void addList(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return;
    _lists.add(TodoList(name: trimmed));
    notifyListeners();
  }

  void renameList(String listId, String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return;
    _updateList(listId, (list) => list.copyWith(name: trimmed));
  }

  void removeList(String listId) {
    _lists.removeWhere((list) => list.id == listId);
    notifyListeners();
  }

  // ---------- Todos ----------

  void addTodo(String listId, Todo todo) {
    _updateList(
      listId,
      (list) => list.copyWith(todos: [...list.todos, todo]),
    );
  }

  void updateTodo(String listId, Todo updated) {
    _updateList(
      listId,
      (list) => list.copyWith(
        todos: [for (final t in list.todos) t.id == updated.id ? updated : t],
      ),
    );
  }

  void removeTodo(String listId, String todoId) {
    _updateList(
      listId,
      (list) => list.copyWith(
        todos: list.todos.where((t) => t.id != todoId).toList(),
      ),
    );
  }

  void setCompleted(String listId, String todoId, bool completed) {
    _updateList(
      listId,
      (list) => list.copyWith(
        todos: [
          for (final t in list.todos)
            t.id == todoId ? t.copyWith(completed: completed) : t,
        ],
      ),
    );
  }

  void clearCompleted(String listId) {
    _updateList(
      listId,
      (list) => list.copyWith(todos: list.openTodos),
    );
  }

  void reorderOpenTodos(String listId, int oldIndex, int newIndex) {
    _updateList(listId, (list) {

      final open = [...list.openTodos];
      final moved = open.removeAt(oldIndex);
      open.insert(newIndex, moved);

      // Open todos first in their new order, completed todos after them
      return list.copyWith(todos: [...open, ...list.completedTodos]);
    });
  }

  // ---------- Internal ----------

  void _updateList(String listId, TodoList Function(TodoList) change) {
    final index = _lists.indexWhere((l) => l.id == listId);
    if (index == -1) return;
    _lists[index] = change(_lists[index]);
    notifyListeners();
  }
}