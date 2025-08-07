import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../shared/Constants/Appcolors.dart';
import '../controllers/donations_controllers.dart';

class DonationsView extends GetView<DonationsControllers> {
  final String templeId;
 DonationsView({super.key, required this.templeId});
  final controller = Get.put(DonationsControllers());

  @override
  Widget build(BuildContext context) {
    print("Current templeId in DonationView: $templeId");
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header section
            Container(
              height: Get.height * 0.10,
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  Text(
                    "Donations",
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Appcolor.appColor),
                  ),

                ],
              ),
            ),
            // StreamBuilder to fetch services from Firestore
            StreamBuilder<QuerySnapshot>(
              stream: controller.getDonations(templeId),
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
                    return Center(child: Text('No Donations available.'));
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var donationData = snapshot.data!.docs[index].data()
                      as Map<String, dynamic>;
                      String name = donationData['user_name'] ??'No name';
                      String eventName = donationData['eventName'] ?? 'No available';
                      String amount = donationData['amount'] ??
                          'Donations not available';
                      String eventId = snapshot.data!.docs[index].id;

                      return DonationTile(
                        title: eventName,
                        subtitle: amount,
                        onTap: () {
                          // Add your onTap logic here
                        },
                        eventId: eventId, name: name,
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

class DonationTile extends StatelessWidget {
  final String eventId; // Add eventId to the tile
  final String title;
  final String subtitle;
  final String name;
  final VoidCallback onTap;

  DonationTile({
    Key? key,
    required this.eventId, // Accept eventId as a parameter
    required this.title,
    required this.subtitle,
    required this.onTap, required this.name,
  }) : super(key: key);

  final controller = Get.put(DonationsControllers());

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        leading: Icon(
          Icons.monetization_on_outlined,
          color: Colors.green,
          size: 32,
        ),
        title: Text(
          name,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            Text(
              subtitle,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),

        onTap: onTap,
      ),
    );
  }


}
