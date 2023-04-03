import 'package:get/get.dart';

import '../controllers/weatherpage_controller.dart';

class WeatherpageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WeatherpageController>(
      () => WeatherpageController(),
    );
  }
}
