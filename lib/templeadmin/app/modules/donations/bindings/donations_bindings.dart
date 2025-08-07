import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import '../controllers/donations_controllers.dart';


class DonationsBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DonationsControllers>(
          () => DonationsControllers(),
    );
  }
}
