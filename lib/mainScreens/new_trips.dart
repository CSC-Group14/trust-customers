import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:location/location.dart';

class TripScreen extends StatefulWidget {
  final String rideRequestId; // Accept ride request ID as a parameter

  TripScreen({required this.rideRequestId});

  @override
  _TripScreenState createState() => _TripScreenState();
}

class _TripScreenState extends State<TripScreen> {
  final DatabaseReference _rideRequestRef =
      FirebaseDatabase.instance.ref('AllRideRequests');
  final Location _location = Location();
  late LocationData _currentLocation;
  bool _locationServiceEnabled = false;
  GoogleMapController? _mapController;
  LatLng? _driverLocation;
  String _driverName = '';
  String _driverPhone = '';
  String _driverImageUrl = '';
  Set<Marker> _markers = Set<Marker>();
  Set<Polyline> _polylines = Set<Polyline>();
  String _statusMessage = '';

  @override
  void initState() {
    super.initState();
    _checkLocationServices();
    _getCurrentLocation();
    _listenForRideRequest(widget.rideRequestId);
  }

  Future<void> _checkLocationServices() async {
    _locationServiceEnabled = await _location.serviceEnabled();
    if (!_locationServiceEnabled) {
      _locationServiceEnabled = await _location.requestService();
      if (!_locationServiceEnabled) {
        print('Location services are disabled');
      }
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      final permissionStatus = await _location.hasPermission();
      if (permissionStatus == PermissionStatus.denied) {
        await _location.requestPermission();
      }

      _currentLocation = await _location.getLocation();
      if (_currentLocation != null && _mapController != null) {
        _mapController!.animateCamera(
          CameraUpdate.newLatLng(
            LatLng(_currentLocation.latitude!, _currentLocation.longitude!),
          ),
        );
        _updateMap(); // Update map to draw polyline with current location
      }
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  void _listenForRideRequest(String rideRequestId) {
    _rideRequestRef.child(rideRequestId).onValue.listen((DatabaseEvent event) {
      if (event.snapshot.value == null) return;

      final requestData =
          Map<String, dynamic>.from(event.snapshot.value as Map);
      final driverLat =
          double.tryParse(requestData['driverLocationData']['latitude'] ?? '');
      final driverLng =
          double.tryParse(requestData['driverLocationData']['longitude'] ?? '');

      if (driverLat != null && driverLng != null) {
        setState(() {
          _driverLocation = LatLng(driverLat, driverLng);
          _driverName = requestData['driverName'] ?? 'Unknown Driver';
          _driverPhone = requestData['driverPhone'] ?? 'Unknown Phone';
          _driverImageUrl = requestData['driverImageUrl'] ??
              'https://example.com/default_image.jpg';
          _updateStatusMessage(requestData['driverStatus'] ?? '');

          _updateMap();
        });
      }
    });
  }

  void _updateStatusMessage(String status) {
    switch (status) {
      case 'Accepted':
        _statusMessage = 'Your Driver is Coming';
        break;
      case 'Arrived':
        _statusMessage = 'Your Driver has Arrived';
        break;
      case 'On Trip':
        _statusMessage = 'The Trip is going On';
        break;
      case 'Ended':
        _statusMessage = 'The Trip has Ended. Please Pay';
        break;
      default:
        _statusMessage = '';
    }
  }

  void _updateMap() {
    if (_mapController != null && _driverLocation != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLng(
          _driverLocation!,
        ),
      );

      setState(() {
        _markers.clear(); // Clear previous markers
        _markers.add(
          Marker(
            markerId: MarkerId('driver'),
            position: _driverLocation!,
            infoWindow: InfoWindow(
              title: _driverName,
              snippet: _driverPhone,
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueAzure),
          ),
        );

        // Add a polyline between current location and driver location
        if (_currentLocation != null) {
          _polylines.clear(); // Clear previous polylines
          _polylines.add(
            Polyline(
              polylineId: PolylineId('route'),
              visible: true,
              points: [
                LatLng(_currentLocation.latitude!, _currentLocation.longitude!),
                _driverLocation!,
              ],
              color: Colors.blue,
              width: 5,
            ),
          );
        }
      });
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    if (_currentLocation != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLng(
          LatLng(_currentLocation.latitude!, _currentLocation.longitude!),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trip Screen'),
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: LatLng(51.5, -0.09), // Default initial position
              zoom: 13.0,
            ),
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            markers: _markers,
            polylines: _polylines, // Add polylines to the map
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.0),
                  topRight: Radius.circular(16.0),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8.0,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center, // Center align
                children: [
                  if (_statusMessage.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        _statusMessage,
                        textAlign: TextAlign.center, // Center align text
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18, // Medium size
                          color: Colors.green, // Green color
                        ),
                      ),
                    ),
                  Divider(height: 1.0, color: Colors.grey[300]),
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(_driverImageUrl),
                        radius: 30,
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _driverName,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            Text(
                              _driverPhone,
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.phone),
                        onPressed: () => _makePhoneCall(_driverPhone),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _makePhoneCall(String phoneNumber) async {
    final Uri phoneUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunch(phoneUri.toString())) {
      await launch(phoneUri.toString());
    } else {
      print('Could not launch $phoneUri');
    }
  }
}
