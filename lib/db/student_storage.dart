import 'package:flutter_application_1/db/app_database.dart';
import 'package:flutter_application_1/models.dart/student_model.dart';

// Insert a new student
Future<int> insertStudent(StudentModel student) async {
  AppDatabase database = AppDatabase();
  final db = await database.getDatabase();
  
  return await db.insert('students', student.studentMap);
}

// Load students for a specific class
Future<List<StudentModel>> loadStudents(int classId) async {
  AppDatabase database = AppDatabase();
  final db = await database.getDatabase();
  
  final result = await db.query(
    'students',
    where: 'classId = ?',
    whereArgs: [classId],
  );
  
  List<StudentModel> resultList = result.map((row) {
    return StudentModel(
      id: row['id'] as int,
      name: row['name'] as String,
      strength: strengthName[row['strength'] as String]!,
      classId: row['classId'] as int,
    );
  }).toList();
  
  return resultList;
}

// Delete a student
void deleteStudent(StudentModel student) async {
  AppDatabase database = AppDatabase();
  final db = await database.getDatabase();
  
  await db.delete('students', where: 'id = ?', whereArgs: [student.id]);
}