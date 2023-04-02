import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/calendar/v3.dart';
import 'package:intl/intl.dart';
import 'package:quiver/async.dart';
import 'package:timo_test/app/modules/login/controllers/login_controller.dart';

class HomescreenController extends GetxController {
  //TODO: Implement HomescreenController

  final count = 0.obs;
  final myFuture =
      Future.delayed(Duration(seconds: 3), () => 'Hello World!').obs;
  final LoginController loginController = Get.put(LoginController());

  //for the time being we will have some constant values for
  //our event data to initalize the start screen

  String address = "".obs();
  String eventName = "".obs();
  DateTime startTime = DateTime(2023, 3, 27, 17, 30).obs();
  int readyTime = 0.obs();
  int travelTime = 0.obs();
  int eventTime = 0.obs();
  int totalTime = 0.obs();

  double readyProportion = 0.0.obs();
  double travlelProportion = 0.0.obs();
  double eventProportion = 0.0.obs();
  //a variable to indicate the time remaining until the next phase

  static int start = 10.obs();
  static int current = 10.obs();

  RxString arriveTime = "".obs;

  RxString time = '00:00:00'.obs;

  RxDouble proportionOfTimer = 0.0.obs;


  //no args constructor
  //HomescreenController() {}

  HomescreenController(int ready, int travel, int event, DateTime timeStart) {
    //loginController.onInit();
    /*
    readyTime = ready.obs();
    travelTime = travel.obs();
    eventTime = event.obs();
    
    totalTime = (readyTime + travelTime + eventTime).obs();

    readyProportion = (readyTime / totalTime).obs();
    travlelProportion = (travelTime / totalTime).obs();
    eventProportion = (eventTime / totalTime).obs();
    */
    initialize();
  }

  initialize() async {
    var localData = await loginController.readDataFromLocalStorage();
    var readyFormat = DateFormat('h:mm a');
    //var readyInt = int.parse(localData[0].start);
    var readyInt = readyFormat.parse(localData[0].start);
    print(readyInt);
    //var endInt = int.parse(localData[0].end);
    RegExp regExp = RegExp(r'\d.*');
    //address = localData[0].location.obs();
    var intermediateAddress =
        regExp.stringMatch(localData[0].location.obs()) as String;
    address =
        intermediateAddress.substring(0, intermediateAddress.length - 5).obs();
    //print(address);
    eventName = localData[0].title.obs();

    readyTime = readyInt.minute.obs();
    var readyTimeString =
        (readyInt.hour - 12).toString() + ":" + readyInt.minute.toString();
    arriveTime = readyTimeString.obs;
    var leaveTimeString = (readyInt.hour - 12).toString() +
        ":" +
        (readyInt.minute - 15).toString();
    time = leaveTimeString.obs;
    //time = travelTime = 30.obs();
    //eventTime = (endInt - readyInt).obs();

    totalTime = (readyTime + travelTime + eventTime).obs();

    readyProportion = (readyTime / totalTime).obs();
    travlelProportion = (travelTime / totalTime).obs();
    eventProportion = (eventTime / totalTime).obs();
  }

  @override
  Future<void> onInit() async {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  String getAddress() {
    return address;
  }

  String getEventName() {
    return eventName;
  }

  void updateArrival() {
    bool PM = false;
    int numHours = startTime.hour;
    if (startTime.hour >= 12) {
      PM = true;
      numHours -= 12;
    } else {
      PM = false;
    }
    if (PM) {
      arriveTime.value =
          numHours.toString() + ":" + startTime.minute.toString() + " PM";
    } else {
      arriveTime.value =
          numHours.toString() + ":" + startTime.minute.toString() + " AM";
    }
  }

  //start a timer that counts down from numSeconds
  void startTimer(int numSeconds) {
    CountdownTimer countDownTimer = CountdownTimer(
      Duration(seconds: numSeconds),
      const Duration(seconds: 1),
    );

    var sub = countDownTimer.listen(null);
    sub.onData((duration) {
      current = numSeconds - duration.elapsed.inSeconds;

      //maintain a variable called proportion that dictates
      //the portion of the timer progress indicator to be filled
      proportionOfTimer.value = current / numSeconds;

      int hours = current ~/ 3600;
      int minutes = current ~/ 60;
      int seconds = current % 60;
      time.value = hours.toString().padLeft(2, "0") +
          ":" +
          minutes.toString().padLeft(2, "0") +
          ":" +
          seconds.toString().padLeft(2, "0");
    });

    sub.onDone(() {
      print("Done");
      sub.cancel();
    });
  }

  void increment() => count.value++;
}
