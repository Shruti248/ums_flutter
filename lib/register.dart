import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'dart:typed_data';

import 'UMSHomePage.dart';
import 'login.dart';


class RegisterController extends GetxController{
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

  bool _isValidEmail(String email) {
    // Regular expression for a simple email validation
    final emailRegExp = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
    return emailRegExp.hasMatch(email);
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
      final dio.Dio dioClient = dio.Dio();
      dioClient.options.headers['Access-Control-Allow-Origin'] = '*';
      dioClient.options.extra['withCredentials'] = true;

      dioClient.options.validateStatus = (status) {
        return status! < 500; // return true if status code is less than 500
      };

     dio.FormData formData = dio.FormData();

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
          dio.MultipartFile.fromBytes(profilePic, filename: 'profilePic.jpg'),
        ));
      }


      final res = await dioClient.post(
        'http://localhost:3000/api/v1/register',
        data: formData,
      );

      if (res.statusCode == 200) {
        final data = res.data;
        // print(data);
        return data;
      } else {
        throw '${res.statusCode} : Failed to register. ${res.data['message']}';
      }
    } catch (err) {
      print('$err');
      throw err.toString();
    }
  }

}


class MyForm extends StatelessWidget {
  // var _myFormKey = GlobalKey<FormState>();
  // GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey<ScaffoldMessengerState>();

  final registerController = Get.put(RegisterController());

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
            // key: _myFormKey,
            child: Column(
              children: <Widget>[
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: registerController._firstNameController,
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
                        controller: registerController._lastNameController,
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
                  controller: registerController._emailController,
                  validator: (String? email) {
                    if (email == null || email.isEmpty) {
                      return "Email is required";
                    } else if (!registerController._isValidEmail(email)) {
                      return "Enter a valid email address";
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
                  controller: registerController._passwordController,
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
                  controller: registerController._confirmPasswordController,
                  validator: (String? confirmPassword) {
                    if (confirmPassword == null || confirmPassword.isEmpty) {
                      return "Required";
                    }

                    if (confirmPassword != registerController._passwordController.value.text) {
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
                    Uint8List? fileBytes = await registerController.pickFile();
                    // print("File : ");
                    // print(fileBytes);
                    if (fileBytes != null) {
                      // You can use fileBytes as needed
                      // setState(() {
                      //   // Assuming profilePicFile is of type Uint8List?
                      //   profilePicFile = fileBytes;
                      // });

                      registerController.profilePicFile = fileBytes;

                      registerController.update();

                      // print("ProfilePicFile : ");
                      // print(profilePicFile);
                    }
                  },
                  // -------------------------------------------------------
                  child: Text('Select Profile Picture'),
                ),
                const SizedBox(height: 30),

                TextFormField(
                  controller: registerController._contactNumberController,
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
                ),

                const SizedBox(height: 30),

                ElevatedButton(
                  child: Text('Register'),
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.all(15)),
                    shape: MaterialStateProperty.all<OutlinedBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                    minimumSize: MaterialStateProperty.all<Size>(Size(double.infinity, 50)),
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                  ),
                  onPressed: () async {
                      final firstName = registerController._firstNameController.text;
                      final lastName = registerController._lastNameController.text;
                      final email = registerController._emailController.text;
                      final password = registerController._passwordController.text;
                      final contactNumber = registerController._contactNumberController.text;

                      try {
                        await registerController.userRegistration(
                          firstName: firstName,
                          lastName: lastName,
                          email: email,
                          password: password,
                          profilePic: registerController.profilePicFile,

                          contactNumber: contactNumber,
                        );

                        // ScaffoldMessenger.of(context).showSnackBar(
                        //   SnackBar(
                        //     // Making teh custom SnackBar
                        //     behavior: SnackBarBehavior.floating,
                        //     backgroundColor: Colors.transparent,
                        //     elevation: 0,
                        //     content: Container(
                        //         padding: const EdgeInsets.all(16),
                        //         // height: 20,
                        //         decoration: const BoxDecoration(
                        //           color: Colors.green,
                        //           borderRadius: BorderRadius.all(Radius.circular(20)),
                        //         ),
                        //         child : const Row(
                        //           children: [
                        //             SizedBox(width: 40,),
                        //             Expanded(
                        //               child: Column(
                        //                 crossAxisAlignment: CrossAxisAlignment.start,
                        //                 children: [
                        //                   Text('Registration Successful' ,
                        //                     style: TextStyle(
                        //                         color: Colors.white,
                        //                         fontSize: 12
                        //                     ),
                        //                   ),
                        //                 ],
                        //               ),
                        //             ),
                        //           ],
                        //         )
                        //     ),
                        //   ),
                        // );
                        //
                        Get.snackbar(
                            'Registration Successful' , ''
                        );

                        print('Registration successful!');

                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(builder: (context) => UMSHomePage()),
                        // );

                        Get.offAll(UMSHomePage());

                      } catch (error) {

                        // ScaffoldMessenger.of(context).showSnackBar(
                        //   SnackBar(
                        //     // Making teh custom SnackBar
                        //     behavior: SnackBarBehavior.floating,
                        //     backgroundColor: Colors.transparent,
                        //     elevation: 0,
                        //     content: Container(
                        //         padding: const EdgeInsets.all(16),
                        //         // height: 20,
                        //         decoration: const BoxDecoration(
                        //           color: Colors.red,
                        //           borderRadius: BorderRadius.all(Radius.circular(20)),
                        //         ),
                        //         child : Row(
                        //           children: [
                        //             const SizedBox(width: 40,),
                        //             Expanded(
                        //               child: Column(
                        //                 crossAxisAlignment: CrossAxisAlignment.start,
                        //                 children: [
                        //                   Text('$error' ,
                        //                     style: const TextStyle(
                        //                         color: Colors.white,
                        //                         fontSize: 12
                        //                     ),
                        //                   ),
                        //                 ],
                        //               ),
                        //             ),
                        //           ],
                        //         )
                        //     ),
                        //   ),
                        // );

                        Get.snackbar("Try Again ! " , '${error}');

                        print('Error during registration: $error');
                      }
                  },
                ),

                const SizedBox(height: 30),

                TextButton(
                  onPressed: () {
                    // Navigate to the registration page
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => MyLoginForm()),
                    // );

                    Get.to(MyLoginForm());
                  },
                  child: Text('Already registered ? Login. '),
                ),

              ],
            ),
          ),
        ),



    );
  }
}

