import 'dart:io';

import 'package:flutter/material.dart';
import 'package:finalexactt/screens/model.dart'; 
import 'package:finalexactt/db/functions.dart';
import 'package:image_picker/image_picker.dart'; 
class UpdateStudentScreen extends StatefulWidget {
  final Map<String, dynamic> student;
  final Function() onUpdate;

  UpdateStudentScreen({required this.student, required this.onUpdate});

  @override
  _UpdateStudentScreenState createState() => _UpdateStudentScreenState();
}

class _UpdateStudentScreenState extends State<UpdateStudentScreen> {
  late Map<String, dynamic> _localStudentsData;
  final courseController = TextEditingController();
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final placeController = TextEditingController();
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    _localStudentsData = widget.student;

    courseController.text = _localStudentsData['course'];
    nameController.text = _localStudentsData['name'];
    ageController.text = _localStudentsData['age'];
    placeController.text = _localStudentsData['place'];
    if (_localStudentsData['imageurl'] != null) {
      _selectedImage = File(_localStudentsData['imageurl']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Student'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(children: <Widget>[
            CircleAvatar(
              backgroundColor: Colors.teal,
              maxRadius: 60,
              child: GestureDetector(
                onTap: () async {
                  File? pickImage = await _pickImageFromCamera();
                  setState(() {
                    _selectedImage = pickImage;
                  });
                },
                child: _selectedImage != null
                    ? ClipOval(
                        child: Image.file(
                          _selectedImage!,
                          fit: BoxFit.cover,
                          width: 140,
                          height: 140,
                        ),
                      )
                    : const Icon(
                        Icons.add_a_photo_rounded,
                        color: Colors.black,
                      ),
              ),
            ),
            TextFormField(
              controller: courseController,
              decoration: InputDecoration(labelText: 'course'),
            ),
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextFormField(
              controller: ageController,
              decoration: InputDecoration(labelText: 'Age'),
            ),
            TextFormField(
              controller: placeController,
              decoration: InputDecoration(labelText: 'Place'),
            ),
            
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () async {
                  final updatedCourse = courseController.text;
                  final updatedName = nameController.text;
                  final updatedAge = ageController.text;
                  final updatedPlace = placeController.text;
                  final updatedImage = _selectedImage?.path;

                  if (updatedImage == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('please select an image')));
                  } else {
                    final updatedStudent = StudentModel(
                      id: widget.student['id'],
                      course: updatedCourse,
                      name: updatedName,
                      age: updatedAge,
                      place: updatedPlace,
                      imageurl: updatedImage,
                    );

                    await updateStudent(updatedStudent);
                    widget.onUpdate();

                    Navigator.pop(context);
                  }
                },
                child: Text('Save Changes'))
          ]),
        ),
      ),
    );
  }

 
}

Future<File?> _pickImageFromCamera() async {
  final pickedImage =
      await ImagePicker().pickImage(source: ImageSource.gallery);
  if (pickedImage != null) {
    return File(pickedImage.path);
  }
  return null;
}
