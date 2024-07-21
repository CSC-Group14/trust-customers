import 'package:flutter/material.dart';
import 'profile_screen.dart';
import 'profile_picture.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String _profileImage = 'https://example.com/default_image.jpg';

  void _updateProfile(String name, String email, String location, String address, String profileImage) {
    setState(() {
      _profileImage = profileImage;
    });
  }

  Future<void> _navigateToProfileScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileScreen(
          name: 'User Name',
          email: 'user@example.com',
          location: 'User Location',
          address: 'User Address',
          profileImage: _profileImage,
          updateProfile: _updateProfile,
        ),
      ),
    );

    if (result != null && result is String) {
      setState(() {
        _profileImage = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main Screen'),
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: _navigateToProfileScreen,
          ),
        ],
      ),
      body: Center(
        child: ProfilePicture(image: _profileImage),
      ),
    );
  }
}
