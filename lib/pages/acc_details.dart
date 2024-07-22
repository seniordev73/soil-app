import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soil_app/utils/Colors.dart';

class AccDetails extends StatefulWidget {
  const AccDetails({super.key});

  @override
  State<AccDetails> createState() => _AccDetailsState();
}

class _AccDetailsState extends State<AccDetails> {

  String _email='';
  String _name='';
  String _phone='';

  @override

  void initState() {
    super.initState();
    load();
  }

  Future<void> load()async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('name');
    final email = prefs.getString('email');
    final phone = prefs.getString('phone');
    setState(() {
      _email=email!;
      _name=name!;
      _phone=phone!;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.c3,
      appBar: AppBar(
        backgroundColor: AppColors.c5,
        foregroundColor: AppColors.c0,
        leading: BackButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        
      ),
      body: Container(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 25,),
              Text('Name : ${_name}',style: TextStyle(
                  color: AppColors.c0,
                  fontSize: 25
                ),),
              const SizedBox(height: 35,),
              Text('Email : \n ${_email}',style: TextStyle(
                  color: AppColors.c0,
                  fontSize: 25
                ),),
              const SizedBox(height: 35,),
              Text('Phone : ${_phone}',style: TextStyle(
                  color: AppColors.c0,
                  fontSize: 25
                ),)
            ],
          ),
        ),
      ),
    );
  }
}