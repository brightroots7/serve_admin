import 'package:get/get.dart';

import '../modules/superLogin/bindings/super_login_binding.dart';
import '../modules/superLogin/views/super_login_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  //static  INITIAL = LoginView();

  static final routes = [
    GetPage(
      name: _Paths.LOGIN,
      page: () =>  SuperLoginView(),
      binding: SuperLoginBinding(),
    ),
  ];
}
