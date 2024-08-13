import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../mainScreens/profile_screen.dart';
import 'about_us_page.dart'; // Import the AboutUsPage
import 'dart:io'; // Import the dart:io library for File class

class DashboardDrawer extends StatefulWidget {
  final String? name;

  DashboardDrawer({this.name});

  @override
  State<DashboardDrawer> createState() => _DashboardDrawerState();
}

class _DashboardDrawerState extends State<DashboardDrawer> {
  String? _imageUrl;
  String? _userName;
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _imageUrl = prefs.getString('profileImageUrl');
      _userName = prefs.getString('name') ?? widget.name ?? 'User';
      if (_imageUrl != null && _imageUrl!.isNotEmpty) {
        _imageFile = File(_imageUrl!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Container(
            height: 165,
            color: Colors.black,
            child: DrawerHeader(
              decoration: const BoxDecoration(color: Colors.black),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey[200],
                    backgroundImage:
                        _imageFile != null ? FileImage(_imageFile!) : null,
                    child: _imageFile == null
                        ? const Icon(
                            Icons.person,
                            size: 80,
                            color: Colors.white,
                          )
                        : null,
                  ),
                  const SizedBox(width: 16),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _userName ?? 'User',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () async {
              // Navigate to ProfileScreen and refresh drawer on return
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );

              // Refresh data if profile was edited
              if (result == true) {
                _fetchUserData();
              }
            },
            child: const ListTile(
              leading: Icon(Icons.person, color: Colors.black),
              title: Text(
                "Profile",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              // Navigate to the About Us page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AboutUsPage()),
              );
            },
            child: const ListTile(
              leading: Icon(Icons.info, color: Colors.black),
              title: Text(
                "About Us",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              // Sign out
              Navigator.pushNamed(context, '/login_screen');
            },
            child: const ListTile(
              leading: Icon(Icons.logout, color: Colors.black),
              title: Text(
                "Sign Out",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
