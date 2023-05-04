import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../homescreen/controllers/homescreen_controller.dart';
import '../controllers/nearby_controller.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:convert';

import 'package:flutter/material.dart';
//import 'package:google_maps_flutter_tutorial/model/nearby_response.dart';

import 'package:http/http.dart' as http;

class NearbyView extends StatefulWidget {
  const NearbyView({Key? key}) : super(key: key);

  @override
  State<NearbyView> createState() => _NearByPlacesScreenState();
}

class _NearByPlacesScreenState extends State<NearbyView> {
  String apiKey = "AIzaSyDSWJxako7BZpccp1_1CfSTzPt5nwwNMY4";
  String radius = "1000";
  double latitude = 42.349480;
  double longitude = -71.094580;
  String keyword = '&keyword=coffee';
  int? timeLeft;
  PolylinePoints polylinePoints = PolylinePoints();
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];

  Future<NearbyController> getNearbyPlaces() async {
    Position location = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    double latitude = location.latitude;
    double longitude = location.longitude;
    var url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=' +
            latitude.toString() +
            ',' +
            longitude.toString() +
            '&radius=' +
            radius +
            keyword +
            '&key=' +
            apiKey);

    var response = await http.post(url);
    return NearbyController.fromJson(jsonDecode(response.body));
  }

  Future<int> calculateTravelTime(Results result) async {
    final prefs = await SharedPreferences.getInstance();
    int transportTime = 0;
    //this is the total time left, it must be greater than the time it takes to go to the
    //other spot

    timeLeft = await prefs.getInt("timeUntilReady");
    Position currentLocation = await determinePosition();

    LatLng locations1 =
        LatLng(currentLocation.latitude, currentLocation.longitude);

    PolylinePoints polylinePoints = PolylinePoints();
    Map<PolylineId, Polyline> polylines = {};
    List<LatLng> polylineCoordinates = [];

    LatLng locations2 = LatLng(
        result.geometry!.location!.lat!, result.geometry!.location!.lng!);

    polylineCoordinates = [];

    PolylineResult path = await polylinePoints.getRouteBetweenCoordinates(
      "AIzaSyDSWJxako7BZpccp1_1CfSTzPt5nwwNMY4",
      PointLatLng(locations1.latitude, locations1.longitude),
      PointLatLng(locations2.latitude, locations2.longitude),
      travelMode: TravelMode.walking,
    );

    if (prefs.getBool("Bike") == true) {
      path = await polylinePoints.getRouteBetweenCoordinates(
        "AIzaSyDSWJxako7BZpccp1_1CfSTzPt5nwwNMY4",
        PointLatLng(locations1.latitude, locations1.longitude),
        PointLatLng(locations2.latitude, locations2.longitude),
        travelMode: TravelMode.bicycling,
      );
    }

    if (path.points.isNotEmpty) {
      path.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    } else {
      print(path.errorMessage);
    }

    addPolyLine(polylineCoordinates);

    double totalDistance = 0;
    //("PolyCoordinates Length: " + polylineCoordinates.length.toString());
    for (var i = 0; i < polylineCoordinates.length - 1; i++) {
      totalDistance += calculateDistance(
          polylineCoordinates[i].latitude,
          polylineCoordinates[i].longitude,
          polylineCoordinates[i + 1].latitude,
          polylineCoordinates[i + 1].longitude);
    }

    transportTime = await (totalDistance * 60 / 4.5).ceil() * 60;
    if (prefs.getBool("Bike") == true) {
      transportTime = await (totalDistance * 60 / 16).ceil() * 60;
    }

    return transportTime;
  }

  addPolyLine(List<LatLng> polylineCoordinates) {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      points: polylineCoordinates,
      width: 8,
    );
    polylines[id] = polyline;
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  void sortByTravelTime(List<Results> results) async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nearby Places'),
        centerTitle: true,
      ),
      body: FutureBuilder<NearbyController>(
        future: getNearbyPlaces(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final results = snapshot.data?.results;
          if (results == null || results.isEmpty) {
            return const Center(child: Text('No nearby places found.'));
          }

          return FutureBuilder<List<int>>(
            future:
                Future.wait(results.map((place) => calculateTravelTime(place))),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              final travelTimes = snapshot.data!;
              for (int i = 0; i < results.length; i++) {
                results[i].travelTime = travelTimes[i];
                if ((results[i].travelTime! + 1200) > ((timeLeft! / 2))) {
                  print("we removed something");
                  results[i].travelTime = -1;
                }
              }

              results.removeWhere((n) => n.travelTime == -1);
              results.sort((a, b) => a.travelTime!.compareTo(b.travelTime!));

              return SingleChildScrollView(
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {});
                      },
                      child: const Text("Refresh"),
                    ),
                    for (int i = 0; i < results.length; i++)
                      nearbyPlacesWidget(results[i])
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget nearbyPlacesWidget(Results results) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Text("Name: " + results.name!),
          InkWell(
            child: Text(
              "Location: " + results.vicinity.toString(),
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                  textStyle: const TextStyle(
                fontWeight: FontWeight.normal,
                color: Colors.black,
                fontSize: 17,
              )),
              overflow: TextOverflow.visible,
              softWrap: true,
            ),
            onTap: () => launchURL('https://www.google.com/maps/place/' +
                results.vicinity.toString()),
          ),
          FutureBuilder<int>(
            future: calculateTravelTime(results),
            builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Text('Loading...');
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return Text(
                    'Travel time: ${(snapshot.data as int) / 60}' + ' minutes');
              }
            },
          ),
        ],
      ),
    );
  }
}

launchURL(String url) async {
  //String url = 'https://flutter.io';
  final uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri);
  } else {
    throw 'Could not launch $url';
  }
}
