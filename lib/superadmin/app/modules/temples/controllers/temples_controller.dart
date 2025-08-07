import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class TemplesController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;




  Stream<QuerySnapshot> getTemplesStream() {
    return _firestore.collection('temples').snapshots();

  }

  // Function to get Donations for a particular temple
  Stream<QuerySnapshot> getDonations(String templeId) {
    return _firestore
        .collection('donations')
        .where('templeId', isEqualTo: templeId)
        .snapshots();
  }

  // Function to get Events for a particular temple
  Stream<QuerySnapshot> getEvents(String templeId) {
    return _firestore
        .collection('events')
        .where('templeId', isEqualTo: templeId)
        .snapshots();
  }

  // Function to get Volunteering Requests for a particular temple
  Stream<QuerySnapshot> getVolunteeringRequests(String templeId) {
    return _firestore
        .collection('volunteering request')
        .where('templeId', isEqualTo: templeId)
        .snapshots();
  }

  // Function to get Services for a particular temple
  Stream<QuerySnapshot> getServices(String templeId) {
    return _firestore
        .collection('services')
        .where('templeId', isEqualTo: templeId)
        .snapshots();
  }

  // Function to get Temple Details
  Stream<DocumentSnapshot> getTempleDetails(String templeId) {
    return _firestore.collection('temples').doc(templeId).snapshots();
  }
}
