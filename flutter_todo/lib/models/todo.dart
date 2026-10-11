class Todo {
  String id;
  String title;
  DateTime dueDate;
  String? description;

  bool completed;

  Todo({required this.title, required this.dueDate, this.description, this.completed = false}) : id = DateTime.now().microsecondsSinceEpoch.toString();
}