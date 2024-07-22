import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:soil_app/pages/soilProps.dart';
import 'package:soil_app/pages/soilPropsQuery.dart';
import 'package:soil_app/utils/Colors.dart';

class SoilProps extends StatefulWidget {
  const SoilProps({super.key});

  @override
  State<SoilProps> createState() => _SoilPropsState();
}

class _SoilPropsState extends State<SoilProps> {
  var _pageState =0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.c3,
      appBar: _pageState!=0? AppBar(
        title: _pageState==1? Text("Soil Props(AI)"):Text("Soil Props Query"),
        backgroundColor: AppColors.c5,
        leading: BackButton(
          onPressed: () {
            setState(() {
              _pageState=0;
            });
          },
        ),
      ):
      AppBar(
        title: Text("Soil Props"),
        centerTitle: true,
        backgroundColor: AppColors.c5,
      ),
      body:_pageState<1? Center(
        child: Column(
          children: [
            SizedBox(height: 45,),
            ElevatedButton(
              onPressed: ()=>{
                setState(() {
                  _pageState=1;
                },),
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
                "Property Search",
                style: TextStyle(
                  color: AppColors.c0,
                  fontSize: 20,
                ),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            ElevatedButton(
              onPressed: ()=>{
                setState(() {
                  _pageState=2;
                },),
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
                "Method Search",
                style: TextStyle(
                  color: AppColors.c0,
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
      ):
      _pageState==1?SoilPropsAi():SoilPropsQuery(),
    );
  }
}