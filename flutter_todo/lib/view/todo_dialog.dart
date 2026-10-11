import 'package:flutter/material.dart';
import 'package:flutter_todo/models/date_only.dart';
import 'package:flutter_todo/models/todo.dart';

class TodoDialog extends StatefulWidget {
  final Todo? todo;

  const TodoDialog({super.key, this.todo});

  @override
  State<TodoDialog> createState() => _TodoDialogState();
}

class _TodoDialogState extends State<TodoDialog> {
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;

  DateTime? _dueDate;
  String? _titleError;

  bool get _isEditing => widget.todo != null;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.todo?.title);
    _descriptionController =
        TextEditingController(text: widget.todo?.description);
    _dueDate = widget.todo?.dueDate;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final today = dateOnly(DateTime.now());

    final existing = _dueDate;
    final firstDate =
        (existing != null && existing.isBefore(today)) ? existing : today;

    final date = await showDatePicker(
      context: context,
      initialDate: existing ?? today,
      firstDate: firstDate,
      lastDate: DateTime(2100),
    );
    if (date != null) setState(() => _dueDate = date);
  }

  void _save() {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      setState(() => _titleError = 'Please enter a title');
      return;
    }

    final existing = widget.todo;
    if (existing == null) {
      Navigator.of(context).pop(
        Todo(
          title: title,
          description: _descriptionController.text,
          dueDate: _dueDate,
        ),
      );
    } else {
      Navigator.of(context).pop(
        existing.copyWith( //Same id
          title: title,
          description: _descriptionController.text,
          dueDate: _dueDate,
          clearDueDate: _dueDate == null,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateText = _dueDate == null
        ? 'No due date'
        : MaterialLocalizations.of(context).formatMediumDate(_dueDate!);

    return AlertDialog(
      title: Text(_isEditing ? 'Edit todo' : 'Add todo'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              autofocus: true,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                labelText: 'Title',
                errorText: _titleError,
              ),
              onChanged: (_) {
                if (_titleError != null) setState(() => _titleError = null);
              },
            ),
            TextField(
              controller: _descriptionController,
              textCapitalization: TextCapitalization.sentences,
              minLines: 1,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Description (optional)',
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _pickDate,
                    icon: const Icon(Icons.event),
                    label: Text(dateText),
                  ),
                ),
                if (_dueDate != null)
                  IconButton(
                    tooltip: 'Remove due date',
                    icon: const Icon(Icons.close),
                    onPressed: () => setState(() => _dueDate = null),
                  ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _save,
          child: Text(_isEditing ? 'Save' : 'Add'),
        ),
      ],
    );
  }
}