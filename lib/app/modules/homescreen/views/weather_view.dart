import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:googleapis/servicemanagement/v1.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
//import 'package:weather/weather.dart';
import 'package:http/http.dart' as http;

//import '../controllers/weatherpage_controller.dart';
import '../controllers/homescreen_controller.dart';
import '../../weatherpage/controllers/weatherpage_controller.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/instance_manager.dart';
import './mainscreen_view.dart';

class WeatherView extends GetView<HomescreenController> {
  WeatherView({Key? key}) : super(key: key);

  String currentDate = DateFormat("EEEE\nMMMM dd, yyyy").format(DateTime.now());

  //final style_date = TextStyle(fontSize: 24, fontWeight: FontWeight.w300);
  final style_time = TextStyle(fontSize: 18, fontWeight: FontWeight.w300);
  final style_temp = TextStyle(
      fontSize: 48,
      fontWeight: FontWeight.w500,
      color: Color.fromARGB(255, 53, 147, 255));

  final style_description = TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w400,
      color: Color.fromARGB(255, 53, 147, 255));

  final style_tip = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: Color.fromARGB(255, 53, 147, 255));

  //final _weatherpagecontroller = Get.find<WeatherpageController>();
  final _weatherpagecontroller = Get.put(WeatherpageController());

  //for rounding up main temperature
  static int roundMainTemp(double t) {
    return t.ceil();
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = new DateTime.now();

    //String currentTime = "${now.hour}:${now.minute} PM (Current):";
    String hour =
        now.hour > 12 ? (now.hour - 12).toString() : now.hour.toString();
    String minute = now.minute < 10 ? '0${now.minute}' : now.minute.toString();
    String amPm = now.hour >= 12 ? "PM" : "AM";
    String currentTime = "$hour:$minute $amPm (Current):";

    //String dt = DateFormat("EEEE\nMMMM dd, yyyy").format(DateTime.now());

    final style_date = TextStyle(fontSize: 24, fontWeight: FontWeight.w300);

    //add tips if it's raining

    //define some colors to be used on the widgets
    Color darkBlue = const Color.fromARGB(255, 64, 149, 249);
    Color lightBlue = const Color.fromARGB(255, 170, 207, 251);

    final HomescreenController controller = Get.put(HomescreenController());
    final WeatherpageController weatherpageController =
        Get.put(WeatherpageController());

    //lets define some variables to give us the proportion of each segment
    int firstSectionValue = (controller.getReadyTime.value / 60).toInt();
    int secondSectionValue = (controller.transportTime.value / 60).toInt();
    int thirdSectionValue = (controller.eventDuration.value).toInt();

    final totalValue =
        firstSectionValue + secondSectionValue + thirdSectionValue;
    final firstSectionWidth = firstSectionValue.toDouble() / totalValue;
    final secondSectionWidth = secondSectionValue.toDouble() / totalValue;
    final thirdSectionWidth = thirdSectionValue.toDouble() / totalValue;

    return Scaffold(
      body: Center(
          child: FutureBuilder(
        future: weatherpageController.getWeather(),
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

          double largestSection = 0;
          double largestSectionValue = 0;
          if (firstSectionWidth >= secondSectionWidth &&
              firstSectionWidth >= thirdSectionWidth) {
            largestSection = 1;
            largestSectionValue = firstSectionWidth as double;
          } else if (secondSectionWidth >= secondSectionWidth &&
              secondSectionWidth >= thirdSectionWidth) {
            largestSection = 2;
            largestSectionValue = secondSectionWidth as double;
          } else {
            largestSection = 3;
            largestSectionValue = thirdSectionWidth as double;
          }
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
                            "at " + controller.shortenedLocation.value,
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

              // const SizedBox(height: 40),
              //   SizedBox(
              //     width: MediaQuery.of(context).size.height * 0.369,
              //     height: MediaQuery.of(context).size.height * 0.369,
              //     child: Stack(
              //         alignment: Alignment.center,
              //         fit: StackFit.expand,
              //         children: <Widget>[
              //           Transform.rotate(
              //             angle: 0,
              //             child: SizedBox(
              //               height: 50,
              //               width: 50,
              //               child: Obx(() => CircularProgressIndicator(
              //                     value: 1.0 - controller.proportionOfTimer.value,
              //                     strokeWidth: 17,
              //                     color:
              //                         controller.currentState == 'beforeGetReady'
              //                             ? beforeGetReadyAbove
              //                             : controller.currentState == 'getReady'
              //                                 ? getReadyAbove
              //                                 : transportationAbove,
              //                     backgroundColor:
              //                         controller.currentState == 'beforeGetReady'
              //                             ? beforeGetReadyBackground
              //                             : controller.currentState == 'getReady'
              //                                 ? getReadyBackground
              //                                 : transportationBackground,
              //                   )),
              //             ),
              //           ),

              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.height * 0.04),
                child: Column(
                  children: <Widget>[
                    Text(
                      currentTime,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(textStyle: style_date),
                    ),
                    SizedBox(height: 20),
                    Image.asset(
                      'assets/Cloud.png',
                      width: 100,
                      height: 100,
                    ),
                    SizedBox(height: 20),
                    Text(
                      '${(_weatherpagecontroller.futureWeather[0].temp * 1.8 + 32).round()}°F',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: controller.currentState == 'beforeGetReady'
                              ? Colors.black
                              : controller.currentState == 'getReady'
                                  ? getReadyBackground
                                  : transportationBackground,
                          fontSize: 45,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.lightBlue),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        "It's slightly chilly today",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          textStyle: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 20,
                            color: Colors.lightBlue,
                          ),
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Obx(
              //   () => Text(
              //       controller.belowTimer.value +
              //           controller.startAtString.value,
              //       textAlign: TextAlign.center,
              //       style: GoogleFonts.inter(
              //           textStyle: const TextStyle(
              //         fontWeight: FontWeight.normal,
              //         color: Colors.black,
              //         fontSize: 30,
              //       ))),
              // ),
              //       ]),
              // ),
              const SizedBox(height: 10),
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
              SizedBox(height: MediaQuery.of(context).size.height * 0.004),
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
                                  fontSize: 17,
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
                            padding: const EdgeInsets.symmetric(
                                vertical: 4.0, horizontal: 2.0),
                            child: Text(
                                controller.startTravelString.value +
                                    "-" +
                                    controller.startEventString.value,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.inter(
                                    textStyle: const TextStyle(
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black,
                                  fontSize: 17,
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
                                  fontSize: 17,
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
                          width: (firstSectionWidth / largestSectionValue) *
                              MediaQuery.of(context).size.width *
                              0.4,
                          height: 20,
                          child: Container(color: lightBlue),
                        ),
                      ),
                      //comment
                      SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: SizedBox(
                          width: (secondSectionWidth / largestSectionValue) *
                              MediaQuery.of(context).size.width *
                              0.4,
                          height: 20,
                          child: Container(color: lightGreen),
                        ),
                      ),
                      SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: SizedBox(
                          width: (thirdSectionWidth / largestSectionValue) *
                              MediaQuery.of(context).size.width *
                              0.4,
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

  //static var firstSectionWidth;

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
                width: firstSectionWidth * 325,
                height: 20,
                child: Container(color: lightBlue),
              ),
              Text(
                firstSectionValue.toString() + "min ",
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
                width: secondSectionWidth * 325,
                height: 20,
                child: Container(color: lightGreen),
              ),
              Text(
                secondSectionValue.toString() + "min ",
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
                width: thirdSectionWidth * 325,
                height: 20,
                child: Container(color: lightOrange),
              ),
              Text(
                thirdSectionValue.toString() + "min ",
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
