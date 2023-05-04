import 'dart:convert';

// our weather data model
class WeatherDataModel {
  //final double lat;
  //final double lon;
  final double temp;
  // ignore: non_constant_identifier_names
  //final double temp_min;
  // ignore: non_constant_identifier_names
  //final double temp_max;
  // ignore: non_constant_identifier_names
  //final String w_description;

  const WeatherDataModel({
    required this.temp,

    //required this.w_description
  });

  factory WeatherDataModel.fromJson(Map<String, dynamic> json) {
    return WeatherDataModel(temp: json["main"]["temp"]

        //w_description: json["weather"][0]["main"]

        );
  }
}
