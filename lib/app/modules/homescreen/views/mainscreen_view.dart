import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controllers/homescreen_controller.dart';
import 'package:timo_test/app/modules/homescreen/views/homescreen_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;

//define some colors to be used on the widgets
Color darkBlue = const Color.fromARGB(255, 53, 146, 255);
Color lightBlue = const Color.fromARGB(255, 170, 207, 251);

Color darkGreen = const Color.fromARGB(255, 0, 201, 153);
Color lightGreen = const Color.fromARGB(255, 148, 229, 210);

Color darkOrange = const Color.fromARGB(255, 237, 123, 87);
Color lightOrange = const Color.fromARGB(255, 243, 198, 183);

//Colors for beforeGetReady
Color beforeGetReadyBackground = const Color.fromARGB(217, 217, 217, 217);
Color beforeGetReadyAbove = const Color.fromARGB(239, 239, 239, 239);

//Colors for getReady
Color getReadyBackground = const Color.fromARGB(255, 53, 146, 255);
Color getReadyAbove = const Color.fromARGB(255, 170, 207, 251);

//Colors for walking
Color transportationBackground = const Color.fromARGB(255, 0, 201, 153);
Color transportationAbove = const Color.fromARGB(255, 223, 243, 239);

class MainScreenView extends GetView<HomescreenController> {
  const MainScreenView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Color timerBackground = controller.currentState == 'beforeGetReady'
        ? beforeGetReadyBackground
        : controller.currentState == 'getReady'
            ? getReadyBackground
            : transportationBackground;

    Color timerAbove = controller.currentState == 'beforeGetReady'
        ? beforeGetReadyAbove
        : controller.currentState == 'getReady'
            ? getReadyAbove
            : transportationAbove;

    bool isNotRunning = controller.isClosed;
    controller.isWidgetRunning = isNotRunning;
    return Scaffold(
      body: Center(
          child: FutureBuilder(
        future: controller.initialize(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          //lets define some variables to give us the proportion of each segment
          int firstSectionValue = (controller.getReadyTime.value / 60).toInt();
          int secondSectionValue =
              (controller.transportTime.value / 60).toInt();
          int thirdSectionValue = (controller.eventDuration.value).toInt();

          final totalValue =
              firstSectionValue + secondSectionValue + thirdSectionValue;
          final firstSectionWidth = firstSectionValue.toDouble() / totalValue;
          final secondSectionWidth = secondSectionValue.toDouble() / totalValue;
          final thirdSectionWidth = thirdSectionValue.toDouble() / totalValue;

          const IconData directions_walk =
              IconData(0xe1e1, fontFamily: 'MaterialIcons');

          const IconData calendar_today =
              IconData(0xe122, fontFamily: 'MaterialIcons');

          return Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: MediaQuery.of(context).size.height * 0.04),
              //here we have some headers indicating the event name and location

              Row(children: [
                const SizedBox(width: 30),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(
                        () => Text(controller.title.value,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                                textStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 28,
                            ))),
                      ),
                      Obx(
                        () => InkWell(
                          child: Text(
                            "at " + controller.location.value,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                                textStyle: const TextStyle(
                              fontWeight: FontWeight.normal,
                              color: Colors.black,
                              fontSize: 17,
                            )),
                            overflow: TextOverflow.visible,
                            softWrap: true,
                          ),
                          onTap: () => launchURL(
                              'https://www.google.com/maps/place/' +
                                  controller.location.value),
                        ),
                      ),
                    ],
                  ),
                ),
              ]),

              const SizedBox(height: 40),
              SizedBox(
                width: MediaQuery.of(context).size.height * 0.369,
                height: MediaQuery.of(context).size.height * 0.369,
                child: Stack(
                    alignment: Alignment.center,
                    fit: StackFit.expand,
                    children: <Widget>[
                      Transform.rotate(
                        angle: 0,
                        child: SizedBox(
                          height: 50,
                          width: 50,
                          child: Obx(() => CircularProgressIndicator(
                                value: 1.0 - controller.proportionOfTimer.value,
                                strokeWidth: 17,
                                color:
                                    controller.currentState == 'beforeGetReady'
                                        ? beforeGetReadyAbove
                                        : controller.currentState == 'getReady'
                                            ? getReadyAbove
                                            : transportationAbove,
                                backgroundColor:
                                    controller.currentState == 'beforeGetReady'
                                        ? beforeGetReadyBackground
                                        : controller.currentState == 'getReady'
                                            ? getReadyBackground
                                            : transportationBackground,
                              )),
                        ),
                      ),
                      Positioned.fill(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Obx(() => Text(
                                  controller.aboveTimer.value,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.inter(
                                      textStyle: const TextStyle(
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black,
                                    fontSize: 30,
                                  )),
                                )),
                            Obx(
                              () => Text(
                                  //this shows the time inside the circle
                                  controller.timeDisplay.value,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.inter(
                                      textStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: controller.currentState ==
                                            'beforeGetReady'
                                        ? beforeGetReadyBackground
                                        : controller.currentState == 'getReady'
                                            ? getReadyBackground
                                            : transportationBackground,
                                    //color: const Color.fromARGB(66, 66, 66, 66),
                                    fontSize: 45,
                                  ))),
                            ),
                            Obx(
                              () => Text(
                                  controller.belowTimer.value +
                                      controller.startAtString.value,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.inter(
                                      textStyle: const TextStyle(
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black,
                                    fontSize: 30,
                                  ))),
                            ),
                          ],
                        ),
                      ),
                    ]),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      // height: 40,
                      // padding: const EdgeInsets.all(4.0),
                      // child: Image.asset('assets/toothbrush.png', color: darkBlue),
                      ),
                  Obx(() => HorizontalBarWidget(
                        firstSectionValue:
                            (controller.getReadyTime.value / 60).toInt(),
                        secondSectionValue:
                            (controller.transportTime.value / 60).toInt(),
                        thirdSectionValue:
                            (controller.eventDuration.value).toInt(),
                      )),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(width: 5),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Container(
                              height: 35,
                              padding: const EdgeInsets.all(4.0),
                              child: Image.asset('assets/toothbrush.png',
                                  color: lightBlue),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(
                                controller.startAtString.value +
                                    "-" +
                                    controller.startTravelString.value,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.inter(
                                    textStyle: const TextStyle(
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black,
                                  fontSize: 20,
                                ))),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(width: 5),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Icon(directions_walk,
                                size: 35, color: lightGreen),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(
                                controller.startTravelString.value +
                                    "-" +
                                    controller.startEventString.value,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.inter(
                                    textStyle: const TextStyle(
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black,
                                  fontSize: 20,
                                ))),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(width: 5),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Icon(calendar_today,
                                size: 35, color: lightOrange),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(
                                controller.startEventString.value +
                                    "-" +
                                    controller.endEventString.value,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.inter(
                                    textStyle: const TextStyle(
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black,
                                  fontSize: 20,
                                ))),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: SizedBox(
                          width: firstSectionWidth * 200,
                          height: 20,
                          child: Container(color: lightBlue),
                        ),
                      ),
                      SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: SizedBox(
                          width: secondSectionWidth * 200,
                          height: 20,
                          child: Container(color: lightGreen),
                        ),
                      ),
                      SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: SizedBox(
                          width: thirdSectionWidth * 200,
                          height: 20,
                          child: Container(color: lightOrange),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          );
        },
      )),
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
                width: firstSectionWidth * 350,
                height: 20,
                child: Container(color: lightBlue),
              ),
              Text(
                firstSectionValue.toString() + " min",
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                    textStyle: const TextStyle(
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                  fontSize: 15,
                )),
              ),
            ],
          ),
          Column(
            children: [
              SizedBox(
                width: secondSectionWidth * 350,
                height: 20,
                child: Container(color: lightGreen),
              ),
              Text(
                secondSectionValue.toString() + " min",
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                    textStyle: const TextStyle(
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                  fontSize: 15,
                )),
              ),
            ],
          ),
          Column(
            children: [
              SizedBox(
                width: thirdSectionWidth * 350,
                height: 20,
                child: Container(color: lightOrange),
              ),
              Text(
                thirdSectionValue.toString() + " min",
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                    textStyle: const TextStyle(
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                  fontSize: 15,
                )),
                //TODO: fix min alignment so that disproportionate times
                //do not create gaps between rectangles
              ),
            ],
          ),
        ],
      ),
    );
  }
}

launchURL(String url) async {
  //String url = 'https://flutter.io';
  final uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri);
  } else {
    throw 'Could not launch $url';
  }
}
