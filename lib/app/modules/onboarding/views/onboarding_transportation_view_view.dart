import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timo_test/app/modules/onboarding/views/preptime_view.dart';

import '../controllers/onboarding_controller.dart';

import 'package:flutter/material.dart';

import '../../login/views/login_view.dart';
//import '../../login/bindings/login_binding.dart';
import '../../../routes/app_pages.dart';
//import '../../../routes/app_routes.dart';
//import '../modules/login/views/login_view.dart';

class TransportationView extends GetView<OnboardingController> {
  const TransportationView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    OnboardingController control = OnboardingController();
    double _value = control.getProgressSliderValue();
    const IconData directions_bike =
        IconData(0xe1d2, fontFamily: 'MaterialIcons');
    const IconData directions_walk =
        IconData(0xe1e1, fontFamily: 'MaterialIcons');
    const IconData directions_bus_sharp =
        IconData(0xe8d2, fontFamily: 'MaterialIcons');
    const IconData train = IconData(0xe675, fontFamily: 'MaterialIcons');
    const IconData directions_car =
        IconData(0xe1d7, fontFamily: 'MaterialIcons');
    const IconData attach_money = IconData(0xe0b2, fontFamily: 'MaterialIcons');
    final ButtonStyle style = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20),
      backgroundColor:
          const Color.fromARGB(255, 112, 180, 252), // Background color
      fixedSize: const Size(
        300,
        70,
      ),
    );

    var walkIsPressed = false.obs;
    var bikeIsPressed = false.obs;
    var busIsPressed = false.obs;
    var trainIsPressed = false.obs;
    var carIsPressed = false.obs;
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
            const SizedBox(height: 70),
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
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SizedBox(
                      width: 150.00,
                      height: 150.00,
                      child: Obx(
                        () => ElevatedButton.icon(
                          onPressed: () {
                            walkIsPressed.value = !(walkIsPressed.value);
                            print("Walking Selected");
                            control.selectTransportation("Walk");
                          },
                          style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                            backgroundColor: walkIsPressed.value
                                ? const Color.fromARGB(255, 52, 120, 202)
                                : const Color.fromARGB(255, 112, 180, 252),
                          ),
                          icon: const Icon(directions_walk,
                              size: 100, color: Colors.black),
                          label: Text(''),
                        ),
                      )),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [],
            ),
            const Expanded(child: SizedBox(height: 10)),
            SizedBox(
              width: 300,
              height: 50,
              child: ElevatedButton(
                  style: style,
                  onPressed: () {
                    // Get.to(TransportationView());
                    // Get.put(OnboardingController());
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
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}

class CustomButtonShape extends RoundedRectangleBorder {
  CustomButtonShape() : super();

  @override
  EdgeInsetsGeometry getDimensions(Rect rect) {
    return EdgeInsets.all(10);
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return getOuterPath(rect, textDirection: textDirection)!;
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    final radius = Radius.circular(rect.width / 2);
    return Path()
      ..addRRect(RRect.fromRectAndRadius(rect, radius))
      ..addRRect(RRect.fromRectAndRadius(rect.deflate(10), radius));
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    final radius = Radius.circular(rect.width / 2);
    final Paint paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    canvas.drawRRect(RRect.fromRectAndRadius(rect.deflate(10), radius), paint);
  }
}
