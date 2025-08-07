import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class AllusersController extends GetxController {
  final _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var currentUserId = ''.obs;
  var user = Rx<Map<String, dynamic>>({});
  var fieldEntries = <Map<String, dynamic>>[].obs;
  var expandedStates = <String, RxBool>{}.obs;
  var isLoading = true.obs;
  @override
  void onInit() {
    super.onInit();
    fetchUsers();
    String? uid = _auth.currentUser?.uid;
    if (uid != null && uid.isNotEmpty) {}
  }

  Future<void> toggleUserStatus(String userId, String currentStatus) async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        String newStatus = currentStatus == 'Active' ? 'Inactive' : 'Active';

        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .update({
          'status': newStatus,
        });

        Get.snackbar(
          'Success',
          'User status updated to $newStatus successfully.',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar('Error', 'User document does not exist.');
      }
    } catch (e) {
      print('Error toggling user status: $e');
      Get.snackbar('Error', 'Failed to update user status: $e');
    }
  }

  Future<void> deleteUser(String uid) async {
    try {
      // Ensure the logged-in user is not deleting themselves
      if (_auth.currentUser != null && _auth.currentUser!.uid == uid) {
        Get.snackbar("Error", "You cannot delete the currently logged-in user.");
        return;
      }


      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (userDoc.exists) {

        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          await user.delete();

          await FirebaseFirestore.instance.collection('users').doc(uid).delete();

          print("User with UID $uid has been deleted successfully.");
          Get.snackbar('Success', 'User deleted successfully.');
        } else {
          Get.snackbar('Error', 'No authenticated user found.');
        }
      } else {
        Get.snackbar('Error', 'User not found.');
      }
    } catch (e) {
      print("Error deleting user: $e");
      Get.snackbar('Error', 'Failed to delete user.');
    }
  }

  var users = <Map<String, dynamic>>[].obs; // List of user data


  // Fetch users from Firestore
  Future<void> fetchUsers() async {
    try {
      // Fetch all users from the 'users' collection
      QuerySnapshot querySnapshot = await _firestore.collection('users').get();

      // Map the documents to a list of maps
      users.value = querySnapshot.docs.map((doc) {
        return {
          'display_name': doc['display_name'],
          'email': doc['email'],
        };
      }).toList();

    } catch (e) {
      print("Error fetching users: $e");
    }
  }



  Future<void> fetchUserDetails(String uid) async {
    if (uid.isNotEmpty) {
      try {
        isLoading.value = true;
        DocumentSnapshot userDoc =
            await FirebaseFirestore.instance.collection('users').doc(uid).get();

        if (userDoc.exists) {
          user.value = userDoc.data() as Map<String, dynamic>;
        } else {
          Get.snackbar('Error', 'User not found.');
        }
      } catch (e) {
        print('Error fetching user details: $e');
        Get.snackbar('Error', 'Failed to fetch user details.');
      } finally {
        isLoading.value = false; // Set loading to false when done
      }
    }


    void handleErrorResponse(http.Response response) {
      if (response.statusCode == 404) {
        Get.snackbar("Error", "Requested resource not found (404)");
      } else {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse["message"] != null) {
          Get.snackbar("Error", jsonResponse["message"]);
        } else {
          Get.snackbar("Error", "Something went wrong");
        }
        print('Error response body: ${response.body}');
      }
    }
  }



  void toggleExpansion(String key) {
    if (!expandedStates.containsKey(key)) {
      expandedStates[key] = false.obs;
    }
    expandedStates[key]!.toggle();
  }
}
