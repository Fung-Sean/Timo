import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:googleapis/servicemanagement/v1.dart';

//new libraries for weather api and geolocator
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather/weather.dart';
import 'package:http/http.dart' as http;

import '../controllers/weather_controller.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/instance_manager.dart';

class WeatherView extends GetView<WeatherController> {
  WeatherView({Key? key}) : super(key: key);

  String dt = DateFormat("EEEE\nMMMM dd, yyyy").format(DateTime.now());

  final style_date = TextStyle(fontSize: 24, fontWeight: FontWeight.w300);
  final style_temp = TextStyle(fontSize: 48, fontWeight: FontWeight.w500);
  final style_temp_hl = TextStyle(fontSize: 16, fontWeight: FontWeight.w300);

  //WeatherFactory wf = WeatherFactory('5ef0b262f16659ab86bd672617ca3c51');
  //Weather w = wf.currentWeatherByLocation(lat, lon);
  final _weathercontroller = Get.find<WeatherController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Main',
              style: TextStyle(
                color: Color.fromARGB(0, 0, 0, 0),
              )),
          centerTitle: true,
          backgroundColor: Color.fromARGB(255, 255, 255, 255),
        ),
        body: Obx(() => _weathercontroller.isLoading.value
            ? Center(
                child: Column(
                children: <Widget>[
                  const SizedBox(height: 80),
                  Text(dt,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(textStyle: style_date)),
                  const SizedBox(height: 100),
                  Text('${_weathercontroller.futureWeather[0].temp}°C',
                      style: GoogleFonts.inter(textStyle: style_temp)),
                  const SizedBox(height: 10),
                  Text(
                      'H: ${_weathercontroller.futureWeather[0].temp_max}°C  L: ${_weathercontroller.futureWeather[0].temp_min}°C',
                      style: GoogleFonts.inter(textStyle: style_temp_hl)),
                  // ignore: unnecessary_string_interpolations
                  Text(
                      'Description: ${_weathercontroller.futureWeather[0].w_description}',
                      style: GoogleFonts.inter(textStyle: style_temp_hl))
                ],
              ))
            : const CircularProgressIndicator()));
  }
}
