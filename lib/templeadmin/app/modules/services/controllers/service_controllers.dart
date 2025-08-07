import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class ServiceControllers extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Stream<QuerySnapshot> getServices(String templeId) {
    print("Fetching services for temple ID: $templeId"); // Debug print
    return _firestore
        .collection('services')
        .where('templeId', isEqualTo: templeId) // Add trim for safety
        .snapshots();
  }

  // Delete a specific event by ID
  Future<void> deleteService(String serviceId) async {
    try {
      // Fetch event document
      DocumentSnapshot eventDoc = await _firestore.collection('services').doc(serviceId).get();

      if (eventDoc.exists) {
        // Delete the event from Firestore
        await _firestore.collection('services').doc(serviceId).delete();
        Get.snackbar('Success', 'Service deleted successfully');
      } else {
        Get.snackbar('Error', 'Service not found');
      }
    } catch (e) {
      print("Error deleting service: $e");
      Get.snackbar('Error', 'Failed to delete service');
    }
  }
}