import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class VoluteeringControllers extends GetxController{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Stream<QuerySnapshot> getVolunteeringRequests(String templeId) {
    print("Fetching Volunteering for temple ID: $templeId"); // Debug print
    return _firestore
        .collection('volunteering requests')
        .where('templeId', isEqualTo: templeId) // Add trim for safety
        .snapshots();
  }
  Future<void> updateRequestStatus(String eventId, String status) async {
    try {
      await _firestore
          .collection('volunteering requests')
          .doc(eventId) // Document reference by eventId
          .update({'status': status});
      print("Request status updated to: $status");
    } catch (e) {
      print("Error updating request status: $e");
    }
  }
}