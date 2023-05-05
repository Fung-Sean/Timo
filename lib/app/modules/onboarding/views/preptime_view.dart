import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timo_test/app/modules/onboarding/views/early_arrive_view.dart';
import 'package:timo_test/app/modules/onboarding/views/onboarding_transportation_view_view.dart';
import 'package:timo_test/app/modules/onboarding/views/preptime_view.dart';

import '../../homescreen/controllers/homescreen_controller.dart';
import '../../homescreen/views/homescreen_view.dart';
import '../../login/controllers/login_controller.dart';
import '../controllers/onboarding_controller.dart';

import 'package:flutter/material.dart';

import '../../login/views/login_view.dart';
//import '../../login/bindings/login_binding.dart';
import '../../../routes/app_pages.dart';
import 'package:flutter/cupertino.dart';
import 'minutes.dart';

//import '../../../routes/app_routes.dart';
//import '../modules/login/views/login_view.dart';

class PreptimeView extends GetView<OnboardingController> {
  const PreptimeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    OnboardingController control = OnboardingController();
    control.setProgressSliderValue(66);
    double _value = control.getProgressSliderValue();

    List<int> values = [1, 2, 3, 4, 5];

    RxInt numMinutes = 0.obs;
    RxInt numHours = 0.obs;

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
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  children: [
                    TextButton(
                      onPressed: () => Get.back(),
                      child: Text(
                        'Back',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.7,
                    ),
                    CircularProgressIndicator(
                      value: _value / 100,
                      backgroundColor: Colors.grey,
                      strokeWidth: 5,
                    ),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(50),
              child: Text(
                'How long does it take for you get ready for your first event?',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 25),
              ),
            ),
            const SizedBox(height: 50),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // hours wheel
                  Container(
                    width: 80, // narrower container
                    padding: const EdgeInsets.symmetric(
                        horizontal: 5), // reduced horizontal padding
                    child: ListWheelScrollView.useDelegate(
                      onSelectedItemChanged: (value) => numHours.value = value,
                      itemExtent: 50,
                      perspective: 0.005,
                      diameterRatio: 1.2,
                      physics: const FixedExtentScrollPhysics(),
                      childDelegate: ListWheelChildBuilderDelegate(
                        childCount: 24,
                        builder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 0),
                            child: Center(
                              child: Obx(
                                () => Text(
                                  index < 10
                                      ? '0' + index.toString()
                                      : index.toString(),
                                  style: TextStyle(
                                    fontSize: 40,
                                    color: index == numHours.value
                                        ? Color.fromARGB(255, 53, 146, 255)
                                        : Color.fromARGB(255, 137, 137, 137),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 30), // reduced horizontal padding
                    child: Text(
                      ':',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 112, 180, 252),
                      ),
                    ),
                  ),

                  // minutes wheel
                  Container(
                    width: 80, // narrower container
                    padding: const EdgeInsets.symmetric(
                        horizontal: 5), // reduced horizontal padding
                    child: ListWheelScrollView.useDelegate(
                      onSelectedItemChanged: (value) =>
                          numMinutes.value = value,
                      itemExtent: 50,
                      perspective: 0.005,
                      diameterRatio: 1.2,
                      physics: const FixedExtentScrollPhysics(),
                      childDelegate: ListWheelChildBuilderDelegate(
                        childCount: 60,
                        builder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 0.0),
                            child: Center(
                              child: Obx(
                                () => Text(
                                  index < 10
                                      ? '0' + index.toString()
                                      : index.toString(),
                                  style: TextStyle(
                                    fontSize: 40,
                                    color: index == numMinutes.value
                                        ? Color.fromARGB(255, 53, 146, 255)
                                        : Color.fromARGB(255, 137, 137, 137),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Expanded(child: SizedBox(height: 10)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: SizedBox(
                width: 350,
                height: 60.0,
                child: ElevatedButton(
                    onPressed: () {
                      Get.to(const EarlyArriveView());
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
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
