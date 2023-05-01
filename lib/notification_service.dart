import 'package:get/get.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

abstract class NotificationService extends GetxController {
  // static final NotificationService _notificationService =
  //     NotificationService._internal();

  // factory NotificationService() {
  //   return _notificationService;
  // }

  // NotificationService._internal();

  void init(
      Future<dynamic> Function(int, String?, String?, String?)? onDidReceive);
  void showNotification(String notificationMessage);
}
