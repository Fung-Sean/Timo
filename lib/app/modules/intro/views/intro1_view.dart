import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timo_test/app/modules/onboarding/views/onboarding_transportation_view_view.dart';

import '../../onboarding/controllers/onboarding_controller.dart';

class Intro1View extends GetView {
  const Intro1View({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //define colors to use here
    Color page1Blue = Color.fromARGB(255, 84, 144, 248);
    return SafeArea(
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: MediaQuery.of(context).size.height * 0.0195),
            Container(
              height: MediaQuery.of(context).size.height * 0.45,
              padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.01),
              child: Image.asset('assets/onboarding.png'),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.0195),
            Padding(
              padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.05,
                right: MediaQuery.of(context).size.width * 0.05,
                top: 0,
                bottom: MediaQuery.of(context).size.width * 0.05,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.0255,
                    vertical: MediaQuery.of(context).size.height * 0.00195),
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
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.height * 0.0085),
              child: Text(
                'Connect your Google calendar and improve your daily routine',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                    textStyle: const TextStyle(
                  fontWeight: FontWeight.w300,
                  color: Colors.black,
                  fontSize: 17,
                )),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          ],
        ),
      ),
    );
  }
}
