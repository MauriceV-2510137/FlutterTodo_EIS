import 'package:flutter_todo/models/id_generator.dart';
import 'package:flutter_todo/models/todo.dart';

class TodoList {
  final String id;
  final String name;
  final List<Todo> todos;

  TodoList({
    String? id,
    required this.name,
    List<Todo> todos = const [],
  }) : id = id ?? generateId(), todos = List.unmodifiable(todos);

  List<Todo> get openTodos => todos.where((t) => !t.completed).toList();
  List<Todo> get completedTodos => todos.where((t) => t.completed).toList();

  bool get isEmpty => todos.isEmpty;

  TodoList copyWith({
    String? name,
    List<Todo>? todos,
  }) {
    return TodoList(
      id: id,
      name: name ?? this.name,
      todos: todos ?? this.todos,
    );
  }

  @override
  bool operator ==(Object other) => other is TodoList && other.id == id;

  @override
  int get hashCode => id.hashCode;

  // Storage //
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'todos': todos.map((t) => t.toJson()).toList(),
  };

  factory TodoList.fromJson(Map<String, dynamic> json) {
    return TodoList(
      id: json['id'],
      name: json['name'],
      todos: (json['todos'] as List).map((t) => Todo.fromJson(t)).toList(),
    );
  }
}