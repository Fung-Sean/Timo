import 'package:get/get.dart';

import '../controllers/default_login_controller.dart';

class DefaultLoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DefaultLoginController>(
      () => DefaultLoginController(),
    );
  }
}
