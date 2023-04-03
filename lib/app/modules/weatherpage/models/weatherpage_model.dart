// our weather data model
class WeatherDataModel {
  //final double lat;
  //final double lon;
  final double temp;
  // ignore: non_constant_identifier_names
  final double temp_min;
  // ignore: non_constant_identifier_names
  final double temp_max;
  // ignore: non_constant_identifier_names
  final String w_description;

  const WeatherDataModel(
      {required this.temp,
      // ignore: non_constant_identifier_names
      required this.temp_min,
      // ignore: non_constant_identifier_names
      required this.temp_max,
      // ignore: non_constant_identifier_names
      required this.w_description});

  factory WeatherDataModel.fromJson(Map<String, dynamic> json) {
    return WeatherDataModel(
        temp: json["main"]["temp"],
        temp_min: json["main"]["temp_min"],
        temp_max: json["main"]["temp_max"],
        w_description: json["weather"]["main"]);
  }
}
