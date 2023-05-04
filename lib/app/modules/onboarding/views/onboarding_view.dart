import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timo_test/app/modules/onboarding/views/onboarding_transportation_view_view.dart';
import '../controllers/onboarding_controller.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20),
      backgroundColor: Color.fromARGB(255, 112, 180, 252), // Background color
      fixedSize: const Size(300, 70),
    );

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 200),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Welcome To Timo!',
                style: TextStyle(
                  fontSize: 60,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: const Text(
                'Before we begin, we would like to customize your experience.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 25),
              ),
            ),
            const Spacer(),
            SizedBox(
              height: MediaQuery.of(context).size.height * .1,
            ),
            ElevatedButton(
              style: style,
              onPressed: () {
                Get.to(const TransportationView());
                Get.put(OnboardingController());
              },
              child: const Text('Continue'),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * .2),
          ],
        ),
      ),
    );
  }
}
