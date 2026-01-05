import 'package:flutter_application_1/db/app_database.dart';
import 'package:flutter_application_1/models.dart/todo_model.dart';

// Insert a new todo
void insertTodo(Todo todo) async {
  AppDatabase database = AppDatabase();
  final db = await database.getDatabase();
  
  await db.insert('todos', todo.todoMap);
}

// Load all todos from database
Future<List<Todo>> loadTodos() async {
  AppDatabase database = AppDatabase();
  final db = await database.getDatabase();
  
  final result = await db.query('todos');
  
  List<Todo> resultList = result.map((row) {
    return Todo(
      id: row['id'] as String,
      title: row['title'] as String,
      completed: (row['completed'] as int) == 1,
      date: DateTime.fromMillisecondsSinceEpoch(row['date'] as int),
    );
  }).toList();
  
  return resultList;
}

// Delete a todo
void deleteTodo(Todo todo) async {
  AppDatabase database = AppDatabase();
  final db = await database.getDatabase();
  
  await db.delete('todos', where: 'id = ?', whereArgs: [todo.id]);
}

// Update todo completion status
void updateTodo(Todo todo) async {
  AppDatabase database = AppDatabase();
  final db = await database.getDatabase();
  
  await db.update(
    'todos',
    todo.todoMap,
    where: 'id = ?',
    whereArgs: [todo.id],
  );
}