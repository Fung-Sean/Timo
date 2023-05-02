import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timo_test/app/modules/login/controllers/login_controller.dart';
import 'package:timo_test/app/modules/onboarding/controllers/onboarding_controller.dart';
import 'package:timo_test/app/modules/onboarding/views/onboarding_view.dart';

import '../../homescreen/controllers/homescreen_controller.dart';
import '../../homescreen/views/homescreen_view.dart';
import '../../login/views/login_view.dart';
import '../../../routes/app_pages.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../onboarding/views/onboarding_transportation_view_view.dart';

class AllSetView extends GetView {
  const AllSetView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final ButtonStyle style =
        ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));

    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 350),
            Text(
              "You're all set!",
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                  textStyle: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Color.fromARGB(255, 64, 149, 249),
                fontSize: 35,
              )),
            ),
            const SizedBox(height: 30),
            Text(
              'Timo will be linking your google calendar information.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                  textStyle: const TextStyle(
                fontWeight: FontWeight.w300,
                color: Colors.black,
                fontSize: 22,
              )),
            ),
            SizedBox(height: MediaQuery.of(context).size.width * 0.55),
            SizedBox(
              width: 300,
              height: 50,
              child: ElevatedButton(
                  style: style,
                  onPressed: () {
                    OnboardingController().seenIntroScreens();
                    Get.to(const HomescreenView());
                    Get.put(HomescreenController());
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
            SizedBox(height: MediaQuery.of(context).size.width * 0),
          ],
        ),
      ),
    );
  }
}
