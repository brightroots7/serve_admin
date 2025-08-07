import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../shared/Constants/appcolor.dart';
import '../controllers/temples_controller.dart';
import 'addTemple.dart';


class TemplesView extends GetView<TemplesController> {
  TemplesView({super.key, required Map<String, dynamic> templeData});

  @override
  final controller = Get.put(TemplesController());
  final List<String> serviceNames = [
    'Volunteering',
    'Event',
    'Service',
    'Donation'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                Container(
                    height: Get.height * 0.10,
                    alignment: Alignment.center,
                    child: Text(
                      "Temples",
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: appcolor.appColor),
                    )),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: appcolor.appColor),
                      onPressed: () {
                        Get.to(() => AddTempleScreen());
                      },
                      child: const Text(
                        "Add Temple",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600),
                      )),
                )
              ],
            ),
            StreamBuilder<QuerySnapshot>(
              stream: controller.getTemplesStream(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var templeData = snapshot.data!.docs[index].data()
                        as Map<String, dynamic>;
                    GeoPoint location = templeData['lat_lng'] as GeoPoint;
                    String templeId = snapshot.data!.docs[index].id;

                    return templeTile(
                      title: templeData['temple_name'] ?? 'No Name',
                      subtitle:
                          templeData['desc'] ?? 'Description not available',
                      onTap: () => _showTempleDetails(
                          context, templeData, location, templeId),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showTempleDetails(BuildContext context, Map<String, dynamic> templeData,
      GeoPoint location, String templeId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: SizedBox(
          width: double.maxFinite,
          child: ListView(
            children: [
              Text(
                templeData['temple_name'] ?? 'No Name',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 15),
              Text(
                templeData['desc'] ?? 'No description',
                style: GoogleFonts.poppins(
                    fontSize: 20, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Icon(Icons.category, size: 24),
                  SizedBox(width: 5),
                  Text(
                    'Admin Email: ${templeData['temple_admin_email'] ?? 'Unknown'}',
                    style: GoogleFonts.poppins(
                        fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Icon(Icons.category, size: 24),
                  SizedBox(width: 5),
                  Text(
                    'Type: ${templeData['type'] ?? 'Unknown'}',
                    style: GoogleFonts.poppins(
                        fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Icon(
                    templeData['fav_status'] == true
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: Colors.red,
                    size: 24,
                  ),
                  SizedBox(width: 5),
                  Text(
                    'Favorite Status: ${templeData['fav_status'] ?? 'Not set'}',
                    style: GoogleFonts.poppins(
                        fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Icon(Icons.location_on, size: 20),
                  SizedBox(width: 5),
                  Text(
                    'Latitude: ${location.latitude.toStringAsFixed(4)}\n'
                    'Longitude: ${location.longitude.toStringAsFixed(4)}',
                    style: GoogleFonts.poppins(
                        fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              SizedBox(height: 10),
              if (templeData['photos'] != null &&
                  (templeData['photos'] as List).isNotEmpty)
                SizedBox(
                  height: 150,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: (templeData['photos'] as List).length,
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: kIsWeb
                          ? Image.network(templeData['photos'][index])
                          : CachedNetworkImage(
                              imageUrl: templeData['photos'][index],
                              placeholder: (context, url) =>
                                  CircularProgressIndicator(),
                              errorWidget: (context, url, error) {
                                print(
                                    'Error loading image: $error'); // Log the error message
                                return Icon(Icons.error);
                              },
                              width: 200,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                ),
              SizedBox(height: 15),
              Text(
                templeData['desc'] ?? 'No description',
                style: GoogleFonts.poppins(
                    fontSize: 20, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 20),
              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 6.0,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                ),
                itemCount: serviceNames.length,
                itemBuilder: (context, index) => GestureDetector(
                  onTap: () {
                    _showServiceDetails(context, serviceNames[index], templeId);
                  },
                  child: Container(
                    height: Get.height *
                        0.2, // Set a relative height based on screen height
                    width: Get.width * 0.4,
                    decoration: BoxDecoration(
                      color: appcolor.appColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        serviceNames[index],
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close', style: TextStyle(color: appcolor.redColor)),
          ),
        ],
      ),
    );
  }

  void _showServiceDetails(
      BuildContext context, String serviceName, String templeId) {
    switch (serviceName) {
      case 'Donation':
        _showDonationDetails(context, templeId);
        break;
      case 'Event':
        _showEventDetails(context, templeId);
        break;
      case 'Volunteering':
        _showVolunteeringDetails(context, templeId);
        break;
      case 'Service':
        _showServiceDetailsPage(context, templeId);
        break;
    }
  }


  void _showDonationDetails(BuildContext context, String templeId) {
    controller.getDonations(templeId).listen((snapshot) {
      if (snapshot.docs.isEmpty) {

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Donations"),
            content: Center(
              child: Text(
                "No donations available.",
                style: GoogleFonts.poppins(
                    fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child:
                    Text('Close', style: TextStyle(color: appcolor.redColor)),
              ),
            ],
          ),
        );
      } else {
        List<Widget> donationList = snapshot.docs.map((doc) {
          var data = doc.data() as Map<String, dynamic>;
          return ListTile(
            title: Text(
              data['eventName'],
              style: GoogleFonts.poppins(
                  fontSize: 18, fontWeight: FontWeight.w500),
            ),
            subtitle: Text(
              'Amount: ${data['amount']}',
              style: GoogleFonts.poppins(
                  fontSize: 18, fontWeight: FontWeight.w500),
            ),
          );
        }).toList();

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Donations"),
            content: Column(
              children: donationList,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child:
                    Text('Close', style: TextStyle(color: appcolor.redColor)),
              ),
            ],
          ),
        );
      }
    });
  }

// Show Events details
  void _showEventDetails(BuildContext context, String templeId) {
    controller.getEvents(templeId).listen((snapshot) {
      if (snapshot.docs.isEmpty) {
        // If no events are found, show a message and reduce the box size
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Events"),
            content: Center(
              child: Text(
                "No events available.",
                style: GoogleFonts.poppins(
                    fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child:
                    Text('Close', style: TextStyle(color: appcolor.redColor)),
              ),
            ],
          ),
        );
      } else {
        List<Widget> eventList = snapshot.docs.map((doc) {
          var data = doc.data() as Map<String, dynamic>;
          return ListTile(
            title: Text(
              data['eventName'],
              style: GoogleFonts.poppins(
                  fontSize: 18, fontWeight: FontWeight.w500),
            ),
            subtitle: Text(
              'Festival: ${data['festivalName']}',
              style: GoogleFonts.poppins(
                  fontSize: 18, fontWeight: FontWeight.w500),
            ),
          );
        }).toList();

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Events"),
            content: Column(
              children: eventList,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child:
                    Text('Close', style: TextStyle(color: appcolor.redColor)),
              ),
            ],
          ),
        );
      }
    });
  }

// Show Volunteering details
  void _showVolunteeringDetails(BuildContext context, String templeId) {
    controller.getVolunteeringRequests(templeId).listen((snapshot) {
      if (snapshot.docs.isEmpty) {
        // If no volunteering requests are found, show a message and reduce the box size
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Volunteering Requests"),
            content: Center(
              child: Text(
                "No volunteering requests available.",
                style: GoogleFonts.poppins(
                    fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child:
                    Text('Close', style: TextStyle(color: appcolor.redColor)),
              ),
            ],
          ),
        );
      } else {
        List<Widget> volunteeringList = snapshot.docs.map((doc) {
          var data = doc.data() as Map<String, dynamic>;
          return ListTile(
            title: Text(
              data['eventName'],
              style: GoogleFonts.poppins(
                  fontSize: 18, fontWeight: FontWeight.w500),
            ),
            subtitle: Text(
              'Username: ${data['username']}',
              style: GoogleFonts.poppins(
                  fontSize: 18, fontWeight: FontWeight.w500),
            ),
          );
        }).toList();

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Volunteering Requests"),
            content: Column(
              children: volunteeringList,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child:
                    Text('Close', style: TextStyle(color: appcolor.redColor)),
              ),
            ],
          ),
        );
      }
    });
  }

// Show Services details
  void _showServiceDetailsPage(BuildContext context, String templeId) {
    controller.getServices(templeId).listen((snapshot) {
      if (snapshot.docs.isEmpty) {
        // If no services are found, show a message and reduce the box size
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Services"),
            content: Center(
              child: Text(
                "No services available.",
                style: GoogleFonts.poppins(
                    fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child:
                    Text('Close', style: TextStyle(color: appcolor.redColor)),
              ),
            ],
          ),
        );
      } else {
        List<Widget> serviceList = snapshot.docs.map((doc) {
          var data = doc.data() as Map<String, dynamic>;
          return ListTile(
            title: Text(
              data['serviceName'],
              style: GoogleFonts.poppins(
                  fontSize: 18, fontWeight: FontWeight.w500),
            ),
            subtitle: Text(
              'Description: ${data['serviceDesciption']}',
              style: GoogleFonts.poppins(
                  fontSize: 18, fontWeight: FontWeight.w500),
            ),
          );
        }).toList();

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Services"),
            content: Column(
              children: serviceList,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child:
                    Text('Close', style: TextStyle(color: appcolor.redColor)),
              ),
            ],
          ),
        );
      }
    });
  }
}

class templeTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const templeTile({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.onTap,
  }) : super(key: key);

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
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.grey,
        ),
        onTap: onTap,
      ),
    );
  }
}
