import 'package:flutter/material.dart';
import 'package:flutter_application_1/db/student_storage.dart';
import 'package:flutter_application_1/models.dart/student_model.dart';

enum StrengthFilter { all, weak, medium, strong }

class StudentsScreen extends StatefulWidget {
  final int classId;

  const StudentsScreen({
    super.key,
    required this.classId,
  });

  @override
  State<StudentsScreen> createState() => _StudentsScreenState();
}

class _StudentsScreenState extends State<StudentsScreen> {
  List<StudentModel> students = [];

  StrengthFilter selectedFilter = StrengthFilter.all;

@override
  void initState() {
    super.initState();
    _loadStudents();
  }
    void _loadStudents() async {
    final loadedStudents = await loadStudents(widget.classId);
    setState(() {
      students = loadedStudents;
    });
  }
    // Add new student
  void _addStudent(String name, Strength strength) async {
  // Create a temporary student with id = 0
  StudentModel tempStudent = StudentModel(
    id: 0,
    name: name,
    strength: strength,
    classId: widget.classId,
  );
  // Insert into database and get the real id
  int insertedId = await insertStudent(tempStudent);
  // Create the FINAL student with the real database ID
  StudentModel newStudent = StudentModel(
    id: insertedId,
    name: name,
    strength: strength,
    classId: widget.classId,
  );
  setState(() {
    students.add(newStudent); // Add the student with correct ID
  });
}

   // Delete student
  void _deleteStudent(StudentModel student) async {
    setState(() {
      students.removeWhere((s) => s.id == student.id);
    });

    // Delete from database
    deleteStudent(student);
  }

  // 🔹 FILTERED LIST (DERIVED DATA)
  List<StudentModel> get filteredStudents {
    if (selectedFilter == StrengthFilter.all) {
      return students;
    }
    return students.where((student) {
      return student.strength.name == selectedFilter.name;
    }).toList();
  }

  // 🔹 COLOR BASED ON STRENGTH
  Color strengthColor(Strength strength) {
    switch (strength) {
      case Strength.weak:
        return Colors.red.shade300;
      case Strength.medium:
        return Colors.orange.shade300;
      case Strength.strong:
        return Colors.green.shade400;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Students'),
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.filter_list),
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
            ),
          ),
        ],
      ),

      // ✅ FILTER DRAWER WITH SWITCHES
      endDrawer: Drawer(
        child: Column(
          children: [
            const DrawerHeader(
              child: Text(
                'Filter by Strength',
                style: TextStyle(fontSize: 18),
              ),
            ),

            _filterSwitch('All', StrengthFilter.all),
            _filterSwitch('Weak', StrengthFilter.weak),
            _filterSwitch('Medium', StrengthFilter.medium),
            _filterSwitch('Strong', StrengthFilter.strong),
          ],
        ),
      ),

       body: filteredStudents.isEmpty
          ? const Center(
              child: Text(
                'No students in this class yet',
                style: TextStyle(fontSize: 16),
              ),
            )
          : ListView.builder(
              itemCount: filteredStudents.length,
              itemBuilder: (context, index) {
                final currentStudent = filteredStudents[index];

          return Dismissible(
            key: ValueKey(currentStudent.id),
            direction: DismissDirection.endToStart,
            onDismissed: (_) {
              _deleteStudent(currentStudent);
            },

            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const Icon(Icons.delete, color: Colors.white),
            ),

            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: strengthColor(currentStudent.strength),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    currentStudent.name,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    currentStudent.strength.name.toUpperCase(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: _addStudentDialog,
      ),
    );
  }

  // 🟢 FILTER SWITCH (BUTTON-ONLY INTERACTION)
  Widget _filterSwitch(String title, StrengthFilter filter) {
    return ListTile(
      title: Text(title),
      trailing: Switch(
        value: selectedFilter == filter,
        onChanged: (value) {
          setState(() {
            selectedFilter =
                value ? filter : StrengthFilter.all;
          });
        },
      ),
    );
  }

  void _addStudentDialog() {
    String studentName = '';
    Strength selectedStrength = Strength.weak;

    showDialog(
      context: context,
      builder: (context)=>StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Add Student'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Student Name'),
                onChanged: (value) {
                  studentName = value;
                },
              ),
              const SizedBox(height: 12),
              DropdownButton<Strength>(
                value: selectedStrength,
                isExpanded: true,
                items: Strength.values.map((strength) {
                  return DropdownMenuItem(
                    value: strength,
                    child: Text(strength.name),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setDialogState(() {
                      selectedStrength = value;
                    });
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (studentName.isNotEmpty) {
                  _addStudent(studentName, selectedStrength);
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }
}