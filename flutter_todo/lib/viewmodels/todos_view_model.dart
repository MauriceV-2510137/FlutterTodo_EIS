import 'package:flutter/material.dart';
import 'package:flutter_todo/models/todo.dart';

class TodosViewModel extends ChangeNotifier {
  final List<Todo> _currentTodos = [];
  final List<Todo> _completedTodos = [];

  List<Todo> get currentTodos => List.unmodifiable(_currentTodos);
  List<Todo> get completedTodos => List.unmodifiable(_completedTodos);

  bool get isEmpty => _currentTodos.isEmpty;

  void addTodo(Todo todo)
  {
    _currentTodos.add(todo);
    notifyListeners();
  }

  void removeTodo(Todo todo) {
    _currentTodos.remove(todo);
    _completedTodos.remove(todo);
    notifyListeners();
  }

  void completeTodo(Todo todo) {
    if(_currentTodos.contains(todo)) {
      todo.completed = true;
      _completedTodos.add(todo);
      _currentTodos.remove(todo);
      notifyListeners();
    }
  }

  void uncompleteTodo(Todo todo) {
    if(_completedTodos.contains(todo)) {
      todo.completed = false;
      _currentTodos.add(todo);
      _completedTodos.remove(todo);
      notifyListeners();
    }
  }
}