// import 'package:collective/screens/HomeScreen.dart';
// import 'package:collective/screens/LoginScreen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// import 'dart:async';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:form_field_validator/form_field_validator.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class RegisterScreen extends StatefulWidget {
//   static const routeName = '/registerScreen';

//   @override
//   _RegisterScreenState createState() => _RegisterScreenState();
// }

// class _RegisterScreenState extends State<RegisterScreen> {
//   TextEditingController emailController = new TextEditingController();
//   TextEditingController usernameController = new TextEditingController();
//   TextEditingController passwordController = new TextEditingController();

//   final _formKey = GlobalKey<FormState>();

//   final emailValidator = MultiValidator([
//     RequiredValidator(errorText: 'Email is required'),
//     EmailValidator(errorText: 'Please enter a valid email address'),
//   ]);

//   final usernameValidator = MultiValidator([
//     RequiredValidator(errorText: 'Username is required'),
//     MinLengthValidator(5, errorText: 'Username must be at least 5 digits long'),
//   ]);

//   final passwordValidator = MultiValidator([
//     RequiredValidator(errorText: 'Password is required'),
//     MinLengthValidator(5, errorText: 'Password must be at least 5 digits long'),
//   ]);

//   @override
//   void dispose() {
//     emailController.dispose();
//     usernameController.dispose();
//     passwordController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
//       statusBarColor: Colors.white,
//       statusBarIconBrightness: Brightness.dark,
//     ));
//     return Scaffold(
//       backgroundColor: Theme.of(context).colorScheme.surface,
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               Container(
//                 height: 50,
//                 padding: EdgeInsets.only(top: 0),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Image.asset(
//                       'assets/images/LogoNoPadding.png',
//                       height: 32,
//                       width: 32,
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(left: 3, top: 5),
//                       child: Text(
//                         'Collective',
//                         style: TextStyle(
//                             color: Theme.of(context).primaryColor,
//                             fontWeight: FontWeight.bold,
//                             fontSize: 30),
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//               Container(
//                 height: 400,
//                 padding: const EdgeInsets.only(left: 40, right: 40),
//                 child: Form(
//                   key: _formKey,
//                   child: ListView(
//                     children: [
//                       Container(
//                         margin: EdgeInsets.only(top: 20),
//                         child: TextFormField(
//                           decoration: InputDecoration(
//                             labelText: 'Email',
//                             filled: true,
//                             fillColor: Colors.grey[50],
//                             focusedBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(30),
//                               borderSide: BorderSide(
//                                   color: Theme.of(context).primaryColor,
//                                   width: 1.5),
//                             ),
//                             enabledBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(30),
//                               borderSide:
//                                   BorderSide(color: Colors.grey[300] ?? Colors.grey, width: 1),
//                             ),
//                           ),
//                           controller: emailController,
//                           validator: emailValidator,
//                         ),
//                       ),
//                       Container(
//                         margin: EdgeInsets.only(top: 20),
//                         child: TextFormField(
//                           decoration: InputDecoration(
//                             labelText: 'Username',
//                             filled: true,
//                             fillColor: Colors.grey[50],
//                             focusedBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(30),
//                               borderSide: BorderSide(
//                                   color: Theme.of(context).primaryColor,
//                                   width: 1.5),
//                             ),
//                             enabledBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(30),
//                               borderSide:
//                                   BorderSide(color: Colors.grey[300] ?? Colors.grey, width: 1),
//                             ),
//                           ),
//                           controller: usernameController,
//                           validator: usernameValidator,
//                         ),
//                       ),
//                       Container(
//                         margin: EdgeInsets.only(top: 20),
//                         child: TextFormField(
//                           decoration: InputDecoration(
//                             labelText: 'Password',
//                             filled: true,
//                             fillColor: Colors.grey[50],
//                             focusedBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(30),
//                               borderSide: BorderSide(
//                                   color: Theme.of(context).primaryColor,
//                                   width: 1.5),
//                             ),
//                             enabledBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(30),
//                               borderSide:
//                                   BorderSide(color: Colors.grey[300] ?? Colors.grey, width: 1),
//                             ),
//                           ),
//                           obscureText: true,
//                           controller: passwordController,
//                           validator: passwordValidator,
//                         ),
//                       ),
//                       Container(
//                         margin: EdgeInsets.only(top: 25),
//                         child: ElevatedButton(
//                           onPressed: () {
//                             _formKey.currentState!.validate()
//                                 ? userRegister(
//                                         emailController.text,
//                                         usernameController.text,
//                                         passwordController.text)
//                                     .then((data) async {
//                                     if (data['result'] == false) {
//                                       ScaffoldMessenger.of(context)
//                                           .showSnackBar(SnackBar(
//                                         content: Text(
//                                           "Register Failed. Please try again",
//                                           textAlign: TextAlign.center,
//                                         ),
//                                       ));
//                                     } else if (data['result'] == true) {
//                                       SharedPreferences prefs =
//                                           await SharedPreferences.getInstance();
//                                       prefs.setString(
//                                           'email', data['details']['email']);
//                                       prefs.setString('username',
//                                           data['details']['username']);
//                                       prefs.setString(
//                                           'id', data['details']['_id']);
//                                       prefs.setString('token', data['token']);
//                                       Navigator.of(context)
//                                           .pushReplacementNamed(
//                                               HomeScreen.routeName);
//                                       ScaffoldMessenger.of(context)
//                                           .showSnackBar(SnackBar(
//                                         backgroundColor:
//                                             Theme.of(context).primaryColor,
//                                         content: Text(
//                                           "Welcome to Collective",
//                                           textAlign: TextAlign.center,
//                                           style: TextStyle(
//                                             color: Colors.white,
//                                           ),
//                                         ),
//                                       ));
//                                     }
//                                   })
//                                 : print('Invalid credentials in from field');
//                           },
//                           style: ElevatedButton.styleFrom(
//                             elevation: 0, backgroundColor: Theme.of(context).primaryColor,
//                             shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(60)),
//                             minimumSize: Size(double.infinity, 50),
//                           ),
//                           child: Text(
//                             'REGISTER',
//                             style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               fontSize: 17,
//                             ),
//                           ),
//                         ),
//                       ),
//                       Container(
//                         padding: EdgeInsets.only(
//                           top: 30,
//                         ),
//                         child: TextButton(
//                           onPressed: () {
//                             Navigator.of(context)
//                                 .pushReplacementNamed(LoginScreen.routeName);
//                           },
//                           child: Text(
//                             'Existing user ? Login here',
//                             style: TextStyle(
//                               color: Theme.of(context).primaryColor,
//                               fontSize: 16,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               Container(
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                 ),
//                 height: 260,
//                 width: double.infinity,
//                 child: Image.asset(
//                   'assets/images/RegisterScreen.png',
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// Future<dynamic> userRegister(
//     String email, String username, String password) async {
//   var headers = {
//     'x-api-key':
//         '8\$dsfsfgreb6&4w5fsdjdjkje#\$54757jdskjrekrm@#\$@\$%&8fdddg*&*ffdsds',
//     'Content-Type': 'application/json'
//   };
//   var request =
//       http.Request('POST', Uri.parse('http://192.168.1.18:8080/api/userRegister'));
//   request.body =
//       json.encode({"email": email, "username": username, "password": password});
//   request.headers.addAll(headers);

//   http.StreamedResponse response = await request.send();

//   return jsonDecode(await response.stream.bytesToString());
// }

import 'package:collective/screens/HomeScreen.dart';
import 'package:collective/screens/LoginScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:form_field_validator/form_field_validator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterScreen extends StatefulWidget {
  static const routeName = '/registerScreen';

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final emailValidator = MultiValidator([
    RequiredValidator(errorText: 'Email is required'),
    EmailValidator(errorText: 'Please enter a valid email address'),
  ]);

  final usernameValidator = MultiValidator([
    RequiredValidator(errorText: 'Username is required'),
    MinLengthValidator(5, errorText: 'Username must be at least 5 characters long'),
  ]);

  final passwordValidator = MultiValidator([
    RequiredValidator(errorText: 'Password is required'),
    MinLengthValidator(5, errorText: 'Password must be at least 5 characters long'),
  ]);

  @override
  void dispose() {
    emailController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
    ));
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 50,
                decoration: BoxDecoration(color: Colors.white),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/LogoNoPadding.png', height: 32, width: 32),
                    Padding(
                      padding: const EdgeInsets.only(left: 3, top: 5),
                      child: Text(
                        'Collective',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                height: 400,
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _buildTextField(
                        controller: emailController,
                        label: 'Email',
                        validator: emailValidator,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      _buildTextField(
                        controller: usernameController,
                        label: 'Username',
                        validator: usernameValidator,
                      ),
                      _buildTextField(
                        controller: passwordController,
                        label: 'Password',
                        validator: passwordValidator,
                        obscureText: true,
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 25),
                        child: ElevatedButton(
                          onPressed: _registerUser,
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: Theme.of(context).primaryColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(60)),
                            minimumSize: Size(double.infinity, 50),
                          ),
                          child: Text(
                            'REGISTER',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pushReplacementNamed(LoginScreen.routeName),
                        child: Text(
                          'Existing user? Login here',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(color: Colors.white),
                height: 260,
                width: double.infinity,
                child: Image.asset('assets/images/RegisterScreen.png', fit: BoxFit.cover),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String? Function(String?) validator,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.grey[50],
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 1.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: Colors.grey[300] ?? Colors.grey, width: 1),
          ),
        ),
        validator: validator,
        obscureText: obscureText,
        keyboardType: keyboardType,
        textInputAction: TextInputAction.next,
      ),
    );
  }

  void _registerUser() {
    if (_formKey.currentState!.validate()) {
      userRegister(emailController.text, usernameController.text, passwordController.text)
          .then((data) async {
        if (data['result'] == false) {
          print(data);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Register Failed. Please try again", textAlign: TextAlign.center)),
          );
        } else {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('email', data['details']['email']);
          prefs.setString('username', data['details']['username']);
          prefs.setString('id', data['details']['_id']);
          prefs.setString('token', data['token']);
          Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Theme.of(context).primaryColor,
              content: Text(
                "Welcome to Collective",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
        }
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${error.toString()}", textAlign: TextAlign.center)),
        );
      });
    } else {
      print('Invalid credentials in form field');
    }
  }
}

Future<dynamic> userRegister(String email, String username, String password) async {
  var headers = {
    'x-api-key': '8\$dsfsfgreb6&4w5fsdjdjkje#\$54757jdskjrekrm@#\$@\$%&8fdddg*&*ffdsds',
    'Content-Type': 'application/json'
  };

  try {
    var response = await http.post(
      Uri.parse('http://192.168.1.18:8080/api/userRegister'),
      headers: headers,
      body: json.encode({"email": email, "username": username, "password": password}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return {'result': false, 'message': 'Server error'};
    }
  } catch (e) {
    return {'result': false, 'message': e.toString()};
  }
}

