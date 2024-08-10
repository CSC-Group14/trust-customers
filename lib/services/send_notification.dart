import 'package:firebase_database/firebase_database.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<void> notifyDriverAboutRideRequest(
    String driverId, String rideRequestId) async {
  try {
    DatabaseReference driverRef =
        FirebaseDatabase.instance.ref().child('Drivers').child(driverId);

    DataSnapshot snapshot = await driverRef.get();
    if (snapshot.exists) {
      Map<String, dynamic> driverData = snapshot.value as Map<String, dynamic>;
      String? deviceToken = driverData['deviceToken'];

      if (deviceToken != null) {
        await sendRideRequestNotification(deviceToken, rideRequestId);
      } else {
        print("Driver does not have a device token.");
      }
    } else {
      print("Driver not found in the database.");
    }
  } catch (e) {
    print("Error fetching driver data: $e");
  }
}

Future<void> sendRideRequestNotification(
    String driverToken, String rideRequestId) async {
  const String serverKey =
      "90e9b6631f10511812b831ac0b78290d6783e550"; // Your FCM server key

  final Uri url =
      Uri.parse("https://fcm.googleapis.com/fcm/send"); // Convert String to Uri
  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'key=$serverKey',
  };

  final body = jsonEncode({
    "to": driverToken,
    "notification": {
      "title": "New Ride Request",
      "body": "You have a new ride request. Check your app.",
    },
    "data": {
      "rideRequestId": rideRequestId,
    },
  });

  final response = await http.post(url, headers: headers, body: body);

  if (response.statusCode == 200) {
    print("Notification sent successfully.");
  } else {
    print("Failed to send notification.");
    print(
        "Response body: ${response.body}"); // Optional: print response body for debugging
  }
}
