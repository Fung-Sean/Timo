import 'package:flutter/material.dart';

import 'package:get/get.dart';

//new libraries for weather api and geolocator
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather/weather.dart';

import '../controllers/weather_controller.dart';

class WeatherView extends GetView<WeatherController> {
  const WeatherView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String dt = DateFormat("EEEE\n MMMM dd, yyyy").format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Main',
            style: TextStyle(
              color: Color.fromARGB(0, 0, 0, 0),
            )),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
      ),
      body: Center(
        child: Text(dt, style: TextStyle(fontSize: 30)),
      ),
    );
  }
}
