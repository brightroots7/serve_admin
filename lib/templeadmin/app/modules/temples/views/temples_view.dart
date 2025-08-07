import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../shared/Constants/Appcolors.dart';
import '../controllers/temples_controller.dart';

class TemplesView extends GetView<TemplesController> {
  final Map<String, dynamic> templeData;
  TemplesView({super.key, required this.templeData});

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
    final GeoPoint location = templeData['lat_lng'] as GeoPoint;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        color: Appcolor.appColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Temple Details",
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 24),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Temple Name: ${templeData['temple_name']}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Description: ${templeData['desc']}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500,),
              ),
            ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Temple Email: ${templeData['temple_admin_email']}',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
        ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Type: ${templeData['type']}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Average Rating: ${templeData['avg_rating']}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Favorite Status: ${templeData['fav_status']}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Location: ${location.latitude}, ${location.longitude}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
            ),
            if (templeData['photos'] != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: const Text(
                      'Photos:',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                  ),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 4,
                      mainAxisSpacing: 4,
                    ),
                    itemCount: templeData['photos'].length,
                    itemBuilder: (context, index) => Image.network(
                      templeData['photos'][index],
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
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
