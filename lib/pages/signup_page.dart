import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:soil_app/components/appbar2.dart';
import 'package:soil_app/components/textfield.dart';
import 'package:soil_app/pages/home_page.dart';
import 'package:soil_app/pages/image_pick.dart';
import 'package:soil_app/pages/login_page.dart';
import 'package:soil_app/utils/Colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final firstnameController = TextEditingController();
  final lastnameController = TextEditingController();
  final phonenoController = TextEditingController();
  final mailaddController = TextEditingController();
  final passController = TextEditingController();
  final repassController = TextEditingController();

  bool _signupProcess = false;
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

  Future<void> sendRequest(BuildContext context, String firstName,
      String lastName, String phone, String email, String password) async {
    // setState(() {
    //   _signupProcess = true;
    // });
    String name = firstName + " " + lastName;
    final url = Uri.parse(
        'https://soil-app-backend.azurewebsites.net/user/signup'); // replace with your API URL

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'name': name,
        'phone': phone,
        'email': email,
        'password': password,
      },
    );
    print(response.statusCode);
    if (response.statusCode == 201) {
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
      setState(() {
        _signupProcess = false;
      });
      // navigate to HomePage and prevent user from going back
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
        (Route<dynamic> route) => false,
      );
    } else {
      setState(() {
        _signupProcess = false;
      });
      // setState(() {
      //   _signupProcess = false;
      // });
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        height: double.infinity,
        width: double.infinity,
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
            child: SingleChildScrollView(
          child: Column(
            children: [
              AppBar2(),
              const SizedBox(
                height: 20,
              ),
              Text(
                'Welcome!',
                style: TextStyle(
                  color: AppColors.c5,
                  fontSize: 60,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Ralaway",
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 400,
                height: 50,
                child: MyTextField(
                    controller: firstnameController,
                    hintText: 'First Name',
                    obscureText: false),
              ),
              const SizedBox(
                height: 25,
              ),
              SizedBox(
                width: 400,
                height: 50,
                child: MyTextField(
                    controller: lastnameController,
                    hintText: 'Last Name',
                    obscureText: false),
              ),
              const SizedBox(
                height: 25,
              ),
              SizedBox(
                width: 400,
                height: 50,
                child: MyTextField(
                    controller: phonenoController,
                    hintText: 'Phone No.',
                    obscureText: false),
              ),
              const SizedBox(
                height: 25,
              ),
              SizedBox(
                width: 400,
                height: 50,
                child: MyTextField(
                    controller: mailaddController,
                    hintText: 'e-mail address',
                    obscureText: false),
              ),
              const SizedBox(
                height: 25,
              ),
              SizedBox(
                width: 400,
                height: 50,
                child: MyTextField(
                    controller: passController,
                    hintText: 'Password',
                    obscureText: true),
              ),
              const SizedBox(
                height: 25,
              ),
              SizedBox(
                width: 400,
                height: 50,
                child: MyTextField(
                    controller: repassController,
                    hintText: 'Re-enter Password',
                    obscureText: true),
              ),
              const SizedBox(
                height: 25,
              ),
              _signupProcess == false
                  ? GestureDetector(
                      onTapDown: (_) => _onTapDown(),
                      onTapUp: (_) => _onTapUp(),
                      onTapCancel: () => _onTapCancel(),
                      child: ElevatedButton(
                        onPressed: () => {
                          if (passController.text == repassController.text)
                            {
                              setState(() {
                                _signupProcess = true;
                              }),
                              sendRequest(
                                  context,
                                  firstnameController.text,
                                  lastnameController.text,
                                  phonenoController.text,
                                  mailaddController.text,
                                  passController.text),
                              // setState(() {
                              //   _signupProcess = false;
                              // })
                            }
                          else
                            {
                              setState(() {
                                _signupProcess = false;
                              }),
                              showDialog(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  title: const Text('Error'),
                                  content: Text("passwords don't match!"),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('OK'),
                                    ),
                                  ],
                                ),
                              )
                            },
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
                          "Sign Up",
                          style: TextStyle(
                            color: AppColors.c0,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                  : CircularProgressIndicator(
                      color: AppColors.c1,
                    ),
            ],
          ),
        )),
      ),
    );
  }
}
