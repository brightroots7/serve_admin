import 'package:admin/superadmin/app/modules/profile/views/profile_view.dart';
import 'package:admin/superadmin/app/modules/superLogin/views/super_login_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../main.dart';
import '../../../superadmin//app/modules/temples/views/temples_view.dart';
import '../../shared/Constants/appcolor.dart';
import 'allusers/views/allusers_view.dart';

class HomeView extends StatefulWidget {
  final Map<String, dynamic> templeData;
  const HomeView({super.key, required this.templeData});

  @override
  HomeViewState createState() => HomeViewState();
}

class HomeViewState extends State<HomeView> {
  int _selectedScreenIndex = 0;
  bool _isDrawerOpen = false;

  late List<Widget> _screens;
  @override
  void initState() {
    super.initState();

   _screens = [
      TemplesView(
        templeData: widget.templeData,
      ),
      AllusersView(),
     // ProfileView(),
    ];
  }

  void _selectScreen(int index) {
    setState(() {
      _selectedScreenIndex = index;
    });
  }

  void toggleDrawer() {
    setState(() {
      _isDrawerOpen = !_isDrawerOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appcolor.appColor,
      appBar: _isDrawerOpen
          ? null
          : AppBar(
              elevation: 0,
              automaticallyImplyLeading: false,
              backgroundColor: appcolor.white,
              leading: InkWell(
                onTap: toggleDrawer,
                child: Transform.flip(
                  flipX: true,
                  child: Image.asset(
                    "assets/images/drawer.webp",
                    height: 25,
                    width: 25,
                    color: appcolor.black,
                  ),
                ),
              ),
            ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              Row(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 50),
                    width: _isDrawerOpen ? 260 : 0,
                    child: _isDrawerOpen
                        ? Drawer(
                            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                            backgroundColor: appcolor.white,
                            child: ListView(
                              padding: EdgeInsets.zero,
                              children: <Widget>[
                                Container(
                                  height: 150,
                                  child: DrawerHeader(
                                    decoration: BoxDecoration(
                                      color: appcolor.white,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        InkWell(
                                          onTap: toggleDrawer,
                                          child: Image.asset(
                                            "assets/images/drawer.webp",
                                            height: 25,
                                            width: 25,
                                          ),
                                        ),
                                        const Spacer(),
                                        ConstrainedBox(
                                          constraints: const BoxConstraints(minWidth: 0, maxWidth: 260),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Serve App",
                                                style: GoogleFonts.urbanist(
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.w600,
                                                  color: appcolor.appColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                _buildDrawerItem(
                                    'Temples', 'assets/images/Temple.png', 0),
                                _buildDrawerItem(
                                    'Users', 'assets/images/allusers.png', 1),
                                // _buildDrawerItem(
                                //     'Profile', 'assets/images/profile.png', 2),
                                _buildLogoutItem(),
                              ],
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                  Expanded(
                    child: Container(
                      child: _screens[_selectedScreenIndex],
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDrawerItem(String title, String asset, int index) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        tileColor:
            _selectedScreenIndex == index ? appcolor.appColor : appcolor.white,
        leading: Image.asset(
          asset,
          height: 25,
          width: 25,
          color: _selectedScreenIndex == index
              ? appcolor.white
              : appcolor.appColor,
        ),
        title: Text(
          title,
          style: GoogleFonts.urbanist(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: _selectedScreenIndex == index
                ? appcolor.white
                : appcolor.appColor,
          ),
        ),
        onTap: () => _selectScreen(index),
      ),
    );
  }

  Widget _buildLogoutItem() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        tileColor:
            _selectedScreenIndex == 3 ? appcolor.appColor : appcolor.white,
        leading: Image.asset(
          "assets/images/logout.png",
          height: 25,
          width: 25,
          color:
              _selectedScreenIndex == 3 ? appcolor.white : appcolor.appColor,
        ),
        title: Text(
          'Log out',
          style: GoogleFonts.urbanist(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color:
                _selectedScreenIndex == 3 ? appcolor.white : appcolor.appColor,
          ),
        ),
        onTap: (){ _showLogoutDialog();},
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Are you sure you want to log out?"),
          content: Text(
            "",
            style: TextStyle(fontSize: 24),
          ),
          actions: <Widget>[
            TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  "No",
                  style: GoogleFonts.urbanist(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: appcolor.redColor),
                )),
            TextButton(
              onPressed: () => Get.offAll(() => SelectionView()),
              child: Text(
                "Yes",
                style: GoogleFonts.urbanist(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
