import 'package:get/get.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../controllers/googlemaps_controller.dart';

//our starting point
//NOTE, the longitude (second number) always seems to be the negative of what comes up
//on google. Keep this in mind as we submit custom coordinates.
// const LatLng SOURCE_LOCATION = LatLng(42.3601, -71.0589);
// const LatLng DEST_LOCATION = LatLng(42.3601, -71.0510);
const LatLng SOURCE_LOCATION = LatLng(42.7477863, -71.1699932);
const LatLng DEST_LOCATION = LatLng(42.744421, -71.1698939);

class GooglemapsController extends GetxController {
  //TODO: Implement GooglemapsController

  late BitmapDescriptor sourceIcon;
  late BitmapDescriptor destinationIcon;

  //places pins on the map, right now its empty but we can fill it later
  Set<Marker> _markers = Set<Marker>().obs;

  late LatLng currentLocation;
  late LatLng destinationLocation;

  final count = 0.obs;

  GoogleMapsController() {
    setInitialLocation();
    setSourceAndDestinationMarkerIcons();
    showPinsOnMap();
  }

  @override
  void onInit() {
    super.onInit();
    setInitialLocation();
    setSourceAndDestinationMarkerIcons();
  }

  @override
  void onReady() {
    super.onReady();
    setInitialLocation();
    setSourceAndDestinationMarkerIcons();
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

  void showPinsOnMap() {
    _markers.add(Marker(
        markerId: MarkerId('sourcePin'),
        position: currentLocation,
        icon: sourceIcon));

    _markers.add(Marker(
        markerId: MarkerId('destinationPin'),
        position: destinationLocation,
        icon: destinationIcon));
  }

  void increment() => count.value++;
}
