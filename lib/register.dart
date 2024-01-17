import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:typed_data';

class MyForm extends StatefulWidget {
  const MyForm({Key? key});

  @override
  State<MyForm> createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  var _myFormKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey<ScaffoldMessengerState>();

  var _firstNameController = TextEditingController();
  var _lastNameController = TextEditingController();
  var _emailController = TextEditingController();
  var _passwordController = TextEditingController();
  var _confirmPasswordController = TextEditingController();
  var _contactNumberController = TextEditingController();

  late Future<Map<String, dynamic>> newUser;
  Uint8List? profilePicFile;

  Future<Uint8List?> pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png'],
      );


      if (result != null) {
        PlatformFile file = result.files.first;

        // Access file content as Uint8List
        Uint8List fileBytes = file.bytes!;
        return fileBytes;

      } else {
        return null;      }
    } catch (e) {
      print('Error picking file: $e');
      return null;

    }
  }


  Future<Map<String, dynamic>> userRegistration({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required Uint8List? profilePic,
    required String contactNumber,
  }) async {
    try {
      final dio = Dio();
      dio.options.headers['Access-Control-Allow-Origin'] = '*';

      FormData formData = FormData();

      formData.fields.addAll([
        MapEntry('firstName', firstName),
        MapEntry('lastName', lastName),
        MapEntry('email', email),
        MapEntry('password', password),
        MapEntry('contactNumber', contactNumber),
      ]);

      if (profilePic != null) {
        // Convert Uint8List to MultipartFile
        formData.files.add(MapEntry(
          'profilePic',
          MultipartFile.fromBytes(profilePic, filename: 'profilePic.jpg'),
        ));
      }

      print('form data ');
      print(formData);

      final res = await dio.post(
        'http://localhost:3000/api/v1/register',
        data: formData,
      );

      if (res.statusCode == 200) {
        final data = res.data;
        // print(data);
        return data;
      } else {
        throw 'Failed to register. Status code: ${res.statusCode}';
      }
    } catch (err) {
      print('Error during registration: $err');
      throw err.toString();
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'REGISTER',
            style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(vertical: 25.0, horizontal: 25.0),
          child: Form(
            key: _myFormKey,
            child: Column(
              children: <Widget>[
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _firstNameController,
                        validator: (String? firstName) {
                          if (firstName == null || firstName.isEmpty) {
                            return "Required";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: "First Name",
                          hintText: "Enter your First Name",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        controller: _lastNameController,
                        validator: (String? lastName) {
                          if (lastName == null || lastName.isEmpty) {
                            return "Required";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: "Last Name",
                          hintText: "Enter your Last Name",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                TextFormField(
                  controller: _emailController,
                  validator: (String? email) {
                    if (email == null || email.isEmpty) {
                      return "Required";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: "Email",
                    hintText: "Enter your email",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                TextFormField(
                  controller: _passwordController,
                  validator: (String? password) {
                    if (password == null || password.isEmpty) {
                      return "Required";
                    }
                    if (password.length < 6 || password.length > 30) {
                      return "Password must be 6 - 30 characters long";
                    }
                    return null;
                  },
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Password",
                    hintText: "Enter your password",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                TextFormField(
                  controller: _confirmPasswordController,
                  validator: (String? confirmPassword) {
                    if (confirmPassword == null || confirmPassword.isEmpty) {
                      return "Required";
                    }

                    if (confirmPassword != _passwordController.value.text) {
                      return "Passwords do not match.";
                    }

                    return null;
                  },
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Confirm Password",
                    hintText: "Enter your password again",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // NULLL Over HERE only -----------------------
                TextButton(
                  onPressed: () async {
                    Uint8List? fileBytes = await pickFile();
                    // print("File : ");
                    // print(fileBytes);
                    if (fileBytes != null) {
                      // You can use fileBytes as needed
                      setState(() {
                        // Assuming profilePicFile is of type Uint8List?
                        profilePicFile = fileBytes;
                      });
                      // print("ProfilePicFile : ");
                      // print(profilePicFile);
                    }
                  },
                  // -------------------------------------------------------
                  child: Text('Select Profile Picture'),
                ),
                const SizedBox(height: 30),
                TextFormField(
                  controller: _contactNumberController,
                  validator: (String? contactNumber) {
                    if (contactNumber == null || contactNumber.isEmpty) {
                      return "Required";
                    }

                    RegExp indianMobileNumber = RegExp(r'^[6-9]\d{9}$');

                    if (!indianMobileNumber.hasMatch(contactNumber)) {
                      return "Enter a valid mobile number";
                    }

                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: "Contact Number",
                    hintText: "Enter your Contact Number",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
        child: Icon(Icons.done),
    onPressed: () async {
    if (_myFormKey.currentState?.validate() ?? false) {
    final firstName = _firstNameController.text;
    final lastName = _lastNameController.text;
    final email = _emailController.text;
    final password = _passwordController.text;
    final contactNumber = _contactNumberController.text;

    try {
      await userRegistration(
        firstName: firstName,
        lastName: lastName,
        email: email,
        password: password,
        profilePic: profilePicFile,

        contactNumber: contactNumber,
      );

      _scaffoldKey.currentState?.showSnackBar(
        SnackBar(
          content: Text('Registration successful!'),
        ),
      );

      print('Registration successful!');
    } catch (error) {
      print('Error during registration: $error');
    }
    }
    },
        ),
    );
  }
}

