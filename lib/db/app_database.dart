import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  Future<Database> getDatabase() async {
    String dbPath = await getDatabasesPath();
    
    Database db = await openDatabase(
      join(dbPath, 'coach_app.db'),
      onCreate: (db, version) async {
        // Create classes table
        await db.execute(
          'CREATE TABLE classes(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, type TEXT)',
        );
        
        // Create students table
        await db.execute(
          'CREATE TABLE students(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, strength TEXT, classId INTEGER)',
        );
        
        // Create todos table
        await db.execute(
          'CREATE TABLE todos(id TEXT PRIMARY KEY, title TEXT, completed INTEGER, date INTEGER)',
        );
        
        // Create attendance table
        await db.execute(
          'CREATE TABLE attendance(date TEXT PRIMARY KEY, status INTEGER)',
        );
      },
      version: 1,
    );
    
    return db;
  }
}