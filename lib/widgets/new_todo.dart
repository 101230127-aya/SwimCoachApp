import 'package:flutter/material.dart';

class NewTodo extends StatefulWidget {
  final Function(String) onAddTodo;

  const NewTodo({super.key, required this.onAddTodo});

  @override
  State<NewTodo> createState() => _NewTodoState();
}

class _NewTodoState extends State<NewTodo> {
  final TextEditingController _titleController = TextEditingController();

  void _saveTodo() {
    if (_titleController.text.trim().isEmpty) {
      return;
    }

    widget.onAddTodo(_titleController.text.trim());
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'Todo title',
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: _saveTodo,
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}