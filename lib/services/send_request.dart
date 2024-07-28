import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RequestRideScreen extends StatefulWidget {
  @override
  _RequestRideScreenState createState() => _RequestRideScreenState();
}

class _RequestRideScreenState extends State<RequestRideScreen> {
  final TextEditingController _destinationController = TextEditingController();
  User? user = FirebaseAuth.instance.currentUser;

  void sendRideRequest() async {
    String destination = _destinationController.text;
    if (destination.isNotEmpty && user != null) {
      await FirebaseFirestore.instance.collection('rideRequests').add({
        'userId': user!.uid,
        'userName': user!.displayName ?? 'Unknown',
        'destination': destination,
        'status': 'pending',
        'timestamp': FieldValue.serverTimestamp(),
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ride request sent')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Request Ride'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _destinationController,
              decoration: InputDecoration(labelText: 'Enter Destination'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: sendRideRequest,
              child: Text('Request Ride'),
            ),
          ],
        ),
      ),
    );
  }
}
