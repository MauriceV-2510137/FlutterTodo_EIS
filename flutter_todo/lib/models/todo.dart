
import 'package:flutter_todo/models/id_generator.dart';

class Todo {
  final String id;
  final String title;
  final String? description;
  final DateTime? dueDate;
  final bool completed;

  Todo({
    String? id,
    required this.title,
    String? description,
    required this.dueDate,
    this.completed = false
    }) : id = id ?? generateId(), description = (description == null || description.trim().isEmpty) ? null : description.trim();

  Todo copyWith({
    String? title,
    String? description,
    DateTime? dueDate,
    bool? completed,
    bool clearDescription = false,
    bool clearDueDate = false,
  }) {
    return Todo(
      id: id,
      title: title ?? this.title,
      description: clearDescription ? null : (description ?? this.description),
      dueDate: clearDueDate ? null : (dueDate ?? this.dueDate),
      completed: completed ?? this.completed,
    );
  }

  @override
  bool operator ==(Object other) => other is Todo && other.id == id;

  @override
  int get hashCode => id.hashCode;

  // Storage //
  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'dueDate': dueDate?.toIso8601String(),
    'completed': completed,
  };

  factory Todo.fromJson(Map<String, dynamic> json) {
    final due = json['dueDate'] as String?;
    return Todo(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      dueDate: due == null ? null : DateTime.parse(due),
      completed: json['completed'],
    );
  }
}