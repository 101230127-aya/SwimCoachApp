import 'package:flutter/material.dart';
import 'package:flutter_application_1/db/attendance_storage.dart';
import 'package:flutter_application_1/theme_controller.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  final int daysInMonth = 31;
  late List<int> attendance;
  late int todayIndex;

  @override
  void initState() {
    super.initState();

    // Initialize attendance list: 0 = future/not decided, 1 = attended, -1 = absent
    attendance = List.generate(daysInMonth, (index) => 0);

    // Get today index (0-based)
    todayIndex = DateTime.now().day - 1;

    _loadAttendance();
  }
  void _loadAttendance() async {
    final savedData = await loadAttendance();
    final now = DateTime.now();

    for (int i = 0; i < daysInMonth; i++) {
      final dayDate = DateTime(now.year, now.month, i + 1);
      final dateKey = formatDate(dayDate);

      if (savedData.containsKey(dateKey)) {
        attendance[i] = savedData[dateKey]!;
      } else if (i < todayIndex) {
        attendance[i] = -1; // Past days are red
      } else {
        attendance[i] = 0; // Future days are grey
      }
    }

    setState(() {});
  }
  void markAttendance(int index) {
   if (index == todayIndex && attendance[index] == 0) {
      final now = DateTime.now();
      final dateKey = formatDate(DateTime(now.year, now.month, index + 1));

      setState(() {
        attendance[index] = 1; // Mark today as attended
      });

      // Save to database
      saveAttendance(dateKey, 1);
    }
  }

  String _monthName(int month) {
    const months = [
      'January', 'February', 'March', 'April',
      'May', 'June', 'July', 'August',
      'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(title: const Text('Calendar')),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
            ),
            ListTile(
              leading: const Icon(Icons.dark_mode),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Dark Mode'),
                  ValueListenableBuilder<bool>(
                    valueListenable: isDarkMode,
                    builder: (context, dark, _) {
                      return Switch(
                        value: dark,
                        onChanged: (value) {
                          isDarkMode.value = value;
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),

          // Month title
          Text(
            '${_monthName(DateTime.now().month)} ${DateTime.now().year}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),

          // Grid of days
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: GridView.builder(
                itemCount: daysInMonth,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () => markAttendance(index),
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                       color: attendance[index] == 1
                      ? Colors.green
                      : attendance[index] == -1
                      ? Colors.red
                       : isDark
                         ? Colors.grey.shade800
                          : Colors.grey.shade200,

                        border: Border.all(color: Colors.blue),
                        borderRadius: BorderRadius.circular(8),
                      ),
                       child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          fontSize: 16,
                          color: isDark ? Colors.white : Colors.black,
                          fontWeight: FontWeight.w500,
                      ),
                    ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
