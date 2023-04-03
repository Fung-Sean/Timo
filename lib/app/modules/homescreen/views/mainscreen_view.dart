import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/homescreen_controller.dart';
import 'package:timo_test/app/modules/homescreen/views/homescreen_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

//define some colors to be used on the widgets
Color darkBlue = const Color.fromARGB(255, 53, 146, 255);
Color lightBlue = const Color.fromARGB(255, 170, 207, 251);

Color darkGreen = const Color.fromARGB(255, 0, 201, 153);
Color lightGreen = const Color.fromARGB(255, 148, 229, 210);

Color darkOrange = const Color.fromARGB(255, 237, 123, 87);
Color lightOrange = const Color.fromARGB(255, 243, 198, 183);

class MainScreenView extends GetView<HomescreenController> {
  const MainScreenView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 20),
            //here we have some headers indicating the event name and location
            Row(
              children: [
                //this sized box gives us a little bit of for the event name and
                //location, which were originally pressed up against the left side of the
                //screen.
                const SizedBox(width: 25),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      controller.eventName,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                          textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 25,
                      )),
                    ),
                    Text(
                      "at " + controller.address,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                          textStyle: const TextStyle(
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                        fontSize: 17,
                      )),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 20),
            SizedBox(
              width: 350,
              height: 350,
              child: Stack(
                  alignment: Alignment.center,
                  fit: StackFit.expand,
                  children: <Widget>[
                    Obx(() => CircularProgressIndicator(
                          value: controller.proportionOfTimer.value,
                          strokeWidth: 17,
                          color: darkBlue,
                          backgroundColor: lightBlue,
                        )),
                    Positioned.fill(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Get Ready!',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                                textStyle: const TextStyle(
                              fontWeight: FontWeight.normal,
                              color: Colors.black,
                              fontSize: 30,
                            )),
                          ),
                          Obx(
                            () => Text(
                              '${controller.time.value}',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                  textStyle: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: const Color.fromARGB(255, 64, 149, 249),
                                fontSize: 45,
                              )),
                            ),
                          ),
                          Obx(() => Text(
                                'Leave at ' + controller.arriveTime.value,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.inter(
                                    textStyle: const TextStyle(
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black,
                                  fontSize: 30,
                                )),
                              )),
                        ],
                      ),
                    ),
                  ]),
            ),
            const SizedBox(height: 70),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    // height: 40,
                    // padding: const EdgeInsets.all(4.0),
                    // child: Image.asset('assets/toothbrush.png', color: darkBlue),
                    ),
                HorizontalBarWidget(
                  firstSectionValue: 10,
                  secondSectionValue: 20,
                  thirdSectionValue: 30,
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
                //style: style,
                onPressed: () {
                  controller.updateArrival();
                  controller.startTimer(900);
                },
                child: const Text('Start Timer')),
          ],
        ),
      ),
    );
  }
}

class HorizontalBarWidget extends StatelessWidget {
  final int firstSectionValue;
  final int secondSectionValue;
  final int thirdSectionValue;

  HorizontalBarWidget({
    required this.firstSectionValue,
    required this.secondSectionValue,
    required this.thirdSectionValue,
  });

  @override
  Widget build(BuildContext context) {
    final totalValue =
        firstSectionValue + secondSectionValue + thirdSectionValue;
    final firstSectionWidth = firstSectionValue.toDouble() / totalValue;
    final secondSectionWidth = secondSectionValue.toDouble() / totalValue;
    final thirdSectionWidth = thirdSectionValue.toDouble() / totalValue;

    return SizedBox(
      height: 50,
      child: Row(
        children: [
          Column(
            children: [
              SizedBox(
                width: firstSectionWidth * 300,
                height: 20,
                child: Container(color: lightBlue),
              ),
              Text(
                firstSectionValue.toString(),
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                    textStyle: const TextStyle(
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                  fontSize: 20,
                )),
              ),
            ],
          ),
          // SizedBox(
          //   width: secondSectionWidth * 300,
          //   child: Container(color: lightGreen),
          // ),
          // SizedBox(
          //   width: thirdSectionWidth * 300,
          //   child: Container(color: lightOrange),
          // ),
        ],
      ),
    );
  }
}
