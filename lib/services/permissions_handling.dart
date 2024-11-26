import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> requestPermission({required Permission permission}) async {
  final status = await permission.status;
  if (status.isGranted) {
    debugPrint('Permission already granted');
  } else if (status.isDenied) {
    if (await permission.request().isGranted) {
      debugPrint("Permission accepted");
    } else {
      debugPrint("Permission denied");
    }
  } else {
    debugPrint('Permission denied');
  }
}

Future<void> requestMultiplePermission() async {
  final statusMap = await [
    Permission.microphone,
    Permission.camera,
    Platform.isIOS ? Permission.photos : Permission.storage,
    Permission.locationWhenInUse
  ].request();

  debugPrint(
      "PermissionStatus Microphone: ${statusMap[Permission.microphone]}");
  debugPrint("PermissionStatus Microphone: ${statusMap[Permission.camera]}");
  debugPrint(
      "PermissionStatus Microphone: ${statusMap[Platform.isIOS ? Permission.photos : Permission.storage]}");
  debugPrint(
      "PermissionStatus Microphone: ${statusMap[Permission.locationWhenInUse]}");
}
