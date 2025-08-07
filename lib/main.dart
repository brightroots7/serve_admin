import 'package:admin/superadmin/app/modules/superLogin/views/super_login_view.dart';
import 'package:admin/superadmin/shared/Constants/appcolor.dart';
import 'package:admin/templeadmin/app/modules/Login/bindings/login_binding.dart';
import 'package:admin/templeadmin/app/modules/Login/views/login_view.dart';
import 'package:admin/templeadmin/shared/Constants/Appcolors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  print(dotenv.env['GMAIL_MAIL']);
  try {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyCAypg0jRdZg1GgPntnVZyJJNRH_tGX-WE",
          authDomain: "serveapp-617d9.firebaseapp.com",
          projectId: "serveapp-617d9",
          storageBucket: "serveapp-617d9.appspot.com",
          messagingSenderId: "5982308522",
          appId: "1:5982308522:web:f23d90de0b9b93369d68d3"),
    );
  } catch (e) {
    print("Firebase initialization error: $e");
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      navigatorKey: Get.key,
      initialRoute: '/Selection',
      debugShowCheckedModeBanner: false,
      title: 'Temple Admin',
      getPages: [
        GetPage(
          name: '/Login',
          page: () => LoginView(),
          binding: LoginBinding(),
        ),
        GetPage(
          name: '/SuperLogin',
          page: () => SuperLoginView(),
        ),
        GetPage(
          name: '/Selection',
          page: () => SelectionView(),
        ),
      ],
    );
  }
}

class SelectionView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
                child: Image.asset(
              "assets/images/logo.png",
              height: 150,
              width: 250,
            )),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Login",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 38,
                        color: Colors.blueGrey.shade400),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    color: Appcolors.appColor,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                  child: InkWell(
                    onTap: () {
                      Get.toNamed('/Login');
                    },
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.admin_panel_settings,
                              size: 50, color: Colors.white),
                          SizedBox(height: 10),
                          Text(
                            'Temple Admin',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 80,
                  width: 80,
                ),
                Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    color: appcolor.appColor,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                  child: InkWell(
                    onTap: () {
                      Get.toNamed('/SuperLogin');
                    },
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.supervisor_account_outlined,
                              size: 50, color: Colors.white),
                          SizedBox(height: 10),
                          Text(
                            'Super Admin',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
