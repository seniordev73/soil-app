import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:soil_app/utils/Colors.dart';

import 'forgotpassword_page.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.c3,
      appBar: AppBar(
          title: Text('The Soil App'),
          centerTitle: true,
          backgroundColor: AppColors.c5,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 30,),
          GestureDetector(
                    onTap: () => {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ForgotpasswordPage(),
                          ))
                    },
                    child: Center(
                      child: Text(
                        'Reset password',
                        style: TextStyle(
                          color: AppColors.c0,
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                    ),
                  ),
        ],
      ),
    );
  }
}