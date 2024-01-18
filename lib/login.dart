import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ums_flutter/register.dart';
import 'UMSHomePage.dart';

class MyLoginForm extends StatefulWidget {
  const MyLoginForm({super.key});

  @override
  State<MyLoginForm> createState() => _MyLoginFormState();
}

class _MyLoginFormState extends State<MyLoginForm> {
  var _myFormKey=GlobalKey<FormState>();

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
      dio.options.extra['withCredentials'] = true;

      dio.options.validateStatus = (status) {
        return status! < 500; // return true if status code is less than 500
      };

      final res = await dio.post(
        'http://localhost:3000/api/v1/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      print(res);

      if (res.statusCode == 200) {
        final data = res.data; // No need to use jsonDecode since Dio does it automatically
        print(data);
        return data;
      } else {
        throw '${res.statusCode} : Failed to Login. ${" " + res.data['message']}';
      }
    } catch (err) {
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

                ElevatedButton(
                  child: Text('Login'),
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
                    if (_myFormKey.currentState?.validate() ?? false) {
                      // If the form is valid, retrieve form data
                      final email = _emailController.text;
                      final password = _passwordController.text;

                      // Call userRegistration method with form data
                      try {
                        Map<String, dynamic> res = await userLogin(
                          email: email,
                          password: password,
                        );

                        print(res);

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            // Making teh custom SnackBar
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: Colors.transparent,
                              elevation: 0,
                              content: Container(
                                padding: const EdgeInsets.all(16),
                                // height: 20,
                                decoration: const BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.all(Radius.circular(20)),
                                ),
                                  child : const Row(
                                    children: [
                                       SizedBox(width: 40,),
                                       Expanded(
                                         child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                             Text('Login Successful' ,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12
                                                ),
                                            ),
                                          ],
                                                                               ),
                                       ),
                                    ],
                                  )
                              ),
                          ),
                        );


                        // Do something after successful registration if needed
                        print('Login successful!');

                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => UMSHomePage())
                        );



                      } catch (error) {

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            // Making teh custom SnackBar
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                            content: Container(
                                padding: const EdgeInsets.all(16),
                                // height: 20,
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.all(Radius.circular(20)),
                                ),
                                child : Row(
                                  children: [
                                    const SizedBox(width: 40,),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('${error}' ,
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 12
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                            ),
                          ),
                        );
                        // Handle registration error
                        // print('Error during logging in : $error');
                      }
                    }
                  },
                ),

                const SizedBox(height: 30),


                TextButton(
                  onPressed: () {
                    // Navigate to the registration page
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MyForm()),
                    );
                  },
                  child: Text('Do not have an Account ? Register. '),
                ),

              ],
            )
        ),
      ),






    );
  }
}