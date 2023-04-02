import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/homescreen_controller.dart';
import 'package:timo_test/app/modules/homescreen/views/homescreen_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class MainScreenView extends GetView<HomescreenController> {
  const MainScreenView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    //define some colors to be used on the widgets
    Color darkBlue = const Color.fromARGB(255, 64, 149, 249);
    Color lightBlue = const Color.fromARGB(255, 227, 237, 246);

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
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Container(
                      height: 40,
                      padding: const EdgeInsets.all(4.0),
                      child:
                          Image.asset('assets/toothbrush.png', color: darkBlue),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: SizedBox(
                        width: 110,
                        height: 110,
                        child: Stack(
                            alignment: Alignment.center,
                            fit: StackFit.expand,
                            children: <Widget>[
                              CircularProgressIndicator(
                                value: controller.readyProportion,
                                strokeWidth: 10,
                                color: darkBlue,
                                backgroundColor: lightBlue,
                              ),
                              Positioned.fill(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '${controller.readyTime}',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.inter(
                                          textStyle: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: const Color.fromARGB(
                                            255, 64, 149, 249),
                                        fontSize: 20,
                                      )),
                                    ),
                                    Text(
                                      'min',
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
                              ),
                            ]),
                      ),
                    ),
                  ],
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