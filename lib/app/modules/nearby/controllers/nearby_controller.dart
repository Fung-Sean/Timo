import 'dart:math';

import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../homescreen/controllers/homescreen_controller.dart';

class NearbyController extends GetxController {
  List<Results>? results;
  String? status;

  NearbyController({this.results, this.status});

  late Position currentLocation;

  PolylinePoints polylinePoints = PolylinePoints();
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];

  late final prefs;
  String googleAPIKey = "AIzaSyClNisCXgPVCbZXqReGLLc3k-5uz6Ho9Mg";
  @override
  Future<void> onInit() async {
    super.onInit();
    prefs = await SharedPreferences.getInstance();
    prefs.setInt("Time_for_stuff", 1200);
  }

  Future<int> calculateTravelTime(Results result) async {
    prefs = await SharedPreferences.getInstance();
    int transportTime = 0;
    //this is the total time left, it must be greater than the time it takes to go to the
    //other spot

    currentLocation = await determinePosition();

    LatLng locations1 =
        LatLng(currentLocation.latitude, currentLocation.longitude);

    PolylinePoints polylinePoints = PolylinePoints();
    Map<PolylineId, Polyline> polylines = {};
    List<LatLng> polylineCoordinates = [];

    LatLng locations2 = LatLng(
        result.geometry!.location!.lat!, result.geometry!.location!.lng!);

    polylineCoordinates = [];

    PolylineResult path = await polylinePoints.getRouteBetweenCoordinates(
      googleAPIKey,
      PointLatLng(locations1.latitude, locations1.longitude),
      PointLatLng(locations2.latitude, locations2.longitude),
      travelMode: TravelMode.walking,
    );

    if (prefs.getBool("Bike") == true) {
      path = await polylinePoints.getRouteBetweenCoordinates(
        googleAPIKey,
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
    print("PolyCoordinates Length: " + polylineCoordinates.length.toString());
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

  //here is a method that will determine if a particular result can be reached
  //in the alloted time.
  Future<bool> findIfReachable(Results result) async {
    await prefs.reload();

    int transportTime = 0;
    //this is the total time left, it must be greater than the time it takes to go to the
    //other spot
    int timeLeft = await (prefs.getInt('Time_for_stuff'));

    currentLocation = await determinePosition();

    LatLng locations1 =
        LatLng(currentLocation.latitude, currentLocation.longitude);

    PolylinePoints polylinePoints = PolylinePoints();
    Map<PolylineId, Polyline> polylines = {};
    List<LatLng> polylineCoordinates = [];

    LatLng locations2 = LatLng(
        result.geometry!.location!.lat!, result.geometry!.location!.lng!);

    polylineCoordinates = [];

    PolylineResult path = await polylinePoints.getRouteBetweenCoordinates(
      googleAPIKey,
      PointLatLng(locations1.latitude, locations1.longitude),
      PointLatLng(locations2.latitude, locations2.longitude),
      travelMode: TravelMode.walking,
    );

    if (prefs.getBool("Bike") == true) {
      path = await polylinePoints.getRouteBetweenCoordinates(
        googleAPIKey,
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
    print("PolyCoordinates Length: " + polylineCoordinates.length.toString());
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

    if (transportTime + 900 < timeLeft) {
      return true;
    } else {
      return false;
    }
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

  Future<Position> getLocation() async {
    currentLocation = await determinePosition();
    return currentLocation;
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  NearbyController.fromJson(Map<String, dynamic> json) {
    if (json['results'] != null) {
      results = <Results>[];
      json['results'].forEach((v) {
        results!.add(Results.fromJson(v));
      });
    }
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.results != null) {
      data['results'] = this.results!.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    return data;
  }
}

class Results {
  Geometry? geometry;
  String? icon;
  String? iconBackgroundColor;
  String? iconMaskBaseUri;
  String? name;
  List<Photos>? photos;
  String? placeId;
  String? reference;
  String? scope;
  List<String>? types;
  String? vicinity;
  String? businessStatus;
  OpeningHours? openingHours;
  PlusCode? plusCode;
  dynamic rating;
  int? userRatingsTotal;

  int? travelTime;

  Results(
      {this.geometry,
      this.icon,
      this.iconBackgroundColor,
      this.iconMaskBaseUri,
      this.name,
      this.photos,
      this.placeId,
      this.reference,
      this.scope,
      this.types,
      this.vicinity,
      this.businessStatus,
      this.openingHours,
      this.plusCode,
      this.rating,
      this.userRatingsTotal,
      this.travelTime});

  Results.fromJson(Map<String, dynamic> json) {
    geometry =
        json['geometry'] != null ? Geometry.fromJson(json['geometry']) : null;
    icon = json['icon'];
    iconBackgroundColor = json['icon_background_color'];
    iconMaskBaseUri = json['icon_mask_base_uri'];
    name = json['name'];
    if (json['photos'] != null) {
      photos = <Photos>[];
      json['photos'].forEach((v) {
        photos!.add(Photos.fromJson(v));
      });
    }
    placeId = json['place_id'];
    reference = json['reference'];
    scope = json['scope'];
    types = json['types'].cast<String>();
    vicinity = json['vicinity'];
    businessStatus = json['business_status'];
    openingHours = json['opening_hours'] != null
        ? OpeningHours.fromJson(json['opening_hours'])
        : null;
    plusCode =
        json['plus_code'] != null ? PlusCode.fromJson(json['plus_code']) : null;
    rating = json['rating'];
    userRatingsTotal = json['user_ratings_total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.geometry != null) {
      data['geometry'] = this.geometry!.toJson();
    }
    data['icon'] = this.icon;
    data['icon_background_color'] = this.iconBackgroundColor;
    data['icon_mask_base_uri'] = this.iconMaskBaseUri;
    data['name'] = this.name;
    if (this.photos != null) {
      data['photos'] = this.photos!.map((v) => v.toJson()).toList();
    }
    data['place_id'] = this.placeId;
    data['reference'] = this.reference;
    data['scope'] = this.scope;
    data['types'] = this.types;
    data['vicinity'] = this.vicinity;
    data['business_status'] = this.businessStatus;
    if (this.openingHours != null) {
      data['opening_hours'] = this.openingHours!.toJson();
    }
    if (this.plusCode != null) {
      data['plus_code'] = this.plusCode!.toJson();
    }
    data['rating'] = this.rating;
    data['user_ratings_total'] = this.userRatingsTotal;
    return data;
  }
}

class Geometry {
  Location? location;
  Viewport? viewport;

  Geometry({this.location, this.viewport});

  Geometry.fromJson(Map<String, dynamic> json) {
    location =
        json['location'] != null ? Location.fromJson(json['location']) : null;
    viewport =
        json['viewport'] != null ? Viewport.fromJson(json['viewport']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.location != null) {
      data['location'] = this.location!.toJson();
    }
    if (this.viewport != null) {
      data['viewport'] = this.viewport!.toJson();
    }
    return data;
  }
}

class Location {
  double? lat;
  double? lng;

  Location({this.lat, this.lng});

  Location.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    lng = json['lng'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    return data;
  }
}

class Viewport {
  Location? northeast;
  Location? southwest;

  Viewport({this.northeast, this.southwest});

  Viewport.fromJson(Map<String, dynamic> json) {
    northeast =
        json['northeast'] != null ? Location.fromJson(json['northeast']) : null;
    southwest =
        json['southwest'] != null ? Location.fromJson(json['southwest']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.northeast != null) {
      data['northeast'] = this.northeast!.toJson();
    }
    if (this.southwest != null) {
      data['southwest'] = this.southwest!.toJson();
    }
    return data;
  }
}

class Photos {
  int? height;
  List<String>? htmlAttributions;
  String? photoReference;
  int? width;

  Photos({this.height, this.htmlAttributions, this.photoReference, this.width});

  Photos.fromJson(Map<String, dynamic> json) {
    height = json['height'];
    htmlAttributions = json['html_attributions'].cast<String>();
    photoReference = json['photo_reference'];
    width = json['width'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['height'] = this.height;
    data['html_attributions'] = this.htmlAttributions;
    data['photo_reference'] = this.photoReference;
    data['width'] = this.width;
    return data;
  }
}

class OpeningHours {
  bool? openNow;

  OpeningHours({this.openNow});

  OpeningHours.fromJson(Map<String, dynamic> json) {
    openNow = json['open_now'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['open_now'] = this.openNow;
    return data;
  }
}

class PlusCode {
  String? compoundCode;
  String? globalCode;

  PlusCode({this.compoundCode, this.globalCode});

  PlusCode.fromJson(Map<String, dynamic> json) {
    compoundCode = json['compound_code'];
    globalCode = json['global_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['compound_code'] = this.compoundCode;
    data['global_code'] = this.globalCode;
    return data;
  }
}

Future<Position> determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  return await Geolocator.getCurrentPosition();
}
