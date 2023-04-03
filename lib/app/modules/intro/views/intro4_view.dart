import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:timo_test/app/modules/login/controllers/login_controller.dart';

import '../../login/views/login_view.dart';
import '../../../routes/app_pages.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controllers/intro_controller.dart';
import 'intro5_view.dart';

class Intro4View extends GetView<IntroController> {
  const Intro4View({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    GoogleSignIn _googleSignIn = GoogleSignIn();
    final ButtonStyle style =
        ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));

    Uri linkURL = Uri(
        scheme: 'https',
        host: 'youtube.com',
        path: '/feed/subscriptions',
        fragment: '');

    return Scaffold(
      appBar: AppBar(
        //title: const Text('TIMO'),
        centerTitle: true,
        backgroundColor: Color.fromARGB(246, 0, 0, 0),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 100),
            Container(
              height: 350,
              width: 350,
              child: Image.asset('assets/timo.png'),
            ),
            Text(
              '*insert tagline*',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                  textStyle: const TextStyle(
                fontWeight: FontWeight.w300,
                color: Color.fromARGB(255, 64, 149, 249),
                fontSize: 22,
              )),
            ),
            const SizedBox(height: 150),
            SizedBox(
              width: 300,
              height: 50,
              child: ElevatedButton(
                  style: style,
                  onPressed: () async {
                    await controller.getGoogleEventsData();
                    controller.appendToLocalStorage();
                    //Get.to(const Intro5View());
                    Get.put(IntroController());
                  },
                  child: const Text('Log in with Google')),
            ),
            const SizedBox(height: 20),
            InkWell(
                child: Text(
                  'Sign up for a Google account',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                      textStyle: const TextStyle(
                    fontWeight: FontWeight.w300,
                    color: Color.fromARGB(255, 64, 149, 249),
                    fontSize: 17,
                  )),
                ),
                onTap: () => launchUrl(linkURL)),
          ],
        ),
      ),
    );
  }
}
