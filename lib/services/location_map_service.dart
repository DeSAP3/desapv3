import 'dart:io';
import 'package:desapv3/services/permissions_handling.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationServices {
  PermissionsHandler phandler = PermissionsHandler();
  late bool locationTrackingPermission = false;
  late Position? _currentPosition;

  Future<Position?> getCurrentLocation() async {
    bool servicePermission = await Geolocator.isLocationServiceEnabled();
    if (!servicePermission) {
      logger.e(
          "Location Services Disabled. Please Enable Them in Device Settings"); //Snack bar this please
          
    } else {
      locationTrackingPermission =
          await phandler.requestPermission(permission: Permission.location);

      if (!locationTrackingPermission) {
        logger.e("Location Permission Denied. Enable it in Device Settings");
        throw Exception("Location Permission Denied");
      }
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<Placemark?> getAddress(Position pos) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(pos.latitude, pos.longitude);

      if (placemarks.isNotEmpty) {
        Placemark location = placemarks.first;
        logger.d("Country: ${location.country}");
        return location;
      } else {
        logger.e("No address found for this location.");
        return null;
      }
    } catch (e) {
      logger.e(e);
      return null;
    }
  }
}
