import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:timo_test/app/modules/onboarding/views/onboarding_transportation_view_view.dart';
import 'package:timo_test/app/modules/onboarding/views/preptime_view.dart';

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
    control.setProgressSliderValue(33);
    double _value = control.getProgressSliderValue();

    List<int> values = [1, 2, 3, 4, 5];

    RxInt numMinutes = 0.obs;

    final ButtonStyle style = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20),
      backgroundColor:
          const Color.fromARGB(255, 112, 180, 252), // Background color
      fixedSize: const Size(
        150,
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
            const SizedBox(height: 40),
            Container(
              width: double.maxFinite,
              child: Slider(
                min: 0.0,
                max: 100.0,
                value: _value,
                onChanged: (value) {
                  value = control.getProgressSliderValue();
                },
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                'How long does it take for you to prepare for your first event of the day?',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 25),
              ),
            ),
            const SizedBox(height: 50),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Minutes',
                style: TextStyle(
                    fontSize: 30,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    // minutes wheel
                    child: Container(
                      width: 70,
                      child: ListWheelScrollView.useDelegate(
                        onSelectedItemChanged: (value) =>
                            numMinutes.value = value,
                        itemExtent: 50,
                        perspective: 0.005,
                        diameterRatio: 1.2,
                        physics: const FixedExtentScrollPhysics(),
                        childDelegate: ListWheelChildBuilderDelegate(
                          childCount: 100,
                          builder: (context, index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 5.0),
                              child: Center(
                                  child: Obx(
                                () => Text(
                                  index < 10
                                      ? '0' + index.toString()
                                      : index.toString(),
                                  style: TextStyle(
                                    fontSize: 40,
                                    color: index == numMinutes.value
                                        ? Color.fromARGB(255, 0, 0, 0)
                                        : Color.fromARGB(255, 137, 137, 137),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Expanded(child: SizedBox(height: 10)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ElevatedButton(
                      style: style,
                      onPressed: () {
                        Get.to(const TransportationView());
                        Get.put(OnboardingController());
                      },
                      child: const Text('Back')),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ElevatedButton(
                      style: style,
                      onPressed: () {
                        OnboardingController()
                            .setMinutesToGetReady(numMinutes.value);
                        Get.to(LoginView());
                        Get.put(LoginController());
                      },
                      child: const Text('Continue')),
                ),
              ],
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
