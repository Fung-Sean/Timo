import 'package:get/get.dart';

import '../controllers/homescreen_controller.dart';

class HomescreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomescreenController>(
      () => HomescreenController(25, 50, 75, DateTime(2023, 3, 27, 17, 30)),
    );
  }
}
