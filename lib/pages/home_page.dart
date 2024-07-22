import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:soil_app/pages/history.dart';
import 'package:soil_app/pages/image_pick.dart';
import 'package:soil_app/pages/my_acc.dart';
import 'package:soil_app/pages/login_page.dart';
import 'package:soil_app/pages/search.dart';
import 'package:soil_app/pages/soilProps.dart';
import 'package:soil_app/pages/soilPropsAi.dart';
import 'package:soil_app/utils/Colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'homeMain.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});
  static List<Widget> _widgetOptions = <Widget>[
    HomeMain(),
    Search(),
    ImgPicker(),
    SoilProps(),
    myAcc(),
  ];

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  DateTime? _lastPressedAt;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Ask user if they want to close the app
        final now = DateTime.now();
        if (_lastPressedAt == null ||
            now.difference(_lastPressedAt!) > const Duration(seconds: 1)) {
          _lastPressedAt = now;
          final snackBar =
              SnackBar(content: const Text('Press back again to exit'));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          return false;
        } else {
          // User has pressed back button twice within 1 second, exit app
          return true;
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.c3,
        appBar: AppBar(
          title: Text('The Soil App'),
          centerTitle: true,
          backgroundColor: AppColors.c5,
        ),
        // drawer: Drawer(
        //   child: Container(
        //     color: AppColors.c4,
        //     child: ListView(
        //       children: [
        //         DrawerHeader(
        //           child: Center(
        //             child: Text(
        //               'Home',
        //               style: TextStyle(
        //                   fontSize: 35,
        //                   fontWeight: FontWeight.bold,
        //                   color: AppColors.c0),
        //             ),
        //           ),
        //         ),
        //         ListTile(
        //           leading: Icon(
        //             Icons.account_tree_rounded,
        //             size: 35,
        //             color: AppColors.c0,
        //           ),
        //           title: Text(
        //             'Soil Properties AI',
        //             style: TextStyle(fontSize: 30, color: AppColors.c0),
        //           ),
        //           onTap: () => {
        //             Navigator.pushReplacement(
        //               context,
        //               MaterialPageRoute(builder: (context) => SoilPropsAi()),
        //             )
        //           },
        //         ),
        //         ListTile(
        //           leading: Icon(
        //             Icons.account_circle,
        //             size: 35,
        //             color: AppColors.c0,
        //           ),
        //           title: Text(
        //             'My Account',
        //             style: TextStyle(fontSize: 30, color: AppColors.c0),
        //           ),
        //           onTap: () => {},
        //         ),
        //         ListTile(
        //           leading: Icon(
        //             Icons.history_outlined,
        //             size: 35,
        //             color: AppColors.c0,
        //           ),
        //           title: Text(
        //             'My History',
        //             style: TextStyle(fontSize: 30, color: AppColors.c0),
        //           ),
        //           onTap: () => {},
        //         ),
        //         ListTile(
        //           leading: Icon(
        //             Icons.settings_applications_outlined,
        //             size: 35,
        //             color: AppColors.c0,
        //           ),
        //           title: Text(
        //             'Settings',
        //             style: TextStyle(fontSize: 30, color: AppColors.c0),
        //           ),
        //           onTap: () => {},
        //         ),
        //         ListTile(
        //           leading: Icon(
        //             Icons.logout_rounded,
        //             size: 35,
        //             color: AppColors.c0,
        //           ),
        //           title: Text(
        //             'Logout',
        //             style: TextStyle(fontSize: 30, color: AppColors.c0),
        //           ),
        //           onTap: () => {
        //             SharedPreferences.getInstance().then((prefs) {
        //               prefs.clear();
        //               Navigator.pushAndRemoveUntil(
        //                 context,
        //                 MaterialPageRoute(builder: (context) => LoginPage()),
        //                 (Route<dynamic> route) => false,
        //               );
        //             })
        //           },
        //         ),
        //         ListTile(
        //           leading: Icon(
        //             Icons.phone_outlined,
        //             size: 35,
        //             color: AppColors.c0,
        //           ),
        //           title: Text(
        //             'Contact Us',
        //             style: TextStyle(fontSize: 30, color: AppColors.c0),
        //           ),
        //           onTap: () => {},
        //         ),
        //         ListTile(
        //           leading: Icon(
        //             Icons.info_outline,
        //             size: 35,
        //             color: AppColors.c0,
        //           ),
        //           title: Text(
        //             'About Us',
        //             style: TextStyle(fontSize: 30, color: AppColors.c0),
        //           ),
        //           onTap: () => {},
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
        bottomNavigationBar: GNav(
          backgroundColor: (AppColors.c5),
          rippleColor: (AppColors.c2),
          hoverColor: (AppColors.c1),
          
          tabs: [
            GButton(
              icon: Icons.home_outlined,
              iconSize: 30,
              iconColor: AppColors.c0,
            ),
            GButton(
              icon: Icons.search_outlined,
              iconSize: 30,
              iconColor: AppColors.c0,
            ),
            GButton(
              icon: Icons.camera_outlined,
              iconSize: 30,
              iconColor: AppColors.c0,
            ),
            GButton(
              icon: Icons.account_tree_rounded,
              iconSize: 30,
              iconColor: AppColors.c0,
            ),
            GButton(
              icon: Icons.account_circle_outlined,
              iconSize: 30,
              iconColor: AppColors.c0,
            ),
          ],
          selectedIndex: _selectedIndex,
          onTabChange: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
        body: Center(
          child: HomePage._widgetOptions.elementAt(_selectedIndex),
        ),
      ),
    );
  }
}
