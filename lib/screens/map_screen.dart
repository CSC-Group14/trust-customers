import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

const CameraPosition googlePlexInitialPosition = CameraPosition(
  target: LatLng(0.3476, 32.5825), // Kampala, Uganda
  zoom: 14.4746,
);

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? googleMapController;
  final Set<Polyline> _polylines = {};
  List<LatLng> polylineCoordinates = [];

  Location location = Location();
  LocationData? currentLocation;
  StreamSubscription<LocationData>? locationSubscription;
  bool isLoading = true;
  final TextEditingController _destinationController = TextEditingController();
  User? user = FirebaseAuth.instance.currentUser;
  String? rideRequestId;
  String status = 'pending';
  Set<Marker> _markers = {};
  List<String> _placeSuggestions = [];

  @override
  void initState() {
    super.initState();
    _initializeLocation();
    _handleRideRequestUpdates();
    listenToDrivers();

    _destinationController.addListener(() {
      _fetchPlaceSuggestions(_destinationController.text);
    });
  }

  @override
  void dispose() {
    locationSubscription?.cancel();
    _destinationController.dispose();
    super.dispose();
  }

  Future<void> _initializeLocation() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    // Get initial location
    currentLocation = await location.getLocation();
    _moveCameraToLocation(currentLocation);
    _updateMarker(
      'current_location',
      LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
      color: Colors.red, // Set the color to red for current location
    );

    // Listen to location changes
    locationSubscription =
        location.onLocationChanged.listen((LocationData locData) {
      setState(() {
        currentLocation = locData;
        _moveCameraToLocation(currentLocation);
        _updateMarker(
          'current_location',
          LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
          color: Colors.red, // Set the color to red for current location
        );
      });
    });

    setState(() {
      isLoading = false;
    });
  }

  void _moveCameraToLocation(LocationData? locationData) {
    if (locationData != null && googleMapController != null) {
      googleMapController!.animateCamera(
        CameraUpdate.newLatLng(
          LatLng(locationData.latitude!, locationData.longitude!),
        ),
      );
    }
  }

  void listenToDrivers() {
    FirebaseFirestore.instance.collection('Drivers').snapshots().listen(
        (snapshot) {
      for (var doc in snapshot.docs) {
        var data = doc.data();
        try {
          if (data['driverStatus'] == 'Idle') {
            GeoPoint driverLocation = data['driverLoc'];
            _updateMarker(
              data['name'],
              LatLng(driverLocation.latitude, driverLocation.longitude),
            );
          }
        } catch (e) {
          print('Error processing driver data: $e');
        }
      }
    }, onError: (error) {
      print('Error fetching driver data: $error');
    });
  }

  void _updateMarker(String id, LatLng position, {Color color = Colors.blue}) {
    final marker = Marker(
      markerId: MarkerId(id),
      position: position,
      infoWindow: InfoWindow(title: id),
      icon: BitmapDescriptor.defaultMarkerWithHue(
        color == Colors.green
            ? BitmapDescriptor.hueGreen
            : color == Colors.red
                ? BitmapDescriptor.hueRed
                : BitmapDescriptor.hueAzure,
      ),
    );

    setState(() {
      _markers.removeWhere((marker) => marker.markerId.value == id);
      _markers.add(marker);
    });
  }

  void _showRideRequestSheet(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 16.0,
                right: 16.0,
                top: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _destinationController,
                  decoration: InputDecoration(labelText: 'Enter Destination'),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: _placeSuggestions.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(_placeSuggestions[index]),
                      onTap: () {
                        _destinationController.text = _placeSuggestions[index];
                        _placeSuggestions.clear();
                        setState(() {});
                      },
                    );
                  },
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
      },
    );
  }

  Future<void> sendRideRequest() async {
    String destination = _destinationController.text;
    if (destination.isNotEmpty && user != null) {
      DocumentReference rideRequest =
          await FirebaseFirestore.instance.collection('rideRequests').add({
        'userId': user!.uid,
        'userName': user!.displayName ?? 'Unknown',
        'userLocation':
            GeoPoint(currentLocation!.latitude!, currentLocation!.longitude!),
        'destination': destination,
        'status': 'pending',
        'timestamp': FieldValue.serverTimestamp(),
      });
      rideRequestId = rideRequest.id;
      Navigator.pop(context); // Close the bottom sheet
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ride request sent')),
      );

      // Fetch and display the route to the destination
      await _fetchRoute(destination);
    }
  }

  Future<void> _fetchRoute(String destination) async {
    if (currentLocation == null) return;

    final origin = '${currentLocation!.latitude},${currentLocation!.longitude}';
    final url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$destination&key=AIzaSyAnsK0I2lw7YP3qhUthMBtlsiJ31WVkPrY';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['routes'].isNotEmpty) {
        final route = data['routes'][0];
        final polyline = route['overview_polyline']['points'];
        final polylineCoordinates = _decodePolyline(polyline);

        setState(() {
          _polylines.clear();
          _polylines.add(Polyline(
            polylineId: const PolylineId('route'),
            points: polylineCoordinates,
            color: Colors.blue,
            width: 5,
          ));

          // Update destination marker
          final destinationLatLng = LatLng(
            data['routes'][0]['legs'][0]['end_location']['lat'],
            data['routes'][0]['legs'][0]['end_location']['lng'],
          );
          _updateMarker('destination', destinationLatLng, color: Colors.green);
        });
      }
    }
  }

  List<LatLng> _decodePolyline(String polyline) {
    List<LatLng> coordinates = [];
    int index = 0, len = polyline.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = polyline.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = polyline.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      coordinates.add(LatLng(lat / 1E5, lng / 1E5));
    }

    return coordinates;
  }

  void _fetchPlaceSuggestions(String input) async {
    if (input.isEmpty) {
      setState(() {
        _placeSuggestions.clear();
      });
      return;
    }

    final url =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&components=country:ug&key=AIzaSyAnsK0I2lw7YP3qhUthMBtlsiJ31WVkPrY';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final suggestions = data['predictions'] as List<dynamic>;
      setState(() {
        _placeSuggestions = suggestions.map((suggestion) {
          return suggestion['description'] as String;
        }).toList();
      });
    }
  }

  void _handleRideRequestUpdates() {
    if (user != null) {
      FirebaseFirestore.instance
          .collection('rideRequests')
          .where('userId', isEqualTo: user!.uid)
          .snapshots()
          .listen((querySnapshot) {
        for (var doc in querySnapshot.docs) {
          setState(() {
            status = doc['status'];
            if (status == 'Accepted') {
              String driverId = doc[
                  'driverId']; // Assuming driverId is stored in ride request
              _fetchDriverDetails(driverId);
            } else if (status == 'Calleced') {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Try again in 2 mins')),
              );
            }
          });
        }
      });
    }
  }

  Future<void> _fetchDriverDetails(String driverId) async {
    try {
      DocumentSnapshot driverDoc = await FirebaseFirestore.instance
          .collection('Drivers')
          .doc(driverId)
          .get();

      if (driverDoc.exists) {
        String driverName = driverDoc['name'];
        String truckPlateNum = driverDoc['Truck_Plate_Num'];
        String contact = driverDoc['Contact'];

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Ride request accepted by $driverName\nTruck Plate Number: $truckPlateNum\nContact: $contact')),
        );
      }
    } catch (e) {
      print('Error fetching driver details: $e');
    }
  }

  void updateRideStatus(String newStatus, String name) {
    if (rideRequestId != null) {
      FirebaseFirestore.instance
          .collection('rideRequests')
          .doc(rideRequestId)
          .update({
        'status': newStatus,
        'name': name,
      });
    }
  }

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double p = 0.017453292519943295; // Math.PI / 180
    final double a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a)); // 2 * R; R = 6371 km
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Maps'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: googlePlexInitialPosition,
                  polylines: _polylines,
                  markers: _markers,
                  onMapCreated: (GoogleMapController controller) {
                    googleMapController = controller;
                    if (currentLocation != null) {
                      _moveCameraToLocation(currentLocation);
                    }
                  },
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: FloatingActionButton(
                      onPressed: () => _moveCameraToLocation(currentLocation),
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      child: const Icon(Icons.my_location, color: Colors.black),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: FloatingActionButton(
                      backgroundColor: Colors.green,
                      onPressed: () => _showRideRequestSheet(context),
                      child: const Icon(Icons.directions, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
