import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../controllers/temples_controller.dart';

class SettingsBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TemplesController>(
          () => TemplesController(),
    );
  }
}
