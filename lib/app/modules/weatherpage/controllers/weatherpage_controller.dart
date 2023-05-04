import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import '../views/weatherpage_view.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/route_manager.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import '../../homescreen/controllers/homescreen_controller.dart';

import '../models/weatherpage_model.dart';

class WeatherpageController extends GetxController {
  var futureWeather = <WeatherDataModel>[].obs;
  var isLoading = true.obs;

  final count = 0.obs;
  final _homescreencontroller = Get.put(HomescreenController());

  get proportionOfTimer => null;
  @override
  void onInit() {
    super.onInit();
    getWeather();
  }

  //latitude: 42.350876
  //longitude: -71.106918

  void getWeather() async {
    final response = await http.get(Uri.parse(
        //"https://api.openweathermap.org/data/2.5/weather?lat=${_homescreencontroller.currentLocation.latitude}&lon=${_homescreencontroller.currentLocation.longitude}&units=imperial&appid=5ef0b262f16659ab86bd672617ca3c51"
        "https://api.openweathermap.org/data/2.5/weather?lat=42.350876&lon=-71.106918&units=imperial&appid=5ef0b262f16659ab86bd672617ca3c51"));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      if (jsonData.length != 0) {
        WeatherDataModel _weatherdatamodel =
            WeatherDataModel.fromJson(jsonData);

        futureWeather.add(WeatherDataModel(temp: _weatherdatamodel.temp
            //w_description: _weatherdatamodel.w_description
            ));
        isLoading.value = true;
        update();
      } else {
        print("unable to get data");
        Get.snackbar('unable to load data', 'boo');
      }
    } else {
      //throw Exception("Failed to load weather API");
      Get.snackbar('Error loading data ...',
          'Server responded: ${response.statusCode}:${response.reasonPhrase.toString()}');
    }
  }

  //@override
  // void onReady() {
  //   super.onReady();
  // }

  // @override
  // void onClose() {
  //   super.onClose();
  // }

  // void increment() => count.value++;
}
