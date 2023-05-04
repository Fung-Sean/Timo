import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:googleapis/servicemanagement/v1.dart';

import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
//import 'package:weather/weather.dart';
import 'package:http/http.dart' as http;

import '../controllers/weatherpage_controller.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/instance_manager.dart';

class WeatherpageView extends GetView<WeatherpageController> {
  WeatherpageView({Key? key}) : super(key: key);

  String dt = DateFormat("EEEE\nMMMM dd, yyyy").format(DateTime.now());
  final style_date = TextStyle(fontSize: 24, fontWeight: FontWeight.w300);
  final style_temp = TextStyle(
      fontSize: 48,
      fontWeight: FontWeight.w500,
      color: Color.fromARGB(255, 53, 147, 255));

  //final _weatherpagecontroller = Get.find<WeatherpageController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Main',
          style: TextStyle(
            color: Color.fromARGB(0, 0, 0, 0),
          ),
        ),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
      ),
      body: FutureBuilder(
        future: controller.getWeather(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            print("Waiting for weather data!");
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            print("I am in snapshot error");
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          return Obx(
            () => Column(
              children: <Widget>[
                const SizedBox(height: 80),
                Text(
                  dt,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(textStyle: style_date),
                ),
                const SizedBox(height: 100),
                /*
                Text(
                  '${controller.futureWeather[0].temp_f}°F',
                  style: GoogleFonts.inter(textStyle: style_temp),
                ),
                */
                const SizedBox(height: 10),
                //Text(
                //    'H: ${_weathercontroller.futureWeather[0].temp_max}°C  L: ${_weathercontroller.futureWeather[0].temp_min}°C',
                //    style: GoogleFonts.inter(textStyle: style_temp_hl)),
                // ignore: unnecessary_string_interpolations
                //Text(
                //    'Description: ${_weathercontroller.futureWeather[0].w_description}',
                //    style: GoogleFonts.inter(textStyle: style_temp_hl))
              ],
            ),
          );
        },
      ),
    );
  }
}
