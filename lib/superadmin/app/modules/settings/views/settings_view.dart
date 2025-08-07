import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';


import '../../../../shared/Constants/appcolor.dart';
import '../controllers/settings_contoller.dart';

class SettingsView extends GetView<SettingsContoller>{
  const SettingsView({super.key});


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: Get.height,
        decoration: BoxDecoration(
          color: appcolor.bgColor,
        ),

      ),
    );
  }
}