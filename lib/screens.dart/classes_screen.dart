import 'package:flutter_application_1/db/class_storage.dart';
import 'package:flutter_application_1/models.dart/class_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens.dart/students_screen.dart'; 


class ClassesScreen extends StatefulWidget { 
final List<ClassModel> classList;

const ClassesScreen({
  super.key,
  required this.classList,
  }); 

@override State<ClassesScreen> createState() => _ClassesScreenState();
}

class _ClassesScreenState extends State<ClassesScreen> {

void _addClass(String name, ClassType type) async {
  // Create a temporary class with id = 0
  ClassModel tempClass = ClassModel(
    id: 0,
    name: name,
    type: type,
  );
  // Insert into database and get the real id
  int insertedId = await insertClass(tempClass);
  // Create the FINAL class with the real database ID
  ClassModel newClass = ClassModel(
    id: insertedId,
    name: name,
    type: type,
  );
  setState(() {
    widget.classList.add(newClass); // Add the class with correct ID
  });
}

  void _deleteClass(ClassModel classModel) async {
    setState(() {
      widget.classList.remove(classModel);
    });

    // Delete from database
    deleteClass(classModel);
  }

@override 
Widget build(BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;

 return Scaffold( 
  appBar: AppBar( title: const Text('My Classes'),
   ), 
   body: ListView.builder(
     itemCount: widget.classList.length, 
     itemBuilder: (context, index) { 
      final currentClass = widget.classList[index];

      return Dismissible( 
      key: ValueKey(currentClass.id),
      direction: DismissDirection.endToStart, 
      onDismissed: (direction) {
        deleteClass(currentClass);
      }, 
      background: Container( 
      color: Colors.red, 
      alignment: Alignment.centerRight, 
      padding: const EdgeInsets.symmetric(horizontal: 20), 
      child: const Icon(Icons.delete, color: Colors.white),
      ), 
      child: InkWell(
        onTap: () { 
          Navigator.of(context).push( 
            MaterialPageRoute(
                builder: (_) => StudentsScreen( 
                  classId: currentClass.id, 
                  ), 
                ), 
              ); 
            }, 
            child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isDark ? Colors.blueGrey.shade800 : Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
          child: Row( 
            mainAxisAlignment: MainAxisAlignment.spaceBetween, 
            children: [ 
            Text( 
              currentClass.name, 
              style: const TextStyle( 
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ), 
            // const SizedBox(height: 4), 
            Text( 
              currentClass.type.name, 
              style: const TextStyle(color: Colors.grey), 
            ),
          ],
         ),
        ), 
       ),
     ); 
   },
  ),

  floatingActionButton: 
    FloatingActionButton( 
      child: const Icon(Icons.add), 
      onPressed: () { 
      String className = ''; 
      ClassType selectedType = ClassType.beginner;
      
      showDialog( 
      context: context, 
      builder: (context)=>StatefulBuilder(
              builder: (context, setDialogState) => AlertDialog(
                title: const Text('Add Class'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      decoration: const InputDecoration(labelText: 'Class Name'),
                      onChanged: (value) {
                        className = value;
                      },
                    ),
                    const SizedBox(height: 10),
                    DropdownButton<ClassType>(
                      value: selectedType,
                      isExpanded: true,
                      items: ClassType.values.map((type) {
                        return DropdownMenuItem(
                          value: type,
                          child: Text(type.name),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setDialogState(() {
                            selectedType = value;
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
                      if (className.isNotEmpty) {
                        _addClass(className, selectedType);
                        Navigator.pop(context);
                      }
                    },
                    child: const Text('Add'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
      
