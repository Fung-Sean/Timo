import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../controllers/googlemaps_controller.dart';

//the view becomes more zoomed out the smaller camera zoom is
const double CAMERA_ZOOM = 10;
const double CAMERA_TILT = 80;
const double CAMERA_BEARING = 30;

class GooglemapsView extends GetView<GooglemapsController> {
  const GooglemapsView({Key? key}) : super(key: key);

  //this controller allows us to create the google maps screen widget
  static Completer<GoogleMapController> _controller = Completer();

  //this controller merely keeps track of our state variables
  static GooglemapsController ourController = GooglemapsController();

  @override
  Widget build(BuildContext context) {
    CameraPosition initialCameraPosition = CameraPosition(
      zoom: CAMERA_ZOOM,
      tilt: CAMERA_TILT,
      bearing: CAMERA_BEARING,
      target: ourController.getInitialLocation(),
    );

    return Scaffold(
      body: Container(
          child: Obx(
        () => GoogleMap(
          myLocationButtonEnabled: true,
          compassEnabled: false,
          tiltGesturesEnabled: false,
          markers: Set<Marker>.of(ourController
              .getMarkers()), //the markers field updates in real time
          mapType: MapType.normal,
          initialCameraPosition: initialCameraPosition,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
            ourController.showPinsOnMap();
          },
        ),
      )),
    );
  }
}
