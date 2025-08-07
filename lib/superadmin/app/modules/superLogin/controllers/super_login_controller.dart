import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../Home.dart';

class SuperLoginController extends GetxController {

  RxBool isLoading = false.obs;

  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> login(String email, String password) async {
    isLoading(true);

    try {

      QuerySnapshot querySnapshot = await _firestore
          .collection('admin')
          .where('email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isEmpty) {

        Get.snackbar("Error", "No user found with this email.");
        return;
      }

      // Get the first document (assuming email is unique)
      DocumentSnapshot userDoc = querySnapshot.docs.first;
      String storedPassword = userDoc['password'];

      if (storedPassword == password) {

        String role = userDoc['role'];

        print("Login successful! Role: $role");

        var templeData = querySnapshot.docs.first.data() as Map<String, dynamic>;
        Get.to(() => HomeView(templeData:templeData,));
      } else {

        Get.snackbar("Error", "Incorrect password.");
      }
    } catch (e) {
      print("Login failed: $e");
      Get.snackbar("Error", "An error occurred while logging in. Please try again.");
    } finally {
      isLoading(false); // Set loading to false after login attempt
    }
  }
}
