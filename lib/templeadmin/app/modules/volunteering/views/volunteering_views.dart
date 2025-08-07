import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../shared/Constants/Appcolors.dart';
import '../controllers/voluteering_controllers.dart';

class VolunteeringViews extends GetView<VoluteeringControllers>{
  final String templeId;



 VolunteeringViews({super.key, required this.templeId});
  final controller = Get.put(VoluteeringControllers());
  @override
  Widget build(BuildContext context) {
    print("Current templeId in Volunteering  View: $templeId");
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
                    "Voluteering Request",
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
              stream: controller.getVolunteeringRequests(templeId),
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
                    return Center(child: Text('No Request available.'));
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var volunteeringData = snapshot.data!.docs[index].data()
                      as Map<String, dynamic>;
                      String Name = volunteeringData['username'] ?? 'No Name';
                      String eventName = volunteeringData['eventName'] ??
                          'Events not available';
                      String status = volunteeringData['status'] ?? 'Requested';
                      String eventId = snapshot.data!.docs[index].id;

                      return VolunteeringTile(
                        title: Name,
                        subtitle: eventName,
                        status: status,
                        onAccept: () {
                          controller.updateRequestStatus(eventId, 'Accepted');
                        },
                        onDecline: () {
                          controller.updateRequestStatus(eventId, 'Declined');
                        },
                        onTap: () {

                        },
                        eventId: eventId,
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

class VolunteeringTile extends StatelessWidget {
  final String eventId; // Add eventId to the tile
  final String title;
  final String subtitle;
  final String status;
  final VoidCallback onTap;
  final Function onAccept;
  final Function onDecline;

  VolunteeringTile({
    Key? key,
    required this.eventId, // Accept eventId as a parameter
    required this.title,
    required this.subtitle,
    required this.onTap, required this.status,
    required this.onAccept,
    required this.onDecline,
  }) : super(key: key);

  final controller = Get.put(VoluteeringControllers());

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        leading: Icon(
          Icons.handshake_outlined,
          color: Colors.blue,
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
        trailing: status == 'Requested'
            ? Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Requested',
              style: TextStyle(
                  color: Colors.orange, fontWeight: FontWeight.w600),
            ),
            IconButton(
              icon: Icon(Icons.check, color: Colors.green),
              onPressed: () => onAccept(),
            ),
            IconButton(
              icon: Icon(Icons.close, color: Colors.red),
              onPressed: () => onDecline(),
            ),
          ],
        )
            : Text(
          status,
          style: TextStyle(color: status == 'Accepted' ? Colors.green : Colors.red),
        ),
        onTap: onTap,
      ),
    );
  }
}


