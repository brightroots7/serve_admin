import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/allusers_controller.dart';
import '../../../../shared/Constants/appcolor.dart';
import '../../../../shared/Constants/usertile.dart';

class AllusersView extends GetView<AllusersController> {
  AllusersView({super.key});

  @override
  final controller = Get.put(AllusersController());

  @override
  Widget build(BuildContext context) {
    return Container( color: appcolor.bgColor,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(18),
            child: Text(
              "All Users",
              style: GoogleFonts.urbanist(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: appcolor.black,
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance.collection('users').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text("No users found"));
                }

                return ListView.builder(
                  padding: EdgeInsets.only(bottom: 20),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final doc = snapshot.data!.docs[index];
                    return Usertile(
                      userData: doc.data(),
                      userId: doc.id,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
