import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

///
/// Responsibilities:
/// - Requests notification permission.
/// - Requests exact alarm permission on Android.
/// - Opens app settings when permissions are permanently denied.
///
/// This keeps permission logic out of UI code and improves readability.
class PermissionService {
  /// Requests all permissions required for notifications.
  static Future<void> requestNotificationPermissions(
      BuildContext context) async {
    // Request notification permission
    var notificationStatus = await Permission.notification.status;
    if (notificationStatus.isDenied) {
      notificationStatus = await Permission.notification.request();
    }

    // Request exact alarm permission (Android only)
    if (Theme.of(context).platform == TargetPlatform.android) {
      var alarmStatus = await Permission.scheduleExactAlarm.status;
      if (alarmStatus.isDenied) {
        await Permission.scheduleExactAlarm.request();
      }
    }
  }

  /// Opens the application settings page.
  static Future<void> openSettings() async {
    await openAppSettings();
  }
}
