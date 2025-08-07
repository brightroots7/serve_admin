import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../shared/Constants/appcolor.dart';
import '../controllers/allusers_controller.dart';

class Userdetails extends StatefulWidget {
  final Map<String, dynamic> userData;

  const Userdetails({super.key, required this.userData});

  @override
  State<Userdetails> createState() => _UserdetailsState();
}

class _UserdetailsState extends State<Userdetails> {
  final AllusersController controller = Get.put(AllusersController());

  @override
  void initState() {
    super.initState();

    final userId = widget.userData['uid'];
    controller.fetchUserDetails(userId);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(21, 61, 100, 1),
        title:
            const Text(' User Detail', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        toolbarHeight: 100,
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: [
                  BoxShadow(color: Colors.grey.shade300, blurRadius: 5)
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(
                     widget.userData['profileImageUrl'] ?? '',
                    ),
                  ),

                ],
              ),
            ),

          ],
        ),
      )),
    );
  }


  }



