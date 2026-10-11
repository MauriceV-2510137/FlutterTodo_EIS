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

  void reorderTodos(String listId, int oldIndex, int newIndex) {
    _updateList(listId, (list) {
      final todos = [...list.todos];
      if (newIndex > oldIndex) newIndex -= 1;
      final moved = todos.removeAt(oldIndex);
      todos.insert(newIndex, moved);
      return list.copyWith(todos: todos);
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