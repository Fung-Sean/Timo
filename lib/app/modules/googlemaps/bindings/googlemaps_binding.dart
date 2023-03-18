import 'package:get/get.dart';

import '../controllers/googlemaps_controller.dart';

class GooglemapsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GooglemapsController>(
      () => GooglemapsController(),
    );
  }
}
