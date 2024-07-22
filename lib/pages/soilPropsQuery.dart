import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:soil_app/pages/soilPropsAi.dart';

import 'package:http/http.dart' as http;
import '../components/textfield.dart';
import '../utils/Colors.dart';

class SoilPropsQuery extends StatefulWidget {
  const SoilPropsQuery({super.key});

  @override
  State<SoilPropsQuery> createState() => _SoilPropsQueryState();
}

class _SoilPropsQueryState extends State<SoilPropsQuery> {
  bool _isLoading=false;
  String method='';
  final propertyController = TextEditingController();
  @override

  Future<void> sendRequest(BuildContext context, String prompt) async {
    setState(() {
      _isLoading=true;
    });
    final url = Uri.parse(
        'https://soil-app-backend.azurewebsites.net/ai/property-query'); // replace with your API URL

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'property': prompt,
      },
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      final data = responseBody['data'];
      setState(() {
        method=data;
      });
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
      _isLoading=false;
      
    });
    
    propertyController.clear();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.c3,
      body: method==''?Column(
        children: [
          SizedBox(height: 30,),
          MyTextField(
            controller: propertyController, 
            hintText: 'Enter the property', 
            obscureText: false
          ),
          SizedBox(height: 30,),
          ElevatedButton(
              onPressed: ()=>{
                setState(() {
                  _isLoading=true;
                }) ,
                sendRequest(context, propertyController.text),
                
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.c5.withOpacity(0.3),
                padding: const EdgeInsets.symmetric(
                  horizontal: 80, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                  side: BorderSide(
                    color: AppColors.c0,
                    width: 1.0,
                  )
              )),
              child:
                _isLoading?CircularProgressIndicator(
                  color: AppColors.c5,
                ):  Text(
                "Search",
                style: TextStyle(
                  color: AppColors.c0,
                  fontSize: 20,
                ),
              ),
            ),
        ],
      ):
      SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: Text(method, style: TextStyle(color: AppColors.c0, fontSize: 20)),
            ),
            SizedBox(height: 30,),
            ElevatedButton(
              onPressed: ()=>{
                setState(() {
                  method='';
                }),
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.c5.withOpacity(0.3),
                padding: const EdgeInsets.symmetric(
                  horizontal: 80, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                  side: BorderSide(
                    color: AppColors.c0,
                    width: 1.0,
                  )
              )),
              child:
                Text(
                "New Search",
                style: TextStyle(
                  color: AppColors.c0,
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}