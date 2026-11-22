import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionStatusModel {
  final bool locationGranted;
  final bool cameraGranted;
  final bool microphoneGranted;

  PermissionStatusModel({
    required this.locationGranted,
    required this.cameraGranted,
    required this.microphoneGranted,
  });

  bool get allGranted =>
      locationGranted && cameraGranted && microphoneGranted;
}

class PermissionService {
  static final PermissionService _instance = PermissionService._internal();
  factory PermissionService() => _instance;
  PermissionService._internal();

  /// Check current status of all 3 required permissions
  Future<PermissionStatusModel> checkPermissions() async {
    if (kIsWeb) {
      // In web, permissions are requested on-demand by browsers
      return PermissionStatusModel(
        locationGranted: true,
        cameraGranted: true,
        microphoneGranted: true,
      );
    }

    try {
      final loc = await Permission.location.isGranted;
      final cam = await Permission.camera.isGranted;
      final mic = await Permission.microphone.isGranted;

      return PermissionStatusModel(
        locationGranted: loc,
        cameraGranted: cam,
        microphoneGranted: mic,
      );
    } catch (e) {
      debugPrint('Error checking permissions: $e');
      return PermissionStatusModel(
        locationGranted: false,
        cameraGranted: false,
        microphoneGranted: false,
      );
    }
  }

  /// Request individual permission
  Future<bool> requestLocation() async {
    if (kIsWeb) return true;
    try {
      final status = await Permission.location.request();
      return status.isGranted;
    } catch (_) {
      return true; // Fallback for unsupported desktop platforms
    }
  }

  Future<bool> requestCamera() async {
    if (kIsWeb) return true;
    try {
      final status = await Permission.camera.request();
      return status.isGranted;
    } catch (_) {
      return true;
    }
  }

  Future<bool> requestMicrophone() async {
    if (kIsWeb) return true;
    try {
      final status = await Permission.microphone.request();
      return status.isGranted;
    } catch (_) {
      return true;
    }
  }

  /// Request all three permissions together
  Future<PermissionStatusModel> requestAllPermissions() async {
    if (kIsWeb) {
      return PermissionStatusModel(
        locationGranted: true,
        cameraGranted: true,
        microphoneGranted: true,
      );
    }

    try {
      final statuses = await [
        Permission.location,
        Permission.camera,
        Permission.microphone,
      ].request();

      return PermissionStatusModel(
        locationGranted: statuses[Permission.location]?.isGranted ?? true,
        cameraGranted: statuses[Permission.camera]?.isGranted ?? true,
        microphoneGranted: statuses[Permission.microphone]?.isGranted ?? true,
      );
    } catch (e) {
      debugPrint('Error requesting permissions: $e');
      return PermissionStatusModel(
        locationGranted: true,
        cameraGranted: true,
        microphoneGranted: true,
      );
    }
  }
}
