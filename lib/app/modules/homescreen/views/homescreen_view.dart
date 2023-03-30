import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:timo_test/app/modules/homescreen/views/homescreen_view.dart';
import 'package:timo_test/app/modules/homescreen/views/weather_view.dart';
import 'package:timo_test/app/modules/homescreen/views/mainscreen_view.dart';

class HomescreenView extends GetView {
  const HomescreenView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: PageView(
      children: [
        MainScreenView(),
        WeatherView(),
      ],
    ));
  }
}
