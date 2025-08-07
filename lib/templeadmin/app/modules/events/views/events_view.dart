import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../../shared/Constants/Appcolors.dart';
import '../controllers/events_controller.dart';
import 'addEvent.dart';

class EventsView extends GetView<EventsController> {
  final String templeId;
  EventsView({super.key, required this.templeId});
  @override
  final controller = Get.put(EventsController());

  @override
  Widget build(BuildContext context) {
    print("Current templeId in ServiceView: $templeId");
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [

            Container(
              height: Get.height * 0.10,
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  Text(
                    "Events",
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Appcolor.appColor),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Appcolor.appColor),
                        onPressed: () {
                          Get.to(() => AddEventsScreen(
                                templeId: templeId,
                              ));
                        },
                        child: const Text(
                          "Add Event",
                          style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.w600),
                        )),
                  )
                ],
              ),
            ),

        StreamBuilder<QuerySnapshot>(
          stream: controller.getEvents(templeId),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              print("Error: ${snapshot.error}");  // Print error to the console
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.connectionState == ConnectionState.active || snapshot.connectionState == ConnectionState.done) {
              if (snapshot.data?.docs.isEmpty ?? true) {
                return Center(child: Text('No temples available.'));
              }

              return ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var eventData = snapshot.data!.docs[index].data() as Map<String, dynamic>;
                  String templeName = eventData['eventName'] ?? 'No Name';
                  String festivalName = eventData['festivalName'] ?? ' Not available';
                  var timestamp = eventData['date_time'];
                  String formattedDate = timestamp != null
                      ? DateFormat('yyyy-MM-dd').format(timestamp.toDate())
                      : 'Not available';


                  String eventId = snapshot.data!.docs[index].id;

                  return EventsTile(
                    title: templeName,
                    subtitle: festivalName,
                      date: formattedDate,
                    eventId: eventId,
                    onTap: () {

                    },
                  );
                },
              );
            }
            return SizedBox(); // Handle if the state is not managed
          },
        ),

        ],
        ),
      ),
    );
  }
}

class EventsTile extends StatelessWidget {
  final String eventId; // Add eventId to the tile
  final String title;
   final String subtitle;
   final String date;
  final VoidCallback onTap;

  EventsTile({
    Key? key,
    required this.eventId, // Accept eventId as a parameter
    required this.title,
    required this.subtitle,
    required this.onTap, required this.date,
  }) : super(key: key);

  final controller = Get.put(EventsController());

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        leading: Icon(
          Icons.temple_buddhist,
          color: Colors.orange,
          size: 32,
        ),
        title: Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              subtitle,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey[600],
              ),

            ),
            Text(
              date,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey[600],
              ),

            ),
          ],
        ),
        trailing: IconButton(
          color: Colors.red,
          onPressed: () =>
              _showDeleteDialog(context, eventId), // Pass eventId to delete
          icon: Icon(
            Icons.delete,
            size: 16,
          ),
        ),
        onTap: onTap,
      ),
    );
  }

  // Show the delete confirmation dialog
  void _showDeleteDialog(BuildContext context, String eventId) {
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
        // Call the delete method with eventId
        controller.deleteEvent(eventId);
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
        "Delete Event",
        style: GoogleFonts.urbanist(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Appcolors.black,
        ),
      ),
      content: Text(
        "Are you sure you want to delete this event?",
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
