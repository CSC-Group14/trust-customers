import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trust/screens/profile_picture.dart';
import 'package:trust/screens/profile_screen.dart';
import 'package:trust/screens/order_history_screen.dart';
import 'package:trust/screens/settings_screen.dart';
import 'package:trust/screens/map_screen.dart'; // Import the MapScreen

class CustomerDashboard extends StatelessWidget {
  final Color themeColor;
  final Function(Color) updateTheme;
  final Function(String) updateLanguage;
  final Function(String) updateFontStyle;
  final Function(double) updateFontSize;
  final String name;
  final String email;
  final String location;
  final String address;
  final String profileImage;
  final Function(String, String, String, String, String) updateProfile;

  CustomerDashboard({
    required this.themeColor,
    required this.updateTheme,
    required this.updateLanguage,
    required this.updateFontStyle,
    required this.updateFontSize,
    required this.name,
    required this.email,
    required this.location,
    required this.address,
    required this.profileImage,
    required this.updateProfile,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lets get to it'),
        backgroundColor: themeColor,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: themeColor,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProfilePicture(image: profileImage),
                  SizedBox(height: 10.h),
                  Text(
                    name,
                    style: TextStyle(color: Colors.white, fontSize: 22.sp),
                  ),
                  Text(
                    email,
                    style: TextStyle(color: Colors.white, fontSize: 16.sp),
                  ),
                ],
              ),
            ),
            _buildDrawerItem(Icons.info, 'Profile', () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ProfileScreen(
                          name: name,
                          email: email,
                          location: location,
                          address: address,
                          profileImage: profileImage,
                          updateProfile: updateProfile,
                        )),
              );
            }),
            _buildDrawerItem(Icons.history, 'Trusted Drivers', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );
            }),
            _buildDrawerItem(Icons.directions_car, 'Get Driver', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomeTabPage()),
              );
            }),
            _buildDrawerItem(Icons.settings, 'Settings', () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SettingsScreen(
                          themeColor: themeColor,
                          updateTheme: updateTheme,
                          updateLanguage: updateLanguage,
                          updateFontStyle: updateFontStyle,
                          updateFontSize: updateFontSize,
                        )),
              );
            }),
            _buildDrawerItem(Icons.logout, 'Logout', () {
              Navigator.pushReplacementNamed(context, '/login');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Logout successful')),
              );
            }),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(15.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileSection(),
            SizedBox(height: 20.h),
            _buildSectionTitle('Recent Orders'),
            SizedBox(height: 10.h),
            // _buildRecentOrdersList(),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap,
    );
  }

  Widget _buildProfileSection() {
    return Row(
      children: [
        ProfilePicture(image: profileImage),
        SizedBox(width: 15.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold),
            ),
            Text(
              email,
              style: TextStyle(fontSize: 16.sp, color: Colors.grey),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
    );
  }
}
