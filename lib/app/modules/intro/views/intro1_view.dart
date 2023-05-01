import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timo_test/app/modules/onboarding/views/onboarding_transportation_view_view.dart';

import '../../onboarding/controllers/onboarding_controller.dart';

//import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//import '../../../../notification_serviceController.dart';
import '../controllers/intro_controller.dart';

class Intro1View extends GetView {
  const Intro1View({Key? key}) : super(key: key);

  // final NotificationServiceController _notificationController =
  //     Get.put(NotificationServiceController());

  // static NotificationServiceController _notificationController =
  //     Get.put(NotificationServiceController());

  // static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  //     FlutterLocalNotificationsPlugin();
  static IntroController _controller = Get.find<IntroController>();

  @override
  Widget build(BuildContext context) {
    //define colors to use here
    Color page1Blue = Color.fromARGB(255, 84, 144, 248);

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 50),
                // ElevatedButton(
                //     onPressed: () => {_controller.sendNotification()},
                //     child: Text('Click me')),
                Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                  padding:
                      EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
                  child: Image.asset('assets/onboarding.png'),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                Padding(
                  padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.05,
                    right: MediaQuery.of(context).size.width * 0.05,
                    top: 0,
                    bottom: MediaQuery.of(context).size.width * 0.05,
                  ),
                  child: Text(
                    'Be on track to be on time',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                        textStyle: const TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Color.fromARGB(255, 84, 144, 248),
                      fontSize: 35,
                    )),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.05,
                    right: MediaQuery.of(context).size.width * 0.05,
                    top: 0,
                    bottom: MediaQuery.of(context).size.width * 0.05,
                  ),
                  child: Text(
                    'Connect your Google calendar and improve your daily routine',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                        textStyle: const TextStyle(
                      fontWeight: FontWeight.w300,
                      color: Colors.black,
                      fontSize: 20,
                    )),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
