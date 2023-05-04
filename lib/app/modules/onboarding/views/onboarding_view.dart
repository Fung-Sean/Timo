import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:timo_test/app/modules/onboarding/views/onboarding_transportation_view_view.dart';

import '../controllers/onboarding_controller.dart';

import 'package:flutter/material.dart';

import '../../login/views/login_view.dart';
//import '../../login/bindings/login_binding.dart';
import '../../../routes/app_pages.dart';
import '../modules/onboarding/views/onboarding_transportation_view_view.dart';
//import '../../../routes/app_routes.dart';
//import '../modules/login/views/login_view.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    double value = OnboardingController().getProgressSliderValue();
    final ButtonStyle style = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20),
      backgroundColor:
          const Color.fromARGB(255, 112, 180, 252), // Background color
      fixedSize: const Size(
        300,
        70,
      ),
    );

    return Scaffold(
      // appBar: AppBar(
      //   //title: const Text('TIMO'),
      //   centerTitle: true,
      //   backgroundColor: Color.fromARGB(150, 110, 177, 255),
      // ),
      body: Center(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 200),
            // ignore: prefer_const_constructors
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Welcome To Timo!',
                style: TextStyle(
                    fontSize: 60,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                'Before we begin, we would like to customize your experience.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 25),
              ),
            ),
            Expanded(
                child:
                    SizedBox(height: MediaQuery.of(context).size.height * 10)),
            ElevatedButton(
                style: style,
                onPressed: () {
                  Get.to(const TransportationView());
                  Get.put(OnboardingController());
                },
                child: const Text('Continue')),
            SizedBox(height: MediaQuery.of(context).size.height * .7),
          ],
        ),
      ),
    );
  }
}
