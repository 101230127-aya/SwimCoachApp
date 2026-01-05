import 'package:flutter_application_1/db/app_database.dart';
import 'package:flutter_application_1/models.dart/class_model.dart';

// Insert a new class and return its ID
Future<int> insertClass(ClassModel classModel) async {
  AppDatabase database = AppDatabase();
  final db = await database.getDatabase();
  
  return await db.insert('classes', classModel.classMap);
}

// Load all classes from database
Future<List<ClassModel>> loadClasses() async {
  AppDatabase database = AppDatabase();
  final db = await database.getDatabase();
  
  final result = await db.query('classes');
  
  List<ClassModel> resultList = result.map((row) {
    return ClassModel(
      id: row['id'] as int,
      name: row['name'] as String,
      type: classTypeName[row['type'] as String]!,
    );
  }).toList();
  
  return resultList;
}

// Delete a class
void deleteClass(ClassModel classModel) async {
  AppDatabase database = AppDatabase();
  final db = await database.getDatabase();
  
  await db.delete('classes', where: 'id = ?', whereArgs: [classModel.id]);
}