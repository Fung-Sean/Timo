import 'package:get/get.dart';

import '../controllers/timer_controller.dart';

class TimerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TimerController>(
      () => TimerController(),
    );
  }
}
