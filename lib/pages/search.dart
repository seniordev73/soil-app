import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:soil_app/components/textfield.dart';
import 'package:soil_app/utils/Colors.dart';
import 'package:soil_app/utils/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Search extends StatefulWidget {
  const Search({super.key});


  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {

  num _lat = 0;
  num _long = 0;
  bool _loc_avail = false;
  bool _data_avail = false;
  bool _isLoading= false;
  List<dynamic> _searchData = [];

  final radiusController = TextEditingController();

  @override

  Future<void> search(BuildContext context, String radius) async{

    final List co_ordinates = await LocationServices.getLocation();
    setState(() {
      _loc_avail=true;
      _isLoading=true;
      _lat = co_ordinates[0];
      _long = co_ordinates[1];
    });

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final url = Uri.parse(
      'https://soil-app-backend.azurewebsites.net/prediction/search');
    final response = await http.post(
      url,
      headers: {'Authorization': 'Bearer $token'},
      body: {
        'latitude': _lat.toString(),
        'longitude': _long.toString(),
        'radius': radius
        },
    );
    final responseBody = jsonDecode(response.body);

    if(response.statusCode==200){
      
      print(responseBody);

      setState(() {
        _searchData = responseBody['data'];
        _data_avail=true;
      }); 
    }
    else{
        final message = responseBody['message'];
       showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Message"),
            content: Text(message),
            actions: [
              TextButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
    setState(() {
      _isLoading=false;
    });

  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.c3,
      appBar: AppBar(title: const Text("Search"),backgroundColor: AppColors.c5),
      body: _data_avail==false? 
        SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MyTextField(
                  controller: radiusController, 
                  hintText: 'Enter radius in km', 
                  obscureText: false
                ),
                const SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                  onPressed: ()=>{
                    search(context, radiusController.text),
                  },
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
                  child: _isLoading? 
                    Center(
                      child: CircularProgressIndicator(
                        color: AppColors.c5,
                      )
                    ): Text(
                    "Search",
                    style: TextStyle(
                      color: AppColors.c0,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),),)
            :
            Column(
              children: [
                Expanded(
                  child: ListView.builder(
                      itemCount: _searchData.length,
                      itemBuilder: (context, index) {
                        final soilType = _searchData[index]['soilType'];
                        final coordinates =
                            _searchData[index]['location']['coordinates'];
                        final id = _searchData[index]['_id'];
                        final date = _searchData[index]['samplingTime'];
                        return Card(
                          color: AppColors.c3,
                          child: ListTile(
                            title: Text('Soil Type: $soilType'),
                            subtitle: Center(
                              child: Column(
                                children: [
                                  Text(
                                      'Coordinates: ${coordinates[0]}, ${coordinates[1]}'),
                                  Text('Date:  ${date}')
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                ),
                  const SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(
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
                  )
                    ),
                    onPressed: () {
                      setState(() {
                        _data_avail=false;
                      });
                    },
                   child: Text('New Search',
                    style: TextStyle(
                      color: AppColors.c0,
                      fontSize: 20,
                      // fontWeight: FontWeight.bold,
                    ),),
                  ),
              ],
            ),
    );
  }
}