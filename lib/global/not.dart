import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> setupFirebaseMessaging() async {
    // Request permissions for iOS
    await _firebaseMessaging.requestPermission();

    // Get the device token
    String? token = await _firebaseMessaging.getToken();
    print('Device Token: $token');

    if (token != null) {
      // Send the token to your server
      await sendTokenToServer(token);
    }
  }

  Future<void> sendTokenToServer(String token) async {
    final response = await http.post(
      Uri.parse('https://your-server-endpoint/save-device-token'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'token': token}),
    );

    if (response.statusCode == 200) {
      print('Token sent to server successfully.');
    } else {
      print('Failed to send token to server. Status code: ${response.statusCode}');
    }
  }
}
