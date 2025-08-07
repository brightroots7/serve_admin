import 'package:get/get.dart';

import '../controllers/allusers_controller.dart';

class AllusersBindings extends Bindings{
  @override
  void dependencies() {
   Get.lazyPut<AllusersController>(()=>AllusersController());
  }
}