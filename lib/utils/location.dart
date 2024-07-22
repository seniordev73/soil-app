import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';

class LocationServices {
  static Future<List> getLocation() async {
    //returns list of co-ordinates
    Position currentPosition;
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      LocationPermission asked = await Geolocator.requestPermission();
    } else {
      currentPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
      return [currentPosition.latitude, currentPosition.longitude];
    }
    return [0, 0];
  }
}
