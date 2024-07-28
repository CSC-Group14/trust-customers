import 'package:cloud_firestore/cloud_firestore.dart';

class Trip {
  final String id;
  final String driverName;
  final String pickupLocation;
  final String dropoffLocation;
  final DateTime timestamp;

  Trip({
    required this.id,
    required this.driverName,
    required this.pickupLocation,
    required this.dropoffLocation,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'driverName': driverName,
      'pickupLocation': pickupLocation,
      'dropoffLocation': dropoffLocation,
      'timestamp': timestamp,
    };
  }

  factory Trip.fromMap(Map<String, dynamic> map) {
    return Trip(
      id: map['id'],
      driverName: map['driverName'],
      pickupLocation: map['pickupLocation'],
      dropoffLocation: map['dropoffLocation'],
      timestamp: (map['timestamp'] as Timestamp).toDate(),
    );
  }
}
