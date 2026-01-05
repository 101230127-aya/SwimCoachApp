import 'package:flutter/material.dart';
import 'package:flutter_application_1/models.dart/todo_model.dart';
import 'todo_item.dart';

class TodoList extends StatelessWidget {
  final List<Todo> todos;
  final Function(Todo) onToggleTodo;
  final Function(Todo) onDeleteTodo;// ✅ Add this

  const TodoList({
    super.key,
    required this.todos,
    required this.onToggleTodo,
    required this.onDeleteTodo, // ✅ Add this
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: todos.length,
      itemBuilder: (context, index) {
        return Dismissible(
          key: ValueKey(todos[index].id),
          direction: DismissDirection.endToStart,
          onDismissed: (_) {
            onDeleteTodo(todos[index]); // ✅ Call delete
          },
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          child: TodoItem(
            todo: todos[index],
            onChanged: (value) {
              onToggleTodo(todos[index]);
            },
          ),
        );
      },
    );
  }
}