import 'package:flutter/material.dart';

void main(){
  runApp(
    const MaterialApp(
      home : MyForm()
    )
  );
}

class MyForm extends StatefulWidget {
  const MyForm({super.key});

  @override
  State<MyForm> createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  var _myFormKey=GlobalKey<FormState>();

  var _password = TextEditingController();
  var _confirmPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register'),),
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
                controller: _password,
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
                controller: _confirmPassword,
                validator: (String? confirmpassword){
                  if(confirmpassword == null || confirmpassword.isEmpty){
                    return "Required";
                  }

                  // Checking the values of both the entered password & the confirm password
                  // Required : Controller for that case

                  if(confirmpassword != _password.value.text){
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
        onPressed: (){
          _myFormKey.currentState?.validate();
        },
      ),
    );
  }
}
