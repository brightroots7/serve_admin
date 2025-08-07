import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class DonationsControllers extends GetxController{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Stream<QuerySnapshot> getDonations(String templeId) {
    print("Fetching donations for temple ID: $templeId"); // Debug print
    return _firestore
        .collection('donations')
        .where('templeId', isEqualTo: templeId) // Add trim for safety
        .snapshots();
  }

}