import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class EventsController extends GetxController{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<QuerySnapshot> getEvents(String templeId) {
    print("Fetching events for temple ID: $templeId"); // Debug print
    return _firestore
        .collection('events')
        .where('templeId', isEqualTo: templeId) // Add trim for safety
        .snapshots();
  }

  Future<void> deleteEvent(String eventId) async {
    try {
      // Fetch event document
      DocumentSnapshot eventDoc = await _firestore.collection('events').doc(eventId).get();

      if (eventDoc.exists) {
        // Delete the event from Firestore
        await _firestore.collection('events').doc(eventId).delete();
        Get.snackbar('Success', 'Event deleted successfully');
      } else {
        Get.snackbar('Error', 'Event not found');
      }
    } catch (e) {
      print("Error deleting event: $e");
      Get.snackbar('Error', 'Failed to delete event');
    }
  }
}