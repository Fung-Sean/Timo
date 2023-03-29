import 'dart:async';

import 'package:get/get.dart';

class TimerController extends GetxController {
  //TODO: Implement TimerController
  final count = 0.obs;
  Timer? _timer;
  int remainSeconds = 1;
  final time = '00.00'.obs;

  TimerController() {}

  @override
  void onInit() {
    _startTimer(900);
    super.onReady();
  }

  @override
  void onReady() {
    _startTimer(900);
    super.onReady();
  }

  @override
  void onClose() {
    if (_timer != null) {
      _timer!.cancel();
    }
    super.onClose();
  }

  _startTimer(int seconds) {
    const duration = Duration(seconds: 1);
    remainSeconds = seconds;
    _timer = Timer.periodic(duration, (Timer timer) {
      if (remainSeconds == 0) {
        timer.cancel();
      } else {
        int minutes = remainSeconds ~/ 60;
        int seconds = remainSeconds % 60;
        time.value =
            "${minutes.toString().padLeft(2, "0")}:${seconds.toString().padLeft(2, "0")}";
        remainSeconds--;
      }
    });
  }

  void increment() => count.value++;
}
