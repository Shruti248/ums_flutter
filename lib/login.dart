import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyLoginForm extends StatefulWidget {
  const MyLoginForm({super.key});

  @override
  State<MyLoginForm> createState() => _MyLoginFormState();
}

class _MyLoginFormState extends State<MyLoginForm> {
  var _myFormKey=GlobalKey<FormState>();
  GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey<ScaffoldMessengerState>();

  // Declare controllers for each form field
  var _emailController = TextEditingController();
  var _passwordController = TextEditingController();

  late Future<Map<String, dynamic>> user;

  Future<Map<String, dynamic>> userLogin({
    required String email,
    required String password,
  }) async {
    try {
      final dio = Dio();
      dio.options.headers['Access-Control-Allow-Origin'] = '*';

      final res = await dio.post(
        'http://localhost:3000/api/v1/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      if (res.statusCode == 200) {
        final data = res.data; // No need to use jsonDecode since Dio does it automatically
        print(data);
        return data;
      } else {
        throw 'Failed to Login. Status code: ${res.statusCode}';
      }
    } catch (err) {
      print('Error during logging in: $err');
      throw err.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('LOGIN' ,
        style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
      ),centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 25.0 , horizontal: 25.0),
        child: Form(
            key: _myFormKey,
            child:Column(
              children: <Widget>[

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

              ],
            )
        ),
      ),

      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.done),
        onPressed: () async {
          if (_myFormKey.currentState?.validate() ?? false) {
            // If the form is valid, retrieve form data
            final email = _emailController.text;
            final password = _passwordController.text;

            // Call userRegistration method with form data
            try {
              await userLogin(
                email: email,
                password: password,
              );

              // Display success message using a SnackBar
              _scaffoldKey.currentState?.showSnackBar(
                SnackBar(
                  content: Text('Login successful!'),
                ),
              );

              // Do something after successful registration if needed
              print('Login successful!');
            } catch (error) {
              // Handle registration error
              print('Error during logging in : $error');
            }
          }
        },
      ),

    );
  }
}