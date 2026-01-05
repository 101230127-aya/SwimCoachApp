import 'package:flutter/material.dart';
import 'package:flutter_application_1/db/todo_storage.dart';
import 'package:flutter_application_1/models.dart/todo_model.dart';
import '../widgets/todo_list.dart';
import '../widgets/new_todo.dart';

class TodoScreen extends StatefulWidget {
  final List<Todo> todosList;

  const TodoScreen({
    super.key,
    required this.todosList,
  });

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  void _addTodo(String title) {
    Todo newTodo = Todo(
      title: title,
      completed: false,
    );

    setState(() {
      widget.todosList.add(newTodo);

      // Sort: incomplete tasks first
      widget.todosList.sort((a, b) {
        if (a.completed == b.completed) return 0;
        return a.completed ? 1 : -1;
      });
    });

    // Insert into database
    insertTodo(newTodo);
  }

  void _toggleTodo(Todo todo) {
    setState(() {
      todo.completed = !todo.completed;

      // Sort: incomplete tasks first
      widget.todosList.sort((a, b) {
        if (a.completed == b.completed) return 0;
        return a.completed ? 1 : -1;
      });
    });

    // Update in database
    updateTodo(todo);
  }

  void _deleteTodo(Todo todo) {
    setState(() {
      widget.todosList.remove(todo);
    });

    // Delete from database
    deleteTodo(todo);
  }

  void _openAddTodoModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => NewTodo(onAddTodo: _addTodo),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget mainContent = const Center(
      child: Text(
        'No tasks yet',
        style: TextStyle(fontSize: 18),
      ),
    );

    if (widget.todosList.isNotEmpty) {
      mainContent = TodoList(
        todos: widget.todosList,
        onToggleTodo: _toggleTodo,
        onDeleteTodo: _deleteTodo,
      );
    }

    return Scaffold(
      body: Column(
        children: [
          Expanded(child: mainContent),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddTodoModal,
        child: const Icon(Icons.add),
      ),
    );
  }
}