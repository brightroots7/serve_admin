import 'package:get/get.dart';

import '../controllers/super_login_controller.dart';

class SuperLoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SuperLoginController>(
      () => SuperLoginController(),
    );
  }
}
