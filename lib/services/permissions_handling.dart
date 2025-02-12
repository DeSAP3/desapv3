import 'dart:io';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';

Logger logger = Logger();

class PermissionsHandler {
  Future<bool> requestPermission({required Permission permission}) async {
    PermissionStatus status = await permission.status;

    if (status.isGranted) {
      logger.d('Permission Already Granted');
      return true;
    } else {
      
      status = await permission.request();

      if (status.isGranted) {
        logger.d("Permission Accepted");
        return true;
      } else if (status.isPermanentlyDenied) {
        logger.d("Permission Permanently Denied. Enable it in settings.");
        await openAppSettings();
      } else {
        logger.e('Permission Denied');
        return false;
      }
    }

    return false;
  }

  Future<bool> requestMultiplePermission() async {
    final statusMap = await [
      Permission.microphone,
      Permission.camera,
      Platform.isIOS ? Permission.photos : Permission.storage,
      Permission.location,
      Permission.locationWhenInUse,
    ].request();

    debugPrint(
        "PermissionStatus Microphone: ${statusMap[Permission.microphone]}");
    debugPrint("PermissionStatus Camera: ${statusMap[Permission.camera]}");
    debugPrint(
        "PermissionStatus Photo Access: ${statusMap[Platform.isIOS ? Permission.photos : Permission.storage]}");
    debugPrint(
        "PermissionStatus Microphone: ${statusMap[Permission.locationWhenInUse]}");

    return statusMap.values.every((status) => status.isGranted);
  }

  Future<bool> requestPermissionWithSettings() => openAppSettings();
}
