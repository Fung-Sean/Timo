import 'package:get/get.dart';

import '../controllers/nearby_controller.dart';

class NearbyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NearbyController>(
      () => NearbyController(),
    );
  }
}
