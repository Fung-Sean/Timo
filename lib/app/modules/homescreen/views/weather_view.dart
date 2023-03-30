import 'package:flutter/material.dart';

import 'package:get/get.dart';

class WeatherView extends GetView {
  const WeatherView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WeatherView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'WeatherView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
