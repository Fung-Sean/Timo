import 'package:get/get.dart';

import '../controllers/homescreen_controller.dart';

class HomescreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomescreenController>;
  }
}
