import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/calendar/v3.dart';
import 'package:intl/intl.dart';
import 'package:quiver/async.dart';
import 'package:timo_test/app/modules/intro/controllers/intro_controller.dart';
import 'package:timo_test/app/modules/login/controllers/login_controller.dart';

import '../../onboarding/controllers/onboarding_controller.dart';

class HomescreenController extends GetxController {
  final count = 0.obs;

  //delays loading of home screenc ontroller to allow for background data processing
  final myFuture =
      Future.delayed(Duration(seconds: 3), () => 'Hello World!').obs;

  //instantiates intro controller into existing controller to utilize its functions
  final IntroController introController = Get.put(IntroController());

  //we import the onboarding controller to get the user's input for preptime needed
  final OnboardingController onboardingController =
      Get.put(OnboardingController());


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
  RxInt getReadyTime = 1200.obs;
  RxInt transportTime = 1800.obs;
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

  HomescreenController() {
    //initialize();
  }

  // function that runs to initialize data from local storage and store it for home screen use
  initialize() async {
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
    print(timeUntilNextGetReady.toString());

    //internal usage
    timeUntilNextGetReadyInt = timeUntilNextGetReady.inSeconds;
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    //getReadyTime = (onboardingController.getMinutesToGetReady() * 60).obs;


    //initializes all data in home screen

    await initialize();

    //inputs data into home screen
    startBeforeGetReadyTimer();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
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

  //function to handle timer logic for before an event's getReady timer starts
  void startBeforeGetReadyTimer() async {
    //change display show timer is over
    if (timeUntilNextGetReadyInt < 0) {
      timeDisplay.value = '00:00:00';
    }

    //countdown timer library initialization
    CountdownTimer countDownTimer = CountdownTimer(
      Duration(seconds: timeUntilNextGetReadyInt),
      const Duration(seconds: 1),
    );

    var sub = countDownTimer.listen(null);
    sub.onData((duration) {
      //calculates time left using duration elapsed
      timeLeft = timeUntilNextGetReadyInt - duration.elapsed.inSeconds;

      //maintain a variable called proportion that dictates
      //the portion of the timer progress indicator to be filled
      proportionOfTimer.value = timeLeft / timeUntilNextGetReadyInt;

      //data field to show time in hours, minutes, and seconds left until timer expires
      int hours = timeUntilNextGetReady.inHours;
      int minutes = timeUntilNextGetReady.inMinutes.remainder(60);
      int seconds = timeLeft.remainder(60);
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

      //start getReady timer
      getReadyTimer();
    });
  }

  //function that handles logic for getReady timer
  void getReadyTimer() async {
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
    });
  }

  void increment() => count.value++;
}
