import 'package:admin/templeadmin/app/modules/chats/controllers/chats_controllers.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';

class ChatsBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChatsControllers>(
          () => ChatsControllers(),
    );
  }
}