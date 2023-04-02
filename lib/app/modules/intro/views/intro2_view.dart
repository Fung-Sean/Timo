import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class Intro2View extends GetView {
  const Intro2View({Key? key}) : super(key: key);
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
              child: Image.asset('assets/Mario.png'),
            ),
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Text(
                'Have everything in one place',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                    textStyle: const TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Color.fromARGB(255, 48, 202, 154),
                  fontSize: 45,
                )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Text(
                'Everything you need, from weather to transportation, to prepare for your day',
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
