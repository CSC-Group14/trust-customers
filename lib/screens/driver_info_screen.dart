import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class DriverInfoScreen extends StatelessWidget {
  
  final List<Map<String, dynamic>> drivers = [
    {
      'name': 'Kashara Alvin',
      'contact': '0706576928',
      'location': 'Downtown',
      'vehicleType': 'Truck',
      'rating': 4.5
    },
    {
      'name': 'Bob kabogere',
      'contact': '098-765-4321',
      'location': 'Uptown',
      'vehicleType': 'Van',
      'rating': 4.0
    },
    {
      'name': 'Charlie agaba',
      'contact': '070-555-5555',
      'location': 'Midtown',
      'vehicleType': 'Bike',
      'rating': 5.0
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Available Drivers'),
        backgroundColor: Colors.grey,
      ),
      body: ListView.builder(
        
        padding: EdgeInsets.all(10),
        itemCount: drivers.length,
        itemBuilder: (context, index) {
          final driver = drivers[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 10),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    driver['name'],
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text('Contact: ${driver['contact']}'),
                  Text('Location: ${driver['location']}'),
                  Text('Vehicle Type: ${driver['vehicleType']}'),
                  SizedBox(height: 5),
                  RatingBarIndicator(
                    rating: driver['rating'],
                    itemBuilder: (context, index) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    itemCount: 5,
                    itemSize: 20.0,
                    direction: Axis.horizontal,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
