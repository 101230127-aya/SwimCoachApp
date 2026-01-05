import 'package:flutter_application_1/models.dart/class_model.dart';
import 'package:flutter_application_1/models.dart/todo_model.dart';
import 'package:flutter_application_1/screens.dart/attendance_screen.dart';
import 'package:flutter_application_1/screens.dart/classes_screen.dart';
import 'package:flutter_application_1/screens.dart/todo_screen.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget{
  final List<ClassModel> classes;
  final List<Todo> todos;
  
  const MainScreen({
    super.key,
    required this.classes,
    required this.todos,
    });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // ✅✅✅ CREATE THE PAGES LIST HERE - INSIDE BUILD METHOD ✅✅✅
    final List<Map<String, Object>> pages = [
      {
        'page': const AttendanceScreen(),
        'title': 'Attendance',
      },
      {
        'page': ClassesScreen(classList: widget.classes), // ✅ Now widget works!
        'title': 'Classes',
      },
      {
        'page': TodoScreen(todosList: widget.todos), // ✅ Now widget works!
        'title': 'To-Do List',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Swim Coach App'),
            Text(
              pages[_selectedIndex]['title'] as String,
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
      body: pages[_selectedIndex]['page'] as Widget,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _selectPage,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Attendance',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pool),
            label: 'Classes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_box),
            label: 'Tasks',
          ),
        ],
      ),
    );
  }
}