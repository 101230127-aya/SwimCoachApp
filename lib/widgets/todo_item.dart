import 'package:flutter/material.dart';
import 'package:flutter_application_1/models.dart/todo_model.dart';

class TodoItem extends StatelessWidget {
  final Todo todo;
  final ValueChanged<bool?> onChanged;

  const TodoItem({
    super.key,
    required this.todo,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: () {
          onChanged(!todo.completed);
        },
        leading: Checkbox(
          value: todo.completed,
          onChanged: onChanged,
        ),
        title: Text(
          todo.title,
          style: TextStyle(
            decoration:
                todo.completed ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Text(
          todo.date.toLocal().toString().split(' ')[0],
        ),
      ),
    );
  }
}

//Notes not to forget:
//todo item is stateless because TodoItem does not manage its own state; the state is managed by the parent StatefulWidget and passed down to it.