import 'package:permission_handler/permission_handler.dart';
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';
import "package:flutter/services.dart";

class Permissions {
  static Future<bool> cameraAndMicrophonePermissionsGranted() async {
    PermissionStatus cameraPermissionStatus = await _getCameraPermission();
    PermissionStatus microphonePermissionStatus =
        await _getMicrophonePermission();

    if (cameraPermissionStatus == PermissionStatus.granted &&
        microphonePermissionStatus == PermissionStatus.granted) {
      return true;
    } else {
      _handleInvalidPermissions(
          cameraPermissionStatus, microphonePermissionStatus);
      return false;
    }
  }

  static Future<PermissionStatus> _getCameraPermission() async {
    PermissionStatus permission = await Permission.camera.status;
    if(!permission.isGranted) {
       PermissionStatus permissionStatus =
          await Permission.camera.request();
      return permissionStatus;
    } else {
      return permission;
    }
  }

  static Future<PermissionStatus> _getMicrophonePermission() async {
    PermissionStatus permission = await Permission.microphone.status;
    if (!permission.isGranted) {
      PermissionStatus permissionStatus =
          await Permission.microphone.request();
      return permissionStatus;
    } else {
      return permission;
    }
  }

  static void _handleInvalidPermissions(
    PermissionStatus cameraPermissionStatus,
    PermissionStatus microphonePermissionStatus,
  ) {
    if (cameraPermissionStatus == PermissionStatus.denied &&
        microphonePermissionStatus == PermissionStatus.denied) {
      throw new PlatformException(
          code: "PERMISSION_DENIED",
          message: "Access to camera and microphone denied",
          details: null);
    } 
  }
}