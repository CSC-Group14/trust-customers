// ignore_for_file: unused_local_variable

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smooth_star_rating_nsafe/smooth_star_rating.dart';
import 'package:logitrust_drivers/assistants/assistant_methods.dart';
import 'package:logitrust_drivers/global/global.dart';

class SelectActiveDriverScreen extends StatefulWidget {
  static DatabaseReference? referenceRideRequest;

  @override
  State<SelectActiveDriverScreen> createState() =>
      _SelectActiveDriverScreenState();
}

class _SelectActiveDriverScreenState extends State<SelectActiveDriverScreen> {
  double? fareAmount;

  double? getFareAmountAccordingToVehicleType(int index) {
    if (tripDirectionDetailsInfo == null) {
      return 0.0;
    }

    String vehicleType =
        driversList[index]["carDetails"]?["carType"] ?? "default";
    fareAmount = AssistantMethods.calculateFareAmountFromSourceToDestination(
        tripDirectionDetailsInfo!, vehicleType);
    return fareAmount;
  }

  

  void requestRide() async {
    if (chosenDriverId.isNotEmpty) {
      // Send notification using OneSignal
      await sendNotificationToDriver(chosenDriverId, currentUserInfo?.name ?? "User");
      print("Ride request sent for driver ID: $chosenDriverId");
    } else {
      print("No driver selected.");
    }
  }

  Future<void> sendNotificationToDriver(String driverId, String userName) async {
    try {
      // Fetch the driver's OneSignal player ID (assuming you store it in your database)
      DatabaseReference driverRef = FirebaseDatabase.instance.ref().child('Drivers').child(driverId);

      DataSnapshot driverSnapshot = await driverRef.get();

      if (driverSnapshot.exists) {
        Map<String, dynamic> driverData = driverSnapshot.value as Map<String, dynamic>;
        String? playerId = driverData["onesignalPlayerId"]; // Use the correct field name

        if (playerId != null) {
          print("Driver's OneSignal Player ID: $playerId");

          // Fetch the latest ride request ID from the database
          DatabaseReference rideRequestRef = FirebaseDatabase.instance.ref().child('AllRideRequests');

          DatabaseEvent rideRequestEvent = await rideRequestRef.orderByKey().limitToLast(1).once();
          DataSnapshot rideRequestSnapshot = rideRequestEvent.snapshot;

          if (rideRequestSnapshot.exists) {
            Map<String, dynamic> rideRequestData = rideRequestSnapshot.value as Map<String, dynamic>;
            String? rideRequestId = rideRequestSnapshot.key;

            print("Ride Request ID: $rideRequestId");

            // Define the payload for the notification
            final message = {
              "app_id": "c23509de-1134-4a59-a802-3d5e133d16cf", // Replace with your OneSignal App ID
              "include_player_ids": [playerId],
              "headings": {"en": "New Ride Request"},
              "contents": {"en": "You have a new ride request from $userName"},
              "data": {"rideRequestId": rideRequestId ?? ""}
            };

            // Send the notification using the OneSignal API
            final response = await http.post(
              Uri.parse('https://onesignal.com/api/v1/notifications'),
              headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Basic ZDQ0NGEzNzctMzVjZC00OTc2LWE4ZmUtNDUzNTQxOWUwNzQ5', // Replace with your REST API key
              },
              body: jsonEncode(message),
            );

            if (response.statusCode == 200) {
              print("Notification sent successfully. Response: ${response.body}");
            } else {
              print("Failed to send notification. Status Code: ${response.statusCode}, Response: ${response.body}");
            }
          } else {
            print("No ride requests found.");
          }
        } else {
          print("Driver does not have a OneSignal Player ID.");
        }
      } else {
        print("Driver not found in the database.");
      }
    } catch (e) {
      print("Error sending notification: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Select Nearest Driver",
          style: TextStyle(fontSize: 18),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.close,
            color: Colors.black,
          ),
          onPressed: () {
            // Remove ride request from Database
            SelectActiveDriverScreen.referenceRideRequest?.remove();
            Fluttertoast.showToast(msg: "You have cancelled the ride request");
            SystemNavigator.pop();
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: driversList.length,
              itemBuilder: (BuildContext context, int index) {
                var driver = driversList[index];

                if (driver == null) {
                  return Container();
                }

                var carDetails = driver["carDetails"];
                var carType = carDetails != null
                    ? carDetails["carType"] ?? "Unknown Type"
                    : "Unknown Type";
                var carImagePath = "images/$carType.png";

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      chosenDriverId = driver["id"].toString();
                    });

                    print("Chosen driver ID: $chosenDriverId");

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Driver Chosen"),
                      ),
                    );
                  },
                  child: Card(
                    color: Colors.white,
                    elevation: 3,
                    shadowColor: Colors.black,
                    margin: const EdgeInsets.all(8),
                    child: ListTile(
                      leading: Padding(
                        padding: const EdgeInsets.only(top: 2.0),
                        child: Image.asset(
                          carImagePath,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset("images/Unknown Type.png");
                          },
                        ),
                      ),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            driver["name"] ?? "No Name",
                            style: const TextStyle(
                                fontSize: 14, color: Colors.black),
                          ),
                          Text(
                            carType,
                            style: const TextStyle(
                                fontSize: 14, color: Colors.black),
                          ),
                          SmoothStarRating(
                            rating: driver["ratings"] == null
                                ? 0.0
                                : double.tryParse(driver["ratings"] ?? "0.0") ??
                                    0.0,
                            allowHalfRating: true,
                            starCount: 5,
                            size: 15.0,
                            color: Colors.black,
                            borderColor: Colors.black,
                          ),
                        ],
                      ),
                      trailing: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "Tk ${getFareAmountAccordingToVehicleType(index) ?? '0.0'}",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            tripDirectionDetailsInfo?.duration_text ?? "",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            tripDirectionDetailsInfo?.distance_text ?? "",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: requestRide,
              child: const Text("Request Ride"),
            ),
          ),
        ],
      ),
    );
  }
}
