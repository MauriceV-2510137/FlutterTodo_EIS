import 'package:flutter/material.dart';
import 'package:flutter_todo/models/todo.dart';

class AddTodoDialog extends StatefulWidget {
  const AddTodoDialog({super.key});

  @override
  State<AddTodoDialog> createState() => _AddTodoDialogState();
}

class _AddTodoDialogState extends State<AddTodoDialog> {
  
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  DateTime? dueDate;

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void save() {
    if (titleController.text.trim().isEmpty || dueDate == null) {
      return;
    }
    Navigator.of(context).pop(
      Todo(
        title: titleController.text.trim(),
        dueDate: dueDate!,
        description: descriptionController.text.trim()
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Todo'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(labelText: 'Title'),
          ),

          TextField(
            controller: descriptionController,
            decoration: const InputDecoration(labelText: 'Description'),
          ),

          const SizedBox(height: 16),

          ElevatedButton(
            onPressed: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime(2100),
                initialEntryMode: DatePickerEntryMode.input,
              );

              if (date != null) {
                setState(() {
                  dueDate = date;
                });
              }
            },
            child: Text(
              dueDate == null
                  ? 'Select due date'
                  : '${dueDate!.day}/${dueDate!.month}/${dueDate!.year}',
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(onPressed: save, child: const Text('Add Todo')),
      ],
    );
  }
}
