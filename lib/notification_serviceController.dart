// import 'package:flutter/material.dart';

// import 'notification_service.dart';
// import 'package:get/get.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// const String channel_id = "1234";

// class NotificationServiceController extends GetxController {
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   static Future initialize(
//       FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
//     final AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings('app_icon');

//     final InitializationSettings initializationSettings =
//         InitializationSettings(
//       android: initializationSettingsAndroid,
//       //iOS: initializationSettingsIOS,
//       //macOS: null
//     );

//     //initializeLocalNotificationsPlugin(initializationSettings);
//     await flutterLocalNotificationsPlugin.initialize(initializationSettings);
//   }

  // Future showNotification(String notificationMessage) async {
  //   await flutterLocalNotificationsPlugin.show(
  //       0,
  //       "TIMO",
  //       notificationMessage,
  //       const NotificationDetails(
  //           android: AndroidNotificationDetails(channel_id, 'meow',
  //               channelDescription: 'To remind you to get moving!!',
  //               importance: Importance.high,
  //               priority: Priority.high)));
  // }

//   static Future showNotification(
//       {var id = 0,
//       required String title,
//       required String body,
//       var payload,
//       required FlutterLocalNotificationsPlugin fln}) async {
//     AndroidNotificationDetails androidPlatformChannelSpecifics =
//         new AndroidNotificationDetails(
//       'AIzaSyClNisCXgPVCbZXqReGLLc3k-5uz6Ho9Mg',
//       'channel_name',
//       importance: Importance.max,
//       priority: Priority.high,
//     );

//     var noti = NotificationDetails(android: androidPlatformChannelSpecifics);
//     await fln.show(0, title, body, noti);
//   }
// }
