
import 'package:flutter/material.dart';
import 'package:flutter_todo/models/todo.dart';
import 'package:flutter_todo/view/todo_list_item.dart';
import 'package:flutter_todo/viewmodels/todos_view_model.dart';

class TodoSectionDropdown extends StatefulWidget {

  final String title;
  final List<Todo> todos;
  final TodosViewModel todosViewModel;
  final bool openByDefault;

  const TodoSectionDropdown({
    super.key,
    required this.title,
    required this.todos,
    required this.todosViewModel,
    this.openByDefault = true
  });

  @override
  State<TodoSectionDropdown> createState() => _TodoSectionDropdownState();
}

class _TodoSectionDropdownState extends State<TodoSectionDropdown> {
  late bool expanded;

  @override
  void initState() {
    super.initState();
    expanded = widget.openByDefault;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            title: Text(
              widget.title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: Icon(
              expanded ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_right,
            ),
            onTap: () {
              setState(() {
                expanded = !expanded;
              });
            },
          ),
          
          if(expanded)
            ...widget.todos.map(
              (todo) => TodoListItem(
                todo: todo,
                todosViewModel: widget.todosViewModel,
              ),
            ),
        ],
      )
    );
  }
}