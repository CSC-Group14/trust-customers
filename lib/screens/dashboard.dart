import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trust/screens/profile_picture.dart';
import 'package:trust/screens/profile_screen.dart';
import 'package:trust/screens/settings_screen.dart';
import 'package:trust/screens/map_screen.dart';
import 'package:trust/services/send_request.dart';
import 'package:trust/services/trip_history.dart';

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
        title: Text('Welcome Back', semanticsLabel: name),
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
            _buildDrawerItem(Icons.history, 'Trip History', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TripHistoryScreen()),
              );
            }),
            _buildDrawerItem(Icons.directions_car, 'Get Driver', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MapScreen()),
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
            _buildServiceButtons(context),
            SizedBox(height: 200.h),
            _buildFooter(),
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

  Widget _buildServiceButtons(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10.h),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.w),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          padding: EdgeInsets.all(10.h),
          child: Text(
            'Your Trusted Partner in Logistics. '
            'Experience seamless and efficient logistics services with LogiTrust. '
            'From small parcels to large shipments, we ensure timely, safe, and hassle-free deliveries. '
            'Track your shipments in real-time and manage your logistics effortlessly with our app.',
            style: TextStyle(color: Colors.black),
          ),
        ),
        SizedBox(height: 30.h),
        Text(
          'Our Services',
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MapScreen()),
                  );
                },
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/smalltruck.png',
                      fit: BoxFit.contain,
                      height: 60.h,
                    ),
                    SizedBox(height: 5.h),
                    Text('Small Truck'),
                  ],
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MapScreen()),
                  );
                },
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/mediumtruck.jpg',
                      fit: BoxFit.contain,
                      height: 60.h,
                    ),
                    SizedBox(height: 5.h),
                    Text('Medium Truck'),
                  ],
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MapScreen()),
                  );
                },
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/bigtruck.jpg',
                      fit: BoxFit.contain,
                      height: 60.h,
                    ),
                    SizedBox(height: 5.h),
                    Text('Big Truck'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: EdgeInsets.all(15.w),
      color: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Contact Us:',
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5.h),
          Text(
            'For more information please contact us:',
            style: TextStyle(fontSize: 16.sp),
          ),
          SizedBox(height: 5.h),
          Text(
            'Contact: 003-456-7890\n'
            'Email: logitrust@domain.com',
            style: TextStyle(fontSize: 16.sp, color: Colors.blue),
          ),
        ],
      ),
    );
  }
}
