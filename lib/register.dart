import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyForm extends StatefulWidget {
  const MyForm({super.key});

  @override
  State<MyForm> createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  var _myFormKey=GlobalKey<FormState>();
  GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey<ScaffoldMessengerState>();
  // var _password = TextEditingController();
  // var _confirmPassword = TextEditingController();

  // Declare controllers for each form field
  var _firstNameController = TextEditingController();
  var _lastNameController = TextEditingController();
  var _emailController = TextEditingController();
  var _passwordController = TextEditingController();
  var _confirmPasswordController = TextEditingController();
  var _contactNumberController = TextEditingController();

  late Future<Map<String, dynamic>> newUser;

  // Future<Map<String, dynamic>> userRegistration() async {
  //   try {
  //     final dio = Dio();
  //     dio.options.headers['Access-Control-Allow-Origin'] = '*';
  //
  //     final res = await dio.post(
  //       'http://localhost:3000/api/v1/register',
  //       data:         {
  //         "firstName": "abc",
  //         "lastName": "xyz",
  //         "email": "t@gmail.com",
  //         "password": "hahuihuiygvb",
  //         "profilePic": "",
  //         "contactNumber": "9086541234",
  //       },
  //     );
  //
  //     if (res.statusCode == 201) {
  //       final data = res.data; // No need to use jsonDecode since Dio does it automatically
  //       print(data);
  //       return data;
  //     } else {
  //       throw "Failed to register. Status code: ${res.statusCode}";
  //     }
  //   } catch (err) {
  //     print('Error during registration: $err');
  //     throw err.toString();
  //   }
  // }

  Future<Map<String, dynamic>> userRegistration({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String profilePic,
    required String contactNumber,
  }) async {
    try {
      final dio = Dio();
      dio.options.headers['Access-Control-Allow-Origin'] = '*';

      final res = await dio.post(
        'http://localhost:3000/api/v1/register',
        data: {
          'firstName': firstName,
          'lastName': lastName,
          'email': email,
          'password': password,
          'profilePic': '',
          'contactNumber': contactNumber,
        },
      );

      if (res.statusCode == 200) {
        final data = res.data; // No need to use jsonDecode since Dio does it automatically
        print(data);
        return data;
      } else {
        throw 'Failed to register. Status code: ${res.statusCode}';
      }
    } catch (err) {
      print('Error during registration: $err');
      throw err.toString();
    }
  }

  // void initState() {
  //   super.initState();
  //   newUser = userRegistration(firstName: _firstNameController.value.text , lastName: _lastNameController.value.text , email: _emailController.value.text , password: _passwordController.value.text , profilePic : "" , contactNumber: _contactNumberController.value.text);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('REGISTER' ,
        style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
      ),centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 25.0 , horizontal: 25.0),
        child: Form(
            key: _myFormKey,
            child:Column(
              children: <Widget>[

                Row(
                  children: [
                    // Firstname
                    Expanded(child:
                    TextFormField(
                      controller: _firstNameController,
                      validator: (String? firstName){
                        if(firstName == null || firstName.isEmpty){
                          return "Required";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          labelText: "First Name",
                          hintText: "Enter your First Name",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0)
                          )
                      ),
                    ),
                    ),

                    SizedBox(width: 10),

                    // last name
                    Expanded(child:
                    TextFormField(
                      controller: _lastNameController,
                      validator: (String? lastName){
                        if(lastName == null || lastName.isEmpty){
                          return "Required";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          labelText: "Last Name",
                          hintText: "Enter your Last Name",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0)
                          )
                      ),
                    ),
                    )

                  ],
                ),

                const SizedBox(height: 30),

                // email
                TextFormField(
                  controller: _emailController,
                  validator: (String? email){
                    if(email == null || email.isEmpty){
                      return "Required";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      labelText: "Email",
                      hintText: "Enter your email",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0)
                      )
                  ),
                ),

                const SizedBox(height: 30),

                // password
                TextFormField(
                  controller: _passwordController,
                  validator: (String? password){
                    if(password == null || password.isEmpty){
                      return "Required";
                    }
                    if(password.length<6 || password.length>30){
                      return "Password must be 6 - 30 characters long";
                    }
                    return null;
                  },
                  // Hidden text
                  obscureText: true,
                  decoration: InputDecoration(
                      labelText: "Password",
                      hintText: "Enter your password",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0)
                      )
                  ),
                ),

                const SizedBox(height: 30),

                // confirm password
                TextFormField(
                  controller: _confirmPasswordController,
                  validator: (String? confirmpassword){
                    if(confirmpassword == null || confirmpassword.isEmpty){
                      return "Required";
                    }

                    // Checking the values of both the entered password & the confirm password
                    // Required : Controller for that case

                    if(confirmpassword != _passwordController.value.text){
                      return "Passwords do not match.";
                    }

                    return null;
                  },
                  // Hidden text
                  obscureText: true,
                  decoration: InputDecoration(
                      labelText: "Confirm Password",
                      hintText: "Enter your password again",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0)
                      )
                  ),
                ),
                const SizedBox(height: 30),

                // profilePic left

                // contact number
                TextFormField(
                  controller: _contactNumberController,
                  // This property does not work for web
                  // keyboardType: TextInputType.phone,

                  validator: (String? contactNumber){
                    if(contactNumber == null || contactNumber.isEmpty){
                      return "Required";
                    }

                    // Adding regular Expression for keyboard type
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
                          borderRadius: BorderRadius.circular(15.0)
                      )
                  ),
                )
              ],
            )
        ),
      ),

      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.done),
        onPressed: () async {
          if (_myFormKey.currentState?.validate() ?? false) {
            // If the form is valid, retrieve form data
            final firstName = _firstNameController.text;
            final lastName = _lastNameController.text;
            final email = _emailController.text;
            final password = _passwordController.text;
            final contactNumber = _contactNumberController.text;

            // Call userRegistration method with form data
            try {
              await userRegistration(
                firstName: firstName,
                lastName: lastName,
                email: email,
                password: password,
                profilePic: "",
                contactNumber: contactNumber,
              );

              // Display success message using a SnackBar
              _scaffoldKey.currentState?.showSnackBar(
                SnackBar(
                  content: Text('Registration successful!'),
                ),
              );

              // Do something after successful registration if needed
              print('Registration successful!');
            } catch (error) {
              // Handle registration error
              print('Error during registration: $error');
            }
          }
        },
      ),

    );
  }
}