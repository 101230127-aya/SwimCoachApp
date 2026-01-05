import 'dart:io';

import 'package:flutter_application_1/db/class_storage.dart';
import 'package:flutter_application_1/db/todo_storage.dart';
import 'package:flutter_application_1/models.dart/class_model.dart';
import 'package:flutter_application_1/models.dart/todo_model.dart';
import 'package:flutter_application_1/screens.dart/Mainscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/theme_controller.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() async {
  // Required before any async code in main
  WidgetsFlutterBinding.ensureInitialized();

  // Change the database factory if you are running a Windows application
  if (Platform.isWindows) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  // Load classes and todos from the database
  List<ClassModel> classesList = await loadClasses();
  List<Todo> todosList = await loadTodos();

  // Pass the loaded data to MyApp
  runApp(MyApp(
    classes: classesList,
    todos: todosList,
  ));
}

ValueNotifier<ThemeMode> appThemeMode = ValueNotifier(ThemeMode.light);

class MyApp extends StatelessWidget {
  final List<ClassModel> classes;
  final List<Todo> todos;

  const MyApp({
    super.key,
    required this.classes,
    required this.todos,
  });


  @override
  Widget build(BuildContext context) {
  return ValueListenableBuilder<bool>(
      valueListenable: isDarkMode,
      builder: (context, dark, _) {
        return MaterialApp(
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: dark ? ThemeMode.dark : ThemeMode.light,
          debugShowCheckedModeBanner: false,
          home:  MainScreen(
            classes: classes,
            todos: todos),
        );
      },
    );
  }
}

