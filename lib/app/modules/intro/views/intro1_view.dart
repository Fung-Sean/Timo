import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timo_test/app/modules/onboarding/views/onboarding_transportation_view_view.dart';

import '../../onboarding/controllers/onboarding_controller.dart';

//import '../../../routes/app_routes.dart';
//import '../modules/login/views/login_view.dart';

class Intro1View extends GetView {
  const Intro1View({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    //define colors to use here
    Color page1Blue = Color.fromARGB(255, 84, 144, 248);
    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 100),
            Container(
              height: 350,
              padding: const EdgeInsets.all(4.0),
              child: Image.asset('assets/onboarding.png'),
            ),
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Text(
                'Be on track to be on time',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                    textStyle: const TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Color.fromARGB(255, 84, 144, 248),
                  fontSize: 45,
                )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Text(
                'Connect your Google calendar and improve your daily routine',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                    textStyle: const TextStyle(
                  fontWeight: FontWeight.w300,
                  color: Colors.black,
                  fontSize: 22,
                )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
