import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../../Home.dart';

class LoginController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  RxBool isLoading = false.obs;

  Future<Map<String, dynamic>?> loginAdmin(String email, String password) async {
    try {
      isLoading.value = true;

      // 1. Find admin with matching credentials
      final adminQuery = await _firestore
          .collection('temple_admin')
          .where('email', isEqualTo: email.trim())
          .where('password', isEqualTo: password.trim())
          .limit(1)
          .get();

      if (adminQuery.docs.isEmpty) {
        Get.snackbar('Error', 'Invalid credentials');
        return null;
      }

      // 2. Get the temple ID (trim whitespace)
      final adminData = adminQuery.docs.first.data();
      final templeId = adminData['templeId'].toString().trim();

      // 3. Get temple document directly using document ID
      final templeDoc = await _firestore.collection('temples').doc(templeId).get();

      if (!templeDoc.exists) {
        Get.snackbar('Error', 'Temple not found for ID: $templeId');
        return null;
      }

      // 4. Pass data to view
      final templeData = templeDoc.data()!;
      Get.to(() => HomeView(templeData: templeData, templeId: templeId,));

      return templeData;
    } catch (e) {
      Get.snackbar('Error', 'Login failed: ${e.toString()}');
      return null;
    } finally {
      isLoading.value = false;
    }
  }
}