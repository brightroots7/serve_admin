import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../shared/Constants/Appcolors.dart';
import '../../../../shared/Constants/button.dart';
import '../../../../shared/Constants/textfield.dart';
import '../controllers/login_controller.dart';

class LoginView extends StatelessWidget {
  final LoginController loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    final width = Get.width;
    final height = Get.height;
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    return Scaffold(
      backgroundColor: Appcolors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: (height - 500) * 0.02),
              Text(
                "Temple Admin",
                style: GoogleFonts.urbanist(
                  fontSize: 30,
                  color: Appcolor.appColor,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: height * 0.05),
              Text(
                "Welcome Back!",
                style: GoogleFonts.urbanist(
                  fontSize: 30,
                  color: Appcolor.appColor,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                "Sign in to your account",
                style: GoogleFonts.urbanist(
                  fontSize: 24,
                  color: Appcolor.appColor,
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
                      color: Appcolors.grey2,
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
                          color: Appcolor.appColor,
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
                        labelColor: Appcolor.appColor,
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
                        labelColor: Appcolor.appColor,
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
                                  loginController.loginAdmin(emailController.text,
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
                                        color: Appcolors.white),
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
