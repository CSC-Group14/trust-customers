import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Trip Model
class Trip {
  final String id;
  final String driverName;
  final String pickupLocation;
  final String dropoffLocation;
  final DateTime timestamp;
  final double fare;

  Trip({
    required this.id,
    required this.driverName,
    required this.pickupLocation,
    required this.dropoffLocation,
    required this.timestamp,
    required this.fare,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'driverName': driverName,
      'pickupLocation': pickupLocation,
      'dropoffLocation': dropoffLocation,
      'timestamp': timestamp,
      'fare': fare,
    };
  }

  factory Trip.fromMap(Map<String, dynamic> map) {
    return Trip(
      id: map['id'],
      driverName: map['driverName'],
      pickupLocation: map['pickupLocation'],
      dropoffLocation: map['dropoffLocation'],
      timestamp: (map['timestamp'] as Timestamp).toDate(),
      fare: map['fare'],
    );
  }
}

// Trip Service
class TripService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> addTrip(Trip trip) async {
    final user = _auth.currentUser;
    if (user != null) {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('trips')
          .add(trip.toMap());
    }
  }

  Stream<List<Trip>> getTripHistory() {
    final user = _auth.currentUser;
    if (user != null) {
      return _firestore
          .collection('users')
          .doc(user.uid)
          .collection('trips')
          .orderBy('timestamp', descending: true)
          .snapshots()
          .map((snapshot) =>
              snapshot.docs.map((doc) => Trip.fromMap(doc.data())).toList());
    } else {
      return Stream.value([]);
    }
  }
}

// Trip History Screen
class TripHistoryScreen extends StatelessWidget {
  final TripService _tripService = TripService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trip History'),
      ),
      body: StreamBuilder<List<Trip>>(
        stream: _tripService.getTripHistory(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No trips found.'));
          }
          final trips = snapshot.data!;
          return ListView.builder(
            itemCount: trips.length,
            itemBuilder: (context, index) {
              final trip = trips[index];
              return ListTile(
                title:
                    Text('${trip.pickupLocation} to ${trip.dropoffLocation}'),
                subtitle: Text('Driver: ${trip.driverName}'),
                trailing: Text('\$${trip.fare.toStringAsFixed(2)}'),
                onTap: () {
                  // Add any action on tap if necessary
                },
              );
            },
          );
        },
      ),
    );
  }
}
