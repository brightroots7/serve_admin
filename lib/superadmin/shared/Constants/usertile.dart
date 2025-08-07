import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../app/modules/allusers/controllers/allusers_controller.dart';
import '../../app/modules/allusers/views/userdetails.dart';
import 'appcolor.dart';

class Usertile extends GetView<AllusersController> {
  final Map<String, dynamic> userData;
  final String userId;

  Usertile( {super.key, required this.userData,required this.userId,});
  final controller = Get.put(AllusersController());

  @override
  Widget build(BuildContext context) {
    String name = userData['display_name']?? 'No Name';
    String email = userData['email'] ?? 'No email';


    RxString status = RxString(userData['status'] ?? 'Inactive');

    String profileImage = userData['profileImageUrl'] ?? '';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: 100,
          maxHeight: Get.height * 0.2,
        ),
        child: Container(
    decoration: BoxDecoration(
    color: appcolor.white,
    borderRadius: BorderRadius.circular(12),),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      radius: 30,
                      child: profileImage.isNotEmpty
                          ? CachedNetworkImage(
                        imageUrl: profileImage,
                        httpHeaders: {"Access-Control-Allow-Origin": "*"},
                        fit: BoxFit.cover,
                        width: 60,
                        height: 60,
                        placeholder: (context, url) =>
                            CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            Icon(Icons.person),
                      )
                          : Icon(Icons.person),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Column(mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Name: $name",
                          style: GoogleFonts.urbanist(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: appcolor.black,
                            decoration: TextDecoration.none,
                          ),
                        ),
                        Text(
                          "email: $email",
                          style: GoogleFonts.urbanist(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: Colors.grey,
                            decoration: TextDecoration.none,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Row(
                            children: [
                              Text(
                                "Status: ",
                                style: GoogleFonts.urbanist(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  color: Colors.grey,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                              Obx(
                                    () => Container(
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: status.value == 'Active'
                                        ? appcolor.greenColor
                                        : appcolor.redColor,
                                    borderRadius: BorderRadius.all(Radius.circular(24)),
                                  ),
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                      child: Text(
                                        status.value,
                                        style: GoogleFonts.urbanist(
                                          decoration: TextDecoration.none,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              IconButton(
                                  onPressed: () {
                                    controller.toggleUserStatus(userId, status.value);
                                  },
                                  icon: Icon(
                                    Icons.swap_horiz,
                                    size: 24,
                                    color: appcolor.appColor,
                                  )),
                            ],
                          ),
                        ),
                        // GestureDetector(
                        //   onTap: () {
                        //     showDialog(
                        //       context: context,
                        //       builder: (BuildContext context) {
                        //         return Userdetails(
                        //           userData: userData,
                        //         );
                        //       },
                        //     );
                        //   },
                        //   child: Container(
                        //     decoration: BoxDecoration(
                        //       color: Appcolor.appColor,
                        //       borderRadius: BorderRadius.circular(12),
                        //     ),
                        //     padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        //     child: Text(
                        //       "See Details",
                        //       style: GoogleFonts.urbanist(
                        //         color: Appcolors.white,
                        //         fontSize: 12,
                        //         fontWeight: FontWeight.w600,
                        //         decoration: TextDecoration.none,
                        //       ),
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 25,right: 10),
                child: _buildActionButton(
                  context,
                  "Delete",
                  "assets/images/Bin.png",
                      () => _showDeleteDialog(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, String label, String assetPath, VoidCallback onPressed) {
    return Column(
      children: [
        IconButton(
          onPressed: onPressed,
          icon: Image.asset(
            assetPath,
            height: 25,
            width: 25,
          ),
          color: appcolor.black,
        ),
        Text(
          label,
          style: GoogleFonts.urbanist(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: appcolor.appColor,
            decoration: TextDecoration.none,
          ),
        ),
      ],
    );
  }

  void _showDeleteDialog(BuildContext context) {
    Widget cancelButton = TextButton(
      child: Text(
        "Yes",
        style: GoogleFonts.urbanist(
          fontSize: 20,
          fontWeight: FontWeight.w400,
          color: appcolor.black,
        ),
      ),
      onPressed: () {

        print(userId);
        controller.deleteUser(userId);
        Navigator.of(context).pop();
      },
    );

    Widget continueButton = TextButton(
      child: Text(
        "No",
        style: GoogleFonts.urbanist(
          fontSize: 20,
          fontWeight: FontWeight.w400,
          color: appcolor.black,
        ),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text(
        "Delete Account",
        style: GoogleFonts.urbanist(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: appcolor.black,
        ),
      ),
      content: Text(
        "Are you sure you want to delete this account?",
        style: GoogleFonts.urbanist(
          fontSize: 20,
          fontWeight: FontWeight.w100,
          color: appcolor.black,
        ),
      ),
      actions: [cancelButton, continueButton],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

