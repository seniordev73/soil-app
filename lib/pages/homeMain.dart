import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:soil_app/utils/Colors.dart';

class HomeMain extends StatefulWidget {
  const HomeMain({super.key});

  @override
  State<HomeMain> createState() => _HomeMainState();
}

class _HomeMainState extends State<HomeMain> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.c3,
      body: Container(
        child: Center(
          child: Image.asset('lib/images/loginscreen/TextLogo.png',
                height: 300,
                width: 300,)
        ),
      ),
    );
  }
}