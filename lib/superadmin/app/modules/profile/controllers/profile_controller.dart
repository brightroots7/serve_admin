import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class ProfileController extends GetxController {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var admin = Rx<Map<String, dynamic>>({});
  RxBool isLoading = true.obs;
  var adminId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _listenToAuthState();
  }

  // Listen to authentication state changes
  void _listenToAuthState() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        adminId.value = user.uid;
        fetchAdminData();  // Fetch admin data after user is authenticated
      } else {
      //  Get.snackbar('Error', 'User not authenticated.');
        isLoading.value = false;
      }
    });
  }

  Future<void> fetchAdminData() async {
    User? user = FirebaseAuth.instance.currentUser;
    print('Current user UID: ${user?.uid}');  // Debugging line

    if (user != null && user.uid.isNotEmpty) {
      try {
        isLoading.value = true;
        DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('admin').doc(user.uid).get();

        if (userDoc.exists) {
          admin.value = userDoc.data() as Map<String, dynamic>;
        } else {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Get.snackbar('Error', 'Admin not found.');
          });
        }
      } catch (e) {
        print('Error fetching admin data: $e');
        WidgetsBinding.instance.addPostFrameCallback((_) {
         Get.snackbar('Error', 'Failed to fetch admin data.');
        });
      } finally {
        isLoading.value = false;
      }
    }
  }

  Future<void> updateAdminData(Map<String, dynamic> updatedData) async {
    try {
      await _firestore
          .collection('admin')
          .doc(adminId.value)
          .update(updatedData);
      Get.snackbar('Success', 'Profile updated successfully');
      fetchAdminData(); // Refresh data
    } catch (e) {
      Get.snackbar('Error', 'Failed to update profile');
    }
  }
}
