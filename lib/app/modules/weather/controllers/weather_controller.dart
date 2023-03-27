import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import '../views/weather_view.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/route_manager.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

import '../models/weather_model.dart';

class WeatherController extends GetxController {
  //TODO: Implement WeatherController

  var futureWeather = <WeatherDataModel>[].obs;
  var isLoading = true.obs;

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
    getWeather();
  }

  Future<void> getWeather() async {
    final response = await http.get(Uri.parse(
        "https://api.openweathermap.org/data/2.5/weather?lat=42.350876&lon=-71.106918&units=metric&appid=5ef0b262f16659ab86bd672617ca3c51"));

    if (response.statusCode == 200) {
      // ignore: no_leading_underscores_for_local_identifiers
      WeatherDataModel _weatherdatamodel =
          WeatherDataModel.fromJson(jsonDecode(response.body));

      futureWeather.add(WeatherDataModel(
          temp: _weatherdatamodel.temp,
          temp_min: _weatherdatamodel.temp_min,
          temp_max: _weatherdatamodel.temp_max,
          w_description: _weatherdatamodel.w_description));

      isLoading.value = true;
      update();
    } else {
      //throw Exception("Failed to load weather API");
      Get.snackbar('Error loading data ...',
          'Server responded: ${response.statusCode}:${response.reasonPhrase.toString()}');
    }
  }

  // @override
  // void onReady() {
  //   super.onReady();
  // }

  // @override
  // void onClose() {
  //   super.onClose();
  // }

  // void increment() => count.value++;
}
