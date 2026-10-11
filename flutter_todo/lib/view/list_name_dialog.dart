import 'package:flutter/material.dart';

class ListNameDialog extends StatefulWidget {
  final String? initialName;

  const ListNameDialog({super.key, this.initialName});

  @override
  State<ListNameDialog> createState() => _ListNameDialogState();
}

class _ListNameDialogState extends State<ListNameDialog> {
  late final TextEditingController _controller;
  String? _errorText;

  bool get _isEditing => widget.initialName != null;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialName);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final name = _controller.text.trim();
    if (name.isEmpty) {
      setState(() => _errorText = 'Please enter a name');
      return;
    }
    Navigator.of(context).pop(name);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_isEditing ? 'Rename list' : 'New list'),
      content: TextField(
        controller: _controller,
        autofocus: true,
        textCapitalization: TextCapitalization.sentences,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          labelText: 'List name',
          errorText: _errorText,
        ),
        onChanged: (_) {
          if (_errorText != null) setState(() => _errorText = null);
        },
        onSubmitted: (_) => _submit(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _submit,
          child: Text(_isEditing ? 'Save' : 'Create'),
        ),
      ],
    );
  }
}