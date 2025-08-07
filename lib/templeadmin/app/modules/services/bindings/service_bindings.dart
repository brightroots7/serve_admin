import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../controllers/service_controllers.dart';

class ServiceBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ServiceControllers>(
          () => ServiceControllers(),
    );
  }
}
