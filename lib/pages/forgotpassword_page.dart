import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:soil_app/components/textfield.dart';
import 'package:soil_app/utils/Colors.dart';
import 'package:soil_app/components/appbar2.dart';
import 'login_page.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

class ForgotpasswordPage extends StatefulWidget {
  const ForgotpasswordPage({super.key});

  @override
  State<ForgotpasswordPage> createState() => _ForgotpasswordPageState();
}

class _ForgotpasswordPageState extends State<ForgotpasswordPage> {
  final mailidController = TextEditingController();
  final codeController = TextEditingController();
  final passController = TextEditingController();
  final repassController = TextEditingController();

  bool isTokenSent = false;
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

  Future<void> sendMail(BuildContext context, String email) async {
    final url = Uri.parse(
        'https://soil-app-backend.azurewebsites.net/user/forgot-password'); // replace with your API URL

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'email': email,
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        isTokenSent = true;
      });
    } else {
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

  Future<void> resetPassword(BuildContext context, String token,
      String password, String repassword) async {
    final url = Uri.parse(
        'https://soil-app-backend.azurewebsites.net/user/reset-password'); // replace with your API URL

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'token': token,
        'password': password,
        'confirmPassword': repassword
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final message = data['message'];
      setState(() {
        isTokenSent = false;
      });
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Password changed!'),
          content: Text("$message. Enter new login details after pressing OK"),
          actions: [
            TextButton(
              onPressed: () => {
                Navigator.pop(context),
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                  (Route<dynamic> route) => false,
                )
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } else {
      final error = json.decode(response.body)['message'];
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Error'),
          content: Text(error),
          actions: [
            TextButton(
              onPressed: () => {
                Navigator.pop(context),
              },
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
        height: MediaQuery.of(context).size.height,
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
            ])),
        child: isTokenSent == false
            ? SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    AppBar2(),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 80, horizontal: 20),
                      child: Text(
                        'Please enter your email address to receive the mail for changing password:',
                        style: TextStyle(
                            color: AppColors.c0,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'RobotoMono'),
                      ),
                    ),
                    SizedBox(height: 1),
                    SizedBox(
                        height: 50,
                        width: 400,
                        child: MyTextField(
                            controller: mailidController,
                            hintText: 'e-mail id',
                            obscureText: false)),
                    SizedBox(height: 25),
                    GestureDetector(
                      onTapDown: (_) => _onTapDown(),
                      onTapUp: (_) => _onTapUp(),
                      onTapCancel: () => _onTapCancel(),
                      child: ElevatedButton(
                          onPressed: () =>
                              {sendMail(context, mailidController.text)},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isTapped
                                ? AppColors.c0.withOpacity(0.3)
                                : Colors.transparent,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 120, vertical: 12),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100),
                                side: BorderSide(
                                  color: AppColors.c0,
                                  width: 1.0,
                                )),
                          ),
                          child: Text(
                            'Send mail',
                            style: TextStyle(
                              color: AppColors.c0,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          )),
                    )
                  ],
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AppBar2(),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 80, horizontal: 20),
                      child: Text(
                        'Please enter the code sent on the mail and reset your password:',
                        style: TextStyle(
                            color: AppColors.c0,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'RobotoMono'),
                      ),
                    ),
                    SizedBox(height: 1),
                    SizedBox(
                        height: 50,
                        width: 400,
                        child: MyTextField(
                            controller: codeController,
                            hintText: 'code',
                            obscureText: false)),
                    SizedBox(height: 25),
                    SizedBox(
                        height: 50,
                        width: 400,
                        child: MyTextField(
                            controller: passController,
                            hintText: 'password',
                            obscureText: true)),
                    SizedBox(height: 25),
                    SizedBox(
                        height: 50,
                        width: 400,
                        child: MyTextField(
                            controller: repassController,
                            hintText: 're-enter password',
                            obscureText: true)),
                    SizedBox(height: 50),
                    GestureDetector(
                      onTapDown: (_) => _onTapDown(),
                      onTapUp: (_) => _onTapUp(),
                      onTapCancel: () => _onTapCancel(),
                      child: ElevatedButton(
                          onPressed: () => {
                                resetPassword(context, codeController.text,
                                    passController.text, repassController.text)
                              },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isTapped
                                ? AppColors.c0.withOpacity(0.3)
                                : Colors.transparent,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 70, vertical: 12),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100),
                                side: BorderSide(
                                  color: AppColors.c0,
                                  width: 1.0,
                                )),
                          ),
                          child: Text(
                            'Reset password',
                            style: TextStyle(
                              color: AppColors.c0,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          )),
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
