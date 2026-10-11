
import 'package:flutter/material.dart';
import 'package:flutter_todo/view/add_todo_dialog.dart';
import 'package:flutter_todo/view/todo_section_dropdown.dart';
import 'package:flutter_todo/viewmodels/todos_view_model.dart';


class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  final TodosViewModel todosViewModel = TodosViewModel();

  Future<void> _addTodo() async {
    final todo = await showDialog(
      context: context,
      builder: (context) => const AddTodoDialog(),
    );

    if (todo == null) return;

    todosViewModel.addTodo(todo);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('My Todos'),
      ),
      body: AnimatedBuilder(
        animation: todosViewModel,
        builder: (context, child) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              TodoSectionDropdown(
                title: 'Current',
                todos: todosViewModel.currentTodos,
                todosViewModel: todosViewModel,
              ),

              const SizedBox(height: 16),

              TodoSectionDropdown(
                title: 'Completed',
                todos: todosViewModel.completedTodos,
                todosViewModel: todosViewModel,
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTodo,
        tooltip: 'Add Todo',
        child: const Icon(Icons.add),
      ),
    );
  }
}