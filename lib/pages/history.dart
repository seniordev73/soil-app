import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:soil_app/utils/Colors.dart';

class History extends StatefulWidget {
  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  List<dynamic> _historyData = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchHistoryData();
  }

  Future<void> _fetchHistoryData() async {
    setState(() {
      _isLoading = true;
    });

    // Check if cached data is available
    final prefs = await SharedPreferences.getInstance();
    final historyJson = prefs.getString('historyJson');
    if (historyJson != null) {
      setState(() {
        _historyData = jsonDecode(historyJson);
        _isLoading = false;
      });
      return;
    }

    // Fetch data from API
    final userId = prefs.getString('userId');
    final token = prefs.getString('token');
    final url = Uri.parse(
        'https://soil-app-backend.azurewebsites.net/prediction/history');
    final response = await http.post(
      url,
      headers: {'Authorization': 'Bearer $token'},
      body: {'userId': userId},
    );
    final responseBody = jsonDecode(response.body);

    // Cache data in shared preferences
    prefs.setString('historyJson', jsonEncode(responseBody['data']));

    setState(() {
      _historyData = responseBody['data'];
      _isLoading = false;
    });
  }

  Future<void> _refreshHistoryData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('historyJson'); // Remove cached data

    _fetchHistoryData();
  }

  Future<void> _deleteHistoryData(String id) async {
    print("delete initiated");
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final url = Uri.parse(
        'https://soil-app-backend.azurewebsites.net/prediction/delete');
    final response = await http.delete(
      url,
      headers: {'Authorization': 'Bearer $token'},
      body: {'id': id},
    );
    final message = json.decode(response.body)['message'];

    if (response.statusCode == 200) {
      // Remove item from the local list and shared preferences
      setState(() {
        _historyData.removeWhere((data) => data['_id'] == id);
      });
      final historyJson = jsonEncode(_historyData);
      prefs.setString('historyJson', historyJson);
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
    } else {
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
  }

  Future<void> _showConfirmationDialog(String id) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm"),
          content: Text("Are you sure you want to delete this item?"),
          actions: [
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Delete"),
              onPressed: () {
                _deleteHistoryData(id);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.c4,
      appBar: AppBar(
        title: Text('My History'),
        centerTitle: true,
        backgroundColor: AppColors.c5,
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
              color: AppColors.c5,
            ))
          : RefreshIndicator(
              onRefresh: _refreshHistoryData,
              child: ListView.builder(
                itemCount: _historyData.length,
                itemBuilder: (context, index) {
                  final soilType = _historyData[index]['soilType'];
                  final coordinates =
                      _historyData[index]['location']['coordinates'];
                  final id = _historyData[index]['_id'];
                  final date = _historyData[index]['samplingTime'];
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
                      trailing: GestureDetector(
                        onTap: () => {_showConfirmationDialog(id)},
                        child: Icon(Icons.delete),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
