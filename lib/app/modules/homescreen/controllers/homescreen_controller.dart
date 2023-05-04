import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/calendar/v3.dart';
import 'package:intl/intl.dart';
import 'package:quiver/async.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timo_test/app/modules/intro/controllers/intro_controller.dart';
import 'package:timo_test/app/modules/login/controllers/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
//import 'package:timo_test/notification_serviceController.dart';
import 'dart:math';
import '../../onboarding/controllers/onboarding_controller.dart';
import 'dart:math';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
//import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//import '../../../../notification_service.dart';
//import '../../../../notification_service_cont.dart';
//import '../../../../notification_serviceController.dart';
import 'package:async/async.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

class HomescreenController extends GetxController {
  final count = 0.obs;

/*
  //delays loading of home screenc ontroller to allow for background data processing
  final myFuture =
      Future.delayed(Duration(seconds: 3), () => 'Hello World!').obs;
      */

  //instantiates intro controller into existing controller to utilize its functions
  final IntroController introController = Get.put(IntroController());

  //we import the onboarding controller to get the user's input for preptime needed
  final OnboardingController onboardingController =
      Get.put(OnboardingController());

  //here we have a google maps controller, that we will use to calculate the
  //distance between points.
  GoogleMapController? mapController;

  // initialize notifications controller to utilize its functions
  // final NotificationServiceController _notificationController =
  //     Get.put(NotificationServiceController());

  // final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  //     FlutterLocalNotificationsPlugin();

  // void init() {
  //   final AndroidInitializationSettings initializationSettingsAndroid =
  //       AndroidInitializationSettings('app_icon');
  //   final NotificationService _notificationController =
  //       NotificationServiceCont();
  // final IOSInitializationSettings initializationSettingsIOS =
  //     IOSInitializationSettings(
  //   requestSoundPermission: false,
  //   requestBadgePermission: false,
  //   requestAlertPermission: false,
  //   onDidReceiveLocalNotification: onDidReceiveLocalNotification,
  // );
  //   final InitializationSettings initializationSettings =
  //       InitializationSettings(
  //           android: initializationSettingsAndroid,
  //           //iOS: initializationSettingsIOS,
  //           macOS: null);
  // }

  //initialize parameters for timer display on screen

  int timeLeft = 0;
  RxString timeDisplay = '00:00:00'.obs;
  RxDouble proportionOfTimer = 0.0.obs;

  //initialize the parameters of the CURRENT or UPCOMING event
  RxString title = "".obs;
  RxString description = "".obs;
  RxString startTime = "".obs;
  RxString endTime = "".obs;
  RxString location = "".obs;
  RxString date = "".obs;

  //Initialize the parameters of titles inside the Circle
  RxString aboveTimer = "".obs;
  RxString belowTimer = "".obs;

  //get this data from the local system, which was originally input on
  //onboarding screen, alongside the transport time, which sean will figure out
  RxInt getReadyTime = 600.obs;
  RxInt transportTime = 600.obs;
  RxInt eventDuration = 0.obs;

  //the physical number of seconds until the we have to get ready for our next event
  late RxInt timeBeforeNextEventGetReady;

  //integer form of the previous
  late int timeUntilNextGetReadyInt;

  //this represents the time at which the user should start getting ready
  RxString startAtString = "".obs;

  //this represents the time at which the ready timer has finished and user should embark
  RxString startTravelString = "".obs;

  RxString startEventString = "".obs;

  RxString endEventString = "".obs;

  //the time until our get ready event starts
  late Duration timeUntilNextGetReady;

  //checks when getReady timer should start
  bool startGetReadyTimer = false;

  //stores current location of user to determine walking time to destination
  late Position currentLocation;

  //variable that stores when last google calendar push was done

  //bool to store if widget is currently running or not
  bool isWidgetRunning = false;

  //Async Memoizer
  AsyncMemoizer _initialize = AsyncMemoizer();
  AsyncMemoizer _beforeGetReady = AsyncMemoizer();
  AsyncMemoizer _getReady = AsyncMemoizer();
  AsyncMemoizer _transport = AsyncMemoizer();

  //Color Values
  Color page1Blue = Color.fromARGB(255, 84, 144, 248);

  //color control variables

  // Define a string variable to represent the current state
  String currentState = 'beforeGetReady';

  HomescreenController() {
    //initialize();
  }

  //fields to store all of the polylines that we gather to get an accurate
  //reading of travel time between two points
  PolylinePoints polylinePoints = PolylinePoints();
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];

  //########################################

  // function that runs to initialize data from local storage and store it for home screen use
  Future<void> initialize() async {
    await _initialize.runOnce(() async {
      print("Initiliaze starts now");
      //initialize our shared preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.reload();
      int readyTime = await (prefs.getInt('time')! * 60) ?? 0;
      int earlyTime = await (prefs.getInt('early')! * 60) ?? 0;
      //String last_timer_update = await (prefs.getString('last_timer_update')!);
      getReadyTime.value = await (readyTime + earlyTime);
      print("getReadyTime: " + getReadyTime.value.toString());
      polylineCoordinates = [];

      //print("last_timer_update: " + last_timer_update);

      //prefs.setInt("TimeLeft", last_timer_update);

      //get current location from user
      currentLocation = await determinePosition();
      print(currentLocation.latitude);

      //uses intro controller's function to read data from local storage
      var localData = await introController.readDataFromLocalStorage();
      //getReadyTime = (onboardingController.getMinutesToGetReady() * 60).obs;

      //on startup, load in the information of the first event
      title.value = localData[0].title;
      description.value = localData[0].description;
      startTime.value = localData[0].start;
      endTime.value = localData[0].end;
      location.value = localData[0].location;
      date.value = localData[0].date;

      //###################################
      //here is where i will do google maps distance and location tracking stuff
      //List<Location> locations1 = await locationFromAddress("610 Beacon St");
      print("I am here!");
      print("Location value: " + location.value);
      List<Location> locations2 = await locationFromAddress(location.value);
      print("Location2 is good");

      Set<Marker> markers = Set(); //markers for google map
      String googleAPIKey = "AIzaSyClNisCXgPVCbZXqReGLLc3k-5uz6Ho9Mg";
      //String googleAPIKey = "AIzaSyDSWJxako7BZpccp1_1CfSTzPt5nwwNMY4";
      //LatLng startLocation =
      //LatLng(locations1[0].latitude, locations1[0].longitude);
      LatLng startLocation =
          LatLng(currentLocation.latitude, currentLocation.longitude);
      LatLng endLocation =
          LatLng(locations2[0].latitude, locations2[0].longitude);

      print("Start location: " + startLocation.toString());
      print("End location: " + endLocation.toString());

      //initialize some booleans to determine what form of transportation we intend
      //to use
      bool car = false;
      bool publicTransit = false;
      bool bike = false;
      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        googleAPIKey,
        PointLatLng(currentLocation.latitude, currentLocation.longitude),
        PointLatLng(endLocation.latitude, endLocation.longitude),
        travelMode: TravelMode.walking,
      );

      print("Polyline result: " + result.points.length.toString());
      //HERE we need to add code to customize which is the fastest
      // if (prefs.getBool("Bus") == true || prefs.getBool("Train") == true) {
      //   publicTransit = true;
      //   PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      //     googleAPIKey,
      //     PointLatLng(currentLocation.latitude, currentLocation.longitude),
      //     PointLatLng(endLocation.latitude, endLocation.longitude),
      //     travelMode: TravelMode.transit,
      //   );
      // }
      if (prefs.getBool("Bike") == true) {
        bike = true;
        result = await polylinePoints.getRouteBetweenCoordinates(
          googleAPIKey,
          PointLatLng(currentLocation.latitude, currentLocation.longitude),
          PointLatLng(endLocation.latitude, endLocation.longitude),
          travelMode: TravelMode.bicycling,
        );
      }

      // if (prefs.getBool("Car") == true || prefs.getBool("Uber") == true) {
      //   car = true;
      //   PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      //     googleAPIKey,
      //     PointLatLng(currentLocation.latitude, currentLocation.longitude),
      //     PointLatLng(endLocation.latitude, endLocation.longitude),
      //     travelMode: TravelMode.driving,
      //   );
      // }

      if (result.points.isNotEmpty) {
        result.points.forEach((PointLatLng point) {
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        });
      } else {
        print(result.errorMessage);
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
      print("Total Distance: " + totalDistance.toString());
      print("Travel time: " +
          (totalDistance * 60 / 4.5).ceil().toString() +
          " minutes");
      transportTime.value = await (totalDistance * 60 / 4.5).ceil() * 60;
      if (bike) {
        transportTime.value = await (totalDistance * 60 / 16).ceil() * 60;
      }

      //also on startup, fill in the info in the circles
      aboveTimer.value = "Get Ready In";
      belowTimer.value = "Start at ";

      //convert startTime fields into seperate fields used to create DateTime object
      DateTime now = DateTime.now();
      int year = convertYearToInt(date.value);
      int month = convertMonthToInt(date.value);
      int day = convertDayToInt(date.value);
      int hour = convertHourToInt(startTime.value);
      int minutes = convertMinuteToInt(startTime.value);

      //startTime variable from gCal as DateTime object
      DateTime eventStartTime = DateTime(year, month, day, hour, minutes);

      //now we want to calculate the duration of time the event actually lasts
      hour = convertHourToInt(endTime.value);
      minutes = convertMinuteToInt(endTime.value);

      //day = convertDayToInt(date.value);
      DateTime eventEndTime = DateTime(year, month, day, hour, minutes);

      //edge case to see if an event starts on one day and ends on another (Eg. starts at 11:59pm and ends at 12:30am next day)
      if (eventEndTime.compareTo(eventStartTime) < 0) {
        day++;
      }
      //TODO: check for edge cases: events between months, and between years

      //stores information about event end time gathered from local data
      eventEndTime = DateTime(year, month, day, hour, minutes);
      print(eventStartTime.toString());
      print(eventEndTime.toString());

      //sets the length of the event
      eventDuration.value = eventEndTime.difference(eventStartTime).inMinutes;
      print(eventDuration.value);

      //calculates total time in seconds that user needs to get ready and transport
      int secondsTosubtract = getReadyTime.value + transportTime.value;

      //calculates time for user to start getting ready as a DateTime Object
      DateTime timeToGetReady =
          eventStartTime.subtract(Duration(seconds: secondsTosubtract));

      startAtString.value = DateFormat.jm().format(timeToGetReady);

      //timeToGetReady records the first time in our list; we will have to track
      //all the other times and turn them into strings that I can work with
      DateTime travelTime =
          timeToGetReady.add(Duration(seconds: getReadyTime.value));
      startTravelString.value = DateFormat.jm().format(travelTime);

      //we also record the start and end of the event
      startEventString.value = DateFormat.jm().format(eventStartTime);
      endEventString.value = DateFormat.jm().format(eventEndTime);

      //calculates how much time you have until next event getReady timer
      timeUntilNextGetReady = timeToGetReady.difference(now);

      //timeUntilNextGetReady = timeToGetReady.difference(DateTime.parse(last_timer_update));

      print("TIME UNTIL NEXT GET READY");
      print(timeUntilNextGetReady.toString());

      //internal usage
      timeUntilNextGetReadyInt = timeUntilNextGetReady.inSeconds;

      prefs.setInt("timeUntilReady", timeUntilNextGetReadyInt);

      //call BeforeGetReady timer
      startBeforeGetReadyTimer();
    });
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

  @override
  Future<void> onInit() async {
    super.onInit();
    //getReadyTime = (onboardingController.getMinutesToGetReady() * 60).obs;

    //initializes all data in home screen
    await initialize();

    //initialize for notification
    // NotificationServiceController.initialize(flutterLocalNotificationsPlugin);

    // NotificationServiceController.showNotification(
    //     title: 'TIMO', body: 'meow', fln: flutterLocalNotificationsPlugin);
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  //Notifications
  void sendStartNotification() {
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });

    AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: 1,
            channelKey: 'test_channel',
            title: 'TIMO',
            body: 'Timer has started!'));

    //what happens if we click the notif?
    // AwesomeNotifications().actionStream.listen((event) {
    //   Get.to(const Intro1View());
    // });
  }

  void sendFinishNotification() {
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });

    AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: 1,
            channelKey: 'test_channel',
            title: 'TIMO',
            body: 'Timer has finished!'));

    //what happens if we click the notif?
    // AwesomeNotifications().actionStream.listen((event) {
    //   Get.to(const Intro1View());
    // });
  }

  int convertYearToInt(String date) {
    DateTime dateTime = DateFormat('EEEE, MMMM d, y').parse(date);
    int year = dateTime.year;
    return year;
  }

  int convertMonthToInt(String date) {
    DateTime dateTime = DateFormat('EEEE, MMMM d, y').parse(date);
    int monthNumber = dateTime.month;
    return monthNumber;
  }

  int convertDayToInt(String date) {
    DateTime dateTime = DateFormat('EEEE, MMMM d, y').parse(date);
    int day = dateTime.day;
    return day;
  }

  int convertHourToInt(String time) {
    DateTime dateTime = DateFormat('h:mm a').parse(time);
    int hour = dateTime.hour;
    return hour;
  }

  int convertMinuteToInt(String time) {
    DateTime dateTime = DateFormat('h:mm a').parse(time);
    int minute = dateTime.minute;
    return minute;
  }

  //FOR NOTIFICATION/POPUPS
  final stylebegin_title = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w500,
    color: Color.fromARGB(255, 53, 147, 255),
  );

  final stylebegin_middle = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w300,
      color: Color.fromARGB(255, 0, 0, 0));

  //function to handle timer logic for before an event's getReady timer starts
  void startBeforeGetReadyTimer() async {
    await _beforeGetReady.runOnce(() async {
      // code for your async operation here
      print("I AM IN TIMER FUNCTION");

      Get.defaultDialog(
          title: 'Your timer has begun!',
          titleStyle: GoogleFonts.inter(textStyle: stylebegin_title),
          content: SizedBox(
              width: 300,
              height: 150,
              child: Text(
                'Timo takes your Google Calendar \n events to set aside periods of time for \n you to get ready and travel to your \n destination on time.',
                style: GoogleFonts.inter(textStyle: stylebegin_middle),
                textAlign: TextAlign.center,
              )),
          // textConfirm: "Let's go!",
          // buttonColor: Color.fromARGB(255, 53, 147, 255)
          actions: [
            ElevatedButton(
                onPressed: () {
                  Get.back();
                },
                child: Text("Let's go!"))
          ],
          barrierDismissible: true

          //middleText:
          //    'Timo takes your Google Calendar \n events to set aside periods of time for \n you to get ready and travel to your \n destination on time.',
          //middleTextStyle: GoogleFonts.inter(textStyle: stylebegin_middle)
          );

      SharedPreferences prefs = await SharedPreferences.getInstance();

      //change display show timer is over
      if (timeUntilNextGetReadyInt < 0) {
        timeDisplay.value = '00:00:00';
      }

      //countdown timer library initialization
      CountdownTimer countDownTimer = CountdownTimer(
        Duration(seconds: timeUntilNextGetReadyInt),
        const Duration(seconds: 1),
      );
      //we save the amount of time until get ready is activated, so that we can use it to see
      //if there is time for miscellaneous task
      await prefs.setInt("Time_for_stuff", timeUntilNextGetReadyInt);

      var sub = countDownTimer.listen(null);
      sub.onData((duration) async {
        //set current time to shared preferences to preserve state
        await prefs.setString("last_timer_update", DateTime.now().toString());
        //calculates time left using duration elapsed
        timeLeft = timeUntilNextGetReadyInt - duration.elapsed.inSeconds;
        //print("timeLeft: " + timeLeft.toString());

        //maintain a variable called proportion that dictates
        //the portion of the timer progress indicator to be filled
        proportionOfTimer.value = timeLeft / timeUntilNextGetReadyInt;

        //data field to show time in hours, minutes, and seconds left until timer expires
        int hours = timeLeft ~/ 3600;
        int minutes = (timeLeft % 3600) ~/ 60;
        int seconds = timeLeft % 60;
        timeDisplay.value = hours.toString().padLeft(2, "0") +
            ":" +
            minutes.toString().padLeft(2, "0") +
            ":" +
            seconds.toString().padLeft(2, "0");
      });

      //after timer expires, switch to getReady timer
      sub.onDone(() {
        print("Done");
        sub.cancel();
        startGetReadyTimer = true;

        //make reset method but for now
        aboveTimer.value = "Get Ready!";
        belowTimer.value = "Leave at ";
        startAtString.value = startTravelString.value;

        //notification
        // NotificationServiceController.showNotification(
        //     title: 'TIMO',
        //     body: 'Timer has started',
        //     fln: flutterLocalNotificationsPlugin);

        //start getReady timer
        getReadyTimer();

        //_notificationController.showNotification("Timer has started!");
      });
    });
  }

  //function that handles logic for getReady timer
  void getReadyTimer() async {
    await _getReady.runOnce(() async {
      //change state
      currentState = "getReady";

      //timer initialization
      CountdownTimer countDownTimer = CountdownTimer(
        Duration(seconds: getReadyTime.value),
        const Duration(seconds: 1),
      );

      var sub = countDownTimer.listen(null);
      sub.onData((duration) {
        //calculates duration based on time elapsed
        timeLeft = getReadyTime.value - duration.elapsed.inSeconds;

        //maintain a variable called proportion that dictates
        //the portion of the timer progress indicator to be filled
        proportionOfTimer.value = timeLeft / getReadyTime.value;

        //values for timer display
        int hours = timeLeft ~/ 3600;
        int minutes = (timeLeft % 3600) ~/ 60;
        int seconds = timeLeft % 60;
        timeDisplay.value = hours.toString().padLeft(2, "0") +
            ":" +
            minutes.toString().padLeft(2, "0") +
            ":" +
            seconds.toString().padLeft(2, "0");
      });

      //when timer is done, switch to travel timer (Implementation in progress)
      sub.onDone(() {
        print("Done");
        sub.cancel();

        Get.defaultDialog(
            title: 'Your timers have ended!',
            titleStyle: GoogleFonts.inter(textStyle: stylebegin_title),
            content: SizedBox(
                width: 300,
                height: 90,
                child: Text(
                  'Did you make it to your event on time?',
                  style: GoogleFonts.inter(textStyle: stylebegin_middle),
                  textAlign: TextAlign.center,
                )),
            // textConfirm: "Let's go!",
            // buttonColor: Color.fromARGB(255, 53, 147, 255)
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: Text("Nope")),
                  ElevatedButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: Text("Yes!"))
                ],
              )
            ],
            barrierDismissible: true

            //middleText:
            //    'Timo takes your Google Calendar \n events to set aside periods of time for \n you to get ready and travel to your \n destination on time.',
            //middleTextStyle: GoogleFonts.inter(textStyle: stylebegin_middle)
            );

        //make reset method but for now
        aboveTimer.value = "Get Ready!";
        belowTimer.value = "Leave at ";
        startAtString.value = startTravelString.value;

        transportTimer();

        // NotificationServiceController.showNotification(
        //     title: 'TIMO',
        //     body: "Time's up! Travel now",
        //     fln: flutterLocalNotificationsPlugin);

        //notification for when timer is done
        //_notificationController.showNotification("Time's up!");
      });
    });
  }

  void transportTimer() async {
    await _getReady.runOnce(() async {
      currentState = "transport";

      //timer initialization
      CountdownTimer countDownTimer = CountdownTimer(
        Duration(seconds: transportTime.value),
        const Duration(seconds: 1),
      );

      var sub = countDownTimer.listen(null);
      sub.onData((duration) {
        //calculates duration based on time elapsed
        timeLeft = transportTime.value - duration.elapsed.inSeconds;

        //maintain a variable called proportion that dictates
        //the portion of the timer progress indicator to be filled
        proportionOfTimer.value = timeLeft / transportTime.value;

        //values for timer display
        int hours = timeLeft ~/ 3600;
        int minutes = (timeLeft % 3600) ~/ 60;
        int seconds = timeLeft % 60;
        timeDisplay.value = hours.toString().padLeft(2, "0") +
            ":" +
            minutes.toString().padLeft(2, "0") +
            ":" +
            seconds.toString().padLeft(2, "0");
      });

      //when timer is done, switch to travel timer (Implementation in progress)
      sub.onDone(() {
        print("Done");
        sub.cancel();

        // NotificationServiceController.showNotification(
        //     title: 'TIMO',
        //     body: "Time's up! Travel now",
        //     fln: flutterLocalNotificationsPlugin);

        //notification for when timer is done
        //_notificationController.showNotification("Time's up!");
      });
    });
  }

  void increment() => count.value++;
}
