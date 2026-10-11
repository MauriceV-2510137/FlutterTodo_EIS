
import 'package:flutter/material.dart';
import 'package:flutter_todo/models/todo.dart';
import 'package:flutter_todo/view/add_todo_dialog.dart';
import 'package:flutter_todo/viewmodels/todos_view_model.dart';

class TodoListItem extends StatelessWidget {
  final Todo todo;
  final TodosViewModel todosViewModel;

  const TodoListItem({
    super.key,
    required this.todo,
    required this.todosViewModel,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Checkbox(
        value: todo.completed,
        onChanged: (value) {
          if (value == true) {
            todosViewModel.completeTodo(todo);
          } else {
            todosViewModel.uncompleteTodo(todo);
          }
        },
      ),
      title: Text(todo.title),
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => const AddTodoDialog(),
        );
      },
    );
  }
}