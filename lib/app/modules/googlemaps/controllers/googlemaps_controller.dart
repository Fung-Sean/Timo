import 'package:get/get.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../controllers/googlemaps_controller.dart';

//our starting point
const LatLng SOURCE_LOCATION = LatLng(42.3601, -71.0589);
const LatLng DEST_LOCATION = LatLng(42.743908, -71.170009);

class GooglemapsController extends GetxController {
  //TODO: Implement GooglemapsController

  late BitmapDescriptor sourceIcon;
  late BitmapDescriptor destinationIcon;

  //places pins on the map, right now its empty but we can fill it later
  Set<Marker> _markers = Set<Marker>();

  late LatLng currentLocation;
  late LatLng destinationLocation;

  final count = 0.obs;

  GoogleMapsController() {}

  @override
  void onInit() {
    super.onInit();
    setInitialLocation();
    setSourceAndDestinationMarkerIcons();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void setInitialLocation() {
    currentLocation =
        LatLng(SOURCE_LOCATION.latitude, SOURCE_LOCATION.longitude);
    destinationLocation =
        LatLng(DEST_LOCATION.latitude, DEST_LOCATION.longitude);
  }

  LatLng getInitialLocation() {
    return SOURCE_LOCATION;
  }

  void setSourceAndDestinationMarkerIcons() async {
    sourceIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.0),
        'assets/imgs/source_pin.png');

    destinationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.0),
        'assets/imgs/destination_pin.png');
  }

  Set<Marker> getMarkers() {
    return _markers;
  }

  void increment() => count.value++;
}
