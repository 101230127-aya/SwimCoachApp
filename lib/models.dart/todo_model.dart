import 'package:uuid/uuid.dart';

class Todo {
  final String id;
  final String title;
  final DateTime date;
  bool completed;

  Todo({
    String? id,
    required this.title,
    required this.completed,
    DateTime? date,
  })  : id = const Uuid().v4(),
        date = date ?? DateTime.now();
  
  Map<String, Object?> get todoMap {
    return {
      'id': id,
      'title': title,
      'completed': completed ? 1 : 0,
      'date': date.millisecondsSinceEpoch,
    };
  }

}