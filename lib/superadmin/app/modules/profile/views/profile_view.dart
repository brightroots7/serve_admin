import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../shared/Constants/appcolor.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  ProfileView({super.key});

  final controller = Get.put(ProfileController()); // Initialize the controller
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
              height: Get.height * 0.10,
              alignment: Alignment.center,
              child: Text(
                "Admin Profile",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: appcolor.appColor),
              )),
          Obx(() {
            // If loading, show a loading indicator
            if (controller.isLoading.value) {
              return Center(child: CircularProgressIndicator());
            }

            final adminData = controller.admin.value; // Access admin data
            if (adminData.isEmpty) {
              return Center(child: Text('No admin data found'));
            }

            // Display admin profile data
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildProfileItem('Email:', adminData['email'] ?? 'N/A'),
                      _buildProfileItem('Role:', adminData['role'] ?? 'N/A'),
                      SizedBox(height: 20),
                      Center(
                        child: ElevatedButton(
                          onPressed: () => _showEditDialog(adminData),
                          child: Text('Edit Profile'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  // Utility widget to display profile items
  Widget _buildProfileItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          SizedBox(width: 10),
          Text(
            value,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  // Function to show the edit dialog for editing admin profile
  void _showEditDialog(Map<String, dynamic> currentData) {
    TextEditingController nameController =
        TextEditingController(text: currentData['name'] ?? '');
    TextEditingController phoneController =
        TextEditingController(text: currentData['phone'] ?? '');

    Get.dialog(
      AlertDialog(
        title: Text('Edit Profile'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: phoneController,
              decoration: InputDecoration(labelText: 'Phone'),
              keyboardType: TextInputType.phone,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              controller.updateAdminData({
                'name': nameController.text,
                'phone': phoneController.text,
              });
              Get.back();
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }
}
