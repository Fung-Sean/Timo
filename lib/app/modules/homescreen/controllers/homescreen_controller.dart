import 'dart:async';
import 'package:get/get.dart';
import 'package:quiver/async.dart';

class HomescreenController extends GetxController {
  //TODO: Implement HomescreenController

  final count = 0.obs;

  //for the time being we will have some constant values for
  //our event data to initalize the start screen

  String address = "780 Commonwealth Ave.".obs();
  String eventName = "CS111 Lecture".obs();
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

  final arriveTime = "".obs;

  final time = '00:00:00'.obs;

  RxDouble proportionOfTimer = 0.0.obs;

  //no args constructor
  //HomescreenController() {}

  HomescreenController(int ready, int travel, int event, DateTime timeStart) {
    readyTime = ready.obs();
    travelTime = travel.obs();
    eventTime = event.obs();
    totalTime = (readyTime + travelTime + eventTime).obs();

    readyProportion = (readyTime / totalTime).obs();
    travlelProportion = (travelTime / totalTime).obs();
    eventProportion = (eventTime / totalTime).obs();
  }

  @override
  void onInit() {
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
