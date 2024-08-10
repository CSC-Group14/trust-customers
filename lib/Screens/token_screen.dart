import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class TokenScreen extends StatefulWidget {
  @override
  _TokenScreenState createState() => _TokenScreenState();
}

class _TokenScreenState extends State<TokenScreen> {
  String? _deviceToken;

  @override
  void initState() {
    super.initState();
    _getDeviceToken();
  }

  Future<void> _getDeviceToken() async {
    try {
      String? token = await FirebaseMessaging.instance.getToken();
      setState(() {
        _deviceToken = token;
      });
      if (token != null) {
        print("Device Token: $token");
      } else {
        print("Failed to get device token.");
      }
    } catch (e) {
      print("Error getting device token: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FCM Device Token'),
      ),
      body: Center(
        child: _deviceToken == null
            ? CircularProgressIndicator()
            : Text('Device Token: $_deviceToken'),
      ),
    );
  }
}
