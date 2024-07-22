// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter/src/widgets/placeholder.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/material.dart';
import 'package:soil_app/components/button.dart';
import 'package:soil_app/components/textfield.dart';
import 'package:soil_app/pages/forgotpassword_page.dart';
import 'package:soil_app/pages/home_page.dart';
import 'package:soil_app/utils/Colors.dart';
import 'package:soil_app/pages/signup_page.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key = const ValueKey('login')}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  bool _isPasswordHidden = true;

  bool _loginProcess = false;
  bool isTapped = false;

  void _onTapDown() {
    setState(() {
      isTapped = true;
    });
  }

  void _onTapUp() {
    setState(() {
      isTapped = false;
    });
  }

  void _onTapCancel() {
    setState(() {
      isTapped = false;
    });
  }

  Future<void> sendRequest(
      BuildContext context, String email, String password) async {
    final url = Uri.parse(
        'https://soil-app-backend.azurewebsites.net/user/signin'); // replace with your API URL

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'email': email,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      final token = data['token'];
      final refreshToken = data['refreshToken'];
      final user = data['user'];
      final userId = user['_id'];
      final email = user['email'];
      final name = user['name'];
      final phone = user['phone'];

      await SharedPreferences.getInstance().then((prefs) {
        prefs.setString('token', token);
        prefs.setString('refreshToken', refreshToken);
        prefs.setString('userId', userId);
        prefs.setString('email', email);
        prefs.setString('name', name);
        prefs.setString('phone', phone);
      });
      // navigate to HomePage and prevent user from going back
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
        (Route<dynamic> route) => false,
      );
    } else {
      // show an error message if request failed
      final error = json.decode(response.body)['message'];
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Error'),
          content: Text(error),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
    setState(() {
      _loginProcess = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.c1,
              AppColors.c2,
              AppColors.c3,
              AppColors.c4,
              AppColors.c5,
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  // logo
                  Image.asset(
                    'lib/images/loginscreen/TextLogo.png',
                    height: 250,
                    width: 250,
                  ),

                  // const SizedBox(height: 50,),
                  // welcome back
                  // Text(
                  //   'Please Login to continue!',
                  //   style: TextStyle(
                  //       color: AppColors.c5,
                  //       fontWeight: FontWeight.bold,
                  //       fontSize: 20.0),
                  // ),

                  const SizedBox(
                    height: 40,
                  ),
                  // username
                  MyTextField(
                    controller: usernameController,
                    hintText: 'User Name',
                    obscureText: false,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  // password
                  MyTextField(
                    controller: passwordController,
                    hintText: 'Password',
                    obscureText: _isPasswordHidden,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () => {
                      setState(
                        () {
                          _isPasswordHidden = !_isPasswordHidden;
                        },
                      )
                    },
                    child: Text(
                      'Show Password',
                      style: TextStyle(
                        color: AppColors.c0,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  // forgot password
                  GestureDetector(
                    onTap: () => {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ForgotpasswordPage(),
                          ))
                    },
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(
                        color: AppColors.c0,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  // sign in
                  _loginProcess == false
                      ? GestureDetector(
                          onTapDown: (_) => _onTapDown(),
                          onTapUp: (_) => _onTapUp(),
                          onTapCancel: () => _onTapCancel(),
                          child: ElevatedButton(
                            onPressed: () => {
                              setState(() {
                                _loginProcess = true;
                              }),
                              sendRequest(context, usernameController.text,
                                  passwordController.text),

                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) => HomePage(),
                              //   ),
                              // ),
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isTapped
                                  ? AppColors.c0.withOpacity(0.3)
                                  : Colors.transparent,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 133, vertical: 16),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100),
                                  side: BorderSide(
                                    color: AppColors.c0,
                                    width: 1.0,
                                  )),
                            ),
                            child: Text(
                              "Sign In",
                              style: TextStyle(
                                color: AppColors.c0,
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        )
                      : CircularProgressIndicator(color: AppColors.c1),
                  const SizedBox(
                    height: 20,
                  ),
                  // signup
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Not a Member?',
                        style: TextStyle(
                            color: AppColors.c0,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      GestureDetector(
                        onTap: () => {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignUpPage(),
                            ),
                          ),
                          setState(
                            () {
                              isTapped = true;
                            },
                          )
                        },
                        child: Text(
                          'Sign Up here!',
                          style: TextStyle(
                            color: AppColors.c0,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            decoration: isTapped
                                ? TextDecoration.underline
                                : TextDecoration.none,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
