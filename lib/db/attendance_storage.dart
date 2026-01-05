import 'package:flutter_application_1/db/app_database.dart';
import 'package:sqflite/sqflite.dart';

// Format date as string key (YYYY-MM-DD)
String formatDate(DateTime date) {
  return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}

// Save attendance for a specific date
void saveAttendance(String dateKey, int status) async {
  AppDatabase database = AppDatabase();
  final db = await database.getDatabase();
  
  await db.insert(
    'attendance',
    {'date': dateKey, 'status': status},
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

// Load all attendance records
Future<Map<String, int>> loadAttendance() async {
  AppDatabase database = AppDatabase();
  final db = await database.getDatabase();
  
  final result = await db.query('attendance');
  
  Map<String, int> attendanceMap = {};
  for (var row in result) {
    attendanceMap[row['date'] as String] = row['status'] as int;
  }
  
  return attendanceMap;
}