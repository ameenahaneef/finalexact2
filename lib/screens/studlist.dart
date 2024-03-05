import 'dart:io';
import 'package:finalexactt/db/functions.dart';
import 'package:finalexactt/screens/updatestudent.dart';
import 'package:flutter/material.dart';

class ListStudentWidget extends StatefulWidget {
  const ListStudentWidget({super.key});

  @override
  State<ListStudentWidget> createState() => _ListStudentWidgetState();
}

class _ListStudentWidgetState extends State<ListStudentWidget> {
  late List<Map<String, dynamic>> _studentsData;
 final searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _studentsData = [];
    _loadStudents();
  }

  Future<void> _loadStudents() async {
    List<Map<String, dynamic>> students = await getAllStudents();

    if (searchController.text.isNotEmpty) {
      students = students
          .where((student) => student['name']
              .toString()
              // .toLowerCase()
              .startsWith(searchController.text))
          .toList();
    }

    setState(() {
      _studentsData = students;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student List'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: searchController,
              onChanged: (value) {
                setState(() {
                  _loadStudents();
                });
              },
              decoration: InputDecoration(
                hintText: 'Search Students',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.search),
                ),
              ),
            ),
          ),
          Expanded(
            child: _studentsData.isEmpty
                ? Center(child: Text("No students available."))
                : ListView.separated(
                    itemBuilder: (ctx, index) {
                      final student = _studentsData[index];
                      final imageUrl = student['imageurl'];

                      return ListTile(
                        onTap: () {
                          _showStudentDetails(context, student);
                        },
                        leading: CircleAvatar(
                          backgroundImage: imageUrl != null
                              ? FileImage(File(imageUrl))
                              : null,
                          child: imageUrl == null ? Icon(Icons.person) : null,
                        ),
                        title: Text(student['name']),
                        subtitle: Text(student['age']),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .push(MaterialPageRoute(builder: (ctx) {
                                    return UpdateStudentScreen(
                                      student: student,
                                      onUpdate: _loadStudents,
                                    );
                                  }));
                                },
                                icon: Icon(
                                  Icons.edit,
                                  color: Colors.teal,
                                )),
                            IconButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext) => AlertDialog(
                                    title: Text("Delete Student"),
                                    content: Text(
                                        "Are you sure you want to delete?"),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pop(); // Close the dialog
                                        },
                                        child: Text("Cancel"),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          await deleteStudent(student['id']);
                                          _loadStudents();
                                          Navigator.of(context).pop();
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  backgroundColor: Colors.teal,
                                                  content: Text(
                                                      "Deleted Successfully")));
                                        },
                                        child: Text('ok'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              icon: Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                            )
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (ctx, index) {
                      return Divider();
                    },
                    itemCount: _studentsData.length,
                  ),
          ),
        ],
      ),
    );
  }
}

Future<void> _showStudentDetails(
    BuildContext context, Map<String, dynamic> student) async {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Student Details"),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
             mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                backgroundImage: student['imageurl'] != null
                    ? FileImage(File(student['imageurl']))
                    : null,
              ),
              Text("course:${student['course']}"),
              Text("Name: ${student['name']}"),
              Text("Age: ${student['age']}"),
              Text("place:${student['place']}"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Close"),
            ),
          ],
        );
      });
}
