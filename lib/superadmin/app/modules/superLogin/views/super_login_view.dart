import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../shared/Constants/appcolor.dart';
import '../../../../shared/Constants/button.dart';
import '../../../../shared/Constants/textfield.dart';
import '../../Home.dart';
import '../controllers/super_login_controller.dart';

class SuperLoginView extends StatelessWidget {
  final SuperLoginController loginController = Get.put(SuperLoginController());

  @override
  Widget build(BuildContext context) {
    final width = Get.width;
    final height = Get.height;
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    return Scaffold(
      backgroundColor: appcolor.white,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: (height - 500) * 0.02),
              Text(
                "Serve App ",
                style: GoogleFonts.urbanist(
                  fontSize: 30,
                  color: appcolor.appColor,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: height * 0.05),
              Text(
                "Welcome Back!",
                style: GoogleFonts.urbanist(
                  fontSize: 30,
                  color: appcolor.appColor,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                "Sign in to your account",
                style: GoogleFonts.urbanist(
                  fontSize: 24,
                  color: appcolor.appColor,
                ),
              ),
              SizedBox(height: height * 0.05),
              Container(
                width: width * 0.4,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: appcolor.grey2,
                      offset: const Offset(5.0, 5.0),
                      blurRadius: 10.0,
                      spreadRadius: 2.0,
                    ),
                    BoxShadow(
                      color: Colors.white,
                      offset: const Offset(0.0, 0.0),
                      blurRadius: 0.0,
                      spreadRadius: 0.0,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "LOG IN",
                        style: GoogleFonts.urbanist(
                          fontWeight: FontWeight.w800,
                          fontSize: 30,
                          color: appcolor.appColor,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      CustomTextField(
                        controller: emailController,
                        borderRadius: 12,
                        containerHeight: height * 0.06,
                        containerWidth: width * 0.8,
                        labelText: "Email",
                        labelFontSize: 20,
                        labelColor: appcolor.appColor,
                        labelFontWeight: FontWeight.w500,
                      ),
                      SizedBox(height: height * 0.03),
                      CustomTextField(
                        controller: passwordController,
                        borderRadius: 12,
                        containerHeight: height * 0.06,
                        containerWidth: width * 0.8,
                        labelText: "Password",
                        labelFontSize: 20,
                        labelColor: appcolor.appColor,
                        labelFontWeight: FontWeight.w500,
                        obscureText: true,
                        suffix: IconButton(
                          icon: const Icon(Icons.visibility_off),
                          onPressed: () {},
                        ),
                      ),
                      SizedBox(height: height * 0.04),
                      Obx(
                        () => loginController.isLoading.value
                            ? Center(child: CircularProgressIndicator())
                            : CustomButton(
                                onTap: () {
                                //  Get.to(()=>HomeView());
                                  loginController.login(emailController.text,
                                      passwordController.text);
                                },
                                height: height * 0.06,
                                width: width * 0.8,
                                child: Center(
                                  child: Text(
                                    "Login",
                                    style: GoogleFonts.urbanist(
                                      fontSize: 24,
                                        fontWeight: FontWeight.w500,
                                        color: appcolor.white),
                                  ),
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
