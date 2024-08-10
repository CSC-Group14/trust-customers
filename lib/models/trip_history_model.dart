import 'package:firebase_database/firebase_database.dart';

class TripHistoryModel {
  String? time;
  String? sourceAddress;
  String? destinationAddress;
  String? carNumber;
  String? carModel;
  String? driverName;
  String? fareAmount;
  String? status;

  TripHistoryModel({
    this.time,
    this.sourceAddress,
    this.destinationAddress,
    this.carNumber,
    this.carModel,
    this.driverName,
    this.fareAmount,
    this.status,
  });

  TripHistoryModel.fromSnapshot(DataSnapshot snapshot) {
    final data = snapshot.value as Map?;
    if (data != null) {
      time = data["time"]?.toString();
      sourceAddress = data["sourceAddress"]?.toString();
      destinationAddress = data["destinationAddress"]?.toString();

      final carDetails = data["carDetails"] as Map?;
      if (carDetails != null) {
        carNumber = carDetails["carNumber"]?.toString();
        carModel = carDetails["carModel"]?.toString();
      } else {
        print("Error: 'carDetails' map is null in the snapshot.");
      }

      driverName = data["driverName"]?.toString();
      fareAmount = data["fareAmount"]?.toString();
      status = data["status"]?.toString();
    } else {
      print("Error: Snapshot value is null or not a Map.");
    }
  }
}
