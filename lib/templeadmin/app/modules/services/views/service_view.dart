import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../shared/Constants/Appcolors.dart';
import '../controllers/service_controllers.dart';
import 'addServices.dart';

class ServiceView extends GetView<ServiceControllers> {
  final String templeId;
  ServiceView({super.key, required this.templeId});
  final controller = Get.put(ServiceControllers());

  @override
  Widget build(BuildContext context) {
    print("Current templeId in ServiceView: $templeId");
    return Scaffold(

      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header section
            Row(mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Spacer(),
                Container(
                  height: Get.height * 0.10,
                  alignment: Alignment.center,
                  child: Text(
                    "Services",
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Appcolor.appColor),
                  ),
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Appcolor.appColor),
                      onPressed: () {
                        Get.to(() => AddServiceScreen(
                          templeId: templeId,
                        ));
                      },
                      child: Text(
                        "Add Service",
                        style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.w600),
                      )),
                )
              ],
            ),
            // StreamBuilder to fetch services from Firestore
            StreamBuilder<QuerySnapshot>(
              stream: controller.getServices(templeId),
              builder: (context, snapshot) {
                // Handle different states of the stream
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.connectionState == ConnectionState.active ||
                    snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.data?.docs.isEmpty ?? true) {
                    return Center(child: Text('No services available.'));
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var serviceData = snapshot.data!.docs[index].data()
                          as Map<String, dynamic>;
                      String serviceName =
                          serviceData['serviceName'] ?? 'No Name';
                      String serviceDescription =
                          serviceData['serviceDesciption'] ??
                              'Description not available';
                      String serviceId = snapshot.data!.docs[index].id;
                      return ServiceTile(
                        title: serviceName,
                        subtitle: serviceDescription,
                        onTap: () {
                          // Add your onTap logic here
                        }, serviceId: serviceId,
                      );
                    },
                  );
                }
                return SizedBox(); // In case the state is not handled
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ServiceTile extends StatelessWidget {
  final String serviceId;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

 ServiceTile({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.onTap, required this.serviceId,
  }) : super(key: key);

  final controller = Get.put(ServiceControllers());
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        leading: Icon(
          Icons.temple_buddhist, // You can change this icon to match your theme
          color: Colors.orange, // Customize the icon color
          size: 32,
        ),
        title: Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        trailing: IconButton(
          color: Colors.red,
          onPressed: () =>
            _showDeleteDialog(context,serviceId),
          icon: Icon(
            Icons.delete,
            size: 16,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
  void _showDeleteDialog(BuildContext context, String serviceId) {
    Widget cancelButton = TextButton(
      child: Text(
        "Yes",
        style: GoogleFonts.urbanist(
          fontSize: 20,
          fontWeight: FontWeight.w400,
          color: Appcolors.black,
        ),
      ),
      onPressed: () {

        print;
        controller.deleteService(serviceId);
        Navigator.of(context).pop();
      },
    );

    Widget continueButton = TextButton(
      child: Text(
        "No",
        style: GoogleFonts.urbanist(
          fontSize: 20,
          fontWeight: FontWeight.w400,
          color: Appcolors.black,
        ),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text(
        "Delete Account",
        style: GoogleFonts.urbanist(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Appcolors.black,
        ),
      ),
      content: Text(
        "Are you sure you want to delete this account?",
        style: GoogleFonts.urbanist(
          fontSize: 20,
          fontWeight: FontWeight.w100,
          color: Appcolors.black,
        ),
      ),
      actions: [cancelButton, continueButton],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
