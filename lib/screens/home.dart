import 'dart:io';

import 'package:finalexactt/db/functions.dart';
import 'package:finalexactt/screens/model.dart';
import 'package:finalexactt/screens/studlist.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class homescreen extends StatefulWidget {
  const homescreen({super.key});

  @override
  State<homescreen> createState() => _homescreenState();
}

class _homescreenState extends State<homescreen> {
  final courseController = TextEditingController();
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final placeController = TextEditingController();
  File? _selectedImage;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('student details'),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
                  return ListStudentWidget();
                }));
              },
              icon: Icon(Icons.people),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.teal,
                    maxRadius: 60,
                    child: GestureDetector(
                      onTap: () async {
                        File? pickimage = await _pickImageFromCamera();
                        setState(() {
                          _selectedImage = pickimage;
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
                  SizedBox(height: 10),

                  TextFormField(
                    controller: courseController,
                    decoration: InputDecoration(
                        labelText: 'course', border: OutlineInputBorder()),
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please enter your course';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                        labelText: 'name', border: OutlineInputBorder()),
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please enter a name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: ageController,
                    decoration: InputDecoration(
                        labelText: 'age', border: OutlineInputBorder()),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please enter your age';
                      }

                      return validateIsInteger(value);
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: placeController,
                    decoration: InputDecoration(
                        labelText: 'place', border: OutlineInputBorder()),
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please enter your place';
                      }
                      return null;
                    },
                  ),

                  //
                  SizedBox(
                    height: 20,
                  ),
               

                  SizedBox(
                    width: 500,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          if (_selectedImage == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: Colors.red,
                                content: Text(
                                  "image should be selected",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            );
                            return;
                          }
                          final _student = StudentModel(
                            course: courseController.text,
                            name: nameController.text,
                            age: ageController.text,
                            place: placeController.text,
                            imageurl: _selectedImage?.path,
                          );
                          await addStudent(_student);

                          setState(() {
                            _selectedImage=null;
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.green,
                              content: Text(
                                "Added successfully",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          );
                          courseController.clear();
                          nameController.clear();
                          ageController.clear();
                          placeController.clear();
                       
                      
                        }
                      },
                      child: const Text('add students'),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: 500,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        courseController.text = '';
                        nameController.text = '';
                        ageController.text = '';
                        placeController.text = '';
                      },
                      child: const Text('clear'),
                    ),
                  ),
                ],
              ),
            ),
          ),
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

String? validateIsInteger(String value) {
  final isDigits = int.tryParse(value);
  if (isDigits == null) {
    return 'Please enter a valid integer';
  }
  return null;
}
