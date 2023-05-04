import 'package:flutter/material.dart';

import 'package:get/get.dart';

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
  NearbyController controller = NearbyController();

  String apiKey = "AIzaSyDSWJxako7BZpccp1_1CfSTzPt5nwwNMY4";
  String radius = "1000";

  double latitude = 42.349480;
  double longitude = -71.094580;

  String keyword = '&keyword=coffee';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nearby Places'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ElevatedButton(
                onPressed: () {
                  getNearbyPlaces();
                  print("this works");
                  print(controller.results);
                },
                child: const Text("Get Nearby Places")),
            if (controller.results != null)
              for (int i = 0; i < controller.results!.length; i++)
                nearbyPlacesWidget(controller.results![i])
          ],
        ),
      ),
    );
  }

  void getNearbyPlaces() async {
    Position location = await controller.getLocation();
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

    controller = NearbyController.fromJson(jsonDecode(response.body));

    setState(() {});
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
          Text("Location: " + results.vicinity.toString()),
        ],
      ),
    );
  }
}
