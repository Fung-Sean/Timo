import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timo_test/app/modules/login/controllers/login_controller.dart';
import 'package:timo_test/app/modules/onboarding/controllers/onboarding_controller.dart';
import 'package:timo_test/app/modules/onboarding/views/onboarding_view.dart';

import '../../login/views/login_view.dart';
import '../../../routes/app_pages.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../onboarding/views/onboarding_transportation_view_view.dart';

class Intro5View extends GetView {
  const Intro5View({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final ButtonStyle style =
        ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));

    Uri linkURL = Uri(
        scheme: 'https',
        host: 'youtube.com',
        path: '/feed/subscriptions',
        fragment: '');

    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 200),
            Text(
              'Welcome to',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                  textStyle: const TextStyle(
                fontWeight: FontWeight.w300,
                color: Color.fromARGB(255, 64, 149, 249),
                fontSize: 25,
              )),
            ),
            Image.asset(
              'assets/timo_logo_copy.png',
              width: 350, // optional width
              height: 165, // optional height
            ),
            const SizedBox(height: 250),
            Padding(
              padding: const EdgeInsets.only(left: 50.0, right: 50.0),
              child: Text(
                'Before we begin, we would like to customize your experience.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                    textStyle: const TextStyle(
                  fontWeight: FontWeight.w300,
                  color: Colors.black,
                  fontSize: 20,
                )),
              ),
            ),
            const SizedBox(height: 50),
            SizedBox(
              width: 300,
              height: 50,
              child: ElevatedButton(
                  style: style,
                  onPressed: () {
                    Get.to(TransportationView());
                    Get.put(OnboardingController());
                  },
                  child: Text(
                    'Continue',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                        textStyle: const TextStyle(
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                      fontSize: 22,
                    )),
                  )),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
