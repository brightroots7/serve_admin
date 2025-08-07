import 'package:get/get.dart';

import '../controllers/settings_contoller.dart';




class SettingsBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SettingsContoller>(
          () => SettingsContoller(),
    );
  }
}
