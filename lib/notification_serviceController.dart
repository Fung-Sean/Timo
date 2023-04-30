import 'notification_service.dart';
import 'package:get/get.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

const String channel_id = "1234";

class NotificationServiceController extends GetxController {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init(
      Future<dynamic> Function(int, String?, String?, String?)?
          onDidReceive) async {
    final AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      //iOS: initializationSettingsIOS,
      //macOS: null
    );

    //initializeLocalNotificationsPlugin(initializationSettings);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  //Future selectNotification(String? payload) async {}
  void showNotification(String notificationMessage) async {
    await flutterLocalNotificationsPlugin.show(
        0,
        "TIMO",
        notificationMessage,
        const NotificationDetails(
            android: AndroidNotificationDetails(channel_id, 'meow',
                channelDescription: 'To remind you to get moving!!',
                importance: Importance.high,
                priority: Priority.high)));
  }
}
