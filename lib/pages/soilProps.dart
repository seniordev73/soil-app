import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:soil_app/pages/soilPropsAi.dart';
import 'package:soil_app/utils/Colors.dart';

class SoilPropsAi extends StatefulWidget {
  const SoilPropsAi({Key? key}) : super(key: key);

  @override
  _SoilPropsAiState createState() => _SoilPropsAiState();
}

class _SoilPropsAiState extends State<SoilPropsAi> {
  List<TextEditingController> _controllers = [];
  List<dynamic> _soilPropsData = [];
  bool _isData = false;
  bool _isLoading= false;

  @override
  void initState() {
    super.initState();
    _controllers.add(TextEditingController());
  }

  @override
  void dispose() {
    _controllers.forEach((controller) => controller.dispose());
    super.dispose();
  }

  void _addTextField() {
    setState(() {
      _controllers.add(TextEditingController());
    });
  }

  void _removeTextField(int index) {
    setState(() {
      _controllers.removeAt(index);
    });
  }

  Future<void> sendRequest(BuildContext context, String prompt) async {
    setState(() {
      _isLoading=true;
    });
    print("request initiated");
    final url = Uri.parse(
        'https://soil-app-backend.azurewebsites.net/ai/extract-parameters'); // replace with your API URL

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'parameters': prompt,
      },
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      print(responseBody['extractedParameters']);
      setState(() {
        _soilPropsData = responseBody['extractedParameters'];
        _isData = true;
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
  }

  void _handleSubmit() {
    String prompt =
        _controllers.map((controller) => controller.text.trim()).join(", ");
    sendRequest(context, prompt);
  }

  @override
  Widget build(BuildContext context) {
    return _isData == false
        ? Scaffold(
            backgroundColor: AppColors.c3,
            body: ListView.builder(
              shrinkWrap: true,
              itemCount: _controllers.length,
              itemBuilder: (BuildContext context, int index) {
                return Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controllers[index],
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          hintText: "Enter text",
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                        ),
                        cursorColor: AppColors.c5,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _removeTextField(index),
                    ),
                  ],
                );
              },
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: AppColors.c5,
              child: Icon(Icons.add),
              onPressed: _addTextField,
            ),
            bottomNavigationBar: Padding(
              padding: EdgeInsets.all(8),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.c5.withOpacity(0.3),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 133, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                      side: BorderSide(
                        color: AppColors.c0,
                        width: 1.0,
                      )
                  )),
                child:_isLoading?CircularProgressIndicator(
                  color: AppColors.c5,
                ): Text("Submit",
                    style: TextStyle(
                      color: AppColors.c0,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),),
                onPressed: _handleSubmit,
              ),
            ),
          )
        : Scaffold(
            backgroundColor: AppColors.c3,
            body: ListView.builder(
              shrinkWrap: true,
              itemCount: _soilPropsData.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(
                    "${index + 1}. ${_soilPropsData[index]['value']}",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                );
              },
            ),
            bottomNavigationBar: Padding(
              padding: EdgeInsets.all(8),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.c5.withOpacity(0.3),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 133, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                      side: BorderSide(
                        color: AppColors.c0,
                        width: 1.0,
                      )
                  )),
                  child: Text("New Search",
                    style: TextStyle(
                      color: AppColors.c0,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),),
                  onPressed: () => {
                        setState(() {
                          _isData = false;
                          _soilPropsData = [];
                          _controllers
                              .forEach((controller) => controller.clear());
                        })
                      }),
            ),
          );
  }
}
