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
      fontSize: 20,
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
    String currentTime = "${now.hour}:${now.minute} (Current):";
    //add tips if it's raining

    //find another API for weather forecasting!! OR SCRAP WEATHER FORECAST, and replace the bottom part of ring with the tip

    //define some colors to be used on the widgets
    Color darkBlue = const Color.fromARGB(255, 64, 149, 249);
    Color lightBlue = const Color.fromARGB(255, 227, 237, 246);

    return Scaffold(
      body: Center(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 100),
            //here we have some headers indicating the event name and location
            Row(
              children: [
                //this sized box gives us a little bit of for the event name and
                //location, which were originally pressed up against the left side of the
                //screen.
                const SizedBox(width: 25),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  //children: [
                  // Text(
                  //   controller.eventName,
                  //   textAlign: TextAlign.center,
                  //   style: GoogleFonts.inter(
                  //       textStyle: const TextStyle(
                  //     fontWeight: FontWeight.bold,
                  //     color: Colors.black,
                  //     fontSize: 25,
                  //   )),
                  // ),
                  //],
                ),
              ],
            ),

            const SizedBox(height: 20),
            SizedBox(
              width: 300,
              height: 300,
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
                          Text(currentTime,
                              style: GoogleFonts.inter(textStyle: style_time)),
                          Text(
                              '${roundMainTemp(_weatherpagecontroller.futureWeather[0].temp)}°C',
                              style: GoogleFonts.inter(textStyle: style_temp)),
                          Text(
                              '${_weatherpagecontroller.futureWeather[0].w_description}',
                              style: GoogleFonts.inter(
                                  textStyle: style_description)),
                          //Text('${position}')
                          // Text(
                          //     'H: ${_weatherpagecontroller.futureWeather[0].temp_max}°C  L: ${_weatherpagecontroller.futureWeather[0].temp_min}°C',
                          //     style: GoogleFonts.inter(textStyle: style_time)),
                        ],
                      ),
                    ),
                  ]),
            ),

            //const SizedBox(height: 0),

            const SizedBox(height: 120),

            Container(
                width: 250,
                height: 100,
                decoration: BoxDecoration(
                    border: Border.all(
                        color: Color.fromARGB(255, 53, 147, 255), width: 2),
                    borderRadius: BorderRadius.circular(12)),
                child: Center(
                    child: Text("Bring raincoat \n or umbrella",
                        style: GoogleFonts.inter(textStyle: style_tip))))
          ],
        ),
      ),
    );
  }
}
