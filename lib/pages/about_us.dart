import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../utils/Colors.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({super.key});

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {

  late final String text;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.c3,
      appBar: AppBar(
        title: Text('The Soil App'),
        centerTitle: true,
        backgroundColor: AppColors.c5,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 30,
            ),
            Text('Hi, nice to meet you!',
              style: TextStyle(
                color: AppColors.c0,
                fontSize: 35
              ),),
            const SizedBox(
              height: 30,
            ),
            Text("Contact Details:",
              style: TextStyle(
                color: AppColors.c0,
                fontSize: 35
              ),),
            const SizedBox(
              height: 30,
            ),
            Text("email: ",
              style: TextStyle(
                color: AppColors.c0,
                fontSize: 35
              ),),
            const SizedBox(
              height: 30,
            ),
            SelectableText.rich(
              TextSpan(
                style: TextStyle(
                  color: AppColors.c5,
                  fontSize: 35
                ),
                children: [
                  TextSpan(text: 'soil.app.bit@gmail.com'),
                ]
              )
            ),
            const SizedBox(
              height: 30,
            ),
            Text("phone: ",
              style: TextStyle(
                color: AppColors.c0,
                fontSize: 35
              ),),
            const SizedBox(
              height: 30,
            ),
            SelectableText.rich(
              TextSpan(
                style: TextStyle(
                  color: AppColors.c5,
                fontSize: 35
                ),
                children: [
                  TextSpan(text:'1234567890'),
                ]
              ),),
          ],
        ),
      ),
    );
  }
}